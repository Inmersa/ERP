<?php
/** Relacion de descuentos entre los clientes y articulos especificos
  global $id_cliente;
  global $descuentos_articulo_modificar_descuento;
  global $descuentos_articulo_modificar_monto;
  global $descuentos_articulo_borrar;
  Acciones Modificar Borrar Nuevo(Anyadir)
 */

function pre_descuento_articulos(&$Sesion) {
	//Para saber de ke cliente estamos tratando

	$id_cliente=$Sesion->fetchVar('id_cliente','GET');
	//variables del formilario
	$descuentos_articulo_modificar_descuento=$Sesion->fetchVar('descuentos_articulo_modificar_descuento','POST');
	$descuentos_articulo_modificar_monto=$Sesion->fetchVar('descuentos_articulo_modificar_monto','POST');
	$descuentos_articulo_borrar=$Sesion->fetchVar('descuentos_articulo_borrar','POST');
	$accion_ejecutar=$Sesion->fetchVar('accion_ejecutar','POST');
	$cliente_articulos=$Sesion->fetchVar('cliente_articulos','POST');

	$id_cliente = id_entidad($Sesion,'id_cliente',$id_cliente);

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
	$oDb = $Sesion->get_db('data');
	$usuario = identifica_usuarios($Sesion);
	$id_empresa = $usuario['id'];

	switch($accion_ejecutar) {
		case "Modificar" :
			if(isset($descuentos_articulo_modificar_monto) or isset($descuentos_articulo_modificar_descuento)){
				foreach($descuentos_articulo_modificar_monto as $clave => $valor){
					$aTmp['monto'] = ( (is_numeric($descuentos_articulo_modificar_monto[$clave])) ? $descuentos_articulo_modificar_monto[$clave] : 'null') ;
					$aTmp['descuento'] = ( (is_numeric($descuentos_articulo_modificar_descuento[$clave])) ? $descuentos_articulo_modificar_descuento[$clave] : 'null');
					$aTmp['id_cliente'] = $id_cliente;
					$aTmp['id_empresa'] = $id_empresa;
					$aTmp['id_articulo'] = $clave;
					$oDb->tb_update('Cliente_articulos',$aTmp);
				}
			}
		break;

		case "Borrar" :
			if(isset($descuentos_articulo_borrar)){
				foreach($descuentos_articulo_borrar as $clave => $valor)
					if($valor == 1 ){
						$consulta="delete from Cliente_articulos
							where id_articulo = $clave AND
							Cliente_articulos.id_cliente = $id_cliente AND
							Cliente_articulos.id_empresa = $usuario[id]";
						$oDb->query($consulta);
					}
			}
		break;

		case "Anyadir" :
			if (is_numeric($id_cliente) AND is_array($cliente_articulos) AND sizeof($cliente_articulos)) {
				foreach ($cliente_articulos as $id => $aArt)
					if (is_numeric($aArt['id_articulo']) AND $id == $aArt['id_articulo']) {
						$aArt['id_cliente'] = $id_cliente;
						$aArt['id_empresa'] = $id_empresa;
						$aArt['monto'] = ( (is_numeric($aArt['monto'])) ? $aArt['monto'] : 'null') ;
						$aArt['descuento'] = ( (is_numeric($aArt['descuento'])) ? $aArt['descuento'] : 'null') ;
						$oDb->tb_replace('Cliente_articulos',$aArt);
					}
			}
		break;

	}

}//fin del precode
/** utillizada para poner check box en el buscador */
function tiene_descuento(&$Sesion,&$aDatos){
	$id_familia_act  = $aDatos["Articulos.id_articulo"];
	$usuario = identifica_usuarios($Sesion);
	$oDb = $Sesion->get_db('data');

	$id_cliente = $Sesion->get_var("id_cliente_promocion");
	$consulta="select Cliente_articulos.id_articulo from Cliente_articulos
		where Cliente_articulos.id_articulo = $id_familia_act AND
		Cliente_articulos.id_cliente = $id_cliente AND
		Cliente_articulos.id_empresa = $usuario[id]";

	$resul = $oDb->query($consulta);
	return $oDb->num_rows($resul);
}

/** deteccion del cambio de familia para la agrupacion */
function cambio_nombre_familia(&$Sesion,&$aDatos){
	static $nombre_familia;
	// debug($nombre_familia);
	//debug(nombre_familia != $aDatos[Familia_articulos.nombre]);
	if(!isset($nombre_familia) OR ($nombre_familia != $aDatos["Familia_articulos.nombre"]) ){
		$nombre_familia = $aDatos["Familia_articulos.nombre"];
		return TRUE;
   } else return FALSE;
}

function precio_tarifa(&$Sesion,&$aDatos){
	if (!empty($aDatos['Tarifas.monto'])) {
		$precio = $aDatos[$aDatos['Tarifas.campo_accion']] + $aDatos['Tarifas.monto'];
	} else {
		$precio = $aDatos[$aDatos['Tarifas.campo_accion']];
		if (!empty($aDatos['Tarifas.pto_primero'])) 
			$precio += $precio * ($aDatos['Tarifas.pto_primero'] / 100);
		if (!empty($aDatos['Tarifas.pto_segundo'])) 
			$precio += $precio * ($aDatos['Tarifas.pto_segundo'] / 100);
	}
	return round($precio,3);
}

function articulo_decliente(&$Sesion,$aParams) {
	static $aProdList;
	$id_cliente = id_entidad($Sesion,'id_cliente');
	if (!is_numeric($id_cliente)) return true;
	if (!is_array($aParams) OR !sizeof($aParams)) return false;
	if (!is_array($aProdList) OR !sizeof($aProdList)) {
		$aProdList = array();
		$oDb = $Sesion->get_db('data');
		$rs = $oDb->query('SELECT id_articulo FROM Cliente_articulos WHERE id_cliente = '.$id_cliente);
		if ($oDb->num_rows($rs)) 
			while ($aTmp = $oDb->fetch_row($rs)) 
				array_push($aProdList,$aTmp[0]);
	}
	$id = array_shift($aParams);
	if (!is_array($aProdList)) return false;
	return in_array($id,$aProdList);
}


?>
