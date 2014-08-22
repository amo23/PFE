<!-- #include file="incSystem.asp" -->
<%
lvl=validate(0)
if lvl=0 and pblusers<>"" then response.redirect "logout.asp"

zoneid=request("zoneid")
if zoneid="" or not(isnumeric(zoneid)) then zoneid=0
plevel=request("plevel")
name=request("name")
set conn=server.createobject("ADODB.Connection")
conn.open connection

psql="select * from publishers where name like '%"&name&"%'"
if zoneid>0 then psql=psql & " and publisherid in (select publisherid from publisherszones where zoneid="&zoneid&")"
if plevel<>"" then psql=psql & " and plevel="&plevel
psql=psql & " order by plevel desc,name asc;"

mypage=request("whichpage")
if mypage="" then mypage=1
mypagesize=10
scriptname="publishers.asp?name="&server.urlencode(name)&"&zoneid="&zoneid&"&plevel="&plevel
searchsql=psql

kill=request("kill")
if kill<>"" and lvl=2 then
	if kill-usrid<>0 then
		psql="delete from publishers where publisherid="&kill
		conn.execute(psql)
	else
		errormsg="You cannot delete yourself"
	end if
end if
%>
<html>
<head>
<title><%=title%></title>
<meta http-equiv="Content-Type" content="text/html; charset=<%=charset%>">
<script language="JavaScript">
<%if lvl=2 then%>
function editpublisher(publisherid){
	self.location='editpublisher.asp?publisherid=' + publisherid;
}

function deletepublisher(publisherid){
	if (confirm('Delete this User?')){
		self.location='publishers.asp?whichpage=<%=mypage%>&kill=' + publisherid;
	}
}
<%else
img="0"%>
function editpublisher(publisherid){
	alert('This option is only available to system administrators');
}

function deletepublisher(publisherid){
	editpublisher(publisherid);
}
<%end if%>
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000">
<form name="form1" method="post" action="">
  <table width="90%" border="0" cellspacing="2" cellpadding="1" align="center">
    <tr> 
      <td height="50%" colspan="8" align="left" valign="top"> 
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td> <font face="Arial, Helvetica, sans-serif" size="2"><b><img src="images/icPublishers.gif" width="18" height="20" align="absmiddle"> 
              Users</b></font></td>
            <td> 
              <div align="right"> 
                <%if lvl=2 then%>
                <a href="editpublisher.asp"><img src="images/btnAddPublisher.gif" width="114" height="18" border="0" alt="Register a New User"></a> 
                <%end if%>
              </div>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td height="50%" colspan="8" align="left" valign="top" bgcolor="#666666"> 
      </td>
    </tr>
    <%if errormsg<>"" then%>
    <tr> 
      <td height="50%" colspan="8" align="left" valign="top"><font face="Arial, Helvetica, sans-serif" size="2"><b><font color="#FF0000">Error 
        : The user could not be deleted - </font></b><%=errormsg%></font></td>
    </tr>
    <%end if%>
    <tr> 
      <td colspan="8" align="left"> 
        <table width="100%" border="0" cellspacing="1" cellpadding="2">
          <tr> 
            <td width="28%" bgcolor="#CCCCCC"><b><font face="Arial, Helvetica, sans-serif" size="2">User 
              Name / Email:</font></b></td>
            <td width="72%" bgcolor="#F3F3F3"><b> 
              <input type="text" name="name" value="<%=name%>" size="50" maxlength="255">
              </b></td>
          </tr>
          <tr> 
            <td width="28%" bgcolor="#CCCCCC"><b><font face="Arial, Helvetica, sans-serif" size="2">Level 
              :</font></b></td>
            <td width="72%" bgcolor="#F3F3F3"><font size="2" face="Arial, Helvetica, sans-serif"> 
              <select name="plevel">
                <option value=''> -- All -- </option>
                <%for x=0 to 2
			  	if plevel<>"" then
					if x-plevel=0 then sel=" selected" else sel=""
				end if
				response.write "<option value="&x&sel&">"&whichlevel(x)&"</option>"
			  next%>
              </select>
              </font></td>
          </tr>
          <tr> 
            <td width="28%" bgcolor="#CCCCCC"><b><font face="Arial, Helvetica, sans-serif" size="2">Assigned 
              To Zone : </font></b></td>
            <td width="72%" bgcolor="#F3F3F3"><b><font size="2" face="Arial, Helvetica, sans-serif"> 
              <select name="zoneid">
                <option value=0> - All -</option>
                <%
		psql="select * from zones order by zonename asc;"
		set rs=conn.execute(psql)
		do until rs.eof
			if rs("zoneid")-zoneid=0 then sel=" selected" else sel=""
			response.write "<option value='"&rs("zoneid")&"'"&sel&">"&rs("zonename")&"</option>"
			rs.movenext
		loop
		rs.close
		set rs=nothing
		%>
              </select>
              </font></b></td>
          </tr>
          <tr bgcolor="#666666" align="right"> 
            <td colspan="2"> 
              <input type="submit" name="Submit" value="List Users">
            </td>
          </tr>
          <tr> 
            <td width="28%">&nbsp;</td>
            <td width="72%">&nbsp;</td>
          </tr>
        </table>
      </td>
    </tr>
    <%  
set rs=server.createobject("ADODB.Recordset")
rs.open searchsql,conn,1 
if not(rs.eof) then 
	maxval=rs.recordcount
	rs.movefirst
	rs.pagesize=mypagesize
	maxcount=cint(rs.pagecount)
	rs.absolutepage=mypage
	howmanyrecs=0
	howmanyfields=rs.fields.count-1
