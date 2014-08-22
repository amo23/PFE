<!-- #include file="incLoadTemplate.asp" -->
<!-- #include file="incCache.asp" -->
<%
dim headline,headlinedate,source,summary,article,zoneid,zonetemplate,zonename
dim related,images,videos,audios,links,attachments

sub anmviewarticle(articleid,zoneid)
	if openfilesnew<>"" then targetfile="target=_blank" else targetfile=""

	set conn=server.createobject("ADODB.Connection")
	if application("xlaANM_connection")<>"" then connection=application("xlaANM_connection")
	conn.open connection
	if articleid<>"" and isnumeric(articleid) then
		psql="select * from varticleszones where articleid="&articleid
		if zoneid<>"" and isnumeric(zoneid) then psql=psql & " and zoneid="&zoneid
		set rs=conn.execute(psql)
		if not(rs.eof) then
			headline=rs("headline")
			headlinedate=rs("headlinedate")
			source=rs("source")
			summary=rs("summary")
			article=rs("article")
			summary=rs("summary")
			zonename=rs("zonename")
			zoneid=rs("zoneid")
			zonetemplate=rs("template")
			relatedid=rs("relatedid")
			autoformat=rs("autoformat")
			editor=rs("editor")
			if (isnull(autoformat) or autoformat="") and editor=0 then	article=replace(server.htmlencode(article),vbcrlf,"<br>")
			
			'/// Replace In-Line Files Path ///
			article=replace(article,"./" & articlefiles,applicationurl&articlefiles,1,-1,1)
			
		else
			zonetemplate="no-article.htm"
		end if
		rs.close
		set rs=nothing
		
		'/// Get Related Articles ///
		if len(relatedid)>0 then
			related="<ul>"
			psql="select * from articles where articleid in ("&relatedid&")"
			set rs=conn.execute(psql)
			do until rs.eof
				related=related & "<li><b><a href='"&applicationurl&"anmviewer.asp?a="&rs("articleid")&"&z="&zoneid&"'>"&rs("headline")&"</a></b>"
				if relatedheadlinedate<>"" then related=related & " ("&rs("headlinedate")&")"
				if relatedsummary<>"" and len(rs("summary"))>0 then related=related &"<br>"&rs("summary")
				related=related &"<br></li>"
				rs.movenext
			loop
			rs.close
			set rs=nothing
			related=related & "</ul>"
		else
			related=norelated
		end if
	
		if headline<>"" then
	
			'/// Read Images and Files ///
			psql="select * from articlefiles where articleid="&articleid
			set rs=conn.execute(psql)
			do until rs.eof
				urlfile=rs("urlfile")
				filename=rs("filename")
				
				if instr(filename,"./" & articlefiles) and urlfile<>0 then
					filename=replace(filename,"./" & articlefiles,applicationurl&articlefiles,1,-1,1)
				end if
			
				if urlfile=0 then filename=applicationurl&"articlefiles/"&articleid&"-"&rs("filename")
				if rs("filetype")="Image" then 
					file="<img src='"&filename&"' alt='"&rs("filetitle")&"'>"
					images=images & file &"<br>&nbsp;"
					if rs("filecomment")<>"" then images=images & rs("filecomment")&"<br>&nbsp;"
				else
					file="<a href='"&filename&"'"&targetfile&">"&rs("filetitle")&"</a>"
					files = "&#149;&nbsp;"&file&"<br>"
					if rs("filecomment")<>"" then files=files & rs("filecomment")
					files=files&"<br>"
					select case ucase(rs("filetype"))
						case "VIDEO"
							videos=videos & files
						case "AUDIO"
							audios=audios & files
						case "LINK"
							links=links & files
						case "INLINE"
							'/// Nothing Happens
						case else
							attachments=attachments & files
					end select
				end if
			rs.movenext
			loop
			rs.close
			set rs=nothing	
		end if
	else
		zonetemplate="no-article.htm"
	end if
	conn.close
	set conn=nothing

	'/// Load Template File ////
	windowcode="<script language=JavaScript>function openppl(app,tlb,mnu,wdt,hei){window.open('"&applicationurl&"' + app,'','toolbar=' + tlb +',location=0,status=1,menubar=' + mnu +',scrollbars=1,resizable=1,width=' + wdt + ',height=' + hei);}</script>"
	if print<>"" then zonetemplate="print-article.htm"
	
	if lcase(right(zonetemplate,4))<>".asp" then
	
		'/// Parse HTML Template ///
		template=loadtemplate(zonetemplate)

		'/// Replace TAGS in template ///
		template=replace(template,"$$ARTICLE$$",article,1,-1,1)
		template=replace(template,"$$ARTICLEID$$",articleid,1,-1,1)
		template=replace(template,"$$AUDIOS$$",audios,1,-1,1)
		template=replace(template,"$$FILES$$",attachments,1,-1,1)
		template=replace(template,"$$HEADLINE$$",headline,1,-1,1)
		template=replace(template,"$$HEADLINEDATE$$",headlinedate,1,-1,1)
		template=replace(template,"$$IMAGES$$",images,1,-1,1)
		template=replace(template,"$$LINKS$$",links,1,-1,1)
		template=replace(template,"$$RELATED$$",related,1,-1,1)
		template=replace(template,"$$SITE$$",license,1,-1,1)
		template=replace(template,"$$SITEURL$$",siteurl,1,-1,1)
		template=replace(template,"$$SOURCE$$",source,1,-1,1)
		template=replace(template,"$$SUMMARY$$",summary,1,-1,1)
		template=replace(template,"$$VIDEOS$$",videos,1,-1,1)
		template=replace(template,"$$ZONEID$$",zoneid,1,-1,1)
		template=replace(template,"$$ZONENAME$$",zonename,1,-1,1)
		template="<base href='"&applicationurl&"templates/"&zonetemplate&"'>"&windowcode&template
		
		'/// Do Cache ? ///
		if articlecache<>"" then
			if resultfile<>"" then call writecache(resultfile,template)
		end if
		
		'/// Write HTML Parsed Template ///
		response.write template

	else
		'/// Keep Variables for ASP Template ///
		response.write windowcode
	end if	
end sub

%>
