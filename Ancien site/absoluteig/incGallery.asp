<!--#include file="incSystem.asp" -->
<%

'/// Check Gallery Lock
if application("AIG_GalleryLock")<>"" then response.redirect "updatemsg.htm"

action=request("action")
if action="" then action="browse"

set conn=server.createobject("ADODB.Connection")
conn.open connection
if enablemybox="" then response.cookies("xlaAIG_box").expires=date-3
mybox=request.cookies("xlaAIG_box")("mybox")
box=request("box")
shownew=request("shownew")

slidetime=request("slidetime")
if slidetime="" or not(isnumeric(slidetime)) then slidetime=defaultslidetime
dim images, title,description,categories,navigation,catpath,pages

function nofiles()
	nofiles="<p align=center><br><br><br>No Files Found In This Category<br><br><br></p>"
end function

function getquery(text,categoryid,box)
	if box<>"" then
		thequery="select * from "&vxlaAIGimagesCategories&" where imageid in("&mybox&") order by imagename,imageid asc"
	elseif shownew<>"" then
		lastdate=dateadd("d",-newdays,now)
		lastdate=revertdate(lastdate)
		thequery="select * from "&vxlaAIGimagesCategories&" where imagedate>='"&lastdate&"'"
	else
		if categoryid<>"" and isnumeric(categoryid) then
			if categoryid=0 then condition="supercatid=0" else condition="categoryid="&categoryid
			thequery="select * from xlaAIGcategories where "&condition
		else
			stext=replace(text,"'","''")
			stext=replace(stext,"*","%")
			thequery="select * from "&vxlaAIGImagesCategories&" where imagename like '%"&stext&"%' or imagedesc like '%"&stext&"%' or imagefile like '%"&stext&"%' or keywords like '%"&stext&"%' or copyright like '%"&stext&"%' or credit like '%"&stext&"%'"
		end if
	end if
	getquery=thequery
end function


