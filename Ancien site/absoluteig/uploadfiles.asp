<!--#include file="incSystem.asp" -->
<!--#include file="incUpload.asp" -->
<%
lvl=validate(1)


categoryid=request("categoryid")
if categoryid="" or not(isnumeric(categoryid)) then categoryid=0
doupload=request("doupload")

set conn=server.createobject("ADODB.Connection")
conn.open connection

dim thisfile,categoryid,imagename,datecreated,imagedesc,keywords,copyright,credit,filesize,status,source,uploadedby,email,infourl,additionalinfo,embedhtml
function savefile()
	psql="select * from xlaAIGimages where imagefile='"&thisfile&"' and categoryid="&categoryid
	Set rs = Server.CreateObject("ADODB.Recordset") 
	rs.open psql,conn,1,2
	if rs.eof then rs.addnew
	rs("imagefile")=thisfile
	rs("categoryid")=categoryid
	rs("imagename")=imagename
	rs("datecreated")=datecreated
	rs("imagedesc")=imagedesc
	rs("keywords")=keywords
	rs("copyright")=copyright
	rs("credit")=credit
	rs("source")=source
	rs("email")=email
	rs("infourl")=infourl
	rs("imagesize")=filesize
	rs("imagedate")=todaydate
	rs("status")=status
	rs("uploadedby")=uploadedby
	rs("additionalinfo")=additionalinfo
	rs("embedhtml")=embedhtml
	rs.update
	rs.close
	set rs=nothing
end function

if doupload<>"" then
	dim msg
	psql="select catpath from xlaAIGcategories where categoryid="&categoryid
	set rs=conn.execute(psql)
	catpath=getpath(rs("catpath"))
	if istn<>"" then catpath=catpath & "\tn"
	rs.close
	set rs=nothing
	call upload(catpath,"","")
	if msg="" then msg="<font color='#FF0000'>Error - The File could not be uploaded : No File provided</font>" 
end if
%>

<html>
<head>
<title><%=title%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script language="JavaScript">
function upload(){
	condit='';
	categoryid=form1.category.value;
	form1.action='uploadfiles.asp?doupload=1&categoryid=' + categoryid
	form1.submit();
}

</script>
</head>

