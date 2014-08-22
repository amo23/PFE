<!-- #include file="incSystem.asp" -->
<%

lvl=validate(1)

'//// Receive Search Criteria ////
text=request("text")&""
stext=replace(text,"'","''")
stext=replace(stext,"*","%")
catname=request("catname")&""
scatname=replace(catname,"'","''")
credit=request("credit")&""
credit=replace(credit,"'","''")
status=request("status")
uploadedby=request("uploadedby")&""
suploadedby=replace(uploadedby,"'","''")
datecriteria=request("datecriteria")
date1=request("year1")&"/"&request("month1")&"/"&request("day1")
date2=request("year2")&"/"&request("month2")&"/"&request("day2")

vxlaAIGimagescategories=replace(vxlaAIGimagescategories,"WHERE xlaAIGimages.status=1","",1,-1,1)
psql="SELECT * from "& vxlaAIGimagesCategories &" where (imagename like '%"&stext&"%' or imagedesc like '%"&stext&"%' or imagefile like '%"&stext&"%' or keywords like '%"&stext&"%' or additionalinfo like '%"&stext&"%')"
if catname<>"" then psql=psql & " and catname like '%"&scatname&"%'"
if credit<>"" then psql=psql & " and (copyright like '%"&credit&"%' or credit like '%"&credit&"%') "
if uploadedby<>"" then psql=psql & " and uploadedby like '%"&uploadedby&"%'"


if datecriteria<>"" and isdate(date1) and isdate(date2) then psql=psql & " and imagedate>='"&date1&"' and imagedate<='"&date2&"'"
if status<>"" then psql=psql & " and status="&status 
psql=psql &" order by imagename,catname asc;"
searchsql=psql

if not(isdate(date1)) then date1=now
if not(isdate(date2)) then date2=now

mypage=request("whichpage")
if mypage="" then mypage=1
mypagesize=10
scriptname="search.asp?text="&server.urlencode(text)&"&catname="&server.urlencode(catname)&"&datecriteria="&datecriteria&"&date1="&server.urlencode(date1)&"&date2="&server.urlencode(date2)&"&uploadedby="&server.urlencode(uploadedby)&"&status="&status&"&credit="&credit

set conn=server.createobject("ADODB.Connection")
conn.open connection


kill=request("kill")
if kill<>"" then
	call deletefile(kill)
end if
%>
<html>
<head>
<title><%=title%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script language="JavaScript">
function deletefile(fileid){
	if (confirm('Delete This File?')){
		self.location.href='<%=scriptname%>&whichpage=<%=mypage%>&kill=' + fileid;
	}
}

