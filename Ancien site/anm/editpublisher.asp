<!-- #include file="incSystem.asp" -->
<%
lvl=validate(2)

publisherid=request("publisherid")
if publisherid="" or not(isnumeric(publisherid)) then publisherid=0
set conn=server.createobject("ADODB.Connection")
conn.open connection

'/// receive data ///
name=request("name")
email=request("email")
username=request("username")
password=request("password")
plevel=request("plevel")
additional=right(request("additional"),900)
zones=replace(request("zones")," ","")

if request("button")<>"" then
	
	if name<>"" and username<>"" and password<>"" then
		if publisherid>0 then condition=" and publisherid<>"&publisherid
		psql="select * from publishers where username='"&username&"'" & condition
		set rs=conn.execute(psql)
		if not(rs.eof) then errormsg="User Name already taken"
		rs.close
		set rs=nothing		
	else
		errormsg="You must provide at least a name, a user name and a password"
	end if


	'/// Save Publisher's Info ///
	if errormsg="" then
		psql="select * from publishers where publisherid="&publisherid
		Set rs = Server.CreateObject("ADODB.Recordset") 
		rs.open psql,conn,1,2
		if rs.eof then rs.addnew
		rs("name")=name
		rs("email")=email
		rs("username")=username
		rs("password")=password
		rs("plevel")=plevel
		rs("additional")=additional
		rs.Update 
		publisherid=rs("publisherid")
		rs.close
		set rs=nothing
		
		'/// Save Publisher's Zones ///
		psql="delete from publisherszones where publisherid="&publisherid
		conn.execute(psql)
		
		set rs=server.createobject("ADODB.Recordset")
		rs.open "publisherszones",conn,1,3,2
		tzones=split(zones,",")
		for x=0 to ubound(tzones)
			rs.addnew
			rs("zoneid")=tzones(x)
			rs("publisherid")=publisherid
			rs.update
		next
		rs.close
		set rs=nothing
		conn.close
		set conn=nothing
		response.redirect "viewpublisher.asp?publisherid="&publisherid
	end if
elseif publisherid>0 then
	psql="select * from publishers where publisherid="&publisherid
	set rs=conn.execute(psql)
	name=rs("name")
	email=rs("email")
	username=rs("username")
	password=rs("password")
	plevel=rs("plevel")
	additional=rs("additional")
	rs.close
	set rs=nothing
	
	'/// Zones ////
	psql="select * from publisherszones where publisherid="&publisherid
	set rs=conn.execute(psql)
	zones=","
	do until rs.eof
		zones=zones &rs("zoneid")&","
		rs.movenext
	loop
	rs.close
	set rs=nothing
	
end if


%>
<html>
<head>
<title><%=title%></title>
<meta http-equiv="Content-Type" content="text/html; charset=<%=charset%>">

</head>

