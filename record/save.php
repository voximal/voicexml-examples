<?php
  

  $phpversion = split(".",phpversion());
  //$file = $_FILES['message'];

  if ($phpversion >= 4)
  {
     $contenttype = $_FILES['message']['type'];
     $filename = $_REQUEST["filename"];
     $file = $_FILES['message']['tmp_name'];
     $mail = $_REQUEST["mail"];
  }
  else
  {
     $contenttype = $message_type;
     $file = $message;
  }

  if(isset($file))
  { 
    $filedir='./';
    if (!file_exists($filedir))
    {
       mkdir($filedir,0777);
       @chmod($filedir,0777);
    }
    


    switch ($contenttype)
    {
    case "video/3gpp":
    case "video/3gp":
       $extension = ".3gp";
       break;
    case "image/tiff":
       $extension = ".tiff";
       break;
    default:
       $extension = ".wav";
       break;

    }
    if (file_exists("$filedir/$filename"))
    {
        @unlink($filedir/$filename);
    }

    if(move_uploaded_file($file, "$filedir/$filename$extension"))
    {
        $message = $filedir.$filename.$extension." saved !";
    }
    else
    {
        $message = "Error : write error for create $filedir/$filename$extension";
    }


    if (isset($mail))
    {
        require("../demo/include/class.phpmailer.php");

        // Instantiate your new class
        $mail = new PHPMailer();
          
        // Now you only need to add the necessary stuff
        $mail->Host     = "172.17.100.2";
        $mail->Mailer   = "smtp";
        
        $mail->FromName = "Navis";
          
        $mail->AddAddress("jeanyves.guerillot@ferma.fr", "JYG");
        $mail->Subject = "Message recorded";
        $mail->Body    = "Your record message is saved in pib-02/vxml/jyg/$filename$extension";
         
         
        if ( !$mail->AddAttachment("$filename$extension") )
        {
            readfile("errorphp.vxml");
            echo "erreur Attach";
            exit;
        }
       
        
        if(!$mail->Send())
        {
            readfile("errorphp.vxml");
            exit;
        }
        
    }  

  }
  else
    $message = "Error : no file !";
  
  
  //echo($message); 
  readfile("waitend.vxml");

  exit;
?>

