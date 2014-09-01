<?php

/** funciones de carrito de la compra
global  $Anyadir;
global $array_numero;
global $array_bultos;
global $borrar_articulos;

Acciones : Anyadir articulos o bultos al carrito

*/
function pre_hacer_pedido_compra(&$Sesion) {
	$id_proveedor_pedido=$Sesion->fetchVar('id_proveedor_pedido','POST GET');
	$id_proveedor=$Sesion->fetchVar('id_proveedor','GET POST SESSION');
	$pedido_proveedor=$Sesion->fetchVar('pedido_proveedor','POST');//por si viene de algun sitio
	$identificador_pedido=$Sesion->fetchVar('identificador_pedido','POST');//de donde viene

	$Anyadir=$Sesion->fetchVar('Anyadir','POST');

	$array=$Sesion->fetchVar('array','POST',NULL,'classDocumentDetail');
	$array_numero = $array['cantidad'];

	$array_bultos=$Sesion->fetchVar('array_bultos','POST',NULL,'classDocumentDetail');
	$array_ids=$Sesion->fetchVar('array_ids','POST');

	$borrar_articulos=$Sesion->fetchVar('borrar_articulos','POST');
	$vaciar_pedido=$Sesion->fetchVar('vaciar_pedido','GET');
	$repo=$Sesion->fetchVar('repo','POST');
	$nuevo=$Sesion->fetchVar('nuevo','GET POST');
	$pedido=$Sesion->fetchVar('pedido','GET POST');
	$factura=$Sesion->fetchVar('factura','GET POST');
	if (!empty($factura)) $abono=$Sesion->fetchVar('abono','POST GET');
	$presupuesto=$Sesion->fetchVar('presupuesto','GET POST');
	$proforma=$Sesion->fetchVar('proforma','GET POST');

	$tipo=$Sesion->fetchVar('tipo','GET POST');
	$pedidos_tipo_proveedor=$Sesion->fetchVar('pedidos_tipo_proveedor','POST');

	if (!is_numeric($id_proveedor_pedido) AND is_numeric($id_proveedor)) $id_proveedor_pedido = $id_proveedor;

	if(is_numeric($id_proveedor_pedido)) {
		$Sesion->set_var("id_proveedor_promocion", $id_proveedor_pedido);
		$Sesion->set_var("id_proveedor", $id_proveedor_pedido);
	}

	if(isset($identificador_pedido)){
		$Sesion->set_var("identificador_pedido", $identificador_pedido);
        //meter el proveedor ke nos lo cargamos al confirmar el pedido
        //pero etamos añadiendo
	} elseif (!isset($id_proveedor_pedido)) {
		$id_proveedor_pedido = $Sesion->get_var('id_proveedor_promocion');
	}

	$usuario = identifica_usuarios($Sesion);
	$id_emp = $usuario['id'];
	$oDb = $Sesion->get_db('data');

	// subseccion de envio de la seleccion contenida en la cesta
	$returnlink = $Sesion->fetchVar('returnlink','GET');
	$cestasendto = $Sesion->get_var('_cesta_sendto');
	if (!empty($returnlink)) {
		$Sesion->set_var('_cesta_sendto','?seccion='.$returnlink,'SUBSECCION');
		// debug("retlink = $returnlink - ".$Sesion->get_var('_cesta_sendto'));
	} elseif (empty($cestasendto)) {
		$Sesion->set_var('_cesta_sendto','?seccion=confirmar_pedido_compra','SUBSECCION');
	}

	$confirm_formto = $Sesion->fetchVar('_confirm_form_to','GET POST SESSION');
	if (!empty($confirm_formto)) $Sesion->set_var('send_form_to',$confirm_formto,'SECCION');

	$sessdocvar = $Sesion->get_var('__document_iface_varname');
	if ($nuevo) {
		$vaciar_pedido = 1;
		$keep_id = false;
		$tmpdoc = $Sesion->get_var('__document_iface_varname');
		$recDoc = $Sesion->get_var($tmpdoc);
		if (is_a($recDoc,'Document') AND $recDoc->getMode() & inmPed_COMPRA ) $id_proveedor_rec = $recDoc->get_issuer_id();
		$tmpdoc = NULL;
		$docvar = 'oPedido_en_curso';
		$Sesion->set_var('__document_iface_varname',$docvar);
		$Sesion->set_var('link_pedido_en_curso','hacer_pedido','NOEXPIRE');
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
		$Sesion->perror(NULL,'BBDD','Imposible obtener el conector');
		return $Sesion->perror_plt('?logout=1');
	}

	if ($tipo == 1 AND is_array($pedidos_tipo_proveedor)) $oPedido = NULL;

	$id_proveedor = id_entidad($Sesion,'id_proveedor',$id_proveedor);

	if (is_object($oPedido) AND empty($pedido) AND empty($factura)) $class_name = get_class($oPedido);
	elseif (!empty($pedido) AND $pedido) $class_name = 'Order';
	elseif (!empty($factura) AND $factura) $class_name = 'Invoice';
	elseif ( (!empty($presupuesto) AND $presupuesto) OR (!empty($proforma) AND $proforma) ) $class_name = 'Budget';
	if (empty($class_name)) $class_name = 'Order';

	if ((int)$vaciar_pedido AND is_object($oPedido)) {
		if (!isset($id_proveedor_pedido)) {
			if ($oPedido->debug) debug("Vaciando el pedido y recogiendo sus datos");
			$aPed = $oPedido->get_info();
			if (is_numeric($aPed['id_proveedor']))
				$id_proveedor = $aPed['id_proveedor'];
			if (is_numeric($aPed['id_empresa']))
				$id_emp = $aPed['id_empresa'];
			$id_tarifa = $aPed['id_tarifa'];
			if ($keep_id) $id_ped = (int)$oPedido->getId();
		} else $id_proveedor = $id_proveedor_pedido;
		if ($oPedido->debug) debug("reeeeset de pedido");
		$oPedido = NULL;

		$Sesion->unset_var($docvar);
	}

	if (!is_object($oPedido)) {
		if (!strcasecmp($usuario['desktop_name'],'proveedor')) {
			$id_proveedor = $usuario['valor'];
			$Sesion->set_var("id_proveedor_pedido",$id_proveedor,'SECCION');
		} elseif (isset($id_proveedor)) {
			$id_proveedor_sesion = $id_proveedor;
			$Sesion->set_var("id_proveedor_pedido", $id_proveedor,'SECCION');
		} elseif (!empty($id_proveedor_rec)) {
			$id_proveedor = $id_proveedor_rec;
		} elseif (!empty($id_proveedor_sesion) AND is_numeric($id_proveedor_sesion)) {
			$id_proveedor = $id_proveedor_sesion;
		} else {
			$Sesion->lcMessage('LCS_NOID',array('entidad' => 'Proveedores'),IM_WARNING);
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

		$oPedido = new $class_name ($Sesion->App_Name,'data',inmPed_COMPRA,$tipo_doc);
		$base_ok = 0;
		if ($tipo == 1 AND is_array($pedidos_tipo_proveedor)) {
			foreach ($pedidos_tipo_proveedor as $idp => $val) {
				$oPedido_base = new $class_name ($Sesion->App_Name,'data',inmPed_COMPRA,$tipo_doc);
				if (!$oPedido_base->dbfill($idp)) {
			  		$Sesion->lcMessage('ORDER_DBFILL',array('id' => $idp),IM_WARNING);
					$base_ok = 0;
					break;
				}
				if (!$base_ok) {
					$id_pv = $oPedido_base->get_issuer_id();
					$id_emp = $oPedido_base->get_reciever_id();
					if (!strcasecmp($usuario['desktop_name'],'Agentes')) $id_ag = $usuario['valor'];
					$oPedido->set_reciever($id_emp);
					$oPedido->set_issuer($id_pv);
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
			// debug("Es factura y abono... asi que... ".$id_fra);
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
				if ($oPedido->debug) debug("Emisor $id_proveedor");
				$oPedido->set_issuer($id_proveedor);
				if ($oPedido->debug) debug("receptor $id_emp");
				$oPedido->set_reciever($id_emp);
				if (!strcasecmp($usuario['desktop_name'],'Agentes')) $id_agente = $usuario['valor'];
				if (is_numeric($id_agente)) $oPedido->set_agent($id_agente);
			} else {
				if (!$oPedido->dbfill($id_ped)) {
					if ($oPedido->debug) debug("No se ha podido rellenar los datos provenientes del pedido $id_ped");
					return NULL;
				}
				for ($idx=$oPedido->first_detail(); $idx; $idx=$oPedido->next_detail())
					$oPedido->del_detail($idx);
			}
		}
	} else {
		$id_proveedor = $oPedido->get_issuer_id();
		if ($oPedido->debug) debug("oPedido es un objeto! proveedor = $id_proveedor; N detalles = ".sizeof($oPedido->_aDetalles));
	}

	if (is_object($oPedido)) {
		if (!strcasecmp(get_class($oPedido),'Order')) {
			$Sesion->set_var('es_pedido',1,'SECCION');
			$Sesion->unset_var('es_factura');
			$Sesion->unset_var('es_proforma');
			$Sesion->unset_var('es_presupuesto');
		} elseif(!strcasecmp(get_class($oPedido),'Invoice')) { 
			$Sesion->set_var('es_factura',1,'SECCION');
			$Sesion->unset_var('es_pedido');
			$Sesion->unset_var('es_proforma');
			$Sesion->unset_var('es_presupuesto');
		} elseif(!strcasecmp(get_class($oPedido),'Budget')) { 
			if ($proforma OR $oPedido->isProforma() ) {
				$Sesion->set_var('es_proforma',1,'SECCION');
				$Sesion->unset_var('es_presupuesto');
				$Sesion->unset_var('es_pedido');
				$Sesion->unset_var('es_factura');
				if (!$oPedido->isProforma()) $oPedido->toProforma();
			} else {
				$Sesion->set_var('es_presupuesto',1,'SECCION');
				$Sesion->unset_var('es_proforma');
				$Sesion->unset_var('es_pedido');
				$Sesion->unset_var('es_factura');
			}
		}
	}

	// Referencias HAbituales del Cliente:

	/** **
	$id_prov = $Sesion->get_var("id_proveedor_pedido");
	if (!empty($id_prov) AND $id_prov != $id_proveedor)
		$id_prov = $id_proveedor;
		/** **/

	if ($Sesion->verifyVar('repo',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('repo',IKRN_VAR_CRC_AUTHED)) {
		if (is_array($repo)) {
			$fini = wol_db::formatear_fecha($repo['fecha_inicio'],true);
			if ( $fini != 'NULL' ) {
				$tmp = wol_db::formatear_fecha($repo['fecha_fin'],FALSE);
				if ($tmp == 'NULL') $ffin = 'NOW()';
				else $ffin = wol_db::formatear_fecha($repo['fecha_fin'],TRUE);

				$solores = (int)$repo['residuales'];
				$sinres = (int)$repo['sin_residuales'];
				$cons = "SELECT t1.id_articulo,SUM(t1.cantidad) ".
					  "FROM Lineas_detalle t1, Pedidos t2, Compra_articulos t3, Articulos t4, Empresas_articulos Ea, Marcas t5 ".
					  "WHERE t1.id_pedido=t2.id_pedido AND ".
					  "(t2.id_proveedor = 0 OR t2.id_proveedor IS NULL) AND ".
					  "t1.id_articulo=t3.id_articulo AND ".
					  "t3.id_articulo=t4.id_articulo AND ".
					  "t4.id_articulo=Ea.id_articulo AND ".
					  "t4.id_marca=t5.id_marca AND ".
					  "t3.id_proveedor = $id_proveedor AND t2.fecha >= $fini ".
					  " AND t2.fecha <= $ffin ".
					  " AND Ea.id_empresa = ".$id_emp.
					  " AND Ea.fecha_baja IS NULL ".
					  ( ($sinres) 
						 ? ' AND t2.residual = 0 '
						 : (($solores) 
							 ? ' AND t2.residual=1 '
							 : ' ' )
					  ).
					  "GROUP BY t1.id_articulo ".
					  "ORDER BY t5.nombre,t4.nombre ";
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
	}

	if ($es_reposicion) $Sesion->set_var('es_reposicion',1,'SUBSECCION');
	else $Sesion->unset_var('es_reposicion');
		
	$Sesion->set_var("id_proveedor_pedido", $id_proveedor,'SECCION');
	$Sesion->set_var("id_proveedor_promocion", $id_proveedor,'SECCION');

	if(isset($Anyadir)) {
	//si estamos borrando eliminar
		if ($Sesion->verifyVar('borrar_articulos',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('borrar_articulos',IKRN_VAR_CRC_AUTHED)) {
			if(is_array($borrar_articulos)) {
				// debug("Fixme: borrar_articulos se ha disparado, comprobar en array.");
				foreach($borrar_articulos as $id_articulo)
					unset($array_numero[$id_articulo]);
			}
		}

	//aki se meten los bultos cantidades ¿y paletas ?
		// debug("Vaciar pedido = $vaciar_pedido");

		if (!method_exists($oPedido,'getInstallment') OR !$oPedido->getInstallment()) {
			if ($Sesion->verifyVar('array_bultos',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('array_bultos',IKRN_VAR_CRC_AUTHED)) {
				if (is_array($array_bultos))
					foreach($array_bultos as $idx => $aBCP) {
						if (empty($aBCP) OR !sizeof($aBCP)) continue;
						$id_art = $array_ids[$idx];
						if ($oPedido->debug) debug("localizando bulto $idx ... $id_art (".$array_numero[$idx].")"); 
						if ((int)$aBCP['bultos']) $num = 1;
						elseif ((int)$aBCP['capas']) $num = 2;
						elseif ((int)$aBCP['palets']) $num = 3;
						else $num = 0;
						$idxdet = $oPedido->add_detail($id_art,$array_numero[$idx],$num);
					}

					// Para reconstruir indices de servicios disponibles
					$oPedido->_build_indexes();
			}

			if ($Sesion->verifyVar('array_numero',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('array_numero',IKRN_VAR_CRC_AUTHED)) {
				if (is_array($array_numero))
					foreach($array_numero as $idx => $num) {
						if (!is_numeric($num) OR ($num==0 AND !$es_reposicion)) continue;
						if (!empty($array_bultos[$idx])) continue;

						$id_art = $array_ids[$idx];
						if ($oPedido->debug) 
							debug("localizando cantidad idx $idx ... $id_art ($num)"); 
						if (!isset($array_bultos[$idx]) OR empty($array_bultos[$idx])) {
							$idxdet = $oPedido->add_detail($id_art,$num);
						}
					}
				// Para reconstruir indices de servicios disponibles
				$oPedido->_build_indexes();
			}
		}
	}

	$Sesion->set_var($docvar,$oPedido);

}//fin del precode

function es_pedido(&$Sesion){
	$id_p = $Sesion->get_var("identificador_pedido");
	return ($Sesion->get_var("es_pedido") == 1) or isset($id_p) ;
}
function es_presupuesto(&$Sesion){
	$id_p = $Sesion->get_var("identificador_presupuesto");
	return $Sesion->get_var("es_presupuesto") == 1 or isset($id_p) ;
}

function cf_articulos_compra(&$Sesion,&$aDatos) {

	if ((int)$aDatos['Compra_articulos.descuento']) {
		$retval = $aDatos['Compra_articulos.descuento'].' % ';
	} elseif ((int)$aDatos["Empresas_articulos.unidades_bulto"]>1) {
		if (is_numeric($aDatos['Compra_articulos.dto_vol'])) {
			if ($aDatos['Compra_articulos.dto_vol'] == (int)$aDatos['Compra_articulos.dto_vol'])
				$aDatos['Compra_articulos.dto_vol'] = (int)$aDatos['Compra_articulos.dto_vol'];
			if (!(int)$aDatos['Compra_articulos.dto_vol_bultos'])
				$aDatos['Compra_articulos.dto_vol_bultos'] = NULL;
			$retval = $aDatos['Compra_articulos.dto_vol'].'% X '.
						 $aDatos['Compra_articulos.dto_vol_bultos'].' Bto';
		} else {
			if ((int)$aDatos['Proveedores.dto_gnrl_vol_bulto']) {
				if ($aDatos['Proveedores.dto_gnrl_vol_bulto'] == (int)$aDatos['Proveedores.dto_gnrl_vol_bulto'])
					$aDatos['Proveedores.dto_gnrl_vol_bulto'] = (int)$aDatos['Proveedores.dto_gnrl_vol_bulto'];
				if (!(int)$aDatos['Proveedores.dto_gnrl_vol_bulto_uds'])
					$aDatos['Proveedores.dto_gnrl_vol_bulto_uds'] = NULL;
				$retval = $aDatos['Proveedores.dto_gnrl_vol_bulto'].'% X '.
							 $aDatos['Proveedores.dto_gnrl_vol_bulto_uds'].' Bto';
			} elseif ((int)$aDatos['Proveedores.dto_gnrl_vol_capa']) {
				if ($aDatos['Proveedores.dto_gnrl_vol_capa'] == (int)$aDatos['Proveedores.dto_gnrl_vol_capa'])
					$aDatos['Proveedores.dto_gnrl_vol_capa'] = (int)$aDatos['Proveedores.dto_gnrl_vol_bulto'];
				if (!(int)$aDatos['Proveedores.dto_gnrl_vol_capa_uds'])
					$aDatos['Proveedores.dto_gnrl_vol_capa_uds'] = NULL;
				$retval = $aDatos['Proveedores.dto_gnrl_vol_capa'].'% X '.
							 $aDatos['Proveedores.dto_gnrl_vol_capa_uds'].' Cpa';
			} elseif ((int)$aDatos['Proveedores.dto_gnrl_vol_palet']) {
				if ($aDatos['Proveedores.dto_gnrl_vol_palet'] == (int)$aDatos['Proveedores.dto_gnrl_vol_palet'])
					$aDatos['Proveedores.dto_gnrl_vol_palet'] = (int)$aDatos['Proveedores.dto_gnrl_vol_palet'];
				if (!(int)$aDatos['Proveedores.dto_gnrl_vol_palet_uds'])
					$aDatos['Proveedores.dto_gnrl_vol_palet_uds'] = NULL;
				$retval = $aDatos['Proveedores.dto_gnrl_vol_palet'].'% X '.
							 $aDatos['Proveedores.dto_gnrl_vol_palet_uds'].' Plt';
			} else $retval = NULL;
		}
	}
	if (!empty($retval)) $aDatos['descuento'] = $retval;
	$retval = NULL;

	if (is_numeric($aDatos['Empresas_articulos.unidades_bulto'])
			AND (int)$aDatos['Empresas_articulos.unidades_bulto'] 
					== $aDatos['Empresas_articulos.unidades_bulto'] ) {
		$retval = (int)$aDatos['Empresas_articulos.unidades_bulto'];
	} else $retval = NULL;
	if (!empty($retval)) $aDatos['Empresas_articulos.unidades_bulto'] = $retval;

	if (is_numeric($aDatos['Compra_articulos.precio'])
			AND (int)$aDatos['Compra_articulos.precio'] 
					== $aDatos['Compra_articulos.precio'] ) {
		$retval = (int)$aDatos['Compra_articulos.precio'].' ';
	} else $retval = NULL;
	if (!empty($retval)) $aDatos['Compra_articulos.precio'] = $retval;

	return 1;
}

function modificable(&$Sesion,&$aData) {
	if (!(float)$aData['precio']) return 0;
	else return 1;
}

?>
