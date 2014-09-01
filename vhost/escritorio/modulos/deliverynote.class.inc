<?php

class DeliveryEntry extends dbListItem {

	function DeliveryEntry(&$oList,$idx = NULL,$aData = NULL,$aAcciones = NULL) {
		// $aAcciones['id_detalle'] = array('method' => 'updateForeignKey');
		$aAcciones['id_almacen_logico'] = array('method' => 'updateForeignKey');
		$aAcciones['cantidad'] = array('method' => 'updateQuantity');
		$aAcciones['cantidad_devuelta'] = array('method' => 'updateReturnedQuantity');
		$aAcciones['fecha_caducidad'] = array('method' => 'setDate');
		$aAcciones['DetallePedido.id_articulo'] = array('method' => 'updateForeignKey');
		return parent::dbListItem($oList,$idx,$aData,$aAcciones);
	}

	function setVerified($val,$bSuma = true) {
		if ($this->isSale()) return false;
		if (!isset($bSuma)) $bSuma = true;
		if ($bSuma) {
			$cnti = $this->getAttribute('stock_previsto');
		} else $cnti = 0;
		$rval = $this->setAttribute('stock_previsto',($cnti+$val));
		return $rval;
	}

	function getVerified() {
		if ($this->isSale()) return NULL;
		return $this->getAttribute('stock_previsto');
	}

	function updateQuantity($cnt,$fld = NULL) {
		$this->debug("updateQuantity de $cnt ",'updateQuantity');
		return $this->check($cnt,false);
	}

	function updateReturnedQuantity($cnt,$fld = NULL) {
		if (empty($fld)) $fld = 'cantidad_devuelta';
		$this->debug("updateReturnedQuantity de $cnt ",'updateReturnedQuantity');
		if ($this->checkFlag($this->ST_NEW)) return false;
		if ($cnt>$this->getAttribute('cantidad')) return false;
		return $this->setAttribute($fld,$cnt);
	}

	function check($cantidad,$bSuma = true) {
		if (!isset($bSuma)) $bSuma = true;
		if ($bSuma) {
			$cnt = $this->getAttribute('cantidad');
		} else $cnt = 0;
		$stot = $cantidad+$cnt;

		$cprev = $this->getAttribute('stock_previsto');
		if (!$this->checkFlag($this->ST_NEW))
			if ($this->isSale()) {
				if (abs($stot)>pow(10,-6) and $stot > $cprev) {
					// $this->unsetVar('SKULoc');
					debug("Ojo, que estamos permitiendo servir mas de lo previsto ");
					// debug("Error: No se puede servir mas genero del previsto. (recalcula si crees que es un error) ");
					// return false;
				}
			} else {
				if (abs($stot)>pow(10,-6) and $stot < $cprev) {
					/** Homgeinizacion entre Compras y Ventas, ya no hay genero confirmado **/
					// $this->unsetVar('SKULoc');
					// debug("Error: No se puede servir _menos_ genero del confirmado. (recalcula si crees que es un error) ");
					debug("Ojo: permitimos servir _menos_ genero del confirmado. (recalcula si crees que es un error) ");
					// return false;
				}
			}
		$this->debug("cant total: $stot y prevista: $cprev  idx: ".$this->getPositionInList(),'check');
		$cntr = $this->getAttribute('cantidad');
		if (!isset($cntr) or $stot!=$cntr) {
			$rval = $this->setAttribute('cantidad',($stot));
			$id_det = $this->getAttribute('id_detalle');
			$ped_cnt = $this->getAttribute('cantidad','DetallePedido');
			if (empty($id_det) and empty($ped_cnt)) $this->setAttribute('cantidad',($stot),'DetallePedido');
		} else $rval = false;
		return $rval;
	}

	function isSale() {
		$oL = &$this->getList();
		if (is_a($oL,'DeliveryEntries')) {
			$oP = &$oL->getParentHook();
			if (is_a($oP,'DeliveryNote')) {
				$rval = ( ($oP->bVenta) ? true : false );
				return $rval;
			}
		}
		return NULL;
	}

	function preUpdate($aData,$bForce = NULL) {
		$aFlds = array('planta','pasillo','columna','fila','fecha_caducidad','lote','id_almacen_logico');

		$this->debug(array("rec-in:"=>$aData),'preUpdate');
		foreach ($aFlds as $fld) $aTmpV[$fld] = $this->getAttribute($fld);
		$this->setVar('SKULoc',$aTmpV);
		$this->setVar('cantidad_preupdate',$this->getAttribute('cantidad'));
		$this->setVar('devuelto_preupdate',$this->getAttribute('cantidad_devuelta'));
		if (!empty($aData['id_articulo'])) {
			$this->debug("Almacenando de strangis el id_art: ".$aData['id_articulo'],'preUpdate');
			$this->setVar('id_articulo_preupdate',$aData['id_articulo']);
		}

		return true;
	}

	function postUpdate($rval) {
		if ($rval) {
			$aVOrig = $this->getVar('SKULoc');
			//$this->debug(array("El <b>post</b>Update con SKULoc orig : "=>$aVOrig,"Data: "=>$this->getData("DetallePedido")),'postUpdate');
			$bDoIt = false;
			if (is_array($aVOrig) and sizeof($aVOrig) ) {
				if (!$this->checkFlag($this->ST_NEW))
					foreach ($aVOrig as $fld => $val) {
						if ($val != $this->getAttribute($fld)) {
							// debug("mismatch en $fld ($val::".$this->getAttribute($fld)."), procesando desplazamiento .. ");
							$bDoIt = true;
							break;
						}
					}
			} else {
				return false;
			}

			if ($this->checkFlag($this->ST_NEW)) {
				$this->updateProduct();
			}

			if ($bDoIt) { 
				$cnt = $this->getVar('cantidad_preupdate');
				$cnt_new = $this->getAttribute('cantidad');
				$cnt_previsto = $this->getAttribute('stock_previsto');
				$cnt_pedida = $this->getAttribute('DetallePedido.cantidad');
				$id_det_orig = $this->getAttribute('id_detalle');

				foreach ($aVOrig as $fld => $val) $aVNew[$fld] = $this->getAttribute($fld);
				if ($cnt != $cnt_new) {
					debug("No coinciden las cantidades => preUpdate: $cnt aftUpdate: $cnt_new Previsto: $cnt_previsto ");
					/** Ya se permite servir distinto al previsto **
					// Comprobamos la cantidad alterada, si el total supera el previsto, a la puta rue.
					if ( $this->isSale() and ($cnt_new > $cnt_previsto) ) {
						debug("Error: No se puede desplazar mas genero del previsto. ");
						return false;
					}
					/** **/

					// Reestablecemos los valores de SKU y Localizacion a los originales.
					foreach ($aVOrig as $fld => $val) $this->setAttribute($fld,$val);

					$idx_act = $this->getPositionInList();
					debug("reseteada linea $idx_act a sus originales. previsto: $cnt_previsto nueva: $cnt_new cnt: $cnt ");
					// Si esta localizacion, una vez restada la cantidad, se queda a 0, la borramos
					if ( (abs($cnt_previsto - $cnt_new) < pow(10,-6)) 
							) {
						//if ( ($this->isSale() and ($cnt_previsto - $cnt_new) < pow(10,-6)) 
								// or (!empty($cnt) and ($cnt_previsto - $cnt_new)>$cnt)  
						debug("Esta ($idx_act) se queda a 0 - Este caso nunca deberia producirse");
						$this->delete();
					} else {
						// $this->setAttribute('cantidad',($cnt - $cnt_new));

						debug("Corregimos entrada($idx_act), cantidad : $cnt previsto sera ($cnt_previsto - $cnt_new) ".
									"cnt_prev: $cnt_previsto ");
						// Alteramos la cantidad de esta linea para que se ajuste al movimiento solicitado
						if (true or $this->isSale()) {
							$this->setAttribute('stock_previsto',($cnt_previsto-$cnt_new));
							if ($cnt_new > ($cnt_previsto-$cnt)) {
								// Si la nueva cantidad, es superior al 'hueco' que habia, corregimos hasta el nuevo previsto
								$this->setAttribute('cantidad',($cnt_previsto-$cnt_new));
							} else $this->setAttribute('cantidad',$cnt);
						} else {
							if ( (abs($cnt_previsto)>pow(10,-6)) and ($cnt_previsto > ($cnt - $cnt_new)) ) {
								debug("<b>Limite</b> inferior no rebasado ... ");
								// El campo stock_previsto, representa las cantidades confirmadas, no se puede ir por debajo
								$this->setAttribute('cantidad',$cnt_previsto);
								$cnt_new -= ($cnt_previsto - ($cnt - $cnt_new));
							} else {
								debug("La cantidad quedase en : ".($cnt-$cnt_new));
								if (!empty($cnt) or !$this->checkFlag($this->ST_NEW)) {
									$this->setAttribute('cantidad',($cnt-$cnt_new));
								} else $this->setAttribute('cantidad',$cnt_new);
							}
						}
					}

					// Con la nueva cantidad ya limpita, buscamos en todos los detalles (salvo este) si nos coincide SKU y Localizacion.
					$oL = &$this->getList();
					$bFound = false;
					for ($idx = $oL->firstItem(true,true); isset($idx); $idx = $oL->nextItem(true,true)) {
						if ($idx==$idx_act) continue;
						$oI = &$oL->getItem();
						$tmp_det = $oI->getAttribute('id_detalle');
						if (!empty($id_det_orig) and !empty($tmp_det) and $id_det_orig!=$tmp_det) continue;
						$aTmp = $oL->getData();
						$this->debug(array("Comprarando localizacion de $idx ",'Buscamos'=>$aVNew,'Tenemos'=>$aTmp),'postUpdate');
						if (wherehouse::__compareLocation($aVNew,$aTmp,true)) {
							// Si coincide con algun detalle, _sumamos_ el stock previsto y el comprobado
							if ($GLOBALS['DEBUG']=='ON') {
								debug("Aqui($idx) nos vale bien. para mover $cnt_new ");
								print_r($aTmp);
							}
							if ($oI->checkFlag($oI->ST_DEL)) {
								$oI->unsetFlag($oI->ST_DEL);
								$oI->setAttribute('stock_previsto',0);
								$oI->setAttribute('cantidad',0);
							}
							$idd = $oI->getAttribute('id_detalle');
							if (empty($idd)) $oI->setAttribute('id_detalle',$id_detalle_orig);
							$oI->setAttribute('stock_previsto',($oI->getAttribute('stock_previsto')+$cnt_new));
							$oI->setAttribute('cantidad',($oI->getAttribute('cantidad')+$cnt_new));
							debug("La cantidad se queda en: ".$oI->getAttribute('cantidad'));
							$bFound = true;
							break;
						}
					}

					// Si no coincide con el de ningun detalle, lo insertamos como nuevo
					if (!$bFound) {
						if ($GLOBALS['DEBUG']=='ON') {
							debug("INsertamos el nuevo detalle ... Cnt: $cnt_new ");
							print_r($aVNew);
						}
						$aRec = $this->getData();
						foreach ($aVNew as $fld => $val) $aRec[$fld] = $val;
						$aRec['cantidad'] = $aRec['stock_previsto'] = $cnt_new;
						/** **
						if ($this->isSale()) $aRec['cantidad'] = $aRec['stock_previsto'] = $cnt_new;
						else $aRec['cantidad'] = $cnt_new;
						/** **/
						$aTmp = $this->getData('DetallePedido');
						if (is_array($aTmp) and sizeof($aTmp)) foreach ($aTmp as $fld => $val) $aRec['DetallePedido.'.$fld] = $val;
						$aTmp = $this->getData('Producto');
						if (is_array($aTmp) and sizeof($aTmp)) foreach ($aTmp as $fld => $val) $aRec['Producto.'.$fld] = $val;
						$aTmp = $this->getData('Familia');
						if (is_array($aTmp) and sizeof($aTmp)) foreach ($aTmp as $fld => $val) $aRec['Familia.'.$fld] = $val;
						$aTmp = $this->getData('Marca');
						if (is_array($aTmp) and sizeof($aTmp)) foreach ($aTmp as $fld => $val) $aRec['Marca.'.$fld] = $val;
						$aTmp = $this->getData('Zona');
						if (is_array($aTmp) and sizeof($aTmp)) foreach ($aTmp as $fld => $val) $aRec['Zona.'.$fld] = $val;
						$oL->insert($aRec,false);
					}
				} else {
					$oL = &$this->getList();
					$idx_act = $this->getPositionInList();
					$bFound = false;
					$this->debug(array("$idx_act en preUpdate cnt: $cnt y ahora: $cnt_new",'NewLoc' => $aVNew),'postUpdate');
					for ($idx = $oL->firstItem(); isset($idx); $idx = $oL->nextItem()) {
						if ($idx==$idx_act) continue;
						$oI = &$oL->getItem();
						$tmp_det = $oI->getAttribute('id_detalle');
						if (!empty($id_det_orig) and !empty($tmp_det) and $id_det_orig!=$tmp_det) continue;
						$aTmp = $oL->getData();
						if (wherehouse::__compareLocation($aVNew,$aTmp,true)) {
							$idd = $oI->getAttribute('id_detalle');
							if (empty($idd)) $oI->setAttribute('id_detalle',$id_detalle_orig);
							$this->debug(array("a la $idx se le va a sumar: $cnt_new",'aDet' => $aTmp),'postUpdate');
							$oI->setAttribute('stock_previsto',($oI->getAttribute('stock_previsto')+$cnt_new));
							$oI->setAttribute('cantidad',($oI->getAttribute('cantidad')+$cnt_new));
							$bFound = true;
							break;
						}
					}
					if ($bFound) {
						$this->delete();
					}
				}
			} else $this->debug("nothing to be done in post-update. rval: $rval ",'postUpdate');

			$this->unsetVar('SKULoc');
			$this->unsetVar('cantidad_preupdate');
		}
		return $rval;
	}

	function updateProduct() {
		$ida = $this->getAttribute('id_articulo','Producto');
		$this->debug("__call__ ($ref/$ida)",'updateProduct');
		if (!empty($ida) and $ida == $this->getAttribute('id_articulo','DetallePedido')) return true;
		$id_det = $this->getAttribute('id_detalle');
		//FixMe?: if (empty($id_det)) return false;
		if ($id_det != $this->getAttribute('id_detalle','DetallePedido')) $this->dbFillEntity(array('id_detalle' => $id_det),'DetallePedido');
		if (empty($ida)) {
			$ida = $this->getAttribute('id_articulo','DetallePedido');
			if (empty($ida)) {
				$aD = $this->getData();
				$ida = $aD['id_articulo'];
				if (empty($ida)) {
					$ida = $this->getVar('id_articulo_preupdate');
				}
			}
		}
		if (empty($ida)) return false;
		if ($ida != $this->getAttribute('id_articulo','Producto')) 
			$this->dbFillEntity(array('id_articulo' => $ida),'Producto');

		$idf = $this->getAttribute('id_familia','Producto');
		$idm = $this->getAttribute('id_marca','Producto');
		$idv = $this->getAttribute('id_iva','Producto');
		if (!is_numeric($idf) or !is_numeric($idm)) return false;
		if ($idf != $this->getAttribute('id_familia','Familia')) $this->dbFillEntity(array('id_familia' => $idf),'Familia');
		if ($idm != $this->getAttribute('id_marca','Marca')) $this->dbFillEntity(array('id_marca' => $idm),'Marca');
		if ($idv != $this->getAttribute('id_iva','IVA')) $this->dbFillEntity(array('id_iva' => $idv),'IVA');

		return true;
	}

	function preDump($tipo) {
		$rval = parent::preDump($tipo);
		if ($rval) {
			// debug("Preparando el detalle para volcarse ... ");
			$id_det = $this->getAttribute('id_detalle');
			$oDb = &$this->getDb();
			if (!is_numeric($id_det) and !$this->checkFlag($this->ST_DEL)) {
				$aD = $this->getData('DetallePedido');
				if (is_array($aD) and sizeof($aD) and is_numeric($aD['id_articulo'])) {
					if (!$oDb->tb_insert('Lineas_detalle',$aD)) {
						debug("Error: No se ha posido insertar la linea de detalle. ");
						return false;
					}
					$aD['id_detalle'] = $oDb->last_insert_id();
					$this->dbFillEntity(array('id_detalle' => $aD['id_detalle']),'DetallePedido');
					$this->setAttribute('id_detalle',$aD['id_detalle']);
				}
			}
		}

		return $rval;
	}

	function setDate($valor,$campo = 'fecha_caducidad') {
		$f = $this->getDate();
		$rval = false;
		if (wol_db::formatear_fecha($f,false,false) != wol_db::formatear_fecha($valor,false,false)) {
			$rval = $this->setAttribute('fecha_caducidad',wol_db::formatear_fecha($valor,false,false));
		}
		return $rval;
	}

	function getDate() {
		$fecha = wol_db::formatear_fecha($this->getAttribute('fecha_caducidad'),false,false);
		if (empty($fecha) or $fecha == '0000-00-00' or $fecha == '0000-00-00 00:00:00') { 
			return '0000-00-00 00:00:00'; 
		}
		return strftime('%d/%m/%Y',strtotime($fecha));
	}

