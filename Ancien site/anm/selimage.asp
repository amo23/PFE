<!--#include file="incSystem.asp"-->
<%
lvl=validate(0)
articleid=request("articleid")
if articleid="" or not(isnumeric(articleid)) then articleid=0

%>
<html>
<head>
<title>Insert Inline Image</title>
<meta http-equiv="Content-Type" content="text/html; charset=<%=charset%>">
	<style>
	BODY
		{
		FONT-FAMILY: Verdana;FONT-SIZE: xx-small;
		}
	TABLE
		{
	    FONT-SIZE: xx-small;
	    FONT-FAMILY: Tahoma
		}
	INPUT
		{
		font:8pt verdana,arial,sans-serif;
		}
	select
		{
		height: 22px; 
		top:2;
		font:8pt verdana,arial,sans-serif
		}	
	.bar 
		{
		BORDER-TOP: #99ccff 1px solid; BACKGROUND: #336699; WIDTH: 100%; BORDER-BOTTOM: #000000 1px solid; HEIGHT: 20px
		}		
	</style>
<script language="JavaScript">
function selectImage(sURL)
	{
	inpImgURL.value = sURL;
	
	divImg.style.visibility = "hidden"
	divImg.innerHTML = "<img id='idImg' src='" + sURL + "'>";
	

	var width = idImg.width;
	var height = idImg.height ;
	
	var resizedWidth = 150;
	var resizedHeight = 170;

	var Ratio1 = resizedWidth/resizedHeight;
	var Ratio2 = width/height;

	if(Ratio2 > Ratio1)
		{
		if(width*1>resizedWidth*1)
			idImg.width=resizedWidth;
		else
			idImg.width=width;
		}
	else
		{
		if(height*1>resizedHeight*1)
			idImg.height=resizedHeight;
		else
			idImg.height=height;
		}
	
	divImg.style.visibility = "visible"
	}
	
	
function InsertImage()
{
//window.opener.document.execCommand("InsertImage",false,inpImgURL.value);
window.opener.idContent.document.execCommand("InsertImage",false,inpImgURL.value);
var oSel = window.opener.idContent.document.selection.createRange()
var sType = window.opener.idContent.document.selection.type	
if ((oSel.item) && (oSel.item(0).tagName=="IMG")) 
	{
	if(inpImgAlt.value!="")
		oSel.item(0).alt = inpImgAlt.value
	oSel.item(0).align = inpImgAlign.value
	oSel.item(0).border = inpImgBorder.value 
	if(inpImgWidth.value!="")
		oSel.item(0).width = inpImgWidth.value 
	if(inpImgHeight.value!="")
		oSel.item(0).height = inpImgHeight.value 
	if(inpHSpace.value!="")
		oSel.item(0).hspace = inpHSpace.value
	if(inpVSpace.value!="")
		oSel.item(0).vspace = inpVSpace.value
	}
}
function window.onload(){
	self.focus();
}
</script>
</head>

<body bgcolor="#CCCCCC" text="#000000" leftmargin="0" topmargin="0" ritghtmargin="0">
<table width="340" border="0" cellspacing="2" cellpadding="2" align="center">
  <tr> 
    <td width="50%"> 
      <table width="160" border="0" cellspacing="1" cellpadding="0" align="center" bgcolor="#006699" height="170">
        <tr> 
          <td bgcolor="#FFFFFF" height="100%" align="center" valign="middle"> 
            <div id="divImg" style="overflow:auto;width:150;height:170"></div>
          </td>
        </tr>
        <tr> 
          <td align="center" height="15"><b><font color="#FFFFFF">Preview</font></b></td>
        </tr>
      </table>
    </td>
    <td width="50%">
      <table width="160" border="0" cellspacing="1" cellpadding="0" align="center" height="170" bgcolor="#006699">
        <tr> 
          <td bgcolor="#FFFFFF" height="100%" align="center" valign="middle"> 
            <iframe id="getfiles" src="selimage2.asp?articleid=<%=articleid%>" width=170 height=168 border=0></iframe> 
          </td>
        </tr>
        <tr> 
          <td align="center" height="15"><b><font color="#FFFFFF">Inline Files 
            Available </font></b></td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td colspan="2">
      <table border=0 width=340 cellpadding=0 cellspacing=1>
        <tr> 
          <td>Image source : </td>
          <td colspan=3> 
            <input type="text" id="inpImgURL" name=inpImgURL size=39>
            
          </td>
        </tr>
        <tr> 
          <td>Alternate text : </td>
          <td colspan=3> 
            <input type="text" id="inpImgAlt" name=inpImgAlt size=39>
          </td>
        </tr>
        <tr> 
          <td>Alignment : </td>
          <td> 
            <select id="inpImgAlign" name="inpImgAlign">
              <option value="" selected>&lt;Not Set&gt;</option>
              <option value="absBottom">absBottom</option>
              <option value="absMiddle">absMiddle</option>
              <option value="baseline">baseline</option>
              <option value="bottom">bottom</option>
              <option value="left">left</option>
              <option value="middle">middle</option>
              <option value="right">right</option>
              <option value="textTop">textTop</option>
              <option value="top">top</option>
            </select>
          </td>
          <td>Image border :</td>
          <td> 
            <select id=inpImgBorder name=inpImgBorder>
              <option value=0>0</option>
              <option value=1>1</option>
              <option value=2>2</option>
              <option value=3>3</option>
              <option value=4>4</option>
              <option value=5>5</option>
            </select>
          </td>
        </tr>
        <tr> 
          <td>Width :</td>
          <td> 
            <input type="text" id="inpImgWidth" name="inpImgWidth" size=2>
          </td>
          <td>Horizontal Spacing :</td>
          <td> 
            <input type="text" id="inpHSpace" name="inpHSpace" size=2>
          </td>
        </tr>
        <tr> 
          <td>Height :</td>
          <td> 
            <input type="text" id="inpImgHeight" name="inpImgHeight" size=2>
          </td>
          <td>Vertical Spacing :</td>
          <td> 
            <input type="text" id="inpVSpace" name="inpVSpace" size=2>
          </td>
        </tr>
      </table>
    </td>
  </tr>
  <tr align="center"> 
    <td colspan="2"> 
      <input type="button" value="Cancel" onClick="self.close();" style="height: 22px;font:8pt verdana,arial,sans-serif" id="Button1" name="Button1">
      <input type="button" value="Insert" onClick="InsertImage();self.close();" style="height: 22px;font:8pt verdana,arial,sans-serif" id="Button2" name="Button2">
    </td>
  </tr>
</table>
</body>
</html>
