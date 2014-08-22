<!--#include file="incSystem.asp"-->
<%
lvl=validate(1)
set conn=server.createobject("ADODB.Connection")
conn.open connection

categoryid=request("categoryid")
query=request("query")
imageid=request("imageid")
if not(isnumeric(imageid)) or imageid="" then 
	imageid=0
	if query<>"" then
		set rs=conn.execute(query)
		imageid=rs("imageid")
		rs.close
		set rs=nothing
		passimage="imageid="&imageid
	end if
else
	passimage="imageid="&imageid
end if

if categoryid="" or not(isnumeric(categoryid)) then categoryid=0 
firstcat=categoryid
viewfull=request("viewfull")

if query<>"" then msg="Browsing Search Results"

kill=request("kill")
if kill<>"" then
	call deletefile(kill)
	msg="The File Has Been Deleted"
end if

%>
<html>
<head>
<title><%=title%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script language="JavaScript">
function loadcategory(){
	newcat=form1.categoryid.value;
	//passedquery=form1.query.value;
	condit='';
	if (form1.viewfull.checked) condit='&viewfull=checked';
	//self.location.href='viewimages.asp?categoryid=' + newcat + '&query=' + passedquery + condit;
	self.location.href='viewimages.asp?categoryid=' + newcat + condit;
}

function deletefile(){
	newcat=form1.categoryid.value;
	passedquery=form1.query.value;
	imageid=form1.originalimageid.value;
	if (imageid!=''){
		if(confirm('Delete This Image?')) self.location.href='viewimages.asp?categoryid=' + newcat +'&kill=' + imageid + '&query=' + passedquery ;
	}
}

function selectpreview(){
	if (form1.viewfull.checked){
		form1.action='loadimage.asp?categoryid=<%=categoryid%>&viewfull=checked';
	} else {
		form1.action='loadimage.asp?categoryid=<%=categoryid%>';
	}
	form1.submit();
}

function updatestatus(what){
	form1.status.value=what;
	for (x=0;x<=2;x++){
		if (x==what) newcolor='#CCCCCC';
		else newcolor='#F3F3F3';
		thebg=eval("document.all.status" + x +".style.backgroundColor='" + newcolor +"';");
	}
}

function changecatid(){
	whichimageid=form1.imageid.value;
	loadimage.location.href='changecategory.asp?imageid=' + whichimageid;
}

function showpanel1(){
	document.all.panel1.style.display='';
	document.all.panel2.style.display='none';
	document.all.backpanel1.style.display='none';
	document.all.backpanel2.style.display='';
}

function showpanel2(){
	document.all.panel2.style.display='';
	document.all.panel1.style.display='none';
	document.all.backpanel1.style.display='';
	document.all.backpanel2.style.display='none';
}

</script>
</head>

