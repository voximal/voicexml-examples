<?php
$value = 'something from somewhere';

setcookie("TestCookie", $value);
setcookie("TestCookie", $value, time()+3600);  /* expire in 1 hour */
setcookie("TestCookie", $value, time()+3600, "/~rasmus/", ".example.com", 1);

echo '<?xml version="1.0" encoding="iso-8859-1" ?>';
echo ' <vxml xml:lang="en-UK" version="2.0" xmlns="http://www.w3.org/2001/vxml">';
echo '  <form>';

echo '   <block>';
echo '    <prompt>';
echo '    Set the cookies in the HTTP request.';
echo '    </prompt>';
echo '    <submit method="post" next="getcookies.php" />';
echo '   </block>';

echo '  </form>';
echo ' </vxml>';

?> 