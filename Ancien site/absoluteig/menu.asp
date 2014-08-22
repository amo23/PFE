<!-- #include file="incSystem.asp" -->
<%lvl=validate(1)
'//// Delete expired postcards
lastdelete=dateadd("d",-15,now)
lastdelete=year(lastdelete)&"/"&right("0"&month(lastdelete),2)&"/"&right("0"&day(lastdelete),2)
psql="delete from xlaAIGpostcards where dateposted<'"&lastdelete&"'"
set conn=server.createobject("ADODB.Connection")
conn.open connection
conn.execute(psql)
conn.close
set conn=nothing



%>
<html>
<head>
<title><%=title%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<frameset rows="71,*" frameborder="NO" border="0" framespacing="0" cols="*"> 
  <frame name="topmenu" scrolling="NO" noresize src="topmenu.asp" >
  <frame name="main" src="search.asp">
</frameset>
<noframes></noframes> 
</html>

