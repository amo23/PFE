<!--#include file="incSystem.asp"-->
<%
lvl=validate(1)
imageid=request("imageid")
if imageid="" or not(isnumeric(imageid)) then 
	response.write "<script language=JavaScript>history.back();</script>"
	response.end 
end if

set conn=server.createobject("ADODB.Connection")
conn.open connection

psql="SELECT xlaAIGimages.*, xlaAIGcategories.catname,xlaAIGcategories.catpath FROM xlaAIGcategories INNER JOIN xlaAIGimages ON xlaAIGcategories.categoryid = xlaAIGimages.categoryid where imageid="&imageid
set rs=conn.execute(psql)
categoryid=rs("categoryid")
catpath=rs("catpath")
imagefile=rs("imagefile")
originalimagepath=getpath(catpath)&imagefile
originaltnpath=getpath(catpath)&"tn\"&tnprefix&imagefile
rs.close
set rs=nothing

newcategoryid=request("newcategoryid")
if newcategoryid<>"" then
	'/// Get new Target path
	psql="select catpath from xlaAIGcategories where categoryid="&newcategoryid 
	set rs=conn.execute(psql)
	targetpath=getpath(rs("catpath"))&imagefile
	targettnpath=getpath(rs("catpath"))&"tn\"&tnprefix&imagefile
	rs.close
	set rs=nothing

	'/// Move File to new category
	psql="update xlaAIGimages set categoryid="&newcategoryid&" where imageid="&imageid 
	conn.execute(psql)
	conn.close
	set conn=nothing
	Set Fs=createobject("scripting.filesystemobject")
	if fs.fileexists(originalimagepath) then fs.movefile originalimagepath, targetpath
	if fs.fileexists(originaltnpath) then fs.movefile originaltnpath,targettnpath
	set fs=nothing
	response.redirect "loadimage.asp?imageid="&imageid
end if


%>
<html>
<head>
<title><%=title%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" rightmargin="0" bottommargin="0">
<form name="form1" method="post" action="changecategory.asp" target="loadimage">
  <div align="center">
    <select name="newcategoryid" size="11" style="width:100%;">
      <%
		psql="select * from xlaAIGcategories order by catpath asc;"
		set rs=conn.execute(psql)
		do until rs.eof
			if rs("categoryid")-categoryid=0 then sel=" selected" else sel=""
			response.write "<option value="&rs("categoryid")&sel&">"&ocurrences(rs("catpath"),rs("catname"))&"</option>"	
			rs.movenext
		loop
		rs.close
		set rs=nothing
		conn.close
		set conn=nothing%>
    </select>
    <input name="cancel" type="button" value="Cancel" onclick="javascript:history.back();">
    <input type="submit" name="Submit" value="Move">
    <input name="imageid" type="hidden" id="imageid" value="<%=imageid%>">
  </div>
</form>
</body>
</html>

