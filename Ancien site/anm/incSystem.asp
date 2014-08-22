<%response.expires=-1
response.buffer=true%>
<!-- #include file="configdata.asp" -->
<!-- #include file="databasedata.asp" -->
<%
title="Absolute News Manager XE V3.1 : Licensed to "&license
todaydate=year(now)&"/"&right("0"&month(now),2)&"/"&right("0"&day(now),2)

function validate(thislevel)
	validate=request.cookies("xlaANMadmin")("lvl")
	if validate="" then response.redirect "logout.asp"
	if validate-thislevel<0 then response.redirect "logout.asp"
end function

function whichlevel(thislevel)
	select case thislevel
		case 1
			whichlevel="Editor"
		case 2
			whichlevel="Administrator"
		case else
			whichlevel="Publisher"
	end select
end function

function whichstatus(status)
	select case status
		case 1
			whichstatus="Publish"
		case 2
			whichstatus="Pending"
		case 3
			whichstatus="Expired"
		case 4
			whichstatus="Archived"
		end select
end function

sub deletefiles(whatarticleid)
	on error resume next
	filestodelete=attachmentsfolder&"\"&whatarticleid&"-*.*"
	Set Fs=createobject("scripting.filesystemobject")
	fs.deletefile(filestodelete)
	set fs=nothing
end sub

function getconnection()
	application("xlaANM_connection")=connection
end function

function revertdate(thisdate)
	if isdate(thisdate) then 
		revertdate=formatdatetime(thisdate,2)
	else
		revertdate="Undefined"
	end if
end function

function archivenow(what)
	if archiveenabled<>"" then
		if what<>""  then
			archivepsql="update articles set status=4 where articleid in("&what&")"
		else
			if archivedays="" or not(isnumeric(archivedays)) then archivedays=0
			if arhivedays>0 then archivedays=-archivedays
			thedate=dateadd("d",date,archivedays)
			archivedays=year(thedate)&"/"&right("0"&month(thedate),2)&"/"&right("0"&day(thedate),2)
			archivepsql="update articles set status=4 where status=3 or enddate<='"&archivedays&"'"
		end if
		conn.execute(archivepsql)
	end if
end function

articlefiles="articlefiles/"
attachmentsfolder=server.mappath(articlefiles)
usrid=request.cookies("xlaANMadmin")("usr")

'//// Do Not Remove or modify the following code ///
'//// Doing so will result in violation of the license agreement
if request("developer")<>"" then 
	response.write "ANM3.1XE-2003.02.15<br>"
	response.write "Licensed to :"&license&" ("&xla_id&")"
	response.write "<br>Copyright(c)2001-2003 : Xigla Software<br><a HREF=http://www.xigla.com>http://www.xigla.com</a>"
	response.end
end if
%>