	function strLoc($aRec,$bArray=false) {
		if (!is_array($aRec)) return $aRec;
		foreach ($aRec as $fld => $val) $aRec[$fld] = (string)$val;
		$aIdx['id_almacen_logico'] = DeliveryEntry::strFromAny($aRec,'id_almacen_logico');
		$aIdx['planta'] = DeliveryEntry::strFromAny($aRec,'planta');
		$aIdx['pasillo'] = DeliveryEntry::strFromAny($aRec,'pasillo');
		$aIdx['columna'] = DeliveryEntry::strFromAny($aRec,'columna');
		$aIdx['fila'] = DeliveryEntry::strFromAny($aRec,'fila');
		$strLoc = ( (strlen($aIdx['id_almacen_logico'])<2) ? '0' : '' ).$aIdx['id_almacen_logico'].'-'.
					( (strlen($aIdx['planta'])<2) ? '0' : '' ).$aIdx['planta'].':'.
					( (strlen($aIdx['pasillo'])<2) ? '0' : '' ).$aIdx['pasillo'].':'.
					( (strlen($aIdx['columna'])<2) ? '0' : '' ).$aIdx['columna'].':'.
					( (strlen($aIdx['fila'])<2) ? '0' : '' ).$aIdx['fila'];
		if ($bArray) return $aIdx;
		else return $strLoc;
	}

	function strFromAny($aD,$fld='id_detalle') {
		if (!is_array($aD)) return $aD;
		foreach ($aD as $fldf => $val) $aD[$fldf] = (string)$val;
		$value = ( (strlen($aD[$fld])>0) 
								? $aD[$fld] 
								: ( (strlen($aD['Detalle.'.$fld])>0)
									? $aD['Detalle.'.$fld]
									: ((strlen($aD['DetallePedido.'.$fld])>0)
											? $aD['DetallePedido.'.$fld]
											: NULL) 
									)
								);
		return $value;
	}

}

class DeliveryEntries extends IndexList {
	var $idxLocToRef = array();
	var $idxLocToRec = array();
	var $idxRefToDet = array();
	var $idxRef = array();
	var $idxCBToRef = array();
	var $bRebuilding = false;

	function DeliveryEntries ($oDelivery) {
		if (!is_object($oDelivery)) {
			$this->setFlag($this->ST_CORRUPT);
			return NULL;
		}
		$itemclass= 'DeliveryEntry';
		$aCampos['Detalles_albaran:Detalle'] = array(
			// Claves propias y foraneas:
			'id_detalle','id_albaran','estado',
			// Localizacion:
			'id_almacen_logico', 'lote', 'fecha_caducidad','planta','pasillo','fila','columna',
			// Datos
			'cantidad','stock_previsto','cantidad_devuelta','fecha_devolucion','observaciones'
			);
		$aCampos['Almacenes_logicos:Zona'] = array(
			'id_almacen_logico','nombre'
			);
		$aCampos['Lineas_detalle:DetallePedido'] = array(
			// Claves propias y foraneas
			'id_detalle','id_pedido','id_articulo','id_servicio','id_presupuesto',
			// Datos:
			'cantidad','cantidad_recibida','observaciones','oextra1','oextra2','oextra3','oextra4',
			// Condiciones de venta:
			'precio_articulo','monto','descuento','monto_total'
			);
		$aCampos['Articulos:Producto'] = array(
			// Claves propias y foraneas
			'id_articulo','id_marca','id_familia','id_unidad_medida','id_iva',
			// Datos:
			'nombre','descripcion','codigo_barras','codigo_barras_bulto','codigo_barras_palet','garantia','peso_unidad','referencia'
			);
		$aCampos['Empresas_articulos:ProductoEmpresa'] = array(
			// Claves propias y foraneas
			'id_articulo','id_empresa',
			// Datos:
			'unidades_bulto','bultos_capa_palet','capas_palet','stock','stock_ficticio'
			);
		$aCampos['Familia_articulos:Familia'] = array(
			// Claves
			'id_familia',
			// Datos
			'nombre','stock','materia_prima'
		);
		$aCampos['Marcas:Marca'] = array(
			// Claves:
			'id_marca',
			// Datos:
			'nombre','observaciones'
			);
		$aCampos['Tipos_IVA:IVA'] = array(
			// Claves:
			'id_iva',
			// Datos:
			'nombre','porcentaje'
			);
		$aIndices = array('DetallePedido.id_articulo','Producto.codigo_barras','Producto.codigo_barras_bulto',
						'Producto.codigo_barras_palet','DetallePedido.id_detalle');

		return parent::IndexList($oDelivery,NULL,'Detalles_albaran',$aCampos,$aIndices,$itemclass);
	}

	function ixReferencia($val) {
		return $this->getFromIndex('DetallePedido.id_articulo',$val);
	}

	function ixCodigoBarras($val) {
		return $this->getFromIndex('Producto.codigo_barras',$val);
	}

	function setVerified($val, $idx = NULL, $bSuma = true) {
		if (!is_numeric($idx)) $idx = $this->getActiveItem();
		if (!is_numeric($idx)) return NULL;
		if (!is_object($this->aoItems[$idx])) return NULL;
		$rval = $this->aoItems[$idx]->setVerified($val,$bSuma);
		return $rval;
	}

	function getVerified($idx = NULL) {
		if (!is_numeric($idx)) $idx = $this->getActiveItem();
		if (!is_numeric($idx)) return NULL;
		if (!is_object($this->aoItems[$idx])) return NULL;
		return $this->aoItems[$idx]->getVerified();
	}

	function getDate($idx = NULL) {
		if (!is_numeric($idx)) $idx = $this->getActiveItem();
		if (!is_numeric($idx)) return NULL;
		if (!is_object($this->aoItems[$idx])) return NULL;
		return $this->aoItems[$idx]->getDate();
	}

	function check($cnt,$bSuma = NULL,$idx=NULL) {
		if (!is_numeric($idx)) $idx = $this->getActiveItem();
		if (!is_numeric($idx)) return NULL;
		return $this->aoItems[$idx]->check($cnt,$bSuma);
	}

	function insert($aD) {
		$this->debug("first sizeOf aoItems: ".sizeof($this->aoItems),'insert');
		$strLoc = DeliveryEntry::strLoc($aD);
		$id_detalle = DeliveryEntry::strFromAny($aD,'id_detalle');
		if (isset($aD['cantidad']) and !isset($aD['stock_previsto'])) $aD['stock_previsto']=$aD['cantidad'];
		$this->debug(array("El id_detalle de entrada: ".$id_detalle=>$this->idxLocToRec[$strLoc]),'insert');
		if (is_array($this->idxLocToRec[$strLoc]) and sizeof($this->idxLocToRec[$strLoc]))
			foreach ($this->idxLocToRec[$strLoc] as $idx) {
				$this->debug("analizando $strLoc  el idx $idx .  $id_detalle / ".DeliveryEntry::strFromAny($this->getDetailVector($idx),'id_detalle'),'insert');
				// Ya sabemos que la localizacion coincide.
				if ($id_detalle == DeliveryEntry::strFromAny($this->getDetailVector($idx),'id_detalle')) {
					$this->debug(array("La loca es $strLoc y el idx $idx  con Det: "=>$this->getData(NULL,$idx)),'insert');
					// Coincide la localizacion y el detalle.
					if (Wherehouse::__compareLocation($aD,$this->getData(NULL,$idx),true)) {
						$this->debug(array("COINCIDE con el idx $idx este : "=>$aD,"IDX $idx"=>$this->getData(NULL,$idx)),'insert');
						$cnt_pte = $this->getAttribute('stock_previsto',NULL,$idx) - $this->getAttribute('cantidad',NULL,$idx);
						$cnt = $this->getAttribute('cantidad',NULL,$idx)+$aD['cantidad'];
						if ($aD['stock_previsto']>$cnt_pte) $aD['stock_previsto'] -= $cnt_pte;
						else $aD['stock_previsto'] = 0;
						$cnt_prev = $this->getAttribute('stock_previsto',NULL,$idx)+$aD['stock_previsto'];
						$aD['cantidad'] = $cnt;
						$aD['stock_previsto'] = $cnt_prev;
						$rval = $this->update($aD,NULL,$idx);
						$this->debug("El rval del update es $rval ",'insert');
						return $idx;
					}
				}
			}
		$this->debug(array(" Insert adecuado. Con eto: "=>$aD),'insert');
		if (!empty($aD['stock_previsto']) && $aD['stock_previsto']>0 && !$this->bRebuilding) {
			$to_substract = $aD['stock_previsto'];
			$aTmp = $this->ixReferencia($aD['id_articulo']);
			debug("Nueva referencia. Intentaremos retirar $to_substract stock_previsto ");
			if (is_array($aTmp) and sizeof($aTmp))
			foreach ($aTmp as $tmpidx) {
				$cnt_pte = $this->getAttribute('stock_previsto',NULL,$tmpidx) - $this->getAttribute('cantidad',NULL,$tmpidx);
				if ($cnt_pte<=0) continue;
				if ($cnt_pte>$to_substract) {
					$cnt_update = ($this->getAttribute('stock_previsto',NULL,$tmpidx)-$to_substract);
					debug("Ya esta. Del idx $tmpidx retiramos todo : $to_substract stock_previsto sera $to_substract ");
					$to_substract = 0;
				} else {
					$cnt_update = ($this->getAttribute('stock_previsto',NULL,$tmpidx)-$cnt_pte);
					$to_substract -= $cnt_pte;
					debug("suma y sigue .. en el idx $tmpidx retiramos el pte: $cnt_pte stock_prvisto sera: ".$to_substract);
				}
				$this->setAttribute('stock_previsto',$cnt_update,NULL,$tmpidx);
				if ($to_substract<=0) break;
			}
		}
		$this->debug("sizeOf aoItems: ".sizeof($this->aoItems),'insert');
		$tmpidx = parent::insert($aD);
		$this->debug("DeliveryEntry::insert() - last not least, newid: ".$tmpidx,'insert');
		return $tmpidx;
	}

	function update($aD,$ent='__main__',$bF=false) {
		$rval = parent::update($aD,$ent,$bF);
		return $this->postUpdate($rval);
	}

	function postUpdate($rval) {
		if ($rval) {
			//debug("DeliveryEntries::<b>POST-UPDATE</b>()");
			$this->buildIndex();
		}
		return $rval;
	}
	function postFill($rval) {
		if ($rval) {
			$this->resetDBOrig();
			$this->buildIndex();
			$this->firstItem();
		}
		return $rval;
	}

	function buildIndex() {
		$this->idxLocToRec = array();
		$this->idxRefToDet = array();
		$this->idxRef = array();
		$this->idxCBToRef = array();
		for ($i=$this->firstItem(); isset($i); $i = $this->nextItem()) {
			$strLoc = DeliveryEntry::strLoc($this->getData(NULL,$i));
			if (!is_array($this->idxLocToRec[$strLoc])) $this->idxLocToRec[$strLoc] = array();
			array_push($this->idxLocToRec[$strLoc],$i);
			$id_det = $this->getAttribute('id_detalle',NULL,$i);
			$id_a = $this->getAttribute('id_articulo','DetallePedido',$i);
			if (!is_array($this->idxRefToDet[$id_a])) $this->idxRefToDet[$id_a] = array();
			array_push($this->idxRefToDet[$id_a],$id_det);
			if (!is_array($this->idxRef[$id_a])) $this->idxRef[$id_a] = array();
			array_push($this->idxRef[$id_a],$i);
			// Codigo de Barras
			$id_cb = $this->getAttribute('codigo_barras','Producto',$i);
			if (!is_array($this->idxCBToRef[$id_cb])) $this->idxCBToRef[$id_cb] = array();
			else {
				$bFound = false;
				foreach ($this->idxCBToRef[$id_cb] as $aTemp) 
					if ($aTemp['id']==$id_a) { 
						$bFound = true;
						continue;
					}
				if ($bFound) continue;
			}
			$aTmp = array('id'=>$id_a,'cnt'=>1);
			array_push($this->idxCBToRef[$id_cb],$aTmp);
			$id_cb = NULL;
			$cnt_bulto = $this->getAttribute('unidades_bulto','ProductoEmpresa',$i);
			$id_cb = $this->getAttribute('codigo_barras_bulto','Producto',$i);
			if (is_numeric($id_cb)) {
				if (!is_array($this->idxCBToRef[$id_cb])) $this->idxCBToRef[$id_cb] = array();
				else {
					$bFound = false;
					foreach ($this->idxCBToRef[$id_cb] as $aTemp) 
						if ($aTemp['id']==$id_a) { 
							$bFound = true;
							continue;
						}
					if ($bFound) continue;
				}
				$aTmp = array('id'=>$id_a,'cnt'=>$cnt_bulto);
				array_push($this->idxCBToRef[$id_cb],$aTmp);
			}
			$id_cb = NULL;
			$id_cb = $this->getAttribute('codigo_barras_palet','Producto',$i);
			$cnt_palet = $cnt_bulto*$this->getAttribute('bultos_capa_palet','ProductoEmpresa',$i)*
							$this->getAttribute('capas_palet','ProductoEmpresa',$i);
			if (is_numeric($id_cb)) {
				if (!is_array($this->idxCBToRef[$id_cb])) $this->idxCBToRef[$id_cb] = array();
				else {
					$bFound = false;
					foreach ($this->idxCBToRef[$id_cb] as $aTemp) 
						if ($aTemp['id']==$id_a) { 
							$bFound = true;
							continue;
						}
					if ($bFound) continue;
				}
				$aTmp = array('id'=>$id_a,'cnt'=>$cnt_palet);
				array_push($this->idxCBToRef[$id_cb],$aTmp);
			}
			$id_cb = NULL;
		}
	}

	function resetDBOrig() {
		for ($idx = $this->firstItem(); isset($idx); $idx = $this->nextItem()) {
			$cnt = $this->getAttribute('cantidad');
			$this->setAttribute('cantidad_dborig',$cnt,NULL,NULL,true,false);
			$cnt = $this->getAttribute('stock_previsto');
			$this->setAttribute('stock_previsto_dborig',$cnt,NULL,NULL,true,false);
			$cnt = $this->getAttribute('cantidad_devuelta');
			$this->setAttribute('cantidad_devuelta_dborig',$cnt,NULL,NULL,true,false);
		}
	}

	/**
	 *Este metodo actualiza la lista completa de detalles a partir de una matriz, computando los cambios como diferencias entre
	 * 	la matriz recibida, y la matriz obtenida en primera instancia. 
	 * Este problema surge dado que los cambios en 1 registro pueden modificar otros registros, pudiendo pisarse si se 
	 * 	toman las modificaciones como valores absultos, en lugar de alteraciones relativas.
	 */
	function updateList($mDet) {
		if (!is_array($mDet) or !sizeof($mDet)) return false;
		$this->debug("FixMe: anyadir comprobacion. if preparado, no permitir modificar cantidades,SKUs ni Localizaciones",'updateList');

		// Primero obtenemos los valores Iniciales de Trabajo.
		for ($idx = $this->firstItem(); isset($idx); $idx = $this->nextItem()) {
			$mOrig[$idx] = $this->getData(NULL,$idx);
			//No debug needed: 
			//$this->debug(array("mOrig[$idx]"=>$mOrig[$idx]),'updateList');
		}

		foreach ($mDet as $idx => $aDet) {
			$aTmpK = array_keys($aDet);
			$bMulti = true;
			foreach ($aTmpK as $k) 
				if (!is_numeric($k)) {
					$bMulti = false;
					break;
				}
			if ($bMulti) {
				$aDetList = array();
				foreach ($aDet as $tmpidx => $aD) {
					if (!is_numeric($aD['id_almacen_logico']) and !is_numeric($aD['planta']) and !is_numeric($aD['pasillo'])
						and !is_numeric($aD['columna']) and !is_numeric($aD['fila'])) {
						$aD['id_almacen_logico'] = $mOrig[$idx]['id_almacen_logico'];
						$aD['planta'] = $mOrig[$idx]['planta'];
						$aD['pasillo'] = $mOrig[$idx]['pasillo'];
						$aD['columna'] = $mOrig[$idx]['columna'];
						$aD['fila'] = $mOrig[$idx]['fila'];
					} elseif (!is_numeric($aD['id_almacen_logico']) or !is_numeric($aD['planta']) or !is_numeric($aD['pasillo'])
						or !is_numeric($aD['columna']) or !is_numeric($aD['fila'])) {
						debug("Error: Localizacion incompleta. ");
						continue;
					}
					if (Wherehouse::__compareLocation($aD,$mOrig[$idx],true)) {
						// Misma Localizacion
						$aD['__add'] = true;
					}
					array_push($aDetList,$aD);
				}
			} else $aDetList = array($aDet);

			foreach ($aDetList as $aTmp) {
				$aTmp['stock_previsto'] = NULL;
				unset($aTmp['stock_previsto']);

				$bChange = false;
				foreach ($aTmp as $fld => $val) {
					if (strstr($fld,'stock_previsto')) continue;
					if ($fld == 'fecha_caducidad') {
						$mOrig[$idx][$fld] = wol_db::formatear_fecha($mOrig[$idx][$fld],false,false);
						$val = wol_db::formatear_fecha($val,false,false);
					}
					if (isset($mOrig[$idx][$fld]) and $mOrig[$idx][$fld] != $val) {
						$bChange = true;
						$this->debug("Hay cambio en $fld entre $val y ".$mOrig[$idx][$fld],'updateList');
						break;
					}
				}
				if (!$bChange and !$aTmp['__add']) {
					$this->debug("... sin cambios para $idx (skip) chkcnt == ".$aTmp['cantidad']." orig: ".$mOrig[$idx]['cantidad'],
									'updateList');
					continue;
				}
				$cnt_orig = $mOrig[$idx]['cantidad'];
				// FixMe: Esta comprobacion solo sirve para cuando de la linea esta, target de otra modificacion, solo
				// se modifica la cantidad, si se quiere desplazar stock, la cantidad que viene es lo que se cuenta para
				// desplazar. (done)
				$this->debug(array('aInput'=>$aTmp, "mOrig[$idx]" => $mOrig[$idx], 
								'aInput_fmtfecha' => wol_db::formatear_fecha($aTmp['fecha_caducidad'],false,false),
								'mOrig_fmtfecha' => wol_db::formatear_fecha($mOrig[$idx]['fecha_caducidad'],false,false),
								'Resultado de comparar localizaciones: '.
										Wherehouse::__compareLocation($aTmp,$mOrig[$idx],true)),'updateList');
				if ($cnt_orig!=$aTmp['cantidad'] and !Wherehouse::__compareLocation($aTmp,$mOrig[$idx],true) ) {
					$cnt_act = $this->getAttribute('cantidad',NULL,$idx);
					$this->debug("La cantidad($idx) va a ser = $cnt_act + ( ".$aTmp['cantidad']." - $cnt_orig ) ",'updateList');
					$aTmp['cantidad'] = $cnt_act + ($aTmp['cantidad'] - $cnt_orig);
				} elseif ($aTmp['__add']) {
					$cnt_act = $this->getAttribute('cantidad',NULL,$idx);
					$aTmp['cantidad'] += $cnt_act;
					$this->debug("Hemos sumado las $cnt_act que ya habia y ahora tenemos: ".$aTmp['cantidad'],'updateList');
				} else $this->debug("Sin tocar la cantidad, que se queda en :".$aTmp['cantidad'],'updateList');
				$this->debug(array('<b>Update</b>! '=>$aTmp),'updateList');
				$this->update($aTmp,NULL,$idx);
			}
		}
		return true;
	}

