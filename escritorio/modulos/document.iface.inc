<?php
/*****************************************************************
** Aplicacion diseñada para Web On Line Studios S.L.            **
**    Todos los derechos reservados.                            **
**    Este programa se podra modificar con el consentimiento    **
**    de Web On Line Studios S.L. Su distribucion queda         **
**    limitada a Web On Line Studios S.L.		        				 **
**    Las posibles modificaciones sobre esta aplicacion ajenas  **
**    a Web On Line Studios S.L. deberan ser consultadas y 		 **
**    enviadas a Web On Line Studios en C/Alcala 18 3º Izda,    **
**    28014 Madrid. Cualquier otra operacion realizada sobre 	 **
**    esta aplicacion queda limitada a Web On Line Studios S.L. **
**    infringiendo en delito cualquier otra entidad que asi lo  **
**    hiciese.       														 **
**																					 **
** Para mas informacion referente a la licencia de esta 			 **
**    aplicacion referirse al fichero LICENCIA. Caso de que Ud. **
**    no tenga una copia de este fichero, contacte con Web On 	 **
**    Line Studios S.L. para recibir una copia del mismo			 **
**							        												 **
** Informacion de Contacto				        							 **
**    Josafat Moragrega Fernandez			        					 **
**    Engineering					        									 **
**    Director Tecnico 					        							 **
**    tite@wolstudios.com													 **
**    C/Alcala 18 3º Izda, 28014 Madrid, España		        		 **
**																					 **
** 				(c) Web On Line Studios S.L. 							 **
**                                                              **
******************************************************************
*****************************************************************/

/** Acuerdate de documentar esta clase **/

/****************************************************************
  Futuras Versiones:
  	
  - En futuras versiones esta clase extendera una clase 'carrito'. Clase destinada a contener lineas de detalle,
	bien sea para un pedido, una factura, un albaran, un tpv, un ticket etc... Esta clase padre tendras todas las
	funcionalidades actuales aplicables sobre las lineas de detalle (comprobar/calcular descuentos, impuestos etc..)
	
	- Esta clase debera incorporar unos cuantos modos que le permitan tener distintos niveles de impacto sobre la db.
	de tal forma que sea soportable la carga de instaciar varias veces esta clase en modos sin 'carrito' y ligth
	
	- Tendremos una clase contenedora para varios pedidos, facturas, albaranes en su modo light.
*****************************************************************/
/** Defines: **/


/******* Funciones nodb para Obtener los datos del oPedido_en_curso ***********/
function nodb_order_data(&$Sesion,$block_name) {
	static $aBlocks;
	static $obj_var;

	if (empty($block_name)) $block_name = 0;
	if (is_array($aBlocks[$block_name]) AND sizeof($aBlocks[$block_name])) {
		$done = $aBlocks[$block_name]['done'];
		$reset = $aBlocks[$block_name]['reset'];
	}
	if (empty($obj_var)) {
	   $docvar = $Sesion->get_var('__document_iface_varname');
	   if (empty($docvar)) $docvar = 'oPedido_en_curso';
	   $obj_var = $docvar;
	}

	if (!$done OR $reset) {
		$done = 1;
		$oPedido = $Sesion->get_var($obj_var);
		if (!is_object($oPedido)) return NULL;
		$aRetVal = $oPedido->get_info();
		if (empty($aRetVal['observaciones'])) $aRetVal['observaciones'] = "";
		if (method_exists($oPedido,'get_agent')) {
		   $aAg = $oPedido->get_agent();
		   $aRetVal['nombre_agente'] = $aAg['nombre'];
		}
		$aDiv = $oPedido->get_currency();
		$aRetVal['nombre_divisa'] = $aDiv['nombre_divisa'];

		// Estado del pedido:
		if (method_exists($oPedido,'get_deliveries')) $aAlb = $oPedido->get_deliveries();
		else $aAlb = NULL;
		$parcial = 0;
		if (is_array($aAlb)) 
			foreach($aAlb as $alb) {
				if ((int)$alb['confirmacion']) {
					if (isset($last_status) AND $last_status != 3) $parcial =1;
					if ((int)$last_status <= 4) {
						$estadio = 'Entregado';
						$last_status = 3;
					}
				} elseif ((int)$alb['enviado']) {
					if (isset($last_status) AND $last_status != 2) $parcial =1;
					if ((int)$last_status <= 3) {
						$estadio = 'Enviado';
						$last_status = 2;
					}
				} elseif ((int)$alb['preparado']) {
					if (isset($last_status) AND $last_status != 1) $parcial =1;
					if ((int)$last_status <= 2) {
						$estadio = 'Preparado';
						$last_status = 1;
					}
				} else {
					if (isset($last_status) AND (int)$last_status != 0) $parcial =1;
					if (!(int)$last_status) {
						$estadio = 'En Preparacion';
						$last_status = 0;
					}
				}
			}
		else $estadio = 'En Preparacion';
		$estado = ( ((int)$parcial) ? 'Parcialmente ' : '').$estadio;
		$aRetVal['descripcion_estado'] = $estado;
		$aRetVal['numero_estado'] = $last_status;

		if (is_array($oPedido->_aServicios) AND sizeof($oPedido->_aServicios) AND method_exists($oPedido,'set_detail_contract') )
			$aRetVal['possible_contracts'] = 1;

		$reset = 0;
	} else {
		$reset = 1;
		$aRetVal = NULL;
	}
	$aBlocks[$block_name]['done'] = $done;
	$aBlocks[$block_name]['reset'] = $reset;
	return $aRetVal;
}

