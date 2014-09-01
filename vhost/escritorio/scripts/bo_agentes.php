<?php
/** Funcion de tratamiento de agentes
global $borrar_agentes;
global $registro;
global $registro2;
global $importar_agentes;
Acciones ;  Importar , Nuevo , Borrar , Modificar 
 */

function pre_agentes(&$Sesion) {
	$id_agente=$Sesion->fetchVar('id_agente','GET'); //de modificar para meter en la sesion
	$borrar_agentes=$Sesion->fetchVar('borrar_agentes','POST');
	$registro=$Sesion->fetchVar('registro','POST');
	$importar_agentes=$Sesion->fetchVar('importar_agentes','POST');
	$accion_ejecutar=$Sesion->fetchVar('accion_ejecutar','POST');
	$acciones=$Sesion->fetchVar('acciones','POST');

	$id_agente = id_entidad($Sesion,'id_agente',$id_agente);
	if (!is_numeric($id_agente) AND strcasecmp($Sesion->get_subsecc_name(),'bo_agentes') ) {
		$Sesion->lcMessage('LCS_NOID',array('entidad' => 'Agentes'),IM_FATALERROR);
	}
	$Sesion->set_var('id_agente',$id_agente);
	$id_empresa = $idemp = $Sesion->get_var('id_empresa');

	$oDb = $Sesion->get_db('data');
	$db_conf = $Sesion->get_db('conf');

	enlazar_crm($Sesion);

	switch($accion_ejecutar){
		case "Importar" :
			//si estamos metiendo un proveedor nuevo ,
			if(isset($importar_agentes)){
				foreach($importar_agentes as $clave => $valor)
					if($valor == 1 ){
						$consulta="select * from Agentes where id_agente = $clave";
						$resul = $oDb->query($consulta);
						$row=$oDb->fetch_array($resul);
						$row['id_empresa'] = $idemp;
						$row['id_agente'] =NULL;
						if (!$oDb->tb_replace("Agentes",$row))
							$Sesion->lcMessage('LCS_DBERR',array('entidad' => 'Agentes'));
					}
			}
		break;

		case "Borrar" :
			if(isset($borrar_agentes)){
				foreach($borrar_agentes as $clave => $valor)
					if($valor == 1 ){
						//Fixme: Aqui habria que borrar el usuario y desmarcar el activo, del agente.
						$consulta="delete from Agentes
							where Agentes.id_agente = $clave AND
							Agentes.id_empresa = $idemp";
						$oDb->query($consulta);
						$consulta="delete from Agentes_clientes
							where Agentes_clientes.id_agente = $clave";
						$oDb->query($consulta);
					}
			}
		break;

		case "Modificar" :
			if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
				$db_conf = $Sesion->get_db('conf');
				if(!(is_object($db_conf))) {
					$Sesion->lcMessage('LCS_DBNULL',array('dbname' => 'Conf'));
					return ;
				}
						
				$oUsr = $Sesion->get_authed_user();
				if (!empty($registro['login']) AND $registro['passwd']==$registro['passwd2'] ) {
					$id_usr = $oUsr->dbReplaceUser(array('login' => $registro['login'], 'passwd' => $registro['passwd'], 
													'id_usr' => $registro['id_usr'], 'nombre' => $registro['nombre'], 'activo' => 1,
													'apellidos' => $registro['apellidos']),'Agentes');
					if (!empty($id_usr) AND $id_usr != -1) $registro['id_usr'] = $id_usr;
					elseif (empty($registro['id_usr'])) $registro['id_usr'] = 'null';
				} elseif (!empty($registro['login']))  {
					$Sesion->lcMessage('LCS_USR_PASSWORDMISMATCH',array('login' => $registro['login']));
				} elseif ( empty($registro['login']) AND is_numeric($registro['id_usr']) ) {
					$registro['id_usr'] = $oUsr->dbReplaceUser(array('login' => $registro['login'], 'id_usr' => $registro['id_usr']),'Agentes');
					if ($registro['id_usr'] <= 0 ) $registro['id_usr'] = 'null';
				}

				if (is_array($acciones) AND sizeof($acciones)) {
					if (is_numeric($acciones['descartar_usuario_crm'])) $registro['crm_id_empleado'] = 'null';
				}

				$registro['id_empresa'] = $idemp;
				if (is_numeric($registro['id_agente'])) $oDb->tb_update("Agentes",$registro);
				else $oDb->tb_replace("Agentes",$registro);

				if(!is_numeric($registro['id_agente'])) {
					$registro['id_agente'] = $oDb->last_insert_id();
				}
				$Sesion->set_var("id_agente",$registro['id_agente'],"SUBSECCION");

			}

		case 'Seleccion_usuario_crm' :
			$usuario_seleccionado = $Sesion->fetchVar('usuario_seleccionado','POST');
			if (is_numeric($id_agente) and is_numeric($usuario_seleccionado) AND is_numeric($id_empresa)) {
				$oDb->tb_update('Agentes',array('id_agente'=>$id_agente,'crm_id_empleado'=>$usuario_seleccionado,'id_empresa'=>$id_empresa));
			}

		break;
	}//fin de switch

}


