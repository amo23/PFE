<!-- #include file="configdata.asp" -->
<!-- #include file="databasedata.asp" -->
<!-- #include file="incValidate.asp" -->
<%




'//// Please note that this application is copyrighted by XIGLA SOFTWARE
'//// As Stated in our license agreement, all of our copyright notices must remain visible
'//// This software is licensed, not sold
'//// Rebranding or resellin this application without our written permission
'//// will result in legal action.
'//// XIGLA SOFTWARE (http://www.xigla.com) Holds all the copyrights for this application
'//// You can only use this application on the licensed site







response.expires=-1
response.buffer=true
title="Absolute Image Gallery XE V2.0 : Licensed to "&license
todaydate=year(now)&"/"&right("0"&month(now),2)&"/"&right("0"&day(now),2)

function getnavigation(catpath,page,flag)
	if instr(page,"?")<>0 then thisparam="&" else thisparam="?"
	lcatpath=replace(catpath&"","'","''")
	psql="select * from xlaAIGcategories where '"&lcatpath&"%' like catpath + '%' order by catpath desc;"
	set rs=conn.execute(psql)
	do until rs.eof
		if rs("catpath")=catpath and flag=0 then
			thisnode=rs("catname")
		else
			thisnode="<a href='"&page&thisparam&"categoryid="&rs("categoryid")&"'>"&rs("catname")&"</a>"
		end if
		navbar=thisnode & " &gt; " & navbar
		rs.movenext
	loop
	navbar=left(navbar,len(navbar)-6)
	rs.close
	set rs=nothing
	getnavigation=navbar
end function

function ocurrences(tpath,tname)
	myocurr=split(tpath,"/")
	for x=1 to ubound(myocurr)-1
		points=points&"..."
	next
	set myocurr=nothing
	ocurrences=points&tname
end function