<body bgcolor="#FFFFFF" text="#000000" topmargin="5">
<form name="form1" method="post" action="loadimage.asp?categoryid=<%=categoryid%>" target="loadimage" style="margin:0">
  <table width="96%" border="0" cellspacing="1" cellpadding="0" align="center">
    <tr align="left" valign="top">
      <td><b><font face="Arial, Helvetica, sans-serif" size="2"><img src="images/icView.gif" width="18" height="18"> 
        View Files :</font><font size="2" face="Arial, Helvetica, sans-serif"><b> 
        <%=msg%></b></font></b></td>
      <td align="right"><b><font face="Arial, Helvetica, sans-serif" size="2"><a href="uploadfiles.asp?categoryid=<%=categoryid%>"><img src="images/btnUploadFiles.gif" width="114" height="18" border="0" alt="Upload Files"></a> 
        <a href="buildindex.asp"><img src="images/btnRebuildIndex.gif" width="114" height="18" alt="Rebuild Gallery Index" border="0"></a></font></b></td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="260"><table width="100%" height="100%" border="0" cellpadding="2" cellspacing="1" bgcolor="#999999">
          <tr> 
            <td valign="top" bgcolor="#FFFFFF"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td colspan="2"><iframe src="loadimage.asp?categoryid=<%=categoryid%>&viewfull=<%=viewfull%>&<%=passimage%>" name="loadimage" height=220 width=260 frameborder="0"></iframe> 
                  </td>
                </tr>
                <tr> 
                  <td><font size="1" face="Arial, Helvetica, sans-serif"><a href="javascript:changecatid();">Change 
                    File Category</a></font></td>
                  <td align="right"><font face="Arial, Helvetica, sans-serif" size="1"> 
                    View full Images 
                    <input type="checkbox" name="viewfull" value="checked" <%=viewfull%> onClick="javascript:selectpreview();">
                    </font> </td>
                </tr>
              </table></td>
          </tr>
          <tr> 
            <td align="left" bgcolor="#CCCCCC"><font size="1" face="Verdana, Arial, Helvetica, sans-serif"><b>Category 
              :</b><br>
              <span id="catname">&nbsp;</span></font></td>
          </tr>
          <tr> 
            <td align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif"> 
              Size : <span id="imagesize">&nbsp;</span>Kb - Hits : <span id="hits">&nbsp;</span>&nbsp; 
              - Rating : <span id="rating">&nbsp;</span></font></td>
          </tr>
          <tr>
            <td align="center" bgcolor="#CCFF00" id="updating" style="display:none;"><b><font size="1" face="Verdana, Arial, Helvetica, sans-serif">Updating 
              Info, Please Wait...</font></b></td>
          </tr>
        </table></td>
      <td><table width="98%" border="0" align="right" cellpadding="2" cellspacing="2">
          <tr align="left" bgcolor="#003399"> 
            <td width="25%" colspan="2"><b><font size="2" face="Arial, Helvetica, sans-serif" color="#FFFFFF">Categories 
              : </font></b> </td>
            <td> <select name="categoryid" onchange="javascript:loadcategory();">
                <%
		psql="select * from xlaAIGcategories order by catpath asc;"
		set rs=conn.execute(psql)
		do until rs.eof
			if firstcat=0 then firstcat=rs("categoryid")
			if rs("categoryid")-categoryid=0 then sel=" selected" else sel=""
			response.write "<option value="&rs("categoryid")&sel&">"&ocurrences(rs("catpath"),rs("catname"))&"</option>"	
			rs.movenext
		loop
		rs.close
		set rs=nothing
		%>
              </select> <textarea name="query" cols="1" rows="1" style="display:none;"><%=server.urlencode(query)%></textarea> 
            </td>
          </tr>
          <tr valign="top" bgcolor="#003399"> 
            <td width="25%" colspan="2" align="left"><font color="#FFFFFF" size="2" face="Arial, Helvetica, sans-serif"><b>File 
              : </b><br>
              </font></td>
            <td align="left"> <select name="imageid" onChange="javascript:form1.submit();" style="width:100%;font-size:9px">
                <%psql=query
		if query="" then psql="select * from xlaAIGimages where categoryid="&firstcat&" order by imagename;"
		set rs=conn.execute(psql)
		do until rs.eof
			if rs("imageid")-imageid=0 then sel=" selected" else sel=""
			imagename=rs("imagefile")
			if rs("imagefile")<>rs("imagename") then imagename=rs("imagename")&" ("&rs("imagefile")&")"
			filesfound=true
			response.write "<option value="&rs("imageid")&sel&">"&imagename&"</option>"	
			rs.movenext
		loop
		rs.close
		set rs=nothing
		%>
              </select></td>
          </tr>
          <tr align="left" valign="top" bgcolor="#999999"> 
            <td colspan="3"> 
              <table width="100%" border="0" align="center" cellpadding="2" cellspacing="1" bgcolor="#FFFFFF" id="panel1" style="">
                <tr> 
                  <td width="25%" align="left" valign="top" bgcolor="#CCCCCC"><font size="2" face="Arial, Helvetica, sans-serif"><b>Name 
                    :</b></font></td>
                  <td align="left" valign="top" bgcolor="#F3F3F3"><font face="Arial, Helvetica, sans-serif" size="2"> 
                    <input type="text" name="imagename" value="" size="40">
                    </font> </td>
                </tr>
                <tr> 
                  <td width="25%" align="left" valign="top" bgcolor="#CCCCCC"><font size="2" face="Arial, Helvetica, sans-serif"><b>Date 
                    Created :</b></font></td>
                  <td align="left" valign="top" bgcolor="#F3F3F3"><font face="Arial, Helvetica, sans-serif" size="2"> 
                    <input name="datecreated" type="text" value="" size="40">
                    </font></td>
                </tr>
                <tr> 
                  <td width="25%" align="left" valign="top" bgcolor="#CCCCCC"><font face="Arial, Helvetica, sans-serif" size="2"><b>Description 
                    :</b> 
                    <input type="hidden" name="originalimageid" value="">
                    <br>
                    </font></td>
                  <td align="left" valign="top" bgcolor="#F3F3F3"><font face="Arial, Helvetica, sans-serif" size="2"> 
                    <textarea name="imagedesc" cols="30" rows="2" style="width:98%;"></textarea>
                    </font></td>
                </tr>
                <tr> 
                  <td width="25%" align="left" valign="top" bgcolor="#CCCCCC"><font face="Arial, Helvetica, sans-serif" size="2"><b>Keywords 
                    :</b><br>
                    </font></td>
                  <td align="left" valign="top" bgcolor="#F3F3F3"><font face="Arial, Helvetica, sans-serif" size="2"> 
                    <textarea name="keywords" cols="30" rows="2" style="width:98%;"></textarea>
                    </font></td>
                </tr>
                <tr> 
                  <td align="left" valign="top" bgcolor="#CCCCCC"><font size="2" face="Arial, Helvetica, sans-serif"><b>Copyright 
                    : </b></font></td>
                  <td align="left" valign="top" bgcolor="#F3F3F3"><font face="Arial, Helvetica, sans-serif" size="2"> 
                    <input name="copyright" type="text" value="" size="40">
                    </font></td>
                </tr>
                <tr> 
                  <td align="left" valign="top" bgcolor="#CCCCCC"><font face="Arial, Helvetica, sans-serif" size="2"><b>Credit 
                    : </b><br>
                    </font></td>
                  <td align="left" valign="top" bgcolor="#F3F3F3"><font face="Arial, Helvetica, sans-serif" size="2"> 
                    <input name="credit" type="text" value="" size="40">
                    </font></td>
                </tr>
                <tr> 
                  <td width="25%" align="left" valign="top" bgcolor="#CCCCCC"><font size="2" face="Arial, Helvetica, sans-serif"><b>Status 
                    : </b> 
                    <input name="status" type="hidden" value="">
                    </font></td>
                  <td align="left" valign="top" bgcolor="#F3F3F3"><table width="100%" border="1" cellspacing="0" cellpadding="0">
                      <tr align="center"> 
                        <td width="33%" id="status0" style=""><font size="1" face="Arial, Helvetica, sans-serif"><a href="javascript:updatestatus(0);"><img src="images/0.gif" width="27" height="27" border="0" align="middle"><%=whichstatus(0)%></a></font></td>
                        <td width="33%" id="status1" style=""><font size="1" face="Arial, Helvetica, sans-serif"><a href="javascript:updatestatus(1);"><img src="images/1.gif" width="27" height="27" border="0" align="middle"><%=whichstatus(1)%></a></font></td>
                        <td width="33%" id="status2" style=""><font size="1" face="Arial, Helvetica, sans-serif"><a href="javascript:updatestatus(2);"><img src="images/2.gif" width="27" height="27" border="0" align="middle"><%=whichstatus(2)%></a></font></td>
                      </tr>
                    </table></td>
                </tr>
              </table>
              <table width="100%" border="0" align="center" cellpadding="2" cellspacing="1" bgcolor="#FFFFFF" id="panel2" style="display:none;">
                <tr> 
                  <td align="left" valign="top" bgcolor="#CCCCCC"><font face="Arial, Helvetica, sans-serif" size="2"><b>Source 
                    : </b><br>
                    </font></td>
                  <td align="left" valign="top" bgcolor="#F3F3F3"><font face="Arial, Helvetica, sans-serif" size="2"> 
                    <input name="source" type="text"  value="" size="40">
                    </font></td>
                </tr>
                <tr> 
                  <td align="left" valign="top" bgcolor="#CCCCCC"><font size="2" face="Arial, Helvetica, sans-serif"><b>Uploaded 
                    by :</b></font> </td>
                  <td align="left" valign="top" bgcolor="#F3F3F3"><font face="Arial, Helvetica, sans-serif" size="2"> 
                    <input name="uploadedby" type="text" value="" size="40">
                    </font></td>
                </tr>
                <tr> 
                  <td width="25%" align="left" valign="top" bgcolor="#CCCCCC"><font face="Arial, Helvetica, sans-serif" size="2"><b>E-mail 
                    : </b><br>
                    </font></td>
                  <td align="left" valign="top" bgcolor="#F3F3F3"><font face="Arial, Helvetica, sans-serif" size="2"> 
                    <input name="email" type="text" value="" size="40">
                    </font></td>
                </tr>
                <tr> 
                  <td width="25%" align="left" valign="top" bgcolor="#CCCCCC"><font size="2" face="Arial, Helvetica, sans-serif"><b>URL 
                    : </b> </font></td>
                  <td align="left" valign="top" bgcolor="#F3F3F3"><font face="Arial, Helvetica, sans-serif" size="2"> 
                    <input name="infourl" type="text" value="" size="40">
                    </font></td>
                </tr>
                <tr> 
                  <td align="left" valign="top" bgcolor="#CCCCCC"><font face="Arial, Helvetica, sans-serif" size="2"><b>Embed 
                    HTML :</b> <br>
                    </font></td>
                  <td align="left" valign="top" bgcolor="#F3F3F3"><font face="Arial, Helvetica, sans-serif" size="2"> 
                    <textarea name="embedhtml" cols="30" rows="2" style="width:98%;"></textarea>
                    </font></td>
                </tr>
                <tr> 
                  <td align="left" valign="top" bgcolor="#CCCCCC"><font size="2" face="Arial, Helvetica, sans-serif"><b>Additional 
                    Info :</b></font></td>
                  <td align="left" valign="top" bgcolor="#F3F3F3"><font face="Arial, Helvetica, sans-serif" size="2"> 
                    <textarea name="additionalinfo" cols="30" rows="3" id="textarea5" style="width:98%;"></textarea>
                    </font> </td>
                </tr>
              </table>
              <table width="100%" border="0" align="center" cellpadding="2" cellspacing="2">
                <tr> 
                  <td width="101" align="left"><a href="javascript:showpanel1();"><img src="images/viewimgPrev.gif" name="backpanel1" width="101" height="22" border="0" style="display:none"></a></td>
                  <td align="center"> 
                    <%if filesfound then%>
<input type="button" name="Submit2" value="Delete File" onClick="javascript:deletefile();showpanel1();form1.imageid.focus();"> 
                    <input type="submit" name="Submit" value="Update Info" onclick="javascript:updating.style.display='';showpanel1();form1.imageid.focus();"><%end if%>
                  </td>
                  <td width="101" align="right"><a href="javascript:showpanel2();"><img src="images/viewimgNext.gif" name="backpanel2" width="101" height="22" border="0" style="display:"></a></td>
                </tr>
              </table>
            </td>
          </tr>
        </table></td>
    </tr>
  </table>
  </form>
</body>
</html>
<%conn.close
set conn=nothing%>

