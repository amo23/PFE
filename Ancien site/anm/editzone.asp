<!-- #include file="incSystem.asp" -->
<%
lvl=validate(0)
if lvl<2 then lock="readonly"

zoneid=request("zoneid")
if zoneid="" or not(isnumeric(zoneid)) then zoneid=0
set conn=server.createobject("ADODB.Connection")
conn.open connection

'/// receive data ///
if lvl=2 then
	zonename=request("zonename")
	description=right(request("description"),900)
	publishers=replace(request("publishers")," ","")
	template=request("template")
	articlespz=request("articlespz")
	if articlespz="" or not(isnumeric(articlespz)) then articlespz=0
	zonefont=request("zonefont")&""
	fontsize=request("fontsize")&""
	fontcolor=request("fontcolor")&""
	showsummary=request("showsummary")&""
	showsource=request("showsource")&""
	showdates=request("showdates")&""
	showtn=request("showtn")&""
	displayhoriz=request("displayhoriz")&""
	textalign=request("textalign")
	cellcolor=request("cellcolor")&""
	targetframe=request("targetframe")&""
end if

if request("button")<>"" and lvl=2 then
	if zonename=""  then
		errormsg="You must provide a name for the zone"
	end if
	
	if template="" then
		errormsg="No Template File Provided"
	else
		Set Fs=createobject("scripting.filesystemobject")
		if not(fs.fileexists(server.mappath("templates/"&template))) then errormsg="File '"&template&"' not found in the templates folder"
		set fs=nothing
	end if
	
	'/// Save zone's Info ///
	if errormsg="" then
		psql="select * from zones where zoneid="&zoneid
		Set rs = Server.CreateObject("ADODB.Recordset") 
		rs.open psql,conn,1,2
		if rs.eof then rs.addnew
		rs("zonename")=zonename
		rs("description")=description
		rs("template")=template
		rs("articlespz")=articlespz
		rs("zonefont")=zonefont
		rs("fontsize")=fontsize
		rs("fontcolor")=fontcolor
		rs("showsummary")=showsummary
		rs("showdates")=showdates
		rs("showtn")=showtn
		rs("displayhoriz")=displayhoriz
		rs("textalign")=textalign
		rs("cellcolor")=cellcolor
		rs("showsource")=showsource
		rs("targetframe")=targetframe
		rs.Update 
		zoneid=rs("zoneid")
		rs.close
		set rs=nothing
		
		'/// Save Zone Publishers ///
		psql="delete from publisherszones where zoneid="&zoneid
		conn.execute(psql)
		
		thepublishers=split(publishers,",")
		set rs=server.createobject("ADODB.Recordset")
		rs.open "publisherszones",conn,1,3,2
		for x=0 to ubound(thepublishers)
			rs.addnew
			rs("zoneid")=zoneid
			rs("publisherid")=thepublishers(x)
			rs.update
		next
		rs.close
		set rs=nothing
		conn.close
		set conn=nothing
		response.redirect "zones.asp"
	end if
	
elseif zoneid>0  then
	psql="select * from zones where zoneid="&zoneid
	if pblzones<>"" and lvl=0 then psql=psql & " and zoneid in (select zoneid from vPublishersZones where publisherid="&usrid&")"
	set rs=conn.execute(psql)
	if rs.eof then
		rs.close
		set rs=nothing
		conn.close
		set conn=nothing
		response.redirect "logout.asp"
	end if
	
	zonename=rs("zonename")
	description=rs("description")
	template=rs("template")
	articlespz=rs("articlespz")
	zonefont=rs("zonefont")
	fontsize=rs("fontsize")
	fontcolor=rs("fontcolor")
	showsummary=rs("showsummary")
	showdates=rs("showdates")
	showtn=rs("showtn")
	displayhoriz=rs("displayhoriz")
	textalign=rs("textalign")
	cellcolor=rs("cellcolor")
	showsource=rs("showsource")
	targetframe=rs("targetframe")
	
	'/// Publishers ///
	publishers=","
	psql="select * from publisherszones where zoneid="&zoneid
	set rs=conn.execute(psql)
	do until rs.eof
		publishers=publishers & rs("publisherid") & ","
		rs.movenext
	loop
	rs.close
	set rs=nothing
end if
if template="" then template="template.htm"
if articlespz="" or not(isnumeric(articlespz)) then articlespz=0
if fontcolor="" then fontcolor="#000000"

