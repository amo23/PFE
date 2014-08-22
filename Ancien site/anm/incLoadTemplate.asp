<%
function loadtemplate(template)
	'/// Read Search-results Template
	thetemplate=server.mappath("templates/"&template)
	Set Fs=createobject("scripting.filesystemobject")
	if fs.fileexists(thetemplate) then
		Set a=fs.opentextfile(thetemplate)
		loadtemplate=a.readall
		a.close
		set a=nothing
		set fs=nothing
	else
		set fs=nothing
		response.write "The Article cannot be displayed : Template File Not Found"
		response.end
	end if
end function

%>
