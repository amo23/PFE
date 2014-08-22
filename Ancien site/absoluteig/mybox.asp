<!--#include file="incSystem.asp" -->
<!--#include file="incEmail.asp" -->
<%
mybox=request.cookies("xlaAIG_box")("mybox")
email=request.cookies("xlaAIG_box")("email")
if mybox="" then mybox=0

'/// Get My Box Contents
set conn=server.createobject("ADODB.Connection")
conn.open connection
psql="select * from "&vxlaAIGimagesCategories&" where imageid in ("&mybox&")"
'psql="SELECT xlaAIGimages.*, xlaAIGcategories.catname,xlaAIGcategories.catpath FROM xlaAIGcategories INNER JOIN xlaAIGimages ON xlaAIGcategories.categoryid = xlaAIGimages.categoryid where imageid in ("&mybox&")"
set rs=conn.execute(psql)
weight=0
files=0
do until rs.eof
	weight=weight + rs("imagesize")
	redim preserve thepath(files)
	thepath(files)=getpath(rs("imagepath"))
	files=files+1
	rs.movenext
loop
rs.close
set rs=nothing
conn.close
set conn=nothing
weight=weight/1000
if myboxlimit>0 and myboxlimit<weight then limiterror="Error"
weight=formatnumber(weight,2)


button=request("button")
if button<>"" and mybox<>"" then
	email=request("email")
	if instr(email,"@")<>0 and instr(email,".")<>0 then
		call startcomponent()
		Set Fs=createobject("scripting.filesystemobject")
		'/// Log E-mail Address
		if keeplog<>"" and logfile<>"" then
			logfile=server.mappath(logfile)
			Set b=fs.opentextfile(logfile,8,1)
			b.writeline(email)
			b.close
			set b=nothing
		end if
		for x=0 to ubound(thepath)
			thispath=thepath(x) 
			if fs.fileexists(thispath) then 
				call addattachment(thispath)
			end if
		next
		set fs=nothing
		call sendmail(email,subject,mainmessage&vbcrlf&vbcrlf&mailsignature,email)
		sent="yes"
		response.cookies("xlaAIG_box")("email")=email
	else
		errormsg="Please type a valid e-mail address<br>"
	end if
end if




%>
<html>
<head>
<title>Send My Favorite Files by E-Mail</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="gallery.css" type="text/css">
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" rightmargin="0"   topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" border="0" cellspacing="0" cellpadding="4" height="100%">
  <tr> 
    <td class="Header" align="center"><span class=CurrentCategory>Send My Favorite 
      Files By E-mail</span></td>
  </tr>
  <tr> 
    <td height="100%" class="FilesCellColor"> 
      <table width="90%" border="0" cellspacing="0" cellpadding="2" align="center">
        <%if mybox="" then%>
        <tr> 
          <td align="center"> 
            <p><font face="Arial, Helvetica, sans-serif" size="2"><b><font color="#FF0000">You 
              Have No Favorite Files</font></b></font></p>
            <p>&nbsp; </p>
          </td>
        </tr>
		<%elseif limiterror<>"" then%>
        <tr>
          <td align="center">
            <p><font size="2"><b><font color="#FF0000" face="Arial, Helvetica, sans-serif">Your 
              Favorite files files Cannot be Sent<br>
              </font></b><font face="Arial, Helvetica, sans-serif">Your files 
              Weight more than the <b><%=myboxlimit%>Kb</b> Limit<br>
              Please Remove Some Files and Try again</font></font></p>
            <p><font face="Arial, Helvetica, sans-serif" size="2">Total Files 
              : <b><%=files%></b> - Size : <b><%=weight%></b>Kb</font></p>
            <p>&nbsp;</p>
          </td>
        </tr>
        <%elseif sent="" then%>
        <tr> 
          <td align="center"> 
            <form name="form1" method="post" action="">
              <table border="0" cellspacing="0" cellpadding="2" class="FilesCellColor">
                <tr> 
                  <td align="center" colspan="2">Your have <b><%=files%></b> Favorite 
                    Files<br>
                    Weighting <b><%=weight%>Kb</b> Approximately</td>
                </tr>
                <tr> 
                  <td align="center" colspan="2"><font face="Arial, Helvetica, sans-serif" size="2"><b><font color="#FF0000"><%=errormsg%></font></b></font></td>
                </tr>
                <tr> 
                  <td align="center"><span class="FilesCellColor">Your E-mail 
                    Address : </span> </td>
                  <td> 
                    <input type="text" name="email" class="NavigationBar" size="30" maxlength="255" value="<%=email%>">
                  </td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td> 
                    <input type="submit" name="button" value="E-Mail My Favorite Files" class="NavigationBar" style="width:100%;">
                  </td>
                </tr>
              </table>
            </form>
          </td>
        </tr>
        <%else%>
        <tr> 
          <td align="center" class="FilesCellColor">
            <p>&nbsp;</p>
            <p>Your Favorite Files Have been sent to <b><%=email%></b></p>
            <p>&nbsp;</p>
          </td>
        </tr>
        <%end if%>
      </table>
      <div align="center">
<hr width="90%">
        <p> 
          <input type="button" name="Button" value="Close Window" onClick="javascript:self.close();" class="NavigationBar">
        </p>
      </div>
    </td>
  </tr>
</table>
</body>
</html>
