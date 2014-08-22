<!--#include file="incSystem.asp" -->
<%lvl=validate(1)%>
<html>
<head>
<title><%=title%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script language="JavaScript">
function rebuild(){
		document.all.msg.style.visibility='';
		self.location.href='buildindex1.asp';
}
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000">
<table width="100%" border="0" cellspacing="2" cellpadding="2" height="100%">
  <tr>
    <td align="center">
      <table width="70%" border="0" cellspacing="2" cellpadding="1">
        <tr>
          <td bgcolor="#999999">
            <table width="100%" border="0" cellspacing="0" cellpadding="4" bgcolor="#FFFFFF">
              <tr align="left" valign="top"> 
                <td><font face="Arial, Helvetica, sans-serif" size="2"><img src="images/btnRebuildStart.gif" width="31" height="26"><br>
                  </font></td>
                <td><font face="Arial, Helvetica, sans-serif" size="2"><b>Rebuild 
                  Gallery Index</b></font> 
                  <hr size="1">
                  <p><font face="Arial, Helvetica, sans-serif" size="2">Use this 
                    option after uploading files (FTP or Absolute Image Gallery) 
                    , creating and deleting categories and files to re-construct 
                    the gallery and update the system database. </font></p>
                  <p><font face="Arial, Helvetica, sans-serif" size="2">This may 
                    take several minutes depending on the amount of files and 
                    folders that your gallery has.</font></p>
                  <p>
<div align="right"> 
                    <p align="center"> 
                      <input type="button" name="Button" value="Rebuild Index &gt;&gt;" onClick="rebuild();">
                      <br>
                    </p>
                    </div>
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr id="msg" style="visibility=hidden;">
          <td bgcolor="#C9FF24"> 
            <div align="center"><font face="Arial, Helvetica, sans-serif" size="2" color="#0033CC"><b>Rebuilding 
              Gallery Index<br>
              Please Wait...</b></font></div>
          </td>
        </tr>
      </table>
      <p>&nbsp;</p>
      <p>&nbsp;</p>
    </td>
  </tr>
</table>
</body>
</html>


