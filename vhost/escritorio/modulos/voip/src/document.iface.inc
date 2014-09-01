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


/** 
  * funcion nodb para la obtencion de los detalles de la clase documento indicada en __document_iface_varname
  */
function OFF_voip_impresion_multiple_pedidos(&$Sesion) {
	static $stored;
	static $aIDs;
	static $aCfg;
	static $nCopia = 0;
	$registro_borrar=$Sesion->fetchVar('registro_borrar','POST');
	$emitir=$Sesion->fetchVar('emitir','GET');
	$factura=$Sesion->fetchVar('factura','POST');

	debug("voip_impresion_multiple_pedidos ");
	if (!is_array($aCfg) OR !sizeof($aCfg)) $aCfg = $Sesion->get_var('_aAppConf');
	// Solo una copia si se va a mandar por email.
	$output = $Sesion->get_var('__output__name');
	if(!strcmp($output,'email')) {
		$aCfg['print_invoice_ncopies'] = NULL;
	}

	if (!$stored) {
		$docvar = $Sesion->get_var('__document_iface_varname');
		$oPedido = $Sesion->get_var($docvar);
		$stored = 1;
		$aIDs = array();
		if (is_array($registro_borrar))
			foreach ($registro_borrar as $idped => $bool) array_push($aIDs,$idped);
		if (!sizeof($aIDs)) $aIDs = NULL;
		if (!is_object($oPedido) AND !is_array($registro_borrar)) return NULL;
	} 

	if (empty($docvar)) $docvar = 'oFactura_ficha';

	if (is_array($aIDs) AND sizeof($aIDs)) {
		while(is_array($aIDs) AND sizeof($aIDs)) {
			$oPedido = new Invoice($Sesion->App_Name,'data',inmPed_VENTA);
			$idped = array_shift($aIDs);
			if ($aCfg['print_invoice_ncopies'] > 0) {
				$nCopia++;
				$Sesion->set_var('_numero_copia',$nCopia,'INMED');
				if ($nCopia < $aCfg['print_invoice_ncopies']) array_unshift($aIDs,$idped);
				elseif ($nCopia == $aCfg['print_invoice_ncopies']) $nCopia = 0;
			} else $Sesion->unset_var('_numero_copia');

			if ($oPedido->dbfill($idped)) {
				if ((int)$emitir AND !$oPedido->getIssued()) {
					if ((int)$factura['factura_abono']) $oFactura->setInstallment($factura['factura_abono']);
					$oPedido->setIssued();
					$oPedido->dbDump();
				}
				$aInfo = $oPedido->get_info();
				if ((int)$aInfo['id_serie_contabilizable']) {
					$aEmp = $oPedido->get_issuer_info();
					$Sesion->set_var("nombre_empresa",$aEmp['razon_social'],"INMED");
				}

				if (!empty($docvar)) {
					$Sesion->set_var($docvar,$oPedido,'SUBSECCION');
					$Sesion->set_var('__document_iface_varname',$docvar,'NOEXPIRE');
				} else {
					$Sesion->set_var($docvar,$oPedido,'SUBSECCION');
					$Sesion->set_var('__document_iface_varname',$docvar,'NOEXPIRE');
				}
				break;
			} 
		}
	} else {
		if ($aCfg['print_invoice_ncopies'] > 0) {
			$nCopia++;
			$Sesion->set_var('_numero_copia',$nCopia,'INMED');
			if ($nCopia <= $aCfg['print_invoice_ncopies']) {
				$oPedido = $Sesion->get_var($docvar);
			} 
		} else $Sesion->unset_var('_numero_copia');
	}
		
	if (is_object($oPedido)) {
		// Calcular el numero de paginas, y posiciones de ruptura.
		$aRupturas = array();
		$nSplit = 0;
		$nSplitOrig = 0;

		$aCfg = $Sesion->get_var('_aAppConf');
		$aSizes['seccion'] = 2;
		$aSizes['titulogrupo'] = 2;
		$aSizes['cabecera'] = 3;
		$nCarLinea = $aCfg['print_numcar_observaciones'];
		if (!is_numeric($nCarLinea)) $nCarLinea = 130;

		$nLineasPrimera = $aCfg['print_pgcabdoc_lineas'];
		if (!is_numeric($nLineasPrimera)) $nLineasPrimera = 49;
		$nLineasPagina = $aCfg['print_pgdoc_lineas'];
		if (!is_numeric($nLineasPagina)) $nLineasPagina = 76;
		$nLineasTotales = $aCfg['print_piedoc_lineas'];
		if (!is_numeric($nLineasTotales)) $nLineasTotales = 12;

		$nLineasPagina = 90;
		$nLineasResumenEnDetalle = 1.7; // Con un pelin de margen

		$bObsEnLinea = (int)$aCfg['print_observaciones_enlinea'];
		$bProductIds = (int)$aCfg['print_invoice_productids'];
		if ($oPedido->getInstallment()) $bProductIds = false;

		$nTotalPaginas = 1; // La primera pagina son los totales que nunca ocupan mas de 1
		// Primero contamos Cuantas paginas ocupa el resumen:

		$aRupturasResumen['origen'] = array();
		//Resumen por Numero:
		$nLResumen = $aSizes['seccion'];		// Lineas para el nombre del resumen
		$nLResumen += $aSizes['cabecera']; 	// Lineas para poner el encabezado del listado
		$aNum = $oPedido->_aIndices['origen']->get();
		if ( ($nLineasPagina - $nLResumen) < (sizeof($aNum)*$nLineasResumenEnDetalle) ) {
			// Vamos a romper en medio del resumen por numero ... 
			$tmpPtr = 0;
			while (true) {
				// debug("Tenemos un total de : ".sizeof($aNum)." Y estamos en $nLResumen/$nLineasPagina ");
				if ( ( ($tmpPtr)+$nLineasPagina) >= (sizeof($aNum)*$nLineasResumenEnDetalle) ) {
					// Si estamos ya a menos de una pagina del final de los numeros, paramos
					$nLResumen = $aSizes['seccion'];		// Lineas para el nombre del resumen
					$nLResumen += $aSizes['cabecera']; 	// Lineas para poner el encabezado del listado

					$nLResumen += (sizeof($aNum) - $tmpPtr -1)*$nLineasResumenEnDetalle;
					break;
				} else {
					// Vamos sumando ruptura, y avanzando el puntero.
					$tmpPtr += ($nLineasPagina-$nLResumen) ;
					// debug("La ruptura deberia caer en... $tmpPtr Siguiente ... ");
					$nTotalPaginas += 1;
					array_push($aRupturasResumen['origen'],$aNum[$tmpPtr]['index'][0]);

					$nLResumen = $aSizes['seccion'];		// Lineas para el nombre del resumen
					$nLResumen += $aSizes['cabecera']; 	// Lineas para poner el encabezado del listado
				}
			}
		} else {
			$nLResumen += (sizeof($aNum) * $nLineasResumenEnDetalle);	// Numero de origenes por el numero de lineas que ocupa cada uno
		}

		if ( ($nLResumen + $aSizes['seccion']) > $nLineasPagina ) {
			// Si la cabecera no va caber en el pie de la pagina, rompemos en el ultimo numero
			$nTotalPaginas += 1;
			array_push($aRupturasResumen['origen'],$aNum[sizeof($aNum)-1]['index'][0]);
			$nLResumen = 0;
		}

		//Resumen por Grupo:
		$aRupturasResumen['familia'] = array();
		$nLResumen += $aSizes['seccion'];		// Lineas para el nombre del resumen
		$aGrupo = $oPedido->_aIndices['familia']->get();
		if (is_array($aGrupo) AND sizeof($aGrupo)) {
			// Obtenemos la lista de grupos Distintos que hay
			$aGrpList = array();
			$nLCabResumen = ($aSizes['titulogrupo']);
			$nLCabResumen += ($aSizes['cabecera']);

			foreach ($aGrupo as $aIdx) {

				if (!in_array($aIdx['index'][0],$aGrpList)) {
					array_push($aGrpList,$aIdx['index'][0]);
					// Cada grupo esta compuesto por un titulo de grupo y una cabecera de listado:
					$tmpline = $nLCabResumen;
				} else $tmpline = 0;
				$tmpline += ($nLineasResumenEnDetalle);

				if ( ($tmpline+$nLResumen) > $nLineasPagina ) {
					// Si sumamos este tamanyo, nos pasamos de la pagina. Rompemos.
					$nTotalPaginas += 1;
					array_push($aRupturasResumen['familia'],$aIdx['index']);
					$nLResumen = $tmpline;
				} else $nLResumen += $tmpline;

			}

			// Ahora le sumamos el numero de Familias/Lineas que se mostraran:
		}
		// debug("El resumen ocupa $nLResumen Lineas => nPg: ".ceil($nLResumen/$nLineasPagina));
		// print_r($aRupturasResumen);
		$Sesion->set_var('aRupturasPaginaResumen',$aRupturasResumen,'SUBSECCION');
		$nTotalPaginas += ceil($nLResumen/$nLineasPagina);

		// debug("Estamos en NPaginas: ".$nTotalPaginas);

		//Detalle por Numero:
		// debug("Numeros: ".sizeof($aNum));
		$nLDetalle = 0;
		if (sizeof($aNum)) {
			$nLCabNumero = $aSizes['seccion'];
			$nLCabNumero += $aSizes['titulogrupo']; // El numero, propiamente dicho
			$nLCabNumero += 1; 				// El encabezado del listado
			$nTotalPaginas += 1; 			// Digo yo, que si hay detalle, habra que meter la pagina primera
			foreach ($aNum as $aIdxNum) {

				// debug("Para el siguiente son: ".sizeof($aIdxNum['values'])." lineas ... ");
				$nLDetalle += $nLCabNumero;
				if (sizeof($aIdxNum['values']) > ($nLineasPagina-$nLDetalle)) {
					// debug("Este hay que romperlo por algun lado. ");
					$tmpPtr = 0;
					while (true) {
						// debug("En esta pagina: $nTotalPaginas hay que poner ".($nLineasPagina-$nLDetalle)." Lineas ");
						if ( ($tmpPtr+$nLineasPagina) >= sizeof($aIdxNum['values'])) {
							// Si estamos ya a menos de una pagina del final de los detalles del numero, paramos
							$nLDetalle = $nLCabNumero;
							// debug("Ultimo cacho, y estamos en el detalle $tmpPtr; En la linea ($nLDetalle) -cabecera- ");

							$nLDetalle += (sizeof($aIdxNum['values']) - $tmpPtr -1);
							// debug("Tendriamos $nLDetalle lineas, una vez maracado el ultimo detalle de este numero como de ruptura. ");
							break;
						} else {
							// Vamos sumando ruptura, y avanzando el puntero.
							$tmpPtr += ($nLineasPagina-$nLDetalle) ;
							// debug("La ruptura deberia caer en... $tmpPtr Siguiente ... ");
							$nTotalPaginas += 1;
							array_push($aRupturas,$aIdxNum['values'][($tmpPtr-1)]);
							$nLDetalle = $nLCabNumero;
						}
					}
				} else {
					$nLDetalle += sizeof($aIdxNum['values']);
				}

				// debug("Pagina $nTotalPaginas, Linea $nLDetalle ");
				if ( ($nLDetalle+$nLCabNumero) >= $nLineasPagina ) {
					// debug("Rompemos, que la siguiente cabecera no va a caber. ");
					$nTotalPaginas += 1;
					array_push($aRupturas,array_pop($aIdxNum['values']));
					$nLDetalle = 0;
				}

			}
		}

		// debug("Romperemos en... ");
		// print_r($aRupturas);
		$Sesion->set_var('aRupturasPagina',$aRupturas,'SUBSECCION');
		$Sesion->set_var("paginas_totales",$nTotalPaginas);
		$Sesion->set_var("pagina_actual",1);

		$aInfo = $oPedido->get_info();
		return $aInfo;
	}

}

