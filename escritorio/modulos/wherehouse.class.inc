<?php

class Wherehouse extends dbItemMultiEntity {
	var $aDeliveryNotes = NULL;
	var $idxArt = NULL;
	var $idxCodBarras = NULL;
	var $idxSKU = NULL;
	var $oIdxSKURef = NULL;
	var $ptrLocation = NULL;
	var $bLocked = NULL; // Si la localizacion activa esta bloqueada. (solo se muestran sus referencias)
	var $iLockedID = NULL; // Si un idarticulo esta bloqueado. (solo se muestra este prod en sus dist localizaciones).
	var $aIgnorados = NULL; // Lista de idx_alb[idx] = bool ignorados temporalmente para el notespack

	function Wherehouse($AppName = NULL, $dbname = 'data', $aData = NULL) {
		if (empty($AppName)) $AppName = $GLOBALS['APP_NAME'];
		$tabla = 'Almacenes';

		$aFlds['Almacenes:Almacen'] = array(
				'id_almacen','id_empresa','id_provincia',
				'nombre','direccion','cp','poblacion','telefono','fax','email','cargo_persona_contacto','persona_contacto','nota_pie_albaran'
				);
		$aFlds['Empresas:Empresa'] = array(
				'id_empresa',
				'razon_social','nombre','apellidos','direccion_facturacion','cp','poblacion','telefono1','fax','email','stock_negativo'
				);

		$aAcciones['id_empresa'] = array('method' => 'updateForeignKey');

		if (!parent::dbItemMultiEntity($AppName,$dbname,$tabla,$aFlds,$aData,$aAcciones)) {
			$this->setFlag($this->ST_CORRUPT);
			return false;
		}
	}

	function dbFill($id) {
		if (is_numeric($id)) return parent::dbFill(array('id_almacen' => $id));
		else return parent::dbFill($id);
	}

	function getId() {
		return $this->getAttribute('id_almacen');
	}

	function fetchId() {
		$id = $this->getAttribute('id_almacen');
		if ($id) return TRUE;
		$ide = $this->getAttribute('id_empresa');
		if (!$ide) return FALSE;
		$this->dbFill(array('id_empresa'=>$ide));
		return TRUE;
	}

	function getLocationsForCheckOut($aProds,$id_alm = -1,$id_emp = NULL,$aNotAlb = NULL,$bAll = false,$aOpts=array()) {
		$oDb = &$this->getDb();

		if (!is_array($aProds) OR !sizeof($aProds)) return NULL;
		if (empty($id_emp)) $id_emp = $this->getAttribute('id_empresa');
		if (empty($id_emp)) return NULL;
		if (!isset($bAll)) $bAll = false;

		if (($id_alm==-1 or !is_numeric($id_alm)) and $this->getId()) {
			$id_alm = $this->getId();
			$bCont = true;
		} elseif (!empty($id_alm)) $bCont = $this->dbFill(array('id_almacen' => $id_alm));
		else $bCont = $this->updateForeignKey($id_emp,'id_empresa');

		if (!$bCont) {
			$this->debug("No hemos sacado los datos de el almacen ($id_alm)... exiting..",'getLocationsForCheckOut');
			return NULL;
		}

		$aPList = array_keys($aProds);
		foreach ($aPList as $ida) $str_prods .= ( (!empty($str_prods)) ? ' OR ' : '' ).' id_articulo = '.$ida;
		if (is_array($aNotAlb) and sizeof($aNotAlb)) 
			foreach ($aNotAlb as $ida) if (!empty($ida)) $str_alb .= ( (!empty($str_alb)) ? ' AND ' : '' ).' A.id_albaran != '.$ida;

		// Descartamos las referencias de albaranes de venta sin preparar
		$cons = 'SELECT STRAIGHT_JOIN DA.*, A.referencia,A.fecha,A.preparado,Ld.id_articulo '.
					'FROM Albaranes A JOIN Pedidos P ON (A.id_pedido=P.id_pedido AND (P.id_proveedor IS NULL OR P.id_proveedor = 0)) '.
					'JOIN Detalles_albaran DA ON (DA.id_albaran = A.id_albaran) JOIN Lineas_detalle Ld ON (Ld.id_detalle=DA.id_detalle) '.
					'WHERE ( '.$str_prods.' ) '.((!empty($id_alm))
						? ' AND A.id_almacen = '.$id_alm
						: ( (!empty($id_emp)) ? ' AND P.id_empresa = '.$id_emp : '' ) ).' '.
					( (!empty($str_alb)) ? ' AND ( '.$str_alb.' ) ' : '' ). 
					'AND A.preparado = 0 AND (DA.planta != 0 OR DA.pasillo != 0 OR DA.fila != 0 OR DA.columna != 0) AND DA.stock_previsto != 0 ';
		$rs = $oDb->query($cons);
		//$this->debug($cons." nr: ".$oDb->num_rows($rs),'getLocationsForCheckOut');
		if ($oDb->num_rows($rs)) 
			while ($aDet = $oDb->fetch_assoc($rs)) {
				if (!is_array($aDoneList[$aDet['id_articulo']])) $aDoneList[$aDet['id_articulo']] = array();
				array_push($aDoneList[$aDet['id_articulo']],$aDet);
				// debug("Registro: ");
				// print_r($aDet);
			}

		//Fixme: AÑADIR LAS LOCALIZACIONES DE ALBARANES DE COMPRA VERIFICADAS PERO SIN ALBARAN PREPARADO

		//nocnt_loclimit
		if (isset($aOpts['stock_negativo'])) $bStockNeg = (bool)$aOpts['stock_negativo'];
		else $bStockNeg = (bool)$this->getAttribute('stock_negativo','Empresa');
		$cons = 'SELECT Al.id_almacen, '.
					'La.id_almacen_logico, La.id_articulo, '.
					'La.lote, La.fecha_caducidad, '.
					'La.planta, La.fila, La.pasillo, La.columna, '.
					'La.cantidad '.
					'FROM Localizacion_articulos La JOIN Almacenes_logicos Al ON (La.id_almacen_logico=Al.id_almacen_logico) '.
					'JOIN Almacenes A ON (Al.id_almacen = A.id_almacen) '.
					'WHERE ('.$str_prods.' )'.((!empty($id_alm)) 
							? ' AND Al.id_almacen = '.$id_alm 
							: ( (!empty($id_emp)) ? ' AND A.id_empresa = '.$id_emp : '' ) ).' '.
					( (!$bStockNeg) ? ' AND La.cantidad > 0 ' : '').
					'ORDER BY La.id_articulo, Al.id_almacen asc, La.fecha_caducidad asc ';
		$locrs = $oDb->query($cons);
		$n_rows = $oDb->num_rows($locrs);
		$this->debug($cons." nr:".$n_rows,'getLocationsForCheckOut');
		/** **
		if (!$n_rows) {
			if ($bStockNeg) {
				$this->debug('No existe localizacion, pero stock_negativo esta on ','getLocationsForCheckOut');
				//$aRetVal[$aL['id_almacen']][$id_art_act]['total_solicitado'] = $cantidad_pendiente;
			}
			return array();
		}
		/** **/
		$aRetVal = array();
		$aList = array();
		if ($n_rows) {
			while ($aL = $oDb->fetch_assoc($locrs)) {
				// Primero Quitamos las localizaciones reservadas por otros albaranes no preparados
				if (is_array($aDoneList[$aL['id_articulo']])) {
					$this->debug("Ref ".$aL['id_articulo']." Tiene localizaciones reservadas en otros albaranes. las quitamos. ",
									'getLocationsForCheckOut');
					foreach ($aDoneList[$aL['id_articulo']] as $idx => $aRef) {
						if ( $this->__compareLocation($aRef,$aL,true)) {
							$this->debug(array("La ref coincide, Eliminandola de las posibilidades: "=>$aL),'getLocationsForCheckOut');
							// Si es un albaran de devolucion, no descontamos nada.
							if ($aRef['stock_previsto']>0 ) {
								if ($aL['cantidad']<=$aRef['stock_previsto']) {
									$aL['cantidad'] = 0;
									$aDoneList[$aL['id_articulo']]['cantidad'] -= $aL['cantidad'];
								} else {
									$aL['cantidad'] -= $aRef['stock_previsto'];
									$aDoneList[$aL['id_articulo']]['cantidad'] = 0;
								}
							}
							// Si ya hemos descontado esta cantidad no preparada, de las posible localizaciones, removemos la linea
							if ( (abs($aDoneList[$aL['id_articulo']]['cantidad']) < pow(10,-6)) ) {
								$aDoneList[$aL['id_articulo']][$idx] = NULL;
								unset($aDoneList[$aL['id_articulo']][$idx]);
							}
						}
					}
				}
				//Nos interesa tener la loc, aunque sea con cantidad 0 
				// if ( !(abs($aL['cantidad']) < pow(10,-6))) array_push($aList,$aL);
				array_push($aList,$aL);
			}
			$this->debug(array('Lista de Loc encontradas' => $aList),'getLocationsForCheckOut');
			$n_rows = sizeof($aList);
			foreach ($aList as $i => $aL) {
				// debug("\n<hr>");
				$this->debug("Estamos en ".$aL['id_articulo']." : total $n_rows rows",'getLocationsForCheckOut');
				// print_r($aList);
				// Inicializamos el producto.
				if (!$id_alm) $id_alm = $aL['id_almacen'];
				if ($aL['id_articulo'] != $id_art_act) {
					$id_art_act = $aL['id_articulo'];
					$cantidad_pendiente = $aProds[$id_art_act];
					$nRes = 0;
					// Numero de localizaciones para esta referencia.
					for ($j=$i;$j < $n_rows;$j++) {
						$aTmp = $aList[$j];
						if ($aTmp['id_articulo'] == $id_art_act) $nRes++;
						else break;
					}
					$this->debug("Data seek de uno mas alante de $i .. ",'getLocationsForCheckOut');
					$oDb->data_seek($locrs,$i+1);
					$nResPend = $nRes-1;
					if (!is_array($aRetVal[$aL['id_almacen']][$id_art_act])) $aRetVal[$aL['id_almacen']][$id_art_act] = array();
					$aRetVal[$aL['id_almacen']][$id_art_act]['total_solicitado'] = $cantidad_pendiente;
					$this->debug("El articulo $id_art_act tiene $nRes locs, sin incluir esta quedan $nResPend para extraer $cantidad_pendiente Uds ",'getLocationsForCheckOut');
				} else {
					// debug("Sin dataseek $i + 1 ");
					$nResPend--;
				}

				$this->debug("CantidadPendiente: $cantidad_pendiente ",'getLocationsForCheckOut');
				// Ya hemos terminado con esta referencia, pasamos a la siguiente.
				if ( $cantidad_pendiente <= pow(10,-6) ) { 
					$this->debug("Ya <b>no</b> queda cantidad pendiente para $id_art_act ... ",'getLocationsForCheckOut');
					continue;
				}

				// Las localizaciones negativas o a 0 directamente no cuentan para nada
				// debug("Resultados pendientes: $nResPend ");
				if (!empty($nResPend) AND // Si no estamoe en la ultima referencia
						$cantidad_pendiente > 0 AND // Y no es una devolucion
						$aL['cantidad'] <= pow(10,-6)) { // Nos saltamos las localizaciones negativas. (o 0)
					// debug("Nos saltamos esta localizacion Negativa: ");
					// print_r($aL);
					continue; 
				}

				if (($cantidad_pendiente < 0 OR // Si es una devolucion al almacen
						($cantidad_pendiente > 0 AND $aL['cantidad']-$cantidad_pendiente >= 0) OR // o en esta loc hay suficiente 
						(empty($nResPend) AND $bStockNeg)) AND !$bAll ) { // o es la ultima y no nos importa dejarla en negativo
					// Restamos de esta localizacion _toda_ la cantidad pendiente.
					$this->debug("Quitamos en localizacion (T:$nResPend) toda la cant de $cantidad_pendiente y tiene $aL[cantidad] ... ",'getLocationsForCheckOut');
					$aSLoc = $aL;
					$aSLoc['cantidad'] = $cantidad_pendiente;
					$cantidad_pendiente = 0;
					if ($nResPend) {
						$this->debug("Deberiamos <b>saltarnos</b> $nResPend registros ... estando en $i vamos a ".($i+1+$nResPend)." ..",'getLocationsForCheckOut');
						$oDb->data_seek($locrs,(($i+1)+$nResPend));
						$i += $nResPend;
						if ($i+1>=$n_rows) $bDelayedBreak = true;
					}
				} else {
					$this->debug("USamos ".$aL['cantidad']." que es _todo lo que queda ",'getLocationsForCheckOut');
					$aSLoc = $aL;
					$cantidad_pendiente -= $aSLoc['cantidad'];
				}

				// Sumamos la localizacion actual. (El primer indice es el id_almacen!!)
				if (!is_array($aRetVal[$aSLoc['id_almacen']][$id_art_act]['localizaciones'])) 
						$aRetVal[$aSLoc['id_almacen']][$id_art_act]['localizaciones'] = array();
				$this->debug("Para $id_art_act le sumamos RVal:".$aRetVal[$aSLoc['id_almacen']][$id_art_act]['cantidad']." Cnt:".
							$aSLoc['cantidad'],'getLocationsForCheckOut');
				$aRetVal[$aSLoc['id_almacen']][$id_art_act]['cantidad'] += $aSLoc['cantidad'];
				array_push($aRetVal[$aSLoc['id_almacen']][$id_art_act]['localizaciones'],$aSLoc);

				$this->debug("localizacion: break? ".(int)$bDelayedBreak,'getLocationsForCheckOut');
				// print_r($aRetVal);
				if ($bDelayedBreak) break;
			}
		}
		if ($bStockNeg) {
			$this->debug('Stock negativo permitido. devolvemos las ref no localizadas con localizacion 0 ','getLocationsForCheckOut');
			if (!$id_alm) {
				$id_alm = $this->getId();
				if (!$id_alm and $this->fetchId()) $id_alm = $this->getId();
			}
			foreach ($aProds as $ref => $cnt) {
				$bFound = FALSE;
				if (is_array($aRetVal) and sizeof($aRetVal))
					foreach (array_keys($aRetVal) as $ida) {
						if (is_array($aRetVal[$ida][$ref])) {
							$bFound = TRUE;
							break;
						}
					}
				if (!$bFound) {
					$aTmp = array('total_solicitado'=>$cnt,'cantidad'=>$cnt,'localizaciones'=>array());
					array_push($aTmp['localizaciones'],array('id_almacen'=>$id_alm,'id_almacen_logico'=>'0',
								'id_articulo'=>$ref,'lote'=>'','planta'=>'0','fecha_caducidad'=>'0000-00-00','fila'=>'0',
								'pasillo'=>'0','columna'=>'0','cantidad'=>$cnt));
					$aRetVal[$id_alm][$ref] = $aTmp;
				}
			}
		}
		$this->debug(array('Las loc: '=>$aRetVal),'getLocationsForCheckOut');
		return $aRetVal;
	}

