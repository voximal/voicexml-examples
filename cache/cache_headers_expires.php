<?php

//header("Expires: Mon, 26 Jul 1997 05:00:00 GMT"); // Date in the past
header("Expires: " . gmdate("D, d M Y H:i:s", time()+60*1) . " GMT"); 

echo '<?xml version="1.0"?>';
echo ' <vxml version="2.0" xmlns="http://www.w3.org/2001/vxml">';
echo '  <form>';

echo '   <block>';
echo '    <prompt> Expire :';
echo gmdate("D, d M Y H:i:s", time()+60*1);
echo '    </prompt>';
echo '   </block>';

echo '  </form>';
echo ' </vxml>';

?>