<%
' The Following Include Must Be Added to all of your ASP Templates
' In order to load the article's content into variables
%>
<!--#include file="../incASPTemplates.asp" -->
<html>
<head>
<title>Absolute News Manager - Template Sample</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0">
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
  <tr> 
    <td bgcolor="#003399" height="70"><img src="../template-files/logo.gif" width="234" height="41" vspace="3" hspace="15"></td>
  </tr>
  <tr> 
    <td height="100%" align="left" valign="top">
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        <tr> 
          <td width="20%" bgcolor="#999999" align="left" valign="top"> 
            <table width="90%" border="0" cellspacing="2" cellpadding="2" align="center">
              <tr> 
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td bgcolor="#F7F7F7" align="left" valign="top"> 
                  <p><font face="Tahoma, Verdana, Arial" size="1"><b><font color="#FF0000">About 
                    This Template :<br>
                    </font></b></font><font face="Tahoma, Verdana, Arial" size="1">Absolute 
                    News Manager Supports an Unlimited number of templates so 
                    that you can give your articles and content any look and style 
                    that you want!</font></p>
                  <p><font face="Tahoma, Verdana, Arial" size="1">This is the 
                    default ASP template (template.asp file) provided with Absolute 
                    News Manager and it's intended to show you how you can design 
                    and create your own ASP based templates with the same look 
                    and feel of your site.</font></p>
                  <p><font face="Arial, Helvetica, sans-serif" size="1">Note that 
                    insted of using tags enclosed in $$ Symbols, you should use 
                    variables enclosed between &lt;%%&gt;</font></p>
                  </td>
              </tr>
            </table>
          </td>
          <td width="80%" align="left" valign="top">
            <table width="98%" border="0" cellspacing="4" cellpadding="4" align="center">
              <tr> 
                <td width="73%" bgcolor="#FFCC00">
                  <div align="center"><font face="Arial, Helvetica, sans-serif" size="2"><b>Absolute 
                    News Manager supports ASP Templates too.<br>
                    Use ASP Templates to add dynamic content and includes to your 
                    templates</b></font> </div>
                </td>
                <td width="27%">&nbsp;</td>
              </tr>
              <tr> 
                <td width="73%"><font face="Arial, Helvetica, sans-serif" size="2"><b><font size="4"><%=headline%></font></b></font><br>
                  <font face="Verdana, Arial, Helvetica, sans-serif" size="1"><%=headlinedate%> 
                  - <%=source%></font></td>
                <td width="27%">&nbsp; </td>
              </tr>
              <tr> 
                <td width="73%" bgcolor="#666666" height=3></td>
                <td width="27%" height=3></td>
              </tr>
              <tr align="left" valign="top"> 
                <td width="73%"> 
                  <table border="0" cellspacing="2" cellpadding="2" align="left" width="10%">
                    <tr> 
                      <td class="images"><%=images%></td>
                    </tr>
                    <tr> 
                      <td class="text"><%=videos%></td>
                    </tr>
                    <tr> 
                      <td class="text"><%=audios%></td>
                    </tr>
                    <tr> 
                      <td class="text"><%=links%></td>
                    </tr>
                    <tr> 
                      <td class="text"><%=files%></td>
                    </tr>
                  </table>
                  <font face="Arial, Helvetica, sans-serif" size="2"><%=article%></font> 
                </td>
                <td rowspan="6"> 
                  <table width="100%" border="0" cellspacing="1" cellpadding="1" bgcolor="#003399">
                    <tr> 
                      <td> 
                        <div align="center"><font size="2" face="Arial, Helvetica, sans-serif"><b><font color="#FFFFFF">Latest 
                          News<br>
                          (This is a Zone)</font></b></font></div>
                      </td>
                    </tr>
                    <tr> 
                      <td bgcolor="#FFFFFF"> 
                        <script language="JavaScript" src="../xlaabsolutenm.asp?z=<%=zoneid%>">
</script>
                      </td>
                    </tr>
                  </table>
                  <div align="center"> 
                    <p>&nbsp;</p>
                  </div>
                </td>
              </tr>
              <tr align="left" valign="top">
                <td width="73%" bgcolor="#666666"></td>
              </tr>
              <tr align="left" valign="top">
                <td width="73%"><font face="Arial, Helvetica, sans-serif" size="2"><b>Related 
                  Articles :</b></font><br>
                  <font face="Arial, Helvetica, sans-serif" size="2"><%=related%></font></td>
              </tr>
              <tr> 
                <td width="73%" height="3" bgcolor="#666666"></td>
              </tr>
              <tr> 
                <td width="73%"> 
                  <div align="center"><a href="javascript:openppl('ppl.sendarticle.asp?a=<%=articleid%>',0,0,360,240)"><font face="Arial, Helvetica, sans-serif" size="2">Email 
                    This Article To A Friend</font></a> - <a href="../anmviewer.asp?a=<%=articleid%>&print=yes"><font face="Arial, Helvetica, sans-serif" size="2">Print 
                    This Article</font></a><br>
                    <font face="Arial, Helvetica, sans-serif" size="1">Articles 
                    can be E-mailed to a friend and you can get a printable version 
                    of the article.<br>
                    Use your own buttons and links!</font></div>
                </td>
              </tr>
              <tr> 
                <td width="73%" bgcolor="#EEEEEE"> 
                  <form name="form1" method="post" action="../../PPL.search.asp">
                    <div align="center"><font face="Arial, Helvetica, sans-serif" size="2" color="#FF0000"><b><font size="3" color="#003399">Search 
                      Articles :</font><font size="3" color="#0033CC"> </font></b></font> 
                      <input type="text" name="search" size="10">
                      <input type="submit" name="Submit" value="&gt;&gt;">
                      <br>
                      <font face="Arial, Helvetica, sans-serif" size="1">By Creating 
                      a simple form like this on anywhere on your site,<br>
                      you'll get a full search engine for your articles</font></div>
                  </form>
                  <div align="center"></div>
                </td>
              </tr>
              <tr> 
                <td width="73%">&nbsp;</td>
                <td width="27%">&nbsp;</td>
              </tr>
              <tr> 
                <td width="73%">&nbsp;</td>
                <td width="27%">&nbsp;</td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
</html>