	function getLocationsForCheckIn($aProds,$id_alm = -1,$id_emp = NULL,$aNotAlb = NULL,$bAll = false,$aOpts=array()) {
		$oDb = &$this->getDb();

		if (!is_array($aProds) OR !sizeof($aProds)) return NULL;
		if (empty($id_emp)) $id_emp = $this->getAttribute('id_empresa');
		if (empty($id_emp)) return NULL;

		if ($id_alm==-1 and $this->getId()) {
			$id_alm = $this->getId();
			$bCont = true;
		} elseif (!empty($id_alm)) $bCont = $this->dbFill(array('id_almacen' => $id_alm));
		else {
			$this->updateForeignKey($id_emp,'id_empresa');
			$bCont = true;
		}

		if (!$bCont) {
			debug("No hemos sacado todos los datos de registro de el almacen... exiting..");
			return NULL;
		}
		$aRetVal = array();

		$aPList = array_keys($aProds);
		foreach ($aPList as $ida) $str_prods .= ( (!empty($str_prods)) ? ' OR ' : '' ).' id_articulo = '.$ida;

		//nocnt_loclimit
		if (isset($aOpts['nocnt_loclimit'])) {
			$nlimit = $aOpts['nocnt_loclimit'];
			debug("LocLIMIT! ".$nlimit);
		}
		$cons = 'SELECT Al.id_almacen, '.
					'La.id_almacen_logico, La.id_articulo, '.
					'La.lote, La.fecha_caducidad, '.
					'La.planta, La.fila, La.pasillo, La.columna, '.
					'La.cantidad '.
					'FROM Localizacion_articulos La JOIN Almacenes_logicos Al ON (La.id_almacen_logico=Al.id_almacen_logico) '.
					'JOIN Almacenes A ON (Al.id_almacen = A.id_almacen) '.
					'WHERE ('.$str_prods.' )'.((!empty($id_alm)) 
							? ' AND Al.id_almacen = '.$id_alm 
							: ( (!empty($id_emp)) ? ' AND A.id_empresa = '.$id_emp : '' ) ).' '.
					'ORDER BY La.id_articulo, Al.id_almacen asc, La.fecha_caducidad desc';
		$locrs = $oDb->query($cons);
		$n_rows = $oDb->num_rows($locrs);
		debug($cons." nr: ".$n_rows);

		if ($n_rows) {
			$aRefCnt = array();
			$id_art_act = NULL;
			while ($aL = $oDb->fetch_assoc($locrs)) {
				if ($aL['id_articulo'] != $id_art_act) {
					if (!$id_alm) $id_alm = $aL['id_almacen'];
					$id_art_act = $aL['id_articulo'];
					$aL['cantidad'] = $aProds[$id_art_act];
					if (!is_array($aRetVal[$aL['id_almacen']][$id_art_act]['localizaciones'])) 
							$aRetVal[$aL['id_almacen']][$id_art_act]['localizaciones'] = array();
					array_push($aRetVal[$aL['id_almacen']][$id_art_act]['localizaciones'],$aL);
				}
			}
		}

		if (!$id_alm) {
			$id_alm = $this->getId();
			if (!$id_alm and $this->fetchId()) $id_alm = $this->getId();
		}
		if (!$id_alm) {
			$this->debug('Error: imposible determinar almacen','getLocationsForCheckIn');
		} else {
			$aPte = $aPList;
			//$this->debug(array('La lista de pte 1: ' => $aPte,'La lista rval '=>$aRetVal),'getLocationsForCheckIn');
			//Quitamos las referencias ya localizadas -con localizacion-
			foreach (array_keys($aRetVal) as $idAlm) { $aPte = array_diff($aPte,array_keys($aRetVal[$idAlm])); }
			$this->debug(array('Las referencias sin localizacion son: '=>$aPte),'getLocationsForCheckIn');
			foreach ($aPte as $id) {
				$aRetVal[$id_alm][$id]['localizaciones'] = array();
				$aTmp = array('id_almacen'=>$id_alm,'id_almacen_logico'=>'0','id_articulo'=>$id,'lote'=>'','planta'=>'0',
								'fecha_caducidad'=>'0000-00-00','fila'=>'0','pasillo'=>'0','columna'=>'0','cantidad'=>$aProds[$id]);
				array_push($aRetVal[$id_alm][$id]['localizaciones'],$aTmp);
			}
		}

		return $aRetVal;
	}

	function getAvailableStock($aProds,$id_alm = NULL,$id_emp = NULL) {
		$oDb = &$this->getDb();

		if (!is_array($aProds) OR !sizeof($aProds)) return NULL;
		if (empty($id_emp)) $id_emp = $this->getAttribute('id_empresa');
		if (empty($id_emp)) return NULL;

		$this->debug("Bucando almacen $id_alm con empresa $id_emp ",'getAvailableStock');
		if ( ($id_alm==-1 or !isset($id_alm)) and $this->getId()) {
			$id_alm = $this->getId();
			$bCont = true;
		} elseif (!empty($id_alm)) $bCont = $this->dbFill(array('id_almacen' => $id_alm));
		else $bCont = $this->updateForeignKey($id_emp,'id_empresa');

		if (!$bCont) {
			$this->debug("No hemos sacado todos los datos en el almacen... exiting..",'getAvailableStock');
			return NULL;
		}

		$aPList = array_keys($aProds);
		foreach ($aPList as $ida) $str_prods .= ( (!empty($str_prods)) ? ' OR ' : '' ).' id_articulo = '.$ida;

		// Obtenemos el stock en almacenes
		$cons = 'SELECT Al.id_almacen, La.id_articulo, SUM(La.cantidad) as "cantidad" '.
					'FROM Localizacion_articulos La JOIN Almacenes_logicos Al ON (La.id_almacen_logico=Al.id_almacen_logico) '.
					'JOIN Almacenes A ON (Al.id_almacen = A.id_almacen) '.
					'WHERE ( '.$str_prods.' ) '.((!empty($id_alm))
						? ' AND A.id_almacen = '.$id_alm
						: ( (!empty($id_emp)) ? ' AND A.id_empresa = '.$id_emp : '' ) ).' '.
					'GROUP BY Al.id_almacen, La.id_articulo '.
					'ORDER BY La.id_articulo, Al.id_almacen asc ';
		// debug($cons);
		$rs = $oDb->query($cons);
		if ($oDb->num_rows($rs)) 
			while ($aDet = $oDb->fetch_assoc($rs)) {
				if (!is_array($aFullStock[$aDet['id_almacen']][$aDet['id_articulo']])) $aFullStock[$aDet['id_almacen']][$aDet['id_articulo']] = 0;
				$aFullStock[$aDet['id_almacen']][$aDet['id_articulo']] = $aDet['cantidad'];
			}


		// Descartamos las referencias de albaranes sin preparar
		$cons = 'SELECT STRAIGHT_JOIN A.id_almacen,Ld.id_articulo,SUM(DA.stock_previsto) as "cantidad" '.
					'FROM Albaranes A JOIN Pedidos P ON (A.id_pedido=P.id_pedido AND (P.id_proveedor IS NULL OR P.id_proveedor = 0)) '.
					'JOIN Lineas_detalle Ld ON (Ld.id_pedido=P.id_pedido ) JOIN Detalles_albaran DA ON (DA.id_detalle = Ld.id_detalle AND A.id_albaran=DA.id_albaran) '.
					'WHERE ( '.$str_prods.' ) '.((!empty($id_alm))
						? ' AND A.id_almacen = '.$id_alm
						: ( (!empty($id_emp)) ? ' AND P.id_empresa = '.$id_emp : '' ) ).' '.
					'AND P.id_empresa = 1 AND A.preparado = 0 '.
					'GROUP BY A.id_almacen,Ld.id_articulo '.
					'ORDER BY Ld.id_articulo,A.id_almacen asc ';
		// debug($cons);
		$rs = $oDb->query($cons);
		if ($oDb->num_rows($rs)) 
			while ($aDet = $oDb->fetch_assoc($rs)) {
				if (empty($aFullStock[$aDet['id_almacen']][$aDet['id_articulo']])) $aFullStock[$aDet['id_almacen']][$aDet['id_articulo']] = 0;
				$aFullStock[$aDet['id_almacen']][$aDet['id_articulo']] -= $aDet['cantidad'];
			}

		if ($GLOBALS['DEBUG']=='ON') {
			$this->debug(array("<b>Full Stock</b> Available (revisando..): -Falta sumar las compras disponibles- "=>$aFullStock),
							'getAvailableStock');
			//print_r($aFullStock);
		}

		$aRetVal = array();
		foreach ($aProds as $id_art => $cnt) {
			// debug("Buscando $cnt de $id_art ");
			$bFound = FALSE;
			foreach (array_keys($aFullStock) as $idAlm) {
				if ($aFullStock[$idAlm][$id_art] <=0) continue;
				$bFound = TRUE;
				$this->debug("en almacen $idAlm hay ".$aFullStock[$idAlm][$id_art]." con una cnt de $cnt - ".$aRetVal[$idAlm][$id_art],
								'getAvailableStock');
				if ($aFullStock[$idAlm][$id_art]>= ($cnt-$aRetVal[$idAlm][$id_art]) ) {
					$aRetVal[$idAlm][$id_art] += $cnt;
					$this->debug("Encontrada toda la cantidad en almacen $idAlm ",'getAvailableStock');
					break;
				} else $aRetVal[$idAlm][$id_art] += $aFullStock[$idAlm][$id_art];
				// debug("en retval vamos a dejar  ".$aRetVal[$idAlm][$id_art]);
			}
			if ($bFound and (bool)$this->getAttribute('stock_negativo','Empresa')) {
				$this->debug('stock_negativo => rellenando cantidades encontradas -si toca-','getAvailableStock');
				$cnt_tot = 0;
				foreach (array_keys($aRetVal) as $ida) { $cnt_tot += $aRetVal[$ida][$id_art]; }
				if ($cnt_tot < $cnt) {
					foreach (array_reverse(array_keys($aRetVal),true) as $ida) {
						if ($aRetVal[$ida][$id_art]>0) {
							$this->debug("stock_negativo => rellenando ref $id_art en alm: $ida es: ".$aRetVal[$ida][$id_art]." + ".
											($cnt-$cnt_tot)." = ".($aRetVal[$ida][$id_art]+($cnt-$cnt_tot)),'getAvailableStock');
							$aRetVal[$ida][$id_art] += ($cnt-$cnt_tot);
						}
					}
				}
			}
			if (!$bFound and (bool)$this->getAttribute('stock_negativo','Empresa')) {
				$this->debug('stock_negativo => forzando cantidad a la pedida.','getAvailableStock');
				$idAlm = $this->getId();
				if (!$idAlm) {
					$this->debug('id_almacen desconocido, probando con fetchId()','getAvailableStock');
					if ($this->fetchId()) {
						$idAlm = $this->getId();
					}
				}
				if (!$idAlm) {
					$this->debug('Error: stock_negativo. pero imposible determinar almacen','getAvailableStock');
				} else {
					$this->debug("stock_negativo. Alm: $idAlm Ref: $id_art Cnt: $cnt ",'getAvailableStock');
					$aRetVal[$idAlm][$id_art] = $cnt;
				}
			}
		}

		return $aRetVal;
	}

	function getMinExpiration($aProds,$id_alm = NULL,$id_emp = NULL) {
		$oDb = &$this->getDb();

		if (!is_array($aProds) OR !sizeof($aProds)) return NULL;
		if (empty($id_emp)) $id_emp = $this->getAttribute('id_empresa');
		if (empty($id_emp)) return NULL;

		if ($id_alm==-1 and $this->getId()) {
			$id_alm = $this->getId();
			$bCont = true;
		} elseif (!empty($id_alm)) { $bCont = $this->dbFill(array('id_almacen' => $id_alm)); }
		else { $bCont = $this->updateForeignKey($id_emp,'id_empresa'); }
		if (!$bCont) {
			debug("No hemos sacado todos los datos en el almacen... exiting..");
			return NULL;
		}
		$aPList = array_keys($aProds);
		foreach ($aPList as $ida) $str_prods .= ( (!empty($str_prods)) ? ' OR ' : '' ).' A.id_articulo = '.$ida;

		//FixMe: Reducir estas 2 consultas de abajo, a 1 sola. y hacerlas multiempresa (Ea.id_empresa!=1)
		// Obtenemos la fechas Orientativas cuando hay fechas en loc superiores a la minima. (la mejor fecha conocida)
		$cons = 'SELECT Al.id_almacen,A.id_articulo,MAX(La.fecha_caducidad) as "fecha_caducidad" '.
					'FROM Articulos A JOIN Empresas_articulos Ea ON (A.id_articulo=Ea.id_articulo) '.
					'LEFT JOIN Localizacion_articulos La ON (La.id_articulo=A.id_articulo) LEFT JOIN Almacenes_logicos Al ON (Al.id_almacen_logico=La.id_almacen_logico) '.
					'WHERE (La.fecha_caducidad >= DATE_ADD(NOW(),INTERVAL (A.dias_vida*Ea.pto_vida_venta/100) DAY)) AND '.
					'( '.$str_prods.' ) '.((!empty($id_alm))
						? ' AND Al.id_almacen = '.$id_alm
						: ( (!empty($id_emp)) ? ' AND Ea.id_empresa = '.$id_emp : '' ) ).' '.
					'GROUP BY A.id_articulo';
		// debug($cons);
		$rs = $oDb->query($cons);
		$tmp_id_alm = 0;
		if ($oDb->num_rows($rs)) 
			while ($aDet = $oDb->fetch_assoc($rs)) {
				if (!is_array($aFullStock[$aDet['id_almacen']][$aDet['id_articulo']])) $aFullStock[$aDet['id_almacen']][$aDet['id_articulo']] = 0;
				$aFullStock[$aDet['id_almacen']][$aDet['id_articulo']] = $aDet['fecha_caducidad'];
				$tmp = NULL;
				$tmp = array_search($aDet['id_articulo'],$aPList);
				if (is_numeric($aPList[$tmp])) unset($aPList[$tmp]);
				$this->debug("Eliminando item pos $tmp con ".$aDet['id_articulo']." ... ",'getMinExpiration');
			}
		$oDb->libera($rs);

		$str_prods = '';
		foreach ($aPList as $ida) $str_prods .= ( (!empty($str_prods)) ? ' OR ' : '' ).' A.id_articulo = '.$ida;
		// Ahora buscamos la fecha minima, o la mayor si no hay minima, de los prod que no se encontraron antes.
		$cons = 'SELECT Al.id_almacen,A.id_articulo, '.
					'IF(A.dias_vida AND Ea.pto_vida_venta,DATE_ADD(NOW(),INTERVAL (A.dias_vida*Ea.pto_vida_venta/100) DAY),MAX(La.fecha_caducidad)) as "fecha_caducidad" '.
					'FROM Articulos A JOIN Empresas_articulos Ea ON (A.id_articulo=Ea.id_articulo) '.
					'LEFT JOIN Localizacion_articulos La ON (La.id_articulo=A.id_articulo) LEFT JOIN Almacenes_logicos Al ON (Al.id_almacen_logico=La.id_almacen_logico) '.
					'WHERE '.
					'( '.$str_prods.' ) '.((!empty($id_alm))
						? ' AND Al.id_almacen = '.$id_alm
						: ( (!empty($id_emp)) ? ' AND Ea.id_empresa = '.$id_emp : '' ) ).' '.
					'GROUP BY A.id_articulo';
		// debug($cons);
		if ($tmp_id_alm) {
			$this->dbFill(array('id_almacen'=>$tmp_id_alm));
			$id_alm = $this->getId();
		}
		if (!$id_alm) {
			$id_alm = $this->getId();
			if (!$id_alm and $this->fetchId()) $id_alm = $this->getId();
		}
		$rs = $oDb->query($cons);
		if ($oDb->num_rows($rs)) 
			while ($aDet = $oDb->fetch_assoc($rs)) {
				if (!$aDet['id_almacen']) $aDet['id_almacen']=$id_alm;
				if (!is_array($aFullStock[$aDet['id_almacen']][$aDet['id_articulo']])) $aFullStock[$aDet['id_almacen']][$aDet['id_articulo']] = 0;
				$aFullStock[$aDet['id_almacen']][$aDet['id_articulo']] = $aDet['fecha_caducidad'];
			}
		$aRetVal = array();

		foreach ($aProds as $id_art => $cnt) {
			foreach (array_keys($aFullStock) as $idAlm) {
				//note: esto provoca que si no se ha encontrado fecha alguna, no se indica cantidad.
				//if (isset($aFullStock[$idAlm][$id_art])) $aRetVal[$idAlm][$id_art]['cantidad'] = $cnt;
				$aRetVal[$idAlm][$id_art]['cantidad'] = $cnt;
				$aRetVal[$idAlm][$id_art]['fecha_caducidad'] = $aFullStock[$idAlm][$id_art];
				// debug("en retval vamos a dejar  ".$aRetVal[$idAlm][$id_art]);
			}
		}

		if ($GLOBALS['DEBUG']=='ON') {
			$this->debug(array("<b>Full Stock</b> Available (revisando..): "=>$aRetVal),'getMinExpiration');
		}

		return $aRetVal;
	}

