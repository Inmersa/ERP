<?php

function pre_exportar(&$Sesion) {
	header('Content-type: text/xml');
}

function existe_imagen_peq($Sesion,$aParam) {
	$img = array_shift($aParam);
	if (empty($img)) return false;
	$path = $Sesion->getFromKrn('doc_root');
	return is_file($path.'/catalogo/peq_'.$img);
}

function existe_imagen_med($Sesion,$aParam) {
	$img = array_shift($aParam);
	if (empty($img)) return false;
	$path = $Sesion->getFromKrn('doc_root');
	return is_file($path.'/catalogo/med_'.$img);
}

function existe_imagen($Sesion,$aParam) {
	$img = array_shift($aParam);
	if (empty($img)) return false;
	$path = $Sesion->getFromKrn('doc_root');
	return is_file($path.'/catalogo/'.$img);
}

function xml_encode($dato) {
	return htmlspecialchars($dato);
}

?>
