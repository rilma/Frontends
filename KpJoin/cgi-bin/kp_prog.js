//<!--
var sitestr = ['est','def'];

/*
function calendar_cgi(year,month,calendar_web)
{	href = "../cgi-bin/winds_calendar.php?year="+year+"&month="+month+"&small=";
	if (calendar_web==parent.frame2) href = href+"1"
	else href = href+"0";
	return(href);
}
*/

function calendar_cgi(year,month,calendar_web)
{ //      siteid = parent.frame1.document.forms[0].site.selectedIndex-2;
 siteid = 0;
 return ("../cgi-bin/kp_calendar.php?year="+year+"&month="+month+"&site="+sitestr[siteid]);
}

function kp_page(image,datafile,webpage)
{ webpage.document.clear();
  webpage.document.open();
  webpage.document.writeln('<html>\n');
  webpage.document.writeln('<head>');
  webpage.document.writeln('<link rel="stylesheet" type="text/css" href="../../style_database.css">');
  webpage.document.writeln('</head>');
  webpage.document.writeln('<body>');
  webpage.document.writeln('<center><IMG SRC="'+image+'"></center>');
  webpage.document.writeln('<blockquote><blockquote><blockquote><font color="#FF0000"><H6>(Red)</font>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Kp >= 5<br></H6>');
  webpage.document.writeln('<font color="#FFFF00"><H6>(Yellow)</font> Kp = 4<br></H6>');
  webpage.document.writeln('<font color="#009F00"><H6>(Green)</font>&nbsp;&nbsp;&nbsp;Kp <= 3</H6></blockquote></blockquote></blockquote>');
//  webpage.document.writeln('<center><A HREF="'+datafile+'"> ASCII DATA </A></center>');
  webpage.document.writeln('<table border="0" cellpadding="3" width="100%"><tr><td width="100%">&nbsp;<hr size="0"><p align="center"><font size="2">Implemented by <a href="MAILTO:%20rilma@jro.igp.gob.pe">Ronald Ilma</a> (March 10, 2004)</font></td></tr></table>');
  webpage.document.writeln('</body></html>');
  webpage.document.close();
}

//-->