	function CheckOutLocations($aLoc) {
	}

	function CheckInLocations($aLoc) {
	}

	function notifyStockChange($aRefList) {
		if (!is_array($aRefList) or !sizeof($aRefList)) return false;

		$aRefAsc = $aRefDesc = array();
		foreach ($aRefList as $id => $cnt) {
			if ($cnt > 0) $aRefAsc[$id] = $cnt;
			else $aRefDesc[$id] = $cnt;
		}

		if (is_array($aRefAsc) and sizeof($aRefAsc)) {
			$this->notifyStockAscChange($aRefAsc);
		}
		if (is_array($aRefDesc) and sizeof($aRefDesc)) {
			$this->notifyStockDescChange($aRefAsc);
		}
	}

	function notifyStockAscChange($aProds) {
		$oDb = &$this->getDb();

		if (!is_array($aProds) OR !sizeof($aProds)) return NULL;
		if (empty($id_emp)) $id_emp = $this->getAttribute('id_empresa');
		if (empty($id_emp)) return NULL;
		$id_alm = $this->getId();

		$aPList = array_keys($aProds);
		foreach ($aPList as $ida) $str_prods .= ( (!empty($str_prods)) ? ' OR ' : '' ).' Ar.id_articulo = '.$ida;

		// Buscamos aquellos pedidos de la lista de prods cuya suma de stock_previsto no llege al pedido.
		$cons = 'SELECT STRAIGHT_JOIN Ld.id_detalle, A.id_almacen,Ld.id_articulo,Ld.cantidad as "cantidad_pedida", SUM(DA.stock_previsto) as "cantidad_prevista", '.
					'A.id_albaran,A.referencia,A.fecha,Ar.nombre,A.id_preparado_por,A.id_revisado_por,A.id_empaquetado_por,A.preparado '.
					'FROM Albaranes A LEFT JOIN Pedidos P ON (A.id_pedido=P.id_pedido AND (P.id_proveedor IS NULL OR P.id_proveedor = 0)) '.
					'JOIN Lineas_detalle Ld ON (Ld.id_pedido=P.id_pedido ) JOIN Detalles_albaran DA ON (DA.id_detalle = Ld.id_detalle AND A.id_albaran=DA.id_albaran) '.
					'JOIN Articulos Ar ON (Ar.id_articulo=Ld.id_articulo) '.
					'WHERE ( '.$str_prods.' ) '.((!empty($id_alm))
						? ' AND A.id_almacen = '.$id_alm
						: ( (!empty($id_emp)) ? ' AND P.id_empresa = '.$id_emp : '' ) ).' '.
					'AND P.id_empresa = 1 AND A.preparado = 0 AND ( ((A.id_proveedor = 0 OR A.id_proveedor IS NULL) AND P.id_pedido IS NULL) OR P.id_pedido IS NOT NULL ) '.
					'GROUP BY Ld.id_detalle '.
					'HAVING cantidad_pedida > cantidad_prevista '.
					'ORDER BY A.fecha desc,Ld.id_articulo asc ';
		debug($cons);
		$rs = $oDb->query($cons);
		$rval = true;
		$aAlbs = array();
		if ($oDb->num_rows($rs)) 
			while ($aDet = $oDb->fetch_assoc($rs)) {
				if (empty($aProds[$aDet['id_articulo']]) or abs($aProds[$aDet['id_articulo']])<pow(10,-6)) continue;

				if ($GLOBALS['DEBUG']=='ON') {
					debug("Procediendo a notificar este: ");
					print_r($aDet);
				}
				$cant_pte = $aDet['cantidad_pedida'] - $aDet['cantidad_prevista'];
				if ($cant_pte > $aProds[$aDet['id_articulo']]) $cant_pte = $aProds[$aDet['id_articulo']];
				$aDet['cantidad_cambio'] = $cant_pte;

				if (!is_array($aAlbs[$aDet['id_albaran']])) $aAlbs[$aDet['id_albaran']] = array();
				array_push($aAlbs[$aDet['id_albaran']],$aDet);
				$aProds[$aDet['id_articulo']] -= $aDet['cantidad_cambio'];
			}
		if ($GLOBALS['DEBUG']=='ON') {
			$this->debug(array("TOTAL notificaciones : ",$aAlbs),'notifyStockAscChange');
		}

		$msg = '';
		if (is_array($aAlbs) and sizeof($aAlbs))
			foreach ($aAlbs as $id_albaran => $aDetList) {
				//FixMe: Anyadir soporte multi-idioma para estos mensajes:
				$id = ( (!empty($aDetList[0]['id_preparado_por'])) ? $aDetList[0]['id_preparado_por'] :
							( (!empty($aDetList[0]['id_empaquetado_por'])) ? $aDetList[0]['id_empaquetado_por'] : 
								( (!empty($aDetList[0]['id_revisado_por'])) ? $aDetList[0]['id_revisado_por'] : NULL)
							) 
						);
				if (!is_numeric($id)) {
					debug("FixMe: Buscar a quien notificar un albaran que no tiene ID's ");
					$cons = 'SELECT id_mozo FROM Mozos_almacen WHERE notificar_stock = 1';
					$mrs = $oDb->query($cons);
					if (!$oDb->num_rows($mrs)) continue;
					$aIDs = array();
					while ($aTmp = $oDb->fetch_row($mrs)) array_push($aIDs,$aTmp[0]);
					$oDb->libera($mrs);
				} else $aIDs = array($id);

				$msg = 'Las siguientes falta del Albaran '.$aDetList[0]['referencia'].' ('.$aDetList[0]['fecha'].') Pueden ser reparadas: '."<br/>\n";

				foreach ($aDetList as $aDet) {
					debug("Registrando albaran $id_albaran ");
					$cons = 'UPDATE Lineas_detalle SET stock_previsto = stock_previsto + "'.$aDet['cantidad_cambio'].'" WHERE id_detalle = '.$aDet['id_detalle'];
					debug($cons);
					$oDb->query($cons);
					$msg .= $aDet['nombre'].' (ID:'.$aDet['id_articulo'].') Pedido: '.$aDet['cantidad_pedida'].' Previsto: '.$aDet['cantidad_prevista'].
								' Nueva Cantidad: '.($aDet['cantidad_prevista']+$aDet['cantidad_cambio'])."<br/>\n" ;
				}
				if (is_array($aIDs) AND sizeof($aIDs))
					foreach ($aIDs as $id)
						if (is_numeric($id)) {
							$aMsgs[$id] .= ((!empty($aMsgs[$id])) ? "<br/><br/>\n" : '').$msg;
						}
			}

		if (is_array($aMsgs) and sizeof($aMsgs)) 
			foreach ($aMsgs as $id => $msg) {
				$oMsg = new MultiPartMessage("\n");
				$oMsg->setHTMLBody($msg);

				$oNot = new Notificacion();
				debug("FixMe: Soporte multilingua para el remite ? y para el tema del mensaje");
				$oNot->de('Inmersa Empresa');
				$oNot->para($id.'@MozosAlmacen');
				$oNot->tema('Cambio Ascendente de Stock, Faltas reparables.');
				$oNot->setMessage($oMsg);
				$oNot->Dump();
			}

		return $rval;
	}

	function notifyStockDescChange($aProds) {
		$oDb = &$this->getDb();

		if (!is_array($aProds) OR !sizeof($aProds)) return NULL;
		if (empty($id_emp)) $id_emp = $this->getAttribute('id_empresa');
		if (empty($id_emp)) return NULL;
		$id_alm = $this->getId();

		$aPList = array_keys($aProds);
		foreach ($aPList as $ida) $str_prods .= ( (!empty($str_prods)) ? ' OR ' : '' ).' Ar.id_articulo = '.$ida;

		// Buscamos aquellos pedidos de la lista de prods cuya suma de stock_previsto no llege al pedido.
		$cons = 'SELECT STRAIGHT_JOIN Ld.id_detalle, A.id_almacen,Ld.id_articulo,Ld.cantidad as "cantidad_pedida", SUM(DA.stock_previsto) as "cantidad_prevista", '.
					'A.id_albaran,A.referencia,A.fecha,Ar.nombre,A.id_preparado_por,A.id_revisado_por,A.id_empaquetado_por,A.preparado '.
					'FROM Albaranes A LEFT JOIN Pedidos P ON (A.id_pedido=P.id_pedido AND (P.id_proveedor IS NULL OR P.id_proveedor = 0)) '.
					'JOIN Lineas_detalle Ld ON (Ld.id_pedido=P.id_pedido ) JOIN Detalles_albaran DA ON (DA.id_detalle = Ld.id_detalle AND A.id_albaran=DA.id_albaran) '.
					'JOIN Articulos Ar ON (Ar.id_articulo=Ld.id_articulo) '.
					'WHERE ( '.$str_prods.' ) '.((!empty($id_alm))
						? ' AND A.id_almacen = '.$id_alm
						: ( (!empty($id_emp)) ? ' AND P.id_empresa = '.$id_emp : '' ) ).' '.
					'AND P.id_empresa = 1 AND A.preparado = 0 AND ( ((A.id_proveedor = 0 OR A.id_proveedor IS NULL) AND P.id_pedido IS NULL) OR P.id_pedido IS NOT NULL ) '.
					'GROUP BY Ld.id_detalle '.
					'HAVING cantidad_pedida > cantidad_prevista '.
					'ORDER BY A.fecha desc,Ld.id_articulo asc ';
		debug($cons);
		$rs = $oDb->query($cons);
		$rval = true;
		$aAlbs = array();
		if ($oDb->num_rows($rs)) 
			while ($aDet = $oDb->fetch_assoc($rs)) {
				if (empty($aProds[$aDet['id_articulo']]) or abs($aProds[$aDet['id_articulo']])<pow(10,-6)) continue;

				if ($GLOBALS['DEBUG']=='ON') {
					debug("Procediendo a notificar este: ");
					print_r($aDet);
				}
				$cant_pte = $aDet['cantidad_pedida'] - $aDet['cantidad_prevista'];
				if ($cant_pte > $aProds[$aDet['id_articulo']]) $cant_pte = $aProds[$aDet['id_articulo']];
				$aDet['cantidad_cambio'] = $cant_pte;

				if (!is_array($aAlbs[$aDet['id_albaran']])) $aAlbs[$aDet['id_albaran']] = array();
				array_push($aAlbs[$aDet['id_albaran']],$aDet);
				$aProds[$aDet['id_articulo']] -= $aDet['cantidad_cambio'];
			}
		if ($GLOBALS['DEBUG']=='ON') {
			debug("<hr> TOTAL notificaciones : ");
			print_r($aAlbs);
		}

		$msg = '';
		if (is_array($aAlbs) and sizeof($aAlbs))
			foreach ($aAlbs as $id_albaran => $aDetList) {
				//FixMe: Anyadir soporte multi-idioma para estos mensajes:
				$id = ( (!empty($aDetList[0]['id_preparado_por'])) ? $aDetList[0]['id_preparado_por'] :
							( (!empty($aDetList[0]['id_empaquetado_por'])) ? $aDetList[0]['id_empaquetado_por'] : 
								( (!empty($aDetList[0]['id_revisado_por'])) ? $aDetList[0]['id_revisado_por'] : NULL)
							) 
						);
				if (!is_numeric($id)) {
					debug("FixMe: Buscar a quien notificar un albaran que no tiene ID's ");
					$cons = 'SELECT id_mozo FROM Mozos_almacen WHERE notificar_stock = 1';
					$mrs = $oDb->query($cons);
					if (!$oDb->num_rows($mrs)) continue;
					$aIDs = array();
					while ($aTmp = $oDb->fetch_row($mrs)) array_push($aIDs,$aTmp[0]);
					$oDb->libera($mrs);
				} else $aIDs = array($id);

				$msg = 'Las siguientes falta del Albaran '.$aDetList[0]['referencia'].' ('.$aDetList[0]['fecha'].') Pueden ser reparadas: '."<br/>\n";

				foreach ($aDetList as $aDet) {
					debug("Registrando albaran $id_albaran . FixMe: Falta hacer mas comrpobaciones cuando el cambio es descendente. ");
					$cons = 'UPDATE Lineas_detalle SET stock_previsto = stock_previsto - "'.$aDet['cantidad_cambio'].'" WHERE id_detalle = '.$aDet['id_detalle'];
					debug($cons);
					$oDb->query($cons);
					$msg .= $aDet['nombre'].' (ID:'.$aDet['id_articulo'].') Pedido: '.$aDet['cantidad_pedida'].' Previsto: '.$aDet['cantidad_prevista'].
								' Nueva Cantidad: '.($aDet['cantidad_prevista']+$aDet['cantidad_cambio'])."<br/>\n" ;
				}
				if (is_array($aIDs) AND sizeof($aIDs))
					foreach ($aIDs as $id)
						if (is_numeric($id)) {
							$aMsgs[$id] .= ((!empty($aMsgs[$id])) ? "<br/><br/>\n" : '').$msg;
						}
			}

		if (is_array($aMsgs) and sizeof($aMsgs)) 
			foreach ($aMsgs as $id => $msg) {
				$oMsg = new MultiPartMessage("\n");
				$oMsg->setHTMLBody($msg);

				$oNot = new Notificacion();
				debug("FixMe: Soporte multilingua para el remite ? y para el tema del mensaje");
				$oNot->de('Inmersa Empresa');
				$oNot->para($id.'@MozosAlmacen');
				$oNot->tema('Cambio Descendente de Stock. ');
				$oNot->setMessage($oMsg);
				$oNot->Dump();
			}

		return $rval;
	}

