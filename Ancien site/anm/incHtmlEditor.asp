<STYLE TYPE="text/css">
TABLE#tblCoolbar 
	{ 
	background-color:threedface; padding:1px; color:menutext; 
	border-width:1px; border-style:solid; 
	border-color:threedhighlight threedshadow threedshadow threedhighlight;
	}
</STYLE><script LANGUAGE="JavaScript">
var isHTMLMode=false
function transferValue()
	{
	idContent.document.designMode="On"
	var theHTML = parent.main.document.all.article.value;
	idContent.document.open();
	idContent.document.write(theHTML)
	idContent.document.close();
	//var theHTML = document.all.article.value;
	//idContent.document.body.innerHTML=theHTML;
	}

function dopreview(){
     temp = idContent.document.body.innerHTML;
     preWindow= open('', 'previewWindow', 'left=150,top=150,width=400,height=440,status=yes,scrollbars=yes,resizable=yes,toolbar=no,menubar=yes');
     preWindow.document.open();
     preWindow.document.write(temp);
     preWindow.document.close();
}

/*
function document.onreadystatechange()
	{
	//This is not required
	transferValue();
	}
	*/
	
function cmdExec(cmd,opt) 
	{
  	if (isHTMLMode){alert("Please uncheck 'Edit HTML'");return;}
	idContent.focus();
  	idContent.document.execCommand(cmd,"",opt);
	}
	
function setMode(bMode)
	{
	var sTmp;
  	isHTMLMode = bMode;
  	if (isHTMLMode){sTmp=idContent.document.body.innerHTML;idContent.document.body.innerText=sTmp;} 
	else {sTmp=idContent.document.body.innerText;idContent.document.body.innerHTML=sTmp;}
  	idContent.focus();
	}
	
function createLink()
	{
	if (isHTMLMode){alert("Please uncheck 'Edit HTML'");return;}
	cmdExec("CreateLink");
	}
	
function articlelink(){
	what=prompt('Please enter the article ID Number','');
	if (what!=null && what!='') what='./articlefiles/r.asp?a=' + what;
	idContent.document.execCommand('createLink','',what);
}
function insertImage()
	{
	if (isHTMLMode){alert("Please uncheck 'Edit HTML'");return;}
	//var sImgSrc=prompt("Image File URL  : ", "http://");
	//if(sImgSrc!=null) cmdExec("InsertImage",sImgSrc);
	idContent.focus();
	var popleft=((document.body.clientWidth - 440) / 2)+window.screenLeft; 
	var poptop=(((document.body.clientHeight - 460) / 2))+window.screenTop-40;		
	window.open("selimage.asp?articleid=<%=articleid%>","InsertImage","scrollbars=NO,width=360,height=380,left="+popleft+",top="+poptop)
	//return true;
	}
	
function copyValue(){
	theHTML=idContent.document.body.innerHTML;
	document.all.article.value =theHTML;
}
	
function foreColor()
	{
	var arr = showModalDialog("selcolor.htm","","font-family:Verdana; font-size:12; dialogWidth:30em; dialogHeight:17em");
	//var arr = showModalDialog("selcolor.htm","","font-family:Verdana; font-size:12; dialogWidth:18em; dialogHeight:17.25em" );
	if (arr != null) cmdExec("ForeColor",arr);	
	}
	