function nodb_currency_data(&$Sesion,$block_name) {
	static $aBlocks;
	static $obj_var;

	if (empty($block_name)) $block_name = 0;
	if (is_array($aBlocks[$block_name]) AND sizeof($aBlocks[$block_name])) {
		$done = $aBlocks[$block_name]['done'];
		$reset = $aBlocks[$block_name]['reset'];
	}
	if (empty($obj_var)) {
	   $docvar = $Sesion->get_var('__document_iface_varname');
	   if (empty($docvar)) $docvar = 'oPedido_en_curso';
	   $obj_var = $docvar;
	}

	if (!$done OR $reset) {
		$done = 1;
		$oPedido = $Sesion->get_var($obj_var);
		if (!is_object($oPedido)) return NULL;
		$aRetVal = $oPedido->get_currency();
		$reset = 0;
	} else {
		$reset = 1;
		$aRetVal = NULL;
	}
	$aBlocks[$block_name]['done'] = $done;
	$aBlocks[$block_name]['reset'] = $reset;
	return $aRetVal;
}

function nodb_issuer_data(&$Sesion,$block_name) {
	static $aBlocks;
	static $obj_var;

	if (empty($block_name)) $block_name = 0;
	if (is_array($aBlocks[$block_name]) AND sizeof($aBlocks[$block_name])) {
		$done = $aBlocks[$block_name]['done'];
		$reset = $aBlocks[$block_name]['reset'];
	}
	if (empty($obj_var)) {
	   $docvar = $Sesion->get_var('__document_iface_varname');
	   if (empty($docvar)) $docvar = 'oPedido_en_curso';
	   $obj_var = $docvar;
	}

	if (!$done OR $reset) {
		$done = 1;
		$oPedido = $Sesion->get_var($obj_var);
		if (!is_object($oPedido)) return NULL;
		$aRetVal = $oPedido->get_issuer_info();
		$reset = 0;
	} else {
		$reset = 1;
		$aRetVal = NULL;
	}
	$aBlocks[$block_name]['done'] = $done;
	$aBlocks[$block_name]['reset'] = $reset;
	return $aRetVal;
}

function nodb_reciever_data(&$Sesion,$block_name) {
	static $aBlocks;
	static $obj_var;

	if (empty($block_name)) $block_name = 0;
	if (is_array($aBlocks[$block_name]) AND sizeof($aBlocks[$block_name])) {
		$done = $aBlocks[$block_name]['done'];
		$reset = $aBlocks[$block_name]['reset'];
	}
	if (empty($obj_var)) {
	   $docvar = $Sesion->get_var('__document_iface_varname');
	   if (empty($docvar)) $docvar = 'oPedido_en_curso';
	   $obj_var = $docvar;
	}

	if (!$done OR $reset) {
		$done = 1;
		$oPedido = $Sesion->get_var($obj_var);
		if (!is_object($oPedido)) return NULL;
		$aRetVal = $oPedido->get_reciever_info();
		if (method_exists($oPedido,'get_reciever_address')) $aTmp = $oPedido->get_reciever_address(false);
		else $aTmp = NULL;
		if (is_array($aTmp) AND sizeof($aTmp) == 1) {
			$aTmp = $aTmp[0];
			if (is_array($aTmp))
			foreach ($aTmp as $campo => $valor) {
				if (is_array($valor)) break;
				$aRetVal["direccion_".$campo] = $valor;
			}
		}
		$reset = 0;
	} else {
		$reset = 1;
		$aRetVal = NULL;
	}
	$aBlocks[$block_name]['done'] = $done;
	$aBlocks[$block_name]['reset'] = $reset;
	return $aRetVal;
}

