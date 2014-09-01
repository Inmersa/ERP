<?php

function pre_direcciones_entrega(&$Sesion) {
	$registro=$Sesion->fetchVar('registro','POST');
	$estado=$Sesion->fetchVar('estado','POST');
	if (empty($estado)) $estado = 0;
	$oDb = $Sesion->get_db('data');
	switch ($estado) {
		case 1: /* modificacion de Direcciones_entrega */
			if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
				//Casos especiales con los registros
				$oDb->tb_replace("Direcciones_entrega",$registro);
				if (empty($registro['id_direccion'])) 
					$registro['id_direccion'] = $oDb->last_insert_id();
				$id_direccion = $registro['id_direccion'];
			}
			break;

		case 2 : //borrado
			$consulta="delete from Direcciones_entrega where id_direccion = $registro[id_direccion]";
			if(!$oDb->query($consulta)){
				$Sesion->lcMessage('LCS_DBERR',array('entidad' => 'Direcciones_entrega'));
			}
			break;

		default: //debug("Estado no reconocido");
			break;
	}//fin del case

}//fin del precode

function obtener_Clientes(&$Sesion,&$aDatos){
	$Sesion->set_var("Clientes",$aDatos["Direcciones_entrega.id_cliente"],"EXPIRE");
}

function chequear_Clientes(&$Sesion,&$aDatos){
	if($Sesion->get_var("Clientes")==$aDatos["Clientes.id_cliente"]) return 'selected="selected"';
}

function obtener_Pedidos(&$Sesion,&$aDatos){
	$Sesion->set_var("Pedidos",$aDatos["Direcciones_entrega.id_pedido"],"EXPIRE");
}

function chequear_Pedidos(&$Sesion,&$aDatos){
	if($Sesion->get_var("Pedidos")==$aDatos["Pedidos.id_pedido"]) return 'selected="selected"';
}

function obtener_Provincias(&$Sesion,&$aDatos){
	$Sesion->set_var("Provincias",$aDatos["Direcciones_entrega.id_provincia"],"EXPIRE");
}

function chequear_Provincias(&$Sesion,&$aDatos){
	if($Sesion->get_var("Provincias")==$aDatos["Provincias.id_provincia"]) return selected;
}

?>
