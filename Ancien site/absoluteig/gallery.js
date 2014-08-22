function addtomybox(imageid){
	eval('document.form1.boxbtn' + imageid + '.src=\'addtobox.asp?imageid=' + imageid +'\';');
}

function slideshow(imageid,categoryid){
	thebox=document.form1.box.value;
	thenew=document.form1.shownew.value;
	document.form1.action='gallery.asp?action=viewimage&slideshow=on&categoryid=' + categoryid + '&imageid=' + imageid + '&box=' + thebox +'&shownew=' + thenew ;
	document.form1.submit();
}

function stopslideshow(){
	window.clearTimeout(timer1)
	document.form1.slideshowon.style.display='';
	document.form1.slideshowoff.style.display='none';
	document.getElementById("slideshowmode").style.display='none';
}

function ratefile(imageid){
	var	rating=window.open('rateimage.asp?imageid=' + imageid ,'rating','toolbar=0,location=0,status=1,menubar=0,scrollbars=1,resizable=0,width=200,height=240');
}

function clearmybox(){
if (confirm('Clear Your Favorite Files?')) self.location.href='gallery.asp?action=mybox&clear=1';
}

function openmybox(){
	var openmybox=window.open('mybox.asp'  ,'openmybox','toolbar=0,location=0,status=1,menubar=0,scrollbars=1,resizable=0,width=400,height=300');
}

function sendpostcard(imageid){
	var	postcard=window.open('sendpostcard.asp?imageid=' + imageid ,'postcard','toolbar=0,location=0,status=1,menubar=0,scrollbars=1,resizable=1,width=720,height=460');
}

