<?php

/** funciones de carrito de la compra */
function pre_hacer_pedido(&$Sesion) {
	debug("Haciendo pedido y tal ... ");

	$id_cliente=$Sesion->fetchVar('id_cliente','POST');
	$id_tarifa=$Sesion->fetchVar('id_tarifa','POST'); // Identificador de la tarifa que le tocca (en nuevo)

	$identificador_presupuesto=$Sesion->fetchVar('identificador_presupuesto','POST');//de donde viene
	$identificador_pedido=$Sesion->fetchVar('identificador_pedido','POST');//de donde viene
	$identificador_factura=$Sesion->fetchVar('identificador_factura','POST');//de donde viene

	// Variables para hacer/modificar un pedido.
	$Anyadir=$Sesion->fetchVar('Anyadir','POST');
	$vaciar_pedido=$Sesion->fetchVar('vaciar_pedido','GET');
	$array_ids=$Sesion->fetchVar('array_ids','POST');
	$array_detalle=$Sesion->fetchVar('array_detalle','POST');
	$borrar_articulos=$Sesion->fetchVar('borrar_articulos','POST');
	$repo=$Sesion->fetchVar('repo','POST');
	// $array_numero=$Sesion->fetchVar('array_numero','POST');
	// $array_bultos=$Sesion->fetchVar('array_bultos','POST');
	$aSelec=$Sesion->fetchVar('seleccion','POST',NULL,'classDocumentDetail');
	$array_numero=$aSelec['cantidad'];
	$array_bultos=$aSelec['bultos'];

	// Variables de pedidos Tipo.
	$pedidos_tipo_cliente=$Sesion->fetchVar('pedidos_tipo_cliente','POST');
	$tipo=$Sesion->fetchVar('tipo','GET');
	$nuevo=$Sesion->fetchVar('nuevo','GET POST');
	$accion_ejecutar=$Sesion->fetchVar('accion_ejecutar','POST');

	// Variables de control de que tipo de documento valorado es
	$pedido=$Sesion->fetchVar('pedido','GET POST');
	$factura=$Sesion->fetchVar('factura','GET POST');
	if (!empty($factura)) $abono=$Sesion->fetchVar('abono','POST GET');
	$presupuesto=$Sesion->fetchVar('presupuesto','POST GET');
	$proforma=$Sesion->fetchVar('proforma','POST GET');
	$albaran=$Sesion->fetchVar('albaran','POST GET');

	// subseccion de envio de la seleccion contenida en la cesta
	$returnlink = $Sesion->fetchVar('returnlink','GET');
	$cestasendto = $Sesion->get_var('_cesta_sendto');
	if (!empty($returnlink)) {
		$Sesion->set_var('_cesta_sendto','?seccion='.$returnlink,'SUBSECCION');
		// debug("retlink = $returnlink - ".$Sesion->get_var('_cesta_sendto'));
	} elseif (empty($cestasendto)) {
		$Sesion->set_var('_cesta_sendto','?seccion=confirmar_pedido','SUBSECCION');
	}

	$confirm_formto = $Sesion->fetchVar('_confirm_form_to','GET POST SESSION');
	if (!empty($confirm_formto)) $Sesion->set_var('send_form_to',$confirm_formto,'SECCION');

	// Fixme: Accesos de Usuarios.
	$usuario = identifica_usuarios($Sesion);
	$id_emp = $usuario['id'];

	// return NULL;
	$sessdocvar = $Sesion->get_var('__document_iface_varname');
	if ($nuevo) {
		$vaciar_pedido = 1;
		$keep_id = false;
		$tmpdoc = $Sesion->get_var('__document_iface_varname');
		$recDoc = $Sesion->get_var($tmpdoc);
		if (is_a($recDoc,'Document') AND $recDoc->getMode() & inmPed_VENTA ) $id_cliente_rec = $recDoc->get_reciever_id();
		$tmpdoc = NULL;

		$docvar = 'oPedido_en_curso';
		$Sesion->set_var('__document_iface_varname',$docvar,'NOEXPIRE');
		$Sesion->set_var('link_pedido_en_curso','hacer_pedido','NOEXPIRE');
		$Sesion->unset_var($docvar);
	} elseif (is_object($Sesion->get_var($sessdocvar))) {
		$docvar = $sessdocvar;
		if (empty($docvar)) $docvar = 'oPedido_en_curso';
		$keep_id = true;
	} else {
		$docvar = 'oPedido_en_curso';
		$Sesion->set_var('__document_iface_varname',$docvar);
		$oPed = $Sesion->get_var($docvar);
		$keep_id = TRUE;
	}
	$oPedido = $Sesion->get_var($docvar);

	$oDb = $Sesion->get_db('data');
	if (!is_object($oDb)) {
		$Sesion->lcMessage('LCS_MODULE_NOINSTANCE',array('class' => 'inmDB'));
		$Sesion->perror_link('?logout=1');
		return ;
	}

	// Esperemos que esto no de problemas.
	if ($tipo == 1 AND is_array($pedidos_tipo_cliente)) $oPedido = NULL;

	$id_cliente = id_entidad($Sesion,'id_cliente',$id_cliente);

	if (is_object($oPedido) AND empty($pedido) AND empty($factura)) $class_name = get_class($oPedido);
	elseif (!empty($pedido) AND $pedido) $class_name = 'Order';
	elseif (!empty($factura) AND $factura) $class_name = 'Invoice';
	elseif ( (!empty($presupuesto) AND $presupuesto) OR (!empty($proforma) AND $proforma) ) $class_name = 'Budget';
	elseif (!empty($albaran) AND $albaran) $class_name = 'DeliveryNote_IfaceToDocument';

	if (empty($class_name)) $class_name = 'Order';

	if ((int)$vaciar_pedido AND is_object($oPedido)) {
		if (!isset($id_cliente) OR ($keep_id)) {
			if ($oPedido->debug) debug("Vaciando el pedido y recogiendo sus datos");
			$aPed = $oPedido->get_info();
			if (is_numeric($aPed['id_cliente']) ) {
				$id_cliente = $aPed['id_cliente'];
			}
			if (is_numeric($aPed['id_empresa']))
				$id_emp = $aPed['id_empresa'];
			$id_tarifa = $aPed['id_tarifa'];
			if ($keep_id) $id_ped = (int)$oPedido->getId();
		} 
		if ($oPedido->debug) debug("reeeeset de pedido");
		$oPedido = NULL;
		$Sesion->unset_var($docvar);
	}

	if (!is_object($oPedido)) {
		if (!strcasecmp($usuario['desktop_name'],'cliente')) {
			$id_cliente = $usuario['valor'];
			$Sesion->set_var("id_cliente_promocion",$id_cliente);
		} elseif (isset($id_cliente)) {
			$id_cliente_sesion = $id_cliente;
			$Sesion->set_var("id_cliente_promocion", $id_cliente);
			$Sesion->set_var("id_cliente", $id_cliente);
		} elseif (!empty($id_cliente_rec)) {
			$id_cliente = $id_cliente_rec;
		} elseif (!empty($id_cliente_sesion) AND is_numeric($id_cliente_sesion)) {
			$id_cliente = $id_cliente_sesion;
			// debug("id_cli = $id_cliente");
		} else {
			$Sesion->lcMessage('LCS_NOID',array('entidad' => 'Clientes'),IM_WARNING);
			return ;
		}

		if(isset($identificador_presupuesto)) {
			$Sesion->set_var("identificador_presupuesto", $identificador_presupuesto);
			// $Sesion->set_var("es_presupuesto",1);
			$tipo_doc = 1;
		}  

		if((isset($identificador_pedido) AND (int)$identificador_pedido) OR ($tipo == 1)) {
			$Sesion->set_var("identificador_pedido", $identificador_pedido);
			// $Sesion->set_var("es_presupuesto",1);
			$tipo_doc = 0;
			$id_ped = (int)$identificador_pedido;
		} else $tipo_doc = 0;

		$oPedido = new $class_name ($Sesion->App_Name,'data',inmPed_VENTA);
		$base_ok = 0;
		if ($tipo == 1 AND is_array($pedidos_tipo_cliente)) {
			foreach ($pedidos_tipo_cliente as $idp => $val) {
				$oPedido_base = new $class_name ($Sesion->App_Name,'data',inmPed_VENTA);
				if (!$oPedido_base->dbfill($idp)) {
			  		$Sesion->lcMessage('ORDER_DBFILL',array('id' => $idp),IM_WARNING);
					$base_ok = 0;
					break;
				}
				if (!$base_ok) {
					$id_cl = $oPedido_base->get_reciever_id();
					$id_emp = $oPedido_base->get_issuer_id();
					if (!strcasecmp($usuario['desktop_name'],'Agente')) $id_ag = $usuario['valor'];
					$oPedido->set_issuer($id_emp);
					$oPedido->set_reciever($id_cl);
					if (is_numeric($id_ag)) $oPedido->set_agent($id_ag);
					$base_ok = 1;
				}
				for($idx = $oPedido_base->first_detail(); isset($idx); $idx = $oPedido_base->next_detail()) {
					$precio = $oPedido_base->get_price($idx);
					if (!$precio) continue;
					$id_art = $oPedido_base->get_detail_article_id($idx);
					$cant = $oPedido_base->get_quantity($idx);
					$oPedido->add_detail($id_art,$cant);
				}
				$oPedido_base = NULL;
				unset($oPedido_base);
			}
		} elseif ($factura AND $abono) {
			$id_fra = $Sesion->fetchVar('identificador_factura','POST GET');
			$selecciones = $Sesion->fetchVar('selecciones','POST');
			if (!is_array($selecciones)) $selecciones = $Sesion->fetchVar('borrar_articulos','POST');
			if (is_numeric($id_fra)) {
				if ($recDoc->getId() != $id_fra) {
					unset($recDoc);
					$recDoc = new $class_name ($Sesion->App_Name,'data',inmPed_VENTA);
					if (!$recDoc->dbFill($id_fra)) $recDoc = NULL;
				}
				$id_abono = $Sesion->fetchVar('id_factura_abono','POST GET');
				if (is_numeric($id_abono) AND !empty($id_abono)) {
					if ($oPedido->getId()) {
						unset($oPedido);
						$oPedido = new $class_name ($Sesion->App_Name,'data',inmPed_VENTA);
					}
					$oPedido->dbFill($id_abono);
				}
				// Si tenemos un documendo que abonar, calcamos las condiciones.
				if (is_a($recDoc,'Invoice')) {
					$oPedido->setInstallment(NULL,$recDoc,$selecciones);
				} else $oPedido->setInstallment();
			}
		}

		if (!$base_ok) {
			if (!$id_ped) {
				if ($oPedido->debug) debug("Emisor $id_emp");
				$oPedido->set_issuer($id_emp);
				if ($oPedido->debug) debug("receptor $id_cliente");
				$oPedido->set_reciever($id_cliente);
				if (is_numeric($id_tarifa)) $oPedido->set_revenue($id_tarifa);
				if (!strcasecmp($usuario['desktop_name'],'Agentes')) $id_agente = $usuario['valor'];
				if (is_numeric($id_agente)) $oPedido->set_agent($id_agente);
			} else {
				if (!$oPedido->dbfill($id_ped)) {
					if ($oPedido->debug) debug("No se ha podido rellenar los datos provenientes del pedido $id_ped");
			  		$Sesion->lcMessage('ORDER_DBFILL',array('id' => $id_ped),IM_FATALERROR);
					return ;
				}
				for ($idx=$oPedido->first_detail(); $idx; $idx=$oPedido->next_detail())
					$oPedido->del_detail($idx);
			}
		}
	} else {
		$id_cliente = $oPedido->get_reciever_id();
		if ($oPedido->debug) debug("oPedido es un objeto! cliente = $id_cliente; N detalles = ".sizeof($oPedido->_aDetalles));
	}
	if (is_object($oPedido)) {
		if (!strcasecmp(get_class($oPedido),'Order')) {
			$Sesion->set_var('es_pedido',1,'NOEXPIRE');
			$Sesion->unset_var('es_factura');
			$Sesion->unset_var('es_proforma');
			$Sesion->unset_var('es_presupuesto');
		} elseif(!strcasecmp(get_class($oPedido),'Invoice')) { 
			$Sesion->set_var('es_factura',1,'NOEXPIRE');
			$Sesion->unset_var('es_pedido');
			$Sesion->unset_var('es_proforma');
			$Sesion->unset_var('es_presupuesto');
		} elseif(!strcasecmp(get_class($oPedido),'Budget')) { 
			if ($proforma OR $oPedido->isProforma() ) {
				$Sesion->set_var('es_proforma',1,'NOEXPIRE');
				$Sesion->unset_var('es_presupuesto');
				$Sesion->unset_var('es_pedido');
				$Sesion->unset_var('es_factura');
				if (!$oPedido->isProforma()) $oPedido->toProforma();
			} else {
				$Sesion->set_var('es_presupuesto',1,'NOEXPIRE');
				$Sesion->unset_var('es_proforma');
				$Sesion->unset_var('es_pedido');
				$Sesion->unset_var('es_factura');
			}
		}
	}

	// Referencias HAbituales del Cliente:
	if (is_array($repo)) {
		$fini = wol_db::formatear_fecha($repo['fecha'],TRUE);
		if ( $fini != 'NULL' ) {
			$tmp = wol_db::formatear_fecha($repo['fecha_fin'],FALSE);
			if ($tmp == 'NULL') $ffin = 'NOW()';
			else $ffin = wol_db::formatear_fecha($repo['fecha_fin'],TRUE);

			$cons = "SELECT t1.id_articulo,SUM(t1.cantidad) ".
				"FROM Lineas_detalle t1, Pedidos t2, Direcciones_entrega t3, Articulos t4, Marcas t5 ".
				"WHERE t1.id_pedido=t2.id_pedido AND ".
				"(t2.id_proveedor = 0 OR t2.id_proveedor IS NULL) AND ".
				"t2.id_direccion=t3.id_direccion AND ".
				"t1.id_articulo=t4.id_articulo AND ".
				"t4.id_marca=t5.id_marca AND ".
				"t3.id_cliente = $id_cliente AND t2.fecha >= $fini ".
				"AND t2.fecha <= $ffin ".
				"GROUP BY t1.id_articulo ".
				'ORDER BY t5.nombre,t4.nombre ';
			$idrs = $oDb->query($cons);
			if ($oDb->num_rows($idrs)) {
				$Anyadir = 1;
				while($aTmp = $oDb->fetch_row($idrs)) {
					$array_numero[$aTmp[0]] = $aTmp[1];
					$array_ids[$aTmp[0]] = $aTmp[0];
				}
				$es_reposicion = true;
			}
		}
	} 

	if ($es_reposicion) $Sesion->set_var('es_reposicion',1,'SUBSECCION');
	else $Sesion->unset_var('es_reposicion');


	// $id_cli = $Sesion->get_var("id_cliente_pedido");
	if (!(int)$id_cli)
		$id_cli = $Sesion->get_var("id_cliente_promocion");
	if (!(int)$id_cli)
		$id_cli = $oPedido->get_reciever_id();

	// $Sesion->set_var("id_cliente_pedido", $id_cli);
	$Sesion->set_var("id_cliente_promocion", $id_cli);
	$Sesion->unset_var('id_proveedor');

	if(isset($Anyadir) ) {
		//si estamos borrando eliminar
		if ($Sesion->verifyVar('borrar_articulos',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('borrar_articulos',IKRN_VAR_CRC_AUTHED)) {
			if(is_array($borrar_articulos)) {
				debug("Fixme: borrar_articulos se ha disparado, comprobar en array.");
				foreach($borrar_articulos as $id_articulo)
					unset($array_numero[$id_articulo]);
			}
		}

		//aki se meten los bultos cantidades ¿y paletas ?

		// No se pueden meter referencias a pelo en las facturas de abono. 
		if (!method_exists($oPedido,'getInstallment') OR !$oPedido->getInstallment()) {
			if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
				if (is_array($array_bultos)) {
					foreach($array_bultos as $idx => $num) {
						if (!is_numeric($num) OR ($num==0 AND !$es_reposicion) ) continue;
						$id_art = $array_ids[$idx];
						if ($oPedido->debug) debug("localizando bulto $idx ... $id_art ($num)"); 
						$idxdet = $oPedido->add_detail($id_art,$num,TRUE);
					}
					// Para reconstruir indices de servicios disponibles
					$oPedido->_build_indexes();
				}
			}

			if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
				if (is_array($array_numero)) {
					foreach($array_numero as $idx => $num) {
						if (!is_numeric($num) OR ($num==0 AND !$es_reposicion) ) continue;
						if (!empty($array_bultos[$idx])) continue;

						$id_art = $array_ids[$idx];
						if ($oPedido->debug) debug("localizando cantidad idx $idx ... $id_art ($num)"); 
						if (!isset($array_bultos[$idx]) OR empty($array_bultos[$idx]))
							$idxdet = $oPedido->add_detail($id_art,$num);
					}
					// Para reconstruir indices de servicios disponibles
					$oPedido->_build_indexes();
				}
			}
		}
	}


	$Sesion->set_var($docvar,$oPedido);

}//fin del precode