sub showfile()
	if streamdownload="" then downloadpath=chr(34)&rs("imagepath")&chr(34) & " target=_blank" else downloadpath="streamfile.asp?imageid="&rs("imageid")
	images="<table width=100% border=0 cellspacing=2 cellpadding=2>"
	images=images & "<tr><td align=center>"&getimage(rs("imageid"),rs("imagefile"),rs("imagepath"),rs("imagesize"))&"<p align=center class=NavigationBar>"
	if downloadlink<>"" then images=images &"[<a href="& downloadpath  &">Download File</a>]"
	if allowpostcards<>"" then images=images & "<br>[<a href='javascript:sendpostcard("&rs("imageid")&")'>Send as Postcard</a>]"
	images=images & "</p>"
	images=images &"</td></tr>"
	images=images & "<tr><td><table width=80% border=0 cellspacing=1 cellpadding=2 align=center class=MainTable><tr><td class=NavigationBar width='20%'><b>Name :</b></td>"
	images=images & "<td colspan=4 class=FilesCellColor>"&rs("imagename")&" ("&rs("imagefile")&")</td></tr>"
	if rs("imagedesc")<>"" then images=images & "<tr><td class=NavigationBar width='20%'><b>Description :</b></td><td colspan=4 class=FilesCellColor>"&rs("imagedesc")&"</td></tr>"
	if rs("keywords")<>"" then images=images & "<tr><td class=NavigationBar width='20%'><b>Keywords :</b></td><td colspan=4 class=FilesCellColor>"&rs("keywords")&"</td></tr>"
	if rs("copyright")<>"" then images=images & "<tr><td class=NavigationBar width='20%'><b>Copyright :</b></td><td colspan=4 class=FilesCellColor>"&rs("copyright")&"</td></tr>"
	if rs("credit")<>"" then images=images & "<tr><td class=NavigationBar width='20%'><b>Credit :</b></td><td colspan=4 class=FilesCellColor>"&rs("credit")&"</td></tr>"
	if rs("source")<>"" then images=images & "<tr><td class=NavigationBar width='20%'><b>Source :</b></td><td colspan=4 class=FilesCellColor>"&rs("source")&"</td></tr>"
	if rs("datecreated")<>"" then images=images & "<tr><td class=NavigationBar width='20%'><b>Date Created :</b></td><td colspan=4 class=FilesCellColor>"&rs("datecreated")&"</td></tr>"
	if rs("uploadedby")<>"" then images=images & "<tr><td class=NavigationBar width='20%'><b>Uploaded By :</b></td><td colspan=4 class=FilesCellColor>"&rs("uploadedby")&"</td></tr>"
	if rs("email")<>"" then images=images & "<tr><td class=NavigationBar width='20%'><b>E-Mail :</b></td><td colspan=4 class=FilesCellColor><a href='mailto:"&rs("email")&"'>"&rs("email")&"</a></td></tr>"
	if rs("infourl")<>"" then images=images & "<tr><td class=NavigationBar width='20%'><b>URL :</b></td><td colspan=4 class=FilesCellColor><a href='"&rs("infourl")&"' target=_blank>"&rs("infourl")&"</a></td></tr>"
	if rs("additionalinfo")<>"" then images=images & "<tr><td class=NavigationBar width='20%'><b>Additional Info :</b></td><td colspan=4 class=FilesCellColor>"&rs("additionalinfo")&"</td></tr>"
	images=images & "<tr align=center><td class=NavigationBar width='20%'><b>Date</b></td>"
	
	if displayhits<>"" then thishits=rs("hits") else thishits="N/A"
	if displayrating<>"" then thisrating="<a href='javascript:ratefile("& imageid&");'>"&getrating(rs("totalrating"),rs("totalreviews"))&"</a>"  else thisrating="N/A"
	if enablemybox<>"" then thisbox=isinmybox(imageid) else thisbox="-"
	images=images & "<td class=NavigationBar width='20%'><b>Size</b></td><td class=NavigationBar width='20%'><b>Hits</b></td><td class=NavigationBar width='20%'><b>Ratings</b></td>"
	images=images & "<td class=NavigationBar width='20%'><b>Favorites</b></td></tr><tr align=center><td class=FilesCellColor width='20%'>"&getdate(rs("imagedate"))&"</td><td class=FilesCellColor width='20%'>"&getsize(rs("imagesize"))&"</td><td class=FilesCellColor width='20%'>"&thishits&"</td><td class=FilesCellColor width='20%'>"&thisrating&"</td>"
	images=images & "<td class=FilesCellColor width='20%'>"&thisbox&"</td></tr></table></td></tr>"
	if rs("embedhtml")<>"" then images=images&"<tr><td align=center>"&rs("embedhtml")&"</td></tr>"
	images=images &"</table>"
	title=rs("imagename")
	description=rs("imagedesc")
	catpath=rs("catpath")	
end sub