function preparecode(what)
	toprepare=what
	toprepare=replace(toprepare,"\","\\")
	toprepare=replace(toprepare,"'","\'")		
	toprepare=replace(toprepare,vbcrlf,"\n")
	toprepare=replace(toprepare,"/","\/")
	toprepare=replace(toprepare,chr(34),"\'")
	preparecode=toprepare
end function

function gettn(whichpath,whichfile)
	thepath=getpath(whichpath)&"tn\"&tnprefix&whichfile
	thetnfile=mid(whichfile,1,instrrev(whichfile,".")-1)
	lookfor=mid(thepath,1,instrrev(thepath,".")-1)
	tnextesnions=".gif,.jpg,.bmp,.png"
	thepath1=lookfor &".gif"
	thepath2=lookfor&".jpg"
	thepath3=lookfor&".bmp"
	thepath4=lookfor&".png"
	theext=lcase(mid(whichfile,instrrev(whichfile,".")+1,len(whichfile)))
	if fs.fileexists(thepath1) then
		gettn=escape(whichpath&"tn/"&tnprefix&thetnfile&".gif")
	elseif fs.fileexists(thepath2) then
		gettn=escape(whichpath&"tn/"&tnprefix&thetnfile&".jpg")
	elseif fs.fileexists(thepath3) then
		gettn=escape(whichpath&"tn/"&tnprefix&thetnfile&".bmp")
	elseif fs.fileexists(thepath4) then
		gettn=escape(whichpath&"tn/"&tnprefix&thetnfile&".png")
	elseif imagecomponent<>"" and flytn<>"" and (theext="jpg" or theext="jpeg" or theext="bmp" or theext="png")  then
		'/// Create Thumbnail on the Fly
		gettn="sendbinary.asp?ipath=" & server.urlencode(whichpath) & "&ifile="&server.urlencode(whichfile)
	elseif fs.fileexists(server.mappath("filetypes/")&"\"&theext&".gif") then 
		gettn="filetypes/"&theext&".gif"
	else
		gettn="filetypes/unknown.gif"
	end if
end function

function getimage(whichimageid,whichfile,whichpath,whatsize)
	if whichimageid="" or not(isnumeric(whichimageid)) then whichimageid=0
	Set Fs=createobject("scripting.filesystemobject")
	thepath=server.mappath("filetypes/")
	theext=lcase(mid(whichfile,instrrev(whichfile,".")+1,len(whichfile)))
	codepath=thepath & "\"&theext&".txt"
	if streamdownload="" then toread=thepath&"\unknown.txt" else toread=thepath&"\unknown2.txt"
	if (kblimit=0 or (kblimit>0 and whatsize/1000<=kblimit)) and fs.fileexists(codepath) then toread=codepath
	'/// Get Default Image Code
	Set a=fs.opentextfile(toread)
	code=a.readall
	a.close
	set a=nothing
	set fs=nothing
	if ispc<>"" and (pcsize<>"" and pcsize<>0) and (theext="jpg" or theext="png" or theext="bmp") and imagecomponent<>"" then 
		whichpath="sendbinary.asp?ispc=1&ipath="&server.urlencode(whichpath) 
	else
		whichpath=server.urlencode(whichpath)
	end if
	if instr(whichpath,"+")>0then whichpath=replace(whichpath,"+","%20")
	code=replace(code&"","$$URL$$",whichpath)
	code=replace(code&"","$$IMAGEID$$",whichimageid)
	getimage=code
end function


function isinmybox(thisimage)
	if enablemybox<>"" then 
		if instr(","&mybox&",",","&thisimage&",")<>0 then boxbtn="btnMyBoxOn.gif" else boxbtn="btnMyBoxOff.gif"
		isinmybox="<a href=javascript:addtomybox('" & thisimage&"');><img src=images/"&boxbtn&" border=0 name='boxbtn" &thisimage&"' vspace=4></a>"
	end if
end function

function getsize(size)
	getsize=formatnumber(size/1000,2)&"Kb"
end function

function whichstatus(what)
	select case what
		case 1
			whichstatus="Approved"
		case 2
			whichstatus="Not Approved"
		case else
			whichstatus="Pending"
	end select
end function

function getdate(thisdate)
	getdate=formatdatetime(thisdate,2)
end function

function revertdate(thisdate)
	revertdate=year(thisdate)&"/"&right("0"&month(thisdate),2)&"/"&right("0"&day(thisdate),2)
end function

function getrating(totalratings,totalreviews)
	if totalreviews>0 then 
		therating=int(totalratings/totalreviews) 
		therating="<img src='images/s"&therating&".gif' border=0>"
	else
		therating="N/A"
	end if
	getrating=therating
end function

function deletefile(kill)
	psql="SELECT * from "&vxlaAIGimagesCategories&" where imageid="&kill
	set rs=conn.execute(psql)
	if not(rs.eof) then
		imagepath=getpath(rs("catpath"))&rs("imagefile")
		tnpath=getpath(rs("catpath")) &"tn\"&tnprefix&rs("imagename")
		Set Fs=createobject("scripting.filesystemobject")
		fs.deletefile(imagepath)
		if fs.fileexists(tnpath) then fs.deletefile(tnpath)
		set fs=nothing
		psql="delete from xlaAIGimages where imageid="&kill
		conn.execute(psql)
	end if
	rs.close
	set rs=nothing
end function

function getpath(what)
	getpath=gallerypath & replace(what&"","/","\")
end function

flytnwidth=120
vxlaAIGimagesCategories="(SELECT TOP 100 PERCENT xlaAIGcategories.catname, xlaAIGcategories.catdesc, xlaAIGcategories.supercatid, xlaAIGcategories.images, xlaAIGcategories.lastupdate, xlaAIGcategories.catpath, [catpath]+[imagefile] AS imagepath, xlaAIGimages.* FROM xlaAIGcategories INNER JOIN xlaAIGimages ON xlaAIGcategories.categoryid = xlaAIGimages.categoryid WHERE xlaAIGimages.status=1 ORDER BY xlaAIGimages.imagename, xlaAIGimages.imageid) derivedtbl "

'//// Do Not Remove or modify the following code ///
'//// Doing so will result in violation of the license agreement
'//// The following code is required for Customer Support
if request("developer")<>"" then 
	response.write "AIGXE2.0-2002.11.16<br>"
	response.write "Licensed to :"&license&" ("&xla_id&")"
	response.write "<br>Copyright(c)2002 - Xigla Software<br><a HREF=http://www.xigla.com>http://www.xigla.com</a>"
	response.end
end if


%>
