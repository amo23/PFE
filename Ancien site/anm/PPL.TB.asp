<!-- #include file="incSystem.asp" -->
<%
lvl=validate(1)
if lvl<1 then 
	response.write "<scr" &"ipt language=""JavaScript"">alert('This option is only available to system administrators');history.back();</s" & "cript>"
	response.end
end if

action=request("action")
thefolder=server.mappath("PPL.TB") & "\"
isdone=false
if request("button")<>""  then
	'//// Generate tree ///
	if request("debug")="" then on error resume next
	Set Fs=createobject("scripting.filesystemobject")
		
	'/// generate database file
	content="<" & "%connection=" & chr(34) & connection & chr(34) & vbcrlf & "siteurl=" & chr(34) & siteurl & chr(34) &  "%" & ">"
	Set b=fs.createtextfile(thefolder & "_ppl.tb.config.asp",true)
	b.write content
	b.close
	set b=nothing
	Set Fs=nothing
	isdone=true
	if err.number<>0 then
		framecode="<scr" &"ipt language=""JavaScript"">alert('An error has ocurred\nMake sure that the PPL.TB folder has read and write permissions enabled');</s" & "cript>"
		framesrc=""
	else
		framecode="<scr" &"ipt language=""JavaScript"">alert('The pages have been successfully created and configured');</s" & "cript>"
		framesrc="PPL.TB/index.asp"
	end if
end if

%>
<html>
<head>
<title><%=title%></title>
<meta http-equiv="Content-Type" content="text/html;">
</head>

<body bgcolor="#FFFFFF" text="#000000">
<form name="form1" method="post" action="PPL.TB.asp">
        
  <p>&nbsp;</p>
  <p>&nbsp;</p>
  <table width="60%" border="0" align="center" cellpadding="6" cellspacing="1" bgcolor="#999999">
    <tr> 
            
      <td><font color="#FFFFFF" size="2" face="Arial, Helvetica, sans-serif"><b>TrafficBooster 
        Plugin</b></font></td>
          </tr>
          <tr> 
            <td bgcolor="#FFFFFF"><br>
              <table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                  <td><p><font size="2" face="Arial, Helvetica, sans-serif">This 
                plug-in will generates a complex tree of search-engine friendly 
                pages from your articles in order to make them easy for web spiders 
                like Google to crawl and index.</font></p>
                    
              <p><font size="2" face="Arial, Helvetica, sans-serif">Once these 
                pages are generated, it is advised to create a hidden link from 
                your home page to these pages well as to submit them to Google 
                as explained in the user manual.</font></p>
                    <p align="right"> 
                      
                <input name="button" type="submit" id="button" value="Generate Tree &gt;">
                    </p></td>
                </tr>
              </table>
              <br><iframe src="<%=framesrc%>" width="0" height="0" style="display:none"></iframe><%=framecode%>
            </td>
          </tr>
        </table>
        </form>
</body>
</html>


