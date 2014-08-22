<!-- #include file="incSystem.asp" -->
<%
lvl=validate(1)

function getNode(what,object)
	getNode=""
	set a=object.selectSingleNode(what)
	'/// If node exists the return its text
	if not(a is nothing) then getNode=a.text
	set a=nothing
end function

function showalert(what)
		conn.close
		set conn=nothing
		response.write "<sc" &"ript language=""JavaScript"">top.showhide();alert('" & what & "');</sc" & "ript>"
		response.end
end function


feedid=request("feedid")
if feedid="" or not(isnumeric(feedid)) then response.end
zones=replace(request("zones") & ""," ","")
startdate=request("year1")&"/"&request("month1")&"/"&request("day1") &" 00:00"
enddate=request("year2")&"/"&request("month2")&"/"&request("day2") &" 23:59"
if request("neverexpires")<>"" then enddate="-"
status=request("status")
totalpoured=0

'/// Load Feed settings
psql="select feedname,feedurl,pourtozones,allowpouring from xlaPPLNGfeeds where feedid=" & feedid
set conn=server.createobject("ADODB.Connection")
conn.open connection
set rs=conn.execute(psql)
if not(rs.eof) then 
	feedname=rs("feedname")
	feedurl=rs("feedurl")
	pourtozones=rs("pourtozones")
	allowpouring=rs("allowpouring")
end if
rs.close
set rs=nothing

'//// Can the feed be saved to the database ?
if allowpouring="" then 
	conn.close
	set conn=nothing
	response.end
end if


'//// Grab the newsfeed and pour it to database ///'
if request("button")<>"" and feedurl<>"" then
	if zones="" then showalert("Please select at least one zone to store the contents of the newsfeed")
	
	tzones=split(zones,",")
	'/// Send HTTP Request
	'on error resume next
	Set xmlhttp = Server.CreateObject("Microsoft.XMLHTTP")
	xmlhttp.Open "GET", feedurl, false
	xmlhttp.Send
	'if err.number<>0 then showalert("An Error has ocurred : The newsfeed could not be loaded\nMake sure that it is a valid and available RSS File")
	
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
		set xmldoc=nothing
		set xmlhttp=nothing
		conn.close
		set conn=nothing
		response.write "<sc" &"ript language=""JavaScript"">alert('An error has ocurred : The newsfeed could not be loaded\nMake sure that it is a valid and available RSS File');</sc" & "ript>"
		response.end
	end if
	set xmlhttp=nothing
	
	
	'/// Grab Nodes ///'
	set nodes=xmlDoc.selectNodes("//item")
		
	'/// Walk Each node taking its properties
	Set rs = Server.CreateObject("ADODB.Recordset") 
	for each x in nodes
		'/// Get Each Node (nodename, object)
		title=getnode("title",x)
		link=getnode("link",x)
		summary=getnode("description",x)
		headlinedate=getnode("pubDate",x)
		
		'/// Save To database
		psql="select * from articles where articleurl='" & replace(link,"'","''") & "'"
		rs.open psql,conn,1,2
		if rs.eof and left(lcase(link),7)="http://" and instr(1,link,applicationurl,1)=0 then
			totalpoured=totalpoured+1
			rs.addnew
			rs("posted")=todaydate
			rs("lastupdate")=todaydate
			rs("startdate")=startdate
			rs("enddate")=enddate
			rs("headline")=title
			rs("headlinedate")=headlinedate
			rs("source")=feedname
			rs("summary")=summary
			rs("articleurl")=link
			rs("article")=""
			rs("status")=status
			rs("autoformat")=""
			rs("publisherid")=0
			rs("clicks")=0
			rs("editor")=0
			rs("relatedid")=""
			rs.update
			articleid=rs("articleid")
			
			for y=0 to ubound(tzones)
				conn.execute("insert into iArticlesZones (articleid,zoneid) values (" & articleid & "," & tzones(y) &")")
			next
			
		end if
		rs.close
	next
	set rs=nothing
	set nodes=nothing
	set xmldoc=nothing
	conn.execute("update xlaPPLNGfeeds set lastpourdate='" & todaydate & "'")
	if totalpoured>0 then 
		message="Neewsfeed succesfully saved :\n " & totalpoured & " headlines were added to the database"
	else
		message="Completed : There were no new headlines to add to the database"
	end if
	
	conn.close
	set conn=nothing
	response.write "<sc" &"ript language=""JavaScript"">top.showhide();alert('" & message & "');top.close();</sc" & "ript>"
	response.end
end if

if not(isdate(startdate)) then startdate=now
if not(isdate(enddate)) then enddate=now

'/// Limit zones ?
zonespsql="select zoneid,zonename from zones order by zonename asc"
if lvl=1 and edtsearch<>"" then zonespsql="select zoneid,zonename from zones where zoneid in (select zoneid from publisherszones where publisherid=" & usrid & ") order by zonename asc"
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Newsgrabber : Pour Contents to Database</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script language="JavaScript" type="text/JavaScript">
function showhide(){
	if (document.getElementById('progress').style.display=='none'){
		document.getElementById('progress').style.display='';
	} else {
		document.getElementById('progress').style.display='none';
	}
}
</script>
</head>

