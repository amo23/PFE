<!--#include file="incGallery.asp" -->
<html>
<head>
<title><%=gallerytitle%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="gallery.css" type="text/css">
<script language="JavaScript" src="gallery.js"></script>
</head>

<body bgcolor="#FFFFFF" text="#000000" link="#C60000" vlink="#C60000" alink="#C60000">
<form name="form1" method="post" action="gallery1.asp?action=search" style="margin:0">

  <input type="hidden" name="box" value="<%=box%>"><input type="hidden" name="shownew" value="<%=shownew%>">
	<div align="center">

  <table width="780" border="1" cellspacing="0" cellpadding="0" bordercolorlight="#000000" bordercolordark="#000000" style="border-width:0; border-collapse:collapse" bordercolor="#111111">
    <tr>
      <td style="border-left-style: solid; border-left-width: 1px; border-top-style: solid; border-top-width: 1px; border-right-style:none; border-right-width:medium; border-bottom-style:none; border-bottom-width:medium" bgcolor="#C60000" width="580">
    <img border="0" src="../absolutenm/templates/images/liege.jpg" width="580" height="161"><table border="0" width="100%" id="table1" cellspacing="0" cellpadding="0">
		<tr>
			<td>
              <a href="../New_Folder/default.htm">
              <img border="0" src="../absolutenm/templates/images/accueil.gif" width="80" height="18"></a><img border="0" src="../scripto/images/intermediaire.gif" width="60" height="18"><a title="Ecriture, réécriture, relecture,..." href="../scripto/texto.htm"><img border="0" src="../absolutenm/templates/images/texto.gif" alt="Ecriture, réécriture, relecture,..." width="60" height="18"></a><a href="../scripto/photo.htm"><img border="0" src="../absolutenm/templates/images/photo.gif" width="60" height="18"></a><a href="../scripto/conseil.htm"><img border="0" src="../absolutenm/templates/images/conseil.gif" width="60" height="18"></a><img border="0" src="../scripto/images/intermediaire.gif" width="60" height="18"><img border="0" src="../absolutenm/templates/images/email.gif" width="60" height="18"><script language=JavaScript src="http://www.iccom.be/absolutels/als.asp"></script></td>
		</tr>
		</table>
		</td>
      <td align="right" style="border-right-style: solid; border-right-width: 1px; border-top-style: solid; border-top-width: 1px; border-left-style:none; border-left-width:medium; border-bottom-style:none; border-bottom-width:medium" bgcolor="#C60000" valign="top"> 
        <object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
  codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=5,0,42,0"
  id="logo" width="200" height="180">
  <param name="movie" value="../scripto/logo.swf">
  <param name="bgcolor" value="#ffffff">
          <embed name="logo" src="logo.swf"
     quality="high" bgcolor="#FFFFFF" swLiveConnect="true"
     width="200" height="180"
     type="application/x-shockwave-flash"
     pluginspage="http://www.macromedia.com/go/getflashplayer"></embed></object>
		</td>
    </tr>
    </table>

	</div>

<table width="780" border="0" cellpadding="0" align="center" class="MainTable" cellspacing="1" height="139">
  <tr>
      <td height="12" background="images/border.gif"></td>
  </tr>
  <tr>
    <td class="NavigationBar" height="27">
    <table width="778" border="0" cellspacing="2" cellpadding="2" class="NavigationBar">
        <tr>
            <td width="572">
            <a href="http://www.iccom.be/absoluteig/gallery.asp?categoryid=6" style="text-decoration: none">
            <font color="#C60000">Événements</font></a><font color="#C60000"> -
            </font>
            <a style="text-decoration: none" href="http://www.iccom.be/absoluteig/gallery.asp?categoryid=14">
            <font color="#C60000">Entreprises</font></a><font color="#C60000"> -
            </font>
            <a href="http://www.iccom.be/absoluteig/gallery.asp?categoryid=8" style="text-decoration: none">
            <font color="#C60000">Panoramiques</font></a><font color="#C60000"> -
            </font>
            <a href="http://www.iccom.be/absoluteig/gallery.asp?categoryid=9" style="text-decoration: none">
            <font color="#C60000">Visites virtuelles</font></a><font color="#C60000"> 
            (basse résolution) 
            - </font>
            <a href="http://www.iccom.be/absoluteig/gallery.asp?categoryid=10" style="text-decoration: none">
            <font color="#C60000">Portraits</font></a><font color="#C60000"> -
            </font>
            <a href="http://www.iccom.be/absoluteig/gallery.asp?categoryid=11" style="text-decoration: none">
            <font color="#C60000">Paysages</font></a><br>
            GALERIE EN CONSTRUCTION...</td>
            <td align="right" width="192"><%=buttons%></td>
        </tr>
      </table></td>
  </tr>

   <%if images<>"" then%>
  <tr> 
      <td class="NavigationBar" height="24"><%=images%></td>
  </tr>
  <%end if%>
  <%if pages<>"" then%>
  <tr>
      <td class="NavigationBar" align="center" height="24"><br>
        <%=pages%><br>
      </td>
  </tr>
  <%end if%>
</table>

</form>
<div align="center"></div>
</body>
</html>