	function stockUpdate($aLoc,$bUpdateEstimado = true, $bTryReLocate = true) {
		$retval = false;
		//Se bloquea dentro del metodo, dado que recibe una matriz en lugar de un vector
		$retval = $this->__stockUpdate($aLoc,$bUpdateEstimado,$bTryRelocate);
		/** **
		if ($this->acquireStockLock($aLoc['id_articulo'])) {
			$retval = $this->__stockUpdate($aLoc,$bUpdateEstimado,$bTryRelocate);
			$this->releaseStockLock($aLoc['id_articulo']);
		}
		/** **/
		return $retval;
	}

	function acquireStockLock($id_art) {
		$oDb = &$this->getDb();
		$cons_lock='SELECT GET_LOCK("'.$oDb->get_dbase_name().'.Localizacion_articulos::id_articulo='.$id_art.'",60)';
		$tmprs = $oDb->query($cons_lock);
		$aTmp = $oDb->fetch_row($tmprs);
		$oDb->libera($tmprs);
		if ($aTmp[0] != 1) return false;
		return true;
	}

	function releaseStockLock($id_art) {
		$oDb = &$this->getDb();
		$cons_unlock = 'SELECT RELEASE_LOCK("'.$oDb->get_dbase_name().'.Localizacion_articulos::id_articulo='.$id_art.'") ';
		$tmprs = $oDb->query($cons_unlock);
		$aTmp = $oDb->fetch_row($tmprs);
		$oDb->libera($tmprs);
	}

	function __stockUpdate($aLoc,$bUpdateEstimado = true, $bTryReLocate = true) {
		if (!is_array($aLoc) or !sizeof($aLoc)) return false;
		$oDb = &$this->getDb();
		if (!isset($bUpdateEstimado)) $bUpdateEstimado = true;
		elseif (!$bUpdateEstimado) $bUpdateEstimado = false;

		$tmpIdx = array_shift(array_keys($aLoc));
		if (is_array($aLoc[$tmpIdx]) and !sizeof($aLoc[$tmpIdx])) return false;
		// array_unshift($aLoc,$aTmp);
		if (!is_array($aLoc[$tmpIdx])) $aLoc = array($aLoc);

		foreach ($aLoc as $idx => $aLocalizacion) {
			if (!is_numeric($aLocalizacion['id_articulo'])) {
				debug("Error: Localizacion sin IDArticulo ");
				continue;
			}
			if ($this->acquireStockLock($aLocalizacion['id_articulo'])) {
				$affected_rows = $this->stockSQLUpdate($aLocalizacion,false);
				$this->debug("first Try sql_update_stock() a pelo.. affected: ".$affected_rows,'__stockUpdate');
				if (!$affected_rows) {
					$this->debug("meeeck!! loc no existe. intentaremos otra cosa ",'__stockUpdate');

					$aLocIn['id_almacen_logico'] = $aLocalizacion['id_almacen_logico'];
					$aLocIn['planta'] = $aLocalizacion['planta'];
					$aLocIn['pasillo'] = $aLocalizacion['pasillo'];
					$aLocIn['fila'] = $aLocalizacion['fila'];
					$aLocIn['columna'] = $aLocalizacion['columna'];
					$aSKUIn['lote'] = $aLocalizacion['lote'];
					$aSKUIn['fecha_caducidad'] = wol_db::formatear_fecha($aLocalizacion['fecha_caducidad'],false);
					if (!strcasecmp($aSKUIn['fecha_caducidad'],'NULL')) $aSKUIn['fecha_caducidad'] = '0000-00-00';

					$affected = 0;
					if ($bTryRelocate) {
						$this->debug('Buscamos por lote y/o la fecha otra localizacion (TryRelocate=1)','__stockUpdate');
						/** 
						 * Lo primero, buscamos esta misma referencia de producto, con fecha y lote, a ver si existe en alguna otra localizacion.
						 **/
						$cons = 'SELECT planta,pasillo,fila,columna,lote,fecha_caducidad,id_almacen_logico,cantidad '.
									'FROM Localizacion_articulos '.
									'WHERE id_articulo = '.$aLocalizacion['id_articulo'].' AND (  ((lote = "'.$aLocalizacion['lote'].'" AND lote != "") OR '.
									'(fecha_caducidad = '.wol_db::formatear_fecha($aLocalizacion['fecha_caducidad']).' AND fecha_caducidad != 0)) ) '.
									' ORDER  BY fecha_caducidad asc ';
						// debug($cons);
						$locrs = $oDb->query($cons);
						$n_rows = $oDb->num_rows($locrs);
						$aFinal = NULL;
						if ($n_rows > 1) {
							// debug("VARIAS ocurrencia encontrada. ");
							/**
							 * Hemos encontrado mas de un lote/fecha ... Comprobando almacen_logico
							 **/
							$i = 0;
							while ($aTmp = $oDb->fetch_assoc($locrs)) {
								if (!$i++) $aFirst = $aTmp;

								if ( vector_incluido($aTmp,$aLocIn) ) {
									// Si coincide la localizacion y estos no estan vacios (no son el cajon desastre). lo metemos aqui.
									if (!is_array($aFinal)) $aFinal = $aTmp;
									else {
										if (!strcasecmp($aLocalizacion['lote'],$aTmp['lote']) AND 
												!strcasecmp(wol_db::formatear_fecha($aLocalizacion['fecha_caducidad'],false),wol_db::formatear_fecha($aTmp['fecha_caducidad'],false)) ) {
											// debug("pero si coinciden!! ");
											// Si Coincide fecha de caducidad y lote, nos da igual que ya hayamos encontrado una localizacion que cuadre, estos son los valores
											$aFinal = $aTmp;
											break;
										} elseif (!strcasecmp($aLocalizacion['lote'],$aTmp['lote']) OR 
												!strcasecmp(wol_db::formatear_fecha($aLocalizacion['fecha_caducidad'],false),wol_db::formatear_fecha($aTmp['fecha_caducidad'],false)) ) {
											// Si coincide la fecha de caducidad o el lote, nos vale la localizacion, probablemente mejor que antes (nunca peor)
											$aFinal = $aTmp;
										}
									}
								} elseif ( ($aTmp['id_almacen_logico'] == $aLocalizacion['id_almacen_logico']) AND !is_array($aFinal)  ) {
									$aFinal = $aTmp;
								}
							}
							if ( (!is_array($aFinal) OR !sizeof($aFinal)) AND ( is_array($aFirst) AND sizeof($aFirst)) ) {
								// Si no hemos encontrado una localizacion en el almacen-logico actual, lo metemos en la primera localizcion
								$aFinal = $aFirst;
							} 
						} elseif ((int)$n_rows) {
							// debug("_una_ encontrada .. ");
							$aFinal = $oDb->fetch_assoc($locrs);
							$aFinal['id_articulo'] = $aLocalizacion['id_articulo'];
							// debug("update_stock(): _solo_ hemos encontrado una localizacion: ");
							// print_r($aFinal);
						}
					} else {
						$aFinal = $aLocalizacion;
						$n_rows = 1;
					}

					if (is_array($aFinal) AND sizeof($aFinal) AND (int)$n_rows) {
						$aFinal['id_articulo'] = $aLocalizacion['id_articulo'];
						$aFinal['id_empresa'] = $aLocalizacion['id_empresa'];

						if (!empty($aLocalizacion['lote'])) $aFinal['lote'] = $aLocalizacion['lote'];
						if (strcasecmp(wol_db::formatear_fecha($aLocalizacion['fecha_caducidad'],false),'NULL')) 
							$aFinal['fecha_caducidad'] = $aLocalizacion['fecha_caducidad'];
						$aFinal['cantidad'] = $aLocalizacion['cantidad'];
						$affected = 1;

						$this->debug(array('vamos a probar a actualizar esta loc: '=>$aFinal),'__stockUpdate');
						$this->stockSQLUpdate($aFinal); // Este metodo crea la loc si no existe

						$aRetVal[$idx] = $aFinal;
						// debug("Va a ser aquina eh : ");
						// print_r($aFinal);

						/** **
						if ( ( ( !empty($aLocalizacion['lote']) AND $aFinal['lote'] != $aLocalizacion['lote'] )
								OR 
								( strcasecmp(wol_db::formatear_fecha($aLocalizacion['fecha_caducidad'],false),'NULL')  
								  AND strcasecmp(wol_db::formatear_fecha($aFinal['fecha_caducidad']),wol_db::formatear_fecha($aLocalizacion['fecha_caducidad'])) ) 
								) 
							) {
						
							/** 
							 * Dado que la localizacion actual tiene otro lote y/o fecha de caducidad
							 * En el mismo hueco, creamos una nueva entrada con este lote/fecha.
							 ** 

							if ( vector_incluido($aFinal,$aLocIn) AND $aFinal['cantidad'] == 0) {
								// Si el hueco/localizacion actual, esta vacia, 
								// debug("Nuevo hueco ... ");
								//FixMe: _NUNCA_ actualizar cantidades por tb_update, hacer una SQL
								// Nota (13/2/06): En realidad este codigo intenta evitar/pisar localizaciones a 0, para no tener que pasar por 
								//   el delete de stockSQLUpdate(). Mover todos los campos => borrar y crear
								$oDb->tb_update('Localizacion_articulos',$aLocalizacion,$aFinal);
								$aRetVal = $aFinal;

								$aFinal['fcad'] = $aFinal['fecha_caducidad'];
								$Sesion->lcMessage('MISC_STOCK_LOC_MOVED',$aFinal);
							} else {
								if (!empty($aLocalizacion['lote'])) $aFinal['lote'] = $aLocalizacion['lote'];
								if (strcasecmp(wol_db::formatear_fecha($aLocalizacion['fecha_caducidad'],false),'NULL')) $aFinal['fecha_caducidad'] = $aLocalizacion['fecha_caducidad'];
								$aFinal['cantidad'] = $aLocalizacion['cantidad'];

								// debug("Reemplazamos una localizacion en varias .... ");
								// print_r($aTmp);
								$aFinal['fecha_alta'] = date('Y-m-d H:i:s');
								$oDb->tb_replace('Localizacion_articulos',$aFinal);
								$aRetVal = $aFinal;
								$affected = 1;

								$aFinal['fcad'] = $aFinal['fecha_caducidad'];
								$Sesion->lcMessage('MISC_STOCK_LOC_NEW',$aFinal);
							}
						} else {
							// debug("Actualizamos el stock.. ");
							$aFinal['cantidad'] = $aLocalizacion['cantidad'];
							$affected = sql_update_stock($oDb,$aFinal);
							$aRetVal = $aFinal;

							$aFinal['fcad'] = $aFinal['fecha_caducidad'];
							$Sesion->lcMessage('MISC_STOCK_LOC_MOVED',$aFinal);
						}
						/** **/

					} else {
						// debug("No hemos encontrado el lote/fecha ... no esta? Comprobando ");
						$cons = 'SELECT planta,pasillo,fila,columna,lote,fecha_caducidad,id_almacen_logico FROM Localizacion_articulos '.
									'WHERE id_articulo = '.$aLocalizacion['id_articulo'].
									' ORDER by fecha_caducidad, lote asc ';
						$artrs = $oDb->query($cons);
						if (!$oDb->num_rows($artrs)) {
							/**
							 * No hemos encontrado la referencia de producto en _ninguna_ localizacion. Le damos esta.
							 **/
							if (empty($aLocalizacion['id_almacen_logico'])) {
								$cons = 'SELECT Almacenes_logicos.id_almacen,Almacenes_logicos.id_almacen_logico '.
										  'FROM Empresas , Almacenes , Almacenes_logicos '.
										  'WHERE Empresas.id_empresa = '.$this->getAttribute('id_empresa').' and '.
										  'Almacenes.id_empresa = Empresas.id_empresa and '.
										  'Almacenes.id_almacen = Almacenes_logicos.id_almacen '.
										  ( (is_numeric($aLocalizacion['id_almacen'])) ? 'Almacenes.id_almacen = '.$aLocalizacion['id_almacen'] : '').
										  ' ORDER BY Almacenes.id_almacen asc, Almacenes_logicos.id_almacen_logico asc'.
										  ' limit 1';
								$idtmp = $oDb->query ($cons);
								if ($oDb->num_rows($idtmp)) {
									$aTmpLoc = $oDb->fetch_array ($idtmp);
									$aLocalizacion['id_almacen_logico'] = $aTmpLoc[0];
								}
							}
							// if (!is_numeric($aLocalizacion['planta'])) $aLocalizacion['planta'] = 0;
							// if (!is_numeric($aLocalizacion['pasillo'])) $aLocalizacion['pasillo'] = 0;
							// if (!is_numeric($aLocalizacion['fila'])) $aLocalizacion['fila'] = 0;
							// if (!is_numeric($aLocalizacion['columna'])) $aLocalizacion['columna'] = 0;

							// debug("No hemos encontrado la referencia, la creamos");
							if (!empty($aLocalizacion['id_almacen_logico'])) {
								$this->stockSQLUpdate($aLocalizacion,true,false);

								// $aLocalizacion['fecha_alta'] = date('Y-m-d H:i:s');
								// $oDb->tb_replace('Localizacion_articulos',$aLocalizacion);
								$aRetVal[$idx] = $aLocalizacion;
								$affected = 1;

								$aTmp = $aLocalizacion;
								$aTmp['fcad'] = $aTmp['fecha_caducidad'];
								$Sesion->lcMessage('MISC_STOCK_LOC_NEW',$aTmp);
								// $localizacion = 'Pta: '.$aLocalizacion['planta'].' P: '.$aLocalizacion['pasillo'].' F: '.$aLocalizacion['fila'].' C: '.$aLocalizacion['columna'];
								// $producto = 'Lte/F.Cad: '.$aLocalizacion['lote'].' / '.colocar_fecha($aLocalizacion['fecha_caducidad']);
								// debug("Producto $producto colocado en una nueva localizacion : $localizacion");
							} else $affected = 0;
						} else {
							// debug("Pues no va a estar no... ");
							$i = 0;

							$bUpdate = false;

							while ($aTmp = $oDb->fetch_assoc($artrs)) {
								if (!$i++) $aFirst = $aTmp;

								/** **
								if ( ( !strcmp(wol_db::formatear_fecha($aTmp['fecha_caducidad']),wol_db::formatear_fecha($aLocalizacion['fecha_caducidad']))  
												AND strcasecmp(wol_db::formatear_fecha($aLocalizacion['fecha_caducidad'],false),'NULL'))  
										OR ($aTmp['lote']==$aLocalizacion['lote'] AND !empty($aLocalizacion['lote'])) ) 
								/** **/
								if (vector_incluido($aTmp,$aSKUIn) AND vector_incluido($aTmp,$aLocIn) )
								{
									// Si coincide la fecha o el lote y estos no estan vacios (no son el cajon desastre). lo metemos aqui.
									// debug("Coincide lote y localizacion!!");
									$aFinal = $aTmp;
									$bUpdate = true;
									break;
								} elseif (vector_incluido($aTmp,$aSKUIn)) {
									// debug("Coincide la fecha/lote solo .. ");
									// print_r($aSKUIn);
									$aFinal = $aTmp;
								} elseif (vector_incluido($aTmp,$aLocIn)) {
									// debug("Coincide la localicacion solo .. ");
									// print_r($aLocIn);
									if ($aFinal['cantidad'] == 0) $aFinal = $aTmp;
								} elseif ($aTmp['id_almacen_logico'] == $aLocIn['id_almacen_logico']) {
									// Si no coinciden fechas ni lote , pero si el almacen, consideramos esta una buena opcion (a espera de seguir evaluando).
									// debug("Coincide tan solo la zona de almacen .. ");
									$aFinal = $aTmp;
								}
							}
							if ( (!is_array($aFinal) OR !sizeof($aFinal)) AND ( is_array($aFirst) AND sizeof($aFirst)) ) {
								// Si no hemos encontrado una localizacion en el almacen-logico actual, lo metemos en la primera localizcion
								$aFinal = $aFirst;
							} 
							if (is_array($aFinal) AND sizeof($aFinal)) {
								$aFinal['id_articulo'] = $aLocalizacion['id_articulo'];
								$aFinal['cantidad'] = $aLocalizacion['cantidad'];
								$aFinal['id_empresa'] = $aLocalizacion['id_empresa'];

								if ($bTryReLocate) {
									$aFinal['lote'] = $aLocalizacion['lote'];
									$aFinal['fecha_caducidad'] = $aLocalizacion['fecha_caducidad'];
								} else {
									$aFinal['lote'] = $aSKUIn['lote'];
									$aFinal['fecha_caducidad'] = $aSKUIn['fecha_caducidad'];

									$aFinal['id_almacen_logico'] = $aLocIn['id_almacen_logico'];
									$aFinal['planta'] = $aLocIn['planta'];
									$aFinal['pasillo'] = $aLocIn['pasillo'];
									$aFinal['fila'] = $aLocIn['fila'];
									$aFinal['columna'] = $aLocIn['columna'];
								}

								$aTmp = $aRetVal[$idx] = $aFinal;

								$this->stockSQLUpdate($aFinal);
								/** **
								if (!$bUpdate) {
									//FixMe: No usar tb_replace, es preferible la opcion del else
									$aFinal['fecha_alta'] = date('Y-m-d H:i:s');
									$oDb->tb_replace('Localizacion_articulos',$aFinal);
									$aTmp['fcad'] = $aTmp['fecha_caducidad'];
									$Sesion->lcMessage('MISC_STOCK_LOC_NEW',$aTmp);
								} else {
									if (!sql_update_stock($oDb,$aFinal)) {
										$aFinal['fecha_alta'] = date('Y-m-d H:i:s');
										$oDb->tb_replace('Localizacion_articulos',$aFinal);
										$aTmp['fcad'] = $aTmp['fecha_caducidad'];
										$Sesion->lcMessage('MISC_STOCK_LOC_NEW',$aTmp);
									}
								}
								/** **/
								$affected = 1;

							} else {
								// Error: Nos hemos hecho la picha un lio con las localizaciones
								debug("Error: Me he hecho la picha un lio ... ");
								$affected = 0;
							}
						}
						$oDb->libera($artrs);
					}
					if ($bTryRelocate) $oDb->libera($locrs);
				} else {
					$affected = 1;
					$aRetVal[$idx] = $aLocalizacion;
				}

				if ($affected AND $bUpdateEstimado) {
					// debug("Actualizamos el stock estimado.");
					$cons = "UPDATE Empresas_articulos SET stock_ficticio = stock_ficticio + ".$aLocalizacion['cantidad'].
						" WHERE id_empresa = ".$this->getAttribute('id_empresa').' AND id_articulo = '.$aLocalizacion['id_articulo'];
					// debug($cons);
					$oDb->query($cons);
				}
				$this->releaseStockLock($aLocalizacion['id_articulo']);
			}
		}
		return $aRetVal;
	}

