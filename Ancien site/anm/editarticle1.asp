<%response.expires=-1%>
<!-- #include file="incSystem.asp" -->
<!-- #include file="incNotify.asp" -->
<%
lvl=validate(0)
articleid=request("articleid")
if articleid="" or not(isnumeric(articleid)) then articleid=0
set conn=server.createobject("ADODB.Connection")
conn.open connection

function getarticletype(what)
	if what=1 then getarticletype="External Article" else getarticletype="Regular Article"
end function

button=request("button")
if button<>"" then
	headline=left(""&request("headline"),255)
	headlinedate=left(""&request("headlinedate"),255)
	startdate=request("year1")&"/"&request("month1")&"/"&request("day1")
	enddate=request("year2")&"/"&request("month2")&"/"&request("day2")
	source=request("source")
	neverexpires=request("neverexpires")
	status=request("status")
	if onlyadmins<>"" and lvl=0 then status=2
	if lvl>0 and articleid>0 then publisherid=request("publisherid") else publisherid=""

	summary=left(""&request("summary"),1000)
	articletype=request("articletype")
	articleurl=left(""&request("articleurl"),300)

	autoformat=request("autoformat")
	zones=replace(request("zones")," ","")
	editor=request("editor")
	
	'/// Retrieve Large Article (
	For I = 1 To Request("article").Count 
	  article = article & Request("article")(I)
	Next

	if zones="" then errormsg="You Must Select at least one zone for this article<br>"
	if not(isdate(startdate)) or (neverexpires="" and (not(isdate(enddate)) or startdate>enddate)) then errormsg=errormsg & "Either the start or ending date doesn't seem to be valid<br>"
	if articletype=1 and articleurl="" then errormsg=errormsg & "You didn't provide an article URL<br>"
	if status="4" and (lvl<1 or archiveaccess="") then response.redirect "logout.asp"
	if headline="" then errormsg="You must provide a headline for this article<br>"
	
	'/// Save Article ///
	if errormsg="" then
		
		psql="select * from articles where articleid="&articleid
		if articleid>0 and lvl=0 then psql=psql & " and publisherid=" & usrid
		Set rs = Server.CreateObject("ADODB.Recordset") 
		rs.open psql,conn,1,2
		if rs.eof and articleid>0 then 
			rs.close
			set rs=nothing
			conn.close
			set conn=nothing
			response.redirect "logout.asp"
		end if
		
		if rs.eof then 
			rs.addnew
			isnew=true
			rs("posted")=todaydate
			rs("relatedid")=""
			rs("clicks")=0
			rs("publisherid")=usrid
		end if
		
		if isnumeric(publisherid) and publisherid<>"" and lvl>0 and articleid>0 then rs("publisherid")=publisherid
		
		rs("lastupdate")=todaydate
		rs("headline")=headline
		rs("headlinedate")=headlinedate
		rs("startdate")=startdate
		if neverexpires<>"" then enddate="-"
		rs("enddate")=enddate
		rs("source")=source
		rs("status")=status
		rs("summary")=summary
		rs("editor")=editor
		
		if articletype=0 then 	
			rs("article")=article
			rs("articleurl")=""
		else
			rs("article")=""
			rs("articleurl")=articleurl
		end if
		
		if editor=1 then autoformat=""
		rs("autoformat")="" & autoformat
		rs.update
		articleid=rs("articleid")
		rs.close
		set rs=nothing
		
		'/// Save Zones
		psql="delete from iArticlesZones where articleid="&articleid
		conn.execute(psql)
		tzone=split(zones,",")
		for x=0 to ubound(tzone)
			psql="insert into iArticleszones (articleid,zoneid) values ("&articleid&","&tzone(x)&")"
			conn.execute(psql)
		next
		
		'/// Send Notifications if necessary
		if (notifyeditor<>"" or notifyadmin<>"") and isnew then
			message="Article ID : "&articleid&vbcrlf
			message=message & "Headline : " & headline &  vbcrlf
			message=message & "Source : " & source & vbcrlf
			message=message & "Summary :"&summary&vbcrlf
			message=message & "Display Between : "&revertdate(startdate)&" - "&revertdate(enddate)&vbcrlf
			message=message & "Status : "&whichstatus(status)&vbcrlf
			message=message & "Publisher ID:"&usrid&vbcrlf
			call sendnotification(zones,message)
		end if
		
		conn.close
		set conn=nothing
		if instr(button,"ges")<>0 then response.redirect "editarticle2.asp?articleid="&articleid&"&headline="&server.urlencode(headline)
		if instr(button,"ated")<>0 then response.redirect "related.asp?articleid="&articleid
		response.redirect "viewarticle.asp?articleid="&articleid
	end if
