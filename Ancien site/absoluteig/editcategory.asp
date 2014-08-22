<%server.ScriptTimeout=7200%>
<!--#include file="incSystem.asp" -->
<%
lvl=validate(1)
categoryid=request("categoryid")
if categoryid="" or not(isnumeric(categoryid)) then categoryid=0
supercatid=request("supercatid")
if supercatid="" then response.write "logout.asp"
islist=request("islist")
listcat=categoryid
if islist<>"" then listcat=supercatid
	 

set conn=server.createobject("ADODB.Connection")
conn.open connection

button=request("button")
catname=request("catname")
lcatname=replace(catname&"","'","''")
catdesc=request("catdesc")
allowupload=request("allowupload")
if button<>"" then
	if catname="" then errormsg="Please provide a valid category name"
	if ucase(catname)="TN" then errormsg="TN is a reserved name"
	if left(catname,1)="_" then errormsg="Category names cannot being with an underscore(_)"
	
	'/// Check for Category with the same name
	psql="select * from xlaAIGcategories where categoryid<>"&categoryid&" and supercatid="&supercatid&" and (catname='"&lcatname&"' or catname='"&replace(lcatname," ","_")&"')"
	set rs=conn.execute(psql)
	if not(rs.eof) then errormsg="There's already a category named '"&catname&"'"
	rs.close
	set rs=nothing

	if errormsg="" then
		if categoryid=0 then
			'/// Get Disk Path from Super-category
			psql="select catpath from xlaAIGcategories where categoryid="&supercatid
			set rs=conn.execute(psql)
			virtualpath=rs("catpath")
			newfolder=replace(catname," ","_")
			diskpath=getpath(virtualpath)&newfolder
		end if

		'/// Save ///	
		psql="select * from xlaAIGcategories where categoryid="&categoryid
		Set rs = Server.CreateObject("ADODB.Recordset") 
		rs.open psql,conn,1,2
		if rs.eof and categoryid=0 then
			rs.addnew
			rs("catname")=catname
			rs("lastupdate")=now
			if right(virtualpath,1)<>"/" then virtualpath=virtualpath&"/"
			rs("catpath")=virtualpath&newfolder&"/"
			rs("supercatid")=supercatid
			rs("images")=0
			'/// Create New Folder
			Set Fs=createobject("scripting.filesystemobject")
			response.write diskpath
			if not(fs.folderexists(diskpath)) then
				fs.createfolder(diskpath)
				fs.createfolder(diskpath&"\tn")
			end if
			set fs=nothing
		end if
		rs("catdesc")=catdesc
		rs("allowupload")=allowupload
		rs.update
		rs.close
		set rs=nothing
		
		conn.execute(psql)
		conn.close
		set conn=nothing
		response.redirect "categories.asp?categoryid="&listcat
	end if
elseif categoryid>0 then
	'/// Retrieve Category Info
	psql="select * from xlaAIGcategories where categoryid="&categoryid
	set rs=conn.execute(psql)
	catname=rs("catname")
	catdesc=rs("catdesc")
	allowupload=rs("allowupload")
	protected="readonly"
	rs.close
	set rs=nothing
end if
conn.close
set conn=nothing
%>
<html>
<head>
<title><%=title%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script language="JavaScript">
function deletecat(whichcat,supercat){
	if (confirm('Delete this category with its subcategories and files')){
		self.location.href='categories.asp?categoryid=' + supercat + '&kill=' + whichcat;
	}
	
}
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000">
<form name="form1" method="post" action="">
  <table width="96%" border="0" cellspacing="2" cellpadding="2" align="center">
    <tr> 
      <td width="28%"><font face="Arial, Helvetica, sans-serif" size="2"><b><img src="images/icCategories.gif" width="20" height="19"> 
        Edit Category</b></font></td>
      <td width="72%" align="right"><a href="categories.asp?categoryid=<%=listcat%>"><img src="images/btnListCategories.gif" width="114" height="18" border="0"></a><%if categoryid>0 then%>
        <a href="javascript:deletecat(<%=categoryid%>,<%=supercatid%>)"><img src="images/btnDeleteCategory.gif" width="114" height="18" border="0" alt="Delete Category"></a> 
        <%end if%></td>
    </tr>
    <%if errormsg<>"" then%>
    <tr> 
      <td colspan="2" bgcolor="#666666"></td>
    </tr>
    <tr> 
      <td colspan="2"><b><font size="2" color="#FF0000" face="Arial, Helvetica, sans-serif">Error 
        : <%=errormsg%></font></b></td>
    </tr>
    <%end if%>
    <tr> 
      <td colspan="2" bgcolor="#666666"></td>
    </tr>
    <tr> 
      <td width="28%" align="left" valign="top" bgcolor="#CCCCCC"><b><font face="Arial, Helvetica, sans-serif" size="2"> 
        Name :</font></b></td>
      <td width="72%" bgcolor="#F3F3F3"> <input type="text" name="catname" size="40" value="<%=catname%>" maxlength="254" <%=protected%>> 
        <br> <font face="Arial, Helvetica, sans-serif" size="1"> Category Names 
        cannot contain \ / ; &lt; &gt; * ? &quot;&quot; | Symbols, It is advised 
        to use underscores _ instead of spaces<br>
        Once created, a category cannot be renamed.<br>
        To rename a category, you should rename its folder via FTP and then rebuild 
        the index</font></td>
    </tr>
    <tr> 
      <td width="28%" align="left" valign="top" bgcolor="#CCCCCC"><b><font face="Arial, Helvetica, sans-serif" size="2">Description 
        :</font></b></td>
      <td width="72%" bgcolor="#F3F3F3"> <textarea name="catdesc" cols="36" rows="3"><%=catdesc%></textarea> 
        <br> <font face="Arial, Helvetica, sans-serif" size="1">Type a short description 
        for this category</font></td>
    </tr>
    <tr>
      <td align="left" valign="top" bgcolor="#CCCCCC">&nbsp;</td>
      <td bgcolor="#F3F3F3"><font size="2" face="Arial, Helvetica, sans-serif">
        <input name="allowupload" type="checkbox" value="checked" <%=allowupload%>>
        Public uploading :Allow users to upload files to this category</font></td>
    </tr>
    <tr> 
      <td width="28%" bgcolor="#CCCCCC"> 
        <input type="hidden" name="supercatid" value="<%=supercatid%>"> 
        <input type="hidden" name="categoryid" value="<%=categoryid%>"> 
        <input type="hidden" name="islist" value="<%=islist%>">
      </td>
      <td width="72%" bgcolor="#F3F3F3"> 
        <input type="submit" name="button" value="Save Category">
      </td>
    </tr>
  </table>
</form>
</body>
</html>
