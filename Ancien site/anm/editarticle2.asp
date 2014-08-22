<!-- #include file="incSystem.asp" -->
<!-- #include file="incUpload.asp" -->
<%
lvl=validate(0)
articleid=request("articleid")
action=request("action")
kill=request("kill")
fileurl=request("fileurl")
if len(fileurl)>0 then noupload=fileurl else noupload=""
dim button
if uploadcomponent="" then uploadcomponent="Undefined"
if articleid="" or not(isnumeric(articleid)) then response.redirect "logout.asp"

set conn=server.createobject("ADODB.Connection")
conn.open connection

'//// validate article edition ///
psql="select * from articles where articleid="&articleid
if lvl=0 then psql=psql & " and publisherid="&usrid
set rs=conn.execute(psql)
if rs.eof then response.redirect "logout.asp"
articleurl=rs("articleurl")
article=rs("article")
rs.close
set rs=nothing

if action="upload" then
	if noupload="" then
		'/// upload file ///
		call upload(articleid)
	else
		'/// Save URL ///
		set rs=server.createobject("ADODB.Recordset")
		filetitle=request("filetitle")
		if filetitle="" then filetitle=noupload
		rs.open "articlefiles",conn,1,3,2
		rs.addnew
			rs("filename")=noupload
			rs("articleid")=articleid
			rs("filetype")=request("filetype")
			rs("filecomment")=request("filecomment")
			rs("filetitle")=filetitle
			rs("urlfile")=1
			button=request("button")
		rs.update
		rs.close
		set rs=nothing
	end if
end if

'/// Delete Article ////
if kill<>"" then
	psql="select * from articlefiles where fileid="&kill
	set rs=conn.execute(psql)
	if not(rs.eof) then
		filename=attachmentsfolder&"\"&articleid&"-"&rs("filename")
		psql="delete from articlefiles where fileid="&kill
		conn.execute(psql)
		Set Fs=createobject("scripting.filesystemobject")
		if fs.fileexists(filename) then fs.deletefile(filename)
		set fs=nothing
	end if
	rs.close
	set rs=nothing
end if
%>
<html>
<head>
<title><%=title%></title>
<meta http-equiv="Content-Type" content="text/html; charset=<%=charset%>">
<script language="JavaScript">
function insertaig()
	{
	window.open("<%=aigurl%>aig-anm.asp","Insertaigfile","scrollbars=yes,status=yes,resizable=yes,width=520,height=480")
	}
	
