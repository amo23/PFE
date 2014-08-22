<!--#include file="incSYstem.asp" -->
<%lvl=validate(1)
categoryid=request("categoryid")
if categoryid="" or not(isnumeric(categoryid)) or categoryid="0" then condition="supercatid=0" else condition="categoryid="&categoryid

set conn=server.createobject("ADODB.Connection")
conn.open connection
apply=request("apply")
if apply="1" then
	allowupdate=request("allowupdate")
	psql="select * from xlaAIGcategories where categoryid="& categoryid
	set rs=conn.execute(psql)
	if not(rs.eof) then
		catpath=replace(rs("catpath")&"","'","''")
		conn.execute("update xlaAIGcategories set allowupload='"&allowupdate&"' where catpath like '"&catpath&"%'")
	end if
	rs.close
	set rs=nothing
end if

'/// Delete a Category
kill=request("kill")
if kill<>"" then
	psql="select * from xlaAIGcategories where categoryid="&kill
	set rs=conn.execute(psql)
		if not(rs.eof) then
		catpath=rs("catpath")
		if rs("supercatid")=0 then errormsg="The Main Category Cannot Be Deleted"
		rs.close
		set rs=nothing
		
		if errormsg="" then
			'/// Delete database References ///
			lcatpath=replace(catpath&"","'","''")
			psql="delete from xlaAIGcategories where catpath like '"&lcatpath&"%'"
			conn.execute(psql)
			
			'/// Delete Phisical Folder
			Set Fs=createobject("scripting.filesystemobject")
			targetfolder=server.mappath(catpath)
			fs.deletefolder targetfolder,true
			set fs=nothing
		end if
	end if
end if

'/// Get Category Properties ////
psql="select * from xlaAIGcategories where "&condition
set rs=conn.execute(psql)
if rs.eof then response.redirect "buildindex.asp"
catname=rs("catname")
catdesc=rs("catdesc")
categoryid=rs("categoryid")
supercatid=rs("supercatid")
catpath=rs("catpath")
images=rs("images")
allowupload=rs("allowupload")
if allowupload<>"" then 
	allowuploadmsg="<b>Enabled :</b> Users can upload files to this category" 
	imgallowupload="enabled"
else
	allowuploadmsg="<b>Disabled : </b>Users cannot upload files to this category"
	imgallowupload="disabled"
end if
rs.close
set rs=nothing
if publicupload="" then allowuploadmsg2="<br>Public uploading is not enabled (check the options screen)"


'//// Get Navigation Tree
navigation=getnavigation(catpath,"categories.asp",0)

%>
<html>
<head>
<title><%=title%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script language="JavaScript">
function deletecat(whichcat,supercat){
	if (confirm('Delete this category with its subcategories and files?')){
		self.location.href='categories.asp?categoryid=' + supercat + '&kill=' + whichcat;
	}
	
}
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000">
<table width="96%" border="0" cellspacing="2" cellpadding="2" align="center">
  <tr> 
    <td width="26%"><font face="Arial, Helvetica, sans-serif" size="2"><b><img src="images/icCategories.gif" width="20" height="19" align="absmiddle"> 
      Categories</b></font></td>
    <td width="74%" align="right"><a href="uploadfiles.asp?categoryid=<%=categoryid%>"><img src="images/btnUploadFiles.gif" width="114" height="18" alt="Upload Files" border="0" align="absmiddle"></a> <a href="editcategory.asp?supercatid=<%=categoryid%>&islist=1"><img src="images/btnCreateSubCategory.gif" width="114" height="18" border="0" alt="Create a New Subcategory"></a> 
      <a href="editcategory.asp?categoryid=<%=categoryid%>&supercatid=<%=supercatid%>"><img src="images/btnEditDescription.gif" width="114" height="18" border="0"></a> 
      <a href="javascript:deletecat(<%=categoryid%>,<%=supercatid%>)"><img src="images/btnDeleteCategory.gif" width="114" height="18" border="0" alt="Delete Category"></a></td>
  </tr>
  <%if errormsg<>"" then%>
  <tr> 
    <td colspan="2" bgcolor="#666666"></td>
  </tr>
  <tr> 
    <td colspan="2"><font color="#FF0000" size="2" face="Arial, Helvetica, sans-serif"><b>Error 
      : <%=errormsg%></b></font></td>
  </tr>
  <%end if%>
  <tr> 
    <td colspan="2" bgcolor="#666666"></td>
  </tr>
  <tr> 
    <td colspan="2" bgcolor="#F3F3F3"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><%=navigation%></font></td>
  </tr>
  <tr> 
    <td colspan="2" bgcolor="#666666"></td>
  </tr>
  <tr> 
    <td width="26%" bgcolor="#CCCCCC"><b><font size="2" face="Arial, Helvetica, sans-serif">Current 
      Category :</font></b></td>
    <td width="74%" bgcolor="#F3F3F3"><font size="2" face="Arial, Helvetica, sans-serif"><%=catname%></font></td>
  </tr>
  <tr> 
    <td width="26%" bgcolor="#CCCCCC"><b><font size="2" face="Arial, Helvetica, sans-serif">Description 
      :</font></b></td>
    <td width="74%" bgcolor="#F3F3F3"><font size="2" face="Arial, Helvetica, sans-serif"><%=catdesc%></font></td>
  </tr>
  <tr> 
    <td width="26%" bgcolor="#CCCCCC"><font face="Arial, Helvetica, sans-serif" size="2"><b>Files 
      :</b></font></td>
    <td width="74%" bgcolor="#F3F3F3"><font size="2" face="Arial, Helvetica, sans-serif"><a href="viewimages.asp?categoryid=<%=categoryid%>"><b><%=images%></b></a> 
      </font></td>
  </tr>
  <tr> 
    <td bgcolor="#CCCCCC"><font size="2" face="Arial, Helvetica, sans-serif"><b>Public 
      Uploading :</b></font></td>
    <td bgcolor="#F3F3F3"><font color="#666666" size="1" face="Verdana, Arial, Helvetica, sans-serif"><b><img src="images/<%=imgallowupload%>.gif" align="left"></b></font><font size="2" face="Arial, Helvetica, sans-serif"> 
      <%=allowuploadmsg%> <font size="1">[</font><font size="2" face="Arial, Helvetica, sans-serif"><font size="1"><a href="categories.asp?categoryid=<%=categoryid%>&apply=1&allowupdate=<%=allowupload%>">Apply 
      to all subcategories</a>]<%=allowuploadmsg2%></font></font></font></td>
  </tr>
  <tr> 
    <td colspan="2" bgcolor="#666666"></td>
  </tr>
