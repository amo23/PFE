<%
cachefolder=server.mappath("cache/")
cachetimeframe="n"
function getcache(cachetype,nocache)
	whatfile=cachetype
	strSeparator = "_"
	For Each var In Request.QueryString
		if lcase(var)<>"nocache" then parameters = parameters & "_" & var & "_" & replace(Request.QueryString(var),"/","-")
	next
	whatfile=whatfile & parameters
	whatfile=cachefolder&"\"&whatfile&".htm"
	resultfile=whatfile
	
	if nocache="" then
		Set Fs=createobject("scripting.filesystemobject")
		if fs.fileexists(whatfile) then
			Set objFile = fs.GetFile(whatfile)
			itsdate = objFile.DateLastModified
			set objFile=nothing
			if datediff(cachetimeframe,itsdate,now)<cachetime then
				Set a=fs.opentextfile(whatfile)
				content=a.readall
				a.close
				set a=nothing
				set fs=nothing
				resultfile=""
				response.write content
			end if
		end if
		set fs=nothing
		if resultfile="" then response.end
	end if
end function

function writecache(targetfile,content)
	'/// Create Cahed Content ///
	Set Fs=createobject("scripting.filesystemobject")
	Set b=fs.createtextfile(targetfile,true)
	b.write content
	b.close
	set b=nothing
	set fs=nothing
end function

%>
