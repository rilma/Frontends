<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<meta http-equiv="Content-Language" content="en-us">
<meta name="GENERATOR" content="Microsoft FrontPage 4.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<title></title>
<link rel="stylesheet" type="text/css" href="../../style_database.css">
<script language="JavaScript" src="kp_prog.js"></script>
<script language="JavaScript" src="../../database.js"></script>
<script language="php">

 include ("phpmag.php");
 $site = "est";
// $site = strtolower($site);
 if ($site=="est") $type = 0;
 if ($site=="def") $type = 1;
 $path = array("../data/","../data_wdc/");
 $dpath = $path[$type];
 $dirid = opendir($dpath);
 $i=0; $eod=0;
 while(!$eod) {
  $junk = readdir($dirid);
  $eod = ($junk == null);
  $revstr = substr(strrev($junk),0,3);
  if (!$eod && strlen($junk) > 2 && strcmp($revstr, 'txt') == 0) {
   $list[$i] = $junk;
   $i++;
  }
 }
 closedir($dirid);
 $num_year = $i;
 for ($i=0;$i<$num_year;$i++) {
  $year[$i] = (int)substr($list[$i],0,4);
 }
 sort($year);
 $set_month[$num_year-1][11] = 0;
 $ij = 0;
 $k = 0;
 for($i=0;$i<$num_year;$i++) {
  $yyyy = $year[$i];
  switch($type) {
   case 0:
    $data_start = kp_read($type, $yyyy, $dpath);
    $fchm = 5;
    $fchd = 8;
    $fext = "_DGD.txt";
    break;
   case 1:
    $data_start = 2;
    $fchm = 4;
    $fchd = 6;
    $fext = "_kp.txt";
    break;
  }
  $fd = fopen($dpath.sprintf("%04d",$yyyy).$fext,"r");
   for($ik=0;$ik<$data_start;$ik++) {
    $buffer = fgets($fd, 4096);
   }
   while(!feof($fd)) {
    $buffer = fgets($fd, 4096);
    $anho = intval(substr($buffer,0,4));
    $mes = intval(substr($buffer,$fchm,2));
    $dia = intval(substr($buffer,$fchd,2));
    if($anho != 0 || $mes != 0 || $dia !=0) {
     $mkt = mktime(0,0,0,$mes,$dia,$anho);
     $fecha[$i][$ij] = gmdate("M d, Y", $mkt);
     $monthfile = strtolower(gmdate("M", $mkt));
     switch ($monthfile) {
      case "jan": $set_month[$i][0] = 1; break;
      case "feb": $set_month[$i][1] = 1; break;
      case "mar": $set_month[$i][2] = 1; break;
      case "apr": $set_month[$i][3] = 1; break;
      case "may": $set_month[$i][4] = 1; break;
      case "jun": $set_month[$i][5] = 1; break;
      case "jul": $set_month[$i][6] = 1; break;
      case "aug": $set_month[$i][7] = 1; break;
      case "sep": $set_month[$i][8] = 1; break;
      case "oct": $set_month[$i][9] = 1; break;
      case "nov": $set_month[$i][10] = 1; break;
      case "dec": $set_month[$i][11] = 1; break;
     }
     $ij++;
    }
   }
  fclose($fd);
 }

	echo "<script language=\"JavaScript\">\n";
	echo "<!--\n";
	echo "var year = [";
	for($i=0;$i<$num_year;$i++) echo $year[$i],($i<($num_year-1))?",":"];\n";
	echo "var set_month = [ ";
	for($i=0;$i<$num_year;$i++)
	{	echo "[";
		for($j=0;$j<12;$j++) echo ($set_month[$i][$j]+0),($j<11)?",":"";
		echo ($i<($num_year-1))?"],\n":"]";
	}
	echo " ];\n";
	echo "//-->\n";
	echo "</","script>\n";
</script>
</head>

<body>

<h1>Planetary K-index</h1>

<form method="POST">

	<p>Select one year:<br>
	<select name="year" size="1" onchange="ctrl_year(this.form,parent.frame2)">
		<option selected>Year</option>
		<option>___________</option>
		<script language="php">
			for($i=0;$i<$num_year;$i++)
			{ echo "<option>",$year[$i],"</option>"; }
			echo "\n";
		</script>
	</select></p>

	<p>Select one month:<br>
	<select name="month" size="1" onchange="ctrl_month(this.form,parent.frame2)">
		<option selected>Month</option>
		<option>___________</option>
	</select> 
<!--
<input type="button" name="button" value="View" onclick="ctrl_month(this.form,parent.frame3)"></p>
-->
</form>

</html>