function popup(what){
	window.open(escape(what),"","toolbar=0,location=0,status=1,menubar=1,scrollbars=1,resizable=1,width=580,height=400");
}
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000">
<form name="form1" method="post" action="search.asp">
  <table width="96%" border="0" cellspacing="1" cellpadding="2" align="center">
    <tr> 
      <td colspan="2"> <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td><font size="2" face="Arial, Helvetica, sans-serif"><b><img src="images/icSearch.gif" width="20" height="19" align="absmiddle">Search 
              Files </b></font></td>
            <td> <div align="right"><a href="buildindex.asp"><img src="images/btnRebuildIndex.gif" width="114" height="18" alt="Rebuld Gallery Index" border="0"></a> 
              </div></td>
          </tr>
        </table></td>
    </tr>
    <tr> 
      <td colspan="2" bgcolor="#666666"></td>
    </tr>
    <tr> 
      <td colspan="2" bgcolor="#F3F3F3"><font size="1" face="Arial, Helvetica, sans-serif">Use 
        this option to browse through your files by defining any search criteria. 
        If you don't define any criteria, all of your files will be shown. </font></td>
    </tr>
    <tr> 
      <td colspan="2" bgcolor="#666666"></td>
    </tr>
    <tr> 
      <td width="25%" bgcolor="#CCCCCC"><b><font size="2" face="Arial, Helvetica, sans-serif">Keywords 
        :</font></b></td>
      <td width="75%" bgcolor="#EFEFEF"><font size="2" face="Arial, Helvetica, sans-serif"> 
        <input type="text" name="text" size="50" value="<%=text%>">
        </font></td>
    </tr>
    <tr> 
      <td width="25%" bgcolor="#CCCCCC"><b><font size="2" face="Arial, Helvetica, sans-serif">Category 
        :</font></b></td>
      <td width="75%" bgcolor="#EFEFEF"><font size="2" face="Arial, Helvetica, sans-serif"> 
        <input type="text" name="catname" size="50" value="<%=catname%>">
        </font></td>
    </tr>
    <tr> 
      <td bgcolor="#CCCCCC"><font size="2" face="Arial, Helvetica, sans-serif"><b>Credit 
        :</b></font></td>
      <td bgcolor="#EFEFEF"><font size="2" face="Arial, Helvetica, sans-serif">
        <input name="credit" type="text" id="credit" value="<%=credit%>" size="50" maxlength="200">
        </font></td>
    </tr>
    <tr> 
      <td bgcolor="#CCCCCC"><b><font size="2" face="Arial, Helvetica, sans-serif">Uploaded 
        by :</font></b></td>
      <td bgcolor="#EFEFEF"><font size="2" face="Arial, Helvetica, sans-serif"> 
        <input name="uploadedby" type="text" id="uploadedby" value="<%=uploadedby%>" size="50" maxlength="200">
        </font></td>
    </tr>
    <tr> 
      <td bgcolor="#CCCCCC"><b><font size="2" face="Arial, Helvetica, sans-serif">Status 
        : </font></b></td>
      <td bgcolor="#EFEFEF"><select name="status">
          <option value=""> -- Any -- </option>
          <option value="0" <%if status="0" then response.write " selected"%>><%=whichstatus(0)%></option>
          <option value="1" <%if status="1" then response.write " selected"%>><%=whichstatus(1)%></option>
          <option value="2" <%if status="2" then response.write " selected"%>><%=whichstatus(2)%></option>
        </select></td>
    </tr>
    <tr> 
      <td width="25%" bgcolor="#CCCCCC"><b><font size="2" face="Arial, Helvetica, sans-serif"> 
        <input type="checkbox" name="datecriteria" value="checked" <%=datecriteria%>>
        Uploaded Between :</font></b></td>
      <td width="75%" bgcolor="#EFEFEF"><font size="2" face="Arial, Helvetica, sans-serif"> 
        <font size="1">(MM/DD/YYYY)</font> 
        <select name="month1">
          <%
			  	for x=1 to 12
				if x=month(date1) then sel=" selected" else sel=""
					response.write "<option"&sel&">"& right("0" & x ,2) & "</option>"
				next
			  %>
        </select>
        / 
        <select name="day1">
          <%
			  	for x=1 to 31
				if x=day(date1) then sel=" selected" else sel=""
					response.write "<option"&sel&">"& right("0" & x ,2) & "</option>"
				next
			  %>
        </select>
        / 
        <select name="year1">
          <%
			  a=year(date1)
			  for x=year(now)-10 to year(now)+10
			  	if x=a then sel=" selected" else sel=""
			  	response.write "<option"&sel&">"& x&"</option>"	
			  next 
			  %>
        </select>
        And 
        <select name="month2">
          <%
			  	for x=1 to 12
				if x=month(date2) then sel=" selected" else sel=""
					response.write "<option"&sel&">"& right("0" & x ,2) & "</option>"
				next
			  %>
        </select>
        / 
        <select name="day2">
          <%
			  	for x=1 to 31
				if x=day(date2) then sel=" selected" else sel=""
					response.write "<option"&sel&">"& right("0" & x ,2) & "</option>"
				next
			  %>
        </select>
        / 
        <select name="year2">
          <%
			  a=year(date2)
			  for x=year(now)-10 to year(now)+10
			  	if x=a then sel=" selected" else sel=""
			  	response.write "<option"&sel&">"& x&"</option>"	
			  next 
			  %>
        </select>
        </font></td>
    </tr>
    <tr align="right"> 
      <td colspan="2" bgcolor="#666666"> <input type="submit" name="Submit" value="Search Files"> 
      </td>
    </tr>
  </table>