function voipnodb_noip_list(&$Sesion,$block_name) {
	static $aBlocks;
	static $obj_var;
	static $aIdxList;
	static $aRupturas;

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
	$aCfg = $Sesion->get_var('_aAppConf');
	$n_dec = $aCfg['gnrl_totdoc_digits'];

	if (!$not_first OR $reset) {
		// Mostrando las Referencias que son.
		$aMethod = &$Sesion->_getCallBackMethod('ModVoIP->getFromInvoiceNotIP');
		if (is_array($aMethod['call']) and sizeof($aMethod['call'])) {
			$aFraNotIPIdx = call_user_func($aMethod['call']);
			if (is_array($aFraNotIPIdx) and sizeof($aFraNotIPIdx) ) {
				$aRList = $Sesion->get_var('aRupturasPaginaResumen');
				if (is_array($aRList[$idx_name]) AND sizeof($aRList[$idx_name]))
					$aRupturas = $aRList[$idx_name];
				$not_first = 1;
				$aIdxList = $aFraNotIPIdx;
			} else $aIdxList = NULL;
		}
	}

	$Sesion->set_var('romper_linea',0);
	if (!sizeof($aIdxList)) {
		$reset = 1;
		$aArt = NULL;
	} else { 
		// $aIdxAct = array_shift($aIdxList);
		// print_r($aIdxAct['index']);
		$reset = 0;
		$idx = array_shift($aIdxList);

		if (is_array($aRupturas) AND sizeof($aRupturas)) {
			$aR = array_shift($aRupturas);
		}

		/** **
		if (is_array($aIdxAct['index']) AND sizeof($aIdxAct['index'])) {
			if (!is_array($aR)) {
				if (isset($aR) and $aR == $aIdxAct['index'][0]) {
					$aR = NULL;
					$bMatch = true;
				}
			} else $bMatch = true;

			foreach ($aIdxAct['index'] as $i => $aIdx) {
				if ($bMatch AND is_array($aR)) {
					if ($aR[$i] != $aIdxAct['index'][$i]) $bMatch = false;
				}
				$aArt['grupo'.$i] = $aIdxAct['index'][$i];
			}
					
			if ($bMatch) $Sesion->set_var('romper_linea',1);
		}
		/** **/

		// print_r($aIdxAct['index']);
		$aDiv = $oPedido->get_currency();
		$aArt['leyenda_divisa'] = $aDiv['leyenda'];
		$dto = $consumo = $descuento = $bruto = $base = $cant = 0;
		/** **
		foreach ($aIdxAct['values'] as $i => $idx) {
			$aDet = $oPedido->get_detail($idx);

			$cant += $oPedido->get_quantity($idx);
			$base += $oPedido->getDetailAttribute($idx,'base_imponible');
			// print_r($aDet);
			$dto = 0;
			if ($oPedido->have_discount($idx)) {
				$aDto = $oPedido->get_detail_discount($idx);
				if ($aDto['porciento'] != 0) {
					$dto = ($aDto['porciento']*$aDet['base_imponible']) / (100 - $aDto['porciento']);
				} else {
					$dto = $aDto['monto'];
				}
				$descuento += $dto;
			}
			$consumo = ($aDet['base_imponible']+$dto);
			// echo("ID: ".$aDet['id_detalle']." Cant: ".$aDet['cantidad']." minutos a ".$aDet['precio_tarifa'].
					// " hace un Consumo = $consumo y base : ".$aDet['base_imponible']." a $n_dec dto de $dto <br>");

			$bruto += ($aDet['base_imponible']+$dto);
		}
		/** **/
		$aArt = $oPedido->get_detail($idx);
		$aArt['cantidad'] = $oPedido->get_quantity($idx);
		$aArt['precio'] = $oPedido->get_price($idx);
		if (isset($aR)) {
			array_unshift($aRupturas,$aR);
		}
	}

	$aBlocks[$block_name]['done'] = $not_first;
	$aBlocks[$block_name]['reset'] = $reset;
	return $aArt;
}