/** 
  * funcion nodb para la obtencion de los detalles de la clase documento indicada en __document_iface_varname
  */
function nodb_order_details(&$Sesion,$block_name) {
	static $aBlocks;
	static $obj_var;

	if (empty($block_name)) $block_name = 0;
	if (is_array($aBlocks[$block_name]) AND sizeof($aBlocks[$block_name])) {
		$not_first = $aBlocks[$block_name]['done'];
		$reset = $aBlocks[$block_name]['reset'];
	}
	if (empty($obj_var)) {
	   $docvar = $Sesion->get_var('__document_iface_varname');
	   if (empty($docvar)) $docvar = 'oPedido_en_curso';
	   $obj_var = $docvar;
	}

	$oPedido = $Sesion->get_var($obj_var);
	if (!is_object($oPedido)) return NULL;

	if (!$not_first OR $reset) {
		$idxdet = $oPedido->first_detail();
		$not_first = 1;
	} else $idxdet = $oPedido->next_detail();

	if (!isset($idxdet)) {
		$reset = 1;
		$aArt = NULL;
	} else { 
		$reset = 0;
		$Sesion->set_var($obj_var,$oPedido);

		$aDiv = $oPedido->get_currency();
		$aArt = $oPedido->get_detail($idxdet);
		$aArt['idx_detalle'] = $idxdet;
		$aArt['leyenda_divisa'] = $aDiv['leyenda'];
		// print_r($aArt);
		$bultos = $oPedido->get_quantity($idxdet,1); 
		$capas = $oPedido->get_quantity($idxdet,2); 
		$palets = $oPedido->get_quantity($idxdet,3); 
		$cant = $oPedido->get_quantity($idxdet);
		if (!empty($palets) AND $palets == (int)$palets) {
			$aArt['palets'] = $palets;
			$aArt['cantidad_pack'] = $palets;
		} elseif (!empty($capas) AND $capas == (int)$capas) {
			$aArt['capas'] = $capas;
			$aArt['cantidad_pack'] = $capas;
		} elseif (!empty($bultos) AND $bultos == (int)$bultos) {
			$aArt['bultos'] = $bultos;
			$aArt['cantidad_pack'] = $bultos;
		} else $aArt['cantidad_pack'] = $aArt['cantidad'];

		$aArt['cantidad_total'] = $aArt['cantidad'];
		$aArt['precio_articulo'] = $aArt['precio'] = $oPedido->get_price($idxdet);

		$aTmp = $oPedido->getArticleContracts($aArt['id_articulo']);
		if (is_array($aTmp) AND sizeof($aTmp)) $aArt['available_contracts'] = 1;
	}

	$aBlocks[$block_name]['done'] = $not_first;
	$aBlocks[$block_name]['reset'] = $reset;
	return $aArt;
}

function nodb_detail_contracts(&$Sesion,$block_name) {
	static $aBlocks;
	static $obj_var;

	if (empty($block_name)) $block_name = 0;
	if (empty($obj_var)) {
	   $docvar = $Sesion->get_var('__document_iface_varname');
	   if (empty($docvar)) $docvar = 'oPedido_en_curso';
	   $obj_var = $docvar;
	}

	if (is_array($aBlocks[$block_name]) AND sizeof($aBlocks[$block_name])) {
		$first = $aBlocks[$block_name]['done'];
		$reset = $aBlocks[$block_name]['reset'];
		$aServ = $aBlocks[$block_name]['extras'];
	}
	if (!isset($first) OR $reset) {
		$oPedido = $Sesion->get_var($obj_var);
		if (!is_object($oPedido)) return NULL;
		$aServ = $oPedido->getArticleContracts($oPedido->getDetailAttribute(NULL,'id_articulo'));
		$first = 1;
		$reset = 0;
	}
	if (!is_array($aServ) OR empty($aServ)) {
		$reset = 1;
		$aRetVal = NULL;
	} else {
		$aS = array_pop($aServ);
		foreach ($aS as $campo => $valor)
			$aRetVal[$campo] = $valor;
	}
	
	$aBlocks[$block_name]['done'] = $first;
	$aBlocks[$block_name]['reset'] = $reset;
	$aBlocks[$block_name]['extras'] = $aServ;
	return $aRetVal;
}

