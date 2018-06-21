<?php
	session_start();
	header('Content-Type: text/plain; charset=ansi');
	require_once('/var/www/thewoice/woice/protected/config/system.php');
	include(SYS_ROOT_INT_DIR_VXN.'/inc/inc_open_db.php');
	include(SYS_ROOT_INT_DIR_VXN.'/inc/inc_functions.php');
	$lettere = array("a","b","c" , "d", "e", "f", "g", "h", "i","j","k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v","w","x","y", "z");
	$ln = $_REQUEST['ln'];
	
	
	?>
#ABNF 1.0 iso-8859-1;
mode voice;
language <?=etc($ln)?>;
tag-format <semantics/1.0>;
root $main;
public $main = {out=""} ($digit {out += rules.digit})<1->;
$digit= $a | $b | $c |$d |$e |$f |$g |$h |$i |$j |$k |$l |$m |$n |$o |$p |$q |$r |$s |$t |$u |$v |$w |$x |$y |$z |  $spec_char | $cifre; 

<? 
	echo "\n";
	foreach($lettere as $char)
	{
		$sql = "SELECT * FROM woice_spelling WHERE iniziale='".$char."' AND lang= ".$ln." ;"; 
		$result = mysqli_query($conn_gramm,$sql)or die(mysqli_error($conn));
		$res = mysqli_fetch_assoc($result);//primo risultato siamo sicuri che c'e'
		echo ' $'.$char.' = '.$res['val']. ' { out="'.$char.'" ; } ';
		while ($res = mysqli_fetch_assoc($result))
		{
			echo " | ".$res['val']." { out=\"".$char."\" ; } ";
		}
		echo ";\n";
	}


?>

	$spec_char =spazio { out= " " ; } | chiocciola { out= "@" ; } | et { out= "@" ; } | punto { out= "." ; } | trattino basso { out= "_" ; } | underscore { out= "_" ; } | trattino alto { out= "-" ; } | upperscore { out= "-" ; } | meno { out= "-" ; };
	$cifre = 1 | 2 | 3 | 4 | 5 |  6| 7| 8| 9| 0;
<? ?>
