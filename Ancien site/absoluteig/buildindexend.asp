<%Server.ScriptTimeout = 7200%>
<!--#include file="incSystem.asp" -->
<%lvl=validate(1)

'/// Unlock the gallery
application("AIG_GalleryLock")=""
%>
<html>
<head>
<title><%=title%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

</head>
<body bgcolor="#FFFFFF">
<table width="100%" border="0" cellspacing="2" cellpadding="2" height="100%">
  <tr>
    <td align="center" valign="middle"><font face="Arial, Helvetica, sans-serif" size="2" color="#003366"><b>The 
      Gallery Index Has Been Reconstructed</b></font></td>
  </tr>
</table>
</body>
</html>




