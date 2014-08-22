<!-- #include file="incSystem.asp" -->
<%
'//// Receive Search Criteria ////
text=request("text")&""
stext=replace(text,"'","''")
stext=replace(stext,"*","%")
catname=request("catname")&""
scatname=replace(catname,"'","''")
psql="SELECT xlaAIGimages.*, xlaAIGcategories.catname,xlaAIGcategories.catpath FROM xlaAIGcategories INNER JOIN xlaAIGimages ON xlaAIGcategories.categoryid = xlaAIGimages.categoryid where where (imagename like '%"&stext&"%' or imagedesc like '%"&stext&"%' or imagefile like '%"&stext&"%') and (catname like '%"&catname&"%') "
psql=psql & "order by imagename,catname asc;"
searchsql=psql
mypage=request("whichpage")
if mypage="" then mypage=1
mypagesize=12
scriptname="aig-anm.asp?text="&server.urlencode(text)&"&catname="&server.urlencode(catname)

set conn=server.createobject("ADODB.Connection")
conn.open connection
%>
<html>
<head>
<title>Absolute Image Gallery  : Media Browser</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script language="JavaScript">
function popup(what){
	window.open(what,"","toolbar=0,location=0,status=1,menubar=1,scrollbars=1,resizable=1,width=580,height=400");
}

function passimage(what)
{
	what='./articlefiles/r.asp?f=' + what;
	window.opener.idContent.document.execCommand("InsertImage",false,what);
	self.close();
}

function passinfo(imagetitle,imagedesc,what)
{
	window.opener.form1.filetitle.value=imagetitle;
	window.opener.form1.filecomment.value=imagedesc;
	what='./articlefiles/r.asp?f=' + what;
	window.opener.form1.fileurl.value=what;
	self.close();
}
function window.onload(){
	self.focus();
}
</script>
<style>
	<!--
        A:link {text-decoration: font-weight:bolder; color: blue}
        A:visited {text-decoration: font-weight:bolder; color: blue}
        A:active {text-decoration: font-weight:bolder; color: green}
        A:hover {text-decoration: font-weight:bolder; color: red}
	-->		
</style>
</head>

<body bgcolor="#F0F0F0" text="#666666" leftmargin="0" topmargin="0" rightmargin="0" bottommargin="0">
<form name="form1" method="post" action="aig-anm.asp" styel="margin:0">
  <table border="0" cellspacing="1" cellpadding="2" align="center">
    <tr> 
      <td align="center"><font size="2"><font face="Tahoma, Verdana, Arial"><b>Absolute 
        Image Gallery : Media Browser<br>
        </b>Keywords :</font> <font face="Tahoma, Verdana, Arial" size="2"> 
        <input type="text" name="text" size="14" value="<%=text%>" maxlength="200" style="font-size:9">
        Category :</font> <font face="Tahoma, Verdana, Arial" size="2"> 
        <input type="text" name="catname" size="14" value="<%=catname%>" maxlength="200" style="font-size:9">
        <input type="submit" name="Submit" value="Search" style="font-size:9">
        </font><font size="2"><font face="Tahoma, Verdana, Arial" size="2">
        <input type="button" name="Submit2" value="Close" style="font-size:9" onclick="javascript:self.close();">
        </font></font><font face="Tahoma, Verdana, Arial" size="2"> </font></font></td>
    </tr>
  </table>
  <table border="0" cellspacing="1" width="98%" cellpadding="0" align="center">
    <%
set rs=server.createobject("ADODB.Recordset")
rs.open searchsql,conn,1 
if not(rs.eof) then 
	Set Fs=createobject("scripting.filesystemobject")
	maxval=rs.recordcount
	rs.movefirst
	rs.pagesize=mypagesize
	maxcount=cint(rs.pagecount)
	rs.absolutepage=mypage
	howmanyrecs=0
	howmanyfields=rs.fields.count-1
%>
    <tr> 
    <td width="0" align="left" valign="top" height="0"> 
      <table width="100%" border="0" cellspacing="1" cellpadding="4" bgcolor="#666666">
        <%do until rs.eof or howmanyrecs>=rs.pagesize%>
		<tr bgcolor="#FFFFFF"> 
		<%
		for x=1 to 3
		imageid=rs("imageid")
		imagename=rs("imagename")
		imagedesc=rs("imagedesc")
		imagefile=rs("imagefile")
		if imagefile<>imagename then imagename=imagename & " ("&imagefile&")"
		catname=rs("catname")
		categoryid=rs("categoryid")
		imagesize=rs("imagesize")
		imagesize=getsize(rs("imagesize"))
		imagedate=getdate(rs("imagedate"))
		imagepath=rs("imagepath")
		preparedcode=preparecode(imagepath)
		categoryid=rs("categoryid")
		thumbnail=gettn(rs("catpath"),rs("imagefile"))
		thefunction="javascript:passinfo('"&preparecode(imagename)&"','"&preparecode(imagedesc)&"','"&preparedcode&"');"
		%>        
		    <td valign="middle" align="center" width="33%" height="100%"> 
              <table width="100%" border="0" cellspacing="2" cellpadding="2" height="100%">
                <tr> 
                  <td align="center" valign="middle" height="100%"><font face="Tahoma, Verdana, Arial" size="1"><a href="javascript:popup('<%=preparedcode%>');"><img src="<%=thumbnail%>" alt="<%=imagename%>" border="0"></a></font></td>
                </tr>
                <tr> 
                  <td bgcolor="#EFEFEF" align="center"><font face="Tahoma, Verdana, Arial" size="1"><b><a href="javascript:popup('<%=preparecode(imagepath)%>');"><%=imagename%><br>
                    </a></b><%=imagedesc%><br>
                    [ <a href="<%=thefunction%>">Select</a> ]</font></td>
                </tr>
              </table>
            </td>
		<%rs.movenext
		howmanyrecs=howmanyrecs+1
		if rs.eof then exit for
		next%>
        </tr>
        <%
		loop
		set fs=nothing
		%>
      </table>
    </td>
  </tr>
  <tr align="center"> 
      <td width="100%" valign="top" align="left"><font face="Tahoma, Verdana, Arial" size="2">Files 
        Found : <%=maxval%> (Page <%=mypage%> of <%=maxcount%>)<br>
        Go to Page : 
        <%
				pad="0"
				
				
				for counter=1 to maxcount
					if counter>=10 then	pad=""
					ref="<a href='"&scriptname&"&whichpage="&counter&"'>"&pad&counter&"</a>"
					response.write ref & " "
					if counter mod 30 = 0 then response.write "<br>"
				next
%>
        </font></td>
  </tr>
  <%else%>
  <tr align="center"> 
    <td width="100%" valign="top" align="left"> 
      <p align="center">&nbsp; 
        <p align="center"><b><font face="Arial, Helvetica, sans-serif" size="2" color="#FF0000">No 
          Files were found for the specified criteria</font></b> <br>
      <p align="center">&nbsp; 
    </td>
  </tr>
  <%end if%>
</table>
</form>
</body>
</html>
<%
rs.close
set rs=nothing
conn.close
set conn=nothing

%>
