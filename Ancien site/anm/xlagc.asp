<%
'/// Xigla Software - Content Grabber
'/// Copyright(c)2002 - XIGLA SOFTWARE
'/// http://www.xigla.com
'/// Place this include at the top of the asp file that will display the poll
'/// To retrieve the content of the poll :
'/// poll=xlaGC(URL_PATH)

function xlaGC(what)
	set xlaGChttp=server.CreateObject("Microsoft.XMLHTTP")
	if instr(what,"?")=0 then what=what & "?xlaparsing=true" else what=what & "&xlaparsing=true"
	xlaGChttp.open "GET", what, false
	xlaGChttp.send
	xlaGC=xlaGChttp.responsetext
	if left(xlagc,4)<>"<!--" then xlagc=""
	set xmlGChttp=nothing
end function
%>