end if



'/// Retrieve Saved Article for editing ///
if articleid>0 and button="" then
	psql="select * from articles where articleid="&articleid
	if lvl=0 then psql=psql & " and publisherid=" & usrid
	set rs=conn.execute(psql)
	if rs.eof then response.redirect "logout.asp"
	
	headline=rs("headline")
	headlinedate=rs("headlinedate")
	startdate=rs("startdate")
	enddate=rs("enddate")
	source=rs("source")
	summary=rs("summary")
	articleurl=rs("articleurl")
	article=rs("article")
	autoformat=rs("autoformat")
	editor=rs("editor")
	status=rs("status")
	publisherid=rs("publisherid")
	rs.close
	set rs=nothing
	
	if pblaccess<>"" and lvl=0 and publisherid<>usrid then response.redirect "logout.asp"
	
	'/// Get Article Zones
	psql="select * from iArticlesZones where articleid="&articleid
	set rs=conn.execute(psql)
	zones=","
	do until rs.eof
		zones=zones & rs("zoneid")&","
		rs.movenext
	loop
	rs.close
	set rs=nothing

	if articleurl="" then articletype=0 else articletype=1
	
	'/// If editors / admins have to check and status is not pending then logout
	if onlyadmins<>"" and lvl=0 and status<>2 then response.redirect "logout.asp"
end if

if enddate="-" then neverexpires="checked" : enddate=date
if not(isdate(startdate)) then startdate=date
if (not(isdate(enddate)) and neverexpires="") then enddate=date

'/// retrieve my zones ///
if lvl=0 then 
	zonespsql="select * from vPublisherszones where publisherid="&usrid
else
	zonespsql="select * from zones"
end if
zonespsql=zonespsql & " order by zonename asc;"
set rs=conn.execute(zonespsql)
if rs.eof then zonesfound=0 else zonesfound=1
rs.close
set rs=nothing

if editor=1 then
	e1="checked"
	e0=""
	txtstyle="display:none"
else
	e0="checked"
	e1=""
	htmlstyle="display:none"
end if
if articleid=0 then
	enddate=dateadd("m",1,now)
end if

'/// Is Archives Browsing enabled (Only Admins 6 Editors) ?
if lvl>0 and archiveaccess<>"" then maxstatus=4 else maxstatus=3

if autoformat="" and editor=0 then newarticle=article
%>
<html>
<head>
<title><%=title%></title>
<meta http-equiv="Content-Type" content="text/html; charset=<%=charset%>">
<script language="JavaScript">
function toggle(showthis,hidethis,runoperation){
	expression1='document.all.' + showthis + '.style.display=\'\'';
	expression2='document.all.' + hidethis + '.style.display=\'none\'';
	expression3=runoperation + '()'
	eval(expression1);
	eval(expression2);
	eval(expression3);
}

function passdata(){
	if (document.all.txtview.style.display=='') transferValue();
	 else copyValue();
}


