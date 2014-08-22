<!--#include file="incSystem.asp" -->
<!--#include file="incEmail.asp" -->
<%
if allowpostcards="" then response.redirect "gallery.asp"
postcardid=request("postcardid")
i=request("i")
bgcolor=request("bgcolor")
bgsound=request("bgsound")
imageid=request("imageid")
bgcolor=request("bgcolor")
bordercolor=request("bordercolor")
fonttype=request("fonttype")
fontcolor=request("fontcolor")
recipientname=request("recipientname")
recipientemail=request("recipientemail")
greeting=request("greeting")
customgreeting=request("customgreeting")
if customgreeting<>"" then greeting=customgreeting
bgmusic=request("bgmusic")
sendername=request("sendername")
senderemail=request("senderemail")
sendermsg=request("sendermsg")

dim ispc
ispc="1"

set conn=server.createobject("ADODB.Connection")
conn.open connection


if postcardid<>"" and i<>"" then
	'/// Retrieve Postcard
	psql="select * from xlaAIGPostcards where postcardid='"&postcardid&"' and imageid="&i
	set rs=conn.execute(psql)
	if not(rs.eof) then
		found=1
		imageid=i
		bgcolor=rs("bgcolor")
		bordercolor=rs("bordercolor")
		fonttype=rs("fonttype")
		fontcolor=rs("fontcolor")
		recipientname=rs("recipientname")
		greeting=rs("greeting")
		bgsound=rs("bgsound")
		sendername=rs("sendername")
		sendermsg=rs("sendermsg")
	end if
	rs.close
	set rs=nothing
	if found<>1 then
		conn.close
		set conn=nothing
		response.redirect "gallery.asp"
	end if
elseif request("sendpostcard")<>"" then
	'/// Save Postcard
	if instr(senderemail,"@")=0 or len(senderemail)<6 or instr(senderemail,".")=0 then errormsg="Please provide your e-mail address"
	if instr(recipientemail,"@")=0 or len(recipientemail)<6 or instr(recipientemail,".")=0 then errormsg="You didn't provide a recipient's e-mail address"
	if imageid="" or not(isnumeric(imageid)) then response.redirect "gallery.asp"
	if errormsg="" then
		'/// Generate Random Code
		randomize
		postcardid=Int((100000 - 1000 + 1) * Rnd + 1000)
		postcardid=left(recipientemail,2)&left(senderemail,2)&postcardid
	
		set rs=server.createobject("ADODB.Recordset")
		rs.open "xlaAIGpostcards",conn,1,3,2
		rs.addnew
		rs("dateposted")=todaydate
		rs("postcardid")=postcardid
		rs("imageid")=imageid
		rs("bgcolor")=bgcolor
		rs("bordercolor")=bordercolor
		rs("fonttype")=fonttype
		rs("fontcolor")=fontcolor
		rs("recipientname")=recipientname
		rs("recipientemail")=recipientemail
		rs("greeting")=greeting
		rs("bgsound")=bgsound
		rs("sendername")=sendername
		rs("senderemail")=senderemail
		rs("sendermsg")=sendermsg
		rs.update
		rs.close
		set rs=nothing
		call startcomponent()
		message=sendername&" has sent you a postcard"&vbcrlf&vbcrlf&"To view it, follow this link :"&vbcrlf&applicationurl&"viewpostcard.asp?postcardid="&postcardid&"&i="&imageid&vbcrlf&vbcrlf&mailsignature
		call sendmail(recipientemail,postcardsubject,message,senderemail)
		sent=1
	else
		conn.close
		set conn=nothing
		response.write errormsg&"<br>Please go back to fix the problem"
		response.end
	end if
else
	if instr(senderemail,"@")=0 or len(senderemail)<6 or instr(senderemail,".")=0 then errormsg="Please provide your e-mail address"
	if instr(recipientemail,"@")=0 or len(recipientemail)<6 or instr(recipientemail,".")=0 then errormsg="You didn't provide a recipient's e-mail address"
	if imageid="" or not(isnumeric(imageid)) then response.redirect "gallery.asp"
	if errormsg<>"" then
		response.write errormsg&"<br>Please go <a href='javascript:history.back();'>back</a> to fix the problem"
		response.end
	end if
