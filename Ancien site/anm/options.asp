<%@ LANGUAGE = VBScript.Encode %>
<!-- #include file="incCache.asp" -->
<!-- #include file="incEmail.asp" -->
<!-- #include file="incUpload.asp" -->
<!-- #include file="incSystem.asp" -->
<%#@~^eBQAAA==@#@&WU,+MDWMPMn/!:nP	+aO@#@&V7s'7lVb[CY`y#@#@&rW,+hlbsmK:2G	+xOxrJ~Y4n	PnslbVmK:aGxxO'rjU[0k	nNr@#@&snd/mo'.+5;/O`rh+k/CLJ#@#@&b0~D5!+dD`r4EDYKU/m\nJ*@!@*ErPY4nx@#@&d1x^tM`2cb@#@&7mw2Vb^lDkGU!DVx.;;+kOvJCaw^kmmYbGx!Ds r#@#@&iVk1nxk+'Mn5E/D`EVr^xd+yE#@#@&7dbY+;.^'.+$;/OvJkkYEMs r#@#@&i6sC|WD9nDbN'Mn5E/D`E6sC|W.N.k9 Eb@#@&dnhmks/!8N+^D'M+;!+kO`r+hlbVd;(L+1O r#@#@&7n:mk^/roUCDE.+{.+aVC^`Y.rs`.+$;/OvJ:lbVkro	lOEM++E*#~1Sm,[Pr'~m4Dv&*#~'rP'P1b@#@&d.nmN:G.'.+$;/OvJM+l9:K.+yJb@#@&dUGM+VmO+9'D5;+kYvJUW.n^lO+9+J*@#@&7M+VCONdEshmDz{D;E/DcJM+slD+[d!::m.XyJ#@#@&7N0mEsYnhmks'Mn;!+dOvJNnWmEsYhmksyJ*@#@&i/sOwk+.\Dx.;EdYvJ/sO2/D7+. Eb@#@&7xKU+S/hnk/lLn{Dn;!nkYcrxKx+S/sn/klL+yJb@#@&dW	sXmN:bUd'M+$En/OcrWUVHCNskUdyJ#@#@&iW2+	nXYnMxmV'M+$;+kYcJKwnU6Y.xmV rb@#@&iyKxnw.GD+^YbGx{Dn5!+/OcryGx2MWOmDkW	J*@#@&i/2+1kCs!DVkxD;EdO`r/a+^kCs!Ds/yE#@#@&72(Vl^^/d'Mn$EnkYvJw(Vm^m/d r#@#@&iw4^;/D/{.n;!+kYcJ28^Ed+Md r#@#@&iWwnU6ks+kUhxM+$E+kYvEWa+U0bVnd	+hyE#@#@&da8syKx/xDn5!+dYvEw(V"G	+/+E*@#@&dm.1tr7+xl(V['M+5E/OcrlD14k7++	C8VNyJb@#@&7mD^tb-+9lzd{D+5;/O`rCMm4b\NlH/yE#@#@&7lMm4r7+l1^+k/'Mn5E/D`El.^4k-+m^m/d+r#@#@&7	WOk6zNrDWM'D;!n/D`ExKYrWH+NbOWM J*@#@&d	WDkWXC[skU'Mn;!+dOvJxGOb0zl9hbx+r#@#@&d	WDr0H/;4N+^O{D+$;+kY`rUGYb0H/;4%n1Y+J*@#@&iyGUml^4'.+$;/OvJ.Wxmm^t E#@#@&7CMYk1s+1lm4nxD;!+dYcEmDOk1s+1l^4 Jb@#@&d^l14Yrs+{D+$EdYvJ^l1tnOb:+yE#@#@&dmrLEMV{Dn;;nkYcJmro!Ds+r#@#@&71tCDknD'.;!+/D`r^tmDd+D Eb@#@&dMnVmY+94nl9VbxnNCO'.+$;+kYcEM+VCON4+m[^kUNmY+yJ*@#@&i@#@&db0~CawVb^lDkW	;.V@!@*rJ~lU[,VrmU/@!@*ErPlU[,/rY;MV@!@*JrPPDtU@#@&@#@&dikW~Mko4O`mww^r^lDkKx;DsS8#@!@*r&J,Y4n	Pl22^k^lDrKx;MV{lwaVb^lDkGx!Ds~LJzr@#@&idk6~.kTtD`dkOn!Ds~8b@!@*J&E,YtnU,/rY;MVxkkD+EMV,'JJJ@#@&idd2mkmsEMV/{.nw^l1+c/2n1kCV!.Vk~-81DVWSriE#@#@&idr6P1lm4+Dr:'EJ,W.~	WYvr/	E:.rmvmmm4+Ors+b#,Otx~^mmtnOb:n'y@#@&d7b0,lD1tb-+9lz/{JE~KDP	GYvk/	;h+Mk1`CD^4b\nNmz/*#~O4+x~CMm4k7n9lzk'Z@#@&idbWP1tCDk+OxrJPD4+	Pm4C./Y{Jr/GRR%X, qJ@#@&77b0PCrTE.V@!@*rJ~Dtx@#@&di7k6P.kTtOcmko!.VBF#@!@*EzrPDtnx~Cbo;D^xlbo;.^P[E&r@#@&din	N~b0@#@&di@#@&7d6ks+D+aO{J@!r~[,J]r~'P741Ds0~',JCwask1lOrKxE.s{J'P1~LPCaw^kmmYbGx!DsPLP^~LP\(^D^0@#@&770bVYn6Ox6ks+Dn6DP'~rVk^n	/n'r',m~LP^kmxknPLP^PLP-81DV6@#@&id0bsnY6D'WksnD+aY,'Pr6sC|WD[nMk['r',m~LPXVl|WM[+Mk[PLP^~LP\(^D^0@#@&770bVYn6Ox6ks+Dn6DP'~,J/rOE.V{ELP^,[,/kD+!.V,[~m,[~-(mD^W@#@&dd6rs+D+XYx0rsYn6D~[,PE^4lDdnD'E[,^,[~1tmD/Y,'P1P'P74^.^0@#@&7d6kVOn6D'6ks+OnXY~[,~JKxszmN:rUk'E[,^,[~Kx^Xl9:bU/,[~m,[~-(mD^W@#@&dd6rs+D+XYx0rsYn6D~[,PE2(Vl^^/d'r',m~LPa4Vmm1n/kP'P1P'~74mMs0@#@&diWrVY6O'Wr^+O+XOPLP~Ea4V"G	+d'r',m~LPa4V.W	n/,[~m,[~-(mD^W@#@&dd6rs+D+XYx0rsYn6D~[,PE2(VEdnM/xJL~1P',w(VEk+MdPLP^PLP-81DV6@#@&id0bsnY6D'WksnD+aY,'P,JG2x0rs/U+Sxr[~1PLPWa+	Wk^+dxh~',mPL~\(mD^W@#@&id6ks+OnXYx0bs+D+aO,[PEnslrVk;(Ln1Y{JPLP1~[,+hlbVd;(L+1OPLPm,'~\(mMVW@#@&7i0rVO+XYxWbV+OnXY~[,E	W.VmY+9'r~[,m~[,xG.VlDnN,[P1~'P741Ds0@#@&idWk^nY6Ox6kVnO6OPL~rDn^lD+NkEshlMXxJ,[~^,[PMnVmY+9d;:slMX~[~^,[~\(^D^0@#@&id0rsYn6Dx6ksY6Y,[,EDl[:KDnxrP[,^PLPDC[:KDP'P^~LP-41.V6@#@&7i0ksnD+aY{WbVnD+XYPLP,EyKxnmmm4n{J[,^PLPyKUnmmm4+~[~^,[~\(^D^0@#@&id0rsYn6Dx6ksY6Y,[,~JmDOk1Vn^mmtxJLPm,'~lMYbms+^C1tnPL~m,[~-(mDsW@#@&7d6r^+O6D'0bVO+XY~[,JG2x+XO+Mxl^xEPLP1P'PG2xn6DnD	ls~LPm~',\8mMs6@#@&id6kVYaY{0rVYnaDP[,EN0l!sO+slbVxJ~',m~[,[+6l;sD+:Cr^P'P1~LP-(mMV0@#@&i70bVnY6Ox6kVO+XYPL~E/sYa/nD-nM'EPL~m,[~dsYwdnM\nD,',m~LP74mMV6@#@&idWk^+OnXY'6rVY+XO~[,J.WU+2.KYnmDrW	'E',mP'~.WU+a.KYn1YbWx,[,^PLP-41DsW@#@&diWk^+YaO'6k^+O+aO,[~Jk2+1kCs!DVdxrP'P1~LPda+1kl^EMs/,[~m,[-81DV6@#@&id0bsnY6D'WksnD+aY,'PrxGOb0Xn[bYGD{E,[~1PLPxKYbWXNrYKD~',mPL-41DV6@#@&di0bVnYnaD'Wk^nY6O~LPJUGDkWXm[skU{J,[P1PL~xKYr0Hl[hbxPL~m,[\(^.V6@#@&d70rsYn6Dx0bVnO6Y~',J^l14Yrs+{JPLP1Cm4+Oks+~'74mMs0@#@&diWrVY6O'Wr^+O+XOPLPECboE.s{J~[,^,[~mkTED^PL~m,[~\(m.s6@#@&i70bV+DnaY{0bVnYnaDP'PrCD1tr-+xC8^+['r~LP^,[,lD1tb-+xC4^+[~LPm,'\(mD^W@#@&id6ks+OnXYx0bs+D+aO,[PE.VCY[4+C9Vbx+9lDn'rP'P1P'~M+VmO+9t+m[sk	+9lO+~',m~[78mMVW@#@&ddWr^+O+XO{0r^+D+6DPL~JmD^tb\n[mX/{EPLPlM^4k7+9lz/~'74^D^W@#@&d7WbV+OnXYx0bsYnXY,[PrlM^tb\nl1mndk'J,'P1P[,C.m4k7+Cm^nk/~[,^PLP-81DVW@#@&d70bsYnXY{0k^+Dn6DP'PrxGOb0Xk;4N+mDxEPLP1P'PUGDkWXk;4N+^O,[P^~L\8mMs6@#@&id6kVYaY{0rVYnaDP[,E+slk^dro	lDE.+xE,[~m,'PM+2smm+cErP'PhmkskkTxlDEMn~74^D^0S~1P[,E[,\41.s0,[rP'P^b,[~J,EPLP^~L\4^.^0@#@&i76ksY6Y{0bs+D+aY,[~E	WxA/s+/kCL+{J,[~m~',xGxA/s+ddmo+~',m~[,-(m.^0,[Pr]r~[,J@*J@#@&77@#@&dij+DPskx^DlD+G4%n1YcJk^DbwOr	oRWr^+dXkO:G(LmYr#@#@&di?nY,4xWkRmMnlD+YaO0bV`d+.-D :m2wmY4crmWUWbo[lDCcldaJ*~YMEb@#@&d74ch.rD+P6rVY+XO@#@&idk+OP8x	WOtbUo@#@&77@#@&d7dY~4{WkR^M+mY+D+XO0bVn`1l^40W^[+M[J'"GxyctO:ESDD;+*@#@&iddnDP4xWkR^DCD+O6D0k^+v^l1tn0KV[nM[J'CDDkm^n"R4YsJSY.;#@#@&i7/Y~8{xWO4bxL@#@&7i@#@&idb0P.W	nmmm4+{JE~,YtU@#@&ddiWdR9+^+O+Wr^+cmm^t0Gs9+D'E'yGxMceE*@#@&ddx9~k6@#@&di@#@&7ik0,CDDkm^n^l1t'EJ~O4+U@#@&7di0d 9+VnO0rVc1l^4+6WV9+M'J'l.YbmsnCRerb@#@&ddU[Pb0@#@&7ddnDPW/{UWDtrUT@#@&77b0~2M.c1;s4D@!@*!,Otx@#@&id7nMDWMh/T'J8E@#@&idVd+@#@&id7:d/monxrKtn~g+APUnDYr	okPtm\~4+UPkl-n9J@#@&7diD+k2Gxk+cDnNr.mOPrGwDkGUkRld2Q:n/kCT+xr[k+D7+M EMVnx1W[nv:+kdlT+#@#@&7dx9Pr0@#@&i+s/@#@&idhnk/lLn{JPt~	+A,/YYbxTdP1W;V9PUGDP4~/m\+9~lPkWs+~0rn^NdPm.+,:rdkkxLE@#@&7+	[,kW@#@&xN,k6@#@&kwnmbls;MV/{.+aVl1nc/a+1kCV;.^/'JrSJpJS-(mDsW*@#@&@#@&sl8GAA==^#~@%>
<html>
<head>
<title><%=#@~^BgAAAA==ObYO^+lgIAAA==^#~@%></title>
<meta http-equiv="Content-Type" content="text/html; charset=<%=#@~^BwAAAA==^4l.k+D6gIAAA==^#~@%>">
</head>
<script language="JavaScript">
function verify(){
	var thisform=document.form1;
	if (thisform.applicationurl2.value !='' && thisform.xla_orderid2.value !='' && thisform.siteurl2.value!='' && thisform.license2.value!='') verify2();
	else alert('You must provide the full URL to the application, the full site URL, a licensed company name and a valid order ID Number');
	}

