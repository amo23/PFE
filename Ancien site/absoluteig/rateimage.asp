<!--#include file="incSystem.asp"-->
<%
imageid=request("imageid")
button=request("button")
set conn=server.createobject("ADODB.Connection")
conn.open connection
if button<>"" then
	imagename=request("imagename")
	rating=request("rating")
	if isnumeric(rating) and rating<>"" then
		psql="update xlaAIGimages set totalreviews=totalreviews+1, totalrating=totalrating+"&rating&" where imageid="&imageid
		conn.execute(psql)
	end if
	rated="yes"
else
	psql="select * from xlaAIGimages where imageid="&imageid
	set rs=conn.execute(psql)
	imagename=rs("imagename")
	rating=getrating(rs("totalrating"),rs("totalreviews"))
	if isnumeric(rating) then
		message="File Rated : <b>"&rating&"</b><br> By <b>"&rs("totalreviews")&"</b> Users"
	else
		message="This file has not been rated."
	end if
	rs.close
	set rs=nothing
end if
conn.close
set conn=nothing
%>
<html>
<head>
<title><%=imagename%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="gallery.css" type="text/css">
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" rightmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" border="0" cellspacing="0" cellpadding="4">
  <tr> 
    <td class="Header" align="center"><span class="CurrentCategory"><%=imagename%></span></td>
  </tr>
  <%if rated="" then%>
  <tr> 
    <td class="FilesCellColor" align="center"> 
      <p>&nbsp;</p>
      <p><%=message%></p><form name="form1" method="post" action="">
        <p>Select Your Rating :<br>
          <input type="hidden" name="imagename" value="<%=imagename%>">
          <input type="hidden" name="imageid" value="<%=imageid%>">
          <select name="rating" class="NavigationBar">
            <option selected>10</option>
            <option>9</option>
            <option>8</option>
            <option>7</option>
            <option>6</option>
            <option>5</option>
            <option>4</option>
            <option>3</option>
            <option>2</option>
            <option>1</option>
          </select>
          <input type="submit" name="button" value="Rate!" class="NavigationBar">
        </p>
        </form>
      <p>&nbsp; </p>
    </td>
  </tr>
  <%else%>
  <tr>
    <td class="FilesCellColor" align="center">
      <p>&nbsp;</p>
      <p>You Rated This File<br>
        <b><font size="4"><%=rating%></font></b></p>
    </td>
  </tr>
  <%end if%>
</table>
<div align="center">
  <hr width="80%">
  <br>
  <input type="button" name="Button" value="Close Window" onClick="javascript:self.close();" class="NavigationBar">
</div>
</body>
</html>