	function getDetailVector($idx = NULL) {
		$aDetalle = $this->getData(NULL,$idx);
		if (!is_array($aDetalle) or !sizeof($aDetalle)) return NULL;
		// $this->debug(array('Detalle: ',$aDetalle),'getDetailVector');
		//if ($this->isSale()) 
		if (true) {
			$aDetalle['cantidad_pendiente'] = $aDetalle['stock_previsto'] - $aDetalle['cantidad'];
		} else {
			/** Uniformando tratamiento de Compras por el de Ventas **/
			// $aDetalle['cantidad_pendiente'] = $aDetalle['cantidad'] - $aDetalle['stock_previsto'];
			$aDetalle['cantidad_pendiente'] = $aDetalle['stock_previsto'] - $aDetalle['cantidad'];
		}

		// $this->debug("Obteniendo de $idx ",'getDetailVector');
		// Formateando fecha:
		if ( empty($aDetalle['fmt_fecha_caducidad']) ) {
			$aFmt['fecha'] = $this->getDate($idx);
			$aTmpF = split("/",$aFmt['fecha']);
			if (is_array($aTmpF) and sizeof($aTmpF)>1) {
				$aDetalle['fmt_fecha_caducidad_dia'] = $aTmpF[0];
				$aDetalle['fmt_fecha_caducidad_mes'] = $aTmpF[1];
				$aDetalle['fmt_fecha_caducidad_ano'] = $aTmpF[2];
				$aDetalle['fmt_fecha_caducidad'] = $aFmt['fecha'];
			}
		}

		$aDetPed = $this->getData('DetallePedido',$idx);
		$aProd = $this->getData('Producto',$idx);
		$aFam = $this->getData('Familia',$idx);
		$aMca = $this->getData('Marca',$idx);
		$aZna = $this->getData('Zona',$idx);
		$aR = array();
		foreach ($aDetalle as $fld => $val) $aR['Detalle.'.$fld] = $val;
		foreach ($aDetPed as $fld => $val) $aR['DetallePedido.'.$fld] = $val;
		foreach ($aProd as $fld => $val) $aR['Producto.'.$fld] = $val;
		foreach ($aFam as $fld => $val) $aR['Familia.'.$fld] = $val;
		foreach ($aMca as $fld => $val) $aR['Marca.'.$fld] = $val;
		if (sizeof($aZna)) { foreach ($aZna as $fld => $val) $aR['Zona.'.$fld] = $val; }
		return $aR;
	}

}

class DeliveryNote extends dbItemMultiEntity {
	var $oDetails = NULL;
	var $bVenta = -1;
	var $oAlmacen = NULL;
	var $aoBajas = NULL;
	var $aoFacturas = NULL;

	function DeliveryNote( $AppName = NULL, $dbname = 'data', $aData = NULL) {

		if (empty($AppName)) $AppName = $GLOBALS['APP_NAME'];
		if (empty($dbname)) $dbname = 'data';
		$tabla = 'Albaranes';

		$aFlds['Albaranes:Albaran'] = array(
			// Claves, propia y foraneas
			'id_albaran', 'id_transportista', 'id_pedido', 'id_direccion', 'id_almacen', 
			// Fechas
			'fecha','id_dia','fecha_preparado','id_dia_preparado','fecha_envio','id_dia_envio','fecha_recepcion','id_dia_recepcion',
			// Estados
			'preparado','enviado','confirmacion','devolucion',
			// Datos propiamente dicho
			'referencia','referencia_externa','observaciones','bultos'
			);
		$aFlds['Transportistas:Transportista'] = array(
			// Claves
			'id_transportista',
			// Datos
			'nombre','apellidos','razon_social','cif','direccion','poblacion','cp','telefono','telefono2','fax','email',
			'iban','bic','bban','entidad','dc_ccc','oficina','cuenta_bancaria'
			);
		$aFlds['Pedidos:Pedido'] = array(
			// Claves
			'id_pedido','id_empresa','id_direccion','id_proveedor',
			// Datos
			'referencia','referencia_externa','nombre','observaciones','fecha','id_dia','preparado','id_pedido_incompleto','residual'
			);
		$aFlds['Empresas:Empresa'] = array(
			// Claves
			'id_empresa',
			// Datos
			'nombre','apellidos','razon_social','direccion_facturacion','cp','email','web','poblacion','telefono1','telefono2',
			'fax','stock_negativo',
			// Contadores
			'prefijo_alb_ventas','sufijo_alb_ventas','digitos_alb_ventas',
			'prefijo_alb_compras','sufijo_alb_compras','digitos_alb_compras',
			);
		$aFlds['Direcciones_entrega:Destino'] = array(
			// Claves
			'id_direccion','id_cliente','id_provincia','id_transportista',
			// Datos
			'nombre','direccion','cp','poblacion','email','telefono1','fax','persona_contacto','cargo_persona_contacto','observaciones'
			);
		$aFlds['Clientes:Cliente'] = array(
			// Claves
			'id_cliente','id_divisa',
			// Datos
			'razon_social','prefijo_cif','cif','nombre','apellidos','direccion_facturacion','cp',
			'poblacion','id_provincia','email','telefono1','telefono2','fax'
			);
		$aFlds['Proveedores:Proveedor'] = array(
			// Claves
			'id_proveedor','id_divisa',
			// Datos
			'razon_social','prefijo_cif','cif','nombre','apellidos','domicilio','cp',
			'poblacion','id_provincia','email','telefono1','telefono2','fax'
			);
		$aFlds['Almacenes:Origen'] = array(
			// Claves
			'id_almacen', 'id_empresa', 'id_provincia',
			// Datos
			'nombre','direccion','cp','poblacion','telefono','fax','email','nota_pie_albaran','persona_contacto','cargo_persona_contacto'
			);

		$aAcciones['id_transportista'] = array('method' => 'updateForeignKey');
		$aAcciones['id_almacen'] = array('method' => 'updateWherehouse');
		// TODO: En este caso, usar un metodo que cambie tambien la direccion o proveedor. (no permitir cambiar la empresa)
		$aAcciones['id_pedido'] = array('method' => 'changeOrder');
		// TODO: Cuando se cambia la direccion, hay que cambiar tambien el cliente.
		$aAcciones['id_direccion'] = array('method' => 'updateForeignKey');
		$aAcciones['preparado'] = array('method' => 'updateStatus');
		$aAcciones['enviado'] = array('method' => 'updateStatus');
		$aAcciones['confirmacion'] = array('method' => 'updateStatus');
		$aAcciones['id_proveedor'] = array('method' => 'updateSuplier');

		if (!parent::dbItemMultiEntity($AppName,$dbname,$tabla,$aFlds,$aData,$aAcciones)) {
			$this->setFlag($this->ST_CORRUPT);
			return false;
		}

	}

	/** Metodos para una clase dbItemMultiEntityWithIndexList 
		TODO:
		Lo suyo seria, crear una clase que permita indicarle en el constructor las distintas
		variables contenedores de listas indexadas y sus respectivas clases. Pudiendo activar
		una u otra, para que las llamadas a los metodos 'permeados' de la clase IndexList, si 
		no se le indica objeto de trabajo, pille el 'activo' en dicho momento.
	 **/
	function &getDetails() {
		$this->_factoryEntries();
		return $this->oDetails;
	}

	function updateDetails($mDet) {
		$oDet = &$this->getDetails();
		return $oDet->updateList($mDet);
	}

	function _factoryEntries() {
		$bCreate = false;
		$id = $this->getAttribute('id_albaran');
		if (!is_a($this->oDetails,'DeliveryEntries')) {
			$bCreate = true;
		} else {
			$n = $this->countDetails();
			if ($n>0 AND is_numeric($id) AND !empty($id)) {
				$idx = $this->firstDetail(false,true);
				//$this->debug("idx: $idx .. ",'_factoryEntries');
				$idn = $this->getDetailAttribute('id_albaran',NULL,$idx);
				//$this->debug("id_albaran nuevo: $idn ",'_factoryEntries');
				if ($idn != $id) {
					// Vamos a crear una instancia nueva, olvidando la anterior.
					$bCreate = true;
				}
			}
		}
		if ($bCreate) {
			$this->debug('Reconstruyendo DeliveryEntries','_factoryEntries');
			$this->oDetails = new DeliveryEntries($this);
//			$rval = $this->oDetails->setParentHook(&$this);
			$rval = $this->oDetails->setParentHook($this);
			if (is_numeric($id) AND !empty($id)) $this->oDetails->dbFill(array('id_albaran' => $id));
		}
		return is_object($this->oDetails);
	}

	function delete() {
		$rval = true;
		$this->_factoryEntries();
		for ($idx = $this->firstDetail(); isset($idx); $idx = $this->nextDetail()) {
			if (!$this->deleteDetail($idx)) {
				$rval = false;
				break;
			}
		}
		if ($rval) $rval = parent::delete();

		return $rval;
	}
	/** Fin de metodos para una clase dbItemMultiEntityWithIndexList **/

	/** Metodos permeados para los detalles (IndexList) **/
	function firstDetail($bMove = true) {
		// $this->debug("oDetails : ".$this->oDetails,'firstDetail');
		if (!is_a($this->oDetails,'DeliveryEntries')) $this->_factoryEntries();
		return ( (is_a($this->oDetails,'DeliveryEntries')) ? $this->oDetails->firstItem($bMove) : NULL );
	}

	function nextDetail($bMove = true) {
		if (!is_a($this->oDetails,'DeliveryEntries')) $this->_factoryEntries();
		return ( (is_a($this->oDetails,'DeliveryEntries')) ? $this->oDetails->nextItem($bMove) : NULL );
	}

	function previousDetail($bMove = true) {
		if (!is_a($this->oDetails,'DeliveryEntries')) $this->_factoryEntries();
		return ( (is_a($this->oDetails,'DeliveryEntries')) ? $this->oDetails->previousItem($bMove) : NULL );
	}

	function lastDetail($bMove = true) {
		if (!is_a($this->oDetails,'DeliveryEntries')) $this->_factoryEntries();
		return ( (is_a($this->oDetails,'DeliveryEntries')) ? $this->oDetails->lastItem($bMove) : NULL );
	}

	function currentDetail() {
		if (!is_a($this->oDetails,'DeliveryEntries')) $this->_factoryEntries();
		return ( (is_a($this->oDetails,'DeliveryEntries')) ? $this->oDetails->currentItem() : NULL );
	}

	function checkDetailPosition($idx,$bCheckDeleted = true) {
		if (!is_a($this->oDetails,'DeliveryEntries')) $this->_factoryEntries();
		return ( (is_a($this->oDetails,'DeliveryEntries')) ? $this->oDetails->checkItemPosition($idx,$bCheckDeleted) : NULL );
	}

	function setActiveDetail($idx) {
		if (!is_a($this->oDetails,'DeliveryEntries')) $this->_factoryEntries();
		return ( (is_a($this->oDetails,'DeliveryEntries')) ? $this->oDetails->setActiveItem($idx) : NULL );
	}

	function countDetails($bCountDel = false) {
		if (!is_a($this->oDetails,'DeliveryEntries')) $this->_factoryEntries();
		return ( (is_a($this->oDetails,'DeliveryEntries')) ? $this->oDetails->countItems($bCountDel) : NULL );
	}

	function setDetailFlag($flag,$idx = NULL) {
		return ( (is_a($this->oDetails,'DeliveryEntries')) ? $this->oDetails->setFlag($flag,$idx) : NULL );
	}

	function unsetDetailFlag($flag,$idx = NULL) {
		return ( (is_a($this->oDetails,'DeliveryEntries')) ? $this->oDetails->unsetFlag($flag,$idx) : NULL );
	}

	function checkDetailFlag($flag,$idx = NULL) {
		return ( (is_a($this->oDetails,'DeliveryEntries')) ? $this->oDetails->checkFlag($flag,$idx) : NULL );
	}

	function checkDetailQuantity($cnt,$idx = NULL) {
		return ( (is_a($this->oDetails,'DeliveryEntries')) ? $this->oDetails->check($cnt,$idx) : NULL );
	}

	function newDetail($aData) {
		$this->_factoryEntries();
		$oDet = &$this->getDetails();
		if (empty($aData['id_detalle']) and empty($aData['DetallePedido.id_detalle']) and empty($aData['DetallePedido.id_articulo']) and empty($aData['id_articulo'])) {
			$this->debug("Error: No se puede insertar un detalle sin id_detalle ni id_articulo. ",'newDetail');
			return NULL;
		} elseif (empty($aData['id_detalle'])) {
			$id_art = ( (!empty($aData['id_articulo'])) ? $aData['id_articulo'] : $aData['DetallePedido.id_articulo'] );
			if (empty($aData['DetallePedido.id_articulo'])) $aData['DetallePedido.id_articulo'] = $id_art;
			$this->debug(array("Sin id_detalle => referencia  $id_art rec : "=>$aData),'newDetail');

			$oPed = new Document ($this->getAppName(),$this->getDbName(),( ($this->bVenta) ? inmPed_VENTA : inmPed_COMPRA ));
			if (is_object($oPed)) {
				$bDone = false;
				if ($this->bVenta) {
					$idemp = $this->getAttribute('id_empresa','Empresa');
					$idcli = $this->getAttribute('id_cliente','Destino');
					if ($oPed->set_issuer($idemp) and $oPed->set_reciever($idcli)) $bDone = true;
				} else {
					$idemp = $this->getAttribute('id_empresa','Empresa');
					$idprv = $this->getAttribute('id_proveedor','Origen');
					if ($oPed->set_issuer($idprv) and $oPed->set_reciever($idemp)) $bDone = true;
				}

				$retval = $oDet->insert($aData);
				if ($bDone) {
					$this->debug('Actualizando precios para: '.$retval,'newDetail');
					$oI = &$this->getDetail($retval);
					$aArt = $oPed->_get_article_conditions($id_art);
					$aArt['stock'] = $aArt['control_stock'];
					$aArt['stock_ficticio'] = $aArt['stock_estimado'];
					$aArt['precio_articulo'] = $aArt['precio_tarifa'];
					$oI->update($aArt,'DetallePedido');
					$oI->update($aArt,'Producto');
					$oI->setAttribute('stock_real',$aArt['stock_real'],'Producto',true);
					$oI->update($aArt,'ProductoEmpresa');
					if (!empty($aArt['id_familia'])) $oI->updateForeignKey($aArt['id_familia'],'id_familia');
					if (!empty($aArt['id_marca'])) $oI->updateForeignKey($aArt['id_marca'],'id_marca');
					if (!empty($aArt['id_almacen_logico'])) $oI->updateForeignKey($aArt['id_almacen_logico'],'id_almacen_logico');
					$this->debug(array("El producto: "=>$oI->getData('Producto')),'newDetail');
				}
				return $retval;
			}
		} else {
			//$aData['DetallePedido.id_detalle'] = $aData['id_detalle'];
			return $oDet->insert($aData);
		}
	}

	function updateDetail($aVal,$entidad = 'main',$idx = NULL) {
		$this->_factoryEntries();
		return $this->oDetails->update($aVal,$entidad,$idx);
	}

	function deleteDetail($idx = NULL) {
		return ( (is_a($this->oDetails,'DeliveryEntries')) ? $this->oDetails->delete($idx) : NULL );
	}

	function undeleteDetail($idx = NULL) {
		return ( (is_a($this->oDetails,'DeliveryEntries')) ? $this->oDetails->undelete($idx) : NULL );
	}

	function isDeletedDetail($idx = NULL) {
		return ( (is_a($this->oDetails,'DeliveryEntries')) ? $this->oDetails->isDeleted($idx) : NULL );
	}

	function setDetailAttribute($campo , $valor, $entidad = NULL, $idx = NULL, $bForce = NULL, $bMarkIfChanged = NULL) {
		return ( (is_a($this->oDetails,'DeliveryEntries')) ? 
					$this->oDetails->setAttribute($campo,$valor,$entidad,$idx,$bForce,$bMarkIfChanged) : NULL);
	}

	function getDetailAttribute($campo = NULL, $entidad = NULL, $idx = NULL) {
		// $this->debug("Get data con: ".$this->oDetails,'getDetailAttribute');
		return ( (is_a($this->oDetails,'DeliveryEntries')) ? $this->oDetails->getAttribute($campo,$entidad,$idx) : NULL);
	}