function pre_agentes_clientes(&$Sesion){
	$borrar_cliente_agente=$Sesion->fetchVar('borrar_cliente_agente','POST');
	$agentes_clientes_comision=$Sesion->fetchVar('agentes_clientes_comision','POST');
	$agentes_clientes_comision_repartida=$Sesion->fetchVar('agentes_clientes_comision_repartida','POST');
	$importar_clientes_agente=$Sesion->fetchVar('importar_clientes_agente','POST');
	$accion_ejecutar=$Sesion->fetchVar('accion_ejecutar','POST');

	$id_agente = id_entidad($Sesion,'id_agente',$id_agente);
	if (!is_numeric($id_agente)) {
		$Sesion->lcMessage('LCS_NOID',array('entidad' => 'Agentes'),IM_FATALERROR);
	}
	$idemp = $Sesion->get_var('id_empresa');

	$oDb = $Sesion->get_db('data');
	switch($accion_ejecutar){
		case "Borrar" :
			if(isset($borrar_cliente_agente)){
				foreach($borrar_cliente_agente as $clave => $valor)
					if($valor == 1 ){
						$consulta="delete from Agentes_clientes
							where Agentes_clientes.id_agente = $id_agente AND
							Agentes_clientes.id_cliente = $clave";
						$oDb->query($consulta);
					}
			}
		break;

		case "Modificar" :
			if(isset($agentes_clientes_comision)){
				foreach($agentes_clientes_comision as $clave => $valor){
					$valor = (float)$valor;
					$agentes_clientes_comision_repartida[$clave] = (float)$agentes_clientes_comision_repartida[$clave];
					$consulta="update Agentes_clientes set comision = $valor , comision_repartida = $agentes_clientes_comision_repartida[$clave]
						where Agentes_clientes.id_agente = $id_agente AND
						Agentes_clientes.id_cliente = $clave";
					$oDb->query($consulta);
				}
			}
		break;

		case "Importar" :
			if(isset($importar_clientes_agente)){
				foreach($importar_clientes_agente as $clave => $valor)
					if($valor == 1 ){
						$row['id_cliente'] = $clave;
						$row['id_agente'] = $id_agente;
						$row['fecha_captacion'] = date("Y-m-d");
						if (!$oDb->tb_replace("Agentes_clientes",$row))
							$Sesion->lcMessage('LCS_DBERR',array('entidad' => 'Agentes_clientes'));
					}
			}
		break;
	}//fin de switch

}

function tiene_clientes_agente(&$Sesion,&$aDatos){
	$oDb = $Sesion->get_db('data');
	//depurar_array($aDatos);
	$id_agente_sesion = $Sesion->get_var("id_agente_promocion");
	$id_cli = $aDatos["Clientes.id_cliente"];
	$consulta = "select * from Agentes_clientes where id_agente = $id_agente_sesion AND id_cliente = $id_cli";
	$oDb->query($consulta);
	if($row = $oDb->fetch_array($resul))
		return 0;
	else return 1;
}

function nombre_login_real(&$Sesion,&$aDatos) {
	$db_conf = $Sesion->get_db('conf');
	if(is_object($db_conf))
		if($aDatos["Agentes.id_usr"] != 0){
			$consulta = "select login from Users where id_usr =" . $aDatos["Agentes.id_usr"];
			$rs = $db_conf->query($consulta);
			$row = $db_conf->fetch_row($rs);
			//      depurar_array($row);
			return $row[0];
		}
}


function suma_facturas_cliente(&$Sesion,&$aDatos){
	$fecha_inicio=$Sesion->fetchVar('fecha_inicio','GET');
	$fecha_fin=$Sesion->fetchVar('fecha_fin','GET');
	$fecha_inicio = descolocar_fecha($fecha_inicio);
	$fecha_fin = descolocar_fecha($fecha_fin);
	$oDb = $Sesion->get_db('data');

	$consulta = "select SUM(Facturas.monto_total) from Facturas , Pedidos where id_cliente =" . $aDatos["Agentes_clientes.id_cliente"]
		. " and Facturas.id_factura = Pedidos.id_factura and Pedidos.id_agente = " . $aDatos["Agentes_clientes.id_agente"]
		. " and Facturas.fecha between '$fecha_inicio' and '$fecha_fin'";
	$rs = $oDb->query($consulta);
	$row = $oDb->fetch_row($rs);
	$total = $Sesion->get_var("total");
	$Sesion->set_var("total",$total + $row[0],"SUBSECCION");
	return $row[0];
}