/** Muestra el descuento que se aplica
  Prioridades Articulo/Cliente
  Familia/Cliente
  Articulo
  Familia
 */
function descripcion_descuento(&$Sesion,&$aDatos){
	$id_art = $aDatos["Articulos.id_articulo"];
	$usuario = identifica_usuarios($Sesion);
	// $id_cliente = $Sesion->get_var("id_cliente_pedido");
	$oPedido = $Sesion->get_var("oPedido_en_curso");
	$oDb = $Sesion->get_db('data');

	//DIVISA
	if (!is_object($oPedido)) {
		$consulta = "select leyenda from Divisa , Empresas ".
			" where Empresas.id_divisa = Divisa.id_divisa and id_empresa = $usuario[id]";
		$resuld=$oDb->query($consulta);
		$rowd=$oDb->fetch_array($resuld);
		$aplicar_descuentos = (int) $Sesion->get_var("aplicar_descuentos_cliente");
	} else {
		$id_cliente = $oPedido->get_reciever_id();
		$aDiv = $oPedido->get_currency();
		$rowd['leyenda'] = $aDiv['leyenda'];
		$aRec = $oPedido->get_reciever_info();
		$aplicar_descuentos = (int)$aRec['mostrar_ofertas'];
	}

	if (!is_numeric($id_cliente)) $id_cliente= id_entidad($Sesion,'id_cliente');

	//depurar_array($rowd);
	//debug($Sesion->get_var("aplicar_descuentos_cliente"));
	if($aplicar_descuentos == 1 AND is_numeric($id_cliente)){
		//SI A ESTE CLIENTE SE LE APLIKAN LOS DESCUENTOS
		//descuento por cliente y articulo
		$consulta = "Select descuento , monto  from Cliente_articulos  where id_articulo = $id_art and id_empresa = $usuario[id] and id_cliente = $id_cliente";
		$resul4 = $oDb->query($consulta);
		$row4 = $oDb->fetch_array($resul2);
		if($row4['descuento'] > 0 )
			return $row4['descuento'] .  "% Cli/Art";
		elseif($row4['monto'] > 0)
			return $row4['monto'] ." " .  $rowd['leyenda'] .  " Cli/Art";

		//descuento por familia de articulos y cliente
		$consulta = "Select descuento from Cliente_familia_articulos , Articulos
			where Articulos.id_articulo = $id_art and Cliente_familia_articulos.id_empresa = $usuario[id]
			and Cliente_familia_articulos.id_cliente = $id_cliente
			and Cliente_familia_articulos.id_familia = Articulos.id_familia";
		$resul2 = $oDb->query($consulta);
		$row2 = $oDb->fetch_array($resul2);
		if($row2['descuento'] > 0){
			return $row2['descuento'] . "% Cli/Fam";
		}
	}//FIN DE DEESCUENTOS ESPECIFICOS DE CLIENTE
	//Promociones u ofertas
	$consulta = "Select descuento , monto , oferta , nombre from Promociones where id_articulo = $id_art AND ".
		"id_empresa = $usuario[id]";
	$consulta = "Select id_promocion, cantidad, descuento , monto , oferta , nombre  ".
		"FROM Promociones ".
		"WHERE id_articulo = $id_art and id_empresa = $usuario[id] ".
		"AND fecha_inicio < NOW() AND (fecha_fin>NOW() OR fecha_fin IS NULL OR fecha_fin=0) ";
	$resul3 = $oDb->query($consulta);
	$row3 = $oDb->fetch_array($resul3);
	if($row3['oferta'] == 1){
		//ofertas
		if($row3['descuento'] > 0)
			return  $row3['descuento'] . "% Art >=$row3[cantidad]";
		elseif($row3['monto'] > 0)
			return  $row3['monto'] . " " .  $rowd['leyenda'] .  " Art >=$row3[cantidad]";
	}
	elseif($row3['nombre'] !=  "") //Promociones
		return  $row3['nombre']." >=$row3[cantidad]";

	$consulta = "Select descuento from Descuento_familia , Articulos
		where Articulos.id_articulo = $id_art and
		Descuento_familia.id_empresa = $usuario[id] and
		Descuento_familia.id_familia = Articulos.id_familia";
	$resul8 = $oDb->query($consulta);
	$row8 = $oDb->fetch_array($resul8);
	if($row8['descuento'] > 0){
		return $row8['descuento'] . "% Fam";
	}

	if ((int)$aDatos["Empresas_articulos.unidades_bulto"]>1) {
		if ((int)$aDatos['Empresas_articulos.dto_vol']) {
			if ($aDatos['Empresas_articulos.dto_vol'] == (int)$aDatos['Empresas_articulos.dto_vol'])
				$aDatos['Empresas_articulos.dto_vol'] = (int)$aDatos['Empresas_articulos.dto_vol'];
			if (!(int)$aDatos['Empresas_articulos.dto_vol_bultos'])
				$aDatos['Empresas_articulos.dto_vol_bultos'] = NULL;
			$retval = $aDatos['Empresas_articulos.dto_vol'].'% X '.
				$aDatos['Empresas_articulos.dto_vol_bultos'].' Bto';
		} elseif ((int)$aDatos['Empresas.dto_gnrl_vol']) {
			if ($aDatos['Empresas.dto_gnrl_vol'] == (int)$aDatos['Empresas.dto_gnrl_vol'])
				$aDatos['Empresas.dto_gnrl_vol'] = (int)$aDatos['Empresas.dto_gnrl_vol'];
			if (!(int)$aDatos['Empresas.dto_gnrl_vol_bultos'])
				$aDatos['Empresas.dto_gnrl_vol_bultos'] = NULL;
			$retval = $aDatos['Empresas.dto_gnrl_vol'].'% X '.
				$aDatos['Empresas.dto_gnrl_vol_bultos'].' Bto';
		} else $retval = NULL;
		return $retval;
	}

}

function es_pedido(&$Sesion){
	$id_p = $Sesion->get_var("identificador_pedido");
	return $Sesion->get_var("es_pedido") == 1 or isset($id_p) ;
}

function modificable(&$Sesion,&$aData) {
	if (!(float)$aData['precio']) return 0;
	else return 1;
}

?>