	function getDetailDate($idx = NULL) {
		return ( (is_a($this->oDetails,'DeliveryEntries')) ? $this->oDetails->getDate($idx) : NULL);
	}

	function getDetailData($entidad = NULL, $idx = NULL) {
		// $this->debug("Get data con: ".$this->oDetails,'getDetailData');
		if (!is_a($this->oDetails,'DeliveryEntries')) $this->_factoryEntries();
		return ( (is_a($this->oDetails,'DeliveryEntries')) ? $this->oDetails->getData($entidad,$idx) : NULL);
	}

	function getDetailVector($idx = NULL) {
		$this->_factoryEntries();
		return $this->oDetails->getDetailVector($idx);
	}

	function &getDetail($idx) {
		$this->_factoryEntries();
		return $this->oDetails->getItem($idx);
	}
	/* Fin de metodos permeados */

	/* Metodos Propios */
	function hookWherehouse(&$oAlmacen) {
		if (!is_a($oAlmacen,'Wherehouse')) return false;
		$this->oAlmacen = &$oAlmacen;
		return true;
	}

	function &getWherehouse() {
		if (!is_a($this->oAlmacen,'Wherehouse')) {
			$idalm = $this->getAttribute('id_almacen');
			if (!empty($idalm)) {
				$this->oAlmacen = new Wherehouse($this->getAppName(),$this->getDbName());
				$this->oAlmacen->dbFill($idalm);
			}
		}
		return $this->oAlmacen;
	}

	function getId() {
		return $this->getAttribute('id_albaran');
	}

	function updateOrder($valor,$campo = 'id_pedido') {
		$origval = $this->getAttribute('id_pedido');
		if ($origval != $valor) {
			$bDone = $this->updateForeignKey($valor,$campo);
			if ($bDone) {
				$id_dir = $this->getAttribute('id_direccion','Pedido');
				$id_prov = $this->getAttribute('id_proveedor','Pedido');
				$id_emp = $this->getAttribute('id_empresa','Pedido');
				if (!$id_prov) {
					$bDone = $this->updateForeignKey($id_dir,'id_direccion');
					$id_cli = $this->getAttribute('id_cliente','Direccion');
					if (is_numeric($id_cli) AND $bDone) $this->updateForeignKey($id_cli,'id_cliente');
					$this->setAttribute('id_direccion',$id_dir);
					$this->bVenta = 1;
				} else {
					$bDone = $this->updateForeignKey($id_prov,'id_proveedor');
					$this->setAttribute('id_proveedor',$id_prov);
					$this->bVenta = 0;
				}
				if ($bDone) $bDone = $this->updateForeignKey($id_emp,'id_empresa');
			}
		}
		return $bDone;
	}

	function updateWherehouse($valor,$campo = 'id_almacen') {
		$origval = $this->getAttribute('id_almacen');
		if ($origval != $valor) {
			$bDone = $this->updateForeignKey($valor,$campo);
			if ($bDone) {
				$id_emp = $this->getAttribute('id_empresa','Origen');
				if ($bDone) $bDone = $this->updateForeignKey($id_emp,'id_empresa');
			}
		}
		return $bDone;
	}

	function updateSuplier($valor,$campo = 'id_proveedor') {
		if ($this->bVenta) return false;
		$origval = $this->getAttribute('id_proveedor');
		if ($origval != $valor) {
			$bDone = $this->updateForeignKey($valor,$campo);
			if ($bDone) {
				$aD = $this->getData('Proveedor');
				$this->update($aD,'Origen',true);
			}
		}
		return $bDone;
	}

	function updateStatus($valor,$campo = 'preparado') {
		if (!is_numeric($valor) and !is_bool($valor)) return false;
		$val_ant = $this->getAttribute($campo);
		// $this->debug("campo $campo tenia $val_ant y ahora $valor",'updateStatus');
		if ((bool)$val_ant == (bool)$valor) return false;
		switch ($campo) {
			case 'preparado':
				$rval = $this->setAttribute('preparado',(int)(bool)$valor);
				// $this->debug("rval del set preparado: $rval ",'updateStatus');
				if ($rval) {
				  if ((bool)$valor) $this->setDate('now','preparado');
				  else $this->setDate('null','preparado');
				}
				break;

			case 'enviado':
				$rval = $this->setAttribute('enviado',(int)(bool)$valor);
				if ($rval) {
					if ((bool)$valor)	$this->setDate('now','enviado');
					else $this->setDate('null','enviado');
				}
				break;

			case 'confirmacion':
				$rval = $this->setAttribute('recepcion',(int)(bool)$valor);
				if ($rval) {
					if ((bool)$valor) $this->setDate('now','recepcion');
					else $this->setDate('null','recepcion');
				}
				break;

		}
		return $rval;
	}

	function changeOrder($valor,$campo = 'id_pedido') {
		$this->debug("Actualizando ... ? ",'changeOrder');
		$bChg = $this->updateOrder($valor,$campo);
		if ($bChg) {
			debug("TODO: Pedido cambiando ... vamos a por los detalles ... ");
		}
	}

	function factoryFromDocument($id = NULL,$dbname = 'data', $AppName = NULL) {
		if (empty($AppName)) $AppName = $GLOBALS['APP_NAME'];
		if (empty($dbname)) $dbname = 'data';
		if ($this) {
			$id_almacen = $this->getAttribute('id_almacen');
			if (!is_numeric($id)) $id = $this->getAttribute('id_pedido');
			$oDb = &$this->getDb();
			$oTmpDet = $this->getDetails();
		} else {
			$oDb = &$GLOBALS[$GLOBALS['APP_NAME']]->get_db($dbname);
			$oTmpDelivery = new DeliveryNote($AppName,$dbname);
			$oTmpDet = &$oTmpDelivery->getDetails();
		}
		if (!is_numeric($id)) return NULL;
		if (!$oTmpDet->countItems()) {
			$tmpidx = $oTmpDet->insert(array('id_detalle' => 0));
			DeliveryNote::debug("insertamos un detalle nulo para tener instancia (".$tmpidx.") ",'DeliveryNote::factoryFromDocument');
		} else $tmpidx = $oTmpDet->firstItem();
		$oTmpDetItem = &$oTmpDet->getItem($tmpidx);

		// TODO: Esta pendiente un tratamiento de los servicios.

		$extra_select = NULL;
		$aDesc = array( array('entidad' => 'DetallePedido', 'alias' => 'Ld', 'fldalias' => 'det_'), 
							array('entidad' => 'Producto', 'fldalias' => 'art_', 'alias' => 'A'),
							array('entidad' => 'Familia', 'fldalias' => 'fam_', 'alias' => 'F'), 
							array('entidad' => 'Zona', 'fldalias' => 'zna_', 'alias' => 'AL'), 
							array('entidad' => 'Marca', 'fldalias' => 'mca_', 'alias' => 'M'));
		foreach ($aDesc as $aDescI) {
			$aTmp = $oTmpDetItem->getEntityDesc(NULL,$aDescI['entidad']);
			$aFlds = array_keys($aTmp);
			foreach ($aFlds as $fld) 
				$extra_select .= ( (!empty($extra_select)) ? ', ' : '' ).$aDescI['alias'].'.'.$fld.' as "'.$aDescI['fldalias'].$fld.'" ';
		}
		// Limpieza de memoria.
		$oTmpDetItem = $tmpidx = $oTmpDet = $oTmpDelivery = NULL;
		unset($oTmpDetItem,$tmpidx,$oTmpDet,$oTmpDelivery);

		$cons = 'SELECT P.id_empresa, P.id_direccion, P.id_proveedor,P.observaciones,P.referencia_externa, '.
					'Ld.id_detalle, Ld.id_articulo, Ld.id_servicio, '.
					'Ld.cantidad, SUM(IF(AA.preparado,Da.cantidad,IF(Da.stock_previsto>Da.cantidad,Da.stock_previsto,Da.cantidad))) as "cantidad_albaran", '.
					'SUM(Da.cantidad_devuelta) as "cantidad_devuelta", '.
					$extra_select.
					'FROM Lineas_detalle Ld LEFT JOIN Detalles_albaran Da ON (Da.id_detalle=Ld.id_detalle) '.
					'JOIN Pedidos P ON (Ld.id_pedido=P.id_pedido) JOIN Articulos A ON (Ld.id_articulo=A.id_articulo) '.
					'JOIN Familia_articulos F ON (F.id_familia=A.id_familia) JOIN Marcas M ON (A.id_marca=M.id_marca) '.
					'LEFT JOIN Almacenes_logicos AL ON (AL.id_almacen_logico=Da.id_almacen_logico) '.
					'LEFT JOIN Albaranes AA ON (AA.id_albaran=Da.id_albaran) '.
					'WHERE Ld.id_pedido = '.$id.' '.
					'GROUP BY Ld.id_detalle';
		// debug($cons);
		$bVenta = true;
		$detrs = $oDb->query($cons);
		if (!$oDb->num_rows($detrs)) return false;
		$texto = NULL;
		$refext = NULL;
		while ($aD = $oDb->fetch_assoc($detrs)) {
			// FixMe: Permitir configurar si se suman las cantidades devueltas en otros albaranes, y sumarlas a este, o se dejan.
			// FixMe: seguro que se suman a este ??
			if (empty($aD['id_proveedor'])) $bVenta = true;
			else $bVenta = false;
			if (empty($id_emp)) $id_emp = $aD['id_empresa'];
			// $aRefList[$aD['id_articulo']] += ( $aD['cantidad'] - ($aD['cantidad_albaran'] + $aD['cantidad_devuelta']));
			$aRefList[$aD['id_articulo']] += ( $aD['cantidad'] - ($aD['cantidad_albaran']));
			if (!strlen($texto) and strlen($aD['observaciones'])) $texto = $aD['observaciones'];
			if (!strlen($refext) and strlen($aD['referencia_externa'])) $refext = $aD['referencia_externa'];
		}
		if ($GLOBALS['DEBUG']=='ON') {
			DeliveryNote::debug(array("Lista de referencias: "=>$aRefList),'DeliveryNote::factoryFromDocument');
		}

		// TODO: Deberia existir una opcion para no generar los albaranes con localizacion, buscarlas al prepararlos.
		$oAlm = new Wherehouse ($AppName,$dbname);
		if ($bVenta) {
			$aTmp = $oAlm->getAvailableStock($aRefList,$id_almacen,$id_emp);
			if (!is_array($aTmp) or !sizeof($aTmp)) {
				DeliveryNote::debug("<b>Error</b>: No hay stock disponible. No generamos Albaranes.",'DeliveryNote::factoryFromDocument');
				return NULL;
			}
			foreach ($aTmp as $idl => $aR) 
				foreach ($aR as $ida => $cnt) {
					DeliveryNote::debug("Para la ref $ida tenemos un total de $cnt uds ",'DeliveryNote::factoryFromDocument');
					$aLoc[$idl][$ida]['cantidad'] = $cnt;
					$aLoc[$idl][$ida]['localizacion'] = array(array('cantidad' => $cnt, 'id_articulo' => $ida, 'id_almacen' => $idl, 
						'id_almacen_logico' => 0, 'lote' => NULL, 'fecha_caducidad' => NULL, 'planta' => 0, 'pasillo' => 0, 'fila' => 0, 'columna' => 0));
				}
		} else {
			$aTmp = $oAlm->getMinExpiration($aRefList,$id_almacen,$id_emp);
			foreach ($aTmp as $idl => $aR) 
				foreach ($aR as $ida => $aL) {
					DeliveryNote::debug("ref $ida , tenemos con fecha $fecha cnt: ".$aL['cantidad'],'DeliveryNote::factoryFromDocument');
					$aLoc[$idl][$ida]['cantidad'] = $aL['cantidad'];
					$aLoc[$idl][$ida]['localizacion'] = array(array('cantidad' => $aL['cantidad'], 'id_articulo' => $ida, 'id_almacen' => $idl, 
						'id_almacen_logico' => 0, 'lote' => NULL, 'fecha_caducidad' => $aL['fecha_caducidad'], 'planta' => 0, 'pasillo' => 0, 'fila' => 0, 'columna' => 0));
				}
		}
		if ($GLOBALS['DEBUG']=='ON') {
			DeliveryNote::debug(array("Localizaciones. ".count($aLoc)." Almacenes distintos. creando instancias .. "=>$aLoc),
						'DeliveryNote::factoryFromDocument');
		}
		$aRV = array();
		$aAList = array_keys($aLoc);
//		asort(&$aAList);
		asort($aAList);
		if (count($aAList) == 1) {
			$aTmp = $aAList;
			$tmpid = array_shift($aTmp);
			if (is_object($this)) {
				debug("Clase: ".get_class($this));
				$this->update(array('id_almacen'=>$tmpid));
				$aRV[$tmpid] = &$this;
			}
		}
		$oDb->data_seek($detrs,0);
		while ($aD = $oDb->fetch_assoc($detrs)) {
			// Asignando valores del resto de entidades relacionadas con el detalle.
			$aDetPed = array();
			$aArtPed = array();
			$aFamPed = array();
			$aMcaPed = array();
			foreach ($aD as $fld => $val) {
				switch (substr($fld,0,4)) {
					case 'det_':
						$aDetPed[substr($fld,4)] = $val;
						break;
					case 'art_':
						$aArtPed[substr($fld,4)] = $val;
						break;
					case 'fam_':
						$aFamPed[substr($fld,4)] = $val;
						break;
					case 'mca_':
						$aMcaPed[substr($fld,4)] = $val;
						break;
					case 'zna_':
						$aZnaPed[substr($fld,4)] = $val;
						break;
				}
			}

			// debug("<hr>Detalle: ");
			foreach ($aAList as $idalm) {
				if (!is_array($aLoc[$idalm][$aD['id_articulo']])) {
					// FixMe: Producto no encontrado, Opcion para generarlos?
					continue;
				}
				debug('IDArt '.$aD['id_articulo'].": EN el almacen $idalm tenemos ".$aLoc[$idalm][$aD['id_articulo']]['cantidad'].
						" y estamos buscando ".$aD['cantidad']);
				if ( abs($aD['cantidad']-$aLoc[$idalm][$aD['id_articulo']]['cantidad']) < pow(10,-6)) { 
					// Tenemos suficiente en este Almacen, 
					$bEnough = true;
				} else $bEnough = false;

				$oAlm = new Wherehouse ($AppName,$dbname);
				$oAlm->dbFill($idalm);

				$cantidad = $aD['cantidad'];
				foreach ($aLoc[$idalm][$aD['id_articulo']]['localizacion'] as $idx => $aL) {
					if (abs($cantidad) < pow(10,-6)) break;
					if (abs($aL['cantidad']) < pow(10,-6)) {
						debug("No hay mas que rascar de esta localizacion. ");
						continue;
					}

					if (abs($cantidad) - abs($aL['cantidad']) > pow(10,-6)) {
						$cantidad -= $aL['cantidad'];
						$cant_servir = $aL['cantidad'];
					} else {
						$cant_servir = $cantidad;
						$cantidad = 0;
					}
					debug("En esta loc solo hay $cant_servir para la posicion $idx se pedian $cantidad ... ");
					$aLoc[$idalm][$aD['id_articulo']]['localizacion'][$idx]['cantidad'] -= $cant_servir;

					// debug("Asignando valores al registro para almacen $idalm ... ");
					$aRec = array();
					$aRec['id_detalle'] = $aD['id_detalle'];
					$aRec['id_almacen_logico'] = $aL['id_almacen_logico'];
					$aRec['planta'] = $aL['planta'];
					$aRec['pasillo'] = $aL['pasillo'];
					$aRec['fila'] = $aL['fila'];
					$aRec['columna'] = $aL['columna'];
					$aRec['lote'] = $aL['lote'];
					$aRec['fecha_caducidad'] = $aL['fecha_caducidad'];

					if ($bVenta) {
						$aRec['cantidad'] = 0;
						$aRec['stock_previsto'] = $cant_servir;
					} else {
						$aRec['cantidad'] = $cant_servir;
						$aRec['stock_previsto'] = 0;
						// Corregimos Compras, para un funcionamiento como el de ventas
						$aRec['stock_previsto'] = $cant_servir;
						$aRec['cantidad'] = 0;
					}

					// Insertando en el registro Datos del resto de entidades
					if (is_array($aDetPed) AND sizeof($aDetPed)) foreach ($aDetPed as $fld => $val) $aRec['DetallePedido.'.$fld] = $val;
					if (is_array($aArtPed) AND sizeof($aArtPed)) foreach ($aArtPed as $fld => $val) $aRec['Producto.'.$fld] = $val;
					if (is_array($aFamPed) AND sizeof($aFamPed)) foreach ($aFamPed as $fld => $val) $aRec['Familia.'.$fld] = $val;
					if (is_array($aMcaPed) AND sizeof($aMcaPed)) foreach ($aMcaPed as $fld => $val) $aRec['Marca.'.$fld] = $val;
					if (is_array($aZnaPed) AND sizeof($aMcaPed)) foreach ($aZnaPed as $fld => $val) $aRec['Zona.'.$fld] = $val;

					if (!is_a($aRV[$idalm],'DeliveryNote')) {
						$aRV[$idalm] = new DeliveryNote ($AppName,$dbname);
						$aRV[$idalm]->bVenta = $bVenta;
						$aRV[$idalm]->update(array('id_almacen'=>$idalm,'observaciones'=>$texto,'referencia_externa'=>$refext));
//						$aRV[$idalm]->hookWherehouse(&$oAlm);
						$aRV[$idalm]->hookWherehouse($oAlm);
					}
					$tmpidx = $aRV[$idalm]->newDetail($aRec);
				}

				if ($bEnough) break;
			}
		}

		foreach (array_keys($aRV) as $k) {
			$aRV[$k]->changeOrder($id);
		}
		$oDb->libera($detrs);

		return $aRV;
	}

