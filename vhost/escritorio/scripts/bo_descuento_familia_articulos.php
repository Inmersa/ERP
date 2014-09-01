<?php

/** listado de descuentos por cliente y familia de productos
  global $descuentos_familia_borrar;
  global $descuentos_familia_modificar;
  Acciones : Modificar , Borrar , Nuevo(anyadir) */

function cf_familias_seleccionadas(&$Sesion,&$aData) {
	return !store_id_check($Sesion,$aData['Familia_articulos.id_familia']);
}

function pre_descuento_familia_articulos(&$Sesion) {
	//Para saber de ke cliente estamos tratando
	$id_cliente=$Sesion->fetchVar('id_cliente','GET');
	$descuentos_familia_borrar=$Sesion->fetchVar('descuentos_familia_borrar','POST');
	$descuentos_familia_modificar=$Sesion->fetchVar('descuentos_familia_modificar','POST');
	$accion_ejecutar=$Sesion->fetchVar('accion_ejecutar','POST');

	$id_cliente_sesion = $Sesion->get_var("id_cliente_promocion");
	$oDb = $Sesion->get_db('data');

	//debug("glob  $id_cliente");
	//debug("ses $id_cliente_sesion");

	if(isset($id_cliente) AND $id_cliente_sesion != $id_cliente)
		$Sesion->set_var("id_cliente_promocion",$id_cliente);
	else {
		$id_cliente = $Sesion->get_var("id_cliente_promocion");
		if(!isset($id_cliente)){
			//               debug("no hay cliente");
			return;
		}
	}

	//$id_cliente = $Sesion->get_var("id_cliente_promocion");
	$usuario = identifica_usuarios($Sesion);
	//debug($id_cliente);

	switch($accion_ejecutar){
		case "Modificar" :
			if ($Sesion->verifyVar('descuentos_familia_modificar',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('descuentos_familia_modificar',IKRN_VAR_CRC_AUTHED)) {
				if(isset($descuentos_familia_modificar)) {
					foreach($descuentos_familia_modificar as $clave => $valor){
						$aTmp = array();
						$aTmp['descuento'] = $descuentos_familia_modificar[$clave];
						$aTmp['id_familia'] = $clave;
						$aTmp['id_cliente'] = $id_cliente;
						$aTmp['id_empresa'] = $usuario['id'];
						$oDb->tb_update('Cliente_familia_articulos',$aTmp);
					}
				}
			}
		break;

		case "Borrar" :
			if(isset($descuentos_familia_borrar)){
				foreach($descuentos_familia_borrar as $clave => $valor)
					if($valor == 1 ){
						$aTmp = array();
						$aTmp['id_familia'] = $clave;
						$aTmp['id_cliente'] = $id_cliente;
						$aTmp['id_empresa'] = $usuario['id'];
						$oDb->tb_delete('Cliente_familia_articulos',$aTmp);
					}
			}
		break;

		case "Anyadir" :
			if ($Sesion->verifyVar('descuentos_familia_modificar',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('descuentos_familia_modificar',IKRN_VAR_CRC_AUTHED)) {
				if(isset($descuentos_familia_modificar)){
					foreach($descuentos_familia_modificar as $clave => $valor){
						if($descuentos_familia_modificar[$clave] != 0){
							$aTmp['id_empresa'] = $usuario['id'];
							$aTmp['id_cliente'] = $id_cliente;
							$aTmp['id_familia'] = $clave;
							$aTmp['descuento'] = $descuentos_familia_modificar[$clave];
							$oDb->tb_replace('Cliente_familia_articulos',$aTmp);
						}
					}
				}
			}
		break;

	}//fin de acciones
}//fin del precode

?>