select case action
	case "mybox"
		clear=request("clear")
		if clear<>"" then
			response.cookies("xlaAIG_box").expires=date-10
			mybox=""
		end if
		if mybox="" then mybox=0
		searchsql=getquery("","","on")
		action="browse"
		box="on"
		title="Browsing My Favorite Files"
		navigation="<a href='gallery.asp'>Top</a> &gt; Favorite Files"
		scriptname="gallery.asp?action=mybox"
		
	case "viewimage"
		text=request("text")
		slideshow=request("slideshow")
		categoryid=request("categoryid")
		imageid=request("imageid")
		direction=request("direction")
		if imageid="" or not(isnumeric(imageid)) then imageid=0
		
		'/// Update Hits
		psql="update xlaAIGimages set hits=hits+1 where imageid="&imageid
		conn.execute(psql)
		
		if categoryid<>"" then
			psql="select * from "&vxlaAIGImagesCategories&" where categoryid="&categoryid
		else
			thesql=replace(getquery(text,"",box),"select * from","select top 100 percent imageid from")
			psql="select * from "&vxlaAIGImagesCategories&" where imageid in("&thesql&")"
		end if
		
		
		'/// Get Current Image ///
		psqlthis=psql 
		if imageid>0 then psqlthis=psqlthis &" and imageid="&imageid
		psqlthis=psqlthis & " order by imagename,imageid asc"

		set rs=conn.execute(psqlthis)
		if rs.eof then
			response.redirect "gallery.asp"
		else
			imagename=rs("imagename")
			imageid=rs("imageid")
			call showfile()
			maxcount=1
		end if
		rs.close
		set rs=nothing
		currentimgname=replace(imagename,"'","''")

		'/// Get Previous Image
		psqlprev=psql & " and (imagename<'"&currentimgname&"' or (imagename='"&currentimgname&"' and imageid<"&imageid&")) order by imagename desc,imageid asc"
		set rs=conn.execute(psqlprev)
		if not(rs.eof) then
			previmageid=rs("imageid")
			prevbutton=rs("Imagename")
		end if
		rs.close
		set rs=nothing
		
		'/// Get Next Image
		psqlnext=psql & " and (imagename>'"&currentimgname&"' or (imagename='"&currentimgname&"' and imageid>"&imageid&")) order by imagename,imageid asc"
		set rs=conn.execute(psqlnext)
		if not(rs.eof) then
			nextbutton=rs("imagename")
			nextimageid=rs("imageid")
		else
			if slideshow<>"" then
				psqlnext=psql & " order by imagename,imageid asc"
				set rs=conn.execute(psqlnext)
				if not(rs.eof) then
					nextbutton=rs("imagename")
					nextimageid=rs("imageid")
				else
					slideshow=""
				end if	
			end if
		end if
		rs.close
		set rs=nothing
		
		pages="<table width=80% border=0 cellspacing=1 cellpadding=2><tr align=center valign=top>"
    	pages=pages & "<td class=NavigationBar width='50%'>"
		if prevbutton<>"" then pages=pages & "<a href='gallery.asp?action=viewimage&imageid="&previmageid&"&text="&server.urlencode(text)&"&categoryid="&categoryid&"&box="&box&"&shownew="&shownew&"'>&lt;&lt;&lt; Previous</a> : "&prevbutton
		pages=pages & "</td><td class=NavigationBar width='50%'>"
		if nextbutton<>"" then pages=pages & nextbutton & " : <a href='gallery.asp?action=viewimage&imageid="&nextimageid&"&text="&server.urlencode(text)&"&categoryid="&categoryid&"&box="&box&"&shownew="&shownew&"'>Next &gt;&gt;&gt;</a>"
		pages=pages & "</td></tr></table>"
		
		navigation=getnavigation(catpath,"gallery.asp",1)&" &gt; "&imagename
		if slideshow<>"" then navigation=navigation & "<span id=slideshowmode style=''><br><b>Slideshow Mode</b> Refresh : <input size=2 type=text name=slidetime value=" & slidetime &" class=NavigationBar> Seconds</span>"
	
	case "browse"
		'/// Browse Categories
		categoryid=request("categoryid")
		if categoryid="" or not(isnumeric(categoryid)) then categoryid=0
		
		'//// Get Category Properties ////
		psql=getquery("",categoryid,box)
		set rs=conn.execute(psql)
		if rs.eof then response.redirect "error.htm"
		catname=rs("catname")
		if rs("supercatid")=0 then catname="Categories"
		catdesc=rs("catdesc")
		catpath=rs("catpath")
		allowupload=rs("allowupload")
		categoryid=rs("categoryid")
		rs.close
		set rs=nothing
		
		'/// Get Subcategories
		psql="select * from xlaAIGcategories where supercatid="&categoryid&" order by catname"
		set rs=conn.execute(psql)
		if not(rs.eof) then
			c=0
			do until rs.eof
				catlink="gallery.asp?categoryid="&rs("categoryid")
				filesfound=" ("&rs("images")& ")<br>"
				desc=""
				if rs("catdesc")&""<>"" then
					desc=rs("catdesc")
				end if
				c=c+1
				if c=1 then
					newcell=newcell &"<tr valign=top><td width=5% align=right><a href="&catlink&"><img src=images/imgGoCategory.gif border=0></a></td>"
					newcell=newcell & "<td width='43%'><span class=CategoriesList_category><a href="&catlink&">"&rs("catname")&"</a></span><span class=CategoriesList_description>"&filesfound&desc&"</span></td>"
					newcell=newcell & "<td width='4%'>&nbsp;</td>"
				else
					newcell=newcell & "<td width=5% align=right valign=top><a href="&catlink&"><img src=images/imgGoCategory.gif border=0></a></td>"
					newcell=newcell & "<td width='43%'><span class=CategoriesList_category><a href="&catlink&">"&rs("catname")&"</a></span><span class=CategoriesList_description>"&filesfound&desc&"</span></td>"
					newcell=newcell &"</tr>"
					c=0
				end if
				rs.movenext
			loop
			if c=1 then
				'/// Complete Table
				newcell=newcell & "<td width=5% align=right>&nbsp;</td><td width='43%'>&nbsp;</td></tr>"
			end if
			categories="<table width=80% border=0 cellspacing=2 cellpadding=2>" & newcell & "</table>"
		end if
		rs.close
		set rs=nothing
		searchsql="select * from "&vxlaAIGImagesCategories&" where categoryid="&categoryid
		
		'/// What To Display
		title=catname
		description=catdesc
		scriptname="gallery.asp?action=browse&categoryid="&categoryid
		
		'/// Get Navigation Bar
		navigation=getnavigation(catpath,"gallery.asp",0)
	
	case "search"
	'//// Perform Search
		text=request("text")
		searchsql=getquery(text,"","")
		box=""
		shownew=""
		
		navigation="Search Results :"
		title="Search"
		description="<br>Keyword : "&server.htmlencode(text)
		scriptname="gallery.asp?action=search&text="&server.urlencode(text)
	
	case "new"
	'//// Perform Search
		shownew="on"
		box=""
		searchsql=getquery("","","")
		navigation="Files added during the last "&newdays&" days :"
		title="New Files"
		description=""
		scriptname="gallery.asp?action=new&shownew=on"
		action="browse"
