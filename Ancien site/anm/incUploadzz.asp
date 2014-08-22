<%
'//// Include for SAFileUp Component ////
'/// http://www.softartisans.com
uploadcomponent="SAFileUp"

sub upload(articleid)
	Set su = Server.CreateObject("SoftArtisans.FileUp")
	set rs=server.createobject("ADODB.Recordset")
	thisfile=Mid(su.form("file").UserFilename, InstrRev(su.form("file").UserFilename, "\") + 1)
	filetitle=su.form("filetitle")
	if filetitle="" then filetitle=thisfile
	if thisfile<>"" then
		rs.open "articlefiles",conn,1,3,2
		rs.addnew
			rs("filename")=thisfile
			rs("articleid")=articleid
			rs("filetype")=su.form("filetype")
			rs("filecomment")=su.form("filecomment")
			rs("filetitle")=filetitle
			rs("urlfile")=0
		rs.update
		rs.close
		targetfile = attachmentsfolder & "\"& articleid & "-"&thisfile
		su.form("file").saveAs targetfile
		button=su.form("button")
	end if
	set rs=nothing
	set su=nothing
end sub

sub uploadtn(filename)
	Set su = Server.CreateObject("SoftArtisans.FileUp")
	'su.Upload()
	thisfile=Mid(su.form("file").UserFilename, InstrRev(su.form("file").UserFilename, "\") + 1)
	if thisfile<>"" then
		su.form("file").saveAs server.mappath("thumbnails") & "\"& filename
	end if
	set su=nothing
end sub

%>
