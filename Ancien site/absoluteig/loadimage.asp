<!--#include file="incSystem.asp" -->
<%
lvl=validate(1)
imageid=request("imageid")
categoryid=request("categoryid")
viewfull=request("viewfull")

if categoryid<>"0" then condition="xlaAIGcategories.categoryid="&categoryid else condition="supercatid=0"
if imageid<>"" then condition="imageid="&imageid

set conn=server.createobject("ADODB.Connection")
conn.open connection

'//// Update Properties ///
imagename=request("imagename")
imagedesc=request("imagedesc")
originalimageid=request("originalimageid")
uploadedby=request("uploadedby")
additionalinfo=request("additionalinfo")
embedhtml=request("embedhtml")
status=request("status")
if status="" or not(isnumeric(status)) then status=defaultindexstatus
keywords=request("keywords")
datecreated=request("datecreated")
copyright=request("copyright")
credit=request("credit")
source=request("source")
uploadedby=request("uploadedby")
email=request("email")
infourl=request("infourl")


if originalimageid<>"" then
	psql="select * from xlaAIGimages where imageid="&originalimageid
	Set rs = Server.CreateObject("ADODB.Recordset") 
	rs.open psql,conn,1,2
	if imagename<>"" then rs("imagename")=imagename
	rs("imagedesc")=imagedesc
	rs("uploadedby")=uploadedby
	rs("additionalinfo")=additionalinfo
	rs("embedhtml")=embedhtml
	rs("status")=status
	rs("keywords")=keywords
	rs("copyright")=copyright
	rs("credit")=credit
	rs("source")=source
	rs("datecreated")=datecreated
	rs("email")=email
	rs("infourl")=infourl
	rs.update
	rs.close
	set rs=nothing
end if

psql="SELECT xlaAIGimages.*, xlaAIGcategories.catname,xlaAIGcategories.catpath FROM xlaAIGcategories INNER JOIN xlaAIGimages ON xlaAIGcategories.categoryid = xlaAIGimages.categoryid where "&condition&" order by imagename"
set rs=conn.execute(psql)
if not(rs.eof) then
	imageid=rs("imageid")
	imagename=rs("imagename")
	imagedesc=rs("imagedesc")
	imagefile=rs("imagefile")
	catpath=rs("catpath")
	catname=rs("catname")
	imagesize=formatnumber(rs("imagesize")/1000,2)
	totalrating=rs("totalrating")
	totalreviews=rs("totalreviews")
	rating=0
	if totalreviews>0 then rating=formatnumber(totalrating/totalreviews,2)

	hits=rs("hits")
	status=rs("status")
	uploadedby=rs("uploadedby")
	additionalinfo=rs("additionalinfo")
	embedhtml=rs("embedhtml")
	keywords=rs("keywords")
	copyright=rs("copyright")
	credit=rs("credit")
	source=rs("source")
	datecreated=rs("datecreated")
	email=rs("email")
	infourl=rs("infourl")
	imagepath=catpath&imagefile
	
	'/// Get Image or Thumbnail	
	if viewfull<>"" then
		thefile=getimage(imageid,imagefile,imagepath,rs("imagesize"))
	else
		Set Fs=createobject("scripting.filesystemobject")
		thefile=gettn(catpath,imagefile)
		set fs=nothing
		thefile="<a href='javascript:popup();'><img src='"&thefile&"' alt='"&imagename&"' border=0><br><font face=Verdana size=1><b>"&imagename&"</b></font></a>"
	end if
end if
rs.close
set rs=nothing
conn.close
set conn=nothing

popup=escape(imagepath)
%>
<html>
<head>
<title><%=title%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script language="JavaScript">
function popup(){
	window.open("<%=popup%>","","toolbar=0,location=0,status=1,menubar=1,scrollbars=1,resizable=1,width=580,height=400");
}
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" rightmargin="0" bottommargin="0" marginwidth="0" marginheight="0" topmargin="0">
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
	<%if imagepath<>"" then%>
  <tr> 
    <td align="center" valign="middle">
      <%=thefile%><script language="JavaScript">
	  window.onload=passvalues;  
	  function passvalues(){
		  parent.imagesize.innerHTML=form1.imagesize.value;
		  parent.catname.innerHTML=form1.catname.value;
		  parent.rating.innerHTML=form1.rating.value;
		  parent.hits.innerHTML=form1.hits.value;;
		  parent.form1.imagename.value=form1.imagename.value;
		  parent.form1.imagedesc.value=form1.imagedesc.value;
		  parent.form1.originalimageid.value=form1.imageid.value;
		  parent.form1.uploadedby.value=form1.uploadedby.value;
		  parent.form1.additionalinfo.value=form1.additionalinfo.value;
		  parent.form1.embedhtml.value=embedhtml.innerHTML;
		  parent.form1.keywords.value=form1.keywords.value;
		  parent.form1.copyright.value=form1.copyright.value;
		  parent.form1.credit.value=form1.credit.value;
		  parent.form1.source.value=form1.source.value;
		  parent.form1.datecreated.value=form1.datecreated.value;
		  parent.form1.email.value=form1.email.value;
		  parent.form1.infourl.value=form1.infourl.value;
		  parent.updatestatus(<%=status%>);
		  parent.updating.style.display='none';
	  }
	</script><form name="form1">
        <input type="hidden" name="imagesize" value="<%=imagesize%>">
        <input type="hidden" name="catname" value="<%=catname%>">
        <input type="hidden" name="rating" value="<%=rating%>">
   	    <input type="hidden" name="hits" value="<%=hits%>">
		<input type="hidden" name="imagename" value="<%=imagename%>">
        <input type="hidden" name="imagedesc" value="<%=imagedesc%>">
        <input type="hidden" name="imageid" value="<%=imageid%>">
        <input type="hidden" name="status" value="<%=status%>">
		<input type="hidden" name="uploadedby" value="<%=uploadedby%>">
		<input type="hidden" name="additionalinfo" value="<%=additionalinfo%>">
        <input name="keywords" type="hidden"value="<%=keywords%>">
        <input name="copyright" type="hidden" value="<%=copyright%>">
        <input name="credit" type="hidden"value="<%=credit%>">
        <input name="source" type="hidden" value="<%=source%>">
        <input name="datecreated" type="hidden" value="<%=datecreated%>">
        <input name="email" type="hidden"  value="<%=email%>">
        <input name="infourl" type="hidden" value="<%=infourl%>">
      </form><div id="embedhtml" style="display:none"><%=embedhtml%></div></td>
  </tr>
  <%else%>
  <tr>
    <td align="center" valign="middle"><font face="Arial, Helvetica, sans-serif" size="2"><b><font color="#FF0000">No 
      File Available</font></b></font></td>
  </tr>
  <%end if%>
</table>
</body>
</html>
