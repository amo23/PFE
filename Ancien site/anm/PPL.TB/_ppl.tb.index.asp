<!--#include file="_ppl.tb.config.asp" -->
<%
articleid=0 : zoneid=0

'/// get First Article From the database
psql="select top 1 articleid,zoneid from iarticleszones order by articleid,zoneid"
set conn=server.createobject("ADODB.Connection")
conn.open connection
set rs=conn.execute(psql)
if not(rs.eof) then
	articleid=rs("articleid")
	zoneid=rs("zoneid")
end if
rs.close
set rs=nothing
conn.close
set conn=nothing

if articleid=0 then 
	response.write "No articles found"
	response.end 
end if
%>
<!--#include file="_ppl.tb.parser.asp" -->