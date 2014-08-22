<!-- #include file="incSystem.asp" -->
<%
lvl=validate(2)

feedid=request("feedid")
if feedid="" or not(isnumeric(feedid)) then feedid=0
set conn=server.createobject("ADODB.Connection")
conn.open connection

'/// receive data ///
feedname=request("feedname")
description=request("description")
feedurl=request("feedurl")
pourtozones=replace(request("pourtozones")," ","")
articlespz=request("articlespz")
if articlespz="" or not(isnumeric(articlespz)) then articlespz=0
feedfont=request("feedfont")&""
fontsize=request("fontsize")&""
fontcolor=request("fontcolor")&""
showsummary=request("showsummary")&""
showdates=request("showdates")&""
displayhoriz=request("displayhoriz")&""
textalign=request("textalign")
cellcolor=request("cellcolor")&""
targetframe=request("targetframe")&""
allowpouring=request("allowpouring") & ""
pourtozones=replace(request("pourtozones")," ","")
if pourtozones="" then pourtozones="0"

if request("button")<>"" then
	if feedname=""  then errormsg="Please provide a name for the newsfeed<br>"
	if len(feedurl)<=9 then errormsg=errormsg & "Please provide a valid source (URL) for the newsfeed"
	
	
	'/// Save feed's Info ///
	if errormsg="" then
		psql="select * from xlaPPLNGfeeds where feedid="&feedid
		Set rs = Server.CreateObject("ADODB.Recordset") 
		rs.open psql,conn,1,2
		if rs.eof then 
			rs.addnew
			rs("lastpourdate")=""
		end if
		rs("feedname")=feedname
		rs("description")=description
		rs("feedurl")=feedurl
		rs("articlespz")=articlespz
		rs("feedfont")=feedfont
		rs("fontsize")=fontsize
		rs("fontcolor")=fontcolor
		rs("showsummary")=showsummary
		rs("showdates")=showdates
		rs("displayhoriz")=displayhoriz
		rs("textalign")=textalign
		rs("cellcolor")=cellcolor
		rs("targetframe")=targetframe
		rs("allowpouring")=allowpouring
		rs("pourtozones")=pourtozones
		rs.Update 
		feedid=rs("feedid")
		rs.close
		set rs=nothing
	
		conn.close
		set conn=nothing
		response.redirect "PPL.NG.asp"
	end if
	
elseif feedid>0  then
	psql="select * from xlaPPLNGfeeds where feedid="&feedid
	set rs=conn.execute(psql)
	
	feedname=rs("feedname")
	description=rs("description")
	feedurl=rs("feedurl")
	articlespz=rs("articlespz")
	feedfont=rs("feedfont")
	fontsize=rs("fontsize")
	fontcolor=rs("fontcolor")
	showsummary=rs("showsummary")
	showdates=rs("showdates")
	displayhoriz=rs("displayhoriz")
	textalign=rs("textalign")
	cellcolor=rs("cellcolor")
	targetframe=rs("targetframe")
	allowpouring=rs("allowpouring")
	pourtozones=rs("pourtozones")
	
	rs.close
	set rs=nothing
end if
if feedurl="" then feedurl="http://"

%>
<html>
<head>
<title><%=title%></title>
<meta http-equiv="Content-Type" content="text/html; charset=<%=charset%>">
<script language="JavaScript">

function pickcolor(tfield){
	var arr = showModalDialog("selcolor.htm","","font-family:Verdana; font-size:12; dialogWidth:30em; dialogHeight:17em" );
	if (arr != null) eval('form1.' + tfield +'.value=arr;');
}
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000">
<form name="form1" method="post" action="PPL.NG.editfeed.asp">

  <table width="96%" border="0" cellspacing="2" cellpadding="2" align="center">
    <tr valign="top" align="left"> 
      <td><b><font size="2" face="Arial, Helvetica, sans-serif"><img src="PPL.NG/rss.gif" width="36" height="14" align="absmiddle"> 
        Edit Newsfeed</font></b></td>
      <td align="right"> <a href="PPL.NG.asp"><img src="PPL.NG/btnListFeeds.gif" width="114" height="18" border="0" alt="Show / List feeds"></a> 
        <%if feedid>0 then%> <script language="JavaScript">
			function deletefeed(){
				if (confirm('Delete this newsfeed?')){
					self.location='PPL.NG.asp?kill=<%=feedid%>';
				}
			}
			