	function __SKUCleanUp($aLoc) {
		$rval = 0;
		if ($this->__verifyLocation($aLoc)) {
			$oDb = &$this->getDb();
			// Si hemos actualizado cantidades... borramos las que nos hayan quedado a 0
			$cntcons = "SELECT COUNT(*) FROM Localizacion_articulos WHERE ".
						"id_articulo = ".$aLoc['id_articulo']." AND ".
						"id_almacen_logico = ".$aLoc['id_almacen_logico']." AND ".
						( (is_numeric($aLoc['planta'])) ? "planta = ".$aLoc['planta']." AND " : '').
						( (is_numeric($aLoc['pasillo'])) ? "pasillo = ".$aLoc['pasillo']." AND " : '').
						( (is_numeric($aLoc['fila'])) ? "fila = ".$aLoc['fila']." AND " : '').
						( (is_numeric($aLoc['columna'])) ? "columna = ".$aLoc['columna']." " : '');
						//"fecha_caducidad != '0000-00-00' AND ".
			/** ** Tite: NoNeed */
			$this->debug($cntcons,"__SKUCleanUp");
			$cntrs = $oDb->query($cntcons);
			$aCnt = $oDb->fetch_row($cntrs);
			/** **/
			// debug("sql_update_stock() - Update ok.. ".$aCnt[0]." Localizaciones puras ");
			if ($aCnt[0]>1) {
				$cons = "DELETE FROM Localizacion_articulos WHERE ".
					"id_articulo = ".$aLoc['id_articulo']." AND ".
					"id_almacen_logico = ".$aLoc['id_almacen_logico']." AND ".
					( (is_numeric($aLoc['planta'])) ? "planta = ".$aLoc['planta']." AND " : '').
					( (is_numeric($aLoc['pasillo'])) ? "pasillo = ".$aLoc['pasillo']." AND " : '').
					( (is_numeric($aLoc['fila'])) ? "fila = ".$aLoc['fila']." AND " : '').
					( (is_numeric($aLoc['columna'])) ? "columna = ".$aLoc['columna']." AND " : '').
					"lote = '".$aLoc['lote']."' AND ".
					"fecha_caducidad = ".wol_db::formatear_fecha($aLoc['fecha_caducidad']).
					" AND cantidad = 0 ";
				$this->debug($cons,'__SKUCleanUp');
				$tmprs = $oDb->query($cons);
				$rval = $oDb->affected_rows();
			}
		}
		return $rval;
	}

	function stockSQLUpdate($aLoc,$bCreate = true,$bUpdate = true) {
		$oDb = &$this->getDb();
		if (empty($aLoc['id_articulo']) OR !is_numeric($aLoc['id_articulo'])) return 0;
		//if (empty($aLoc['id_almacen_logico']) OR !is_numeric($aLoc['id_almacen_logico'])) return 0;
		if (!isset($aLoc['id_almacen_logico'])) $aLoc['id_almacen_logico']=0;
		if (!isset($bCreate)) $bCreate = true;
		if (!isset($bUpdate)) $bUpdate = true;

		$fecha_fmt = wol_db::formatear_fecha($aLoc['fecha_caducidad'],false);
		if (!strcasecmp($fecha_fmt,'NULL')) $fecha_fmt = '"0000-00-00"';
		else $fecha_fmt = '"'.$fecha_fmt.'"';

		if ($bUpdate) {
			$cons = "UPDATE Localizacion_articulos SET cantidad = cantidad + ".$aLoc['cantidad']." WHERE ".
				"id_articulo = ".$aLoc['id_articulo']." AND ".
				"id_almacen_logico = ".$aLoc['id_almacen_logico']." AND ".
				( (is_numeric($aLoc['planta'])) ? "planta = ".$aLoc['planta']." AND " : '').
				( (is_numeric($aLoc['pasillo'])) ? "pasillo = ".$aLoc['pasillo']." AND " : '').
				( (is_numeric($aLoc['fila'])) ? "fila = ".$aLoc['fila']." AND " : '').
				( (is_numeric($aLoc['columna'])) ? "columna = ".$aLoc['columna']." AND " : '').
				"lote = '".$aLoc['lote']."' AND ".
				"fecha_caducidad = ".$fecha_fmt;
			$idrs = $oDb->query($cons);
			$affected_rows = $oDb->affected_rows();
			$this->debug(array('UPDATE Localizacion_articulos con '.$affected_rows.' filas afecatadas: '=>$cons),'stockSQULUpdate');
		} else $affected_rows = 0;

		if ($affected_rows == 1) {
			$this->__SKUCleanUp($aLoc);
		} elseif ($bCreate) {
			$aLoc['fecha_alta'] = date('Y-m-d H:i:s');
			$this->debug(array('directiva de creacion:'=>$aLoc),'stockSQULUpdate');
			$oDb->tb_replace('Localizacion_articulos',$aLoc);
		} else {
			$this->debug('No hemos actualizado, y tampoco tenemos directiva de creacion.','stockSQULUpdate');
		}
		return $affected_rows;
	}

	function stockMovement($aOrigenes,$aDestino,$bKeepSKUID=true) {
		if (!is_array($aOrigenes) or !sizeof($aOrigenes)) return false;
		if (!is_array($aDestino) or !sizeof($aDestino)) return false;
		if (!isset($bKeepSKUID) or !is_bool($bKeepSKUID)) $bKeepSKUID = true;

		// Obtenemos lista indexada por id_articulo
		$aOrig = array();
		foreach ($aOrigenes as $aO) {
			if (is_array($aO) and sizeof($aO) and !empty($aO['id_articulo']) and !empty($aO['cantidad'])) {
				if ($this->__verifyLocation($aO)) {
					if (!is_array($aOrig[$aO['id_articulo']])) $aOrig[$aO['id_articulo']] = array();
					$aO['cantidad'] *= -1;
					array_push($aOrig[$aO['id_articulo']],$aO);
				}
			}
		}
		$retval = true;
		if ($this->__verifyLocation($aDestino)) {
			foreach ($aOrig as $id => $aOA) {
				if ($this->acquireStockLock($id)) {
					$cnt = 0;
					foreach ($aOA as $aO) {
						// Si la cantidad es 0. Borramos la loc
						if (abs($aO['cantidad'])<pow(10,-6)) $this->__SKUCleanUp($aO);
						elseif ($this->stockSQLUpdate($aO,false)) {
							$aDestino['id_articulo'] = $aO['id_articulo'];
							$aDestino['cantidad'] = ($aO['cantidad']*-1);
							if ($bKeepSKUID) {
								$aDestino['fecha_caducidad'] = $aO['fecha_caducidad'];
								$aDestino['lote'] = $aO['lote'];
							}
							$this->debug(array("Para el Destino: "=>$aDestino),'stockMovement');
							if (!$this->stockSQLUpdate($aDestino,true)) {
								debug("Error: No se ha podifo desplazar una referencia. (deshaciendo cambio)");
								$aO['cantidad'] *= -1;
								if (!$this->stockSQLUpdate($aO,true)) {
									debug("ERROR FATAL: No se ha podido desahacer movimiento!. Stock descuadrado!!! ");
									$retval = false;
									break;
								}
							}
						}
					}
					$this->releaseStockLock($id);
				}
			}
		} else {
			$this->debug(array("Destino inapropiado: "=>$aDestino));
			$retval = false;
		}
		return $retval;
	}

	/** Inicio de METODOS DE PREPARACION DE ALBARANES
	 * Este metodo se encarga de preparar una lista ordenada de localizaciones para guiar la preparacion de los albaranes indicados por parametro.
	 *  Para preparar los albaranes habran de existir varios metodos:
	 * 	- Listar los SKUs (cad/lote) y cantidades (con posibilidad de ver la pedida-servida) contenidos en 2 o 3 siguientes localizaciones.
	 * 	- Listar los SKUs y cantidades (con posibilidad de ver la pedida-servida) de la localizacion actual
	 * 	- bloquear localizacion, de tal forma que solo se muestren los detalles de dicha localizacion.
	 * 	- metodos de navegacion entre las referncias de la localizacion bloqueada, siguiente ref, anterior. 
	 * 	- seleccionar producto por _codigo de barras_. con localizacion bloqueada, o sin ella.
	 * 	- seleccionar 1 prod epecifico de la localizacion bloqueda
	 * 	- Metodo para dar como verificada X cantidad de una referencia en una localizacion
	 * 	- opcion para saltarse la localizacion, y con ello los productos pendientes. De tal forma que ya no se pongan de esta vez.
	 * 	- cuando cambiamos de localizacion, se libera la anterior.
	 * 	- Antes de terminar la trayectoria, hace una comprobacion en las posibles entradas de genero sin localizacion ni estar preparado su albaran.
	 * 	- En un futuro existira la posibilidad de incluir solo algunas referencias del albaran, no todas.
	**/

	/**
	 * Este metodo se encarga de elaborar la lista ordenada de localizaciones de distintos albaranes que se han de preparar.
	 * @param $aIDs - Secuence-of-id_albaran|Dictionary-of-DeliveryNoteClass|DeliveryNoteClass|id_albaran
	 * @return bool true on success, otherwise, false
	 **/
	function makeNotesPack($aIDs) {
		if ( (!is_array($aIDs) or !sizeof($aIDs)) and (!is_numeric($aIDs) and !is_a($aIDs,'DeliveryNote')) ) return false;
		if ( is_numeric($aIDs) or is_a($aIDs,'DeliveryNote') ) $aIDs = array($aIDs);

		$aDN = array();
		foreach ($aIDs as $idx => $Val) {
			$i = sizeof($aDN);
			if (is_numeric($Val) and !empty($Val)) {
				$oTmp = new DeliveryNote();
				$oTmp->dbFill(array('id_albaran' => $Val));
				if ($oTmp->getAttribute('id_almacen')==$this->getId()) {
					$oTmp->hookWherehouse(&$this);
					$aDN[$i] = &$oTmp;
				}
				$bLocate = true;
				$cnt_noloc = 0;
				for ($idx=$oTmp->firstDetail(); $idx<$oTmp->countDetails(); $idx=$oTmp->nextDetail()) {
					$id_zona = $oTmp->getDetailAttribute('id_almacen_logico',NULL,$idx);
					$planta = $oTmp->getDetailAttribute('planta',NULL,$idx);
					$pasillo = $oTmp->getDetailAttribute('pasillo',NULL,$idx);
					$fila = $oTmp->getDetailAttribute('fila',NULL,$idx);
					$columna = $oTmp->getDetailAttribute('columna',NULL,$idx);
					if ($id_zona=='0' and $planta=='0' and $pasillo=='0' and $fila=='0' and $columna=='0') {
						$cnt_noloc++;
					} else {
						$bLocate = false;
						break;
					}
				}
				if ($bLocate) {
					$this->debug("Localizando referencias en albaran sin localizaciones. ",'makeNotesPack');
					$oTmp->LocateProduct();
				}
				unset($oTmp);
			} elseif (is_a($Val,'DeliveryNote')) {
				if ($Val->getAttribute('id_almacen')==$this->getId()) $aDN[$i] = &$Val;
			}
		}
		unset($aIDs);

		$this->aDeliveryNotes = &$aDN;
		$this->debug('Size of aDeliveryNotes: '.sizeof($this->aDeliveryNotes),'makeNotesPack');
		unset($aDN);
		$this->__buildNotesIndex();
	}

	function closeNotesPack() {
		if (!is_array($this->aDeliveryNotes) or !sizeof($this->aDeliveryNotes)) return NULL;
		foreach (array_keys($this->aDeliveryNotes) as $idx) {
			$this->aDeliveryNotes[$idx]->dbDump();
		}
	}