%>
<html>
<head>
<title><%=title%></title>
<meta http-equiv="Content-Type" content="text/html; charset=<%=charset%>">
<script language="JavaScript">
function preview(){
	var thefile=form1.template.value;
	if (thefile!='') {
		window.open('templates/' + thefile);
	} else {
		alert('No Template File To Preview');
	}
}

function pickcolor(tfield){
	var arr = showModalDialog("selcolor.htm","","font-family:Verdana; font-size:12; dialogWidth:30em; dialogHeight:17em" );
	if (arr != null) eval('form1.' + tfield +'.value=arr;');
}
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000">
<form name="form1" method="post" action="editzone.asp">

  <table width="96%" border="0" cellspacing="2" cellpadding="2" align="center">
    <tr valign="top" align="left"> 
      <td colspan="2"> 
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td><b><font size="2" face="Arial, Helvetica, sans-serif"><img src="images/icZones.gif" width="20" height="19" align="absmiddle"> 
              Edit / View zone</font></b></td>
            <td align="right"> <a href="zones.asp"><img src="images/btnShowZones.gif" width="114" height="18" border="0" alt="Show / List Zones"></a> 
              <%if lvl=2 and zoneid>0 then%>
              <script language="JavaScript">
			function deletezone(){
				if (confirm('Delete this zone?')){
					self.location='zones.asp?kill=<%=zoneid%>';
				}
			}
			
