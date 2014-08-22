<!--#include file="incSystem.asp" -->
<%
lvl=validate(0)
zoneid=request("zoneid")
zonename=request("zonename")
if not(isnumeric(zoneid)) then zoneid=0
date1=request("year1")&"/"&request("month1")&"/"&request("day1")
if not(isdate(date1)) then date1=todaydate
codeline="<script language=" & chr(34) & "JavaScript"& chr(34) & " src="& chr(34) & applicationurl & "xlaabsolutenm.asp?z=" & zoneid & "&target=_blank&fdate="&date1&chr(34) & "></script>"

%>
<html>
<head>
<title><%=zonename%></title>
<meta http-equiv="Content-Type" content="text/html; charset=<%=charset%>">
<style type="text/css">
<!--
.listbox {  font-family: Arial, Helvetica, sans-serif; font-size: 9px}
-->
</style>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" rightmargin="0" topmargin="0" bottommargin="0">
<form name="form1" method="post" action="" style="margin:0">
  <table width="100%" border="0" cellspacing="0" cellpadding="2" bgcolor="#000099">
    <tr> 
      <td align="left" valign="top" bgcolor="#CCCCCC"><font color="#FFFFFF"><b><font face="Arial, Helvetica, sans-serif" size="2"> 
        <font color="#666666">
        <select name="month1" class="listbox">
          <%
			  	for x=1 to 12
				if x=month(date1) then sel=" selected" else sel=""
					response.write "<option"&sel&">"& right("0" & x ,2) & "</option>"
				next
			  %>
        </select>
        / 
        <select name="day1" class="listbox">
          <%
			  	for x=1 to 31
				if x=day(date1) then sel=" selected" else sel=""
					response.write "<option"&sel&">"& right("0" & x ,2) & "</option>"
				next
			  %>
        </select>
        / 
        <select name="year1" class="listbox">
          <%
			  a=year(date1)
			  for x=a-20 to a+20
			  	if x=a then sel=" selected" else sel=""
			  	response.write "<option"&sel&">"& x&"</option>"	
			  next 
			  %>
        </select>
        <input type="submit" name="Submit" value="Preview" class="listbox">
        <input type="hidden" name="zoneid" value="<%=zoneid%>">
        </font></font><font face="Arial, Helvetica, sans-serif" size="2" color="#666666"> 
        <input type="hidden" name="zonename" value="<%=zonename%>">
        </font><font face="Arial, Helvetica, sans-serif" size="2"> </font></b></font></td>
    </tr>
    <tr>
      <td align="center" valign="top" bgcolor="#666666"></td>
    </tr>
  </table>
  <%=codeline%>
</form>
</body>
</html>
