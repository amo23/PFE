<!-- #include file="configdata.asp" -->
<!-- #include file="incEmail.asp" -->
<%
dim errormsg
articleid=request("a")
email=request("email")
senderemail=request("senderemail")
note=request("note")

if request("sendbutton")<>"" then
	if instr(email,"@")<>0 and instr(email,".")<>0 then
		note=note & vbcrlf & vbclrf & applicationurl & "anmviewer.asp?a="&articleid &vbcrlf & vbcrlf & "___________"&vbcrlf & emailsignature
		call sendmail(email,"",senderemail,emailsubject,note)
		if errormsg="" then send=1
	else
		errormsg="Invalid e-mail address"
	end if
else
	note="I Found this and I thought you might be interested"
end if
'if Err.Number<>0 then errormsg=Err.Description

%>
<html>
<head>
<title>Send Article</title>
<meta http-equiv="Content-Type" content="text/html; charset=<%=charset%>">
</head>

<body bgcolor="#FFFFFF" text="#000000">

<script language="JavaScript">
function ANM_validate(){
	if (form1.email.value=='' || form1.senderemail.value=='') alert('please verify the e-mails provided');
		else form1.submit();
}
</script>
<form name="form1" method="post" action="PPL.sendarticle.asp?sendbutton=1">
  <table border="0" cellspacing="2" cellpadding="2" align="center" width="100%">
    <tr> 
    <td colspan="2">
        <div align="center"><font face="Tahoma, Arial, Verdana" size="2"><b>Send 
          Article By E-mail :</b></font></div>
      </td>
  </tr>
  <tr> 
    <td colspan="2" bgcolor="#666666"></td>
  </tr>
  <%
  if send<>1 then
  if errormsg<>"" then%>
  <tr valign="top"> 
      <td colspan="2" align="left"> 
        <div align="center"><font size="1" face="Tahoma, Arial, Verdana" color="#FF0000"><b>Error 
          : The E-mail couldn't be sent<br>
          <%=errormsg%></b></font></div>
      </td>
  </tr>
  <%end if%>
  <tr> 
      <td bgcolor="#E9E9E9" align="right" valign="top"><b><font size="2" face="Tahoma, Arial, Verdana">Recipient's 
        E-Mail :</font></b></td>
      <td bgcolor="#F7F7F7"><font size="2" face="Tahoma, Arial, Verdana"> 
        <input type="text" name="email" value="<%=email%>">
      </font></td>
  </tr>
  <tr> 
      <td bgcolor="#E9E9E9" align="right" valign="top"><b><font face="Tahoma, Arial, Verdana" size="2">Your 
        E-Mail :</font></b></td>
      <td bgcolor="#F7F7F7"><font size="2" face="Tahoma, Arial, Verdana"> 
        <input type="text" name="senderemail" value="<%=senderemail%>">
      </font></td>
  </tr>
  <tr> 
    <td bgcolor="#E9E9E9" align="right" valign="top"><b><font size="2" face="Tahoma, Arial, Verdana">Additional 
      Note : </font></b></td>
      <td bgcolor="#F7F7F7"> 
        <textarea name="note" rows="3"><%=note%></textarea>
    </td>
  </tr>
  <tr> 
    <td align="right"> 
      <input type="button" name="button2" value="Close Window" style="font-family: Tahoma, Arial, Verdana; font-size: 9px" onClick="javascript:self.close()">
    </td>
    <td> 
        <input type="button" value="Send Article &gt;&gt;" style="font-family: Tahoma, Arial, Verdana; font-size: 9px" onClick="javascript:ANM_validate()">
        <input type="hidden" name="a" value="<%=articleid%>">
    </td>
  </tr>
  <%else%>
  <tr> 
      <td colspan="2"> 
        <p>&nbsp;</p>
        <p align="center"><font size="2" color="#0066CC" face="Tahoma, Arial, Verdana"><b>The 
          Article has Been Sent To:<br>
          <%=email%> </b></font> </p>
        <p align="center"> 
          <input type="button" name="button22" value="Close Window" style="font-family: Tahoma, Arial, Verdana; font-size: 9px" onClick="javascript:self.close()">
        </p>
        <p align="center">&nbsp;</p>
        </td>
  </tr>
  <%end if%>
</table>
</form>
</body>
</html>