function BreakItUp()
{
  //Set the limit for field size.
  var FormLimit = 102399

  //Get the value of the large input object.
  var TempVar = new String
  TempVar = document.form1.article.value

  //If the length of the object is greater than the limit, break it
  //into multiple objects.
  if (TempVar.length > FormLimit)
  {
    document.form1.article.value = TempVar.substr(0, FormLimit)
    TempVar = TempVar.substr(FormLimit)

    while (TempVar.length > 0)
    {
      var objTEXTAREA = document.createElement("TEXTAREA")
      objTEXTAREA.name = "article"
      objTEXTAREA.value = TempVar.substr(0, FormLimit)
      document.form1.appendChild(objTEXTAREA)
      TempVar = TempVar.substr(FormLimit)
    }
  }
}


function dotest(){
	alert(form1.article.value);
}

function window.onload(){
	var thecontent=articletemp.innerHTML;
	<%if newarticle="" then response.write "form1.article.value=thecontent;"%>
	transferValue();
	showtype();
}

function showtype(){
	if (form1.articletype.value=='1'){
		 aurl.style.display=''
	} else {
		aurl.style.display='none';
	}
}
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000">
<form name="form1" method="post" action="editarticle1.asp" onsubmit="javascript:passdata();BreakItUp()">
  <table width="96%" border="0" cellspacing="2" cellpadding="2" align="center">
    <tr> 
      <td width="23%"><font size="2" face="Arial, Helvetica, sans-serif"><b><img src="images/icArticle.gif" width="20" height="16" align="absmiddle"> 
        Edit Article</b></font></td>
      <td width="77%">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="2" bgcolor="#666666"></td>
    </tr>
    <%if errormsg<>"" then%>
    <tr> 
      <td colspan="2"><font face="Arial, Helvetica, sans-serif" size="2" color="#FF0000"><b>Error 
        - The article could not be saved :</b></font> <font size="2" face="Arial, Helvetica, sans-serif"><%=errormsg%></font></td>
    </tr>
    <%end if
	if zonesfound=0 then%>
    <tr> 
      <td colspan="2"> 
        <div align="center"> 
          <p>&nbsp;</p>
          <p>&nbsp;</p>
          <p><font size="2" face="Arial, Helvetica, sans-serif"><b><font color="#FF0000">You 
            have no assigned zones</font><font color="#FF0000"><br>
            In order to edit or create an article you must have at least one zone 
            </font><font size="2" face="Arial, Helvetica, sans-serif" color="#FF0000">assigned</font><font color="#FF0000"> 
            <br>
            <br>
            <font size="2" face="Tahoma, Verdana, Arial"> <br>
            <%if lvl=2 then%>
            <a href="editzone.asp"><img src="images/btnZone2.gif" width="114" height="18" border="0" alt="Create a New Zone"> 
            </a> 
            <%end if%>
            </font> </font></b></font></p>
        </div>
      </td>
    </tr>
    <%else%>
    <tr> 
      <td colspan="2" bgcolor="#003399"><font face="Arial, Helvetica, sans-serif" size="3" color="#FFFFFF"><b>Article 
        Properties &amp; Content</b></font></td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="23%" bgcolor="#CCCCCC"><b><font face="Arial, Helvetica, sans-serif" size="2">Headline 
        :</font></b></td>
      <td width="77%" bgcolor="#F3F3F3"> 
        <input type="text" name="headline" size="50" value="<%=server.HTMLEncode(headline & "")%>" maxlength="255">
        <input type="hidden" name="articleid" value="<%=articleid%>">
      </td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="23%" bgcolor="#CCCCCC"><b><font face="Arial, Helvetica, sans-serif" size="2">Headline 
        Date :</font></b></td>
      <td width="77%" bgcolor="#F3F3F3"> 
        <input type="text" name="headlinedate" size="30" value="<%=headlinedate%>" maxlength="255">
        <input type="button" name="Button" value="Insert Current Date" onclick="form1.headlinedate.value='<%=formatdatetime(date,1)%>';"> </td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="23%" bgcolor="#CCCCCC"><b><font face="Arial, Helvetica, sans-serif" size="2">Source 
        :</font></b></td>
      <td width="77%" bgcolor="#F3F3F3"> 
        <input type="text" name="source" size="50" value="<%=source%>">
      </td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="23%" bgcolor="#CCCCCC"><b><font face="Arial, Helvetica, sans-serif" size="2">Start 
        Date :</font></b></td>
      <td width="77%" bgcolor="#F3F3F3"><font size="1" face="Arial, Helvetica, sans-serif"> 
        (mm/dd/yyyy) 
        <select name="month1">
          <%
			  	for x=1 to 12
				if x=month(startdate) then sel=" selected" else sel=""
					response.write "<option"&sel&">"& right("0" & x ,2) & "</option>"
				next
			  %>
        </select>
        / 
        <select name="day1">
          <%
			  	for x=1 to 31
				if x=day(startdate) then sel=" selected" else sel=""
					response.write "<option"&sel&">"& right("0" & x ,2) & "</option>"
				next
			  %>
        </select>
        / 
        <select name="year1">
          <%
			  a=year(startdate)
			  for x=a-50 to a+50
			  	if x=a then sel=" selected" else sel=""
			  	response.write "<option"&sel&">"& x&"</option>"	
			  next 
			  %>
        </select>
        <br>
        Date that the headline will start showing on the zones</font></td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="23%" bgcolor="#CCCCCC"><b><font face="Arial, Helvetica, sans-serif" size="2">End 
        Date :</font></b></td>
      <td width="77%" bgcolor="#F3F3F3"> <font size="1" face="Arial, Helvetica, sans-serif">(mm/dd/yyyy) 
        <select name="month2">
          <%
			  	for x=1 to 12
				if x=month(enddate) then sel=" selected" else sel=""
					response.write "<option"&sel&">"& right("0" & x ,2) & "</option>"
				next
			  %>
        </select>
        / 
        <select name="day2">
          <%
			  	for x=1 to 31
				if x=day(enddate) then sel=" selected" else sel=""
					response.write "<option"&sel&">"& right("0" & x ,2) & "</option>"
				next
			  %>
        </select>
        / 
        <select name="year2">
          <%
			  a=year(enddate)
			  for x=a-50 to a+50
			  	if x=a then sel=" selected" else sel=""
			  	response.write "<option"&sel&">"& x&"</option>"	
			  next 
			  %>
        </select>
        <input type="checkbox" name="neverexpires" value="checked" <%=neverexpires%>>
        <font size="2">Never Expires</font><br>
        Date that the headline will stop showing on the zones</font></td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="23%" bgcolor="#CCCCCC"><b><font face="Arial, Helvetica, sans-serif" size="2">Status 
        :</font></b></td>
      <td width="77%" bgcolor="#F3F3F3"> <font size="1" face="Arial, Helvetica, sans-serif"> 
        <%if onlyadmins<>"" and lvl=0 then%>
        <font size="2"><b>Pending</b></font> 
        <%else%>
        <select name="status">
          <%
		if status="" or not(isnumeric(status)) then status=0
		for x=1 to maxstatus
			if x-status=0 then sel=" selected" else sel=""
			response.write "<option value="&x&sel&">"&whichstatus(x)&"</option>"
		next
		%>
        </select>
        <%end if %>
        </font></td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="23%" bgcolor="#CCCCCC"><b><font face="Arial, Helvetica, sans-serif" size="2">Zones 
        :</font></b></td>
      <td width="77%" bgcolor="#F3F3F3"> 
        <select name="zones" size="4" multiple>
          <%set rs=conn.execute(zonespsql)
		do until rs.eof
			if instr(","&zones&",",","&rs("zoneid")&",")<>0 then sel=" selected" else sel=""
			response.write "<option value="&rs("zoneid")&sel&">"&rs("zonename")&"</option>"
		rs.movenext
		loop
		rs.close
		set rs=nothing%>
        </select>
        <br>
        <font size="1" face="Arial, Helvetica, sans-serif">Select the Zones (categories) 
        to classify your articles</font> </td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="23%" bgcolor="#CCCCCC"><b><font face="Arial, Helvetica, sans-serif" size="2">Summary 
        :</font></b></td>
      <td width="77%" bgcolor="#F3F3F3"> <font size="1" face="Arial, Helvetica, sans-serif"> 
        <textarea name="summary" cols="46"><%=summary%></textarea>
        <br>
        Enter a short summary for the article</font></td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="23%" bgcolor="#CCCCCC"><font face="Arial, Helvetica, sans-serif" size="2"><b>Article 
        Type : </b></font></td>
      <td width="77%" bgcolor="#F3F3F3"> 
        <select name="articletype" onChange="javascript:showtype()">
          <%if articletype="" or not(isnumeric(articletype)) then articletype=0
		for x=0 to 1
			if x-articletype=0 then sel=" selected" else sel=""
			response.write "<option value="&x&sel&">"&getarticletype(x)&"</option>"
		next		
		%>
        </select>
        <span id="aurl" style="<%=aurl%>"><font face="Arial, Helvetica, sans-serif" size="2">- 
        URL : 
        <input type="text" name="articleurl" size="30" value="<%=articleurl%>">
        <input type="button" value="Open" onClick="javascript:window.open(form1.articleurl.value);" name="button2">
        </font></span></td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="23%" bgcolor="#CCCCCC"><b><font face="Arial, Helvetica, sans-serif" size="2"> 
        Article :</font></b></td>
      <td width="77%" bgcolor="#F3F3F3"><font face="Arial, Helvetica, sans-serif" size="2"><b> 
        <input type="radio" name="editor" value="0" <%=e0%> onclick="javascript:toggle('txtview','htmlview','copyValue');">
        Text Editor&nbsp; &nbsp; 
        <input type="radio" name="editor" value="1" <%=e1%> onclick="javascript:toggle('htmlview','txtview','transferValue');">
        On-Line HTML editor </b></font></td>
    </tr>
    <tr align="left" valign="top" id="txtview" style="<%=txtstyle%>"> 
      <td bgcolor="#CCCCCC">&nbsp;</td>
      <td  bgcolor="#F3F3F3"> 
        <textarea name="article" cols="60" rows="14"><%=newarticle%></textarea>
        <br>
        <font face="Arial, Helvetica, sans-serif" size="2"> <b> 
        <input type="checkbox" name="autoformat" value="checked" <%=autoformat%>>
        Don't Auto Format <br>
        </b><font size="1">(Check this option if you're pasting pure HTML Code)</font></font></td>
    </tr>
    <tr align="left" valign="top" id="htmlview" style="<%=htmlstyle%>"> 
      <td bgcolor="#CCCCCC"></td>
      <td  bgcolor="#F3F3F3"><!--#include file="incHTMLEditor.asp" --></td>
    </tr>
    <%if lvl>0 and articleid>0  then
	psql="select * from publishers where publisherid in (select publisherid from publisherszones where zoneid in (select zoneid from iArticlesZones where articleid="&articleid&")) or plevel=2 "
	set rs=conn.execute(psql)
	if not(rs.eof) then%>
    <tr> 
      <td width="23%" bgcolor="#CCCCCC"><font face="Arial, Helvetica, sans-serif" size="2"><b>Publisher 
        : </b></font></td>
      <td width="77%" bgcolor="#F3F3F3"> 
        <select name="publisherid">
          <%do until rs.eof
			if publisherid-rs("publisherid")=0 then sel=" selected" else sel=""
			response.write "<option value="&rs("publisherid")&sel&">"&rs("name")&" ("&whichlevel(rs("plevel"))&")</option>"
		rs.movenext
		loop%>
        </select>
      </td>
    </tr>
    <%end if
	rs.close
	set rs=nothing
	end if%>
    <tr> 
      <td width="23%"> </td>
      <td width="77%"> 
        <input type="submit" name="button" value="Images and Files">
        <input type="submit" name="button" value="Related Articles">
        <input type="submit" name="button" value="Save Article">
      </td>
    </tr>
    <%end if '/// Zones=""%>
  </table>
</form>
<div id="articletemp" style="display:none"><%=article%></div>
</body>
</html>
<%conn.close
set conn=nothing%>