function voipnodb_order_orig_resume(&$Sesion,$block_name) {
	static $aBlocks;
	static $obj_var;
	static $aIdxList;
	static $aRupturas;

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
	$aCfg = $Sesion->get_var('_aAppConf');
	$n_dec = $aCfg['gnrl_totdoc_digits'];

	if (!$not_first OR $reset) {
		$idx_name = $Sesion->get_var('resume_index');
		if (empty($idx_name)) $idx_name = 'origen';
		$aIdxList = $oPedido->_aIndices[$idx_name]->get();
		// Eliminando las referencias que no son de voz.
		$aMethod = &$Sesion->_getCallBackMethod('ModVoIP->getFromInvoiceNotIP');
		if (is_array($aMethod['call']) and sizeof($aMethod['call'])) {
			$aFraNotIPIdx = call_user_func($aMethod['call']);
			if (is_array($aFraNotIPIdx) and sizeof($aFraNotIPIdx) and is_array($aIdxList) and sizeof($aIdxList)) {
				foreach (array_keys($aIdxList) as $i) {
					$aIdxList[$i]['values'] = array_diff($aIdxList[$i]['values'],$aFraNotIPIdx);
					if (!sizeof($aIdxList[$i]['values'])) {
						$aIdxList[$i] = NULL;
						unset($aIdxList[$i]);
					}
				}
			}
		}
		$aRList = $Sesion->get_var('aRupturasPaginaResumen');
		if (is_array($aRList[$idx_name]) AND sizeof($aRList[$idx_name]))
			$aRupturas = $aRList[$idx_name];
		$not_first = 1;
	}

	$Sesion->set_var('romper_linea',0);
	if (!sizeof($aIdxList)) {
		$reset = 1;
		$aArt = NULL;
	} else { 
		$aIdxAct = array_shift($aIdxList);
		// print_r($aIdxAct['index']);
		$reset = 0;
		$Sesion->set_var($obj_var,$oPedido);
		if (is_array($aRupturas) AND sizeof($aRupturas)) {
			$aR = array_shift($aRupturas);
		}

		if (is_array($aIdxAct['index']) AND sizeof($aIdxAct['index'])) {
			if (!is_array($aR)) {
				if (isset($aR) and $aR == $aIdxAct['index'][0]) {
					$aR = NULL;
					$bMatch = true;
				}
			} else $bMatch = true;

			foreach ($aIdxAct['index'] as $i => $aIdx) {
				if ($bMatch AND is_array($aR)) {
					if ($aR[$i] != $aIdxAct['index'][$i]) $bMatch = false;
				}
				$aArt['grupo'.$i] = $aIdxAct['index'][$i];
			}
					
			if ($bMatch) $Sesion->set_var('romper_linea',1);
		}

		// print_r($aIdxAct['index']);
		$aDiv = $oPedido->get_currency();
		$aArt['leyenda_divisa'] = $aDiv['leyenda'];
		$dto = $consumo = $descuento = $bruto = $base = $cant = 0;
		foreach ($aIdxAct['values'] as $i => $idx) {
			$aDet = $oPedido->get_detail($idx);

			$cant += $oPedido->get_quantity($idx);
			$base += $oPedido->getDetailAttribute($idx,'base_imponible');
			// print_r($aDet);
			$dto = 0;
			if ($oPedido->have_discount($idx)) {
				$aDto = $oPedido->get_detail_discount($idx);
				if ($aDto['porciento'] != 0) {
					$dto = ($aDto['porciento']*$aDet['base_imponible']) / (100 - $aDto['porciento']);
				} else {
					$dto = $aDto['monto'];
				}
				$descuento += $dto;
			}
			$consumo = ($aDet['base_imponible']+$dto);
			// echo("ID: ".$aDet['id_detalle']." Cant: ".$aDet['cantidad']." minutos a ".$aDet['precio_tarifa'].
					// " hace un Consumo = $consumo y base : ".$aDet['base_imponible']." a $n_dec dto de $dto <br>");

			$bruto += ($aDet['base_imponible']+$dto);
		}
		$aArt['cantidad'] = $cant;
		$aArt['base_imponible'] = $base;
		$aArt['bruto'] = $bruto;
		$aArt['importe_descuento'] = $descuento;
		if (isset($aR)) {
			array_unshift($aRupturas,$aR);
		}
		$aArt['id_unidad_medida'] = $Sesion->get_var('voip_id_unidad_medida');
	}

	$aBlocks[$block_name]['done'] = $not_first;
	$aBlocks[$block_name]['reset'] = $reset;
	return $aArt;
}

