<!--#include file="_ppl.tb.config.asp" -->
<%
'/// Articleurl
function createfile(whatfile,whatarticleid,whatzoneid)
	on error resume next
	Set Fs=createobject("scripting.filesystemobject")
	thefileexists=false
	if fs.fileexists(server.mappath(whatfile)) then
		itsdate = fs.GetFile(whatfile).DateLastModified
		if datediff("h",itsdate,now)<5 then thefileexists=true
	end if
	
	if thefileexists=false then
		content="<" & "%articleid=" & whatarticleid &":zoneid=" & whatzoneid & "%" & ">" & vbcrlf & "<!--" & """#include file=""_ppl.tb.parser.asp"" --" & ">"
		Set b=fs.createtextfile(server.mappath(whatfile),true)
		b.write content
		b.close
		set b=nothing
		set fs=nothing
	end if
	set fs=nothing
end function


function getfilename(what,zoneid,articleid,RegX)
		a=left(what,20)
		a=RegX.Replace(lcase(a), "") 
		a=replace(a," ","") & "-" & zoneid & "-" & articleid & ".asp"
		getfilename=a
		call createfile(a,articleid,zoneid)
end function

function setdesc()
	setdesc=left(summary,50)
end function

function setkeywords()
	a=split(summary," ")
	maxlimit=30
	if ubound(a)<maxlimit then maxlimit=ubound(a)
	for y=0 to maxlimit
		if len(a(y))>2 then keywords=keywords & a(y) & ","
	next
	setkeywords=keywords
end function

function followlinks(linkarray)
	if isarray(linkarray) then
		set RegX = New RegExp
		SearchPattern="[^a-z0-9]"
		RegX.Pattern = SearchPattern 
		RegX.Global = True 
	
		response.write "<ul>"
		for x=0 to ubound(linkarray,2)
			response.write "<li><b><a href=""" & getfilename(linkarray(1,x),linkarray(3,x),linkarray(0,x),RegX) & """>" & linkarray(1,x) & "</a></b><br>" & linkarray(2,x)
			response.write "<br></li><br>&nbsp;" & vbcrlf
		next
		response.write "</ul>"
		set RegX = nothing
	end if
end function
%>

