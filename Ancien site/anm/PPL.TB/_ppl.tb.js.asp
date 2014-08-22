<%
if request.servervariables("http_referer")="" then response.end
a=request("a")
z=request("z")
targetlink="'../anmviewer.asp?a=" & a & "&z=" & z & "'"
thecode=doescape(targetlink)

function doescape(what)
	a=""
	for x=1 to len(what)
		a=a & "%" & hex(asc(mid(what,x,1))) 
	next
	doescape=a
end function

response.contenttype="text/Javascript"
response.write "b='atio';c='f.loc';e='n.hr';d='ef=';a='sel';g=a+c+b+e+d;eval(g + unescape('" & thecode & "'));"
%>


