<?php

require("include/class.phpmailer.php");

if (isset($message))
{                   
 if (file_exists($message))
 //if (1)
 {
  // Instantiate your new class
  $mail = new PHPMailer();
  
  // Now you only need to add the necessary stuff
  $mail->Host     = "";
  $mail->Port     = "22";
  $mail->Mailer   = "mail";

  //$mail->From     = "Navis";
  $mail->FromName = "Barradevoces";
  
  $mail->AddAddress("borja.sixto@i6net.com", "Borja");
  $mail->Subject = "Message recorded form ".$phone;
  $mail->Body    = "A file is attached ($message_type).";
  
  if ($message_type=="image/tiff")
  $mail->AddAttachment($message, $message_name.".tiff");
  else if ($message_type=="video/quicktime")
  $mail->AddAttachment($message, $message_name.".mov");
  else
  $mail->AddAttachment($message, $message_name.".wav");

  if(!$mail->Send())
  {
   readfile("error.vxml");
   exit;
  }  
 }
}
readfile("goodbye.vxml");	
?>