	function LocateProduct($aRefList = NULL,$bRefill = false) {
		$oDet = &$this->getDetails();
		$this->debug(array('aoItems Keys (Los detalles actuales):'=>array_keys($oDet->aoItems)),'LocateProduct');
		if (!is_a($oDet,'IndexList')) return false;
		if (!$aRefList) {
			$aRefList = $oDet->getIndexKeys('DetallePedido.id_articulo');
		}

		$this->debug("<b>setting up rebuild</b>",'LocateProduct');
		$oDet->bRebuilding = true;
		$id_prov = $this->getAttribute('Pedido.id_proveedor');
		$id_dir = $this->getAttribute('Pedido.id_direccion');
		$this->debug("cabeceras - Dir: $id_dir y prov: $id_prov e idped: ".$this->getAttribute('id_pedido'),'LocateProduct');
		if (!isset($this->bVenta)) {
			if (empty($id_prov)) $this->bVenta = true;
			else $this->bVenta = false;
		}
		$id_almacen = $this->getAttribute('id_almacen');
		if (empty($id_almacen)) return false;
		$oAlm = new Wherehouse($this->getAppName(),$this->getDbName());
		$rval = $oAlm->dbFill($id_almacen);
		$id_albaran = $this->getAttribute('id_albaran');
		$this->debug("cabeceras - id_almacen: $id_almacen  id_albaran: $id_albaran  venta: ".(int)$this->bVenta." dbname: ".
						$this->getDbName()." rval-almacen-dbfill: ".(int)$rval,'LocateProduct');

		$aRefCnt = array();
		$aFechas = array();
		foreach ($aRefList as $ida) {
			$cnt = 0;
			$aTmp = $oDet->getFromIndex('DetallePedido.id_articulo',$ida);
			$this->debug(array('after getFromIndex(DetallePedido.id_articulo='.$ida.') los idx son:'=>$aTmp),'LocateProduct');
			if ($bRefill) {
				$this->debug("Se ha solicitado _volver_ a poblar: ",'LocateProduct');
				// print_r(array_keys($oDet->aoItems));
				$tmp = array_shift($aTmp);
				$cnt = $oDet->getAttribute('cantidad','DetallePedido',$tmp);
				// TODO: Comprobar que esto funciona bien con as de una linea por ID
				$this->debug("-forzando- La cantidad pedida en $tmp que es $cnt ",'LocateProduct');
				array_unshift($aTmp,$tmp);
			}
			// Obtenemos el sumatorio por referencia de las existencias previstas 
			foreach ($aTmp as $idx) {
				$cantidad = $oDet->getAttribute('cantidad',NULL,$idx);
				$exist = $oDet->getAttribute('stock_previsto',NULL,$idx);
				if ($this->bVenta) {
					if (!$bRefill) $cnt += $exist - $cantidad;
					else $cnt -= $cantidad;
				} else {
					/** Correccion tratamiento de Compras **
					if (!$bRefill) $cnt += $cantidad - $exist;
					else $cnt -= $exist;
					/** **/
					if (!$bRefill) $cnt += $exist - $cantidad;
					else $cnt -= $cantidad;
				}

				$this->debug("Con fecha : ".$oDet->getAttribute('fecha_caducidad',NULL,$idx)." TotalCantidad: $cnt ",'LocateProduct');
				$f = $oDet->getAttribute('fecha_caducidad');
				if (!is_array($aFechas[$ida])) $aFechas[$ida] = array();
				if (!in_array($f,$aFechas[$ida])) array_push($aFechas[$ida],$oDet->getAttribute('fecha_caducidad'));
				/** **
				$st = $oDet->getValidity($idx);
				if (!$st) {
					$cnt += $oDet->getAttribute($idx,'cantidad');
				} else {
					debug("Detalle $idx ya verificado ");
				}
				/** **/
			}
			$aRefCnt[$ida] = $cnt;
		}

		$this->debug(array('Lista de Referencias, aRefCnt:' => $aRefCnt),'LocateProduct');

		if ($this->isSale()) {
			if (!empty($id_albaran)) $aTmp = array($id_albaran);
			else $aTmp = NULL;
			$aLoc = $oAlm->getLocationsForCheckOut($aRefCnt,$id_almacen,$id_emp,$aTmp);
		} else {
			$aLoc = $oAlm->getLocationsForCheckIn($aRefCnt,$id_almacen,$id_emp);
			$this->debug("En compras .. <b>Deberiamos</b> sobreescribir la fecha ? (ahora no se hace) ",'LocateProduct');
			$aDoneIdx = array();
			if (FALSE)
				foreach ($aFechas as $ida => $aF) {
					$aLz = $aLoc[$id_almacen][$ida]['localizaciones'];
					foreach ($aF as $f) {
						debug("Estamos con la fecha $f ... ");
						$bDone = false;
						foreach ($aLz as $idx => $aL) {
							if (!in_array($idx,$aDoneIdx)) {
								$aLoc[$id_almacen][$ida]['localizaciones'][$idx]['fecha_caducidad'] = $f;
								array_push($aDoneIdx,$idx);
								$bDone = true;
								break;
							}
						}
						if (!$bDone) {
							$aTmp = $aL;
							$aTmp['fecha_caducidad'] = $f;
							$aLoc[$id_almacen][$ida]['localizaciones'][] = $aTmp;
						}
					}
				}
		}
		$aLoc = $aLoc[$id_almacen];

		$this->debug(array("Lista de Localizaciones: Prov: $id_prov Dir: $id_dir Alm: $id_almacen "=>$aLoc,
						'sep'=>"<br/> --- <br/>"),'LocateProduct');

		foreach ($aRefCnt as $id_articulo => $cantidad) {
			$aIdx = $oDet->getFromIndex('DetallePedido.id_articulo',$id_articulo);
			$idx = array_shift($aIdx);
			array_unshift($aIdx,$idx);
			$aDetPed = $oDet->getData('DetallePedido',$idx);
			$aProd = $oDet->getData('Producto',$idx);
			$aFam = $oDet->getData('Familia',$idx);
			$aMca = $oDet->getData('Marca',$idx);
			$aZna = $oDet->getData('Zona',$idx);
			$aLP = $aLoc[$id_articulo]['localizaciones'];
			$aDetDb = array(); //Lista de id_detalle borrados, por tanto reciclables. -para el id_art-

			$this->debug(array("<hr/>LOOPINI-> Procesando ref: ",'id_articulo'=>$id_articulo,'cantidad_solicitada'=>$cantidad,'aIdx - folloop'=>$aIdx,'Loc'=>$aLP),'LocateProduct');
			foreach ($aIdx as $idx) {
				$aDet = $oDet->getData(NULL,$idx);
				$bMatch = false;
				// La cantidad que se solicita al Almacen es la pendiente, por eso hace falta saber la que hay puesta
				if ($this->bVenta) $cnt_orig = $oDet->getAttribute('cantidad',NULL,$idx);
				else {
					/** Correccion compras a tratamiento ventas **
					$cnt_orig = $oDet->getAttribute('stock_previsto',NULL,$idx);
					/** **/
					$cnt_orig = $oDet->getAttribute('cantidad',NULL,$idx);
				}
				//FixMe: solo tolerable no tener localizaciones, en Compra
				if (is_array($aLP) and sizeof($aLP))
					foreach ($aLP as $i => $aLoca) {
						if (Wherehouse::__compareLocation($aDet,$aLoca,true)) {
							$this->debug(array("Registrando en idx $idx la cantidad ".($aLoca['cantidad']+$cnt_orig),
									'LDetalle'=>$aDet),'LocateProduct');
							if ($this->bVenta) 
								$oDet->setAttribute('stock_previsto',($aLoca['cantidad']+$cnt_orig),NULL,$idx);
							else {
								/** Correccion compras a tratamiento ventas **
								$oDet->setAttribute('cantidad',($aLoca['cantidad']+$cnt_orig),NULL,$idx);
								/** **/
								$oDet->setAttribute('stock_previsto',($aLoca['cantidad']+$cnt_orig),NULL,$idx);
							}
							$bMatch = true;
							$aLP[$i] = NULL;
							unset($aLP[$i]);
						} else {
							$this->debug(array('Seguro que no coincide la loc en detalle: '=>$aDet,'con la nueva?:'=>$aLoca),'LocateProduct');
						}
					}
				if (!$bMatch) {
					// Si no se ha puesto ninguna cantidad de este SKU
					if (abs($cnt_orig) < pow(10,-6)) {
						$this->debug("Borrando el indice $idx .. con cantidad $cnt_orig ",'LocateProduct');
						$id_det = $oDet->getAttribute('id_detalle',NULL,$idx);
						if ($this->bVenta) $cnt = $oDet->getAttribute('stock_previsto',NULL,$idx);
						else {
							/** Correccion compras a tratamiento ventas **
							$cnt = $oDet->getAttribute('cantidad',NULL,$idx);
							/** **/
							$cnt = $oDet->getAttribute('stock_previsto',NULL,$idx);
						}
						$aDetDb[$id_det] += $cnt;
						$oDet->delete($idx);
					} else {
						// Si hay puesta cantidad, pero no existe en la nueva lista de SKUs, ya no existe este SKU, rasuramos
						$this->debug("Rasurando este SKU($idx) a la cantidad _ya_ puesta ",'LocateProduct');
						if ($this->bVenta) 
							$oDet->setAttribute('stock_previsto',$oDet->getAttribute('cantidad',NULL,$idx));
						else {
							/** Correccion compras a tratamiento ventas **
							$oDet->setAttribute('cantidad',$oDet->getAttribute('stock_previsto',NULL,$idx),NULL,$idx);
							/** **/
							$oDet->setAttribute('stock_previsto',$oDet->getAttribute('cantidad',NULL,$idx),NULL,$idx);
						}
					}
				}
			}

			$this->debug(array("otherloop->LocateProduct() id_detalle con cantidades: ",'aDetDb'=>$aDetDb,'aLoca'=>$aLP),'LocateProduct');
			//FixMe: solo tolerable no tener localizaciones, en Compra
			if (!is_array($aLP) or !sizeof($aLP)) {
				$this->debug('Pues no hay locas!! asi que a otra cosa :?? ','LocateProduct');
				continue;
			}
			// print_r($aDetDb);
			// foreach ($aLP as $aLoca) 
			while ( $aLoca = array_shift($aLP) ) {
				$aRec = $aLoca;
				if (is_array($aDetDb) and sizeof($aDetDb)) {
					//Detalles reciclables (borrados)
					foreach ($aDetDb as $iddet => $cnt) {
						$this->debug("<u><b>La loc</b></u> contiene ".$aRec['cantidad']." IDArt: ".$aRec['id_articulo'].
								" FCad: ".$aRec['fecha_caducidad']." y el detalle $iddet tiene $cnt ",'LocateProduct');
						$aRec['id_detalle'] = $iddet;
						$aRec['cantidad'] = $aLoca['cantidad'];
						#echo "En el det $cnt y en la loca ".$aLoca['cantidad']."<br/>\n";
						if (abs($aRec['cantidad'])-abs($cnt) > pow(10,-6) and $cnt>0) {
							$aRec['cantidad'] = $cnt;
							$aLoca['cantidad'] -= $cnt;
							array_unshift($aLP,$aLoca);
							#echo "YA .. para este detalle, no va mas. ";
							$aDetDb[$iddet] = NULL;
							unset($aDetDb[$iddet]);
							break;
						} else {
							$aDetDb[$iddet] = NULL;
							unset($aDetDb[$iddet]);
						}
						/** ** Dado que compras y ventas ahora se comportan de igual forma. Si hay localizaciones nuevas que 
						necesitan anyadirse ($aLP) y hay lineas borradas ($aDetDb) se recoge un id_detalle cualquiera
						para esta localizacion a insertar, y se usa para _toda_ la cantidad (que recordemos es el stock_previsto
						y por tanto no altera nada confirmado ya)
						if ($aRec['cantidad'] >= $cnt) {
							$aRec['id_detalle'] = $iddet;
							$aRec['cantidad'] = $cnt;
							$this->debug("de la Loc, la cantidad ".$aLoca['cantidad']." se le quitan $cnt ",'LocateProduct');
							$aLoca['cantidad'] -= $cnt;
							if ( abs($aLoca['cantidad']) > pow(10,-6) ) array_push($aLP,$aLoca);
							$aDetDb[$iddet] = NULL;
							unset($aDetDb[$iddet]);
							break;
						} elseif (abs($cnt) > pow(10,-6)) {
							$aRec['id_detalle'] = $iddet;
							$this->debug("Del detalle $iddet con ".$aDetDb[$iddet]." le quitamos ".$aLoca['cantidad'],'LocateProduct');
							$aDetDb[$iddet] -= $aLoca['cantidad'];
							break;
						}
						/** **/
					}
				} else {
					$this->debug("Ya no quedan mas detalles, le metemos este: ".$aDetPed['id_detalle'],'LocateProduct');
					$aRec['id_detalle'] = $aDetPed['id_detalle'];
				}

				$aRec['id_albaran'] = $id_albaran;
				// La cantidad SKU (obtenida de las localizaciones) Se corresponde con una prevision, no con la que se ha servido
				if ($this->bVenta) {
					$aRec['stock_previsto'] = $aRec['cantidad'];
					$aRec['cantidad'] = 0;
				} else {
					/** Correccion compras a tratamiento ventas **
					if (abs($aRec['cantidad'])<pow(10,-6)) continue;
					$aRec['stock_previsto'] = 0;
					/** **/
					$aRec['stock_previsto'] = $aRec['cantidad'];
					$aRec['cantidad'] = 0;
				}
				$this->debug(array("Registro a insertar: "=>$aRec),'LocateProduct');

				if (is_array($aDetPed) AND sizeof($aDetPed)) foreach ($aDetPed as $fld => $val) $aRec['DetallePedido.'.$fld] = $val;
				if (is_array($aProd) AND sizeof($aProd)) foreach ($aProd as $fld => $val) $aRec['Producto.'.$fld] = $val;
				if (is_array($aFam) AND sizeof($aFam)) foreach ($aFam as $fld => $val) $aRec['Familia.'.$fld] = $val;
				if (is_array($aMca) AND sizeof($aMca)) foreach ($aMca as $fld => $val) $aRec['Marca.'.$fld] = $val;
				if (is_array($aZna) AND sizeof($aZna)) foreach ($aZna as $fld => $val) $aRec['Zona.'.$fld] = $val;
				$tmpidx = $this->newDetail($aRec);
				$this->debug("Reg insertado en $tmpidx ",'LocateProduct');
			}
		}
		$oDet->bRebuilding = false;
		return;
	}

	function setDate($fecha = NULL,$tipo = 'entrada') {
		if (empty($tipo)) $tipo = 'entrada';
		if (!strcasecmp($fecha,'now')) $fecha = $this->getDate('now');
		$retval = false;
		//FixMe: Falta obtener el id_dia para los dashboards.

		switch ($tipo) {
			case 'entrada':
				if (wol_db::formatear_fecha($fecha,false,false) == wol_db::formatear_fecha($this->getAttribute('fecha'),false)) 
					continue;
				if (!strcasecmp($fecha,'null')) {
					$this->setAttribute('id_dia','null');
				} elseif (class_exists(Periodo)) {
					if (!is_a($oPer,'Periodo')) $oPer = &Periodo::factoryActivePeriod();
					if (is_a($oPer,'Periodo')) 
						$aTmp = $oPer->getAssignments(array('fecha' => $fecha),'Albaranes',false);
					if (is_array($aTmp) and sizeof($aTmp)) 
						foreach ($aTmp as $fld => $val) {
							if (!strcasecmp(substr($fld,1,5),'fecha')) continue;
							$this->setAttribute($fld,$val);
						}
				}
				$this->setAttribute('fecha',$fecha);
				$retval = true;
				break;

			case 'preparado':
				if (wol_db::formatear_fecha($fecha,false,false)==wol_db::formatear_fecha($this->getAttribute('fecha_preparado'),false,false))
					continue;
				if (!strcasecmp($fecha,'null')) {
					$this->setAttribute('id_dia_preparado','null');
				} elseif (class_exists(Periodo)) {
					if (!is_a($oPer,'Periodo')) $oPer = &Periodo::factoryActivePeriod();
					if (is_a($oPer,'Periodo')) 
						$aTmp = $oPer->getAssignments(array('fecha_preparado' => $fecha),'Albaranes',false);
					if (is_array($aTmp) and sizeof($aTmp)) 
						foreach ($aTmp as $fld => $val) {
							if (!strcasecmp(substr($fld,1,6),'fecha_')) continue;
							$this->setAttribute($fld,$val);
						}
				}
				$this->setAttribute('fecha_preparado',$fecha);
				$retval = true;
				break;

			case 'envio':
				if (wol_db::formatear_fecha($fecha,false,false) == wol_db::formatear_fecha($this->getAttribute('fecha_envio'),false,false)) 
					continue;
				if (!strcasecmp($fecha,'null')) {
					$this->setAttribute('id_dia_envio','null');
				} elseif (class_exists(Periodo)) {
					if (!is_a($oPer,'Periodo')) $oPer = &Periodo::factoryActivePeriod();
					if (is_a($oPer,'Periodo')) 
						$aTmp = $oPer->getAssignments(array('fecha_envio' => $fecha),'Albaranes',false);
					if (is_array($aTmp) and sizeof($aTmp)) 
						foreach ($aTmp as $fld => $val) {
							if (!strcasecmp(substr($fld,1,6),'fecha_')) continue;
							$this->setAttribute($fld,$val);
						}
				}
				$this->setAttribute('fecha_envio',$fecha);
				$retval = true;
				break;

			case 'recepcion':
				if (wol_db::formatear_fecha($fecha,false,false)==wol_db::formatear_fecha($this->getAttribute('fecha_recepcion'),false,false))
					continue;
				if (!strcasecmp($fecha,'null')) {
					$this->setAttribute('id_dia_recepcion','null');
				} elseif (class_exists(Periodo)) {
					if (!is_a($oPer,'Periodo')) $oPer = &Periodo::factoryActivePeriod();
					if (is_a($oPer,'Periodo')) 
						$aTmp = $oPer->getAssignments(array('fecha_recepcion' => $fecha),'Albaranes',false);
					if (is_array($aTmp) and sizeof($aTmp)) 
						foreach ($aTmp as $fld => $val) {
							if (!strcasecmp(substr($fld,1,6),'fecha_')) continue;
							$this->setAttribute($fld,$val);
						}
				}
				$this->setAttribute('fecha_recepcion',$fecha);
				$retval = true;
				break;

		}

		return $retval;
	}

