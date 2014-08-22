<!-- #include file="incSystem.asp" -->
<!-- #include file="incUpload.asp" -->
<%
lvl=validate(0)
articleid=request("articleid")
dim filename
up=request("up")
if up<>"" then
	call uploadtn(articleid&".gif")
end if
%>
<html>
<head>
<title>Upload Article Thumbnail</title>
<meta http-equiv="Content-Type" content="text/html; charset=<%=charset%>">
<%if up<>"" then%>
<script language="JavaScript">
opener.writediv('<img src=\'<%=applicationurl & "thumbnails/" & articleid%>.gif\'>');
self.close();
</script>
<%end if%>
<script language="JavaScript">
function preview1(){
	var imglogo = form1.file.value;
	if (imglogo!='') window.open(imglogo);
		else alert('There\'s No File To Preview');
}
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000">
<form name="form1" method="post" ENCTYPE="multipart/form-data" action="uploadthumbnail.asp?up=1&articleid=<%=articleid%>">
  <table border="0" cellspacing="2" cellpadding="2" align="center">
    <tr> 
      <td><font face="Arial, Helvetica, sans-serif" size="2"><b> Upload Article 
        Thumbnail</b></font></td>
    </tr>
    <tr> 
      <td bgcolor="#666666" align="center"></td>
    </tr>
    <tr> 
      <td bgcolor="#F6F6F6"><font face="Arial, Helvetica, sans-serif" size="1">Select 
        the file that you want to upload and then click the upload button.<br>
        Only .JPG or .GIF Files</font></td>
    </tr>
    <tr> 
      <td bgcolor="#666666" align="center"></td>
    </tr>
    <tr> 
      <td> <font face="Arial, Helvetica, sans-serif" size="2"> File : 
        <input type="FILE" name="file" size="30" style="">
        </font></td>
    </tr>
    <tr> 
      <td align="center"><font face="Arial, Helvetica, sans-serif" size="2"> 
        <input type="button" name="Submit2" value="Preview" onclick="javascript:preview1();">
        <input type="submit" name="Submit" value="Upload File">
        </font></td>
    </tr>
  </table>
</form>
</body>
</html>

