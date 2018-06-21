<?php

sleep(6);

echo '<?xml version="1.0" ?>';
echo ' <vxml version="2.0" xmlns="http://www.w3.org/2001/vxml">';
echo '  <form>';

echo '   <property name="fetchaudiodelay" value="3s" />';
echo '   <property name="fetchaudiominimum" value="20s" />';

echo '   <block>';
echo 'Page 2, Page 2. with audio fetch.';
echo '    <submit next="page3.php" method="post" fetchaudio="longaudio.wav"/>';
echo '   </block>';

echo '  </form>';
echo ' </vxml>';

?>