<body bgcolor="#FFFFFF" text="#000000">
<form name="form1" method="post" action="editpublisher.asp">
  <table width="96%" border="0" cellspacing="2" cellpadding="2" align="center">
    <tr> 
      <td colspan="2">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="41%"><b><font size="2" face="Arial, Helvetica, sans-serif"><img src="images/icPublishers.gif" width="18" height="20" align="absmiddle"> 
              Edit User</font></b></td>
            <td width="59%"> 
              <div align="right"> 
                <%if publisherid>0 then%>
                <script language="JavaScript">
		function deletepublisher(){
			if (confirm('Delete this user?')){
				self.location='publishers.asp?kill=<%=publisherid%>';
			}
		}
		</script>
                <a href="javascript:deletepublisher()"><img src="images/btnDeletePublisher.gif" width="114" height="18" border="0" alt="Delete Publisher"></a> 
                <input type="hidden" name="publisherid" value="<%=publisherid%>">
                <%end if%>
              </div>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td colspan="2" bgcolor="#666666"></td>
    </tr>
    <%if errormsg<>"" then%>
    <tr> 
      <td colspan="2"><font color="#FF0000" size="2" face="Arial, Helvetica, sans-serif"><b>Error 
        : The user could not be saved - <%=errormsg%></b></font></td>
    </tr>
    <%end if%>
    <tr valign="top" align="left"> 
      <td width="28%" bgcolor="#CCCCCC"><b><font size="2" face="Arial, Helvetica, sans-serif">Name 
        :</font></b></td>
      <td width="72%" bgcolor="#F3F3F3"><b><font size="2" face="Arial, Helvetica, sans-serif"> 
        <input type="text" name="name" size="40" value="<%=name%>" maxlength="250">
        </font></b></td>
    </tr>
    <tr valign="top" align="left"> 
      <td width="28%" bgcolor="#CCCCCC"><b><font size="2" face="Arial, Helvetica, sans-serif">E-mail 
        :</font></b></td>
      <td width="72%" bgcolor="#F3F3F3"><b><font size="2" face="Arial, Helvetica, sans-serif"> 
        <input type="text" name="email" size="40" value="<%=email%>" maxlength="250">
        </font></b></td>
    </tr>
    <tr valign="top" align="left"> 
      <td width="28%" bgcolor="#CCCCCC"><b><font size="2" face="Arial, Helvetica, sans-serif">Username 
        :</font></b></td>
      <td width="72%" bgcolor="#F3F3F3"><b><font size="2" face="Arial, Helvetica, sans-serif"> 
        <input type="text" name="username" size="40" value="<%=username%>" maxlength="250">
        </font></b></td>
    </tr>
    <tr valign="top" align="left"> 
      <td width="28%" bgcolor="#CCCCCC"><b><font size="2" face="Arial, Helvetica, sans-serif">Password 
        :</font></b></td>
      <td width="72%" bgcolor="#F3F3F3"><b><font size="2" face="Arial, Helvetica, sans-serif"> 
        <input type="password" name="password" size="40" value="<%=password%>" maxlength="250">
        </font></b></td>
    </tr>
    <tr valign="top" align="left"> 
      <td width="28%" bgcolor="#CCCCCC"><b><font size="2" face="Arial, Helvetica, sans-serif">Level 
        :</font></b></td>
      <td width="72%" bgcolor="#F3F3F3"><font size="2" face="Arial, Helvetica, sans-serif"> 
        <select name="plevel">
          <%for x=0 to 2
			if x-plevel=0 then sel=" selected" else sel=""
			response.write "<option value="&x&sel&">"&whichlevel(x)&"</option>"
			next%>
        </select>
        </font></td>
    </tr>
    <tr valign="top" align="left"> 
      <td width="28%" bgcolor="#CCCCCC"><b><font size="2" face="Arial, Helvetica, sans-serif">Assigned 
        Zones :</font></b></td>
      <td width="72%" bgcolor="#F3F3F3"><b><font size="2" face="Arial, Helvetica, sans-serif"> 
        <select name="zones" size="4" multiple>
          <%
		psql="select * from zones order by zonename asc;"
		set rs=conn.execute(psql)
		do until rs.eof
			if instr(","&zones&",",","& rs("zoneid")&",")<>0 then sel=" selected" else sel=""
			response.write "<option value='"&rs("zoneid")&"'"&sel&">"&rs("zonename")&"</option>"
			rs.movenext
		loop
		rs.close
		set rs=nothing
		conn.close
		set conn=nothing
		%>
        </select>
        </font></b></td>
    </tr>
    <tr valign="top" align="left"> 
      <td width="28%" bgcolor="#CCCCCC"><b><font size="2" face="Arial, Helvetica, sans-serif">Additional 
        Info :</font></b></td>
      <td width="72%" bgcolor="#F3F3F3"><b><font size="2" face="Arial, Helvetica, sans-serif"> 
        <textarea name="additional" cols="40" rows="8"><%=additional%></textarea>
        </font></b></td>
    </tr>
    <tr> 
      <td width="28%">&nbsp; </td>
      <td width="72%"> 
        <input type="submit" name="button" value="Save User">
      </td>
    </tr>
  </table>
</form>
</body>
</html>
