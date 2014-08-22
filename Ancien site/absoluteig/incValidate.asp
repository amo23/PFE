<%
function validate(thislevel)
	session.timeout=90
	if session("xlaAIG_usr")="" then response.redirect "logout.asp"
	validate=1
end function
%>
