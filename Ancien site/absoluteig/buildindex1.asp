<%Server.ScriptTimeout = 7200%>
<!--#include file="incSystem.asp" -->
<%
lvl=validate(1)
'/// lock the gallery
application("AIG_GalleryLock")="Locked"

set conn=server.createobject("ADODB.Connection")
conn.open connection
Set rs = Server.CreateObject("ADODB.Recordset") 
lastupdate=now
supercatid=0

'/// New Fix ///
randomize
lastupdate=Int((1000000 - 100 + 1) * Rnd + 100)


function scanfolders(virtualpath,supercatid)
	diskpath=getpath(virtualpath)
	Set f = Fso.GetFolder(diskpath) 
	Set fc = f.SubFolders 
	For Each Folder in fc 
		catname=mid(folder,instrRev(folder,"\")+1,len(folder))
		if lcase(catname)<>"tn" and left(catname,1)<>"_" then
			catpath=virtualpath&catname
			if right(catpath,1)<>"/" then catpath=catpath & "/"
			escapedcatpath=replace(catpath&"","'","''")
			psql="select * from xlaAIGcategories where catpath like '"&escapedcatpath&"'"
			rs.open psql,conn,1,2
			if rs.eof then 
				rs.addnew
				rs("catdesc")=""
				rs("images")=0
				rs("allowupload")=""
			end if
			rs("catname")=replace(catname&"","_"," ")
			rs("catpath")=catpath
			rs("supercatid")=supercatid
			rs("lastupdate")=lastupdate
			rs.update
			categoryid=rs("categoryid")
			rs.close
			call scanfolders(catpath,categoryid)
		end if
	Next 
	'/// If No Thumbnails Folder : Create it
	if not(fso.folderexists(diskpath&"\tn")) then fso.createfolder(diskpath&"\tn")
	set fc=nothing
	set f=nothing
end function

'/// Get the Root Category (Supercatid=0)
psql="select * from xlaAIGcategories where supercatid=0"
rs.open psql,conn,1,2
if rs.eof then 
	psql="delete from xlaAIGcategories"
	conn.execute(psql)
	rs.addnew
	rs("catdesc")="Gallery Root"
	rs("supercatid")=0
	rs("catname")="Top"
	rs("allowupload")=defaultallowupload
end if
rs("catpath")=galleryfolder
rs("lastupdate")=lastupdate
rs.Update 
supercatid=rs("categoryid")
rs.close

Set Fso = CreateObject("Scripting.FileSystemObject")
call scanfolders(galleryfolder,supercatid)
set fso=nothing
set rs=nothing

'/// Delete Invalid references
psql="delete from xlaAIGcategories where lastupdate<>'"&lastupdate&"'"
conn.execute(psql)

conn.close
set conn=nothing

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>
<table width="100%" height="100%" border="0" cellpadding="2" cellspacing="2">
  <tr>
    <td align="center" valign="middle"><font color="#003366" size="2" face="Arial, Helvetica, sans-serif"><b>Preparing 
      Categories...</b></font></td>
  </tr>
</table>
<meta http-equiv="refresh" content="0;URL=buildindex2.asp">
</body>
</html>