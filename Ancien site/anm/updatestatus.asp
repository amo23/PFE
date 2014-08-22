<!-- #include file="incSystem.asp" -->
<%
lvl=validate(1)
articleid=request("articleid")
status=request("status")
if articleid<>"" and status<>"" then
	set conn=server.createobject("ADODB.Connection")
	conn.open connection
	conn.execute("update articles set status="&status&" where articleid="&articleid)
	conn.close
	set conn=nothing
	response.redirect "images/"&whichstatus(status)&".gif"
end if
%>