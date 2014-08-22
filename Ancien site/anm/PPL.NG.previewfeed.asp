<!--#include file="incSystem.asp" -->
<%
lvl=validate(1)
feedid=request("feedid")
feedname=request("feedname")
if not(isnumeric(feedid)) then feedid=0
codeline="<script language=" & chr(34) & "JavaScript"& chr(34) & " src="& chr(34) & applicationurl & "PPL.NG.feed.asp?f=" & feedid & "&target=_blank" & chr(34) & "></script>"
%>
<html>
<head>
<title><%=feedname%></title>
<meta http-equiv="Content-Type" content="text/html; charset=<%=charset%>">
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" rightmargin="0" topmargin="0" bottommargin="0">
<%=codeline%>
</body>
</html>