<body bgcolor="#FFFFFF" text="#000000" topmargin="5">
<form name="form1" method="post" action="uploadfiles.asp?doupload=1" ENCTYPE="multipart/form-data">
  <table width="96%" border="0" cellspacing="2" cellpadding="2" align="center">
    <tr> 
      <td width="25%"><font face="Arial, Helvetica, sans-serif" size="2"><b><img src="images/icUpload.gif" width="18" height="19"> 
        Upload Files </b></font></td>
      <td width="75%" align="right"><a href="buildindex.asp"><img src="images/btnRebuildIndex.gif" width="114" height="18" border="0"></a></td>
    </tr>
    <tr> 
      <td colspan="2" bgcolor="#666666"></td>
    </tr>
    <tr> 
      <td colspan="2" bgcolor="#F3F3F3"><font face="Arial, Helvetica, sans-serif" size="1">Use 
        this form to upload new files to the gallery. Rebuilding the Gallery Index 
        is recommended after finishing</font></td>
    </tr>
    <tr> 
      <td colspan="2" bgcolor="#666666"></td>
    </tr>
    <%if msg<>"" then%>
    <tr align="left" valign="top" bgcolor="#CCCCCC"> 
      <td colspan="2"><b><font size="2" face="Arial, Helvetica, sans-serif"><%=msg%></font></b></td>
    </tr>
    <tr align="left" valign="top"> 
      <td colspan="2" bgcolor="#999999"></td>
    </tr>
    <%end if%>
    <tr align="left" valign="top"> 
      <td width="25%" bgcolor="#CCCCCC"><b><font face="Arial, Helvetica, sans-serif" size="2">Target 
        Category :</font></b></td>
      <td bgcolor="#F3F3F3"> <select name="category">
          <%
		psql="select * from xlaAIGcategories"
		if query<>"" then psql=psql &" where categoryid in ("&replace(query,"select *","select categoryid")&")"
		psql=psql & " order by catpath asc;"
		set rs=conn.execute(psql)
		do until rs.eof
			if firstcat=0 then firstcat=rs("categoryid")
			if rs("categoryid")-categoryid=0 then sel=" selected" else sel=""
			response.write "<option value="&rs("categoryid")&sel&">"&ocurrences(rs("catpath"),rs("catname"))&"</option>"	
			rs.movenext
		loop
		rs.close
		set rs=nothing
		conn.close
		set conn=nothing
		%>
        </select> </td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="25%" bgcolor="#CCCCCC"><b><font face="Arial, Helvetica, sans-serif" size="2">File 
        To Upload :</font></b></td>
      <td bgcolor="#F3F3F3"> <input type="FILE" name="file" size="40" style=""> 
        <br> <font face="Arial, Helvetica, sans-serif"> <font size="1"> Files 
        with a &quot;<%=tnprefix%>&quot; prefix, will be uploaded as thumbnails </font></font></td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="25%" bgcolor="#CCCCCC"><b><font face="Arial, Helvetica, sans-serif" size="2">File 
        Name :</font></b></td>
      <td bgcolor="#F3F3F3"> <input type="text" name="imagename" size="40" maxlength="254"> 
      </td>
    </tr>
    <tr align="left" valign="top"> 
      <td bgcolor="#CCCCCC"><b><font face="Arial, Helvetica, sans-serif" size="2">Date 
        Created :</font></b></td>
      <td bgcolor="#F3F3F3"> <input name="datecreated" type="text" size="40" maxlength="254"> 
      </td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="25%" bgcolor="#CCCCCC"><b><font face="Arial, Helvetica, sans-serif" size="2">Description 
        :</font></b></td>
      <td bgcolor="#F3F3F3"> <textarea name="imagedesc" cols="40" rows="2"></textarea></td>
    </tr>
    <tr align="left" valign="top"> 
      <td bgcolor="#CCCCCC"><b><font size="2" face="Arial, Helvetica, sans-serif">Keywords 
        :</font></b></td>
      <td bgcolor="#F3F3F3"><textarea name="keywords" cols="40" rows="2"></textarea></td>
    </tr>
    <tr align="left" valign="top"> 
      <td bgcolor="#CCCCCC"><b><font size="2" face="Arial, Helvetica, sans-serif">Copyright 
        :</font></b></td>
      <td bgcolor="#F3F3F3"><input name="copyright" type="text" size="40" maxlength="254"></td>
    </tr>
    <tr align="left" valign="top"> 
      <td bgcolor="#CCCCCC"><b><font size="2" face="Arial, Helvetica, sans-serif">Credit 
        :</font></b></td>
      <td bgcolor="#F3F3F3"><input name="credit" type="text" size="40" maxlength="254"></td>
    </tr>
    <tr align="left" valign="top"> 
      <td bgcolor="#CCCCCC"><font size="2" face="Arial, Helvetica, sans-serif"><b>Status 
        : </b> </font></td>
      <td bgcolor="#F3F3F3"><select name="status">
          <option value="0" <%if defaultuploadstatus=0 then response.write " selected"%>><%=whichstatus(0)%></option>
          <option value="1" <%if defaultuploadstatus=1 then response.write " selected"%>><%=whichstatus(1)%></option>
          <option value="2" <%if defaultuploadstatus=2 then response.write " selected"%>><%=whichstatus(2)%></option>
        </select></td>
    </tr>
    <tr align="left" valign="top"> 
      <td bgcolor="#CCCCCC"><font size="2" face="Arial, Helvetica, sans-serif"><b>Source 
        :</b></font></td>
      <td bgcolor="#F3F3F3"><input name="source" type="text" size="40" maxlength="254"></td>
    </tr>
    <tr align="left" valign="top"> 
      <td bgcolor="#CCCCCC"><b><font size="2" face="Arial, Helvetica, sans-serif">Uploaded 
        By :</font></b></td>
      <td bgcolor="#F3F3F3"><input name="uploadedby" type="text" size="40" maxlength="254"></td>
    </tr>
    <tr align="left" valign="top"> 
      <td bgcolor="#CCCCCC"><b><font size="2" face="Arial, Helvetica, sans-serif">E-Mail 
        :</font></b></td>
      <td bgcolor="#F3F3F3"><input name="email" type="text" size="40" maxlength="254"></td>
    </tr>
    <tr align="left" valign="top"> 
      <td bgcolor="#CCCCCC"><b><font size="2" face="Arial, Helvetica, sans-serif">URL 
        :</font></b></td>
      <td bgcolor="#F3F3F3"><input name="infourl" type="text" size="40" maxlength="254"></td>
    </tr>
    <tr align="left" valign="top"> 
      <td bgcolor="#CCCCCC"><b><font size="2" face="Arial, Helvetica, sans-serif">Additional 
        Info : </font></b></td>
      <td bgcolor="#F3F3F3"><textarea name="additionalinfo" cols="40" rows="4"></textarea></td>
    </tr>
    <tr align="left" valign="top"> 
      <td bgcolor="#CCCCCC"><font size="2" face="Arial, Helvetica, sans-serif"><b>Embed 
        HTML : </b></font></td>
      <td bgcolor="#F3F3F3"><textarea name="embedhtml" cols="40" rows="4"></textarea> 
        <br> <font size="1" face="Arial, Helvetica, sans-serif">Use this field 
        for integrating HTML code with the file. <br>
        For example : Integrating this file with a shopping cart</font></td>
    </tr>
    <tr> 
      <td width="25%" bgcolor="#CCCCCC">&nbsp;</td>
      <td width="75%" bgcolor="#F3F3F3"> <input type="button" name="Button" value="Upload File" onclick="javascript:upload();"> 
      </td>
    </tr>
  </table>
</form>
</body>
</html>