end if

psql="select * from "&vxlaAIGimagesCategories&" where imageid="&imageid 
set rs=conn.execute(psql)
if not(rs.eof) then theimage=getimage(imageid,rs("imagefile"),rs("imagepath"),rs("imagesize"))
rs.close
set rs=nothing
conn.close
set conn=nothing

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title><%=greeting%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="gallery.css" rel="stylesheet" type="text/css">
</head>
<%if bgsound<>"-" then%><embed src="postcardmusic/<%=bgsound%>" autostart="true" loop="true" hidden="true"></embed><%end if%>
<body bgcolor="<%=bgcolor%>">
<table width="90%" height="90%" border="7" align="center" cellpadding="2" cellspacing="4" bordercolor="<%=bordercolor%>">
  <tr>
    <td align="left" valign="top"><table width="100%" height="100%" border="0" cellpadding="2" cellspacing="2">
        <tr align="left" valign="top"> 
          <td width="50%" align="center" valign="middle"><%=theimage%></td>
          <td width="50%"><table border="2" align="right" cellpadding="2" cellspacing="2">
              <tr> 
                <td width="121"><img src="images/Stamp.gif" width="121" height="40"></td>
              </tr>
            </table>
            <p><br>
              <br>
              <br>
              <font color="<%=fontcolor%>" face="<%=fonttype%>"><b>From 
              : <a href="mailto:<%=senderemail%>"><%=sendername%></a></b><br>
              <b>To : <a href="mailto:<%=recipientemail%>"><%=recipientname%></a></b></font></p>
            <p><font color="<%=fontcolor%>" size="5" face="<%=fonttype%>"><b><%=greeting%></b></font></p>
            <p><font color="<%=fontcolor%>" size="2" face="<%=fonttype%>"><%=sendermsg%></font></p>
            <p>&nbsp;</p></td>
        </tr>
        <tr align="left" valign="top">
          <td>&nbsp;</td>
          <td align="right"><font size="1" face="Arial, Helvetica, sans-serif">Copyright(c) 
            - <a href="gallery.asp"><%=gallerytitle%></a></font></td>
        </tr>
      </table>
      <br>
    </td>
  </tr>
</table>

<div align="center"><%if i="" and sent="" then%><form name="form1" method="post" action="" style="margin:0">
    <input name="Submit2" type="button" class="NavigationBar" onclick="javascript:history.back();" value="&lt;&lt; Edit Postcard">
    <input name="sendpostcard" type="submit" class="NavigationBar" value="Send Postcard &gt;&gt;">
    <input name="imageid" type="hidden" value="<%=imageid%>">
	 <input name="bgsound" type="hidden" value="<%=bgsound%>">
    <input name="bgcolor" type="hidden" value="<%=bgcolor%>">
    <input name="bordercolor" type="hidden" value="<%=bordercolor%>">
    <input name="fonttype" type="hidden" value="<%=fonttype%>">
    <input name="fontcolor" type="hidden" value="<%=fontcolor%>">
    <input name="recipientname" type="hidden"  value="<%=recipientname%>">
    <input name="recipientemail" type="hidden"  value="<%=recipientemail%>">
    <input name="greeting" type="hidden" value="<%=greeting%>">
    <input name="bgmusic" type="hidden" value="<%=bgmusic%>">
    <input name="sendername" type="hidden" value="<%=sendername%>">
    <input name="senderemail" type="hidden" value="<%=senderemail%>">
    <input name="sendermsg" type="hidden" value="<%=sendermsg%>">
</form><%elseif sent<>"" then%>
  <font color="#000000" size="2" face="Arial, Helvetica, sans-serif">Your postcard 
  has been sent to <b><%=recipientname%></b> at <b><a href="mailto:<%=recipientemail%>"><%=recipientemail%></a></b><br>
<input  type="button" class="NavigationBar" onclick="javascript:self.close();" value="Close Window">
  </font>
<%end if%>
</div>
</body>
</html>
