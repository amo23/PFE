<!-- #include file="incSystem.asp" -->
<%
lvl=validate(1)
redim codeline(2)
codeline(0)="<script language=JavaScript src=" & chr(34) & applicationurl & "PPLNewsTicker.asp?z=[ZONEID]" & chr(34)&"></script>"
codeline(1)="<script language=JavaScript src=" & chr(34) & applicationurl & "PPLHistoryTicker.asp?z=[ZONEID]&h=[HEIGHT]" &chr(34) &"></script>"
codeline(2)="<script language=JavaScript src=" &chr(34) & applicationurl & "PPLHorizontalTicker.asp?z=[ZONEID]" & chr(34)&"></script>"
height=request("height")
tcode=request("tcode")
p=request("p")
zoneid=request("zoneid")
if tcode="" or not(isnumeric(tcode)) then tcode=0
if height="" or not(isnumeric(height)) then height=120


function ticker(which)
	select case which
		case 0
			ticker="News Ticker"
			
		case 1
			ticker="History Ticker"
			
		case 2
			ticker="Horizontal Ticker"
	end select
end function		


set conn=server.createobject("ADODB.Connection")
conn.open connection
%>
<html>
<head>
<title><%=title%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script language="JavaScript">
function displaycode(){
	thecode=form1.tcode.value;
	if (thecode=='1') {
		theheight=prompt('Ticker Height :','120');
		if (theheight!='' && theheight!=null){
			form1.height.value=theheight;
			form1.submit();
		}
	} else {
		form1.submit();
	}
}

function preview(zoneid,theheight){
	previewwind=window.open("PPLTickersVol1.asp?p=1&tcode=<%=tcode%>&height=" + theheight + "&zoneid=" + zoneid,"preview","toolbar=0,location=0,status=0,menubar=0,scrollbars=1,resizable=0,width=280,height=280");
	previewwind.focus();
}
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000">
<%if p<>"" then
   thecode=replace(codeline(tcode),"[ZONEID]",zoneid)
   thecode=replace(thecode,"[HEIGHT]",height)

%>
<base target=_blank>
<table width="100%" border="0" cellspacing="0" cellpadding="4" height="100%">
  <tr> 
    <td height="28" bgcolor="#003399" align="center"><font size="2"><font color="#FFFFFF" face="Arial, Helvetica, sans-serif"><b><%=ticker(tcode)%> 
      Preview<br>
      </b></font> <b><font size="1" face="Arial, Helvetica, sans-serif" color="#FFFFFF">The 
      News Tickers resize to the full width of the cell where the code is pasted 
      and their full articles are displayed on the same window</font></b></font></td>
  </tr>
  <tr> 
    <td valign="middle" bgcolor="#F2F2F2" width="100%"><%=thecode%></td>
  </tr>
  <tr>
    <td valign="middle" bgcolor="#F2F2F2" align="center"> 
      <input type="button" name="Button" value="Close" onclick="javascript:self.close();">
    </td>
  </tr>
</table>
<%response.end
end if
%>
<form name="form1" method="post" action="PPLTickersVol1.asp">
  <table width="90%" border="0" cellspacing="2" cellpadding="2" align="center">
  <tr valign="top"> 
      <td colspan="4" align="left"> <font face="Arial, Helvetica, sans-serif" size="2"><b>News 
        Tickers Vol. 1</b></font></td>
  </tr>
  <tr valign="top" bgcolor="#666666"> 
    <td colspan="4" align="left"></td>
  </tr>
  <tr valign="top" bgcolor="#F3F3F3"> 
      <td colspan="4" align="left"> <font face="Arial, Helvetica, sans-serif" size="2"><b> 
        News Ticker Type : 
        <select name="tcode" onchange="javascript:displaycode();">
          <%for x=0 to 2
	  if tcode-x=0 then sel=" selected" else sel=""
	  response.write "<option value="&x&sel&">"&ticker(x)&"</option>"
	  next%>
        </select>
        <input type="hidden" name="height" value="120">
        </b></font> </td>
  </tr>
  <tr valign="top" bgcolor="#666666"> 
    <td colspan="4" align="left"></td>
  </tr>
  <tr valign="top"> 
    <td width="5%" align="left" bgcolor="#003399"> 
      <div align="right"><b><font size="2" face="Arial, Helvetica, sans-serif" color="#FFFFFF">#</font></b></div>
    </td>
    <td width="35%" align="left" bgcolor="#003399" valign="middle"><b><font size="2" face="Arial, Helvetica, sans-serif" color="#FFFFFF">Zone 
      Name / Description </font></b></td>
    <td width="36%" align="left" bgcolor="#003399" valign="middle"> 
      <div align="center"><b><font size="2" face="Arial, Helvetica, sans-serif" color="#FFFFFF">News Ticker 
        Code</font></b></div>
    </td>
    <td align="center" bgcolor="#003399" valign="middle"> 
      <div align="center"><font face="Arial, Helvetica, sans-serif" size="2"><b></b></font><font size="2" face="Arial, Helvetica, sans-serif"><b><font color="#FFFFFF"></font></b></font></div>
      <b><font face="Arial, Helvetica, sans-serif" size="2" color="#FFFFFF">Preview</font></b></td>
  </tr>
  <%
	psql="select * from zones order by zonename asc;"
	set rs=conn.execute(psql)
	if not(rs.eof) then
   do until rs.eof
   cc=cc+1
   thecode=replace(codeline(tcode),"[ZONEID]",rs("zoneid"))
   thecode=replace(thecode,"[HEIGHT]",height)
%>
  <tr valign="top" bgcolor="#EAEAEA"> 
    <td width="5%" align="left"> 
      <div align="right"><b><font size="2" face="Arial, Helvetica, sans-serif"><%=cc%>.</font></b></div>
    </td>
      <td width="35%" align="left"><a href="javascript:preview(<%=rs("zoneid")%>,<%=height%>)"><font face="Arial, Helvetica, sans-serif"><b><font size="2"><%=rs("zonename")%></font></b></font></a><font face="Arial, Helvetica, sans-serif"><br>
        <font size="1"><%=replace(""&rs("description"),vbcrlf,"<br>")%></font></font></td>
    <td width="36%" valign="top" align="center"> 
      <textarea name="code" cols="40" readonly rows="4" style="font-family: Verdana; font-size: 8pt; border: 1 solid #000000"><%=thecode%></textarea>
      </td>
      <td align="center" valign="top"><a href="javascript:preview(<%=rs("zoneid")%>,<%=height%>)"><br>
      <img src="images/btnView.gif" width="27" height="27" alt="Edit Zone" border="0"></a> 
</td>
    <%rs.movenext
  loop%>
  <tr valign="top" bgcolor="#666666"> 
    <td colspan="4" align="left"></td>
  </tr>
  <% else%>
  <tr valign="top"> 
    <td colspan="4" align="left"> 
      <div align="center"> 
        <p>&nbsp;</p>
        <p><font size="2" color="#FF0000"><b><font face="Arial, Helvetica, sans-serif"><br>
          There are no defined zones<br>
            At least one zone must be defined To display News Tickers</font></b></font></p>
        <p><font size="2" color="#FF0000"><b><font face="Arial, Helvetica, sans-serif"><br>
          <%if lvl=1 then%>
          <a href="editzone.asp"><img src="images/btnZone2.gif" width="114" height="18" alt="Create a New Zone" border="0"></a> 
          <%end if%>
          </font></b></font></p>
        <p>&nbsp;</p>
      </div>
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

