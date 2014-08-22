<!--#include file="incSystem.asp" -->
<%
zoneid=request("z")
lastdate=dateadd("d",now,-rssdays)
lastdate=year(lastdate)&"/"&right("0"&month(lastdate),2)&"/"&right("0"&day(lastdate),2)

function enc(what)
	enc=server.htmlencode(what & "")
end function

function getlink(articleid)
	getlink=applicationurl & "anmviewer.asp?a=" & articleid
	if zoneid<>"" then getlink=getlink & "&z=" & zoneid
end function

psql="select * from articles where status=1 and enddate>='" & lasdate &"' "
if zoneid<>"" and isnumeric(zoneid) then psql=psql & " and articleid in (select articleid from iArticlesZones where zoneid=" & zoneid & ") "
psql=psql & " order by articleid asc;"

Response.contenttype = "text/xml"
'/// Must be the first line of the document
response.write "<?xml version=""1.0""?>"
set conn=server.createobject("ADODB.Connection")
conn.open connection
set rs=conn.execute(psql)
%><rss>
  <channel>
    <title><%=enc(sitename)%></title>
    <link><%=enc(siteurl)%></link>
	<%do until rs.eof%>
    <item>
      <title><%=enc(rs("headline"))%></title>
      <description><%=enc(rs("summary"))%></description>
      <link><%=enc(getlink(rs("articleid")))%></link>
    </item>
	<%rs.movenext
	loop%>
</channel>
</rss><%
rs.close
set rs=nothing
conn.close
set conn=nothing
%>