	function __buildNotesIndex() {
		$this->debug("Ya tenemos una lista de Instancias ",'__buildNotesIndex');
		$this->idxArt = $this->idxCodBarras = $this->idxSKU = array();
		$this->oIdxSKURef = new FieldIndexer(array('idx_albaran','idx'),array('planta','pasillo','columna','fila'),'Asc');
		foreach ($this->aDeliveryNotes as $idxa => $oDNone) {
			// $oDet = &$oD->getDetails();
			$oD = &$this->aDeliveryNotes[$idxa];
			$oD->firstDetail();
			//$this->debug("delivery notex $idxa con first: ".$this->aDeliveryNotes[$idxa]->firstDetail(false),'__buildNotesIndex');
			for ($idx = $oD->firstDetail(); isset($idx); $idx = $oD->nextDetail()) {
				// Indexamos la posicion con la localizacion
				//$this->debug("delivery notex $idxa y detalle: $idx ",'__buildNotesIndex');
				$aIdx['idx_albaran'] = $idxa;
				$aIdx['idx'] = $idx;
				$aIdx['id_almacen_logico'] = $oD->getDetailAttribute('id_almacen_logico',$idx);
				$aIdx['planta'] = $oD->getDetailAttribute('planta',$idx);
				$aIdx['pasillo'] = $oD->getDetailAttribute('pasillo',$idx);
				$aIdx['columna'] = $oD->getDetailAttribute('columna',$idx);
				$aIdx['fila'] = $oD->getDetailAttribute('fila',$idx);
				//$this->debug(array("Dentro de Estado: ",'idxSKU' => $aIdx),'__buildNotesIndex');
				$this->oIdxSKURef->Index($aIdx);

				// Convertimos todos los valores a string para formar una cadena de localizacion (actualmente de 2 dig por campo)
				foreach ($aIdx as $fld => $val) $aIdx[$fld] = (string)$val;
				$strLoc = ( (strlen($aIdx['id_almacen_logico'])<2) ? '0' : '' ).$aIdx['id_almacen_logico'].'-'.
							( (strlen($aIdx['planta'])<2) ? '0' : '' ).$aIdx['planta'].':'.
							( (strlen($aIdx['pasillo'])<2) ? '0' : '' ).$aIdx['pasillo'].':'.
							( (strlen($aIdx['columna'])<2) ? '0' : '' ).$aIdx['columna'].':'.
							( (strlen($aIdx['fila'])<2) ? '0' : '' ).$aIdx['fila'];
				if (!in_array($strLoc,$this->idxSKU)) array_push($this->idxSKU,$strLoc);

				//Poblamos los indices de id_articulo y codigo de barras.
				$idart = $oD->getDetailAttribute('id_articulo','Producto',$idx);
				//NOTA: En este vector por idart almacenamos la strLoc, la matriz de loc, y en cuanto se pueda el idx_loc
				if (!is_array($this->idxArt[$idart])) $this->idxArt[$idart] = array();
				$aTmp['localizacion']['compact'] = $strLoc;
				$aTmp['localizacion']['detail'] = $aIdx; // No se si recortar los idx
				$aTmp['detail'] = $aIdx; // No se si recortar los idx
				array_push($this->idxArt[$idart],$aTmp);

				//TODO: Almacenar tambien el codigo de barras de la caja
				// Unidad
				$codbarras = $oD->getDetailAttribute('codigo_barras','Producto',$idx);
				if (!empty($codbarras) and empty($this->idxCodBarras[$codbarras])) $this->idxCodBarras[$codbarras] = array('id'=>$idart);
				// Bulto
				$codbarras = $oD->getDetailAttribute('codigo_barras_bulto','Producto',$idx);
				$cnt_bto = $oD->getDetailAttribute('unidades_bulto','Producto',$idx);
				if (!empty($codbarras) and empty($this->idxCodBarras[$codbarras]))
					$this->idxCodBarras[$codbarras] = array('id'=>$idart,'cnt'=>$cnt_bto);
				// Palet
				$codbarras = $oD->getDetailAttribute('codigo_barras_palet','Producto',$idx);
				$cnt_cpa = $oD->getDetailAttribute('bultos_capa','Producto',$idx)*$cnt_bto;
				$cnt = $oD->getDetailAttribute('capas_palet','Producto',$idx)*$cnt_cpa;
				if (!empty($codbarras) and empty($this->idxCodBarras[$codbarras]))
					$this->idxCodBarras[$codbarras] = array('id'=>$idart,'cnt'=>$cnt);
			}
		}

		// Al final, ordenamos el vector de strLocalizaciones pqra que nos sirva como guia de posicionamiento en el almacen.
		rsort(&$this->idxSKU);
		foreach ($this->idxArt as $ida => $aArt) {
			foreach ($aArt as $i => $aA) {
				$idxl = FieldIndexer::searchBinaryOnVector($this->idxSKU,$aA['localizacion']['compact']);
				$this->idxArt[$ida][$i]['localizacion']['idx'] = $idxl;
			}
		}

		//$this->debug(array("Estado: ",'idxSKU' => $this->idxSKU,'idxArt' => $this->idxArt),'__buildNotesIndex');

		return true;
	}

	/** Navegacion entre localizaciones **/
	function firstLocation($bMove = true) {
		if (!is_array($this->idxSKU) or !sizeof($this->idxSKU)) return NULL;
		$idx = array_shift(array_keys($this->idxSKU));
		if ($bMove) $this->ptrLocation = $idx;
		return $idx;
	}

	function nextLocation($bMove = true) {
		if (!is_numeric($this->ptrLocation)) return $this->firstLocation();
		$idx = $this->ptrLocation;
		while (true) {
			$idx++;
			if (isset($this->idxSKU[$idx])) {
				if ($bMove) $this->ptrLocation = $idx;
				return $idx;
			}
			if ($idx > sizeof($this->idxSKU)) break;
		}
		return NULL;
	}

	function lastLocation($bMove = true) {
		$idx = array_pop(array_keys($this->idxSKU));
		if ($bMove) $this->ptrLocation = $idx;
		return $idx;
	}

	function prevLocation($bMove = true) {
		if (!is_numeric($this->ptrLocation)) return $this->firstLocation();
		$idx = $this->ptrLocation;
		while (true) {
			$idx--;
			if (isset($this->idxSKU[$idx])) {
				if ($bMove) $this->ptrLocation = $idx;
				return $idx;
			}
			if ($idx <= 0) break;
		}
		return NULL;
	}

	function currentLocation() {
		return $this->ptrLocation;
	}

	function setLocation($loc) {
		// $loc as int or string
		if (is_numeric($loc)) {
			if (isset($this->idxSKU[$loc])) {
				$idx = $loc;
			}
		} else {
			$idx = FieldIndexer::searchBinaryOnVector($this->idxSKU,$loc);
		}
		if (is_numeric($idx) and isset($this->idxSKU[$idx])) {
			$this->ptrLocation = $idx;
			return true;
		} else return false;
	}

	function unsetLocation() {
		$this->ptrLocation = NULL;
	}
	/** FIN de Navegacion entre localizaciones **/

	// Obtenemos una lista limitada de stock+sku 
	function previewNotes($ref = NULL, $nLimit = 3) {
		$aRetVal = array();
		if (empty($nLimit)) $nLimit = 3;

		$i = 0;
		$bLocked = false;
		if (!isset($ref)) {
			$idxLoc = $this->currentLocation();
			$this->debug("Se supone que la loc actual deberia servir: ($idxLoc) sino .. ".$this->firstLocation(false),'previewNotes');
			if (!is_numeric($idxLoc)) $idxLoc = $this->firstLocation();
			elseif (empty($this->idxSKU[$idxLoc])) {
				return NULL;
			}
			debug("Vamos a empezar en $idxLoc con : ".$this->idxSKU[$idxLoc]);
		} else {
			//debug("De momento a ver si hacemos nada conuna ref $ref .. ");
			// Primero miramos a ver si es una localizacion:
			$idxLoc = array_search($ref,$this->idxSKU);
			if (is_numeric($idxLoc)) {
				debug("<b>VAle</b>, localizacion encontrada en $idxLoc ");
				$this->setLocation($idxLoc);
				$bLocked = true;
			} else {
				$ida = NULL;
				$aTmp = $this->idxCodBarras[$ref];
				if (is_array($aTmp) and sizeof($aTmp)) $ida = $aTmp['id'];
				//$ida = $this->idxCodBarras[$ref];
				debug("Hemos buscando en los cod con $ref con resultado $ida ");
				if (is_numeric($ida)) {
					debug("Bloqueando por codigo barras. ".$ida);
					$bLockedID = $ida;
				} elseif (is_array($this->idxArt[$ref]) and sizeof($this->idxArt[$ref])) {
					$bLockedID = $ref;
				} else return NULL;
				$idxLoc = $this->currentLocation();
				if (!is_numeric($idxLoc)) $idxLoc = $this->firstLocation();
			}
			if ($bLockedID or $bLocked) {
				debug("Bloqueado .. ".$bLockedID." blokeado: ".$bLocked);
				$this->bLocked = $bLocked;
				$this->iLockedID = $bLockedID;
			}
		}

		$bCont = true;
		$bNextOnNotCont = true;
		debug("A punto del if: bLock: ".!$this->bLocked." o iLock: ".$this->iLockedID." idxLoc: ".$idxLoc);
		// Sacamos en aIdxList, una lista de referencias _previas_ a 0 sin ignorar
		if ($idxLoc != $this->firstLocation(false) and !$this->bLocked and !$this->iLockedID) {
			$lmtLoc = $this->currentLocation();
			$this->debug("Loc actual ($lmtLoc), que no la primera: ".$this->firstLocation(false),'previewNotes');
			for ($tmpLoc = $this->firstLocation(); $tmpLoc < $lmtLoc; $tmpLoc = $this->nextLocation()) {
				$strL = $this->idxSKU[$tmpLoc];
				$aTmpIdx = $this->__getFromLocation($strL);
				foreach ($aTmpIdx as $aTmpAlb)
					if (!$this->isIgnoredForNotes($aTmpAlb['idx_albaran'],$aTmpAlb['idx']) and 
						abs($this->aDeliveryNotes[$aTmpAlb['idx_albaran']]->getAttribute('cantidad',NULL,$aTmpAlb['idx']))
								<pow(10,-6) ) {
						$aIdxList[] = $aTmpAlb;
					}
			}
			if (!empty($nLimit) and sizeof($aIdxList) >= $nLimit) {
				// debug("Si No hay que continuar ... no hay siguiente, ahroa en $lmtLoc ");
				$bNextOnNotCont = false;
			}
			// $this->setLocation($lmtLoc);
			$this->prevLocation();
			$idxLoc = $tmpLoc;
		} elseif ($this->bLocked or $this->iLockedID) {
			$this->debug("hay un bloqueo en currentLocation() O en la ref: ".$this->iLockedID,'previewNotes');
			if ($this->iLockedID and !$this->bLocked) {
				foreach ($this->idxArt[$this->iLockedID] as $aTmp) {
					if (!$this->isIgnoredForNotes($aTmp['idx_albaran'],$aTmp['idx'])) {
						$aIdxList[] = array('idx_albaran'=>$aTmp['detail']['idx_albaran'],'idx'=>$aTmp['detail']['idx']);
					}
				}
				//$this->debug(array("lock ref ".$this->iLockedID." hemos encontrado -no ign-: "=>$aIdxList),"previewNotes");
			}
		}
		while ($bCont) {
			$strL = $this->idxSKU[$idxLoc];
			if (!is_array($aIdxList) or !sizeof($aIdxList)) {
				$this->debug('Llamando a getFromLocation con ('.$strL.') del indice '.$idxLoc,'previewNotes');
				$aTmpIdx = $this->__getFromLocation($strL);
				if (is_array($aTmpIdx) and sizeof($aTmpIdx))
					foreach ($aTmpIdx as $aTmpAlb)
						if (!$this->isIgnoredForNotes($aTmpAlb['idx_albaran'],$aTmpAlb['idx'])) {
							$aIdxList[] = $aTmpAlb;
						}
			} 
			if (is_array($aIdxList) and sizeof($aIdxList)) {
				foreach ($aIdxList as $aRefAlb) {
					$this->debug("Procediendo a obtener: desde ".$aRefAlb['idx_albaran']."->".$aRefAlb['idx'],'previewNotes');
					$aDetalle = $this->aDeliveryNotes[$aRefAlb['idx_albaran']]->getDetailData(NULL,$aRefAlb['idx']);
					$aDetPed = $this->aDeliveryNotes[$aRefAlb['idx_albaran']]->getDetailData('DetallePedido',$aRefAlb['idx']);
					if ($this->aDeliveryNotes[$aRefAlb['idx_albaran']]->isSale()) {
						$aDetalle['cantidad_pendiente'] = $aDetalle['stock_previsto'] - $aDetalle['cantidad'];
					} else {
						/** Compatiblizacion entre Compras y Ventas, tratando compras cual ventas. **
						// En las compras, el previsto es la que ya esta confirmada
						$aDetalle['cantidad_pendiente'] = $aDetalle['cantidad'] - $aDetalle['stock_previsto'];
						/** **/
						$aDetalle['cantidad_pendiente'] = $aDetalle['stock_previsto'] - $aDetalle['cantidad'];
					}
					// debug("Detalle Albaran: ");
					// print_r($aDetalle);
					if ( ($aDetalle['cantidad_pendiente']) < pow(10,-6) OR 
							($this->iLockedID and $this->iLockedID != $aDetPed['id_articulo']) ) {
						debug("No pendiente (".$aDetalle['stock_previsto']." - ".$aDetalle['cantidad']." = ".
									$aDetalle['cantidad_pendiente'].
									") (o este no es el prod)... seguimos. locked: $bLockedID ID:".$aDetPed['id_articulo']."\n");
						// print_r($aDetPed);
						continue;
					}

					$aR = $this->aDeliveryNotes[$aRefAlb['idx_albaran']]->getDetailVector($aRefAlb['idx']);
					if (!is_array($aRetVal)) $aRetVal = array();
					$aR['idx_albaran'] = $aRefAlb['idx_albaran'];
					$aR['idx'] = $aRefAlb['idx'];

					// debug("Sumamos aR a la lista de retornos .. ");
					array_push($aRetVal,$aR);

					debug("El limite ahora esta en $i + 1 de $nLimit ... ");
					if ( !empty($nLimit) and ++$i>=$nLimit ) {
						// debug("_Rompemos! ");
						$bCont = false;
						break;
					}
				}
				$aIdxList = NULL;
			} else debug("Pues no hay idx ... ninguno ");

			if ($this->bLocked) break;
			if ($bNextOnNotCont or $bCont) {
				$idxLoc = $this->nextLocation();
				// debug("Saltando a Siguiente idxLoc es ($idxLoc) ");
				if (!is_numeric($idxLoc) or empty($this->idxSKU[$idxLoc])) {
					// Nothing to do
					// debug("Sa Limox");
					break;
				}
			}
		}
		return $aRetVal;
	}

	function unlockNotes() {
		$this->bLocked = false;
		$this->iLockedID = NULL;
	}

	function setIgnoredForNotes($idx_alb,$idx) {
		if (is_a($this->aDeliveryNotes[$idx_alb],'DeliveryNote') and 
				$this->aDeliveryNotes[$idx_alb]->checkDetailPosition($idx)) {
			$this->aIgnorados[$idx_alb][$idx] = true;
		}
	}

