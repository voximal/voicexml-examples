<?php
echo '<?xml version="1.0" encoding="iso-8859-1" ?>';
echo ' <vxml xml:lang="en-UK" version="2.0" xmlns="http://www.w3.org/2001/vxml">';
echo '  <form>';

echo '   <block>';
echo '    <prompt>';
echo '    Get the cookies.';

// Print an individual cookie
echo $_COOKIE["TestCookie"];
echo $HTTP_COOKIE_VARS["TestCookie"];

// Another way to debug/test is to view all cookies
print_r($_COOKIE);

echo '    </prompt>';
echo '   </block>';

echo '  </form>';
echo ' </vxml>';

?> 