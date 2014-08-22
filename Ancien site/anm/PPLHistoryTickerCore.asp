<!--#include file="configdata.asp"-->
<!--#include file="databasedata.asp"-->
<%
today=year(now)&"/"&right("0"&month(now),2)&"/"&right("0"&day(now),2)
response.buffer=true
zoneid=request("z")
h=request("h")
font=request("font")
size=request("size")
bg=request("bg")
fg=request("fg")
sp=request("sp")
if fg="" then fg="#000000"
if bg="" then bg="#FFFFFF"
if font="" then font="arial"
if size="" then size="2"
target=request("target")
if target<>"" then target="target='"&target&"'"
if sp="" or not(isnumeric(sp)) then sp=1

if zoneid="" or not(isnumeric(zoneid)) then zoneid=0
psql="select * from vArticlesZones where zoneid="&zoneid&" and status=1 and startdate<='"&today&"' and enddate>='"&today&"' order by posted desc;"
set conn=server.createobject("ADODB.Connection")
conn.open connection

set rs=conn.execute(psql)
c=0
do until rs.eof
articles=articles & "<p align=center><a href='"&applicationurl&"anmviewer.asp?a="&rs("articleid")&"&z="&zoneid&"' target=_top><b>"&rs("headline")&"</b></a><br>"&rs("headlinedate")&"<br>"&rs("summary")&"<br></p>"
rs.movenext
loop
rs.close
set rs=nothing
conn.close
set conn=nothing
%>
<body bgcolor="<%=bg%>">
<table cellpadding="2" cellspacing="0" width=100% h=100%>
  <tr>
    <td align="center" valign="top"> 
      <div align="center"><marquee behavior=scroll direction=up width=100% height=<%=h%> scrollamount=<%=sp%> scrolldelay=10 onmouseover='this.stop()' onmouseout='this.start()'> 
        <font face="<%=font%>" size="<%=size%>" color="<%=fg%>"><%=articles%></font></marquee></div>
    </td>
  </tr></table>