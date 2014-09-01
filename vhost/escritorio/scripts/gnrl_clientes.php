<?php

function pre_seleccionar_clientes(&$Sesion) {
	$clientes_var=$Sesion->fetchVar('clientes_var','POST');
	$clientes_array=$Sesion->fetchVar('clientes_array','POST');

	if (!empty($clientes_var)) {
		$aSel = $Sesion->fetchVar($clientes_var,'POST');
		$array = 0;
	} elseif (!empty($clientes_array)) {
		$aSel = $Sesion->fetchVar($clientes_array,'POST');
		$array = 1;
	} else return NULL;

	$aCli = array();
	if (is_array($aSel))
		foreach ($aSel as $clave => $valor) {
			if (is_numeric($clave) AND is_numeric($valor) AND $clave == $valor) {
				array_push($aCli,$valor);
			} elseif (is_numeric($clave) AND is_numeric($valor)) {
				array_push($aCli,$valor);
			} elseif (!is_numeric($clave) AND is_numeric($valor)) {
				array_push($aCli,$valor);
			}
		}
	if (is_array($aCli) AND sizeof($aCli)) $Sesion->set_var("_clientes_seleccionados",$aCli,"INMED");

}

function cliente_seleccionado(&$Sesion,$Param) {
	$aClis = $Sesion->get_var('_clientes_seleccionados');
	if (!is_array($aClis)) return 0;
	if (is_array($Param))
		foreach ($Param as $id_cli) 
			if (in_array($id_cli,$aClis)) return 1;
	return 0;
}

?>
