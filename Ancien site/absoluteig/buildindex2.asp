<%Server.ScriptTimeout = 7200%>
<!--#include file="incSystem.asp" -->
<%
lvl=validate(1)

counter=request("counter")
if counter="" then counter=0

'/// Scan Files Function ////
function scanfolders(catpath,categoryid)
	pathspec=getpath(catpath)
	totalfiles=0
	Set FolderInfo = Fso.GetFolder(PathSpec) 
	Set FileList = FolderInfo.Files 
	For Each File in FileList 
		totalfiles=totalfiles+1
		imagefile = File.Name
		imagefile2=replace(imagefile,"'","''")
		imagesize= File.size
		imagedate=todaydate
		if instr(1,"<"&catfiles&">","<"&imagefile&">",1)=0 then
			'/// Add New File	
			psql="insert into xlaAIGimages (imagename,imagedesc,imagefile,imagedate,imagesize,totalrating,totalreviews,hits,categoryid,status,uploadedby,additionalinfo,embedhtml) values ('"&imagefile2&"','','"&imagefile2&"','"&imagedate&"','"&imagesize&"',0,0,0,"&categoryid&","&defaultindexstatus&",'','','')"
			conn.execute(psql)
		else
			catfiles=replace(catfiles&"","<"&imagefile&">","",1,-1,1)
		end if
	Next 
	set folderinfo=nothing
	set filelist=nothing
	scanfolders=totalfiles
end function


set conn=server.createobject("ADODB.Connection")
conn.open connection
categoryid=request("categoryid")
if categoryid="" or not(isnumeric(categoryid)) then categoryid=0

'/// Get The category ////
psql="select Top 1 * from xlaAIGcategories where categoryid>"&categoryid&" order by categoryid"
set rs=conn.execute(psql)
if rs.eof then
	rs.close
	set rs=nothing
	conn.close
	set conn=nothing
	response.redirect "buildindex3.asp"
end if
catname=rs("catname")
categoryid=rs("categoryid")
catpath=rs("catpath")
rs.close
set rs=nothing

'//// Select the number of categories left ////
psql="select count(categoryid) as catleft from xlaAIGcategories where categoryid>"&categoryid
set rs=conn.execute(psql)
catleft=rs("catleft")
rs.close
set rs=nothing

'/// Get Category Files ///
catfiles=""
psql="select imagefile from xlaAIGimages where categoryid="&categoryid
set rs=conn.execute(psql)
do until rs.eof
	catfiles=catfiles&"<"&rs("imagefile")&">"
	rs.movenext
loop
rs.close
set rs=nothing


'/// Update Category and Store New Images ////
Set Fso = CreateObject("Scripting.FileSystemObject")
filesfound=scanfolders(catpath,categoryid)
set fso=nothing

psql="update xlaAIGcategories set images="&filesfound&" where categoryid="&categoryid
conn.execute(psql)

'/// Delete From database any file reference no longer available
catfiles=">"&catfiles&"<"
todelete=split(catfiles,"><")
for x=0 to ubound(todelete)
	if len(todelete(x))>0 then
		psql="delete from xlaAIGimages where imagefile like '"&replace(todelete(x),"'","''")&"' and categoryid="&categoryid
		conn.execute(psql)
	end if
next
conn.close
set conn=nothing

'/// Go To Next Folder ////
counter=counter+1
if counter<7 then response.redirect "buildindex2.asp?categoryid="&categoryid&"&counter="&counter
%>
<body>
<table width="100%" height="100%" border="0" cellpadding="2" cellspacing="2">
  <tr>
    <td align="center" valign="middle"><font color="#003366" size="2" face="Arial, Helvetica, sans-serif"><b>Now 
      Indexing : <%=catname%><br>
      Categories Left : <%=catleft%><br>
      Please wait...</b></font></td>
  </tr>
</table>
<meta http-equiv="refresh" content="0;URL=buildindex2.asp?categoryid=<%=categoryid%>">
</body>