function verify2(){
	if (confirm('Save Changes?')){
		document.form1.buttonsave.value='1';
		form1.submit();
		}
	}

function confirmation(){
	if (!confirm('You are accessing the system configuration settings\nDo you want to continue?')) history.back();
}
<%#@~^0wAAAA==r6Ph/klo'rEPmx[PD.GM:/TxJrPY4nUPM+kwGxdnch.kDnPrmGU6kDhCDkGxvbpJ~Vk+PM+k2W	/nRSDrOPJmxBuG%u1]+Guv/]qu 3]+f]+sYG] oYFcvi9G1EhxDRhMkDn`E@!r:TPd.1'tDOw=zzE~QPmP3PvPdOHVn'9r/aVCz=xWUn,tnkT4D'T,hbNY4'Z@*B*iEDUIAAA==^#~@%>
</script>
<body bgcolor="#FFFFFF" text="#000000">
<form name="form1" method="post" action="options.asp">
  <table width="90%" border="0" cellspacing="2" cellpadding="2" align="center">
    <tr align="left" valign="top"> 
      <td colspan="2"><b><font size="2" face="Arial, Helvetica, sans-serif"><img src="images/icOptions.gif" width="20" height="20" align="absmiddle">Configuration 
        Settings</font></b></td>
    </tr>
    <tr align="left" valign="top"> 
      <td colspan="2" bgcolor="#666666"></td>
    </tr>
    <tr align="left" valign="top"> 
      <td colspan="2" bgcolor="#F3F3F3"><font size="1" face="Arial, Helvetica, sans-serif">Use 
        this option to set and configure your Absolute News Manager. Write permission 
        is required on the application's folder.</font></td>
    </tr>
    <tr align="left" valign="top"> 
      <td colspan="2" bgcolor="#666666"></td>
    </tr>
    <%#@~^FgAAAA==r6PnMDKD:ko@!@*JrPOtx7QYAAA==^#~@%>
    <tr bgcolor="#FF0000" align="left" valign="top"> 
      <td colspan="2"><font color="#FFFF00" size="2" face="Arial, Helvetica, sans-serif"><b>Error 
        : The new settings could not be saved because this directory has no write 
        permission</b></font></td>
    </tr>
    <tr align="left" valign="top" bgcolor="#F3F3F3"> 
      <td colspan="2"> 
        <p><font face="Arial, Helvetica, sans-serif" size="2">To save the new 
          settings you'll have to copy and paste the following code into a blank 
          .txt file and then rename that file to <b>configdata.asp</b> and upload 
          it to your Absolute News Manager Directory and your new settings will 
          take place.</font></p>
        <p><font face="Arial, Helvetica, sans-serif" size="2"><b> Here's the code 
          :</b><br>
          <textarea name="textfield" cols="50" rows="10" readonly wrap="OFF" style="width:100%"><%=#@~^CAAAAA==WbVnD+XYZQMAAA==^#~@%></textarea>
          <br>
          <br>
          <b>This are your current settings :</b></font></p>
      </td>
    </tr>
    <%#@~^JQAAAA==@#@&dn	N,k0@#@&ir0,:n/klLn@!@*Jr~Y4+xxwgAAA==^#~@%>
    <tr align="left" valign="top"> 
      <td colspan="2" bgcolor="#003399"><font color="#FFFFFF" size="2" face="Arial, Helvetica, sans-serif"><b><%=#@~^BwAAAA==h/dmo5QIAAA==^#~@%></b></font></td>
    </tr>
    <%#@~^BgAAAA==n	N~b0JgIAAA==^#~@%>
    <tr align="left" valign="top"> 
      <td width="30%" bgcolor="#CCCCCC"><b><font size="2" face="Arial, Helvetica, sans-serif">Licensed 
        to :<br>
        </font></b></td>
      <td width="70%" bgcolor="#F3F3F3"> 
        <input type="text" name="license2" value="<%=#@~^BwAAAA==sbmn	/4wIAAA==^#~@%>" size="32">
        <font face="Arial, Helvetica, sans-serif" size="2"> Order ID #</font> 
        <input type="text" name="xla_orderid2" value="<%=#@~^CwAAAA==a^lmKD9+DbNjQQAAA==^#~@%>" size="6">
        <br>
        <font size="1" face="Arial, Helvetica, sans-serif">Administrator Name 
        / Company </font></td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="30%" bgcolor="#CCCCCC"><b><font size="2" face="Arial, Helvetica, sans-serif">Site 
        URL :<br>
        </font></b></td>
      <td width="70%" bgcolor="#F3F3F3"> 
        <p> 
          <input type="text" name="siteurl2" value="<%=#@~^BwAAAA==dbYn!D^CAMAAA==^#~@%>" size="50">
          <br>
          <font size="1" face="Arial, Helvetica, sans-serif">Enter your site's 
          URL</font></p>
      </td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="30%" bgcolor="#CCCCCC"><b><font size="2" face="Arial, Helvetica, sans-serif">Application 
        URL :<br>
        </font></b></td>
      <td width="70%" bgcolor="#F3F3F3"> 
        <input type="text" name="applicationurl2" value="<%=#@~^DgAAAA==CawsbmmYkKx!.V5wUAAA==^#~@%>" size="50">
        <br>
        <font size="1" face="Arial, Helvetica, sans-serif">Full URL to the AbsoluteNew 
        Manager Directory.</font></td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="30%" bgcolor="#CCCCCC"><font face="Arial, Helvetica, sans-serif" size="2"><b>Charset 
        Encoding : </b></font></td>
      <td width="70%" bgcolor="#F3F3F3"> <font face="Arial, Helvetica, sans-serif"> 
        <input type="text" name="charset2" value="<%=#@~^BwAAAA==^4l.k+D6gIAAA==^#~@%>" size="50">
        <br>
        <font size="1">Please type the appropiate character set for your language</font></font></td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="30%" bgcolor="#CCCCCC"><font face="Arial, Helvetica, sans-serif" size="2"><b>Publisher 
        Access :</b></font></td>
      <td width="70%" bgcolor="#F3F3F3"> 
        <p><font face="Arial, Helvetica, sans-serif" size="2"> 
          <input type="checkbox" name="pblaccess2" value="checked" <%=#@~^CQAAAA==2(VC1m//sAMAAA==^#~@%>>
          Publishers can only search / acces their own articles and zones<br>
          </font><font face="Arial, Helvetica, sans-serif" size="2"> 
          <input type="checkbox" name="pblusers2" value="checked" <%=#@~^CAAAAA==2(V;k+M/cAMAAA==^#~@%>>
          Publishers cannot access to other publishers information</font></p>
      </td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="30%" bgcolor="#CCCCCC"><font face="Arial, Helvetica, sans-serif" size="2"><b>Editor's 
        Access :</b></font></td>
      <td width="70%" bgcolor="#F3F3F3"><font face="Arial, Helvetica, sans-serif" size="1"><font size="2"> 
        <input type="checkbox" name="onlyadmins2" value="checked" <%=#@~^CgAAAA==G	VzmNskxkPgQAAA==^#~@%>>
        Only Editors Can Publish Articles</font><br>
        Check this option if you want the editors to review the articles before 
        publishing.<br>
        If you check this option, the writers will be only able to set the status 
        of an article to PENDING while editors will be able to change it to PUBLISH 
        or EXPIRED</font></td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="30%" bgcolor="#CCCCCC"><font face="Arial, Helvetica, sans-serif" size="2"><b>Attachments 
        &amp; External Articles:</b></font></td>
      <td width="70%" bgcolor="#F3F3F3"> <font face="Arial, Helvetica, sans-serif" size="2"> 
        <input type="checkbox" name="openfilesnew2" value="checked" <%=#@~^DAAAAA==Ga+U6k^+/	+SDwUAAA==^#~@%>>
        Open The Article's Files On a new WIndow<br>
        <input type="checkbox" name="openexternal2" value="checked" <%=#@~^DAAAAA==Ga+U6D+D	l^FQUAAA==^#~@%>>
        Open External Articles (URL's) on a new window</font></td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="30%" bgcolor="#CCCCCC"><font size="2" face="Arial, Helvetica, sans-serif"><b>No 
        News Message :</b></font></td>
      <td width="70%" bgcolor="#F3F3F3"> 
        <input type="text" name="nonewsmessage2" value="<%=#@~^DQAAAA==UKxnS/s+/klTnfwUAAA==^#~@%>" size="50">
        <br>
        <font size="1" face="Arial, Helvetica, sans-serif">This message will be 
        displayed when no news are available.</font></td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="30%" bgcolor="#CCCCCC"><b><font face="Arial, Helvetica, sans-serif" size="2">Related 
        Articles :</font></b></td>
      <td width="70%" bgcolor="#F3F3F3"> <font face="Arial, Helvetica, sans-serif" size="2">No 
        Related Articles Label :</font> 
        <input type="text" name="norelated2" value="<%=#@~^CQAAAA==UKDn^lD+NvgMAAA==^#~@%>" size="30">
        <br>
        <font size="1" face="Arial, Helvetica, sans-serif">This message will be 
        displayed when no related articles are found (You can leave it blank)<br>
        </font><font face="Arial, Helvetica, sans-serif" size="2"> <font size="1"> 
        <font size="2"> </font><font face="Arial, Helvetica, sans-serif" size="2"><font size="1"><font size="2">
        <input type="checkbox" name="relatedheadlinedate2" value="checked" <%=#@~^EwAAAA==.VCD+9t+mN^rxNCYuQcAAA==^#~@%>>
        </font></font>Display headline dates</font><font size="2"><br>
        <input type="checkbox" name="relatedsummary2" value="checked" <%=#@~^DgAAAA==.VCD+9/Es:m.X7wUAAA==^#~@%>>
        </font></font>Display Summaries</font><font face="Arial, Helvetica, sans-serif" size="1">&nbsp; 
        </font></td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="30%" bgcolor="#CCCCCC"><b><font face="Arial, Helvetica, sans-serif" size="2">Read 
        More Label :</font></b></td>
      <td width="70%" bgcolor="#F3F3F3"> 
        <input type="text" name="readmore2" value="<%=#@~^CAAAAA==.l[sWM+TwMAAA==^#~@%>" size="50">
        <br>
        <font size="1" face="Arial, Helvetica, sans-serif">To display a &quot;Read 
        More&quot; link for each headline in your zones, type the label here</font></td>
    </tr>
    <tr align="left" valign="top"> 
      <td bgcolor="#CCCCCC"><font face="Arial, Helvetica, sans-serif" size="2"><b>Cache 
        :</b></font></td>
      <td bgcolor="#F3F3F3"> <font face="Arial, Helvetica, sans-serif" size="2"> 
        <input type="checkbox" name="zonecache2" value="checked" <%=#@~^CQAAAA=="Kxn1l1t+sAMAAA==^#~@%>>
        Enable Zone's Cache<br>
        <input type="checkbox" name="articlecache2" value="checked" <%=#@~^DAAAAA==CMYr1Vml1t2AQAAA==^#~@%>>
        Enable Article's Cache</font><br>
        <font face="Arial, Helvetica, sans-serif" size="2">Enable Cached content 
        for 
        <input type="text" name="cachetime2" value="<%=#@~^CQAAAA==^mm4Yb:+owMAAA==^#~@%>" size="4">
        Minutes</font><br>
        <font face="Arial, Helvetica, sans-serif" size="1">Write permission is 
        required on the &quot;Cache&quot; folder of Absolute News Manager<br>
        Article's Caching is only available for articles using HTML Templates</font></td>
    </tr>
    <tr align="left" valign="top"> 
      <td bgcolor="#CCCCCC"><font face="Arial, Helvetica, sans-serif" size="2"><b>Components 
        : </b></font></td>
      <td bgcolor="#F3F3F3"><font face="Arial, Helvetica, sans-serif" size="2">E-Mail 
        Component (incEmail.asp) : <b><font color="#0066CC"><%=#@~^DgAAAA==nslr^mK:wKxUY2wUAAA==^#~@%><br>
        </font></b>Upload Component (incUpload.asp) :<b><font face="Arial, Helvetica, sans-serif" size="2" color="#0066CC"> 
        <%=#@~^DwAAAA==;aVGmN1W:aW	nxDWAYAAA==^#~@%></font></b></font></td>
    </tr>
    <tr align="left" valign="top"> 
      <td bgcolor="#CCCCCC"><font face="Arial, Helvetica, sans-serif" size="2"><b>Zone's 
        Syndication :</b> </font></td>
      <td bgcolor="#F3F3F3"> <font face="Arial, Helvetica, sans-serif" size="2"> 
        <font size="1"> 
        <input type="radio" name="zoneprotection" value="any" <%#@~^SgAAAA==r6P"KxwDKY^YbWU'rJ~GMPyKU+aDWDn^YbW	'ElUzrPOtUPM+d2Kx/n SDrY~rm4m0+NrQhsAAA==^#~@%>>
        The Zone Code can be called from any URL<br>
        <input type="radio" name="zoneprotection" value="restricted" <%#@~^PAAAAA==r6P"KxwDKY^YbWU'rDndDDk1O+9JPD4nx,D/2WUdRADbO+,J^4m3n[rjhYAAA==^#~@%>>
        The Zone Code can only be called from the following URL's<br>
        <input type="radio" name="zoneprotection" value="banned" <%#@~^OAAAAA==r6P"KxwDKY^YbWU'r4CU	+Nr~Y4+x,.n/aW	/nRA.bYnPr^tmVn9JvRQAAA==^#~@%>>
        The Zone Code can not be called from the follwing URL's</font><br>
        <textarea name="specialurls2" rows="4" cols="36"><%=#@~^CwAAAA==da+^bl^ED^/pwQAAA==^#~@%></textarea>
        <br>
        <font size="1">Use this option to protect your headlines from being displayed 
        from other sites<br>
        Type the URL's pressing [ENTER] between each one.</font></font></td>
    </tr>
    <tr align="left" valign="top"> 
      <td bgcolor="#CCCCCC"><font face="Arial, Helvetica, sans-serif" size="2"><b>Archives 
        :</b></font></td>
      <td bgcolor="#F3F3F3"> <font face="Arial, Helvetica, sans-serif" size="2"> 
        <input type="checkbox" name="archiveenabled2" value="checked" <%=#@~^DgAAAA==CMm4b\+xm4^nNrQUAAA==^#~@%>>
        Archive Expired Articles after 
        <input type="text" name="archivedays2" size="6" value="<%=#@~^CwAAAA==CMm4b\NlH/kwQAAA==^#~@%>">
        Days <br>
        <input type="checkbox" name="archiveaccess2" value="checked" <%=#@~^DQAAAA==CMm4b\lm1+kdVAUAAA==^#~@%>>
        Archived Articles Can be Edited &amp; Browsed (Only Editors &amp; Administrators)</font></td>
    </tr>
    <tr align="left" valign="top"> 
      <td bgcolor="#CCCCCC"><font face="Arial, Helvetica, sans-serif" size="2"><b>Absolute 
        Image Gallery Support :</b></font></td>
      <td bgcolor="#F3F3F3"><font face="Arial, Helvetica, sans-serif" size="2">Absolute 
        Image Gallery Application URL : 
        <input type="text" name="aigurl2" value="<%=#@~^BgAAAA==Cbo;MVhAIAAA==^#~@%>">
        <br>
        <font size="1">Use this option to allow insertion of Inline images from 
        your Absolute Image Gallery.<br>
        For more information on Absolute Image Gallery <a href="http://www.xigla.com/absoluteig" target="_blank">Click 
        Here</a></font></font></td>
    </tr>
    <tr align="left" valign="top"> 
      <td bgcolor="#CCCCCC"><font face="Arial, Helvetica, sans-serif" size="2"><b>Database 
        Options : </b></font></td>
      <td bgcolor="#F3F3F3"><font face="Arial, Helvetica, sans-serif" size="1"> 
        <input type="button" name="Button2" value="Compact Database" onClick="javascript:compactdb()">
        <script language="JavaScript">function compactdb(){
	window.open('compact.asp','','width=340,height=260,statusbar=no,toolbar=no,scrollbars=yes,navbar=no');
}
</script>
        <br>
        This option is only available if you're using an Access database with 
        a DSN-Less Connection</font></td>
    </tr>
    <tr align="left" valign="top"> 
      <td bgcolor="#CCCCCC"><font face="Arial, Helvetica, sans-serif" size="2"><b> 
        E-Mail Options :<br>
        </b><font size="1">For sending articles by e-mail and plug-ins with e-mail 
        capability</font></font></td>
      <td bgcolor="#F3F3F3"> 
        <p><font face="Arial, Helvetica, sans-serif" size="2"><b>Default E-Mail 
          Address :</b><br>
          <input type="text" name="defaultemail2" value="<%=#@~^DAAAAA==[0C!VD+:mk^7QQAAA==^#~@%>" size="50">
          <font size="1"><br>
          Must be a valid e-mail address on your SMTP Server</font></font></p>
      </td>
    </tr>
    <tr align="left" valign="top"> 
      <td bgcolor="#CCCCCC">&nbsp;</td>
      <td bgcolor="#F3F3F3"><font face="Arial, Helvetica, sans-serif" size="2"><b>SMTP 
        Server :</b></font><br>
        <font face="Arial, Helvetica, sans-serif" size="2"> 
        <input type="text" name="smtpserver2" value="<%=#@~^CgAAAA==dsY2k+M\+MWwQAAA==^#~@%>" size="50">
        <br>
        <font size="1"> SMTP </font><font size="1">Server used to send e-mails</font></font></td>
    </tr>
    <tr align="left" valign="top"> 
      <td bgcolor="#CCCCCC">&nbsp;</td>
      <td bgcolor="#F3F3F3"><font face="Arial, Helvetica, sans-serif" size="2"><b>Subject 
        :</b><br>
        <input type="text" name="emailsubject2" value="<%=#@~^DAAAAA==nslr^/!4LmD+AQAAA==^#~@%>" size="50">
        </font><font face="Arial, Helvetica, sans-serif" size="2"><br>
        <font size="1">Default Subject for the articles and e-mails sent from 
        within the application</font></font></td>
    </tr>
    <tr align="left" valign="top"> 
      <td bgcolor="#CCCCCC">&nbsp;</td>
      <td bgcolor="#F3F3F3"><font face="Arial, Helvetica, sans-serif" size="2"><b>Signature 
        : </b><br>
        <textarea name="emailsignature2" cols="46"><%=#@~^DgAAAA==nslr^/boxmY!.+2gUAAA==^#~@%></textarea>
        <br>
        <font size="1">Add a signature to all the articles and e-mails sent from 
        Absolute News Manager</font></font></td>
    </tr>
    <tr align="left" valign="top"> 
      <td bgcolor="#CCCCCC"><font face="Arial, Helvetica, sans-serif" size="2"><b>E-Mail 
        Notifications</b></font></td>
      <td bgcolor="#F3F3F3"><font face="Arial, Helvetica, sans-serif" size="2"> 
        Send Notifications when New Articles Are Posted :<br>
        <input type="checkbox" name="notifyeditor2" value="checked" <%=#@~^DAAAAA==UKYr6XNkDWMIAUAAA==^#~@%>>
        To Editors<br>
        <input type="checkbox" name="notifyadmin2" value="checked" <%=#@~^CwAAAA==UKYr6XmN:bxogQAAA==^#~@%>>
        To Administrators<br>
        Notification Subject : 
        <input type="text" name="notifysubject2" value="<%=#@~^DQAAAA==UKYr6XkE4N+1OiQUAAA==^#~@%>" size="30">
        </font></td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="30%" bgcolor="#666666"> 
        <input type="hidden" name="buttonsave">
        </td>
      <td width="70%" bgcolor="#666666"> 
        <input type="button" name="button" value="Save Settings" onClick="javascript:verify()">
      </td>
    </tr>
  </table>
</form>
</body>
</html>