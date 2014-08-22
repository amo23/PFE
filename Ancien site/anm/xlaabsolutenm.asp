<!-- #include file="incSystem.asp" -->
<!-- #include file="incGetThumbnail.asp" -->
<!-- #include file="incCache.asp" -->
<%
function preparemsg(what)
	a=what
	a=replace(a,"\","\\")
	a=replace(a,"/","\/")
	a=replace(a,vbclrf,"\n")
	a=replace(a,chr(34),"\"&chr(34))
	a=replace(a,"'","\'")
	a="document.write('"&a&"');"
	preparemsg=a
end function

function dohtml(what)
	dohtml=server.HTMLEncode(what)
end function

zoneid=request("z")
xlaparsing=request("xlaparsing")
if xlaparsing<>"" then 
	response.buffer=true
	response.flush
	response.write "<!-- Absolute News Manager Content -->"
else
	response.ContentType="application/x-javascript"
end if

if instr(zoneid,"$")<>0 or zoneid="" then response.end
nocache=request("nocache")
fdate=request("fdate")
if fdate<>"" then zonecache=""

'/// Check Protection ///
callingurl=lcase(Request.ServerVariables("HTTP_REFERER"))
if zoneprotection<>"any" and instr(callingurl,lcase(applicationurl))=0 and callingurl<>"" then
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
	if zoneprotection="restricted" and takeaction=false then response.end
	if zoneprotection="banned" and takeaction=true then response.end
end if


'//// Override Default Parameters 
articlespz=request("h")			'Number of headlines 0-Unlimited
showsummary=request("ss")		'Show Summary Y,N
showsource=request("sc")		'Show Source Y,N
showdates=request("sd")			'Show Dates Y,N
showtn=request("st")			'Show Thumbnail Y,N
displayhoriz=request("d")		'Display V-Vertical, H-Horizontal
textalign=request("al")			'Align
cellcolor=request("cc")			'Cell Color
targetframe=request("target")	'Targetframe
zonefont=request("font")		'Font
fontcolor=request("color")		'Font Color
fontsize=request("size")		'Font Size
isarchive=request("isarchive")	'List only Archives
stdate=request("stdate")		'With Start Date Like
edate=request("edate")			'With End Date Like
pdate=request("pdate")			'With Posted Date Like
hdate=request("hdate")			'With Headline Date Like
sort=request("sort")			'Sorting Criteria
ord=request("ord")				'Order (asc,desc)
css=request("css")				'Class Style
rmore=request("rmore")			'Read More Display

'/// Zone Cache  ///
if zonecache<>"" then
	dim resultfile
	resultfile=""
	call getcache("zone",nocache)
end if


today=year(now)&"/"&right("0"&month(now),2)&"/"&right("0"&day(now),2)
if fdate<>"" then today=fdate

psql="select * from vArticlesZones where "
if isnumeric(zoneid) then  psql=psql & "zoneid="&zoneid
if isarchive="" or isarchive="n" then psql=psql &" and status=1 " else psql=psql & " and status=4"

if stdate="" and edate="" and pdate="" and hdate="" then
	psql=psql & " and startdate<='"&today&"' and (enddate>='"&today&"' or enddate='-')"
else
	if stdate<>"" then psql=psql & " and startdate like '"&stdate&"%'"
	if edate<>"" then psql=psql & " and enddate like '"&edate&"%'"
	if pdate<>"" then psql=psql & " and posted like '"&pdate&"%'"
	if hdate<>"" then psql=psql & " and headlinedate like '"& hdate & "%'"
end if

if sort<>"" then psql=psql & "order by "&sort else psql=psql & " order by startdate  "
if ord<>"" then psql=psql & " " & ord

set conn=server.createobject("ADODB.Connection")
conn.open connection

call archivenow("")
set rs=conn.execute(psql)
if rs.eof then 
	if nonewsmessage<>"" then articlelist="<div align=center>"&dohtml(nonewsmessage)&"</div>" else articlelist=""
else
	'/// Headlines Per Zone
	if articlespz<>"" then
		articlespz=cint(articlespz)
	else
		articlespz=rs("articlespz")
	end if
	
	'/// Display Summary
	if showsummary="" then
		showsummary=rs("showsummary")
	elseif showsummary="n" then
		showsummary=""
	end if
	
	'/// Display Source
	if showsource="" then
		showsource=rs("showsource")
	elseif showsource="n" then
		showsource=""
	end if
	
	'/// Display Dates
	if showdates="" then
		showdates=rs("showdates")
	elseif showdates="n" then
		showdates=""
	end if
	
	'/// Display Thumbnail
	if showtn="" then
		showtn=rs("showtn")
	elseif showtn="n" then
		showtn=""
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
	
	if zonefont="" then zonefont=rs("zonefont")
	if fontsize="" then fontsize=rs("fontsize")
	if fontcolor="" then fontcolor=rs("fontcolor")
	if fontcolor<>"" then fontcolor=" fontcolor='"&fontcolor&"'"
	if css<>"" then css=" class="&chr(34)&css&chr(34) else css="face='"&zonefont&"' size='"&fontsize&"'"&fontcolor
	if targetframe="" then targetframe=rs("targetframe")
	if targetframe<>"" then target=" target='"&targetframe&"'" else target=""
	if textalign="" then textalign=rs("textalign")
	if cellcolor="" then cellcolor=rs("cellcolor")
	if cellcolor<>"" then cellcolor=" bgcolor='"&cellcolor&"'"
	
	do until rs.eof
		closetag=""
		summary=rs("summary") 
		if rs("articleurl")<>"" and openexternal<>"" then thistarget="target=_blank"  else thistarget=target
		c=c+1
		if rowmade="" or displayhoriz="" then articlelist=articlelist & "<tr>"
		if displayhoriz<>"" then rowmade="1"
		articlelist=articlelist & "<td align='"&textalign&"' width=[WIDTH] left valign=top "&cellcolor&">"
		if showtn<>"" then thisimage=gettnimage(rs("articleid"),textalign) else thisimage=""
		articlelist=articlelist & "<font "&css&">"
		if rs("article")<>"" or rs("articleurl")<>"" then articlelist=articlelist & "<a href='"&applicationurl&"anmviewer.asp?a="&rs("articleid")&"&z="&zoneid&"'"&thistarget&">" : closetag="</a>"

		articlelist=articlelist &thisimage&"<b>"&dohtml(rs("headline"))&"</b>" & closetag & "</font>"

		if showdates<>"" and rs("headlinedate")<>"" then articlelist=articlelist & "<br><font "&css&"><i>"&dohtml(rs("headlinedate"))&"</i></font>"
		if showsource<>"" and rs("source")<>"" then articlelist=articlelist & "<br><font "&css&"><i>"&dohtml(rs("source"))&"</i></font>"
		if showsummary<>"" and summary<>"" then articlelist=articlelist & "<br><font "&css&">"&replace(summary,vbcrlf,"<br>")&"</font>"
		if readmore<>"" then articlelist=articlelist &"<br><font "&css&">"
		if closetag<>"" then articlelist=articlelist & "<a href='"&applicationurl&"anmviewer.asp?a="&rs("articleid")&"&z="&zoneid&"'"&thistarget&">"&readmore&"</a>"
		articlelist=articlelist &"</font>"
		articlelist=articlelist&"</td>"
		if displayhoriz="" then articlelist=articlelist & "</tr>"
		rs.movenext
				
		'/// Display Limited Articles ?
		if articlespz>0 and c>=articlespz then exit do
	loop

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
rs.close
set rs=nothing
conn.close
set conn=nothing

if not(xlaparsing) then articlelist=preparemsg(articlelist)
'/// Do Cache ? ///
if zonecache<>"" and resultfile<>"" then call writecache(resultfile,articlelist)
response.write articlelist
response.end
%>