	function getIgnoredForNotes($idx_alb = NULL) {
		$aRetVal = NULL;
		if (is_array($this->aIgnorados) and sizeof($this->aIgnorados)) 
			foreach ($this->aIgnorados as $idxa => $aIdx) {
				if (!empty($idx_alb) and $idxa != $idx_alb) continue;
				if (is_array($aIdx) and sizeof($aIdx)) 
					foreach ($aIdx as $idx => $bool) 
						if ((bool)$bool) {
							if (!empty($idx_alb)) $aRetVal[] = $idx;
							else $aRetVal[$idxa][] = $idx;
						}
			}
		return $aRetVal;
	}

	function isIgnoredForNotes($idx_alb,$idx) {
		// $this->debug("idxA: $idx_alb  idxDet: $idx ",'isIgnoredForNotes');
		return (bool)$this->aIgnorados[$idx_alb][$idx];
	}

	function unsetIgnoredForNotes($idx_alb,$idx) {
		if ( (bool)$this->aIgnorados[$idx_alb][$idx]) $this->aIgnorados[$idx_alb][$idx] = false;
		return true;
	}

	function &getDeliveryNote($idx) {
		if (is_object($this->aDeliveryNotes[$idx])) return $this->aDeliveryNotes[$idx];
		else return NULL;
	}

	function getNoteList() {
		if (!is_array($this->aDeliveryNotes) or !sizeof($this->aDeliveryNotes)) {
			debug("NO HAY NOTAS ");
			return NULL;
		}
		return array_keys($this->aDeliveryNotes);
	}

	function checkItem($idx_alb,$idx,$cnt) {
		if (is_a($this->aDeliveryNotes[$idx_alb],'DeliveryNote')) {
			$this->debug("Haciendo check para $idx en $idx_alb con $cnt ",'checkItem');
			$this->aDeliveryNotes[$idx_alb]->checkDetailQuantity($cnt,$idx);
		}
		return;
	}

	function checkItemList($idx_alb,$mDet) {
		if (is_a($this->aDeliveryNotes[$idx_alb],'DeliveryNote') and is_array($mDet) and sizeof($mDet)) {
			debug("Haciendo check Multiple en $idx_alb ");
			$this->aDeliveryNotes[$idx_alb]->updateDetails($mDet);
		}
	}

	function __getFromLocation($loc = NULL) {
		if (empty($loc)) $loc = $this->currentLocation();
		if (empty($loc)) {
			// Nothing to do
			return NULL;
		}
		if (is_numeric($loc) and !isset($this->idxSKU[$loc])) return NULL;
		if (is_numeric($loc)) $str = $this->idxSKU[$loc];
		else $str = $loc;

		$aTmp = split('\-',$str);
		if (sizeof($aTmp)>1) {
			$aIdx['id_almacen_logico'] = (int)$aTmp[0];
			$str = $aTmp[1];
		}
		$aTmp = split('\:',$str);
		$aIdx['planta'] = (int)$aTmp[0];
		$aIdx['pasillo'] = (int)$aTmp[1];
		$aIdx['columna'] = (int)$aTmp[2];
		$aIdx['fila'] = (int)$aTmp[3];

		$aRec = $this->oIdxSKURef->get($aIdx,false);
		// $this->debug(array("Obteniendo: $loc ",'aIdx' => $aIdx,'aRec' => $aRec,'<br/>'),'__getFromLocation');

		return $aRec;
	}

	/** FIN de Metodos de Preparacion de Albaranes **/

	function __compareLocation($aF,$aL,$bProdID = false) {
		if (!is_array($aF) or !is_array($aL)) return false;
		$bMatch = false;
		$aFldOrig = array();
		$aFldDest = array();
		// Campos!
		if (is_numeric($aF['id_almacen_logico'])) $aFldOrig['zona']='id_almacen_logico';
		elseif (is_numeric($aF['Detalle.id_almacen_logico'])) $aFldOrig['zona']='Detalle.id_almacen_logico';
		else  $aFldOrig['zona']='id_almacen_logico';
		if (is_numeric($aL['id_almacen_logico'])) $aFldDest['zona']='id_almacen_logico';
		elseif (is_numeric($aL['Detalle.id_almacen_logico'])) $aFldDest['zona']='Detalle.id_almacen_logico';
		else  $aFldDest['zona']='id_almacen_logico';
		if (is_numeric($aF['planta'])) $aFldOrig['planta']='planta';
		elseif (is_numeric($aF['Detalle.planta'])) $aFldOrig['planta']='Detalle.planta';
		else  $aFldOrig['planta']='planta';
		if (is_numeric($aL['planta'])) $aFldDest['planta']='planta';
		elseif (is_numeric($aL['Detalle.planta'])) $aFldDest['planta']='Detalle.planta';
		else  $aFldDest['planta']='planta';
		if (is_numeric($aF['pasillo'])) $aFldOrig['pasillo']='pasillo';
		elseif (is_numeric($aF['Detalle.pasillo'])) $aFldOrig['pasillo']='Detalle.pasillo';
		else  $aFldOrig['pasillo']='pasillo';
		if (is_numeric($aL['pasillo'])) $aFldDest['pasillo']='pasillo';
		elseif (is_numeric($aL['Detalle.pasillo'])) $aFldDest['pasillo']='Detalle.pasillo';
		else  $aFldDest['pasillo']='pasillo';
		if (is_numeric($aF['columna'])) $aFldOrig['columna']='columna';
		elseif (is_numeric($aF['Detalle.columna'])) $aFldOrig['columna']='Detalle.columna';
		else  $aFldOrig['columna']='columna';
		if (is_numeric($aL['columna'])) $aFldDest['columna']='columna';
		elseif (is_numeric($aL['Detalle.columna'])) $aFldDest['columna']='Detalle.columna';
		else  $aFldDest['columna']='columna';
		if (is_numeric($aF['fecha_caducidad'])) $aFldOrig['fecha_caducidad']='fecha_caducidad';
		elseif (is_numeric($aF['Detalle.fecha_caducidad'])) $aFldOrig['fecha_caducidad']='Detalle.fecha_caducidad';
		else  $aFldOrig['fecha_caducidad']='fecha_caducidad';
		if (is_numeric($aL['fecha_caducidad'])) $aFldDest['fecha_caducidad']='fecha_caducidad';
		elseif (is_numeric($aL['Detalle.fecha_caducidad'])) $aFldDest['fecha_caducidad']='Detalle.fecha_caducidad';
		else  $aFldDest['fecha_caducidad']='fecha_caducidad';
		if (is_numeric($aF['lote'])) $aFldOrig['lote']='lote';
		elseif (is_numeric($aF['Detalle.lote'])) $aFldOrig['lote']='Detalle.lote';
		else  $aFldOrig['lote']='lote';
		if (is_numeric($aL['lote'])) $aFldDest['lote']='lote';
		elseif (is_numeric($aL['Detalle.lote'])) $aFldDest['lote']='Detalle.lote';
		else  $aFldDest['lote']='lote';
		/** **
		debug("Comparando localizaciones. Origen: ");
		print_r($aF);
		debug("Campos Origen: ");
		print_r($aFldOrig);
		debug("Destino: ");
		print_r($aL);
		debug("Campos Destino: ");
		print_r($aFldDest);
		/** **/
		if ( $aF[$aFldOrig['id_almacen_logico']]==$aL[$aFldDest['id_almacen_logico']] 
				and $aF[$aFldOrig['planta']]==$aL[$aFldDest['planta']] 
				and $aF[$aFldOrig['pasillo']]==$aL[$aFldDest['pasillo']] 
				and $aF[$aFldOrig['columna']]==$aL[$aFldDest['columna']] 
				and $aF[$aFldOrig['fila']]==$aL[$aFldDest['fila']] ) {
			if (!$bProdID) $bMatch = true;
			elseif (wol_db::formatear_fecha($aF[$aFldOrig['fecha_caducidad']],false,false)==wol_db::formatear_fecha($aL[$aFldDest['fecha_caducidad']],false,false) 
						and ((empty($aF[$aFldOrig['lote']]) and empty($aL[$aFldDest['lote']])) 
							or $aF[$aFldOrig['lote']]==$aL[$aFldDest['lote']]) ) {
				$bMatch = true;
			}
		}
		return $bMatch;
	}

	function __verifyLocation($aL,$bProdID = false) {
		if (!is_array($aL)) return false;
		if ( !is_numeric($aL['id_almacen_logico']) or !is_numeric($aL['planta']) or !is_numeric($aL['pasillo'])
			or !is_numeric($aL['columna']) or !is_numeric($aL['fila']) ) return false;

		if ($bProdID) {
			if (!is_numeric($aL['id_articulo'])) return false;
			if (empty($aL['fecha_caducidad']) or !strcasecmp(wol_db::formatear_fecha($aF['fecha_caducidad'],false,false),'0000-00-00'))
				return false;
		}
		return true;
	}

}

class BajaAlmacen extends dbItemMultiEntity {
	var $oPeriodo = NULL;
	var $oAlmacen = NULL;
	var $oAlbaran = NULL;
	var $bStockChange = true;

	function BajaAlmacen($AppName = NULL,$dbname = NULL,$aData = NULL) {
		if (empty($AppName)) $AppName = $GLOBALS['APP_NAME'];
		if (empty($dbname)) $dbname = 'data';
		$tabla = 'Bajas_localizacion';

		$aFlds['Bajas_localizacion:Baja'] = array(
			//Claves Primarias, Maestros y Foraneas
			'id_baja_localizacion','id_baja_almacen','id_articulo','id_albaran','id_detalle',
			// Localizacion
			'id_almacen_logico','lote','planta','pasillo','columna','fila','fecha_caducidad',
			// Datos
			'cantidad','descripcion','fecha_baja','id_dia_baja'
			);
		$aFlds['Bajas_almacen:Tipo'] = array(
			// Claves
			'id_baja_almacen',
			// Datos
			'nombre'
			);
		$aFlds['Articulos:Producto'] = array(
			// Claves
			'id_articulo',
			// Datos
			'nombre','codigo_barras','codigo_barras_bulto'
			);
		$aFlds['Almacenes_logicos:Zona'] = array(
			// Claves
			'id_almacen_logico',
			// Datos
			'nombre','id_almacen'
			);


		$aAcciones['id_baja_almacen'] = array('method' => 'updateForeignKey');
		$aAcciones['id_articulo'] = array('method' => 'updateForeignKey');
		$aAcciones['id_almacen_logico'] = array('method' => 'updateForeignKey');
		$aAcciones['fecha_baja'] = array('method' => 'setDate');

		if (!parent::dbItemMultiEntity($AppName,$dbname,$tabla,$aFlds,$aData,$aAcciones)) {
			$this->setFlag($this->ST_CORRUPT);
			return false;
		}
		return true;
	}

	function setAttribute($campo,$valor,$entidad = NULL,$bForce = NULL,$bMarkIfChanged = NULL) {
		if (!$this->ST_NEW) {
			debug("Error: no se puede modificar una baja ");
			return false;
		}
		return parent::setAttribute($campo,$valor,$entidad,$bForce,$bMarkIfChanged);
	}

	function update($aData,$entidad = NULL,$bForce = NULL) {
		if (!$this->ST_NEW) {
			debug("Error: no se puede modificar una baja ");
			return false;
		}
		return parent::update($aData,$entidad,$bForce);
	}

	function setDate($fecha = NULL) {
		if (empty($fecha)) $fecha = date('Y-m-d H:i:s');
		$f = $this->getAttribute('fecha_baja');
		if ($f==$fecha) return true;
		$f = wol_db::formatear_fecha($fecha,false);
		if (!strcasecmp($f,'null')) return false;
		if (!is_a($this->oPeriodo,'Periodo')) $this->oPeriodo = &Periodo::factoryActivePeriod();
		if (is_a($this->oPeriodo,'Periodo')) $aRec = $this->oPeriodo->getAssignments(array('fecha_baja'=>$fecha),'Bajas_localizacion');
		if (is_array($aRec) and sizeof($aRec))
			foreach ($aRec as $fld => $val) $this->setAttribute($fld,$val);
		else $this->setAttribute('fecha_baja',$fecha);
	}

	function getDate() {
		return $this->getAttribute('fecha_baja');
	}

	function alterStock($bStockChange = true) {
		$this->bStockChange = ( ($bStockChange) ? true : false );
		return true;
	}

	function preDump() {
		$rval = true;

		$f = $this->getDate();
		if (empty($f)) $this->setDate();
		$ida = $this->getAttribute('id_albaran');
		$idd = $this->getAttribute('id_detalle');
		if ((!empty($idd) and empty($ida)) or (!empty($ida) and empty($idd)) ) {
			debug("Error: Baja no asociada a Albaran al no disponer de los 2 campos requeridos. ");
			$this->setAttribute('id_albaran',NULL);
			$this->setAttribute('id_detalle',NULL);
		}
		if (!is_a($this->oAlmacen,'Wherehouse')) {
			$ida = $this->getAttribute('id_almacen','Zona');
			if (!is_numeric($ida)) {
				debug("Error: Debe indicar una zona de Almacen. ");
				return false;
			}
			debug("Creando instancia de Almacen ");
			$this->oAlmacen = new Wherehouse();
			$rval = $this->oAlmacen->dbFill($ida);
		}
		return $rval;
	}

	function postDump($rval) {
		if ($rval) {
			if (!$this->bStockChange) return $rval;

			debug("Procedemos a retirar la mercancia del stock .. ");
			if (!is_a($this->oAlmacen,'Wherehouse')) {
				debug("Error: No existe la instancia Almacen ");
				return false;
			}

			$aLoc = array(
						'id_articulo' => $this->getAttribute('id_articulo'),
						'id_almacen_logico' => $this->getAttribute('id_almacen_logico'),
						'planta' => $this->getAttribute('planta'),
						'pasillo' => $this->getAttribute('pasillo'),
						'columna' => $this->getAttribute('columna'),
						'fila' => $this->getAttribute('fila'),
						'fecha_caducidad' => $this->getAttribute('fecha_caducidad'),
						'lote' => $this->getAttribute('lote'),
						);
			if ($GLOBALS['DEBUG']=='ON') {
				debug("La loca .. ");
				print_r($aLoc);
			}
			$aLoc['cantidad'] = (-1*$this->getAttribute('cantidad'));
			$aNLoc = $this->oAlmacen->stockUpdate(array($aLoc));
			if (is_array($aNLoc) and sizeof($aNLoc)) {
				foreach ($aNLoc as $idx => $aL) $aP[$aL['id_articulo']] += $aL['cantidad'];
				$this->oAlmacen->notifyStockDescChange($aP);
			}
		}
		return $rval;
	}

}

class AltaAlmacen extends dbItemMultiEntity {
	var $oPeriodo = NULL;
	var $oAlmacen = NULL;
	var $oAlbaran = NULL;
	var $bStockChange = true;

