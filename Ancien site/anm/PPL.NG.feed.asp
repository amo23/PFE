<!-- #include file="incSystem.asp" -->
<!-- #include file="incCache.asp" -->
<%
function preparemsg(what)
	a=what
	a=replace(a,"\","\\")
	a=replace(a,"/","\/")
	a=replace(a,vbcrlf,"\n")
	a=replace(a,chr(13),"\n")
	a=replace(a,chr(10),"\n")
	a=replace(a,chr(34),"\"&chr(34))
	a=replace(a,"'","\'")
	a="document.write(" & chr(34) &  a & chr(34) & ");"
	preparemsg=a
end function



function getNode(what,object)
	getNode=""
	set a=object.selectSingleNode(what)
	'/// If node exists the return its text
	if not(a is nothing) then getNode=a.text
	set a=nothing
end function

function dohtml(what)
	dohtml=server.HTMLEncode(what)
end function

feedid=request("f")
xlaparsing=request("xlaparsing")
if request("debug")="" then on error resume next
errormsg=false

if xlaparsing<>"" then 
	response.buffer=true
	response.flush
	response.write "<!-- Absolute News Manager Content -->"
else
	response.ContentType="application/x-javascript"
end if

if feedid="" or not(isnumeric(feedid)) then response.end
nocache=request("nocache")

'/// Check Protection ///
callingurl=lcase(Request.ServerVariables("HTTP_REFERER"))
if feedprotection<>"any" and instr(callingurl,lcase(applicationurl))=0 and callingurl<>"" then
	specialurls=split(lcase(specialurls),";")
	for x=0 to ubound(specialurls)
		if len(specialurls(x))>5 then
			if instr(specialurls(x),"http://")=0 then specialurls(x)="http://"&specialurls(x)
			if instr(callingurl,specialurls(x))=1 then 
				takeaction=true
				exit for
			end if
		end if
	next
	if feedprotection="restricted" and takeaction=false then response.end
	if feedprotection="banned" and takeaction=true then response.end
end if


'//// Override Default Parameters 
articlespz=request("h")			'Number of headlines 0-Unlimited
showsummary=request("ss")		'Show Summary Y,N
showdates=request("sd")			'Show Dates Y,N
displayhoriz=request("d")		'Display V-Vertical, H-Horizontal
textalign=request("al")			'Align
cellcolor=request("cc")			'Cell Color
targetframe=request("target")	'Targetframe
feedfont=request("font")		'Font
fontcolor=request("color")		'Font Color
fontsize=request("size")		'Font Size
css=request("css")				'Class Style
rmore=request("rmore")			'Read More Display
ord=request("ord")				'Order ASC, DESC

'/// feed Cache  ///
'/// Inherits the caching sett
if zonecache<>"" then
	dim resultfile
	resultfile=""
	call getcache("zone-feed",nocache)
end if

'/// Load Feed settings
psql="select * from xlaPPLNGfeeds where feedid=" & feedid
set conn=server.createobject("ADODB.Connection")
conn.open connection
set rs=conn.execute(psql)
feedurl=""
if not(rs.eof) then 
	'/// Feed URL
	feedurl=rs("feedurl")

	'/// Headlines Per feed
	if articlespz<>"" then articlespz=cint(articlespz) else articlespz=rs("articlespz")
	
	'/// Display Summary
	if showsummary="" then 
		showsummary=rs("showsummary")
	elseif showsummary="n" then
		showsummary=""
	end if
	

	'/// Display Dates
	if showdates="" then
		showdates=rs("showdates")
	elseif showdates="n" then
		showdates=""
	end if
	

	'/// Display Articles Horizontally
	if displayhoriz="" then
		displayhoriz=rs("displayhoriz")
	elseif displayhoriz="v" then
		displayhoriz=""
	end if
	
	'/// Read More
	if rmore<>"" then
		readmore=rmore
		if readmore="-" then readmore=""
	end if
	
	if feedfont="" then feedfont=rs("feedfont")
	if fontsize="" then fontsize=rs("fontsize")
	if fontcolor="" then fontcolor=rs("fontcolor")
	if fontcolor<>"" then fontcolor=" color='"&fontcolor&"'"
	if css<>"" then css=" class="&chr(34)&css&chr(34) else css="face='"&feedfont&"' size='"&fontsize&"'"&fontcolor
	if targetframe="" then targetframe=rs("targetframe")
	if targetframe<>"" then target=" target='"&targetframe&"'" else target=""
	if textalign="" then textalign=rs("textalign")
	if cellcolor="" then cellcolor=rs("cellcolor")
	if cellcolor<>"" then cellcolor=" bgcolor='"&cellcolor&"'"
end if
rs.close
set rs=nothing
conn.close
set conn=nothing

'//// Grab the newsfeed ///'
if feedurl<>"" then

	'/// Send HTTP Request
	Set xmlhttp = Server.CreateObject("Microsoft.XMLHTTP")
	xmlhttp.Open "GET", feedurl, false
	xmlhttp.Send
	
	set xmlDoc=server.createObject("MSXML2.DOMDocument")
	xmlDoc.async="false"


	'/// Load RSS File
	thexml=xmlhttp.ResponseText & ""

	'/// Remove <DOCTYPE>
	Set objRegExp = New Regexp
	objRegExp.IgnoreCase = True
	objRegExp.Global = True  
	objRegExp.Pattern = "<!DOCTYPE(.|\n)+?>" 
	thexml=objRegExp.Replace(thexml, "") 
	set objRegExp=nothing

	if not(xmlDoc.loadxml(thexml)) then
		'/// Loading Failed
		errormsg=true
		articlelist="An error has ocurred<br>" & xmlDoc.parseError.Reason 
		set xmldoc=nothing
	end if
	set xmlhttp=nothing
	
	'/// if no error has ocurred then 
	if articlelist="" then
	
		'/// Grab Nodes ///'
		set nodes=xmlDoc.selectNodes("//item")
		
		'/// Walk Each node taking its properties
		c=0
		if openexternal<>"" then thistarget="target=_blank"  else thistarget=target
		
		for each x in nodes
			'/// Get Each Node (nodename, object)
			title=getnode("title",x)
			link=getnode("link",x)
			summary=getnode("description",x)
			headlinedate=getnode("pubDate",x)
			
			c=c+1
			summary=dohtml(summary)
			thisarticle=""
			if rowmade="" or displayhoriz="" then thisarticle=thisarticle & "<tr>"
			if displayhoriz<>"" then rowmade="1"
			thisarticle=thisarticle & "<td align='"&textalign&"' width=[WIDTH] valign=top "&cellcolor&">"
			thisarticle=thisarticle & "<font "&css&">"
			closetag=""
			if link<>"" then thisarticle=thisarticle & "<a href='" & link & "'" & thistarget & ">" : closetag="</a>"
	
			thisarticle=thisarticle & "<b>" & dohtml(title) & "</b>" & closetag & "</font>"
			if showdates<>"" and headlinedate<>"" then thisarticle=thisarticle & "<br><font "&css&"><i>"&dohtml(headlinedate)&"</i></font>"
			if showsummary<>"" and summary<>"" then thisarticle=thisarticle & "<br><font "&css&">"&replace(summary,vbcrlf,"<br>")&"</font>"
			if readmore<>"" then thisarticle=thisarticle &"<br><font "&css&">"
			if closetag<>"" then thisarticle=thisarticle & "<a href='" & link & "'" & thistarget & ">" & readmore & "</a>"
			thisarticle=thisarticle &"</font>"
			thisarticle=thisarticle&"</td>"
			if displayhoriz="" then thisarticle=thisarticle & "</tr>"
			if ord="desc"  then
				articlelist=thisarticle & articlelist
			else
				articlelist=articlelist  & thisarticle
			end if
			
			'/// Display Limited Articles ?
			if articlespz>0 and c>=articlespz then exit for
		next
		
		'/// Get Appropiate Cell Width
		width="100%"
		if displayhoriz<>"" then 
			if c=0 then c=1
			articlelist=articlelist & "</tr>"
			width=int(100/c)&"%"
		end if
		articlelist=replace(articlelist,"[WIDTH]",width)
		articlelist="<table width=100% cellspacing=1 cellpadding=3 border=0>"&articlelist&"</table>" 

	end if
	
	set nodes=nothing
	set xmldoc=nothing

end if

'/// No Articles to display
if articleslist="" then articleslist=nonewsmessage

'/// Prepare file for displaying
if not(xlaparsing) then articlelist=preparemsg(articlelist)

'/// Do Cache ? ///
if zonecache<>"" and errormsg=false and resultfile<>"" then call writecache(resultfile,articlelist)

response.write articlelist
response.end
%>