end select



'//// Perform Search //////
if action="search" or action="browse"  or action="new" then
	mypage=request("whichpage")
	if mypage="" then mypage=1
	mypagesize=columns*rows
	set rs=server.createobject("ADODB.Recordset")
	rs.open searchsql,conn,1 
	maxval=0
	maxcount=0
	if not(rs.eof) then 
		maxval=rs.recordcount
		rs.movefirst
		rs.pagesize=mypagesize
		maxcount=cint(rs.pagecount)
		rs.absolutepage=mypage
		howmanyrecs=0
		howmanyfields=rs.fields.count-1
		description=description &"<br>" & maxcount & " Pages - "&maxval&" Files Found"
		'//// Prepare Cells ////
		c=0
		thewidth=int(100/columns)
		images="<table width=100% border=0 cellspacing=1 cellpadding=2>"
		for x=1 to rows
			images=images & "<tr align=center valign=bottom>"
			for y=1 to columns
				c=c+1
				images=images & "<td width="&thewidth&"% class=FilesCellColor>["&c&"]</td>"
			next
			images=images&"</tr>"
		next
		images=images&"</table>"

		redim  image(mypagesize)
		'/// Get Images
		Set Fs=createobject("scripting.filesystemobject")
		do until rs.eof or howmanyrecs>=rs.pagesize
			imagedate=getdate(rs("imagedate"))
			imagesize=getsize(rs("imagesize"))
			imagename=rs("imagename")
			imagefile=rs("imagefile")
			imagedesc=rs("imagedesc")
			catpath=rs("catpath")
			thumbnail=gettn(catpath,imagefile)
			imageid=rs("imageid")
			
			hits=rs("Hits")
			rating=getrating(rs("totalrating"),rs("totalreviews"))
			
			howmanyrecs=howmanyrecs+1
			image(howmanyrecs)="<table width=100% border=0 cellspacing=2 cellpadding=2><tr><td align=center><a href='gallery.asp?action=viewimage&categoryid=" & categoryid&"&text="&server.urlencode(text)&"&imageid="&imageid&"&box="&box&"&shownew="&shownew&"'><img src='"&thumbnail&"' border=0 vspace=3></a>"
			image(howmanyrecs)=image(howmanyrecs) & "</td></tr><tr><td class=NavigationBar align=center><b><a href='gallery.asp?action=viewimage&categoryid=" & categoryid&"&text="&server.urlencode(text)&"&imageid="&imageid&"&box="&box&"&shownew="&shownew&"'>" & imagename&"</a></b><br>"
			if displaydesc<>"" and imagedesc<>"" then image(howmanyrecs)=image(howmanyrecs) & imagedesc &"<br>"
			image(howmanyrecs)=image(howmanyrecs) & "<b>Date : </b>"&imagedate&"<br><b>Size : </b>"&imagesize&"<br>"
			if displayhits<>"" then image(howmanyrecs)=image(howmanyrecs) & "<b>Hits : </b>"&rs("hits")&"<br>" 
			if displayrating<>"" then image(howmanyrecs)=image(howmanyrecs) &"<b>Rating : </b><a href='javascript:ratefile("&imageid&");'>"&rating &"</a><br>"
			if enablemybox<>"" then image(howmanyrecs)=image(howmanyrecs)&isinmybox(imageid)
			image(howmanyrecs)=image(howmanyrecs) & "</td></tr></table>"
		rs.movenext
		loop
		set fs=nothing
		rs.close
		set rs=nothing
		
		'/// Pare Page Selector
		pages="<div class=NavigationBar align=left>&nbsp; &nbsp;Go To Page :<select class=NavigationBar name=pageselector onchange=javascript:gopage(this.value);>"
		for counter=1 to maxcount
		if counter-mypage=0 then sel=" selected" else sel=""
			pages=pages & "<option value="&counter&sel&">"&counter&"</option>"
		next
		pages=pages & "</select>"
		pages=pages & "<script language=JavaScript>function gopage(what){self.location.href='" & scriptname & "&whichpage=' + what;}</script>"
        if cint(mypage)>1 then pages=pages & "<a href='"&scriptname&"&whichpage="&mypage-1&"'>&lt;&lt;</a> "  
	    if cint(mypage)<maxcount then pages=pages & "<a href='"&scriptname&"&whichpage="&mypage+1&"'>&gt;&gt;</a>"
		pages=pages & "</div>"
	
		'//// Replace Cells
		for x=1 to mypagesize
			images=replace(images,"["&x&"]",image(x))
		next
	else
		images=nofiles()
	end if
	imageid=0