function nodb_detail_productids(&$Sesion,$block_name) {
	static $aBlocks;
	static $obj_var;

	if (empty($block_name)) $block_name = 0;
	if (empty($obj_var)) {
	   $docvar = $Sesion->get_var('__document_iface_varname');
	   if (empty($docvar)) $docvar = 'oPedido_en_curso';
	   $obj_var = $docvar;
	}

	if (is_array($aBlocks[$block_name]) AND sizeof($aBlocks[$block_name])) {
		$first = $aBlocks[$block_name]['done'];
		$reset = $aBlocks[$block_name]['reset'];
		$aServ = $aBlocks[$block_name]['extras'];
	}
	if (!isset($first) OR $reset) {
		$aCfg = $Sesion->get_var('_aAppConf');
		if (!(int)$aCfg['print_invoice_productids']) return NULL;
		$oPedido = $Sesion->get_var($obj_var);
		if (!is_object($oPedido)) return NULL;
	
		if (method_exists($oPedido,'getDeliveryOrders')) {
			$aAlb = $oPedido->getDeliveryOrders();
			if (is_array($aAlb) AND sizeof($aAlb)) {
				$id_det = $oPedido->getDetailAttribute($oPedido->current_detail(),'id_detalle');
				$aAL = $oPedido->getDeliveryFromDbDet($id_det);
				if (sizeof($aAL))
					foreach ($aAL as $ida) {
						if (!is_array($aServ)) $aServ=array();
						if (is_array($aAlb[$ida]['detalles'][$id_det]))
							foreach ($aAlb[$ida]['detalles'][$id_det] as $tmpidx => $aDet)
								if ($aDet['cantidad'] != 0) array_push($aServ,$aDet);
					}
			}
		}
		$first = 1;
		$reset = 0;
	}
	if (!is_array($aServ) OR empty($aServ)) {
		$reset = 1;
		$aRetVal = NULL;
	} else {
		$aS = array_pop($aServ);
		foreach ($aS as $campo => $valor)
			$aRetVal[$campo] = $valor;
	}
	
	$aBlocks[$block_name]['done'] = $first;
	$aBlocks[$block_name]['reset'] = $reset;
	$aBlocks[$block_name]['extras'] = $aServ;
	return $aRetVal;
}

/** calcula los ivas en funcion de las lineas de detalle ke nos llegan de nodb_confirmar_pedido */
function nodb_taxes_detail(&$Sesion,$block_name) {
	static $aBlocks;
	static $obj_var;

	if (empty($block_name)) $block_name = 0;
	if (empty($obj_var)) {
	   $docvar = $Sesion->get_var('__document_iface_varname');
	   if (empty($docvar)) $docvar = 'oPedido_en_curso';
	   $obj_var = $docvar;
	}

	if (is_array($aBlocks[$block_name]) AND sizeof($aBlocks[$block_name])) {
		$first = $aBlocks[$block_name]['done'];
		$reset = $aBlocks[$block_name]['reset'];
		$aIVAs = $aBlocks[$block_name]['extras'];
		$aDiv = $aBlocks[$block_name]['divisa'];
	}
	if (!isset($first) OR $reset) {
		$oPedido = $Sesion->get_var($obj_var);
		if (!is_object($oPedido)) return NULL;
		$aTotIva = $oPedido->get_taxes();
		$aIVAs = $aTotIva['detalle'];
		$aDiv = $oPedido->get_currency();
		$first = 1;
		$reset = 0;
	}
	if (!is_array($aIVAs) OR empty($aIVAs)) {
		$reset = 1;
		$aRetVal = NULL;
	} else {
		$aIva = array_pop($aIVAs);
		$aRetVal['porcentaje'] = $aIva['porciento'] ;
		$aRetVal['porcentaje_recargo_equivalente'] = $aIva['recargo_eq'];
		$aRetVal['recargo_iva'] = $aIva['total_iva'];
		$aRetVal['recargo_equivalente'] = $aIva['total_recargo'];
		$aRetVal['base_imponible'] = $aIva['base_imponible'];
		$aRetVal['leyenda_divisa'] = $aDiv['leyenda'];
	}
	
	$aBlocks[$block_name]['done'] = $first;
	$aBlocks[$block_name]['reset'] = $reset;
	$aBlocks[$block_name]['extras'] = $aIVAs;
	$aBlocks[$block_name]['divisa'] = $aDiv;
	return $aRetVal;
}

