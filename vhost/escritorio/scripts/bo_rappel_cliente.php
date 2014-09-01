<?php

/** 
global $id_cliente;
//arrays de datos
global $rappel_inicio;
global $rappel_final;
global $rappel_fecha_inicio;
global $rappel_porcentaje;
global $rappel_borrar;

Acciones : Borrar , Nuevo (anyadir) , Modificar
*/
function pre_descuento_rappel_cliente(&$Sesion) {
	$id_cliente=$Sesion->fetchVar('id_cliente','GET');
	$rappel=$Sesion->fetchVar('rappel','POST');
	$rappel_borrar=$Sesion->fetchVar('rappel_borrar','POST');
	$accion_ejecutar=$Sesion->fetchVar('accion_ejecutar','POST');

	$id_cliente_sesion = $Sesion->get_var("id_cliente_promocion");
	if(isset($id_cliente))
		  $Sesion->set_var("id_cliente_promocion",$id_cliente);
	elseif (isset($id_cliente_sesion) AND !empty($id_cliente_sesion)) 
		$id_cliente = $id_cliente_sesion;
	elseif (!strcasecmp($usuario['desktop_name'],"cliente")){
		$id_cliente = $usuario['valor'];
		$Sesion->set_var("id_cliente_promocion",$id_cliente);
	}

	$oDb = $Sesion->get_db('data');
	$usuario = identifica_usuarios($Sesion);
	$tmp = $Sesion->get_var("id_empresa");
	if ($usuario['id'] != $tmp OR empty($tmp)) {
		$Sesion->set_var("id_empresa",$usuario['id'],"NOEXPIRE");
		$id_empresa = $usuario['id'];
	} else $id_empresa = $tmp;

	switch($accion_ejecutar){
		case "Modificar" :
			if ($Sesion->verifyVar('rappel',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('rappel',IKRN_VAR_CRC_CHANGE)) {  
				if (is_array($rappel))
					foreach($rappel as $id => $aRappel) {
						$aRappel['id_rappel'] = $id;
						$aRappel['fecha_inicial'] = descolocar_fecha($aRappel['fecha_inicial']);
						$aRappel['id_cliente'] = $id_cliente;
						$aRappel['id_empresa'] = $id_empresa;
						$oDb->tb_update("Rappel",$aRappel);
					}
			}
		  	break;

		case "Borrar" :
			if(isset($rappel_borrar) AND is_array($rappel_borrar) AND sizeof($rappel_borrar))
				foreach($rappel_borrar as $clave => $valor)
					if ((int)$valor) $oDb->tb_delete("Rappel",array("id_rappel" => $clave));
		 break;

		case "Anyadir" :
			if ($Sesion->verifyVar('rappel',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('rappel',IKRN_VAR_CRC_CHANGE)) {
				if(isset($rappel))
					foreach($rappel as $idx => $aRappel)
						if (is_numeric($aRappel['monto_inicial']) AND is_numeric($aRappel['monto_final']) 
								AND !empty($aRappel['fecha_inicial'])) {
							$aRappel['fecha_inicial'] = descolocar_fecha($aRappel['fecha_inicial']);
							$aRappel['id_cliente'] = $id_cliente;
							$aRappel['id_empresa'] = $id_empresa;
							$oDb->tb_replace("Rappel",$aRappel);
						}

			}
			break;
	}

}//fin del precode


?>