function dosubmit(){
	if (form1.file.value!='' && form1.fileurl.value!=''){
		alert('You must provide either a file to upload or a URL to the file');
	} else {
		if (form1.file.value!='') form1.encoding='multipart/form-data';
		if (form1.fileurl.value!='') form1.encoding='application/x-www-form-urlencoded'
		form1.submit();
	}
}
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000">
<form name="form1" method="post"  ENCTYPE="multipart/form-data" action="editarticle2.asp?articleid=<%=articleid%>&action=upload">
  <table width="96%" border="0" cellspacing="2" cellpadding="2" align="center">
    <tr> 
      <td colspan="3"><font size="2" face="Arial, Helvetica, sans-serif"><b><img src="images/icArticle.gif" width="20" height="16" align="absmiddle"> 
        Media Manager<br>
        <font size="1" face="Verdana, Arial, Helvetica, sans-serif">Current Upload 
        Component :<font color="#339966"><%=uploadcomponent%></font></font></b></font></td>
    </tr>
    <tr> 
      <td colspan="3" bgcolor="#666666"></td>
    </tr>
    <%if len(articleurl)>0 then%>
    <tr bgcolor="#F2F2F2"> 
      <td colspan="3"><font size="1" face="Arial, Helvetica, sans-serif">If This 
        article is stored outside Absolute News Manager (It's an URL to an article) 
        or is a Summary only article, any uploaded files will not be displayed 
        <%if articleurl<>"" then%>
        <br>
        Article URL : <a href="<%=articleurl%>" target="_blank"><%=articleurl%></a> 
        <%end if%>
        </font></td>
    </tr>
    <%end if%>
    <tr> 
      <td colspan="3" bgcolor="#003399"><b><font size="3" color="#FFFFFF" face="Arial, Helvetica, sans-serif">Images 
        &amp; Files</font></b></td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="28%" bgcolor="#CCCCCC"><b><font size="2" face="Arial, Helvetica, sans-serif"> 
        Upload File :</font></b></td>
      <td colspan="2" bgcolor="#F3F3F3"> <font face="Arial, Helvetica, sans-serif" size="1"> 
        <input type="FILE" name="file" size="40" style="">
        </font></td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="28%" bgcolor="#CCCCCC"><b><font size="2" face="Arial, Helvetica, sans-serif"> 
        File URL :</font></b></td>
      <td colspan="2" bgcolor="#F3F3F3"> <font face="Arial, Helvetica, sans-serif" size="1"> 
        <input type="text" name="fileurl" size="40" maxlength="254">
        <%if aigurl<>"" then %>
        <a href="javascript:insertaig();"><img src="images/launchaig.gif" width="99" height="26" border="0" align="absmiddle"></a> 
        <%end if%>
        </font></td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="28%" bgcolor="#CCCCCC"><font face="Arial, Helvetica, sans-serif" size="2"><b>File 
        Title :</b></font></td>
      <td colspan="2" bgcolor="#F3F3F3"> <font face="Arial, Helvetica, sans-serif" size="1"> 
        <input type="text" name="filetitle" size="40" maxlength="254">
        </font></td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="28%" bgcolor="#CCCCCC"><b><font size="2" face="Arial, Helvetica, sans-serif">Comments 
        :</font></b></td>
      <td colspan="2" bgcolor="#F3F3F3"> <font face="Arial, Helvetica, sans-serif" size="1"> 
        <input type="text" name="filecomment" size="40" maxlength="254">
        </font></td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="28%" bgcolor="#CCCCCC"><b><font size="2" face="Arial, Helvetica, sans-serif">File 
        Type :</font></b></td>
      <td colspan="2" bgcolor="#F3F3F3"> <font face="Arial, Helvetica, sans-serif" size="1"> 
        <select name="filetype">
          <option>Image</option>
          <option>Video</option>
          <option>Audio</option>
          <option>File</option>
          <option>Link</option>
          <option>Inline</option>
          <option>Other</option>
        </select>
        <br>
        Inline Files can be inserted directly into the article by using The HTML 
        Editor</font></td>
    </tr>
    <tr> 
      <td width="28%"> 
        <div align="right"> 
          <input type="button" name="Button2" value="&lt;&lt; Edit Article" onClick="javascript:self.location='editarticle1.asp?articleid=<%=articleid%>'">
        </div>
      </td>
      <td colspan="2"> 
        <input type="button" name="button" value="Submit" onclick="javascript:dosubmit();">
        <input type="button" name="Button" value="View Article &gt;&gt;" onclick="javascript:self.location='viewarticle.asp?articleid=<%=articleid%>'">
      </td>
    </tr>
    <tr> 
      <td width="28%">&nbsp;</td>
      <td colspan="2">&nbsp;</td>
    </tr>
  </table>
  <table width="96%" border="0" cellspacing="2" cellpadding="2" align="center">
    <tr> 
      <td width="46%" bgcolor="#003399" align="left"> <font size="2" face="Arial, Helvetica, sans-serif" color="#FFFFFF"><b>File</b></font></td>
      <td width="35%" bgcolor="#003399"> <font size="2" face="Arial, Helvetica, sans-serif" color="#FFFFFF"><b>Comments</b></font></td>
      <td width="10%" bgcolor="#003399" align="center"> <b><font color="#FFFFFF" size="2" face="Arial, Helvetica, sans-serif">View</font></b></td>
      <td width="9%" bgcolor="#003399" align="center"> <font size="2" face="Arial, Helvetica, sans-serif" color="#FFFFFF"><b>Delete</b></font></td>
    </tr>
    <%
	psql="select * from articlefiles where articleid="&articleid
	set rs=conn.execute(psql)
	do until rs.eof
		filetype=rs("filetype")
		filecomment=rs("filecomment")
		filetitle=rs("filetitle")
		urlfile=rs("urlfile")
		filename=rs("filename")
		if urlfile=0 then filename="articlefiles/"&articleid&"-"&rs("filename")
		fileid=rs("fileid")
	%>
    <tr valign="top" bgcolor="#F3F3F3"> 
      <td width="46%" align="left"> <font face="Arial, Helvetica, sans-serif" size="2"><b><a href="<%=filename%>" target="_blank"><%=filetitle%></a></b><br>
        <font size="1">(<%=filetype%>)</font></font></td>
      <td width="35%" align="left"><font face="Arial, Helvetica, sans-serif" size="2"><%=filecomment%></font></td>
      <td width="10%" align="center" valign="middle"> <font face="Arial, Helvetica, sans-serif" size="2"><a href="<%=filename%>" target="_blank"><img src="images/btnView.gif" width="27" height="27" hspace="5" alt="View file" border="0"></a></font></td>
      <td width="9%" align="center" valign="middle"> <font face="Arial, Helvetica, sans-serif" size="2"><a href="editarticle2.asp?kill=<%=fileid%>&articleid=<%=articleid%>"><img src="images/btnKill.gif" width="27" height="27" hspace="5" alt="Delete File" border="0"></a></font></td>
    </tr>
    <%
	rs.movenext
	loop
	rs.close
	set rs=nothing
	conn.close
	set conn=nothing
	%>
  </table>
  <p>&nbsp;</p>
</form>
</body>
</html>