	function getDate($tipo = 'entrada') {
		if (empty($tipo)) return NULL;
		$retval = NULL;
		switch ($tipo) {
			case 'entrada':
				$retval = $this->getAttribute('fecha');
				break;

			case 'preparado':
				$retval = $this->getAttribute('fecha_preparado');
				break;

			case 'recepcion':
				$retval = $this->getAttribute('fecha_recepcion');
				break;

			case 'envio':
				$retval = $this->getAttribute('fecha_envio');
				break;

			case 'now':
				$retval = date('Y-m-d H:i:s');
				break;
		}

		$retval = strftime('%d/%m/%Y %H:%M:%S',strtotime(wol_db::formatear_fecha($retval,false,false)));
		return $retval;
	}

	function buildRef() {
		$id_emp = $this->getAttribute('id_empresa','Empresa');
		if (!is_numeric($id_emp)) return false;

		if ($this->bVenta) {
			$fld = 'contador_alb_ventas';
			$ndig = $this->getAttribute('digitos_alb_ventas','Empresa');
			$pref = $this->getAttribute('prefijo_alb_ventas','Empresa');
			$sufi = $this->getAttribute('sufijo_alb_ventas','Empresa');
		} else {
			$fld = 'contador_alb_compras';
			$ndig = $this->getAttribute('digitos_alb_compras','Empresa');
			$pref = $this->getAttribute('prefijo_alb_compras','Empresa');
			$sufi = $this->getAttribute('sufijo_alb_compras','Empresa');
		}

		$oDb = &$this->getDb();
		$cons = 'SELECT '.$fld.' FROM Empresas WHERE id_empresa = '.$id_emp;
		$cntrs = $oDb->query($cons);
		if (!$oDb->num_rows($cntrs)) return false;
		$oDb->query('UPDATE Empresas set '.$fld.' = '.$fld.' + 1 WHERE id_empresa = '.$id_emp);
		$aTmp = $oDb->fetch_row($cntrs);

		$tmp = pow(10,$ndig);
		$tmp += $aTmp[0];
		$ref = $pref.substr((string)$tmp,1).$sufi;
		$this->setAttribute('referencia',$ref);

		return true;
	}

	function isSale() {
		$rval = ( ($this->bVenta) ? true : false );
		return $rval;
	}

	function findInvoices() {
		if ((bool)$this->getAttribute('preparado') and (!is_array($this->aoFacturas) or !sizeof($this->aoFacturas))) {
			$tmp = $this->getVar('findinvoices_lastcheck');
			if (!empty($tmp)) {
				$this->debug("findInvoices() solo debe correr 1 vez ",'findInvoices');
				return;
			}
			$oDb = &$this->getDb();
			$id_alb = $this->getID();
			$this->aDetFras = array();
			// Antes de Nada comprobamos los ids_facturados.
			for ($idx = $this->firstDetail(); isset($idx); $idx = $this->nextDetail()) {
				$aD = $this->getDetailData();
				if (is_numeric($aD['id_detalle']) AND is_numeric($aD['id_albaran'])) 
					$strdets .= ( (empty($strdets)) ? ' ' : ' OR ' ).' (Ad.id_detalle = '.$aD['id_detalle'].' AND Ad.id_albaran = '.$id_alb.') ';
			}
			if (!empty($strdets)) {
				$cons = 'SELECT Fd.id_detalle,F.id_factura,F.id_serie,F.estado,F.id_cliente,F.id_proveedor,A.referencia,A.fecha, '.
							'Ld.descuento as "descuento_pto", Ld.monto as "descuento_monto", Ld.precio_articulo, Ld.id_pedido '.
							'FROM Facturas_detalle Fd,Facturas F, Detalles_albaran Ad, Albaranes A, Lineas_detalle Ld '.
							'WHERE Fd.id_detalle = Ld.id_detalle AND Ld.id_detalle = Ad.id_detalle AND Ad.id_albaran = A.id_albaran '.
							'AND F.id_factura = Fd.id_factura AND F.factura_abono = 0 AND ('.$strdets.') ORDER BY F.fecha asc ';
				$tmprs = $oDb->query($cons);
				if ($oDb->num_rows($tmprs)) {
					$aFound = array();
					$id_fra = NULL;
					$str_notfras = NULL;
					while ($aTmp = $oDb->fetch_assoc($tmprs)) {
						if (in_array($aTmp['id_detalle'],$aFound)) continue;
						array_push($aFound,$aTmp['id_detalle']);
						if (!empty($aTmp['id_cliente'])) {
							$bVenta = true;
							$id_cliente = $aTmp['id_cliente'];
						} else {
							$bVenta = false;
							$id_proveedor = $aTmp['id_proveedor'];
						}
						if (!is_array($this->aDetFras[$aTmp['id_detalle']])) 
							$this->aDetFras[$aTmp['id_detalle']] = array();
						array_push($this->aDetFras[$aTmp['id_detalle']],$aTmp['id_factura']);

						if (!is_a($this->aoFacturas[$aTmp['id_factura']],'Invoice')) {
							$tipo = ( ($bVenta) ? inmPed_VENTA : inmPed_COMPRA);
							$oFra = new Invoice($this->getAppName(),$this->getDbName(),$tipo);
							if ($oFra->dbFill($aTmp['id_factura'])) {
								$this->aoFacturas[$aTmp['id_factura']] = &$oFra;
								// debug("aoFacturas del id: ".$aTmp['id_factura']);
							}
							unset($oFra);
						}

						// Si la fra no esta emitida, Marcamos estas facturas como no validas para un abono
						//   esto es asi porque vamos a asociarlo con el mismo id_detalle, y una misma fra no puede 
						//	  tener asociado el mismo id_detalle 2 veces.
						if (!(int)$aTmp['estado'] ) $str_notfras .= ( (empty($str_notfras)) ? '' : ' AND ').' id_factura != '.$aTmp['id_factura'];
					}
				}
				$oDb->libera($tmprs);
			}
			$this->setVar('findinvoices_lastcheck','somets');
		}
	}

	function completeWithSKU($aSKUList,$bInsertRest=true) {
		if (!is_array($aSKUList) or !sizeof($aSKUList)) return false;
		if (!is_array($aSKUList[array_shift(array_keys($aSKUList))])) $aSKUList = array($aSKUList);
		if (!is_a($this->oDetails,'DeliveryEntries')) $this->_factoryEntries();
		$aPte = array();
		$this->oDetails->buildIndex();
		for ($idx = $this->firstDetail(); isset($idx); $idx = $this->nextDetail()) {
			$pte = $this->getAttribute('cantidad_pendiente','Detalle',$idx);
			if (!isset($pte)) $pte = $this->getAttribute('cantidad_pendiente','Detalle',$idx);
			if (!isset($pte)) $pte = $this->getAttribute('stock_previsto',NULL,$idx) - $this->getAttribute('cantidad',NULL,$idx);
			if (!isset($pte) or $pte<=0) continue;
			$aPte[$idx] = $pte;
			$pte = NULL;
		}
		$mDetalles = array();
		$aNuevas = array();
		foreach ($aSKUList as $aSKU) {
			$strLoc = DeliveryEntry::strLoc($aSKU);
			$id_art = $aSKU['id_articulo'];
			$this->debug("$id_art Loc : ".$strLoc,'completeWithSKU');
			// Lo primero Buscaremos la fecha de caducidad/lote (SKU) entre las cantidades pendientes.
			$aIdx = array();
			$aTmp = NULL;
			$aTmp = $this->oDetails->idxRef[$id_art];
			if (!is_array($aTmp) or !sizeof($aTmp)) {
				// Si esta referencia no existe ... habra que meterlo como nueva.
				debug("Error: Esto no deberia ocurrir .. corrigiendo ");
				$aNuevas[] = $aSKU;
				continue;
			}
			$aSKU['__add']=true;
			foreach ($aTmp as $tmp_idx) {
				// Si la localizacion y sku coinciden, _no_ hay otro sitio donde meterlo.
				if (Wherehouse::__compareLocation($aSKU,$this->getDetailData(NULL,$tmp_idx),true)) {
					if ($bInsertRest or $aPte[$tmp_idx]) {
						if ($aPte[$tmp_idx]>$aSKU['cantidad']) {
							$aPte[$tmp_idx] -= $aSKU['cantidad'];
							$mDetalles[$tmp_idx] = $aSKU;
							debug("Metemos todo(".$aSKU['cantidad'].") en $idx ");
						} else {
							if (!$bInsertRest) {
								$aSKU['cantidad'] = $aPte[$tmp_idx];
							}
							$aPte[$idx] = NULL;
							unset($aPte[$tmp_idx]);
							$mDetalles[$tmp_idx] = $aSKU;
							debug("Metemos esto (".$aSKU['cantidad'].") en $tmp_idx  y todavia tiramos ? $bInsertRest");
						}
					}
					$aSKU = NULL;
				} elseif (in_array($tmp_idx,array_keys($aPte))) { array_push($aIdx,$tmp_idx); }
			}
			if (!is_array($aSKU) or !sizeof($aSKU)) {
				debug("Err:: No hay sku: ");
				print_r($aSKU);
				continue;
			} 
			if (is_array($aIdx) and sizeof($aIdx)) {
				// Buscamos este SKU en las referencias de producto con falta > $aIdx
				foreach ($aIdx as $idx) {
					// Si en esta linea queda mas cantidad por cubrir de la que tenemos ..
					if ($aPte[$idx]>$aSKU['cantidad']) {
						$aPte[$idx] -= $aSKU['cantidad'];
						$mDetalles[$idx] = $aSKU;
						$aSKU = NULL;
						debug("Metemos todo(".$aSKU['cantidad'].") en $idx ");
						break;
					} else {
						// Si con lo pendiente aqui, no metemos todas .. todavia quedara genero
						$aTmp = $aSKU;
						$aTmp['cantidad'] = $aPte[$idx];
						$aSKU['cantidad'] -= $aPte[$idx];
						$aPte[$idx] = NULL;
						unset($aPte[$idx]);
						$mDetalles[$idx] = $aTmp;
						array_push($aNuevas,$aSKU);
						debug("Metemos esto (".$aSKU['cantidad'].") en $idx  y todavia nos queda: ".$aSKU['cantidad']);
					}
				}
			} elseif (!sizeof($aPte) and $bInsertRest and sizeof($aSKU)) array_push($aNuevas,$aSKU);
		}
		if (is_array($mDetalles) and sizeof($mDetalles)) $this->updateDetails($mDetalles);
		if (is_array($aNuevas) and sizeof($aNuevas) and $bInsertRest) {
			$oDet = &$this->getDetails();
			foreach ($aNuevas as $aSKU) {
				$id_a = $aSKU['id_articulo'];
				if (is_array($oDet->idxRefToDet[$id_a]) and sizeof($oDet->idxRefToDet[$id_a])) {
					$id_det = $oDet->idxRefToDet[$id_a][array_shift(array_keys($oDet->idxRefToDet[$id_a]))];
					$aSKU['id_detalle'] = $id_det;
					//$aSKU['DetallePedido.id_articulo'] = $id_a;
					$aSKU['id_articulo'] = $id_a;
				}
				$aSKU['stock_previsto'] = $aSKU['cantidad'];
				$tmpi = $this->newDetail($aSKU);
			}
		}
	}

	function returnDetail ($cnt,$aReason,$idx=NULL) {
		if (!is_a($this->oDetails,'DeliveryEntries')) $this->_factoryEntries();
		if (!$idx) $idx = $this->currentDetail();
		$this->findInvoices();
		$aDet = $this->getDetailData(NULL,$idx);
		$aFlds = array_keys($aDet);
		$aBaja = array();
		foreach ($aFlds as $fld) $aBaja[$fld] = $aReason[$fld];
		$id_det = $aBaja['id_detalle'];
		$aBaja['cantidad'] = $cnt;
		$aBaja['descripcion'] = $aReason['descripcion'];
		$aBaja['id_baja_almacen'] = $aReason['id_baja_almacen'];
		$aBaja['id_articulo'] = $this->getDetailAttribute('id_articulo','DetallePedido',$idx);
		$new_cnt = $cnt + $this->getDetailAttribute('cantidad_devuelta',NULL,$idx);
		$aTmp = array('cantidad_devuelta'=>$new_cnt);
		if (!empty($aReason['descripcion'])) {
			if (!empty($aTmp['observaciones'])) $aTmp['observaciones'] .= "\n";
			$aTmp['observaciones'] .= '-['+$aReason['descripcion']+']-';
		}
		$this->updateDetail($aTmp,NULL,$idx);
		$this->debug("La nueva cantidad es $new_cnt y la que existe es: ".
					$this->getDetailAttribute('cantidad_devuelta',NULL,$idx),'returnDetail');
		if ($new_cnt != $this->getDetailAttribute('cantidad_devuelta',NULL,$idx)) {
			echo "Error: No se puede devolver mas genero del servido ".$new_cnt;
			return false;
		}
		//$aBaja = array();
		$aBaja['cantidad'] = $cnt;
		//$aBaja['id_detalle'] = $id_det;
		//$aBaja['id_albaran'] = $this->getId();
		$aBaja['idx'] = $idx;
		$aBaja['causar_baja'] = $aReason['causar_baja'];
		$aBaja['razon'] = $aReason['descripcion'];
		$oB = new BajaAlmacen();
		$this->debug("Para la baja tenemos: detalle $id_det ",'returnDetail');
		$oB->update($aBaja);
		// print_r($aBaja);
		if ((bool)$aReason['causar_baja']) {
			$oB->alterStock(true);
		} else $oB->alterStock(false);
		$oB->alterStock(false);
		if (!is_array($this->aoBajas)) $this->aoBajas = array();
		if (!is_array($this->aoBajas[$id_det])) $this->aoBajas[$id_det] = array();
		$aBaja['__instancia__'] = &$oB;
		$aBaja['id_factura_abono'] = $aReason['id_factura_abono'];
		$this->debug("El id de la factura de abono es: ".$aBaja['id_factura_abono'],'returnDetail');
//		array_push($this->aoBajas[$id_det],&$aBaja);
		array_push($this->aoBajas[$id_det],$aBaja);
		$this->update(array('devuelto'=>1));
	}

	/* Fin de metodos Propios */

	/* Implementacion de Metodos Abstractos */
	function postFill($rval) {
		// debug("Comprobando la integridad del invento ... ");
		$idp = $this->getAttribute('id_pedido');
		if (!empty($idp)) {
			$id_dir = $this->getAttribute('id_direccion','Pedido');
			$id_prov = $this->getAttribute('id_proveedor','Pedido');
			if (!empty($id_dir) and $id_dir != $this->getAttribute('id_direccion')) {
				debug("Actualizando la direccion de entrega por no coincidir... nah. ");
				$this->updateForeignKey($id_dir,'id_direccion');
				$id_cli = $this->getAttribute('id_cliente','Direccion');
				if (is_numeric($id_cli) AND $bDone) $this->updateForeignKey($id_cli,'id_cliente');
				$this->setAttribute('id_direccion',$id_dir);
			} elseif (!empty($id_prov) and $id_prov != $this->getAttribute('id_proveedor')) {
				$this->updateForeignKey($id_prov,'id_proveedor');
				$this->setAttribute('id_proveedor',$id_prov);
			}
		} else {
			$id_dir = $this->getAttribute('id_direccion','Destino');
			$id_prov = $this->getAttribute('id_proveedor','Origen');
		}

		if (empty($id_dir) and !empty($id_prov)) { $this->bVenta = false;
		} elseif (!empty($id_dir) and empty($id_prov)) $this->bVenta = true;

		$this->debug("Fixme: No se si crear instancia Wherehouse aqui o no .. :? Venta: ".$this->bVenta,'postFill');

		$aD = $this->getData('Destino');
		if (!empty($aD['id_direccion'])) {
			$this->bVenta = true;
		} else {
			$aP = $this->getData('Proveedor');
			$aAlm = $this->getData('Origen');
			if (!empty($aP['id_proveedor'])) {
				$this->bVenta = false;
				$this->update($aAlm,'Destino',true);
				$this->update($aP,'Origen',true);
			}
		}

		$aAlb = $this->getData();
		$this->setVar('preparado_dborig',$aAlb['preparado']);
		if ((bool)$aAlb['recogida']) {
			$aO = $this->getData('Origen');
			$aD = $this->getData('Destino');
			$this->update($aD,'Origen',true);
			$this->update($aO,'Destino',true);
		}
		return true;
	}