</table>
<table width="96%" border="0" cellspacing="2" cellpadding="2" align="center">
  <tr> 
    <td width="4%" align="center" valign="middle" bgcolor="#000099"><b><font size="2" face="Arial, Helvetica, sans-serif" color="#FFFFFF"><a href="categories.asp?categoryid=<%=supercatid%>"><img src="images/imgUp.gif" width="15" height="13" border="0" alt="..Up Folder"></a></font></b></td>
    <td bgcolor="#000099"><b><font size="2" face="Arial, Helvetica, sans-serif" color="#FFFFFF">Subcategories 
      : </font></b></td>
    <td bgcolor="#000099" width="12%" align="center"><font color="#FFFFFF" size="2" face="Arial, Helvetica, sans-serif"><b>Files</b></font></td>
    <td width="12%" align="center" bgcolor="#000099"><font color="#FFFFFF" size="2" face="Arial, Helvetica, sans-serif"><b>Public 
      Uploading</b></font></td>
    <td width="12%" align="center" bgcolor="#000099"><b><font size="2" face="Arial, Helvetica, sans-serif" color="#FFFFFF">Browse<br>
      Files </font></b></td>
    <td width="10%" align="center" bgcolor="#000099"><b><font size="2" face="Arial, Helvetica, sans-serif" color="#FFFFFF">Edit 
      </font></b></td>
    <td width="12%" align="center" bgcolor="#000099"><b><font size="2" face="Arial, Helvetica, sans-serif" color="#FFFFFF">Delete</font></b></td>
  </tr>
  <%
  '/// Search Sub-Categories
  psql="select * from xlaAIGcategories where supercatid="&categoryid&" order by catname asc;"
  set rs=conn.execute(psql)
  if not(rs.eof) then
  do until rs.eof
  cc=cc+1
  allowupload=rs("allowupload")
  if allowupload<>"" then allowupload="enabled" else allowupload="disabled"
  %>
  <tr valign="top"> 
    <td width="4%" bgcolor="#F3F3F3" align="right"><font face="Arial, Helvetica, sans-serif" size="2"><b><%=cc%>.</b></font></td>
    <td bgcolor="#F3F3F3"><font face="Arial, Helvetica, sans-serif" size="2"><b><a href="categories.asp?categoryid=<%=rs("categoryid")%>"><%=rs("catname")%></a></b></font><br> <font face="Arial, Helvetica, sans-serif" size="1"><%=rs("catdesc")%></font></td>
    <td width="12%" align="center" bgcolor="#F3F3F3"><font face="Arial, Helvetica, sans-serif" size="2"><%=rs("images")%></font></td>
    <td width="7%" align="center" bgcolor="#F3F3F3"><font color="#666666" size="1" face="Verdana, Arial, Helvetica, sans-serif"><b><img src="images/<%=allowupload%>.gif"><br>
      <%=allowupload%></b></font></td>
    <td width="7%" align="center" bgcolor="#F3F3F3"><a href="viewimages.asp?categoryid=<%=rs("categoryid")%>"><img src="images/btnView.gif" width="27" height="27" border="0" alt="Browse Files"></a></td>
    <td width="10%" align="center" bgcolor="#F3F3F3"><a href="editcategory.asp?categoryid=<%=rs("categoryid")%>&supercatid=<%=supercatid%>&islist=1"><img src="images/btnEdit.gif" width="27" height="27" border="0" alt="Edit Category Description"></a></td>
    <td width="12%" align="center" bgcolor="#F3F3F3"><a href="javascript:deletecat(<%=rs("categoryid")%>,<%=categoryid%>)"><img src="images/btnKill.gif" width="27" height="27" border="0" alt="Delete Category"></a></td>
  </tr>
  <%rs.movenext
  loop%>
  <tr> 
    <td colspan="7" bgcolor="#666666"></td>
  </tr>
  <%else%>
  <tr align="center"> 
    <td colspan="7"> <p>&nbsp;</p>
      <p><font size="2"><b><font face="Arial, Helvetica, sans-serif" color="#FF0000">This 
        category has no subcategories</font><font face="Arial, Helvetica, sans-serif" color="#FF0000"><br>
        <a href="editcategory.asp?supercatid=<%=categoryid%>&islist=1"><img src="images/btnCreateSubCategory.gif" width="114" height="18" border="0" alt="Create a New Subcategory"></a></font></b></font></p></td>
  </tr>
  <%end if%>
</table>
</body>
</html>
<%  rs.close
  set rs=nothing
  conn.close
set conn=nothing%>