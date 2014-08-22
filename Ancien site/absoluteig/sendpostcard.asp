<!--#include file="incSystem.asp" -->
<%
imageid=request("imageid")
if allowpostcards="" then response.redirect "gallery.asp"
dim ispc
ispc="1" 

'/// Retrieve Music Files for BGMusic
Set Fso = CreateObject("Scripting.FileSystemObject")
musicfolder=server.mappath("postcardmusic/")
musicfolderlen=len(musicfolder)
Set FolderInfo = Fso.GetFolder(musicfolder) 
Set FileList = FolderInfo.Files 
for each theme in FileList
	theme=mid(theme,musicfolderlen+2,len(theme))
	themename=left(theme,instrrev(theme,".")-1)
	musicthemes=musicthemes & "<option value='"&theme&"'>"&replace(themename&"","_"," ")&"</option>"
next
set FileList=nothing
set FolderInfo=nothing
set fso=nothing

'/// Get Image 
psql="select * from "&vxlaAIGimagesCategories&" where imageid="&imageid 
set conn=server.createobject("ADODB.Connection")
conn.open connection
set rs=conn.execute(psql)
if not(rs.eof) then theimage=getimage(imageid,rs("imagefile"),rs("imagepath"),rs("imagesize"))
rs.close
set rs=nothing
conn.close
set conn=nothing
if theimage="" then response.redirect "gallery.asp"

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title><%=gallerytitle%> : Send a Postcard</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="gallery.css" rel="stylesheet" type="text/css">
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" rightmargin=0 bottommargin=0>
<table width="100%" border="0" cellspacing="0" cellpadding="4">
  <tr class="Header"> 
    <td height="25"><span class="CurrentCategory">Send a PostCard</span></td>
  </tr>