/** calcula los descuentos en funcion de las lineas de detalle ke nos llegan de nodb_confirmar_pedido y detalles IVA*/
function nodb_discounts_detail(&$Sesion,$block_name) {
	static $aBlocks;
	static $obj_var;

	if (empty($block_name)) $block_name = 0;
	if (is_array($aBlocks[$block_name]) AND sizeof($aBlocks[$block_name])) {
		$first = $aBlocks[$block_name]['done'];
		$reset = $aBlocks[$block_name]['reset'];
		$aDtos = $aBlocks[$block_name]['extras'];
		$aDiv = $aBlocks[$block_name]['divisa'];
	}
	if (empty($obj_var)) {
	   $docvar = $Sesion->get_var('__document_iface_varname');
	   if (empty($docvar)) $docvar = 'oPedido_en_curso';
	   $obj_var = $docvar;
	}

	if (!isset($first) OR $reset) {
		$oPedido = $Sesion->get_var($obj_var);
		if (!is_object($oPedido)) return NULL;
		$aTotDtos = $oPedido->get_discounts();
		$aDtos = $aTotDtos['detalle'];
		$aDiv = $oPedido->get_currency();
		if (!is_array($aDtos) OR empty($aDtos)) return NULL;
		$first = 1;
		$reset = 0;
	}
	if (!is_array($aDtos) OR !sizeof($aDtos)) {
		$reset = 1;
		return NULL;
	}
	$aDto = array_shift($aDtos);
	$aRetVal['base_imponible'] = $aDto['base_imponible'] ;
	$aRetVal['descuento'] = $aDto['descuento'];
	$aRetVal['importe'] = $aDto['importe'];
	$aRetVal['leyenda_divisa'] = $aDiv['leyenda'];
	$aRetVal['nombre'] = $aDto['nombre'];
	$aRetVal['orden'] = $aDto['orden'];

	$aBlocks[$block_name]['done'] = $first;
	$aBlocks[$block_name]['reset'] = $reset;
	$aBlocks[$block_name]['extras'] = $aDtos;
	$aBlocks[$block_name]['divisa'] = $aDiv;
	return $aRetVal;
}


/** calcula los totales en funcion de las lineas de detalle ke nos llegan de nodb_confirmar_pedido , detalle_iva y detalle_descuento*/
function nodb_order_totals(&$Sesion,$block_name) {
	static $aBlocks;
	static $obj_var;

	if (empty($block_name)) $block_name = 0;
	if (is_array($aBlocks[$block_name]) AND sizeof($aBlocks[$block_name])) {
		$first = $aBlocks[$block_name]['done'];
		$reset = $aBlocks[$block_name]['reset'];
	}
	if (empty($obj_var)) {
	   $docvar = $Sesion->get_var('__document_iface_varname');
	   if (empty($docvar)) $docvar = 'oPedido_en_curso';
	   $obj_var = $docvar;
	}

	if (!isset($first) OR $reset) {
		$oPedido = $Sesion->get_var($obj_var);
		if (!is_object($oPedido)) return NULL;
		$oPedido->calculate();
		$aTotales = $oPedido->get_totals();
		$aDiv = $oPedido->get_currency();
		$aRetVal = $aTotales;
		$aRetVal['leyenda_divisa'] = $aDiv['leyenda'];
		$aRetVal['total_impuestos'] = $aRetVal['impuestos'] + $aRetVal['recargos'];
		$first = 1;
		$reset = 0;
	} else {
		$reset = 1;
		$aRetVal = NULL;
	}
	$aBlocks[$block_name]['done'] = $first;
	$aBlocks[$block_name]['reset'] = $reset;
	return $aRetVal;
}

?>