function cleanhtml() {
	if (confirm('This action will clean the HTML code pasted from MS Word\nWould you like to proceed?')){
		temp = idContent.document.body.innerHTML;
		temp = temp.replace(/<p([^>])*>(&nbsp;)*\s*<\/p>/gi,"")
		temp = temp.replace(/<span([^>])*>(&nbsp;)*\s*<\/span>/gi,"")
		temp = temp.replace(/<([\w]+) class=([^ |>]*)([^>]*)/gi, "<$1$3")
		temp = temp.replace(/<([\w]+) style="([^"]*)"([^>]*)/gi, "<$1$3")
		temp = temp.replace(/<\\?\??xml[^>]>/gi, "")
		temp = temp.replace(/<\/?\w+:[^>]*>/gi, "")
  		idContent.document.body.innerHTML=temp;
		idContent.focus();
	}
}
</script>
<table border="0" id="tblCoolbar" cellpadding="0" cellspacing="0" width="100%">
  <tr> 
    <td colspan="4" background="editorimages/toolbar_hspacer.gif" height="4"></td>
  </tr>
  <tr> 
    <td width="0%"><img src="editorimages/toolbar_spacer.gif" width="5" height="20" align="absmiddle"> 
    </td>
    <td width="15%"> 
      <select onChange="cmdExec('fontname',this[this.selectedIndex].value);" name="select2" style="font-size:9">
        <option selected>Font</option>
        <option value="Arial">Arial</option>
        <option value="Arial Black">Arial Black</option>
        <option value="Arial Narrow">Arial Narrow</option>
        <option value="Comic Sans MS">Comic Sans MS</option>
        <option value="Courier New">Courier New</option>
        <option value="System">System</option>
        <option value="Tahoma">Tahoma</option>
        <option value="Times">Times New Roman</option>
        <option value="Verdana">Verdana</option>
        <option value="Wingdings">Wingdings</option>
      </select>
    </td>
    <td width="6%"> 
      <select onChange="cmdExec('fontsize',this[this.selectedIndex].value);" name="select" style="font-size:9">
        <option selected>Size</option>
        <option value="1">1</option>
        <option value="2">2</option>
        <option value="3">3</option>
        <option value="4">4</option>
        <option value="5">5</option>
        <option value="6">6</option>
        <option value="7">7</option>
      </select>
    </td>
    <td> <img src="editorimages/toolbar_spacer.gif" width="5" height="20" align="absmiddle"><a href="javascript:cmdExec('bold');"><img align=absmiddle src="editorimages/Bold.GIF" alt="Bold" border="0"></a><a href="javascript:cmdExec('italic');"><img align=absmiddle src="editorimages/Italic.GIF" alt="Italic" border="0"></a><a href="javascript:cmdExec('underline');"><img align=absmiddle src="editorimages/under.GIF" alt="Underline" border="0"></a><img src="editorimages/toolbar_spacer.gif" width="5" height="20" align="absmiddle"><a href="javascript:cmdExec('justifyleft');"><img align=absmiddle src="editorimages/left.GIF" alt="Justify Left" border="0"></a><a href="javascript:cmdExec('justifycenter');"><img align=absmiddle src="editorimages/Center.GIF" alt="Center" border="0"></a><a href="javascript:cmdExec('justifyright');"><img align=absmiddle src="editorimages/right.GIF" alt="Justify Right" border="0"></a><a href="javascript:cmdExec('justifyFull');"><img align=absmiddle src="editorimages/justify.gif" alt="Justify Full" border="0" hspace="1"></a><img src="editorimages/toolbar_spacer.gif" width="5" height="20" align="absmiddle"><a href="javascript:cmdExec('insertorderedlist');"><img align=absmiddle src="editorimages/numlist.GIF" alt="Ordered List" border="0"></a><a href="javascript:cmdExec('insertunorderedlist');"><img align=absmiddle src="editorimages/bullist.GIF" alt="Unordered List" border="0"></a><img src="editorimages/toolbar_spacer.gif" width="5" height="20" align="absmiddle"><a href="javascript:cmdExec('outdent');"><img align=absmiddle src="editorimages/DeIndent.GIF" alt="Decrease Indent" border="0"></a><a href="javascript:cmdExec('indent');"><img align=absmiddle src="editorimages/inindent.GIF" alt="Increase Indent" border="0"></a><img src="editorimages/toolbar_spacer.gif" width="5" height="20" align="absmiddle"><a href="javascript:foreColor();"><img align=absmiddle src="editorimages/fgcolor.GIF" alt="Foreground Color" border="0"></a><a href="javascript:cmdExec('InsertHorizontalRule');"><img vspace=1 align=absmiddle src="editorimages/hr.gif" alt="Insert Horizontal Line" border="0"></a></td>
  </tr>
  <tr> 
    <td width="0%"><img src="editorimages/toolbar_spacer.gif" width="5" height="20" align="absmiddle"></td>
    <td colspan="2"> 
      <input type="checkbox" onClick="setMode(this.checked)" name="checkbox">
      <font face="Tahoma, Arial, Verdana" size="2">View HTML Source</font></td>
    <td><img src="editorimages/toolbar_spacer.gif" width="5" height="20" align="absmiddle"><a href="javascript:cmdExec('cut')"><img align=absmiddle src="editorimages/Cut.GIF" alt="Cut" border="0"></a><a href="javascript:cmdExec('copy');"><img align=absmiddle src="editorimages/Copy.GIF" alt="Copy" border="0"></a><a href="javascript:cmdExec('paste');"><img align=absmiddle src="editorimages/Paste.GIF" alt="Paste" border="0"></a><img src="editorimages/toolbar_spacer.gif" width="5" height="20" align="absmiddle"><a href="javascript:cmdExec('Undo');"><img align=absmiddle src="editorimages/undo.gif" alt="Undo" border="0"></a><a href="javascript:cmdExec('Redo');"><img align=absmiddle src="editorimages/redo.gif" alt="Redo" border="0"></a><img src="editorimages/toolbar_spacer.gif" width="5" height="20" align="absmiddle"><a href="javascript:cmdExec('createLink');"><img align=absmiddle src="editorimages/Link.GIF" alt="Insert Web Link" border="0"></a><a href="javascript:insertImage();"><img align=absmiddle src="editorimages/image.GIF" alt="Insert Inline Image" border="0"></a><img src="editorimages/toolbar_spacer.gif" width="5" height="20" align="absmiddle"><a href="javascript:articlelink();"><img src="editorimages/LinkArticle.gif" align="absmiddle" alt="Link to Article" border="0"></a><a href="javascript:dopreview();"><img src="editorimages/preview.gif" width="22" height="22" align="absmiddle" border="0" alt="Preview"></a><a href="javascript:cleanhtml();"><img src="editorimages/word.gif" width="22" height="22" border="0" alt="Clean Word HTML" align="absmiddle"></a></td>
  </tr>
  <tr> 
    <td colspan="4"><iframe width="100%" id="idContent" height="280"></iframe></td>
  </tr>
</table>