</table>
 <form name="form1" method="post" action="viewpostcard.asp" style="margin:0">
  <table width="100%" border="0" cellspacing="2" cellpadding="2">
    <tr align="left" valign="top"> 
      <td width="50%" rowspan="12" align="center" valign="middle" class="NavigationBar"><%=theimage%></td>
      <td width="30%" class="NavigationBar"><b> Background color :</b></td>
      <td width="30%"> <select name="bgcolor" style="width:60%">
          <option style='background-color: FFD700' value='#FFD700'>Gold</option>
          <option style='background-color: FFFFFF' value='#FFFFFF' selected>White</option>
          <option style='background-color: 87CEEB' value='#87CEEB'>Sky Blue</option>
          <option style='background-color: 7FFFD4' value='#7FFFD4'>Aqua Marine</option>
          <option style='background-color: DDA0DD' value='#DDA0DD'>Plum</option>
          <option style='background-color: FFDAB9' value='#FFDAB9'>Peach Puff</option>
          <option style='background-color: 9ACD32' value='#9ACD32'>Yellow Green</option>
          <option style='background-color: DEB887' value='#DEB887'>Burlywood</option>
          <option style='background-color: FFF8DC' value='#FFF8DC'>Corn Silk</option>
          <option style='background-color: E6E6FA' value='#E6E6FA'>Lavender</option>
          <option style='background-color: 1E90FF' value='#1E90FF'>Dodger Blue</option>
        </select></td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="30%" class="NavigationBar"><b>Border Color :</b></td>
      <td width="30%"> <select name="bordercolor" style="width:60%">
          <option style='background-color: DAA520; color: FFFFFF' value='#DAA520'>Golden 
          Rod</option>
          <option style='background-color: 000000; color: FFFFFF' value='#000000' selected>Black</option>
          <option style='background-color: 6B8E23; color: FFFFFF' value='#6B8E23'>Olive 
          Drab</option>
          <option style='background-color: 8b008b; color: FFFFFF' value='#8b008b'>Dark 
          Magenta</option>
          <option style='background-color: 8B0000; color: FFFFFF' value='#8B0000'>Dark 
          Red</option>
          <option style='background-color: 008080; color: FFFFFF' value='#008080'>Teal</option>
          <option style='background-color: 708090; color: FFFFFF' value='#708090'>Slate 
          Grey</option>
          <option style='background-color: 4169E1; color: FFFFFF' value='#4169E1'>Royal 
          Blue</option>
          <option style='background-color: 800080; color: FFFFFF' value='#800080'>Purple</option>
          <option style='background-color: 32CD32; color: FFFFFF' value='#32CD32'>Lime 
          Green</option>
          <option style='background-color: FF8c00; color: FFFFFF' value='#FF8c00'>Dark 
          Orange</option>
        </select></td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="30%" class="NavigationBar"><b>Font Color :</b></td>
      <td width="30%"> <select name="fontcolor" style="width:60%">
          <option style='background-color: DAA520; color: FFFFFF' value='#DAA520'>Golden 
          Rod</option>
          <option style='background-color: 000000; color: FFFFFF' value='#000000' selected>Black</option>
          <option style='background-color: 6B8E23; color: FFFFFF' value='#6B8E23'>Olive 
          Drab</option>
          <option style='background-color: 8b008b; color: FFFFFF' value='#8b008b'>Dark 
          Magenta</option>
          <option style='background-color: 8B0000; color: FFFFFF' value='#8B0000'>Dark 
          Red</option>
          <option style='background-color: 008080; color: FFFFFF' value='#008080'>Teal</option>
          <option style='background-color: 708090; color: FFFFFF' value='#708090'>Slate 
          Grey</option>
          <option style='background-color: 4169E1; color: FFFFFF' value='#4169E1'>Royal 
          Blue</option>
          <option style='background-color: 800080; color: FFFFFF' value='#800080'>Purple</option>
          <option style='background-color: 32CD32; color: FFFFFF' value='#32CD32'>Lime 
          Green</option>
          <option style='background-color: FF8c00; color: FFFFFF' value='#FF8c00'>Dark 
          Orange</option>
        </select></td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="30%" class="NavigationBar"><b>Select a Font :</b></td>
      <td width="30%"><table width="100%" border="0" cellspacing="1" cellpadding="2">
          <tr> 
            <td><font size="2" face="Arial"> 
              <input name="fonttype" type="radio" value="arial" checked>
              Arial</font><font size="2"><br>
              </font></td>
            <td><font size="2" face="Times New Roman"> 
              <input type="radio" name="fonttype" value="times">
              Times </font></td>
          </tr>
          <tr> 
            <td><font size="2" face="Verdana"> 
              <input type="radio" name="fonttype" value="verdana">
              Verdana</font></td>
            <td><font size="2" face="Tahoma"> 
              <input type="radio" name="fonttype" value="tahoma">
              Tahoma</font></td>
          </tr>
          <tr> 
            <td><font size="2" face="Helvetica"> 
              <input type="radio" name="fonttype" value="helvetica">
              Helvetica</font></td>
            <td><font size="2" face="Geneva"> 
              <input type="radio" name="fonttype" value="geneva">
              Geneva</font></td>
          </tr>
        </table></td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="30%" class="NavigationBar"><b>Type a greeting:</b></td>
      <td width="30%"> <input name="customgreeting" type="text" id="customgreeting3"> 
      </td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="30%" class="NavigationBar"><b>Background Music :</b></td>
      <td width="30%"> <select name="bgsound">
          <option value="-">-- None --</option>
          <%=musicthemes%></select> </td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="30%" class="NavigationBar"><b>Recipient's Name :</b></td>
      <td width="30%"> <input name="recipientname" type="text" id="recipientname3"></td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="30%" class="NavigationBar"><b>Recipient's E-mail :</b></td>
      <td width="30%"> <input name="recipientemail" type="text" id="recipientemail4"></td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="30%" class="NavigationBar"><b>Your Name :</b></td>
      <td width="30%"> <input name="sendername" type="text" id="sendername5"></td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="30%" class="NavigationBar"><b>Your E-mail :</b></td>
      <td width="30%"> <input name="senderemail" type="text" id="senderemail4"></td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="30%" class="NavigationBar"><b>Your Message :</b></td>
      <td width="30%"> <textarea name="sendermsg" rows="3" id="textarea3"></textarea></td>
    </tr>
    <tr align="left" valign="top"> 
      <td colspan="2" align="center" class="NavigationBar"><input type="button" class="NavigationBar" value="Close Window" onclick="javascript:self.close();"> 
        <input name="reset" type="reset" class="NavigationBar" id="reset5" value="Start Again"> 
        <input name="submit" type="submit" class="NavigationBar" id="submit5" value="Send &amp; Preview &gt;&gt;"> 
        <input name="imageid" type="hidden" id="imageid5" value="<%=imageid%>"> 
      </td>
    </tr>
  </table>
</form>
</body>
</html>
