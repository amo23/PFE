<%Server.ScriptTimeout = 7200%>
<!--#include file="incSystem.asp" -->
<%lvl=validate(1)

set conn=server.createobject("ADODB.Connection")
conn.open connection
categoryid=request("categoryid")
if categoryid="" or not(isnumeric(categoryid)) then categoryid=0
counter=request("counter")
if counter="" then counter=0

psql="select top 1 categoryid,catpath,catname from xlaAIGcategories where categoryid>"&categoryid&" order by categoryid"
set rs=conn.execute(psql)
if rs.eof then
	rs.close
	set rs=nothing
	conn.close
	set conn=nothing
	response.redirect "buildindexend.asp"
end if
catname=rs("catname")
catpath=rs("catpath")
categoryid=rs("categoryid")
rs.close
set rs=nothing
totalfiles=0
psql="SELECT count(imageid) as totalfiles from xlaAIGimages where status=1 and categoryid in (select categoryid from xlaAIGcategories where catpath like '"&replace(catpath,"'","''")&"%')"
set rs=conn.execute(psql)
if not(rs.eof) then totalfiles=rs("totalfiles")
rs.close
set rs=nothing

psql="update xlaAIGcategories set images="&totalfiles&" where categoryid="&categoryid
conn.execute(psql)
conn.close
set conn=nothing
counter=counter+1
if counter<7 then response.redirect "buildindex4.asp?categoryid="&categoryid&"&counter="&counter

%>
<html>
<head>
<title><%=title%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body bgcolor="#FFFFFF">
<table width="100%" border="0" cellspacing="2" cellpadding="2" height="100%">
  <tr>
    <td align="center" valign="middle"><font face="Arial, Helvetica, sans-serif" size="2" color="#000099"><b><font color="#000066">Summarizing <%=catname%>
      </font></b></font></td>
  </tr>
</table>
<meta http-equiv="refresh" content="0;URL=buildindex4.asp?categoryid=<%=categoryid%>">
</body>
</html>




