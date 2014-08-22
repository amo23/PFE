<!--#include file="incSystem.asp" -->
<!--#include file="incUpload.asp" -->
<%
categoryid=request("categoryid")
myname=request.cookies("xlaAIGmyname")
if categoryid="" or not(isnumeric(categoryid)) then response.end
if publicupload="" then
	response.write "This feature is not enabled"
	response.end
end if
dim thisfile,categoryid,imagename,imagedesc,copyright,credit,source,email,infourl,filesize,status,uploadedby,msg

'/// get category info
psql="select * from xlaAIGcategories where categoryid="&categoryid&" and allowupload<>''"
set conn=server.createobject("ADODB.Connection")
conn.open connection
set rs=conn.execute(psql)
if rs.eof then response.end
catpath=rs("catpath")
catname=rs("catname")
targetpath=getpath(catpath)
rs.close
set rs=nothing

doupload=request("doupload")
if doupload<>"" then
	'//// Check if file exists
	checkfile=request("checkfile")
	checkfile=mid(checkfile,instrrev(checkfile,"\")+1,len(checkfile))
	Set Fs=createobject("scripting.filesystemobject")
	if fs.fileexists(targetpath&checkfile) then msg="An error has ocurred : File '"&checkfile&"' already exists"
	set fs=nothing
	
	'/// Check if file is valid
	if instr(checkfile,".")=0 then 
		msg=checkfile&"Is Not a valid filename"
	else
		puiblicuploadblock=replace(publicuploadblock&"",",",";")
		publicuploadblock=";"&replace(publicuploadblock&""," ","")&";"
		itsextension=mid(checkfile,instrrev(checkfile,".")+1,len(checkfile))
		if publicupload="2" and instr(1,publicuploadblock,itsextension,1)=0 then msg="File type '"&itsextension&"', is not supported"
		if publicupload="3" and instr(1,publicuploadblock,itsextension,1)>0 then msg="File type '"&itsextension&"', is not supported"
	end if
	if msg="" then call upload(targetpath,checkfile,"yes")
end if

function savefile()
	psql="select * from xlaAIGimages where imagefile='"&replace(thisfile,"'","''")&"' and categoryid="&categoryid
	Set rs = Server.CreateObject("ADODB.Recordset") 
	rs.open psql,conn,1,2
	if rs.eof then 	rs.addnew
	rs("imagefile")=thisfile
	rs("categoryid")=categoryid
	rs("imagename")=imagename
	rs("imagedesc")=imagedesc
	rs("imagesize")=filesize
	rs("imagedate")=todaydate
	rs("status")=defaultuploadstatus
	rs("uploadedby")=uploadedby
	rs("copyright")=copyright
	rs("credit")=credit
	rs("source")=source
	rs("email")=email
	rs("infourl")=infourl
	rs("additionalinfo")=""
	rs("embedhtml")=""
	rs.update
	rs.close
	set rs=nothing
	response.cookies("xlaAIGmyname")=uploadedby
	response.cookies("xlaAIGmyname").expires=date+365
	myname=uploadedby
end function
conn.close
set conn=nothing

publicuploadblock=replace(publicuploadblock&"",";"," ,")
if publicupload="2" then warning="You can only submit '"&publicuploadblock&"' files<br>"
if publicupload="3" then warning="File types '"&publicuploadblock&"' are not supported<br>"
if publicuploadsize<>"" then warning=warning & "Files cannot exceed "&publicuploadsize&"Kb in size"


%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title><%=gallerytitle%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="gallery.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/JavaScript">
function upload(){
	filename=document.form1.file.value;
	document.form1.action='galleryupload.asp?doupload=1&categoryid=<%=categoryid%>&checkfile=' + escape(filename);
	document.form1.submit();
}


</script>

</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bottommargin="0" rightmargin="0">
<form name="form1" method="post" action="galleryupload.asp" ENCTYPE="multipart/form-data">
  <table width="100%" border="0" cellspacing="0" cellpadding="4">
    <tr class="Header"> 
    <td align="center" class="CurrentCategory">Upload File</td>
  </tr>
</table>
  <table width="96%" border="0" align="center" cellpadding="2" cellspacing="2">

    <tr align="center" valign="top"> 
      <td colspan="2" class="CategoriesList_category"><%=msg%></td>
    </tr>
    <%if warning<>"" then%>
    <tr align="left" valign="top">
      <td class="NavigationBar">Special Note :</td>
      <td class="NavigationBar"><%=warning%></td>
    </tr>
	<%end if%>
    <tr align="left" valign="top"> 
      <td width="25%" class="NavigationBar"><b>Category :</b></td>
      <td width="77%" class="NavigationBar"><%=catname%></td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="25%" class="NavigationBar"><b>Status :</b></td>
      <td class="NavigationBar"><img src="images/<%=defaultuploadstatus%>.gif" width="27" height="27" align="middle"><%=whichstatus(defaultuploadstatus)%></td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="25%" class="NavigationBar"><b>File :</b></td>
      <td class="NavigationBar"> <input name="file" type="FILE" style="" size="40" class="NavigationBar"></td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="25%" class="NavigationBar"><b>File Name :</b></td>
      <td class="NavigationBar"> <input type="text" name="imagename" size="40" maxlength="254" class="NavigationBar"></td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="25%" class="NavigationBar"><b>Description :</b></td>
      <td class="NavigationBar"> <textarea name="imagedesc" cols="36" rows="2" class="NavigationBar"></textarea></td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="25%" class="NavigationBar"><b>Copyright :</b></td>
      <td class="NavigationBar"><input name="copyright" type="text" class="NavigationBar" size="40" maxlength="254"></td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="25%" class="NavigationBar"><b>Credit :</b></td>
      <td class="NavigationBar"><input name="credit" type="text" class="NavigationBar" size="40" maxlength="254"></td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="25%" class="NavigationBar"><b>Source : </b></td>
      <td class="NavigationBar"><input name="source" type="text" class="NavigationBar" size="40" maxlength="254"></td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="25%" class="NavigationBar"><b>E-Mail :</b></td>
      <td class="NavigationBar"><input name="email" type="text" class="NavigationBar" size="40" maxlength="254"></td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="25%" class="NavigationBar"><b>URL :</b></td>
      <td class="NavigationBar"><input name="infourl" type="text" class="NavigationBar" id="infourl" size="40" maxlength="254"></td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="25%" class="NavigationBar"><b>Uploaded By :</b></td>
      <td class="NavigationBar"> <input name="uploadedby" class="NavigationBar" type="text" value="<%=myname%>" size="40" maxlength="254" onclick="clearfield();"> 
      </td>
    </tr>
  </table>
  <div align="center">
    <input name="Button2" type="button" class="NavigationBar" onclick="javascript:self.close();" value="Close Window">
    <input name="Button" type="button" class="NavigationBar" onclick="javascript:upload();" value="Upload File">
  </div>
</form>
</body>
</html>