function voipnodb_order_orig_resume_detail(&$Sesion,$block_name) {
	static $aBlocks;
	static $obj_var;
	static $aIdxList;
	static $aIdxValues = array();
	static $aAddArt;

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
		$idx_name = $Sesion->get_var('resume_index');
		if (empty($idx_name)) $idx_name = 'origen';
		$aIdxList = $oPedido->_aIndices[$idx_name]->get();
		// Eliminando las referencias que no son de voz.
		$aMethod = &$Sesion->_getCallBackMethod('ModVoIP->getFromInvoiceNotIP');
		if (is_array($aMethod['call']) and sizeof($aMethod['call'])) {
			$aFraNotIPIdx = call_user_func($aMethod['call']);
			if (is_array($aFraNotIPIdx) and sizeof($aFraNotIPIdx) and is_array($aIdxList) and sizeof($aIdxList)) {
				foreach (array_keys($aIdxList) as $i) {
					$aIdxList[$i]['values'] = array_diff($aIdxList[$i]['values'],$aFraNotIPIdx);
					if (!sizeof($aIdxList[$i]['values'])) {
						$aIdxList[$i] = NULL;
						unset($aIdxList[$i]);
					}
				}
			}
		}
		$not_first = 1;
	}

	if (!sizeof($aIdxList) AND !sizeof($aIdxValues)) {
		$reset = 1;
		$aArt = NULL;
	} else { 
		if (!sizeof($aIdxValues)) {
			$aIdxAct = array_shift($aIdxList);
			if (is_array($aIdxAct['index']) AND sizeof($aIdxAct['index']))
				foreach ($aIdxAct['index'] as $i => $aIdx) {
					$aAddArt['grupo'.$i] = $aIdxAct['index'][$i];
				}
			$aIdxValues = $aIdxAct['values'];
		}
		$idxdet = array_shift($aIdxValues);
		// print_r($aIdxAct['index']);
		$reset = 0;

		$aDiv = $oPedido->get_currency();
		$aArt = $oPedido->get_detail($idxdet);
		if (!is_array($aArt) OR !sizeof($aArt)) return NULL;
		$oPedido->set_active_detail($idxdet);
		$Sesion->set_var($obj_var,$oPedido);

		if (is_array($aAddArt) AND sizeof($aAddArt)) foreach ($aAddArt as $fld => $val) $aArt[$fld] = $val;

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

?>
