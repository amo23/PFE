<%
Dim JMail
sub sendmail(recipient,subject,message,replyto)
	JMail.addrecipient recipient
	if replyto<>"" then JMail.replyto=replyto
	JMail.ServerAddress = smtpserver
	JMail.Sender = mailadmin
	JMail.Subject = subject
	JMail.Body = message
	JMail.Execute
	set Jmail=nothing
end sub


sub addattachment(thefile)
	JMail.addattachment thefile
end sub

sub startcomponent()
	Set JMail = Server.CreateObject("JMail.SMTPMail")
end sub
%>