function suma_comisiones_cliente(&$Sesion,&$aDatos){
	$fecha_inicio=$Sesion->fetchVar('fecha_inicio','GET');
	$fecha_fin=$Sesion->fetchVar('fecha_fin','GET');
	$fecha_inicio = descolocar_fecha($fecha_inicio);
	$fecha_fin = descolocar_fecha($fecha_fin);
	$oDb = $Sesion->get_db('data');
	$consulta = "select SUM(Agentes_facturas.monto) from Agentes_facturas , Facturas
		where  id_agente = " . $aDatos["Agentes_clientes.id_agente"] .
		" and Facturas.id_cliente = "  . $aDatos["Agentes_clientes.id_cliente"] .
		" and Facturas.id_factura = Agentes_facturas.id_factura"
		. " and Facturas.fecha between '$fecha_inicio' and '$fecha_fin'";
	$rs = $oDb->query($consulta);
	$row = $oDb->fetch_row($rs);
	$total = $Sesion->get_var("total_comision");
	$Sesion->set_var("total_comision",$total + $row[0],"SUBSECCION");
	return $row[0];
}

function suma_total_comisiones_cliente(&$Sesion,&$aDatos){
	$total = $Sesion->get_var("total_comision");
	return $total;

}
function suma_total_facturas_cliente(&$Sesion,&$aDatos){
	$total = $Sesion->get_var("total");
	return $total;
}
function suma_total_comisiones_agente(&$Sesion,&$aDatos){
	$fecha_inicio=$Sesion->fetchVar('fecha_inicio','GET');
	$fecha_fin=$Sesion->fetchVar('fecha_fin','GET');
	$fecha_inicio = descolocar_fecha($fecha_inicio);
	$fecha_fin = descolocar_fecha($fecha_fin);
	$oDb = $Sesion->get_db('data');
	$consulta = "select SUM(Agentes_facturas.monto) from Agentes_facturas , Facturas
		where  id_agente = " . $Sesion->get_var("id_agente_promocion") .
		" and Facturas.id_factura = Agentes_facturas.id_factura"
		. " and Facturas.fecha between '$fecha_inicio' and '$fecha_fin'";
	$rs = $oDb->query($consulta);
	$row = $oDb->fetch_row($rs);
	return $row[0];
}
function suma_total_facturas_agente(&$Sesion,&$aDatos){
	$fecha_inicio=$Sesion->fetchVar('fecha_inicio','GET');
	$fecha_fin=$Sesion->fetchVar('fecha_fin','GET');
	$fecha_inicio = descolocar_fecha($fecha_inicio);
	$fecha_fin = descolocar_fecha($fecha_fin);
	$oDb = $Sesion->get_db('data');
	$consulta = "select SUM(Facturas.monto_total) from Facturas , Pedidos where Facturas.id_factura = Pedidos.id_factura and
		Pedidos.id_agente = " . $Sesion->get_var("id_agente_promocion")
		. " and Facturas.fecha between '$fecha_inicio' and '$fecha_fin'";
	$rs = $oDb->query($consulta);
	$row = $oDb->fetch_row($rs);
	return $row[0];
}

function valores_grafica(&$Sesion,$aData) {
	$aFacturado = $Sesion->get_var('facturado');
	$aCobrado = $Sesion->get_var('cobrado');
	$aComisiones = $Sesion->get_var('comisiones');
	$aClientes = $Sesion->get_var('leyenda');

	$aFacturado[$aData['Clientes.id_cliente']]['data'] = $aData['total_facturas'];
	$aFacturado[$aData['Clientes.id_cliente']]['link'] = '?seccion=bo_facturas_agente&id_cli='.$aData['Clientes.id_cliente'];

	$aCobrado[$aData['Clientes.id_cliente']]['data'] = $aData['monto_pagado'];
	$aComisiones[$aData['Clientes.id_cliente']]['data'] = $aData['comision'];

	$Sesion->set_var('facturado',$aFacturado,'INMED');
	$Sesion->set_var('cobrado',$aCobrado,'INMED');
	$Sesion->set_var('comisiones',$aComisiones,'INMED');

	$aClientes[$aData['Clientes.id_cliente']]['nombre'] = $aData['Clientes.razon_social'];
	$aClientes[$aData['Clientes.id_cliente']]['link'] = '?seccion=modif_clientes&id_cliente='.$aData['Clientes.id_cliente'];
	$Sesion->set_var('leyenda',$aClientes,'INMED');

	return true;
}

?>