</script>
              <a href="javascript:deletezone()"><img src="images/btnDeleteZone2.gif" width="114" height="18" alt="Delete Zone" border="0"></a> 
              <%end if%>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td colspan="2" bgcolor="#666666"></td>
    </tr>
    <%if errormsg<>"" then%>
    <tr> 
      <td colspan="2"><font color="#FF0000" face="Arial, Helvetica, sans-serif" size="2"><b>Error 
        - The Zone Could Not Be Created : <%=errormsg%></b></font></td>
    </tr>
    <%end if%>
    <tr valign="top" align="left"> 
      <td width="27%" bgcolor="#CCCCCC"><b><font size="2" face="Arial, Helvetica, sans-serif">Zone 
        Name :</font></b></td>
      <td colspan="2" bgcolor="#F3F3F3" width="73%"><b><font size="2" face="Arial, Helvetica, sans-serif"> 
        <input type="text" name="zonename" size="50" value="<%=zonename%>" maxlength="250" <%=lock%>>
        </font></b></td>
    </tr>
    <tr valign="top" align="left"> 
      <td width="27%" bgcolor="#CCCCCC"><b><font size="2" face="Arial, Helvetica, sans-serif">Description 
        :</font></b></td>
      <td colspan="2" bgcolor="#F3F3F3" width="73%"><b><font size="2" face="Arial, Helvetica, sans-serif"> 
        <textarea name="description" cols="46" <%=lock%>><%=description%></textarea>
        </font></b></td>
    </tr>
    <tr valign="top" align="left"> 
      <td width="27%" bgcolor="#CCCCCC"><font face="Arial, Helvetica, sans-serif" size="2"><b>Template 
        : </b></font></td>
      <td colspan="2" bgcolor="#F3F3F3" width="73%"><b><font size="2" face="Arial, Helvetica, sans-serif"> 
        <input type="text" name="template" size="50" value="<%=template%>" maxlength="250" <%=lock%>>
        <input type="button" name="Button" value="Preview" onclick="javascript:preview();">
        <br>
        </font></b><font size="1" face="Arial, Helvetica, sans-serif">Templates 
        should be either .asp or .htm files<br>
        All Template files must be located in the templates folder of the application 
        directory<br>
        ASP Templates cannot be previewed as they're automatically executed to 
        look for an article</font></td>
    </tr>
    <tr valign="top" align="left"> 
      <td width="27%" bgcolor="#CCCCCC"><font face="Arial, Helvetica, sans-serif" size="2"><b>Headlines 
        Per Zone :</b></font></td>
      <td colspan="2" bgcolor="#F3F3F3" width="73%"> 
        <input type="text" name="articlespz" value="<%=articlespz%>" size="12" maxlength="8">
        <br>
        <font face="Arial, Helvetica, sans-serif" size="1">Max. Numbers of headlines 
        to be displayed per zone, Type 0 Zero for Unlimited</font></td>
    </tr>
    <tr valign="top" align="left"> 
      <td width="27%" bgcolor="#CCCCCC"><font face="Arial, Helvetica, sans-serif" size="2"><b>Display 
        :</b></font></td>
      <td colspan="2" bgcolor="#F3F3F3" width="73%"> <font face="Arial, Helvetica, sans-serif" size="2">Cell 
        Color (Leave Blank for Transparent) : 
        <input type="text" name="cellcolor" size="8" value="<%=cellcolor%>" maxlength="8">
        <a href="javascript:pickcolor('cellcolor');"><img src="images/bgcolor.GIF" width="23" height="22" align="absmiddle" alt="Color Picker" border="1"></a><br>
        <input type="checkbox" name="displayhoriz" value="checked" <%=displayhoriz%>>
        Display Headlines Horizontally<br>
        <font size="1">Check this option to display your headlines Horizontally 
        otherwise they'll be displayed vertically<br>
        Not Recommended if the Number of headlines is unlimited</font></font></td>
    </tr>
    <tr valign="top" align="left"> 
      <td width="27%" bgcolor="#CCCCCC"><b><font face="Arial, Helvetica, sans-serif" size="2">Headline 
        Listing Options :</font></b></td>
      <td colspan="2" bgcolor="#F3F3F3" width="73%"><font face="Arial, Helvetica, sans-serif" size="2"> 
        Align : 
        <select name="textalign">
          <%if textalign<>"" then response.write "<option>"&textalign&"</option>"%>
          <option>Left</option>
          <option>Center</option>
          <option>Right</option>
        </select>
        Font : 
        <select name="zonefont">
          <%if zonefont<>"" then response.write "<option>"&zonefont&"</option>"%>
          <option>Arial</option>
          <option>Verdana</option>
          <option>Courier</option>
          <option>Helvetica</option>
          <option>Geneva</option>
          <option>Times</option>
        </select>
        Size : 
        <select name="fontsize">
          <%if fontsize<>"" then response.write "<option>"&fontsize&"</option>"%>
          <option>1</option>
          <option>2</option>
          <option>3</option>
          <option>4</option>
          <option>5</option>
          <option>6</option>
          <option>7</option>
        </select>
        Color : 
        <input type="text" name="fontcolor" size="8" value="<%=fontcolor%>" maxlength="8">
        <a href="javascript:pickcolor('fontcolor');"><img src="images/fgcolor.GIF" width="23" height="22" align="absmiddle" alt="Color Picker" border="1"></a><br>
        <input type="checkbox" name="showsource" value="checked" <%=showsource%>>
        Show Source<br>
        <input type="checkbox" name="showsummary" value="checked" <%=showsummary%>>
        Show Summaries<br>
        <input type="checkbox" name="showdates" value="checked" <%=showdates%>>
        Show Headline's Dates<br>
        <input type="checkbox" name="showtn" value="checked" <%=showtn%>>
        Show Article Thumbnails </font></td>
    </tr>
    <tr valign="top" align="left"> 
      <td width="27%" bgcolor="#CCCCCC"><font face="Arial, Helvetica, sans-serif" size="2"><b>Target 
        Frame : </b></font></td>
      <td colspan="2" bgcolor="#F3F3F3" width="73%"> 
        <input type="text" name="targetframe" value="<%=targetframe%>" size="40" maxlength="250">
        <br>
        <font face="Arial, Helvetica, sans-serif" size="1">If you want the articles 
        from this zone to open in a new frame or window, enter the target here.<br>
        To open the articles in the same page, leave it blank</font></td>
    </tr>
    <tr valign="top" align="left"> 
      <td width="27%" bgcolor="#CCCCCC"><font face="Arial, Helvetica, sans-serif" size="2"><b> 
        Assigned Users : </b></font></td>
      <td colspan="2" bgcolor="#F3F3F3" width="73%"><b><font size="2" face="Arial, Helvetica, sans-serif"> 
        <select name="publishers" size="8" multiple>
          <%
		psql="select * from publishers order by plevel desc,name asc;"
		set rs=conn.execute(psql)
		do until rs.eof
			if instr(","&publishers&",",","& rs("publisherid")&",")<>0 then sel=" selected" else sel=""
			response.write "<option value='"&rs("publisherid")&"'"&sel&">"&rs("name")&" ("&whichlevel(rs("plevel"))&")</option>"
			rs.movenext
		loop
		rs.close
		set rs=nothing
		conn.close
		set conn=nothing
		%>
        </select>
        </font></b></td>
    </tr>
    <%if lvl=2 then%>
    <tr valign="top" align="left"> 
      <td width="27%" bgcolor="#CCCCCC"> 
        <input type="hidden" name="zoneid" value="<%=zoneid%>">
      </td>
      <td colspan="2" bgcolor="#F3F3F3" width="73%"> 
        <input type="submit" name="button" value="Save Zone">
      </td>
    </tr>
    <%end if%>
  </table>
  <p>
</form>
</body>
</html>
