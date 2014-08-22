<!--#include file="configdata.asp"-->
<!--#include file="databasedata.asp"-->
<%
today=year(now)&"/"&right("0"&month(now),2)&"/"&right("0"&day(now),2)
response.buffer=true
zoneid=request("z")
if zoneid="" or not(isnumeric(zoneid)) then zoneid=0
font=request("font")
size=request("size")

if font="" then font="arial"
if size="" then size="2"

target=request("target")
if target<>"" then target="target='"&target&"'"

psql="select * from vArticlesZones where zoneid="&zoneid&" and status=1 and startdate<='"&today&"' and enddate>='"&today&"' order by posted desc;"
set conn=server.createobject("ADODB.Connection")
conn.open connection
%>
var newslist=new Array();
var cnt=0;			// current news item
var curr = "";
var i=-1;			// current letter being typed
newslist[0]=new Array("<%=nonewsmessage%>","");
<%
set rs=conn.execute(psql)
c=0
do until rs.eof
fontface=rs("zonefont")
fontsize=rs("fontsize")
%>
newslist[<%=c%>]=new Array("<%=rs("headline")%>","<%=applicationurl&"anmviewer.asp?a="&rs("articleid")&"&z="&zoneid%>");
<%
c=c+1
rs.movenext
loop
rs.close
set rs=nothing
conn.close
set conn=nothing
%>
function newsticker()
{
	// next character of current item
	if (i < newslist[cnt][0].length - 1)
	{
		i++;
		temp1 = newslist[cnt][0];	
		temp1 = temp1.split('');	
  		curr = curr+temp1[i];
		temp2 = newslist[cnt][1];	
  		mtxt.innerHTML = "<a href='"+temp2+"' style='text-decoration:none' <%=target%>><font size='<%=size%>' face='<%=font%>'>"+curr+"_</font></a>";
  		setTimeout('newsticker()',20)
		return;
	}

	// new item
	i = -1; curr = "";
	if (cnt<newslist.length-1)
		cnt++;
	else
		cnt=0;
	setTimeout('newsticker()',3000)

}

function document.body.onload(){
 newsticker();
}

document.write('<' + 'Span Id=mtxt style=\"position:relative;top:1px;padding:5px 5px 5px 5px;width:100%;overflow:auto;height:100%\"><\/Span>');