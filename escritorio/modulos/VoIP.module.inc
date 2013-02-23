<?php

class ModVoIP extends AppModule {
	var $activo = NULL;
	var $entActiva = NULL;
	var $pii_activo = NULL;
	var $own_mask = 2;
	var $aFraNotIPIdx = array();

	function SectionStart() {
		$oS = &$this->getApp();
		if (!is_a($oS,'wolSesion')) return false;
		debug(get_class($this)." :: Desde modulo VoIP, _todo ok no? ".$oS->get_subsecc_name());
		switch ($oS->get_subsecc_name()) {
			case 'hacer_pedido':
				$bBus = $oS->haveSearch();
				$oB = &$oS->getSearch();
				$oB->registerModule(&$this,'searchNotOwnProducts');
				break;
			case 'bo_factura_cliente':
				break;
		}
		return true;
	}

	function triggerPII($pii) {
		static $aEnt = array('Articulos');
		$this->pii_activo = $pii;
		if ($pii != 'Datos_Generales') return;
		// debug(get_class($this)."::triggerPII($pii)($this->activo) disparador de punto de informacion: $pii con ".get_class($this->getApp()));
		$oS = &$this->getApp();
		if (!is_numeric($this->activo) and is_array($oS->_aIdxAccSS[$oS->get_subsecc_name()])) {
			foreach ($oS->_aIdxAccSS[$oS->get_subsecc_name()] as $ent) {
				if (in_array($ent,$aEnt)) {
					$this->activo = 1;
					$this->entActiva = $ent;
					$oB = &$oS->getRootBlock($pii);
					if (is_object($oB)) $oB->set_cfunc('ModVoIP->checkRecord');
					break;
				}
			}
		} 
	}

	function preRenderPII($pii) {
		$oS = &$this->getApp();
		switch ($oS->get_subsecc_name()) {
			case 'bo_factura_cliente':
				if ($pii == 'prettyPrint') {
					$this->activo = true;
					$oB = &$oS->getRootBlock($pii);
					$idx = $oB->getCurrentChildNum();
					// debug("Ya tenemos el idx $idx  y hay: ");
					// print_r(array_keys($oB->hijos));
					$oBI = &$oB->getChild();
					if (is_a($oBI,'bucle') and $oBI->get_nombre()=='impresion_multiple_pedidos') {
						// debug("El hijo se llama: ".$oBI->get_nombre());
						$oBI->set_cfunc('ModVoIP->checkInvoice');
					}
					$oB->setCurrentChildNum($idx);
				}
				break;
			default:
				// $this->debug("A ver si esta activo? ".(int)$this->activo,'preRenderPII');
				break;
		}
	}

	function fldAvailable($fld) {
		if (!$this->activo) return NULL;
		if ($this->pii_activo == 'VoIP') return true;
		// debug("Activo en ".$this->pii_activo);
		$rval = parent::fldAvailable($fld);
		return $rval;
	}

	function isRecordEntity ($entidad,$accion) {
		$aList = array('Articulos');
		if (in_array($entidad,$aList)) return true;
		return false;
	}

	function checkInvoice(&$oB) {
		if (!$this->activo) return true;

		$oS = &$this->getApp();
		$docvar = $oS->get_var('__document_iface_varname');
		$oFra = &$oS->getVarByRef($docvar);
		if (is_a($oFra,'Invoice') and $oFra->num_details()) {
			$idx_act = $oFra->current_detail();
			$bFound = false;
			$aNotOwnIdx = array();
			for ($idx = $oFra->first_detail(); isset($idx); $idx = $oFra->next_detail()) {
				$mask = $oFra->getDetailAttribute($idx,'mascara_modulo');
				if ($mask & $this->own_mask) {
					$id_unidad = $oFra->getDetailAttribute($idx,'id_unidad_medida');
					$oS->set_var('voip_id_unidad_medida',$id_unidad);
					$bFound = true;
				} else {
					if (!in_array($idx,$aNotOwnIdx)) array_push($aNotOwnIdx,$idx);
				}
			}
			$oFra->set_active_detail($idx_act);
			if ($bFound) {
				$aPlt = $oS->getPltArray('voip_print_base');
				$oS->changePlt('print_one_document',$aPlt);
				$this->aFraNotIPIdx = $aNotOwnIdx;
			}
		}

		return true;
	}

	function getFromInvoiceNotIP() {
		return $this->aFraNotIPIdx;
	}

	function off__to_delete___checkRecord(&$oB) {
		if (!$this->activo) return true;

		$fld = $oB->sesion->_aAcciones[$this->entActiva]['module_field'];
		if (empty($this->entActiva) or empty($fld)) {
			$this->__deactivate();
			return true;
		}
		if (!strchr($fld,'.')) $fld = $this->entActiva.'.'.$fld;
		$val = $oB->get_data($fld);
		if (empty($val)) {
			$this->__deactivate();
			return true;
		}
		if ( !($val & $this->own_mask) ) {
			$this->__deactivate();
			return true;
		}
		// debug("prueba superada!: ".$this->entActiva" campo: ".$fld." val: $val ");
		// print_r($aData);
		return true;
	}

	function __deactivate() {
		parent::__deactivate();
		$oS = &$this->getApp();

		$aPlts = $oS->getPltArrayAll();
		if (is_array($aPlts) and sizeof($aPlts))
			foreach ($aPlts as $nombre => $aP)
				if ( stristr($nombre,'VoIP') ) {
					$oS->delPlt($aP['pii']);
				}
		return true;
	}

	function searchNotOwnProducts(&$oSearchAPI) {
		// debug("-- Descartando las referencias de voz de la busqueda ... ".get_class($oSearchAPI));
		if (is_numeric($this->own_mask))
			$oSearchAPI->add_where('(Articulos.mascara_modulo IS NULL OR !(Articulos.mascara_modulo & '.$this->own_mask.')) ','AND');
	}

	function pageInvoice() {
		$Sesion = &$this->getApp();
		$docvar = $Sesion->get_var('__document_iface_varname');
		$oPedido = &$Sesion->getVarByRef($docvar);
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
			if (is_array($this->aFraNotIPIdx) and sizeof($this->aFraNotIPIdx) and is_array($aNum) and sizeof($aNum)) {
				foreach (array_keys($aNum) as $i) {
					$aNum[$i]['values'] = array_diff($aNum[$i]['values'],$this->aFraNotIPIdx);
					if (!sizeof($aNum[$i]['values'])) {
						$aNum[$i] = NULL;
						unset($aNum[$i]);
					}
				}
			}
			$aNumKeys = array_keys($aNum);
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
						array_push($aRupturasResumen['origen'],$aNum[$aNumKeys[$tmpPtr]]['index'][0]);

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
				array_push($aRupturasResumen['origen'],$aNum[$aNumKeys[sizeof($aNum)-1]]['index'][0]);
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
		}
	}

	function isMixedInvoice() {
		$aRef = $this->getFromInvoiceNotIP();
		// $this->debug('Size: '.sizeof($aRef),'isMixedInvoice');
		if (is_array($aRef) and sizeof($aRef)) return true;
		else return false;
	}

	function cerrar() {
		$this->activo = NULL;
		$this->entActiva = NULL;
		// debug("Cerrando el modulo ... ");
		return parent::cerrar();
	}
}

?>
