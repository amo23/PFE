<!-- #include file="incSystem.asp" -->
<%
lvl=validate(0)

'//// Update Expired Articles ////
psql="update articles set status=3 where enddate<'"&todaydate&"' and enddate<>'-' and status=1"
set conn=server.createobject("ADODB.Connection")
conn.open connection
conn.execute(psql)

'//// Archive Articles ////
if archiveenabled<>"" then call archivenow("")

conn.close
set conn=nothing

call getconnection()
%>
<html>
<head>
<title><%=title%></title>
<meta http-equiv="Content-Type" content="text/html; charset=<%=charset%>">
</head>

<frameset rows="80,*" frameborder="NO" border="0" framespacing="0" cols="*"> 
  <frame name="topmenu" scrolling="NO" noresize src="topmenu.asp" >
  <frame name="main" src="search.asp">
</frameset>
<noframes><body bgcolor="#FFFFFF" text="#000000">

</body></noframes>
</html>