</script> <a href="javascript:deletefeed()"><img src="PPL.NG/btnDeletefeed.gif" width="114" height="18" alt="Delete feed" border="0"></a> 
        <%end if%> </td>
    </tr>
    <tr> 
      <td colspan="2" bgcolor="#666666"></td>
    </tr>
    <%if errormsg<>"" then%>
    <tr> 
      <td colspan="2"><font color="#FF0000" face="Arial, Helvetica, sans-serif" size="2"><b>Error 
        - The feed Could Not Be Created :</b></font><font face="Arial, Helvetica, sans-serif" size="2"><br>
        <%=errormsg%></font></td>
    </tr>
    <%end if%>
    <tr valign="top" align="left"> 
      <td width="27%" bgcolor="#CCCCCC"><b><font size="2" face="Arial, Helvetica, sans-serif">Newsfeed 
        Name :</font></b></td>
      <td bgcolor="#F3F3F3" width="73%"><b><font size="2" face="Arial, Helvetica, sans-serif"> 
        <input type="text" name="feedname" size="50" value="<%=feedname%>" maxlength="250" >
        </font></b></td>
    </tr>
    <tr valign="top" align="left"> 
      <td bgcolor="#CCCCCC"><font size="2" face="Arial, Helvetica, sans-serif"><b>Newsfeed 
        Source (URL) : </b></font></td>
      <td  bgcolor="#F3F3F3"><b><font size="2" face="Arial, Helvetica, sans-serif"> 
        <input name="feedurl" type="text" id="feedurl" value="<%=feedurl%>" size="50" maxlength="250" >
        </font></b></td>
    </tr>
    <tr valign="top" align="left"> 
      <td width="27%" bgcolor="#CCCCCC"><b><font size="2" face="Arial, Helvetica, sans-serif">Description 
        :</font></b></td>
      <td colspan="2" bgcolor="#F3F3F3" width="73%"><b><font size="2" face="Arial, Helvetica, sans-serif"> 
        <textarea name="description" cols="46" ><%=description%></textarea>
        </font></b></td>
    </tr>
    <tr valign="top" align="left"> 
      <td width="27%" bgcolor="#CCCCCC"><font face="Arial, Helvetica, sans-serif" size="2"><b>Number 
        of headlines : </b></font></td>
      <td  bgcolor="#F3F3F3" width="73%"> <font size="2" face="Arial, Helvetica, sans-serif">Display 
        the top 
        <input type="text" name="articlespz" value="<%=articlespz%>" size="12" maxlength="8">
        Headlines </font><br> <font face="Arial, Helvetica, sans-serif" size="1">Max. 
        Numbers of headlines to be displayed per feed, Type 0 Zero to display 
        all</font></td>
    </tr>
    <tr valign="top" align="left"> 
      <td width="27%" bgcolor="#CCCCCC"><font face="Arial, Helvetica, sans-serif" size="2"><b>Display 
        :</b></font></td>
      <td  bgcolor="#F3F3F3" width="73%"> <font face="Arial, Helvetica, sans-serif" size="2">Cell 
        Color (Leave Blank for Transparent) : 
        <input type="text" name="cellcolor" size="8" value="<%=cellcolor%>" maxlength="8">
        <a href="javascript:pickcolor('cellcolor');"><img src="images/bgcolor.GIF" width="23" height="22" align="absmiddle" alt="Color Picker" border="1"></a><br>
        <input type="checkbox" name="displayhoriz" value="checked" <%=displayhoriz%>>
        Display Headlines Horizontally<br>
        <font size="1">Check this option to display the feed's headlines Horizontally. 
        otherwise they'll be displayed vertically<br>
        Not Recommended if the Number of headlines is unlimited</font></font></td>
    </tr>
    <tr valign="top" align="left"> 
      <td width="27%" bgcolor="#CCCCCC"><b><font face="Arial, Helvetica, sans-serif" size="2"> 
        Listing Options :</font></b></td>
      <td  bgcolor="#F3F3F3" width="73%"><font face="Arial, Helvetica, sans-serif" size="2"> 
        Align : 
        <select name="textalign">
          <%if textalign<>"" then response.write "<option>"&textalign&"</option>"%>
          <option>Left</option>
          <option>Center</option>
          <option>Right</option>
        </select>
        Font : 
        <select name="feedfont">
          <%if feedfont<>"" then response.write "<option>"&feedfont&"</option>"%>
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
        <input type="checkbox" name="showsummary" value="checked" <%=showsummary%>>
        Show Summaries<br>
        <input type="checkbox" name="showdates" value="checked" <%=showdates%>>
        Show Headline's Dates</font></td>
    </tr>
    <tr valign="top" align="left"> 
      <td width="27%" bgcolor="#CCCCCC"><font face="Arial, Helvetica, sans-serif" size="2"><b>Target 
        Frame : </b></font></td>
      <td bgcolor="#F3F3F3" width="73%"> <input type="text" name="targetframe" value="<%=targetframe%>" size="40" maxlength="250"> 
        <br> <font face="Arial, Helvetica, sans-serif" size="1">If you want the 
        articles from this feed to open in a new frame or window, enter the target 
        here.<br>
        To open the articles in the same page, leave it blank</font></td>
    </tr>
    <tr valign="top" align="left"> 
      <td width="27%" bgcolor="#CCCCCC"><font face="Arial, Helvetica, sans-serif" size="2"> 
        <b>Pour to Zones :</b></font></td>
      <td bgcolor="#F3F3F3" width="73%"><font size="2" face="Arial, Helvetica, sans-serif"> 
        <input type="checkbox" name="allowpouring" value="checked" <%=allowpouring%>>
        Allow pouring of the newsfeed content to database<font size="1"><br>
        Select this option if you want to download the newsfeed's headlines into 
        the database for browsing and inclusion in your zones</font><br>
        <br>
        Zones :<br>
        <select name="pourtozones" size="8" multiple id="pourtozones">
          <%
		psql="select zoneid,zonename from zones order by zonename asc;"
		set rs=conn.execute(psql)
		do until rs.eof
			if instr(","&pourtozones&",",","& rs("zoneid")&",")<>0 then sel=" selected" else sel=""
			response.write "<option value='"&rs("zoneid")&"'"&sel&">"&rs("zonename")&"</option>"
			rs.movenext
		loop
		rs.close
		set rs=nothing
		conn.close
		set conn=nothing
		%>
        </select>
        </font></td>
    </tr>
    <tr valign="top" align="left"> 
      <td width="27%" bgcolor="#CCCCCC"> <input type="hidden" name="feedid" value="<%=feedid%>"> 
      </td>
      <td colspan="2" bgcolor="#F3F3F3" width="73%"> <input type="submit" name="button" value="Save Feed"> 
      </td>
    </tr>
  </table>
  <p>
</form>
</body>
</html>