	function AltaAlmacen($AppName = NULL,$dbname = NULL,$aData = NULL) {
		if (empty($AppName)) $AppName = $GLOBALS['APP_NAME'];
		if (empty($dbname)) $dbname = 'data';
		$tabla = 'Altas_stock';

		$aFlds['Altas_stock:Alta'] = array(
			//Claves Primarias, Maestros y Foraneas
			'id_alta_stock','id_tipo_alta','id_articulo',
			// Localizacion
			'id_almacen_logico','lote','planta','pasillo','columna','fila','fecha_caducidad',
			// Datos
			'cantidad','descripcion','fecha_alta','id_dia_alta'
			);
		$aFlds['Tipos_Alta_stock:Tipo'] = array(
			// Claves
			'id_tipo_alta',
			// Datos
			'nombre'
			);
		$aFlds['Articulos:Producto'] = array(
			// Claves
			'id_articulo',
			// Datos
			'nombre','codigo_barras','codigo_barras_bulto'
			);
		$aFlds['Almacenes_logicos:Zona'] = array(
			// Claves
			'id_almacen_logico',
			// Datos
			'nombre','id_almacen'
			);


		$aAcciones['id_tipo_alta'] = array('method' => 'updateForeignKey');
		$aAcciones['id_articulo'] = array('method' => 'updateForeignKey');
		$aAcciones['id_almacen_logico'] = array('method' => 'updateForeignKey');
		$aAcciones['fecha_alta'] = array('method' => 'setDate');

		if (!parent::dbItemMultiEntity($AppName,$dbname,$tabla,$aFlds,$aData,$aAcciones)) {
			$this->setFlag($this->ST_CORRUPT);
			return false;
		}
		return true;
	}

	function setAttribute($campo,$valor,$entidad = NULL,$bForce = NULL,$bMarkIfChanged = NULL) {
		if (!$this->ST_NEW) {
			debug("Error: no se puede modificar una baja ");
			return false;
		}
		return parent::setAttribute($campo,$valor,$entidad,$bForce,$bMarkIfChanged);
	}

	function update($aData,$entidad = NULL,$bForce = NULL) {
		if (!$this->ST_NEW) {
			debug("Error: no se puede modificar una baja ");
			return false;
		}
		return parent::update($aData,$entidad,$bForce);
	}

	function setDate($fecha = NULL) {
		if (empty($fecha)) $fecha = date('Y-m-d H:i:s');
		$f = $this->getAttribute('fecha_baja');
		if ($f==$fecha) return true;
		$f = wol_db::formatear_fecha($fecha,false);
		if (!strcasecmp($f,'null')) return false;
		if (!is_a($this->oPeriodo,'Periodo')) $this->oPeriodo = &Periodo::factoryActivePeriod();
		if (is_a($this->oPeriodo,'Periodo')) $aRec = $this->oPeriodo->getAssignments(array('fecha_alta'=>$fecha),'Bajas_localizacion');
		if (is_array($aRec) and sizeof($aRec))
			foreach ($aRec as $fld => $val) $this->setAttribute($fld,$val);
		else $this->setAttribute('fecha_baja',$fecha);
	}

	function getDate() {
		return $this->getAttribute('fecha_alta');
	}

	function alterStock($bStockChange = true) {
		$this->bStockChange = ( ($bStockChange) ? true : false );
		return true;
	}

	function preDump() {
		$rval = true;

		$f = $this->getDate();
		if (empty($f)) $this->setDate();
		if (!is_a($this->oAlmacen,'Wherehouse')) {
			$ida = $this->getAttribute('id_almacen','Zona');
			if (!is_numeric($ida)) {
				debug("Error: Debe indicar una zona de Almacen. ");
				return false;
			}
			debug("Creando instancia de Almacen ");
			$this->oAlmacen = new Wherehouse();
			$rval = $this->oAlmacen->dbFill($ida);
		}
		return $rval;
	}

	function postDump($rval) {
		if ($rval) {
			if (!$this->bStockChange) return $rval;

			debug("Procedemos a sumar la mercancia del stock .. ");
			if (!is_a($this->oAlmacen,'Wherehouse')) {
				debug("Error: No existe la instancia Almacen ");
				return false;
			}

			$aLoc = array(
						'id_articulo' => $this->getAttribute('id_articulo'),
						'id_almacen_logico' => $this->getAttribute('id_almacen_logico'),
						'planta' => $this->getAttribute('planta'),
						'pasillo' => $this->getAttribute('pasillo'),
						'columna' => $this->getAttribute('columna'),
						'fila' => $this->getAttribute('fila'),
						'fecha_caducidad' => $this->getAttribute('fecha_caducidad'),
						'lote' => $this->getAttribute('lote'),
						);
			if ($GLOBALS['DEBUG']=='ON') {
				debug("La loca .. ");
				print_r($aLoc);
			}
			$aLoc['cantidad'] = ($this->getAttribute('cantidad'));
			$aNLoc = $this->oAlmacen->stockUpdate(array($aLoc));
			if (is_array($aNLoc) and sizeof($aNLoc)) {
				foreach ($aNLoc as $idx => $aL) $aP[$aL['id_articulo']] += $aL['cantidad'];
				$this->oAlmacen->notifyStockAscChange($aP);
			}
		}
		return $rval;
	}

}

class CuarentenaAlmacen extends dbItemMultiEntity {
	var $oPeriodo = NULL;
	var $oAlmacen = NULL;
	var $oAlbaran = NULL;
	var $bStockChange = true;

	function CuarentenaAlmacen($AppName = NULL,$dbname = NULL,$aData = NULL) {
		if (empty($AppName)) $AppName = $GLOBALS['APP_NAME'];
		if (empty($dbname)) $dbname = 'data';
		$tabla = 'Cuarentenas';

		$aFlds['Cuarentenas:Cuarentena'] = array(
			//Claves Primarias, Maestros y Foraneas
			'id_cuarentena','id_tipo_cuarentena','id_articulo',
			// Localizacion
			'id_almacen_logico','lote','planta','pasillo','columna','fila','fecha_caducidad',
			// Datos
			'cantidad','descripcion','fecha_alta','id_dia_alta'
			);
		$aFlds['Tipos_Cuarentena:Tipo'] = array(
			// Claves
			'id_tipo_cuarentena',
			// Datos
			'nombre'
			);
		$aFlds['Articulos:Producto'] = array(
			// Claves
			'id_articulo',
			// Datos
			'nombre','codigo_barras','codigo_barras_bulto'
			);
		$aFlds['Almacenes_logicos:Zona'] = array(
			// Claves
			'id_almacen_logico',
			// Datos
			'nombre','id_almacen'
			);


		$aAcciones['id_tipo_cuarentena'] = array('method' => 'updateForeignKey');
		$aAcciones['id_articulo'] = array('method' => 'updateForeignKey');
		$aAcciones['id_almacen_logico'] = array('method' => 'updateForeignKey');
		$aAcciones['fecha_alta'] = array('method' => 'setDate');

		if (!parent::dbItemMultiEntity($AppName,$dbname,$tabla,$aFlds,$aData,$aAcciones)) {
			$this->setFlag($this->ST_CORRUPT);
			return false;
		}
		return true;
	}

	function setAttribute($campo,$valor,$entidad = NULL,$bForce = NULL,$bMarkIfChanged = NULL) {
		if (!$this->ST_NEW) {
			debug("Error: no se puede modificar una baja ");
			return false;
		}
		return parent::setAttribute($campo,$valor,$entidad,$bForce,$bMarkIfChanged);
	}

	function update($aData,$entidad = NULL,$bForce = NULL) {
		if (!$this->ST_NEW) {
			debug("Error: no se puede modificar una baja ");
			return false;
		}
		return parent::update($aData,$entidad,$bForce);
	}

	function setDate($fecha = NULL,$campo = NULL) {

		switch ($campo) {
			case 'apertura':
				$campo = 'fecha_apertura';
				break;
			case 'cierre':
				$campo = 'fecha_cierre';
				break;
			case 'fecha_apertura':
				$campo = 'fecha_apertura';
				break;
			case 'fecha_cierre':
				$campo = 'fecha_cierre';
				break;
			default:
				$f = $this->getDate('apertura');
				if (!empty($f)) $campo = 'fecha_cierre';
				else $campo = 'fecha_apertura';
				break;
		}
		if (empty($fecha)) $fecha = date('Y-m-d H:i:s');
		$f = $this->getAttribute($campo);
		if ($f==$fecha) return true;
		$f = wol_db::formatear_fecha($fecha,false);
		if (!strcasecmp($f,'null')) return false;
		if (!is_a($this->oPeriodo,'Periodo')) $this->oPeriodo = &Periodo::factoryActivePeriod();
		if (is_a($this->oPeriodo,'Periodo')) $aRec = $this->oPeriodo->getAssignments(array($campo=>$fecha),'Bajas_localizacion');
		if (is_array($aRec) and sizeof($aRec))
			foreach ($aRec as $fld => $val) $this->setAttribute($fld,$val);
		else $this->setAttribute($campo,$fecha);
	}

	function getDate() {
		switch ($campo) {
			case 'apertura':
				$campo = 'fecha_apertura';
				break;
			case 'cierre':
				$campo = 'fecha_cierre';
				break;
			case 'fecha_apertura':
				$campo = 'fecha_apertura';
				break;
			case 'fecha_cierre':
				$campo = 'fecha_cierre';
				break;
			default:
				$campo = 'fecha_apertura';
				break;
		}
		return $this->getAttribute($campo);
	}

	function alterStock($bStockChange = true) {
		$this->bStockChange = ( ($bStockChange) ? true : false );
		return true;
	}

	function preDump() {
		$rval = true;

		$f = $this->getDate();
		if (empty($f)) $this->setDate();
		if (!is_a($this->oAlmacen,'Wherehouse')) {
			$ida = $this->getAttribute('id_almacen','Zona');
			if (!is_numeric($ida)) {
				debug("Error: Debe indicar una zona de Almacen. ");
				return false;
			}
			debug("Creando instancia de Almacen ");
			$this->oAlmacen = new Wherehouse();
			$rval = $this->oAlmacen->dbFill($ida);
		}
		return $rval;
	}

	function postDump($rval) {
		if ($rval) {
			if (!$this->bStockChange) return $rval;

			debug("Procedemos a sumar la mercancia del stock .. ");
			if (!is_a($this->oAlmacen,'Wherehouse')) {
				debug("Error: No existe la instancia Almacen ");
				return false;
			}

			$aLoc = array(
						'id_articulo' => $this->getAttribute('id_articulo'),
						'id_almacen_logico' => $this->getAttribute('id_almacen_logico'),
						'planta' => $this->getAttribute('planta'),
						'pasillo' => $this->getAttribute('pasillo'),
						'columna' => $this->getAttribute('columna'),
						'fila' => $this->getAttribute('fila'),
						'fecha_caducidad' => $this->getAttribute('fecha_caducidad'),
						'lote' => $this->getAttribute('lote'),
						);
			if ($GLOBALS['DEBUG']=='ON') {
				debug("La loca .. ");
				print_r($aLoc);
			}
			$aLoc['cantidad'] = ($this->getAttribute('cantidad'));
			$aNLoc = $this->oAlmacen->stockUpdate(array($aLoc));
			if (is_array($aNLoc) and sizeof($aNLoc)) {
				foreach ($aNLoc as $idx => $aL) $aP[$aL['id_articulo']] += $aL['cantidad'];
				$this->oAlmacen->notifyStockAscChange($aP);
			}
		}
		return $rval;
	}

}

class MozoAlmacen extends dbItemMultiEntity {

	function MozoAlmacen ($AppName = NULL, $dbname = 'data', $aData = NULL) {
		if (empty($AppName)) $AppName = $GLOBALS['APP_NAME'];

		$tabla = 'Mozos_almacen';

		$aFlds['Mozos_almacen:Mozo'] = array(
			// Claves Primarias y Foraneas
				'id_mozo','id_empresa','id_almacen','id_provincia','crm_id_empleado','id_usr',
			// Datos Personales
				'cif','nombre','apellidos','direccion','cp','poblacion','telefono1','telefono2','email','observaciones','notificar_stock',
			// Datos Bancarios
				'iban','bic','bban','entidad','dc_ccc','oficina','cuenta_bancaria'
				);
		$aFlds['Almacenes:Almacen'] = array(
				'id_almacen','id_empresa','id_provincia',
				'nombre','direccion','cp','poblacion','telefono','fax','email','cargo_persona_contacto','persona_contacto','nota_pie_albaran'
				);
		$aFlds['Empresas:Empresa'] = array(
				'id_empresa',
				'razon_social','nombre','apellidos','direccion_facturacion','cp','poblacion','telefono1','fax','email','stock_negativo'
				);

		$aAcciones['id_empresa'] = array('method' => 'updateForeignKey');
		$aAcciones['id_almacen'] = array('method' => 'updateForeignKey');

		if (!parent::dbItemMultiEntity($AppName,$dbname,$tabla,$aFlds,$aData,$aAcciones)) {
			$this->setFlag($this->ST_CORRUPT);
			return false;
		}
	}

	function update ($aData,$entidad = NULL,$bForce = NULL) {
		$oS = &$this->getApp();
		if (empty($aData['login']) and empty($aData['passwd']) and empty($aData['nombre']) and empty($aData['apellidos']) ) {
			$tmp = $this->getAttribute('nombre');
			$tmp2 = $this->getAttribute('apellidos');
			if (empty($tmp) and empty($tmp2)) {
				if (empty($tmp)) $aTmp['fld1'] = 'nombre';
				if (empty($tmp2)) $aTmp['fld2'] = 'apellidos';
				$oS->lcMessage('IKRN_MISSING_FIELDS',$aTmp);
				return false;
			}
		}
		$idu = $this->getAttribute('id_usr');
		if ($idu != $aData['id_usr'] and !empty($aData['login']) ) $aData['id_usr'] = $idu;

		$rval = parent::update($aData,$entidad,$bForce);
		debug("FixMe: De momento no comprobamos el atributo id_empresa, falta ver que hacemos con el, no esta bien que este en MozosAlmacen ");

		if ($rval) {
			if (!empty($aData['login']) or !empty($aData['id_usr'])) {
				if (!empty($aData['passwd']) and strcmp($aData['passwd'],$aData['passwd2'])) {
					$oS->lcMessage('LCS_USR_PASSWORDMISMATCH',array('login' => $luser['login']));
				} else {
					$aUsr['activo'] = (int)$aData['activo'];
					$aUsr['nombre'] = $this->getAttribute('nombre').' '.$this->getAttribute('apellidos');
					$aUsr['passwd'] = $aData['passwd'];
					$aUsr['login'] = $aData['login'];
					$aUsr['id_usr'] = $this->getAttribute('id_usr');
					$oUsr = $oS->get_authed_user();
					$idu = $oUsr->dbReplaceUser($aUsr,'Almacenes');
					if ( (!empty($idu) and $idu!=-1) ) {
						$this->setAttribute('id_usr',$idu);
					} else {
						$this->setAttribute('id_usr','null');
					}
				}
			}
		}

		return $rval;
	}

	function postDump($rval) {
		if ($rval) {
			if ($this->checkFlag($this->ST_DEL)) {
				$id_usr = $this->getAttribute('id_usr');
				$oS = &$this->getApp();
				$oUsr = $oS->get_authed_user();
				$oUsr->dbReplaceUser(array('id_usr' => $id_usr, 'login' => NULL),'Almacenes');
			}
		}
		return $rval;
	}
}

?>
