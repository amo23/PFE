<%
function gettnimage(articleid,align)
	align=ucase(align)
	if align<>"CENTER" then talign="align="&align
	thefile1="thumbnails/"&articleid&".gif"
	Set Fs=createobject("scripting.filesystemobject")
	if fs.fileexists(server.mappath(thefile1)) then tnimage="<img src='"&applicationurl&"thumbnails/"&articleid&".gif"&"' "&talign&" border=0>"
	if align="CENTER" then tnimage=tnimage&"<br>"
	set fs=nothing
	gettnimage=tnimage
end function

function deleteimage(articleid)
	thefile1=server.mappath("thumbnails/"&articleid&".gif")
	Set Fs=createobject("scripting.filesystemobject")
	if fs.fileexists(thefile1) then fs.deletefile thefile1
	set fs=nothing
end function
%>