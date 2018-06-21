<?php

//header("Cache-Control: no-cache, must-revalidate"); // HTTP/1.1
header("Expires: Mon, 26 Jul 1997 05:00:00 GMT"); // Date in the past

echo '<?xml version="1.0" encoding="iso-8859-1" ?>';
echo ' <vxml version="2.0" xmlns="http://www.w3.org/2001/vxml">';
echo '  <form>';

echo '   <block>';
echo '    <prompt> Date :';
echo gmdate("H:i:s", time());
echo '    </prompt>';
echo '   </block>';

echo '  </form>';
echo ' </vxml>';

?>