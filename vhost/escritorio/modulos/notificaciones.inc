<?php

/** **
include_once "Mail.php";
include_once "Mail/mime.php";

class Notificacion extends dbItem {
	var $ST_NUEVO = 1;
	var $ST_LEIDO = 2;
	var $ST_REENVIADO = 4;
	var $ST_ENCORREO = 8;

	function Notificacion ($AppName = NULL, $dbase = 'data', $aData = NULL) {

		if (empty($AppName)) $AppName = $GLOBALS['APP_NAME'];
		if (empty($dbname)) $dbname = 'data';
		$tabla = 'Notificaciones';

		$aFlds['Notificaciones:Mensaje'] = array(
			// Claves, propia y foraneas
			'id_notificacion',
			// Fechas
			'fecha',
			// Estados
			'estado',
			// datos
			'de','para','tema','tipo_mime','body'
			);
		$aAcciones['fecha'] = array('method' => 'setDate');

		if (!parent::dbItem($AppName,$dbname,$tabla,$aData,$aAcciones)) {
			$this->setFlag($this->ST_CORRUPT);
			return false;
		}

		return true;
	}

	function setDate($campo = 'fecha',$valor = NULL) {
		if (empty($valor)) $valor = date('Y-m-d H:i:s');
		return $this->setAttribute('fecha',$valor);
	}

	function getDate() {
		return $this->getAttribute('fecha');
	}

	function de($remite) {
		return $this->setAttribute('de',$remite);
	}

	function para($destino) {
		return $this->setAttribute('para',$destino);
	}

	function tema($tema) {
		return $this->setAttribute('tema',$tema);
	}

	function setMessage($oMsg) {
		if (!is_a($oMsg,'MultiPartMessage')) return false;
		return $this->setAttribute('body',$oMsg->get());
	}

	function getMessage() {
		return $this->getAttribute('body');
	}

	function getId() {
		return $this->getAttribute('id_notificacion');
	}

	function preDump() {
		$f = $this->getDate();
		if (empty($f)) $this->setDate();
		$fr = $this->getDate();
		$this->debug("$f o $fr",'preDump');
		return true;
	}

}

class MultiPartMessage {
	var $oMsg;

	function MultiPartMessage($crlf = "\r\n") {
		$this->oMsg = new Mail_mime($crlf);
		return true;
	}

	function setTXTBody($text) {
		$this->oMsg->setTXTBody($html);
		return true;
	}

	function setHTMLBody($html) {
		$this->oMsg->setHTMLBody($html);
		return true;
	}

	function addAttachment($file,$mime = 'text/plain') {
		$this->oMsg->addAttachment($file,$mime);
		return true;
	}

	function get() {
		return $this->oMsg->get();
	}

	function headers($hdrs) {
		return $this->oMsg->headers($hdrs);
	}

	function &factory($tipo = 'mail') {
		return Mail::factory($tipo);
	}

}

/** Un mensaje, que puede tener 'attach' relacionados **/
class Message {
	var $_aContent = array();
	var $_aFiles = array();

	function Message() {
	}

	function addPart($msg,$name = NULL) {
		if (!strstr($msg,'\n')) {
			// Puede ser un file
			if ($this->verifyFile($file)) {
				$file = $msg;
				$msg = NULL;
			}
		}

		if (!empty($msg)) {
			$retval = $this->addContent($msg);
		} else {
			$retval = $this->addFile($file,$name);
		}
		return $retval;
	}

	function addFile($file,$name = NULL) {
		if ($this->verifyFile($file)) {
			$aTmp['file'] = $file;
			$aTmp['name'] = $name;
			$aTmp['content-type'] = mime_content_type($file);
			array_push($this->_aContent,$aTmp);
			return array_pop(array_keys($this->_aFiles));
		}
	}

	function addContent($msg) {
		$aTmp['content'] = $msg;
		array_push($this->_aContent,$aTmp);
		return array_pop(array_keys($this->_aContent));
	}

	function verifyFile($file) {
		if (is_file($file)) return true;
	}

}

/** Una lista de varios Mensajes **/

class MimeMail {
}

function mail_attach($to, $from, $subject, $message, $files,$lb="\n") {
	// $to Recipient
	// $from Sender (like "email@domain.com" or "Name <email@domain.com>")
	// $subject Subject
	// $message Content
	// $files hash-array of files to attach
	// $lb is linebreak characters... some mailers need \r\n, others need \n
	$mime_boundary = "<<<:" . md5(uniqid(mt_rand(), 1));
	$msg_boundary = "<<<:" . md5(uniqid(mt_rand(), 1));
	$header = "From: ".$from.$lb;
	$header.= "MIME-Version: 1.0".$lb;
	$header.= "Content-Type: multipart/related;".$lb;
	$header.= " boundary=\"".$mime_boundary."\"".$lb.$lb;
	// $contentfst = "This is a multi-part message in MIME format.".$lb.$lb;
	// $contentfst.= "--".$mime_boundary.$lb;
	// $contentfst.= "Content-Type: multipart/related ".$lb;
	// $contentfst.= "    boundary=\"".$msg_boundary."\"".$lb.$lb.$lb;

	$contentfst.= "--".$mime_boundary.$lb;
	$contentfst.= "Content-Type: text/html; charset=\"iso-8859-15\"".$lb;
	$contentfst.= "Content-Transfer-Encoding: 7bit".$lb.$lb.$lb;
	// $contentfst.= "Content-Transfer-Encoding: quoted-printable".$lb.$lb;

	if(is_array($files)) {
		$cnt = sizeof($files);
		$i = 1;
		foreach($files as $filename=>$filelocation) {
			if(is_readable($filelocation)) {
				$id = md5(uniqid(mt_rand(), 1));
				$data = chunk_split(base64_encode(implode("", file($filelocation))));
				// $content.= "Content-Disposition: attachment;".$lb;
				$content.= "Content-Type: ".mime_content_type($filelocation).$lb;
				//Application/Octet-Stream;";
				//$content.= " name=\"".$filename."\"".$lb;
				$content.= "Content-Transfer-Encoding: base64".$lb;
				$content.= "Content-Disposition: inline; filename=\"$filename\"".$lb;
				$content.= "Content-ID: <$id>".$lb.$lb;
				$content.= $data;
				$content.= "--".$mime_boundary.( ($i++>=$cnt) ? '--' : '').$lb;
				$message = str_replace($filename, 'cid:'.$id, $message);
			}
		}
	}
	$contentfst.= $message.$lb;
	$contentfst.= "--".$mime_boundary.$lb;

	$content = $contentfst.$content;
	// $content.= "--".$mime_boundary.$lb;

	if(mail($to, $subject, $content, $header)) {
		return TRUE;
	}
	return FALSE;
}

/** **/

?>