%>
    <tr> 
      <td colspan="8" align="left"> <b><font face="Arial, Helvetica, sans-serif" size="2">Users 
        Found : <%=maxval%><br>
        Page <%=mypage%> of <%=maxcount%></font></b></td>
    </tr>
    <tr> 
      <td width="3%" height="30" align="left" bgcolor="#003399"> 
        <div align="right"><b><font size="2" face="Arial, Helvetica, sans-serif" color="#FFFFFF">#</font></b></div>
      </td>
      <td width="30%" height="30" align="left" bgcolor="#003399"> 
        <div align="left"><b><font size="2" face="Arial, Helvetica, sans-serif" color="#FFFFFF">User's 
          Name </font></b></div>
      </td>
      <td width="27%" height="30" align="left" bgcolor="#003399"> <b><font size="2" face="Arial, Helvetica, sans-serif" color="#FFFFFF">Email</font></b></td>
      <td width="8%" height="30" bgcolor="#003399"> 
        <div align="center"><b><font face="Arial, Helvetica, sans-serif" color="#FFFFFF" size="2">Level</font></b></div>
      </td>
      <td width="8%" height="30" bgcolor="#003399"> 
        <div align="center"><font face="Arial, Helvetica, sans-serif" size="2" color="#FFFFFF"><b>ID</b></font></div>
      </td>
      <td width="8%" height="30" align="center" bgcolor="#003399"> <font size="2" color="#FFFFFF" face="Arial, Helvetica, sans-serif"><b>View</b></font></td>
      <td width="8%" height="30" align="center" bgcolor="#003399"> <b><font size="2" face="Arial, Helvetica, sans-serif" color="#FFFFFF">Edit</font></b></td>
      <td width="8%" height="30" align="center" bgcolor="#003399"> <b><font color="#FFFFFF" size="2" face="Arial, Helvetica, sans-serif">Delete</font></b></td>
    </tr>
    <%
	cc=(mypagesize*mypage)-mypagesize
	do until rs.eof or howmanyrecs>=rs.pagesize
		cc=cc+1
	%>
    <tr> 
      <td width="3%" align="left" valign="top" bgcolor="#F3F3F3"> 
        <div align="right"><b><font size="2" face="Arial, Helvetica, sans-serif"><%=cc%>.</font></b></div>
      </td>
      <td width="30%" align="left" valign="top" bgcolor="#F3F3F3"><font size="2" face="Arial, Helvetica, sans-serif"><b><a href="viewpublisher.asp?publisherid=<%=rs("publisherid")%>"><%=rs("name")%></a><font size="3" face="Arial, Helvetica, sans-serif"><br>
        </font></b></font></td>
      <td width="27%" align="left" valign="top" bgcolor="#F3F3F3"><font size="2" face="Arial, Helvetica, sans-serif"><b><a href="mailto:<%=rs("email")%>"><%=rs("email")%></a></b></font></td>
      <td width="8%" align="center" valign="top" bgcolor="#F3F3F3"><font size="2" face="Arial, Helvetica, sans-serif"><b><%=whichlevel(rs("plevel"))%></b></font> 
      </td>
      <td width="8%" align="center" valign="top" bgcolor="#F3F3F3"><font size="2" face="Arial, Helvetica, sans-serif"><b><%=rs("publisherid")%></b></font></td>
      <td width="8%" align="center" bgcolor="#F3F3F3"> <a href="viewpublisher.asp?publisherid=<%=rs("publisherid")%>"><img src="images/btnView.gif" width="27" height="27" border="0"></a></td>
      <td width="8%" align="center" bgcolor="#F3F3F3"> <font face="Arial, Helvetica, sans-serif" size="2"><a href="javascript:editpublisher(<%=rs("publisherid")%>)"><img src="images/btnEdit<%=img%>.gif" width="27" height="27" alt="Edit Publisher" border="0"></a> 
        </font></td>
      <td width="8%" align="center" bgcolor="#F3F3F3"> <font face="Arial, Helvetica, sans-serif" size="2"><a href="javascript:deletepublisher(<%=rs("publisherid")%>)"><img src="images/btnKill<%=img%>.gif" width="27" height="27" alt="Delete Publisher" border="0"></a></font></td>
      <%
		rs.movenext
		howmanyrecs=howmanyrecs+1
		loop
		rs.close
		set rs=nothing
%>
    <tr> 
      <td colspan="8" align="left" valign="top" bgcolor="#666666"></td>
    </tr>
    <tr> 
      <td colspan="8" align="left" valign="top"><b><font face="Arial, Helvetica, sans-serif" size="2">Go 
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
      <%if cint(mypage)>1 then response.write "<a href='"&scriptname&"&whichpage="&mypage-1&"'>&lt;&lt;</a> "  
	  if cint(mypage)<maxcount then response.write "<a href='"&scriptname&"&whichpage="&mypage+1&"'>&gt;&gt;</a>"%>
      </font></b></td>
    </tr>
    <%else%>
    <tr align="center" valign="middle"> 
      <td colspan="8"> 
        <p>&nbsp;</p>
        <p><font size="2" face="Arial, Helvetica, sans-serif" color="#FF0000"><b>No 
          Users Were Found For The Specified Criteria</b></font></p>
        <p>&nbsp;</p>
      </td>
    </tr>
    <%end if%>
  </table>
</form>
</body>
</html>
<%
conn.close
set conn=nothing
%>