</form>
<table border="0" cellspacing="1" width="96%" cellpadding="0" align="center">
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
    <td width="100%" align="left" valign="top"> <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td width="58%"><font face="Arial, Helvetica, sans-serif" size="2"><b>Files 
            Found </b><b> : <%=maxval%><br>
            Page <%=mypage%> of <%=maxcount%></b></font></td>
          <td align="right" valign="bottom" width="42%"> <form name="form2" method="post" action="viewimages.asp" style="margin:0;">
              <textarea name="query" cols="1" rows="1" style="display:none;"><%=searchsql%></textarea>
              <input type="image" border="0" name="imageField" src="images/btnBrowseThis.gif" width="114" height="18">
            </form></td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td width="0" align="left" valign="top" height="0"> <table border="0" cellpadding="3" width="100%">
        <tr bgcolor="#003399"> 
          <td align="right" width="5%"><b><font color="#FFFFFF" face="Arial, Helvetica, sans-serif" size="2">#</font></b></td>
          <td align="left"><b><font color="#FFFFFF" face="Arial, Helvetica, sans-serif" size="2">File</font><br>
            </b></td>
          <td align="center" width="15%"><b><font color="#FFFFFF" face="Arial, Helvetica, sans-serif" size="2">Category</font><font color="#FFFFFF" face="Arial, Helvetica, sans-serif" size="2"><br>
            </font></b></td>
          <td width="24%"  align="center"><b><font color="#FFFFFF" face="Arial, Helvetica, sans-serif" size="2">Thumbnail</font><font color="#FFFFFF" face="Arial, Helvetica, sans-serif" size="2"><br>
            <font size="1">(Click To View Full File)</font><br>
            </font></b></td>
          <td  align="center" width="8%"><font color="#FFFFFF" size="2" face="Arial, Helvetica, sans-serif"><b>Status</b></font></td>
          <td  align="center" width="11%"><b><font size="2" color="#FFFFFF" face="Arial, Helvetica, sans-serif">Stats</font><font size="2" color="#FFFFFF" face="Arial, Helvetica, sans-serif"><br>
            </font></b></td>
          <td  align="center" width="8%"><b><font size="2" color="#FFFFFF" face="Arial, Helvetica, sans-serif">View</font></b></td>
          <td  align="center" width="8%"><b><font size="2" color="#FFFFFF" face="Arial, Helvetica, sans-serif">Delete</font></b></td>
        </tr>
        <%
	cc=(mypagesize*mypage)-mypagesize
	do until rs.eof or howmanyrecs>=rs.pagesize
		cc=cc+1
		imageid=rs("imageid")
		imagename=rs("imagename")
		imagename=replace(imagename,"_"," ")
		imagedesc=left(rs("imagedesc")&"",200)
		imagefile=rs("imagefile")
		catname=rs("catname")
		categoryid=rs("categoryid")
		imagesize=rs("imagesize")
		totalrating=rs("totalrating")
		totalreviews=rs("totalreviews")
		rating=getrating(totalrating,totalreviews)
		hits=rs("hits")
		imagesize=getsize(rs("imagesize"))
		imagedate=getdate(rs("imagedate"))
		imagepath=rs("catpath")&imagefile
		categoryid=rs("categoryid")
		thumbnail=gettn(rs("catpath"),rs("imagefile"))
		status=rs("status")
		%>
        <tr bgcolor="#EAEAEA"> 
          <td width="5%" align="right" valign="top" bgcolor="#EAEAEA"><font face="Arial, Helvetica, sans-serif" size="2"><%=cc%>.</font></td>
          <td bgcolor="#EAEAEA" align="left" valign="top"><font face="Arial, Helvetica, sans-serif" size="2"><a              href="viewimages.asp?imageid=<%=imageid%>&categoryid=<%=categoryid%>"><b><%=imagename%></b></a></font><br> <font face="Verdana, Arial, Helvetica, sans-serif" size="1">- 
            File : <%=imagefile%><br>
            - Size : <%=imagesize%><br>
            - Date : <%=imagedate%><br>
            - Description : <%=server.htmlencode(imagedesc)%></font></td>
          <td width="15%" align="center" valign="top"> <font face="Arial, Helvetica, sans-serif" size="2"><a href="categories.asp?categoryid=<%=categoryid%>"><b><%=catname%></b></a></font></td>
          <td width="24%" align="center" valign="top"> <a href="javascript:popup('<%=preparecode(imagepath)%>');"><img src="<%=thumbnail%>" alt="<%=imagename%>" border="0"></a></td>
          <td width="8%" align="center" valign="top"><font size="1" face="Verdana, Arial, Helvetica, sans-serif"><img src="images/<%=status%>.gif" width="27" height="27"><br>
            <b><%=whichstatus(status)%></b></font> </td>
          <td width="11%" align="center" valign="top"> <font face="Arial, Helvetica, sans-serif" size="1">Hits 
            : <%=hits%><br>
            Rated : <%=rating%><br></font><font size="1" face="Verdana, Arial, Helvetica, sans-serif"><br>
            </font> </td>
          <td width="8%" align="center" valign="top"> <b><a href="viewimages.asp?imageid=<%=imageid%>&categoryid=<%=categoryid%>"><img src="images/btnView.gif" width="27" height="27" border="0" alt="View file"></a></b> 
          </td>
          <td width="8%" align="center" valign="top"> <b><a href="javascript:deletefile(<%=imageid%>);"><img src="images/btnKill.gif" width="27" height="27" border="0" alt="Delete file"></a></b></td>
        </tr>
        <%
		rs.movenext
		howmanyrecs=howmanyrecs+1
		loop
		set fs=nothing
			%>
      </table></td>
  </tr>
  <tr>
    <td bgcolor="#666666"></td>
  </tr>
  <tr align="center"> 
    <td width="100%" valign="top" align="left"><b><font face="Arial, Helvetica, sans-serif" size="2">Go 
      to Page : 
      <select name="pageselector" onchange="javascript:gopage(this.value);">
        <%
		for counter=1 to maxcount
		if counter-mypage=0 then sel=" selected" else sel=""
			response.write "<option value="&counter&sel&">"&counter&"</option>"
		next
		%>
      </select>
      <script language="JavaScript">
	  function gopage(what){
	  	self.location.href='<%=scriptname%>&whichpage=' + what;
	  }
	  </script>
      <%if cint(mypage)>1 then response.write "<a href='"&scriptname&"&orderby="&server.urlencode(orderby)&"&whichpage="&mypage-1&"'>&lt;&lt;</a> "  
	  if cint(mypage)<maxcount then response.write "<a href='"&scriptname&"&orderby="&server.urlencode(orderby)&"&whichpage="&mypage+1&"'>&gt;&gt;</a>"%>
      </font></b></td>
  </tr>
  <%else%>
  <tr align="center"> 
    <td width="100%" valign="top" align="left"> <p align="center"><b><font face="Arial, Helvetica, sans-serif" size="2" color="#FF0000">No 
        files were found for the specified criteria</font></b> <br>
      
      <p align="center">&nbsp; </td>
  </tr>
  <%end if%>
</table>
</body>
</html>
<%
rs.close
set rs=nothing
conn.close
set conn=nothing

%>
