<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%categoryid=request("categoryid")
catname=request("catname")
catleft=request("catleft")%>
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>
<table width="100%" height="100%" border="0" cellpadding="2" cellspacing="2">
  <tr>
    <td align="center" valign="middle"><font color="#003399" size="2" face="Arial, Helvetica, sans-serif"><b>Now 
      Indexing : <%=catname%><br>
      Categories Left : <%=catleft%><br>
      Please wait</b></font></td>
  </tr>
</table>
<meta http-equiv="refresh" content="0;URL=buildindex2.asp?categoryid=<%=categoryid%>">
</body>
</html>