end if

conn.close
set conn=nothing

'/// Activate Page Protection
if disableclick<>"" then
	protection="<SCRIPT language=JavaScript src=disablerc.asp></SCRIPT>"
	title=title & protection
end if
if slideshow<>"" then
	slidescript="<SCRIPT language=JavaScript>var timer=null;function doslideshow(){timer1=setTimeout('slideshow(\'" & nextimageid & "\',\'"&categoryid&"\')', " & slidetime*1000 & ")};window.onload=doslideshow;</script>"
	title=title & slidescript
end if
if ieimagebar<>"" then
	title=title & "<META HTTP-EQUIV=imagetoolbar CONTENT=no>"
end if

'/// Prepare Buttons
buttons="<a href=gallery.asp><img src=images/btnGalleryTop.gif hspace=1 border=0 alt='Go To Main Category'></a>"
buttons=buttons & "<a href=gallery.asp?action=new><img src=images/btnGallerynew.gif hspace=1 border=0 alt='New Files'></a>"

if slideshow="" then offstyle="display:none" else onstyle="display:none"
if maxcount>0 then buttons=buttons &"<a href=javascript:slideshow('" & imageid&"','"&categoryid&"');><img src=images/btnGalleryPlay.gif hspace=1 name=slideshowon style='"&onstyle&"' alt='Play Slide Show' border=0></a><a href=javascript:stopslideshow();><img src=images/btnGalleryStop.gif hspace=1 alt='Stop Slide Show' id='slideshowoff' style='"&offstyle&"' border=0></a>" 
if allowupload<>"" and publicupload<>"" then buttons=buttons & "<a href=javascript:uploadfile('"&categoryid&"');><img src=images/btnGalleryupload.gif hspace=1 border=0 alt='Upload File'></a><script language=Javascript>function uploadfile(what){window.open('Galleryupload.asp?categoryid=' + what,'gupload','toolbar=0,location=0,status=1,menubar=0,scrollbars=1,resizable=0,width=440,height=400');}</script>"

if enablemybox<>"" then
	if mybox<>"0" and mybox<>"" and box<>"" then buttons=buttons & "<a href=javascript:clearmybox();><img src=images/btnGalleryClearMyBox.gif hspace=1 border=0 alt='Clear My Box Contents'></a>" 
	if mybox<>"0" and mybox<>"" and enablesend<>"" then buttons=buttons & "<a href=javascript:openmybox();><img src=images/btnSendMyBox.gif hspace=1 border=0 alt='Send My Box Cotents by E-mail'></a>" 
    buttons=buttons & "<a href=gallery.asp?action=mybox><img src=images/btnFavorites.gif hspace=1 border=0 alt='View My Favorite Files'></a>" 
end if

response.buffer=true
response.flush


%>