	function preDump($tipo) {
		$this->debug('','preDump');
		$ref = $this->getAttribute('referencia');
		if (empty($ref) AND !$this->buildRef()) {
			$this->debug("Imposible construir una referencia valida. ",'preDump');
			return false;
		}
		$fecha = $this->getAttribute('fecha');
		if (empty($fecha)) $this->setDate('now');

		$id_dir = $this->getAttribute('id_direccion');
		if (empty($id_dir) and $this->isSale()) {
			$aCl = $this->getData('Cliente');
			$this->debug(array("Cliente: "=>$aCl),'preDump');
			$oDb = &$this->getDb();
			$cons = 'SELECT id_direccion FROM Direcciones_entrega WHERE id_cliente = '.$aCl['id_cliente'].
						' ORDER BY id_direccion asc LIMIT 1';
			$idrs = $oDb->query($cons);
			if (!$oDb->num_rows($idrs)) return false;
			$aTmp = $oDb->fetch_row($idrs);
			$this->debug("Estableciendo direccion : ".$aTmp[0],'preDump');
			//$this->setAttribute('id_direccion',$aTmp[0]);
			$this->update(array('id_direccion'=>$aTmp[0]));
			$id_dir = $this->getAttribute('id_direccion');
		}

		$id_alm = $this->getAttribute('id_almacen');
		if (empty($id_alm)) {
			if (!is_a($oDb,'wol_db')) $oDb = &$this->getDb();
			$id_emp = $this->getAttribute('id_empresa');
			if (empty($id_emp)) $id_emp = 1;
			$cons = 'SELECT id_almacen FROM Almacenes WHERE id_empresa = '.$id_emp.' ORDER BY id_almacen asc LIMIT 1 ';
			$rs = $oDb->query($cons);
			if (!$oDb->num_rows($rs)) return false;
			$aTmp = $oDb->fetch_array($rs);
			//$this->setAttribute('id_almacen',$aTmp[0]);
			$this->update(array('id_almacen'=>$aTmp[0]));
			$id_alm = $this->getAttribute('id_almacen');
		}

		$id_trans = $this->getAttribute('id_transportista');
		if (empty($id_trans)) {
			$id_trans = $this->getAttribute('id_transportista','Destino');
			debug("id_trans en dir puede ser $id_trans ");
			$aTmp = $this->getData('Destino');
			print($aTmp);
			if (!empty($id_trans)) {
				//$this->setAttribute('id_transportista',$id_trans);
				$this->update(array('id_transportista'=>$id_trans));
			} else {
				debug("Buscando id_trans en cfg general ... ");
				$oS = &$this->getApp();
				$aCfg = $oS->get_var('_aAppConf');
				$id_trans = $aCfg['gnrl_transportista_defecto'];
				debug("trans por defecto es $id_trans ... ");
				//if (!empty($id_trans)) $this->setAttribute('id_transportista',$id_trans);
				if (!empty($id_trans)) $this->update(array('id_transportista'=>$id_trans));
			}
		} else debug("Ya tenemos transportista ... $id_trans ");

		// Vamos a por los detalles:
		$id_alm = $this->getAttribute('id_almacen');
		if ($this->bVenta) $fld = 'stock_previsto';
		else $fld = 'stock_previsto';
		//Mismo comportamiento ventas que compras: else $fld = 'cantidad';
		for ($idx = $this->firstDetail(); isset($idx); $idx = $this->nextDetail()) {
			$tmp = $this->getDetailAttribute($fld,NULL,$idx);
			if (empty($tmp)) { // Si no hay stock previsto ... lo buscaremos
				$idart = $this->getDetailAttribute('id_articulo','DetallePedido',$idx);
				if (!empty($idart)) {
					$aRefCnt[$idart] += $this->getDetailAttribute('cantidad','DetallePedido',$idx);
					if (!is_array($aRefIdx[$idart])) $aRefIdx[$idart] = array();
					array_push($aRefIdx[$idart],$idx);
				}
			}
		}
		$this->debug(array("revisando aRefCnt: "=>$aRefCnt),'preDump');
		if (is_array($aRefCnt) and sizeof($aRefCnt)) {
			// Comportamiento uniformado ventas/compras: if $this->bVenta ...
			if (TRUE or $this->bVenta) {
				$oAlm = &$this->getWherehouse();
				debug("Buscanto stock ... ");
				$aTmp = $oAlm->getAvailableStock($aRefCnt);
				if ($GLOBALS['DEBUG']=='ON') {
					debug("CAntidades disponibles en preDump: ID - ".$oAlm->getId());
					print_r($aTmp);
				}
				foreach ($aTmp as $idl => $aR)
					foreach ($aR as $ida => $cnt) {
						foreach ($aRefIdx[$ida] as $id_x) {
							if (empty($cnt)) {
								$this->deleteDetail($id_x);
								continue;
							}
							$cnt_tmp = $this->getDetailAttribute('cantidad','DetallePedido',$id_x);
							if ($cnt_tmp >= $cnt) {
								$this->setDetailAttribute($fld,$cnt,NULL,$id_x);
								$cnt = 0;
							} else {
								$this->setDetailAttribute($fld,$cnt_tmp,NULL,$id_x);
								$cnt -= $cnt_tmp;
							}
						}
					}
			} else {
				debug("TODO: Funcionalidad de albaranes directos en compra, todavia no implementada ");
				return true;
				return false;
			}
		}
		$this->debug('retornamos gracefuly','preDump');
		return true;
	}

	function postDump($bDumpStat,$tipo) {
		if (TRUE or $bDumpStat) { //Si no se han alterado las cabeceras, tambien queremos que se ejecute la revision.
			if (is_a($this->oDetails,'IndexList')) {
				// debug("Ojo, que de momento no volcamos los detalles ");
				$this->oDetails->Dump($tipo);
			} else return $bDumpStat;
			$oDb = &$this->getDb();

			$aRefList = array();
			$aRefNot = array();
			$aDetList = array();
			$aLocList = array();
			for ($idx = $this->firstDetail(); isset($idx); $idx = $this->nextDetail()) {

				$id_art = $this->getDetailAttribute('id_articulo','DetallePedido');
				if (!$this->bVenta) {
					$cnt = $this->getDetailAttribute('stock_previsto');
					$cnt_not = $this->getDetailAttribute('stock_previsto_dborig');
					$this->debug("Para $id_art ya hemos notificado (previsto_dborig) $cnt_not y ahora hay un previsto de $cnt ",'postDump');
					if (($cnt != $cnt_not)) {
					  	$aRefNot[$id_art] += ($cnt - $cnt_not);
					}
				}

				$cantidad = $this->getDetailAttribute('cantidad');
				if (abs($cantidad) < pow(10,-6) ) continue;
				$id_det = $this->getDetailAttribute('id_detalle');
				//$this->debug("Sumando de $idx cnt $cantidad detalle $id_det ",'postDump');
				$aTmp = $this->getDetailData();
				$aTmp['id_articulo'] = $id_art;
				$aLocList[] = $aTmp;
				$aDetList[$id_det] += $cantidad;
				// Esta no hace falta.
				$aRefList[$id_art] += $cantidad;

				//Comprobando si hay devoluciones:
				if ((float)$this->getDetailAttribute('cantidad_devuelta')!=(float)$this->getDetailAttribute('cantidad_devuelta_dborig')) {
					$this->debug("NO coinciden las cantidades devueltas ... vamos a hacer algo. ");
					$cnt = $this->getDetailAttribute('cantidad_devuelta') - $this->getDetailAttribute('cantidad_devuelta_dborig');
					$cons = 'UPDATE Lineas_detalle SET cantidad_recibida = cantidad_recibida - \''.$cnt.'\' WHERE id_detalle = '.$id_det;
					$this->debug($cons);
					$oDb->query($cons);
				}
			}
			
			$id_almacen = $this->getAttribute('id_almacen');
			$oAlm = &$this->getWherehouse();
			if (!is_a($oAlb,'Wherehouse')) {
				$this->debug("No es normal esto de crear la instancia Wherehouse en el postdump ",'postDump');
				$oAlm = new Wherehouse();
				$oAlm->dbFill($id_almacen);
			}

			$this->debug("dbOrig(prep): ".$this->getVar('preparado_dborig'),'postDump');
			if ($this->getAttribute('preparado')!=$this->getVar('preparado_dborig') or $this->checkFlag($this->ST_DEL) ) {
				$this->debug("Ha habido cambios ... ",'postDump');
				if ($this->checkFlag($this->ST_DEL)) {
					// Para no tener que enrebesar el if de abajo, invierto el sentido de la marca preparado, para que haga la op inversa.
					$this->debug("BORRADO!! ",'postDump');
					$this->setAttribute('preparado',(int)!$this->getAttribute('preparado'));
				}
				if ( ($this->getAttribute('preparado') and $this->bVenta) or (!$this->getAttribute('preparado') and !$this->bVenta) ) {
					$this->debug(array("FixMe: Falta marcar el pedido como preparado! ",
									"_RETIRAMOS_ del stock todas las cantidades ... "=>$aLocList),'postDump');
					foreach ($aLocList as $idx => $aL) {
						$aLocList[$idx]['cantidad'] *= -1;
					}
					// debug("updateStock con ");
					// print_r($aLocList);
					$oAlm->stockUpdate($aLocList,false);
					if (!$this->bVenta) {
						// debug("Y actualizamos cantidad_servida para que _NO_ se pueda facturar ");
						foreach ($aDetList as $id_det => $cnt) $aDetList[$id_det] *= -1;
					}
					foreach ($aDetList as $id_det => $cnt) {
						$cons = 'UPDATE Lineas_detalle SET cantidad_recibida = cantidad_recibida + \''.$cnt.'\' WHERE id_detalle = '.$id_det;
						$this->debug($cons,'postDump');
						$oDb->query($cons);
					}
				} else {
					$this->debug(array("_INSERTAMOS_ en el stock todas las cantidades ... ","updateStock con "=>$aLocList),'postDump');
					$oAlm->stockUpdate($aLocList,false);
					if ($this->bVenta) {
						// debug("Y actualizamos cantidad_servida para que _NO_ se pueda facturar ");
						foreach ($aDetList as $id_det => $cnt) $aDetList[$id_det] *= -1;
					}
					// debug("SQL");
					foreach ($aDetList as $id_det => $cnt) {
						$cons = 'UPDATE Lineas_detalle SET cantidad_recibida = cantidad_recibida + \''.$cnt.'\' WHERE id_detalle = '.$id_det;
						// debug($cons);
						$oDb->query($cons);
					}
				}
				$this->debug("El Albaran, preparado: ".$this->getAttribute('preparado')." Pero el pedido: ".
						$this->getAttribute('preparado','Pedido'),'postDump');
				if ($this->getAttribute('preparado')!=$this->getAttribute('preparado','Pedido')) {
					if (!(bool)$this->getAttribute('preparado')) {
						// Si estamos despreparando, no miramos nada. Cambiamos el estado del pedido
						$cons = 'UPDATE Pedidos SET preparado = '.$this->getAttribute('preparado').
							' WHERE id_pedido = '.$this->getAttribute('id_pedido');
						$this->setAttribute('preparado',$this->getAttribute('preparado'),'Pedido');
						$this->debug($cons,'postDump');
						$oDb->query($cons);
					} else {
						// Si estamos preparando, solo cambiamos si el resto no existe o esta tb a 1 
						$cons = 'SELECT MIN(preparado) as "status" FROM Albaranes WHERE id_pedido = '.
								$this->getAttribute('id_pedido').' AND id_albaran != '.
								$this->getAttribute('id_albaran');
						$this->debug($cons,'postDump');
						$tmprs = $oDb->query($cons);
						$aTmp = $oDb->fetch_assoc($tmprs);
						$this->debug("Estado Alb ".$this->getAttribute('preparado')." Estado Pedido: ".
							$this->getAttribute('preparado','Pedido')." Estado MIN ".$aTmp['status'],'postDump');
						if ($aTmp['status']!='0') {
							$cons = 'UPDATE Pedidos SET preparado = '.$this->getAttribute('preparado').
								' WHERE id_pedido = '.$this->getAttribute('id_pedido');
							$this->debug($cons,'postDump');
							$oDb->query($cons);
							$this->setAttribute('preparado',$this->getAttribute('preparado'),'Pedido');
						}
					}
				}
				$this->setVar('preparado_dborig',$this->getAttribute('preparado'));
			}
			// Revisamos lo que haya que hacer con las bajas.
			if (is_array($this->aoBajas) and sizeof($this->aoBajas) AND !$this->checkFlag($this->ST_DEL)) {
				$aStock = array();
				// 1 - Pedido en negativo/Nota de recogida; 2 - Albaran en positivo/reenviar; 3 - Factura en negativo; 4 - Abono
				$stCorreccion = 4;
				$this->debug("Forma de la correccion administrativa: $stCorreccion ",'postDump');
				$oDoc = $this->__getReturnDocument($stCorreccion);
				foreach (array_keys($this->aoBajas) as $id_det) 
				foreach (array_keys($this->aoBajas[$id_det]) as $key) {
					if ($this->aoBajas[$id_det][$key]['__dbsync__']) {
						$this->debug("baja en posicion $key ya estaba ok ",'postDump');
						continue;
					}
					$aBaja = &$this->aoBajas[$id_det][$key];
					$this->debug("La Baja: ".get_class($aBaja['__instancia__']),'postDump');
					// Lo Primero es Ver que se hace con el stock
					if ($this->isSale()) {
						// Para las ventas!:
						if ($aBaja['causar_baja']) {
							//  	Si HAY que causar baja => _insertamos_ Bajas_localizacion Y dejamos Stock como este
							$aBaja['__instancia__']->alterStock(false);
							$aBaja['__instancia__']->Dump();
						} else {
							//  	Si no hay que causar baja => NO insertamos Bajas_localizacion Y Sumamos Stock
							$aTmp = $aBaja['__instancia__']->getData();
							//$aTmp['cantidad'] *= -1;
							$this->debug(array("Para devolver al stock: "=>$aTmp),'postDump');
							array_push($aStock,$aTmp);
						}
					} else {
						// Para las compras!:
						//    _siempre_ registrar la baja en negativo.
						$cnt = $aBaja['__instancia__']->getAttribute('cantidad');
						$cnt *= -1;
						$aBaja['__instancia__']->setAttribute('cantidad',$cnt);
						if (!(bool)$aBaja['causar_baja']) {
							//  	Si no hay que causar baja => Dejamos el Stock como esta
							$this->debug("Nothing to do",'postDump');
						} else {
							//  	Si HAY que causar baja => Retiramos del stock la devolucion
							$aTmp = $aBaja['__instancia__']->getData();
							$aTmp['cantidad'] *= -1;
							array_push($aStock,$aTmp);
							$this->debug(array("Para retirar del stock: "=>$aTmp),'postDump');
						}
						$aBaja['__instancia__']->Dump();
					}
					$stock_update = $aBaja['cantidad'];
					$this->debug("La cantidad de baja: ".$aBaja['cantidad'],'postDump');
					// Lo Siguiente, ver como se trata administrativamente
					//if ($bAbonar and isset($this->aDetFra[$aRec['id_detalle']));
					switch ($stCorreccion) {
						case 4:
							if (isset($this->aDetFras[$aBaja['id_detalle']])) {
								// Abonamos sobre la _primera_ factura de este detalle
								$id_facturita = $this->aDetFras[$aBaja['id_detalle']][0];
								if (is_numeric($id_facturita) AND !empty($id_facturita) AND is_a($this->aoFacturas[$id_facturita],'Invoice')) {
									// debug("id: $id_facturita det ".$aRec['id_detalle']);
									$idx = $oDoc->get_idxdetail_db($aBaja['id_detalle']);
									if (!is_numeric($idx)) {
										$idx = $this->aoFacturas[$id_facturita]->get_idxdetail_db($aBaja['id_detalle']);
										$this->debug(array("en fra $id_facturita el det ".$aBaja['id_detalle']." Esta en $idx => "=>$this->aoFacturas[$id_facturita]->_aDetIdx),'postDump');
										$this->debug("en fra $id_facturita hay num: ".$this->aoFacturas[$id_facturita]->num_details(),'postDump');
										$oDoc->setInstallment(NULL,$this->aoFacturas[$id_facturita],array($idx => 1),true,false);
										$this->debug("Tenemos un abono con ".$oDoc->num_details()." referencias ",'postDump');
										$idx = $oDoc->get_idxdetail_db($aBaja['id_detalle']);
										$oDoc->set_quantity($idx,$stock_update,NULL,false);
										$this->debug("El idx = $idx , con cantidad ".$oDoc->get_quantity($idx),'postDump');
									} else {
										$this->debug("la Fra $id_facturita ya tenia el detalle. ",'postDump');
										$oDoc->set_quantity($idx,$stock_update,NULL,true);
									}
									$this->debug("idx $idx con $stock_update que son ".$oDoc->get_quantity($idx),'postDump');
								} else {
									$this->debug("No hemos encontrado la clase... que mal rollito. ",'postDump');
									$idx = $oDoc->get_idxdetail_db($aBaja['id_detalle']);
									if (!is_numeric($idx)) {
										$idx = $oDoc->add_detail($aBaja['id_articulo'],$stock_update,0,false);
										$oDoc->setDetailAttribute($idx,'id_detalle',$aBaja['id_detalle']);
										$oDoc->setDetailAttribute($idx,'id_pedido',$this->getAttribute('id_pedido'));
									} else {
										$oDoc->set_quantity($idx,$stock_update,NULL,true);
									}
									/** ** OJO, Para activar lo de aqui, hay que revisarlo
									if ($aCond['precio_articulo'] != $oFactura->get_price($idx,FALSE)) {
										$oFactura->set_price($idx,$aCond['precio_articulo'],FALSE);
									}
									// Corregimos los descuentos:
									if (empty($aCond['descuento_pto']) AND empty($aCond['descuento_monto'])) {
										if ($oFactura->have_discount($idx)) $oFactura->set_detail_discount($idx,0,0,'',TRUE);
									} else {
										if (!empty($aCond['descuento_pto'])) 
											$oFactura->set_detail_discount($idx,$aCond['descuento_pto'],TRUE,' - ',TRUE);
										elseif (!empty($aCond['descuento_monto'])) 
											$oFactura->set_detail_discount($idx,$aCond['descuento_monto'],FALSE,' - ',TRUE);
									}
									$oFactura->setDetailAttribute($idx,'id_pedido',$aCond['id_pedido']);
									$oFactura->_aIDPedido[$aCond['id_pedido']]['id_pedido'] = $aCond['id_pedido'];

									// Fixme: peque�a chapuza para que la factura sepa que tiene albaranes, y no debe actualizar el stock estimado.
									$oFactura->_aIDAlbaran[$aRec['id_albaran']]['referencia'] = $aCond['referencia'];
									$oFactura->_aIDAlbaran[$aRec['id_albaran']]['fecha'] = $aCond['fecha'];
									// Anyadimos referencia del albaran que causa el abono.
									$oFactura->set_detail_comment($idx,$aCond['referencia'].' ('.$aCond['fecha'].'): '.$aRec['descripcion']);
									/** **/
								}
							}
							if (is_object($oDoc) AND $oDoc->num_details()==0) $oDoc = NULL;
					}
					$aBaja['__dbsync__'] = true;
				}
				if (is_array($aStock) and sizeof($aStock))
					$oAlm->stockUpdate($aStock,true,true);

				if (is_object($oDoc)) {
					//debug("Volcando ".get_class($oDoc)." : ".$oDoc->getId()." con ".$oDoc->num_details()." detalles ");
					$oDoc->Dump();
				}
			}
			if (!$this->bVenta) {
			   if (!$this->checkFlag($this->ST_DEL)) {
					$this->debug(array("es de compra. procedemos a informar de estos cambios: "=>$aRefNot),'postDump');
					if (is_array($aRefNot) and sizeof($aRefNot)) {
						$oAlm->notifyStockChange($aRefNot);
					}
				} else $this->debug("De compra, pero lo vamos a borrar, asi que la notificacion pal otro lao. Y los cambios!!",'postDump');
			}
			if (is_a($this->oDetails,'DeliveryEntries')) {
				$this->oDetails->resetDBOrig();
			}
		}
		return $bDumpStat;
	}