<body>
<form name="form1" method="post" action="PPL.NG.pourfeed.asp?feedid=<%=feedid%>" target="subframe">
  <table width="100%" border="0" cellspacing="2" cellpadding="2">
    <tr> 
      <td colspan="2"><font face="Arial, Helvetica, sans-serif"><b><font size="2"><img src="PPL.NG/rss.gif" width="36" height="14" align="absmiddle"> 
        Newsgrabber : Pour newsfeeds contents to database</font></b><br>
        <font size="1">Use this option to save the newsfeed headlines to the Absolute 
        News Manager database </font></font></td>
    </tr>
    <tr> 
      <td colspan="2" bgcolor="#666666"></td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="20%" bgcolor="#CCCCCC"><b><font size="2" face="Arial, Helvetica, sans-serif">Newsfeed 
        :</font></b></td>
      <td bgcolor="#F3F3F3"><font size="2" face="Arial, Helvetica, sans-serif"><b><%=feedname%></b></font></td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="20%" bgcolor="#CCCCCC"><b><font size="2" face="Arial, Helvetica, sans-serif">URL 
        :</font></b></td>
      <td bgcolor="#F3F3F3"><font size="2" face="Arial, Helvetica, sans-serif"><a href="<%=feedurl%>" target="_blank"><b><%=feedurl%></b></a></font></td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="20%" bgcolor="#CCCCCC"><b><font size="2" face="Arial, Helvetica, sans-serif">Start 
        date : </font></b></td>
      <td bgcolor="#F3F3F3"><font size="2" face="Arial, Helvetica, sans-serif"> 
        <select name="month1">
          <%
			  	for x=1 to 12
				if x=month(startdate) then sel=" selected" else sel=""
					response.write "<option value=" &right("0" & x ,2)&sel&">"&monthname(x)& "</option>"
				next
			  %>
        </select>
        <select name="day1">
          <%
			  	for x=1 to 31
				if x=day(startdate) then sel=" selected" else sel=""
					response.write "<option"&sel&">"& right("0" & x ,2) & "</option>"
				next
			  %>
        </select>
        <select name="year1">
          <%
			  a=year(startdate)
			  for x=a-50 to a+50
			  	if x=a then sel=" selected" else sel=""
			  	response.write "<option"&sel&">"& x&"</option>"	
			  next 
			  %>
        </select>
        </font><font size="2" face="Arial, Helvetica, sans-serif"><br>
        </font><font size="1" face="Arial, Helvetica, sans-serif">Date that the 
        headline will start showing on the zones</font><font size="2" face="Arial, Helvetica, sans-serif">&nbsp; 
        </font></td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="20%" bgcolor="#CCCCCC"><b><font size="2" face="Arial, Helvetica, sans-serif">End 
        date :</font></b></td>
      <td bgcolor="#F3F3F3"><font size="2" face="Arial, Helvetica, sans-serif">
        <select name="month2">
          <%
			  	for x=1 to 12
				if x=month(enddate) then sel=" selected" else sel=""
					response.write "<option value=" &right("0" & x ,2)&sel&">"&monthname(x)& "</option>"
				next
			  %>
        </select>
        <select name="day2">
          <%
			  	for x=1 to 31
				if x=day(enddate) then sel=" selected" else sel=""
					response.write "<option"&sel&">"& right("0" & x ,2) & "</option>"
				next
			  %>
        </select>
        <select name="year2">
          <%
			  a=year(enddate)
			  for x=a-50 to a+50
			  	if x=a then sel=" selected" else sel=""
			  	response.write "<option"&sel&">"& x&"</option>"	
			  next 
			  %>
        </select>
        </font> <font size="1" face="Arial, Helvetica, sans-serif"> 
        <input type="checkbox" name="neverexpires" value="checked" <%=neverexpires%>>
        <font size="2">Never Expires<br>
        </font>Date that the headline will stop showing on the zones<font size="2"> 
        </font></font></td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="20%" bgcolor="#CCCCCC"><b><font size="2" face="Arial, Helvetica, sans-serif">Status 
        :</font></b></td>
      <td bgcolor="#F3F3F3"> <font face="Arial, Helvetica, sans-serif"> 
        <select name="status">
          <%for x=1 to 4
			response.write "<option value="&x&sel&">"&whichstatus(x)&"</option>"
			next%>
        </select>
        </font></td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="20%" bgcolor="#CCCCCC"><b><font size="2" face="Arial, Helvetica, sans-serif">Zones 
        :</font></b></td>
      <td bgcolor="#F3F3F3"> <font face="Arial, Helvetica, sans-serif"> 
        <select name="zones" size="4" multiple>
          <%set rs=conn.execute(zonespsql)
		do until rs.eof
			if instr(","&pourtozones&",",","&rs("zoneid")&",")<>0 then sel=" selected" else sel=""
			response.write "<option value="&rs("zoneid")&sel&">"&rs("zonename")&"</option>"
		rs.movenext
		loop
		rs.close
		set rs=nothing
		conn.close
		set conn=nothing%>
        </select>
        <br>
        <font size="1">Select the Zones (categories) to classify your articles</font></font> 
      </td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="20%" bgcolor="#CCCCCC">&nbsp;</td>
      <td bgcolor="#F3F3F3"><font face="Arial, Helvetica, sans-serif"> 
        <input name="button" type="submit" id="button" value="Pour Headlines &gt;" onclick="javascript:showhide();">
        <iframe name="subframe" width="0" height="0" style="display:none"></iframe>
        </font><font face="Arial, Helvetica, sans-serif"><img src="PPL.NG/progressbar.gif" name="progress" width="45" height="14" align="absmiddle" id="progress" style="display:none"></font></td>
    </tr>
    <tr align="left" valign="top"> 
      <td colspan="2" bgcolor="#666666"></td>
    </tr>
  </table>
</form>
</body>
</html>