	function __getReturnDocument($tipo) {
		switch ($tipo) {
			case 4:
				if (is_array($this->aoBajas) and sizeof($this->aoBajas))
					foreach (array_keys($this->aoBajas) as $id_det) 
						foreach (array_keys($this->aoBajas[$id_det]) as $key) {
							if (!empty($this->aoBajas[$id_det][$key]['id_factura_abono'])) {
								$id_fra = $this->aoBajas[$id_det][$key]['id_factura_abono'];
								break;
							}
					}
				debug("Obteniendo una Fra de Abono. ($id_fra) ");
				$tipo = ( ($this->isSale()) ? inmPed_VENTA : inmPed_COMPRA);
				$oDoc = new Invoice($this->getAppName(),$this->getDbName(),$tipo);
				if (!empty($id_fra)) {
					if (!$oDoc->dbFill($id_fra)) {
						$id_fra = NULL;
						unset($oDoc);
						$oDoc = new Invoice($this->getAppName(),$this->getDbName(),$tipo);
					}
				} 
				if (empty($id_fra)) {
					$id_empresa = $this->getAttribute('id_empresa','Empresa');
					$id_cliente = $this->getAttribute('id_cliente','Destino');
					$id_proveedor = $this->getAttribute('id_proveedor','Origen');
					// Poblamos la factura.
					if ($this->isSale()) {
						$oDoc->set_issuer($id_empresa);
						$oDoc->set_reciever($id_cliente);
					} else {
						$oDoc->set_issuer($id_proveedor);
						$oDoc->set_reciever($id_empresa);
					}
					if (is_array($this->aoFacturas) and sizeof($this->aoFacturas)) {
						$tmp_id = array_shift(array_keys($this->aoFacturas));
						$id_serie = $this->aoFacturas[$tmp_id]->getHeaderAttribute('id_serie_abonar');
						if (!empty($id_serie)) $oDoc->setSeries($id_serie);
					}
					debug("Creada nueva factura en la serie $id_serie ");
				}
				break;

			default:
				$this->debug("El tipo ha sido: $tipo",'__getReturnDoc');
				break;
		}
		return $oDoc;
	}

	function init() {
		parent::init();
		if (is_object($this->oDetails)) {
//			$this->oDetails->init(&$this);
			$this->oDetails->init($this);
		}
	}

	function cerrar() {
		if (is_object($this->oDetails)) {
			$this->debug('Llamando a Hijos .. ','cerrar');
			$this->oDetails->cerrar();
		} else $this->debug("No hay hijos? ... ".get_class($this->oDetails),'cerrar');
		$this->debug('Llamando a Padre .. ','cerrar');
		parent::cerrar();
	}
	/** Fin de los Metodos Abstractos **/

}

/**
* NOTA: Esta clase solo se usa para crear albaranes directos (sin pedido)
**/
class DeliveryNote_IfaceToDocument {
	var $oNote = NULL;
	var $aDiv = array();

	function DeliveryNote_IfaceToDocument($App = NULL,$db = NULL,$tipo = inmPed_VENTA) {
		$this->oNote = new DeliveryNote();
		if (!isset($tipo) or ($tipo & inmPed_VENTA)) {
			$this->oNote->bVenta = true;
		} else {
			$this->oNote->bVenta = false;
		}
		return true;
	}

	function &getNote() {
		return $this->oNote;
	}

	function set_issuer($id) {
		if ($this->oNote->bVenta) {
			$idemp = $this->oNote->getAttribute('id_empresa','Empresa');
			if ($idemp != $id) $this->oNote->updateForeignKey($id,'id_empresa');
		} else {
			$this->oNote->updateSuplier($id);
		}
		return false;
	}

	function set_reciever($id) {
		if ($this->oNote->bVenta) {
			$idcli = $this->oNote->getAttribute('id_cliente','Cliente');
			if ($idcli != $id) $this->oNote->updateForeignKey($id,'id_cliente');
		} else {
			$idemp = $this->oNote->getAttribute('id_empresa','Empresa');
			if ($idemp != $id) $this->oNote->updateForeignKey($id,'id_empresa');
		}
		return false;
	}

	function set_reciever_address($id) {
		if ($this->oNote->bVenta) {
			$iddir = $this->oNote->getAttribute('id_direccion');
			if ($iddir != $id) $this->oNote->updateForeignKey($id,'id_direccion');
		} else {
			$idalm = $this->oNote->getAttribute('id_almacen');
			if ($idalm != $id) $this->oNote->updateForeignKey($id,'id_almacen');
		}
		return false;
	}

	function set_agent($id) {
		return true;
	}

	function set_payment_method($id) {
		debug("TODO: analizar si debe existir forma de pago en Albaranes. ");
		return true;
	}

	function set_currency($id) {
		debug("TODO: analizar si debe existir divisa en Albaranes. ");
		return true;
	}

	function set_name($name) {
		return true;
	}

	function set_comments($notas) {
		if ($this->oNote) $this->oNote->setAttribute('observaciones',$notas);
		return false;
	}

	function get_info() {
		// debug("get_info()");
		return $this->oNote->getData();
	}

	function get_reciever_info() {
		// debug("get_reciever_info()");
		if ($this->oNote->bVenta) {
			$aReceptor = $this->oNote->getData('Cliente');
			$aReceptor['id'] = $aReceptor['id_cliente'];
		} else {
			$aReceptor = $this->oNote->getData('Empresa');
			$aReceptor['id'] = $aReceptor['id_empresa'];
		}
		// print_r($aReceptor);
		return $aReceptor;
	}

	function get_reciever_id() {
		if ($this->oNote->bVenta) {
			$id = $this->oNote->getAttribute('id_cliente','Cliente');
		} else {
			$id = $this->oNote->getAttribute('id_proveedor','Proveedor');
		}
		return $id;
	}

	function get_currency() {
		if ($this->oNote->bVenta) {
			$iddiv = $this->oNote->getAttribute('id_divisa','Cliente');
		} else {
			$iddiv = $this->oNote->getAttribute('id_divisa','Proveedor');
		}
		if (!is_numeric($iddiv)) return NULL;
		if (!is_array($this->aDiv) or !sizeof($this->aDiv) or $this->aDiv['id_divisa'] != $iddiv) {
			$cons = 'SELECT Div.id_divisa as "id_divisa", Div.leyenda as "leyenda", Div.ratio as "ratio" FROM Divisa `Div` WHERE id_divisa = '.$iddiv;
			$oDb = &$this->oNote->getDb();
			$rs = $oDb->query($cons);
			if ($oDb->num_rows($rs)) {
				$this->aDiv = $oDb->fetch_assoc($rs);
			}
			$oDb->libera($rs);
		}
		return $this->aDiv;
	}

	function get_detail_attribute($idx,$attr) {
		if ($this->oNote) {
			$rval = $this->oNote->getDetailAttribute($idx,$attr);
		}
		return $rval;
	}

	function setHeaderAttribute($attr,$val) {
		if ($this->oNote) {
			$rval = $this->oNote->setAttribute($attr,$val);
		}
		return $rval;
	}

	function getId() {
		if ($this->oNote) {
			$id = $this->oNote->getAttribute('id_albaran');
		}
		return $id;
	}

	function first_detail() {
		return $this->oNote->firstDetail();
	}

	function next_detail() {
		return $this->oNote->nextDetail();
	}

	function _build_indexes() {
		return true;
	}

	function add_detail($id_art,$cantidad = NULL,$bBultos = 0,$bCheck_dtos = TRUE,$force_idx = NULL,$aForceIDs = 0) {
		debug("FixMe: metodo add_detail necesita de retoques para convertir la cantidad en bulstos ");
		if ($this->oNote->bVenta) {
			$idx = $this->oNote->newDetail(array('id_articulo'=>$id_art,
						'DetallePedido.cantidad'=>$cantidad,'mBultos'=>$bBultos,'cantidad_devuelta'=>0));
		} else {
			$idx =  $this->oNote->newDetail(array('id_articulo'=>$id_art,'cantidad'=>$cantidad,'mBultos'=>$bBultos));
		}
		$aTmp = $this->oNote->getDetailData('IVA',$idx);
		if ($GLOBALS['DEBUG']=='ON') {
			debug("IVA en add: ");
			print_r($aTmp);
		}
		$this->set_quantity($idx,$cantidad,$bBultos);
		// $this->oNote->setDetailAttribute('cantidad',$cantidad,'DetallePedido',$idx);
		return $idx;
	}

	function get_detail($idx) {
		$aArt = $this->oNote->getDetailData('DetallePedido',$idx);
		$aArt['precio_tarifa'] = $aArt['precio_articulo'];
		$aD = $this->oNote->getDetailData(NULL,$idx);
		if (is_numeric($aD['cantidad'])) $aArt['cantidad'] = $aD['cantidad'];

		$aTmp = $this->oNote->getDetailData('Producto',$idx);
		foreach ($aTmp as $fld => $val) $aArt[$fld] = $val;
		$aTmp = $this->oNote->getDetailData('ProductoEmpresa',$idx);
		foreach ($aTmp as $fld => $val) $aArt[$fld] = $val;
		$aArt['stock_estimado'] = $aTmp['stock_ficticio'];

		$aTmp = $this->oNote->getDetailData('Familia',$idx);
		$aArt['nombre_familia'] = $aTmp['nombre'];

		$aTmp = $this->oNote->getDetailData('Marca',$idx);
		$aArt['nombre_marca'] = $aTmp['nombre'];
		$aTmp = $this->oNote->getDetailData('IVA',$idx);
		if ($GLOBALS['DEBUG']=='ON') {
			debug("IVA: ");
			print_r($aTmp);
		}
		$aArt['porcentaje'] = $aTmp['porcentaje'];
		$aArt['idx_detalle'] = $idx;

		$bultos = $this->get_quantity($idx,1); 
		$capas = $this->get_quantity($idx,2); 
		$palets = $this->get_quantity($idx,3); 
		$cant = $this->get_quantity($idx);
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
		$aArt['precio_articulo'] = $aArt['precio'] = $this->get_price($idx);
		if ($GLOBALS['DEBUG']=='ON') {
			debug("Lista: ");
			print_r($aArt);
		}

		return $aArt;
	}

	function get_quantity($idx_det,$bBultos = 0, $mTipo = inmPed_QUANTITY) {
		$campo_cantidad = 'DetallePedido.cantidad';
		if ($bBultos)
			if ($bBultos == 1 AND (int)$this->oNote->getDetailAttribute('unidades_bulto','ProductoEmpresa',$idx_det)) {
				$cant = $this->oNote->getDetailAttribute($campo_cantidad,NULL,$idx_det) / 
							$this->oNote->getDetailAttribute('unidades_bulto','ProductoEmpresa',$idx_det);
			} elseif ($bBultos==2 AND $this->oNote->getDetailAttribute('unidades_bulto','ProductoEmpresa',$idx_det)
					AND $this->oNote->getDetailAttribute('bultos_capa_palet','ProductoEmpresa',$idx_det)) {
				$cant = $this->oNote->getDetailAttribute($campo_cantidad,NULL,$idx_det) /
						($this->oNote->getDetailAttribute('unidades_bulto','ProductoEmpresa',$idx_det) * 
						$this->oNote->getDetailAttribute('bultos_capa_palet','ProductoEmpresa',$idx_det) );
			} elseif ($bBultos==3 AND $this->oNote->getDetailAttribute('unidades_bulto','ProductoEmpresa',$idx_det)
				AND $this->oNote->getDetailAttribute('bultos_capa_palet','ProductoEmpresa',$idx_det)
					AND $this->oNote->getDetailAttribute('capas_palet','ProductoEmpresa',$idx_det) ) {
				$cant =  $this->oNote->getDetailAttribute($campo_cantidad,NULL,$idx_det) /
					($this->oNote->getDetailAttribute('unidades_bulto','ProductoEmpresa',$idx_det) *
					$this->oNote->getDetailAttribute('bultos_capa_palet','ProductoEmpresa',$idx_det) *
					$this->oNote->getDetailAttribute('capas_palet','ProductoEmpresa',$idx_det));
			} else {
				//Fixme: revisar consecuencias de comentar esto.
				//  $this->error(510,"El detalle indicado no tiene unidades por bulto. Division por 0");
				return NULL;
			}
		else $cant = $this->oNote->getDetailAttribute($campo_cantidad,NULL,$idx_det);

		return $cant;
	}

	function get_price($idx_det,$bDiscount = true) {
		return $this->oNote->getDetailAttribute('precio_articulo','DetallePedido',$idx_det);
	}

	function getarticlecontracts() {
		return NULL;
	}

	function set_quantity($idx_det,$cantidad,$bBultos = 0,$bSuma = FALSE,$mTipo = inmPed_QUANTITY,$bDtos = TRUE) {
		if ($bBultos) 
			if ($bBultos==1 AND is_numeric($this->oNote->getDetailAttribute('unidades_bulto','ProductoEmpresa',$idx_det))) {
				$cantidad *= ($this->oNote->getDetailAttribute('unidades_bulto','ProductoEmpresa',$idx_det));
			} elseif ($bBultos==2 AND is_numeric($this->oNote->getDetailAttribute('unidades_bulto','ProductoEmpresa',$idx_det))
					AND is_numeric($this->oNote->getDetailAttribute('bultos_capa_palet','ProductoEmpresa',$idx_det))) {
				$cantidad *= ($this->oNote->getDetailAttribute('unidades_bulto','ProductoEmpresa',$idx_det) *
									($this->oNote->getDetailAttribute('bultos_capa_palet','ProductoEmpresa',$idx_det)));
			} elseif ($bBultos==3 AND is_numeric($this->oNote->getDetailAttribute('unidades_bulto','ProductoEmpresa',$idx_det))
					AND is_numeric($this->oNote->getDetailAttribute('bultos_capa_palet','ProductoEmpresa',$idx_det))
					AND is_numeric($this->oNote->getDetailAttribute('capas_palet','ProductoEmpresa',$idx_det))) {
				$cantidad *= ($this->oNote->getDetailAttribute('unidades_bulto','ProductoEmpresa',$idx_det) *
									($this->oNote->getDetailAttribute('bultos_capa_palet','ProductoEmpresa',$idx_det)) *
									($this->oNote->getDetailAttribute('capas_palet','ProductoEmpresa',$idx_det)) );
			}

		$oDet = &$this->oNote->getDetails();
		$cnti = $oDet->getAttribute('cantidad','DetallePedido',$idx_det);
		return $oDet->setAttribute('cantidad',$cantidad,'DetallePedido',$idx_det);
	}

	function calculate() {
		debug("FixMe: Metodo calculate(): Falta calcular los totales. ");
		return true;
	}

	function get_taxes() {
		debug("FixMe: Metodo get_taxes(): Falta agrupar los impuestos ");
		return NULL;
	}

	function get_discounts() {
		// debug("FixMe: Metodo get_taxes(): Falta agrupar los impuestos ");
		return NULL;
	}

	function get_totals() {
		debug("FixMe: Metodo get_totals(): Falta calcular los totales. ");
		return NULL;
	}

	function get_issuer_info() {
		if ($this->oNote->bVenta) {
			$aEmisor = $this->oNote->getData('Empresa');
		} else {
			$aEmisor = $this->oNote->getData('Proveedor');
		}
		return $aEmisor;
	}

	function dbDump() {
		if ($this->oNote) return $this->oNote->Dump();
		else return NULL;
	}

}

?>
