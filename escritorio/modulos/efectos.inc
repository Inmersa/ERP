<?php

class DraftDetailItem extends dbListItem {
	var $bAccount = true;

	function DraftDetailItem(&$oEfecto,$idx,$aData) {
		$aAcciones['id_banco'] = array('method' => 'updateBank');
		$aAcciones['monto_satisfecho'] = array('method' => 'updateAmmount');
		$aAcciones['fecha'] = array('method' => 'setDate');

		if (!parent::dbListItem($oEfecto,$idx,$aData,$aAcciones)) {
			$this->setFlag($this->ST_CORRUPT);
			return false;
		}
	}

	/** Metodos Sobre-Escritos **/
	function preDump($type) {
		$id_banco = $this->getAttribute('id_banco');

		if ($this->checkFlag($this->ST_NEW | $this->ST_EDIT | $this->ST_DEL)) {
			$id_abono = $this->getAttribute('id_factura_abono');
			if (is_numeric($id_abono) AND !empty($id_abono)) {
				$aAbono = $this->getData('Abono');
				if (!is_array($aAbono) OR !sizeof($aAbono)) {
					$this->dbFillEntity(array('id_factura' => $id_abono),'Abono');
					$aAbono = $this->getData('Abono');
					if (!is_array($aAbono) OR !sizeof($aAbono)) {
						debug("Error: No se ha podido obtener la Fra de abono del pago parcial");
						return false;
					}
				}
				$aSerie = $this->getData('AbonoSerie');
				if (!is_array($aSerie) OR !sizeof($aSerie)) {
					if (!is_numeric($aAbono['id_serie'])) {
						debug("Error: No se puede tener una factura de abono sin una serie de facturacion determinada");
						return false;
					}
					$this->dbFillEntity(array('id_serie' => $aAbono['id_serie']),'AbonoSerie');
					$aSerie = $this->getData('AbonoSerie');
					if (!is_array($aSerie) OR !sizeof($aSerie)) {
						debug("Error:  No se ha podido encontrar la serie de facturacion perteneciente a la fra de abono XX-X ");
						return false;
					}
				}
				if (!(int)$aSerie['contabilizable']) {
					$this->dontAccount();
				}
				$this->debug("Parcial de Fra de Abono: ".$id_abono,'preDump');
			}
			$fecha = $this->getDate('fecha');
			if (empty($fecha)) $this->setDate();
			$this->setPaymentMethod();

			$oE = &$this->getMainDraft();
			if ($this->checkFlag($this->ST_DEL)) {
				$tipo = 'del';
				$this->setDate($this->getDate('now'),'fecha');
				$fecha = $this->getDate('fecha');
				$importe = $this->getAmmount('paid');
				$concepto = 'Borrado ';
			} else {
				$tipo = 'cargo';
				$fecha = $this->getDate();
				$importe = $this->getAmmount('paid');
				$concepto = '';
			}
			$idn = $oE->newAccountEntry(NULL,NULL,$tipo,$fecha,$importe);
			$oAsiento = &$oE->getAccountEntry($idn,'new');

			if (is_a($oAsiento,'AccountEntry') ) {
				$this->debug("Apilando asiento .. ",'preDump');

				if (!is_numeric($this->getAttribute('id_factura_abono'))) {
					$ref_ext = $oE->getAttribute('referencia_externa','Factura');
					$concepto .= 'Efecto Parcial Fra: '.$oE->getAttribute('referencia','Factura').( (!empty($ref_ext)) ? ' ['.$ref_ext.']' : '');
					$oAsiento->setName($concepto);
				} else {
					$this->debug("Asiento de EfectoParcial por factura de abono ... ",'preDump');
					$ref_ext = $this->getAttribute('referencia_externa','Abono');
					$concepto .= 'Saldo Efecto Fra: '.$oE->getAttribute('referencia','Factura').' por Abono en '.
									$this->getAttribute('referencia','Abono').( (!empty($ref_ext)) ? ' ['.$ref_ext.']' : '');
					$oAsiento->setName($concepto);
					$oAsiento->setInvoice($this->getAttribute('id_factura_abono'));
				}
				$oAsiento->setDescription($this->getAttribute('notas'));

				$oE->Account($idn,$this,'new');
			}
		}

		return true;
	}

	function postDump($retdump) {
		return true;
	}

	function delete($bForce = false) {
		if (!$bForce) {
			// No se permiten borrar efectos de abono
			$id_abono = $this->getAttribute('id_factura_abono');
			if (is_numeric($id_abono) AND !empty($id_abono)) return false;
		}

		$pparcial = $this->getAttribute('monto_satisfecho');
		$oE = &$this->getMainDraft();
		$pagado = $oE->getAmmount('paid');
		if ($oE->update(array('monto_pagado' => (-1 * $pparcial)))) {
			$this->_setAttribute('devuelto',1);

			/** ** FixMe: Esto no vale no? 
			$ida = $oE->findAccountEntry($fecha);
			if (!$ida) {
				$oAsiento = &$oE->newAccountEntry();
			} else {
				$oAsiento = &$oE->getAccountEntry($ida);
			}
			$ida = $oE->getAttribute('id_asiento');
			if (!is_numeric($ida) OR empty($ida)) {
				$ida = $this->getAttribute('id_asiento');
				if (is_numeric($ida) AND !empty($ida))
					$oE->_setAttribute('id_asiento',$ida);
			}
			/** **/
			return parent::delete();
		}
	}

	function getData($what = '__main__') {
		if (!strcmp($what,'Cliente') OR !strcmp($what,'Proveedor') ) {
			$oE = &$this->getMainDraft();
			return $oE->getData($what);
		}
		return parent::getData($what);
	}

	function getAttribute($campo,$entidad = '__main__') {
		if (strchr($campo,'.')) {
			$aTmp = split('\.',$campo);
			$what = $aTmp[0];
		} else $what = $entidad;
		if (strcasecmp($what,'EfectoParcial') AND strcasecmp($what,'Efecto') AND strcasecmp($what,'Banco') 
				AND strcasecmp($what,'Abono') AND strcasecmp($what,'AbonoSerie') AND strcasecmp($what,'__main__') ) {
			$oE = &$this->getMainDraft();
			return $oE->getAttribute($campo,$entidad);
		} else return parent::getAttribute($campo,$entidad);
	}

	/** Metodos de Control y Flujo **/
	function &getMainDraft() {
		return $this->_oList->getMainDraft();
	}

	function dontAccount($val = true) {
		if (!isset($val)) $val = true;
		$this->bAccount = (bool)!$val;
		$this->debug('AccountAble => '.$this->bAccount,'dontAccount');
		return $this->bAccount;
	}

	function isAccountable() {
		return $this->bAccount;
	}


	/** Metodos de Atributos **/

	function updateAmmount($val,$fld = NULL) {
		$this->debug("val: $val fld: $fld ",'UpdateAmmount');
		if (!is_numeric($val)) return false;
		$oEfecto = &$this->getMainDraft();
		$pendiente = $oEfecto->getAmmount('pending');
		$retval = $oEfecto->update(array('monto_pagado' => $val));
		if ($retval) {
			settype($val,'float');
			$val = round($val,7);
			settype($pendiente,'float');
			$pendiente = round($pendiente,7);
			$retval = $this->_setAttribute($fld,$val);

			if ($val == $pendiente) {
				$oEfecto->setDate($this->getDate('abono'),'abono');
			}
		} else {
			return false;
		}
		return $retval;
	}

	function getAmmount($tipo = NULL) {
		if (empty($tipo) OR !strcasecmp($tipo,'paid')) return $this->getAttribute('monto_satisfecho');
		else {
			$oE = &$this->getMainDraft();
			return $oE->getAmmount($tipo);
		}
	}

	function getPaymentType() {
		$oE = &$this->getMainDraft();
		return (int)$oE->getAttribute('pago_cobro');
	}

	function updateAccountEntryId($val,$fld) {
		$this->_setAttribute($fld,$val);
		return true;
	}

	function updateBank($val,$fld) {
		$old = $this->getAttribute($fld,'Banco');
		if ($old != $val) {
			$retval = $this->dbFillEntity(array('id_banco' => $val),'Banco');
			if ($retval) $retval = $this->_setAttribute($fld,$val);
		} else $retval = true;
		return $retval;
	}

	function setDate($val = NULL,$fld = NULL) {
		if (empty($fld)) $fld = 'fecha';
		if (empty($val) OR !strcasecmp(wol_db::formatear_fecha($val,false),'null')) {
			if (!strcasecmp($fld,'fecha')) $fecha = date('d/m/Y H:m:i');
			$this->_setAttribute($fld,wol_db::formatear_fecha($fecha,false));
		} else {
			if (strcasecmp($fld,'fecha')) $fld = 'fecha';
			$this->_setAttribute($fld,wol_db::formatear_fecha($val,false));
		}
		if (!is_a($oPer,'Periodo')) $oPer = &Periodo::factoryActivePeriod();
		if (is_a($oPer,'Periodo')) $aTmp = $oPer->getAssignments(array($fld=>$val),'Efectos_parciales',false);
		if (is_array($aTmp) and sizeof($aTmp)) foreach ($aTmp as $fldn => $nval) $this->_setAttribute($fldn,$nval);
		return true;
	}

	function getDate($tipo = NULL) {
		if (empty($tipo)) $tipo = 'fecha';
		if (!strcasecmp($tipo,'abono')) $tipo = 'fecha';
		if (!strcasecmp($tipo,'fecha_vencimiento')) $tipo = 'vencimiento';
		if (!strcasecmp($tipo,'devolucion') AND $this->checkFlag($this->ST_DEL)) $tipo = 'now';
		switch ($tipo) {
			case 'now':
				$retval = date('d/m/Y H:m:i');
				break;

			case 'fecha':
				$retval = $this->getAttribute('fecha');
				break;

			case 'vencimiento':
				$oE = &$this->getMainDraft();
				$retval = $oE->getDate('vencimiento');
				break;
		}
		return $retval;
	}

	function setPaymentMethod() {
		$medio = $this->_oList->_oEfecto->getAttribute('medio_pago');
		// debug("medio: $medio ");
		$this->_setAttribute('medio_pago',$medio);
		return true;
	}

}

class DraftDetails extends IndexList {
	var $_oEfecto;

	function DraftDetails ($AppName,$dataconn = 'data') {
		if (empty($AppName)) {
			$this->setFlag($this->ST_CORRUPT);
			return false;
		}

		$itemclass = 'DraftDetailItem';

		// Ojo con meter mas entidades, en tal caso tb habria que meterlas en DraftDetailItem::getAttribute() 
		$tabla='Efectos_parciales';
		$aCampos['Efectos_parciales:EfectoParcial'] = array(
			'id_efecto_parcial', 'id_factura_abono','id_banco','id_efecto','fecha','monto_satisfecho',
				'notas','medio_pago'
			);
		$aCampos['Efectos:Efecto'] = array(
			'id_efecto', 'id_factura','id_banco','concepto','fecha_vencimiento','id_dia_vencimiento','fecha_abono','id_dia_abono','fecha_devolucion','id_dia_devolucion',
			'monto','monto_pagado','pago_cobro','emitido','devuelto','pagado'
			);
		$aCampos['Bancos:Banco'] = array(
			'id_banco', 'nombre','persona_contacto','cargo_contacto','email','telefono','fax','cuenta_contable'
			);

		$aCampos['Facturas:Abono'] = array(
			'id_factura', 'id_serie','referencia','referencia_externa','fecha','id_cliente','id_proveedor','factura_abono'
			);
		$aCampos['Series_facturacion:AbonoSerie'] = array(
				'id_serie','nombre','contador','ventas','contabilizable'
				);

		$aIndices = array('id_factura_abono','id_efecto_parcial','Banco.id_banco');
		// $aIndices = array('id_comentario','id_documento','Usuarios.id_usuario','Empleados.id_empleado');

		// $aAcciones['id_prioridad'] = array('method' => 'updatePriority');
		// $aAcciones[$oComentarios->clave_evento] = array('exclude' => array('new' => false, 'edit' => false) );

		return parent::IndexList($AppName,$dataconn,$tabla,$aCampos,$aIndices,$itemclass);
	}

	function cerrar() {
		if (is_a($this->_oEfecto,'Draft')) {
			unset($this->_oEfecto);
		}
		return parent::cerrar();
	}

	function setMainDraft(&$oEfecto) {
		if (!is_object($oEfecto)) return false;
		$this->_oEfecto = &$oEfecto;
		return true;
	}

	function &getMainDraft() {
		if (!is_object($this->_oEfecto)) return NULL;
		else return $this->_oEfecto;
	}

	function postFill($retval) {
		if ($this->countItems()) {
			for ($idx = $this->firstItem(); isset($idx); $idx=$this->nextItem()) {
				$oItem = &$this->getItem($idx);
				$monto = $oItem->getAttribute('monto_satisfecho');
				if ($monto < 0) {
					if (!is_a($oDb,'wol_db')) $oDb = $this->getDb();
					$monto *= -1;
					$oItem->_setAttribute('monto_satisfecho',$monto);
					$oDb->tb_update('Efectos_parciales',array('id_efecto_parcial' => $oItem->getAttribute('id_efecto_parcial'), 'monto_satisfecho' => $monto));
				}
				$total += $oItem->getAttribute('monto_satisfecho');
				$fecha = $oItem->getDate();
				if (!empty($fecha)) $oItem->_setAttribute('fecha',wol_db::formatear_fecha($fecha,false));
			}
			$oEfecto = &$this->getMainDraft();
			$monto_pagado = $oEfecto->getAttribute('monto_pagado');
			if ($monto_pagado < $total) $oEfecto->update(array('monto_pagado' => $total));
			// debug("Monto Total : $total  contra ".$oEfecto->getAttribute('monto')." y ".$monto_pagado." EdFlag: ".$oEfecto->checkFlag($oEfecto->ST_EDIT));
		}
		return true;
	}

	function preDump() {
		return true;
	}

	function postDump() {
		return true;
	}

	function _checkDraft() {
		$retval = false;
		if (!is_a($this->_oEfecto,'Draft')) {
			if ($this->countItems()) {
				$this->_oEfecto = new Draft($this,NULL);
				$oTE = $this->getItem($this->firtItem());
				$id = $oTE->getAttribute('id_efecto');
				if (is_numeric($id)) {
					if ($this->_oEfecto->dbFill(array('id_efecto' => $id))) {
						debug("<b>Asignando a pelo el main draft</b>");
						$this->_oEfecto->_oEfectosParciales = &$this;
						$retval = true;
					}
				}
			}
		} else $retval = true;
		return $retval;
	}

	function insert($aData) {
		if (!$this->_checkDraft()) return false;
		if (is_array($aData) AND sizeof($aData)) {
			$aData['id_efecto'] = $this->_oEfecto->getAttribute('id_efecto');
		}
		$retval = parent::insert($aData);
		return $retval;
	}

	function setAccounting($dbdata,$dbconf,$id_ejercicio) {
		if (empty($dbdata) AND empty($dbconf)) return false;

		$oE = &$this->getMainDraft();
		$retval = $oE->setAccounting($dbdata,$dbconf,$id_ejercicio);
		return $retval;
	}

	function getAccountingConf() {
		$oE = &$this->getMainDraft();
		return $oE->getAccountingConf($dbdata,$dbconf,$id_ejercicio);
	}


}

class Draft extends dbItemMultiEntity {
	var $_oEfectosParciales;
	var $_aVars;
	var $_aConta;
	var $_acList;
	var $bAccount = true;
	var $bAmmountChange = false; 	// Esta variable nos va a indicar si se han producido pagos sobre el efecto -no parciales-
	var $bAccountAsNew = false; 	// Esta variable nos va a indicar si se ha de volcar el asiento a contabilidad, como si fuese nuevo -reconocimiento adeudo-

	function Draft ($App_Name,$dataconn = 'data',$bVenta = true) {

		if (!isset($bVenta)) $bVenta = true;

		$tabla = 'Efectos';
		$aCampos['Efectos:Efecto'] = array(
			'id_efecto', 'id_factura','id_banco','concepto','fecha_vencimiento','fecha_abono','fecha_devolucion','monto','monto_pagado','pago_cobro',
				'emitido','devuelto','pagado', 'medio_pago'
			);
		$aCampos['Facturas:Factura'] = array(
				'id_factura','referencia','referencia_externa','base_imponible','fecha','estado','factura_abono','id_asiento', 'notas',
				'id_serie','id_cliente','id_proveedor'
				);
		$aCampos['Series_facturacion:Serie'] = array(
				'id_serie','nombre','contador','ventas','contabilizable'
				);
		$aCampos['Empresas:Empresa'] = array(
				'id_empresa','razon_social'
				);
		$aCampos['Clientes:Cliente'] = array(
				'id_cliente','razon_social', 'nombre', 'apellidos'
				);
		$aCampos['Clientes_empresas:ClienteEmp'] = array(
				'id_empresa','riesgo','cc_cliente','cc_ventas','cc_efectos','cc_banco','cc_retenciones',
				'cc_descuento_financiero','cc_descuento_comercial','cc_gastos'
				);
		if (1 OR !$bVenta) {
			$aCampos['Proveedores:Proveedor'] = array(
					'id_proveedor','razon_social', 'nombre', 'apellidos' 
					);
			$aCampos['Proveedores_empresas:ProveedorEmp'] = array(
					'id_empresa','cc_proveedor','cc_compras','cc_efectos','cc_banco','cc_retenciones',
					'cc_descuento_financiero','cc_descuento_comercial','cc_gastos'
					);
		}
		$aCampos['Bancos:Banco'] = array(
			'id_banco', 'nombre','persona_contacto','cargo_contacto','email','telefono','fax','cuenta_contable'
			);

		$aActions['monto_pagado'] = array('method' => 'updateAmmount');
		$aActions['monto'] = array('method' => 'updateAmmount');
		$aActions['fecha_vencimiento'] = array('method' => 'updateExpiration');
		$aActions['fecha_abono'] = array('method' => 'setDate');
		$aActions['id_banco'] = array('method' => 'updateBank');


		return parent::dbItemMultiEntity($App_Name,$dataconn,$tabla,$aCampos,$aData,$aActions);
	}

	function init() {
		$retval = parent::init();
		if ($retval) {
			debug("Llamado a init ... ");
			if (is_a($this->_oEfectosParciales,'DraftDetails'))
				$retval = $this->_oEfectosParciales->setMainDraft($this);
			else $retval = true;
		}
		return $retval;
	}

	function cerrar() {
		debug("Llamando a cerrar ... ");
		$this->_acList = NULL;
		return parent::cerrar();
	}

	/** Metodos Sobre-Escritos **/
	function dbFill($id) {
		$retval = parent::dbFill(array('id_efecto' => $id));
		return $retval;
	}

	function postFill() {
		$pagado = $this->getAttribute('monto_pagado');
		if (!is_numeric($pagado)) $pagado = 0;
		$monto = $this->getAmmount();
		if ($monto < 0) {
			$this->debug("monto negativo: $monto ",'postFill');
			$pago_cobro = $this->getAttribute('pago_cobro');
			$this->setAttribute('pago_cobro',!((int)$pago_cobro));
			$monto *= -1;
			$this->_setAttribute('monto',$monto);
			if ($pagado < 0) {
				$pagado *= -1;
				$oDb = $this->getDb();
				$oDb->tb_update('Efectos',array('id_efecto' => $this->getId(), 'monto_pagado' => $pagado));
				$this->_setAttribute('monto_pagado',$pagado);
			}
		}
		$this->_setVar('monto_pendiente',($monto-$pagado));

		$this->_checkPartials();

		// Rellenando las cuentas contables, por entidad 
		$aProv = $this->getData('Proveedor');
		if (!$aProv) {
			$aCli = $this->getData('Cliente');
			$aUpt = $this->getData('ClienteEmp');
			$upt = 'Cliente';
		} else {
			$aUpt = $this->getData('ProveedorEmp');
			$upt = 'Proveedor';
		}
		if (!empty($upt)) 
			if (is_array($aUpt) AND sizeof($aUpt)) 
				foreach ($aUpt as $campo => $valor) 
					$this->setAttribute($campo,$valor,$upt);

		$oDb = $this->getDb();
		$rs = $oDb->query('SELECT * FROM Efectos_asientos WHERE id_efecto = '.$this->getId());
		if ($oDb->num_rows($rs)) {
			while ($aAs = $oDb->fetch_assoc($rs)) {
				$this->_acList[$aAs['id_asiento']] = $aAs;
			}
		}

		// Regularizando las fechas:
		$fecha = $this->getDate('vencimiento');
		if (!empty($fecha)) $this->_setAttribute('fecha_vencimiento',wol_db::formatear_fecha($fecha,false));
		$fecha = $this->getDate('abono');
		if (!empty($fecha)) $this->_setAttribute('fecha_abono',wol_db::formatear_fecha($fecha,false));
		$fecha = $this->getDate('devolucion');
		if (!empty($fecha)) $this->_setAttribute('fecha_devolucion',wol_db::formatear_fecha($fecha,false));


		return true;
	}

	function delete() {
		$oParciales = &$this->getPartialDrafts();
		$bBorrar = true;
		for ($idx = $oParciales->firstItem(); isset($idx); $idx = $oParciales->nextItem()) {
			$oItem = &$oParciales->getItem();
			$importe = $oItem->getAmmount();
			$id_abono = $oItem->getAttribute('id_factura_abono');
			if (!$oItem->isDeleted() AND (!empty($importe) OR (is_numeric($id_abono) AND !empty($id_abono))) ) {
				$bBorrar = false;
				break;
			}
		}
		$this->debug("bBorrar = ".$bBorrar,'delete');
		if ($bBorrar) {
			$retval = parent::delete();
		} else {
			debug("Error: No se puede borrar efecto, con pagos parciales.");
			$retval = false;
		}
		return $retval;
	}

	function preDump() {
		$aFra = $this->getData('Factura');
		if (!is_numeric($aFra['id_factura'])) {
			debug("Error: No se puede tener un efecto sin factura");
			return false;
		}
		$aSerie = $this->getData('Serie');
		if (!is_array($aSerie) OR !sizeof($aSerie)) {
			if (!is_numeric($aFra['id_serie'])) {
				debug("Error: No se puede tener un efecto sin que su factura pertenezca a una serie de facturacion determinada");
				return false;
			}
			$this->dbFillEntity(array('id_serie' => $aFra['id_serie']),'Serie');
			$aSerie = $this->getData('Serie');
			if (!is_array($aSerie) OR !sizeof($aSerie)) {
				debug("Error: No se puede tener un efecto sin que su factura pertenezca a una serie de facturacion determinada (no se encuentra)");
				return false;
			}
		}
		if (!(int)$aSerie['contabilizable']) {
			$this->dontAccount();
		}
		if (!is_numeric($aFra['id_cliente']) AND !is_numeric($aFra['id_proveedor'])) {
			$this->dbFillEntity(array('id_factura' => $aFra['id_factura']),'Factura');
			$aFra = $this->getData('Factura');
		}

		if (!empty($aFra['id_proveedor'])) {
			$aProv = $this->getData('Proveedor');
			if (!$aProv) {
				$this->dbFillEntity(array('id_proveedor' => $aFra['id_proveedor']),'Proveedor');
				$this->dbFillEntity(array('id_proveedor' => $aFra['id_proveedor']),'ProveedorEmp');
				$aUpt = $this->getData('ProveedorEmp');
				if ($aUpt) $upt = 'Proveedor';
			}
		} else {
			// Rellenando las cuentas contables, por entidad 
			$aCli = $this->getData('Cliente');
			if (!$aCli) {
				$this->dbFillEntity(array('id_cliente' => $aFra['id_cliente']),'Cliente');
				$this->dbFillEntity(array('id_cliente' => $aFra['id_cliente']),'ClienteEmp');
				$aUpt = $this->getData('ClienteEmp');
				if ($aUpt) $upt = 'Cliente';
			}
		}

		if (!empty($upt)) 
			if (is_array($aUpt) AND sizeof($aUpt)) 
				foreach ($aUpt as $campo => $valor) 
					$this->setAttribute($campo,$valor,$upt);

		$monto = $this->getAmmount('total');
		if ($monto < 0) {
			$aC = $this->getData('Cliente');
			if (!$aC) {
				// Si es de compra, y de importe negativo, es uno de cobro
				$this->_setAttribute('pago_cobro',1);
			} else {
				// Si es de venta, y de importe negativo, es uno de pago
				$this->_setAttribute('pago_cobro',0);
			}
			$this->_setAttribute('monto',abs($monto));
		}

		$monto_pagado = $this->getAttribute('monto_pagado');
		$this->debug('Monto pagado: '.$monto_pagado,'preDump');
		$this->_setVar('_predb_monto_pagado',$monto_pagado);
		$this->_cleanAttribute('monto_pagado',NULL);

		$concepto = $this->getAttribute('concepto');
		if (empty($concepto)) {
			$ref_ext = $this->getAttribute('referencia_externa','Factura');
			$ref = $this->getAttribute('referencia','Factura');
			$concepto = 'Su Fra '.$ref.( (!empty($ref_ext)) ? ' ['.$ref_ext.']' : '');
			$this->_setAttribute('concepto',$concepto);
		}

		return true;
	}

	function Dump($tipo = NULL) {
		if (is_a($this->_oEfectosParciales,'DraftDetails')) $retval = $this->_oEfectosParciales->Dump($tipo);
		else $retval = true;

		if ($retval) $retval = parent::Dump($tipo);
		return $retval;
	}

	function postDump($retdump) {
		if ($this->checkFlag($this->ST_NEW | $this->ST_EDIT | $this->ST_DEL)) {
			if (!$this->checkFlag($this->ST_DEL)) {
				$monto = $this->_getVar('monto_apagar');
				$this->debug("Abonando ($monto) checkFlag(NEW): ".$this->checkFlag($this->ST_NEW).' AmmountChange('.$this->bAmmountChange.
									') En '.$this->getDate('abono'),'postDump');
				if (is_numeric($monto) ) {
					$id = $this->getId();
					$monto_pagado = $this->_getVar('_predb_monto_pagado');
					$this->_unsetVar('_predb_monto_pagado');
					$monto_total = $this->getAttribute('monto');
					$cons = 'UPDATE Efectos SET monto_pagado = monto_pagado + '.$monto.' WHERE (id_efecto = '.$id.' )';
					$db = $this->getDb();
					$db->query($cons);
					$total_asiento = $monto;
				} elseif ($this->bAccountAsNew) {
					// Si se contabiliza como nuevo, asentamos el total pagado.
					// debug("Abonando como nuevo!!! ");
					$total_pagado = $this->_getVar('_predb_monto_pagado');
					$this->_unsetVar('_predb_monto_pagado');
					$monto = $total_pagado;
					$monto_pagado = 0;
					$fecha = $this->getDate('now');

					// Asentamos el impororte pagado, menos el que se haya pagado en parciales de un asiento distinto a este.
					$total_pagado -= $this->getAmmount('accounted');
					$total_asiento = $total_pagado;
				}
				$this->_setAttribute('monto_pagado',$monto+$monto_pagado);

				if ($this->bAmmountChange OR $this->checkFlag($this->ST_NEW) OR $this->bAccountAsNew ) {
					$this->debug("Contabilizando ($monto) - ida: $ida En: $fecha",'postDump');
					if ($this->checkFlag($this->ST_NEW)) {
						$tipo = 'new';
						$fecha = $this->getDate('now');
						if (is_numeric($monto)) {
							// Si a la par se paga... registramos ya el reconocimiento
							$new_total = $this->getAmmount('total');
							$idn = $this->newAccountEntry(NULL,NULL,$tipo,$fecha,$new_total);
							if (is_numeric($idn) ) $retval = $this->Account($idn,$this,'new');
						
							$fecha = $this->getDate('abono');
							$tipo = 'cargo';
						} elseif (!$total_asiento) $total_asiento = $this->getAmmount('total');
					} elseif ($this->checkFlag($this->ST_DEL)) {
						$tipo = 'del';
						$fecha = $this->getDate('now');
						if (!$total_asiento) $total_asiento = $this->getAmmount('total');
					} else {
						// Si no existen asientos de este efecto en Contabilidad, primero reconocer el adeudo
						if ((!is_array($this->_acList) OR !sizeof($this->_acList)) ) {
							// debug("Antes de asentar el cargo... reconocemos el adeudo. ");
							$tipo = 'new';
							$fecha = $this->getAttribute('fecha','Factura');
							$new_total = $this->getAmmount('total');
							$idn = $this->newAccountEntry(NULL,NULL,$tipo,$fecha,$new_total);
							if (is_numeric($idn) ) $this->Account($idn,$this,'new');
							$idn = NULL;
						}

						// Procedemos a asentar el cargo o devolucion
						if ((int)$this->getAttribute('devuelto')) {
							$fecha = $this->getDate('devolucion');
							$tipo = 'del';
							if ($total_asiento < 0) {
								$total_asiento *= -1;
							}
						} else {
							$fecha = $this->getDate('abono');
							if (empty($fecha)) $fecha = $this->getDate('now');
							$tipo = 'cargo';
						}
					}

					if (!empty($total_asiento)) $idn = $this->newAccountEntry(NULL,NULL,$tipo,$fecha,$total_asiento);
					else {
						debug("_no_ asentamos el cargo/devolucion efecto de la factura: ".$this->getAttribute('referencia','Factura')." por tener importe 0");
					}

					if (is_numeric($idn) ) {
						// El monto pagado, es el que usa el metodo Account para saber el importe a volcar en la contabilidad.
						// Este importe, no necesariamente es el total del efecto, sino que pueden ser pagos de inferior importe
						$this->debug("Contabilizando de pleno el asiento ... ",'postDump');
						$retval = $this->Account($idn,$this,'new');
					}
				}

			} else {
				if (!$this->checkFlag($this->ST_NEW)) {
					// debug("Borrando el efecto, con su asiento y tal");
					$fecha = $this->getDate('now');
					$tipo = 'del';
					// Devolvemos el importe pagado.
					$importe = $this->getAmmount('paid');
					if (!empty($importe)) {
						$idn = &$this->newAccountEntry(NULL,NULL,$tipo,$fecha,$importe);
						$retval = $this->Account($idn,$this,'new');
					}
					$tipo = 'limpio';
					$importe = $this->getAmmount('total');
					if (!empty($importe)) {
						$idn = &$this->newAccountEntry(NULL,NULL,$tipo,$fecha,$importe);
						$retval = $this->Account($idn,$this,'new');
					}
				}

				$mnt = $this->_getVar('_predb_monto_pagado');
				$this->_unsetVar('_predb_monto_pagado');
				$this->_setAttribute('monto_pagado',$mnt);
			}

			$this->dumpAccountEntries();
		} else {
			$mnt = $this->_getVar('_predb_monto_pagado');
			$this->_unsetVar('_predb_monto_pagado');
			$this->_setAttribute('monto_pagado',$mnt);
		}

		return true;
	}

	/** Metodos de Control y Flujo **/

	function dumpAccountEntries() {
		$this->debug("Volcando .. ".sizeof($this->_acList),'dumpAccountEntries');
		if (is_array($this->_acList) AND sizeof($this->_acList) AND $this->isAccountable()) {
			$oDb = $this->getDb();
			$bDeleted = false;
			foreach ($this->_acList as $id => $aAsiento) {
				if (strcasecmp($id,'new')) {
					if ($this->checkFlag($this->ST_DEL)) {
						if ($bDeleted) continue;
						$bDeleted = true;
						$oDb->tb_delete('Efectos_asientos',array('id_efecto' => $this->getId()));
					} else {
						// debug("Volcando id asiento $id ");
						$oAsiento = &$this->_acList[$id]['instance'];
						if (is_a($oAsiento,'AccountEntry')) {
							$oAsiento->dbDump();
							$aTmp['id_asiento'] = $oAsiento->getId();
						} elseif(!is_numeric($aAsiento['id_asiento'])) continue;
						else $aTmp['id_asiento'] = $aAsiento['id_asiento'];

						$aTmp['id_efecto'] = $this->getId();
						$aTmp['operacion'] = $aAsiento['operacion'];
						$aTmp['fecha'] = $aAsiento['fecha'];
						$aTmp['importe'] = $aAsiento['importe'];
						// debug("_no_ se vuelcan modificaciones en asientos... se corrigen. ");
						// $oDb->tb_update('Efectos_asientos',$aTmp);
					}
				}
			}
			if (is_array($this->_acList['new']) AND sizeof($this->_acList['new'])) {
				foreach ($this->_acList['new'] as $idx => $aAsiento) {
					$oAsiento = &$this->_acList['new'][$idx]['instance'];
					$this->debug("Nueva $idx == ".get_class($this->_acList['new'][$idx]['instance']),'dumpAccountEntries');
					if (!is_a($oAsiento,'AccountEntry')) {
						$this->debug('<b>_no_ se ha volcado</b> nuevo asiento idx ('.$idx.','.$aAsiento['operacion'].','.$aAsiento['fecha'].','.$aAsiento['importe'].
										') perteneciente al id '.$this->getId().' por no existir la instancia.','dumpAccountEntries');
						continue;
					}
					$aCfg = $this->getAccountingConf();
					if ((int)$aCfg['diario'] AND $aCfg['canal']) {
						$oAsiento->addDiary($aCfg['diario'],$aCfg['canal']);
					}
					$idfraa = $oAsiento->getInvoice();
					if (!is_numeric($idfraa) OR empty($idfraa)) {
						$idfra = $this->getAttribute('id_factura','Factura');
						if (is_numeric($idfra)) $oAsiento->setInvoice($idfra);
						$ref = $this->getAttribute('referencia','Factura');
						if (is_numeric($ref)) $oAsiento->setDocument($ref);
					}

					$nombre = $oAsiento->getName();
					if (empty($nombre)) {
						$nombre = 'Efecto Gestion '.$ref;
						$oAsiento->setName($nombre);
					}

					$desc = $oAsiento->getDescription();
					if (empty($desc)) {
						$desc = $this->getAttribute('notas','Factura');
						$oAsiento->setDescription($desc);
					}

					$fecha = $oAsiento->getDate();
					if (empty($fecha)) $oAsiento->setDate($this->getDate('now'));

					// debug("Volcando nuevo Asiento ... ");
					$oAsiento->dbDump();
					$ida = $oAsiento->getId();
					$this->_acList[$ida]['instance'] = &$oAsiento;
					$this->_acList['new'][$idx] = NULL;

					if (!$this->checkFlag($this->ST_DEL)) {
						debug("Efectos_asientos .. ");
						$aTmp['id_efecto'] = $this->getId();
						$aTmp['id_asiento'] = $ida;
						$aTmp['operacion'] = $aAsiento['operacion'];
						$aTmp['fecha'] = $aAsiento['fecha'];
						$aTmp['importe'] = $aAsiento['importe'];
						print_r($aTmp);
						$oDb->tb_replace('Efectos_asientos',$aTmp);
					}
				}
			}
		}
		return true;
	}

	function dontAccount($val = true) {
		if (!isset($val)) $val = true;
		$this->bAccount = (bool)!$val;
		return $this->bAccount;
	}

	function isAccountable() {
		return $this->bAccount;
	}

	function isPaid() {
		$total = $this->getAttribute('monto');
		$pagado = $this->getAttribute('monto_pagado');
		if ($pagado < $total) return false;
		else return true;
	}

	function Pay($aMedio = NULL) {
		// Primero miramos cuanto se ha pagado por parciales.
		$pagosparciales = 0;
		$oParciales = &$this->getPartialDrafts();
		if ($oParciales)
			for ($idx = $oParciales->firstItem(); isset($idx); $idx = $oParciales->nextItem()) {
				$oItem = &$oParciales->getItem();
				$pagosparciales += $oItem->getAmmount('paid');
			}
		$pendiente = abs($this->getAmmount('total')) - $pagosparciales;
		$this->debug("Pendiente: ".$pendiente.' ya patado: '.$pagosparciales.' Que suma: '.($pendiente+$pagosparciales),'Pay');

		$this->update(array('monto_pagado' => $pendiente));
		// Para que vuelque a iconta
		$this->bAmmountChange = true;

		if (is_array($aMedio) AND sizeof($aMedio)) 
			foreach ($aMedio as $fld => $val) {
				switch ($fld) {
					case 'id_banco':
						$this->update(array('id_banco' => $val));
				}
			}

		return true;
	}

	function setNotPaid($bMarkBack = true) {
		if (!isset($bMarkBack)) $bMarkBack = true;
		// Primero miramos cuanto se ha pagado por parciales.
		$pagosparciales = 0;
		$oParciales = &$this->getPartialDrafts();
		if ($oParciales)
			for ($idx = $oParciales->firstItem(); isset($idx); $idx = $oParciales->nextItem()) {
				$oItem = &$oParciales->getItem();
				$pagosparciales += $oItem->getAmmount('paid');
			}

		$devolucion = abs($this->getAmmount()) - $pagosparciales;
		if ($devolucion > 0) {
			if (!$bMarkBack) $dev = $this->getAttribute('devuelto');
			$this->update(array('monto_pagado' => ($devolucion * -1) ));
			// Para que vuelque a iconta
			$this->bAmmountChange = true;
			if (!$bMarkBack) {
				$this->setAttribute('devuelto',$dev);
			}
		} else {
			debug("Warning: No se puede devolver efecto al tner pagos parciales por el total del efecto. ");
		}

		return false;
	}


	function _checkPartials() {
		$retval = false;
		if (!is_a($this->_oEfectosParciales,'DrafDetail')) {
			$this->_oEfectosParciales = new DraftDetails($this,NULL);
			$id = $this->getAttribute('id_efecto');
			$retval = $this->_oEfectosParciales->setMainDraft($this);
			if (is_numeric($id)) 
				$this->_oEfectosParciales->dbFill(array('id_efecto' => $id));
		} else $retval = true;
		// debug("_checkPartials($retval) - EdFlag: ".$this->checkFlag($this->ST_EDIT));
		return $retval;
	}

	function &getPartialDrafts() {
		return $this->_oEfectosParciales;
	}

	function newPartialDraft($aData) {
		debug("Draft::newPartialDraft()");

		if (!is_array($aData) OR !sizeof($aData)) return false;
		if (!$this->_checkPartials()) return false;

		print_r($aData);

		return $retval;
	}

	function setAccounting($dbdata,$dbconf,$id_ejercicio,$diario = NULL,$canal = NULL) {
		$this->debug("data: $dbdata cfg: $dbconf Ej: $id_ejercicio ",'setAccounting');
		if (empty($dbdata) AND empty($dbconf)) return false;

		$retval = false;
		if ($dbdata == $this->_aConta['dbdata'] AND $dbconf == $this->_aConta['dbconf']) $retval = true;
		else {
			$oApp = &$this->getApp();
			$oDb = $oApp->get_db($dbdata);
			$oDbConf = $oApp->get_db($dbconf);
			if (is_a($oDb,'wol_db') AND is_a($oDbConf,'wol_db') AND $oDb->conectado() AND $oDbConf->conectado()) {
				$this->_aConta['dbdata'] = $dbdata;
				$this->_aConta['dbconf'] = $dbconf;
				$this->_aConta['id_ejercicio'] = $id_ejercicio;
				if (is_numeric($diario)) $this->_aConta['diario'] = $diario;
				if (is_numeric($canal)) $this->_aConta['canal'] = $canal;
				$retval = true;
			}
		}
		if (!$retval) {
			$this->_aConta['dbdata'] = NULL;
			$this->_aConta['dbconf'] = NULL;
			$this->dontAccount(true);
		}
		return $retval;
	}

	function getAccountingConf() {
		if (empty($this->_aConta['dbdata']) OR empty($this->_aConta['dbconf'])) return NULL;
		return $this->_aConta;
	}

	function &newAccountEntry($id = NULL, $bInstance = false, $tipoa = NULL, $fecha = NULL, $importe = NULL) {
		$aCfg = $this->getAccountingConf();
		$this->debug(array('cfg de Accounting es: '=>$aCfg),'newAccountEntry');
		if (!is_array($aCfg)) return NULL;
		$id_ej = $aCfg['id_ejercicio'];
		if (!is_numeric($id_ej)) return NULL;

		$aProv = $this->getData('Proveedor');
		if (!$aProv) {
			$tipo = ICEntry_MODE_SALE;
		} else {
			$tipo = ICEntry_MODE_SALE;
		}

		switch ($tipoa) {
			case 'new':
				$tipo_asiento = 'reconocimiento';
				break;

			case 'del':
				$tipo_asiento = 'devolucion';
				break;

			case 'limpio':
				if ($this->checkFlag($this->ST_DEL)) $tipo_asiento = 'eliminacion';
				else return NULL;
				break;

			default:
				$tipo_asiento = 'cargo';
				break;
		}
		$this->debug($id.' Tipo: '.$tipo_asiento.' En: '.$fecha.' Con: '.$importe,'newAccountEntry');

		$oA = new AccountEntry($this->getAppName(),$aCfg['dbdata'],$aCfg['dbconf'],$tipo,$id_ej);
		if (!empty($fecha) AND strcasecmp(wol_db::formatear_fecha($fecha,false),'null')) $oA->setDate($fecha);

		if (is_numeric($id) AND !$oA->dbFill($id)) $idn = NULL;
		elseif (is_numeric($id)) {
			$this->_acList[$id]['instance'] = &$oA;
			$this->_acList[$id]['operacion'] = $tipo_asiento;
			$this->_acList[$id]['fecha'] = $fecha;
			$this->_acList[$id]['importe'] = $importe;
			if ($bInstance) $idn = &$this->_acList[$id]['instance'];
			else $idn = $id;
		} else {
			$idn = sizeof($this->_acList['new']);
			$this->_acList['new'][$idn] = array('instance' => &$oA);
			$this->_acList['new'][$idn]['operacion'] = $tipo_asiento;
			$this->_acList['new'][$idn]['fecha'] = $fecha;
			$this->_acList['new'][$idn]['importe'] = $importe;
			if ($bInstance) $idn = &$this->_acList['new'][$idn]['instance'];
		}

		return $idn;
	}

	function &getAccountEntry($id = NULL,$tipo = NULL) {
		if (!is_numeric($id)) return NULL;
		if (!strcasecmp($tipo,'new'))  {
			if (!is_a($this->_acList['new'][$id]['instance'],'AccountEntry')) return $this->newAccountEntry($id,true);
			return $this->_acList['new'][$id]['instance'];
		} else  {
			if (!is_a($this->_acList[$id]['instance'],'AccountEntry')) return $this->newAccountEntry($id,true);
			return $this->_acList[$id]['instance'];
		}
	}

	function findAccountEntry($fecha = NULL) {
		$this->debug('de Fecha '.$fecha,'findAccountEntry');
		return NULL;
	}

	function setAccountEntry($id = 'new',&$oAsiento) {
		if (!is_a($oAsiento,'AccountEntry')) return false;
		if (!is_numeric($id)) $id = 'new';
		if (is_numeric($id)) {
			$this->_acList[$id]['instance'] = &$oAsiento;
		} else {
			if (!is_array($this->_acList['new'])) $this->_acList['new'] = array();
			// array_push($this->_acList['new'],&$oAsiento);
			$this->_acList['new'][] = array('instance' => &$oAsiento);
		}
		return true;
	}

	function Account($ida,&$oE,$tipo = NULL) {

		switch ($tipo) {
			case 'new':
				$oAsiento = &$this->getAccountEntry($ida,'new');
				$accion = $this->_acList['new'][$ida]['operacion'];
				$fecha = $this->_acList['new'][$ida]['fecha'];
				$importe = $this->_acList['new'][$ida]['importe'];
				break;

			default:
				$oAsiento = &$this->getAccountEntry($ida);
				$accion = $this->_acList[$ida]['operacion'];
				$fecha = $this->_acList[$ida]['fecha'];
				$importe = $this->_acList[$ida]['importe'];
				break;
		}
		$this->debug("Comprobamos($ida) clase de oAsiento .. $tipo - ".get_class($oAsiento),'Account');

		if (!is_a($oAsiento,'AccountEntry')) return false;
		$this->debug("Comprobamos si hay que contabilizarlo .. Accountable ? ".$oE->isAccountable(),'Account');
		if (!$oE->isAccountable()) return false;

		if ($oE->checkFlag($oE->ST_NEW) AND $oE->checkFlag($oE->ST_DEL)) {
			debug("<b>Borrar</b> y nuevo a la vez... que cutre no?");
			return false;
		}
		if ($importe == 0) return false;

		$this->debug("<b>Asentando</b> operacion $accion en $fecha con $importe ",'Account');

		$aQuien = $oE->getData('Proveedor');
		if (!$aQuien) {
			$aQuien = $oE->getData('Cliente');

			$bVenta = true;
			$acLadoEfecto = ICEntry_MOVE_HAVE;
			$acLadoAbono = ICEntry_MOVE_MUST;
			$ccEntidad = $aQuien['cc_cliente'];
			if (empty($ccEntidad)) $ccEntidad = $oAsiento->getCfg('cc_clientes');
			$ccEfecto = $aQuien['cc_efectos'];
			$ccGnrl = $oAsiento->getCfg('cc_efectos_cliente');
		} else {
			$bVenta = false;
			$acLadoEfecto = ICEntry_MOVE_MUST;
			$acLadoAbono = ICEntry_MOVE_HAVE;
			$ccEntidad = $aQuien['cc_proveedor'];
			if (empty($ccEntidad)) $ccEntidad = $oAsiento->getCfg('cc_proveedores');
			$ccEfecto = $aQuien['cc_efectos'];
			$ccGnrl = $oAsiento->getCfg('cc_efectos_proveedor');
		}
		if (empty($ccGnrl)) {
			debug("Error: No se encuentra la configuracion de cuentas contables de efectos (configure iConta)");
			return false;
		}

		if (!empty($ccEfecto)) {
			$aTmp = $oAsiento->filterAccount($ccEfecto,NULL,ICEntry_FILTER_ARRAY | ICEntry_FILTER_EXTENDED);
			$aTmp2 = $oAsiento->filterAccount($ccGnrl,NULL,ICEntry_FILTER_ARRAY | ICEntry_FILTER_EXTENDED);
			// if ($aTmp[0] != $aTmp2[0]) $ccEfecto = $ccGnrl;
		} else {
			$ccEfecto = $ccGnrl;
		}
		$ccGnrl = NULL;
		// Si no existe la cuenta, la creamos
		if (!empty($ccEfecto)) $oAsiento->dbFetchAccount($ccEfecto,true);

		$aBanco = $oE->getData('Banco');
		if (is_array($aBanco) AND !empty($aBanco['id_banco'])) {
			$ccAbono = $aBanco['cuenta_contable'];
			$ccGnrl = $oAsiento->getCfg('cc_bancos');
		} else {
			$ccGnrl = $oAsiento->getCfg('cc_caja');
		}
		if (empty($ccGnrl)) {
			debug("Error: No se encuentra la configuracion de cuentas contables de caja y/o bancos (configure iConta)");
			return false;
		}

		if (!empty($ccAbono)) {
			$aTmp  = $oAsiento->filterAccount($ccAbono,NULL,ICEntry_FILTER_ARRAY | ICEntry_FILTER_EXTENDED);
			$aTmp2 = $oAsiento->filterAccount($ccGnrl,NULL,ICEntry_FILTER_ARRAY | ICEntry_FILTER_EXTENDED);
			// if ($aTmp[0] != $aTmp2[0]) $ccAbono = $ccGnrl;
		} else {
			$ccAbono = $ccGnrl;
		}
		// Si no existe la cuenta, la creamos
		if (!empty($ccAbono)) $oAsiento->dbFetchAccount($ccAbono,true);

		$this->debug("Comprobamos Tipo de Efecto (".get_class($oE).") : IDAbono (".$oE->getAttribute('id_factura_abono').")",'Account');

		$es_abono = (int)$oE->getAttribute('factura_abono','Factura');
		if (is_a($oE,'DraftDetailItem')) {
			$id_fra_abono = $oE->getAttribute('id_factura_abono');
			// if (!empty($id_fra_abono)) $es_abono = $oE->getAttribute('factura_abono','Abono');
		} 
		$es_devolucion = (int)$oE->getAttribute('devuelto');

		$pago_cobro = (int)$oE->getPaymentType();
		$bInvertido = false;
		if ( ($bVenta AND !$pago_cobro) OR (!$bVenta AND $pago_cobro) ) {
			debug("_invertimos_ asiento Venta($bVenta) PagoCobro($pago_cobro)");
			$tmpLado = $acLadoEfecto;
			$acLadoEfecto = $acLadoAbono;
			$acLadoAbono = $tmpLado;
			$bInvertido = true;
		}

		switch ($accion) {
			case 'reconocimiento' :
				// Reconocimiento de deuda:
				if (($oE->checkFlag($oE->ST_NEW) OR $oE->bAccountAsNew) AND !empty($ccEntidad) ) {
					debug("Asentando en el asiento ".$oAsiento->getId()." El reconocimiento de deuda. ");
					$ref_ext = $oE->getAttribute('referencia_externa','Factura');
					$concepto = 'Reconocimiento Adeudo Fra'.(($es_abono) ? 'de Abono ' : ' ').
										$oE->getAttribute('referencia','Factura')." (".$oE->getAttribute('fecha','Factura').')'.
										( (!empty($ref_ext)) ? ' ['.$ref_ext.']' : '');
					$monto = abs($oE->getAmmount('total'));
					$fecha = $oE->getAttribute('fecha','Factura');

					debug($concepto);
					debug((($acLadoEfecto & ICEntry_MOVE_MUST) ? 'Cargamos ' : 'Abonamos ').' a la '.$ccEntidad.' un importe de '.$monto);
					debug((($acLadoAbono & ICEntry_MOVE_MUST) ? 'Cargamos ' : 'Abonamos ').' a la '.$ccEfecto.' un importe de '.$monto);

					// El lado del efecto, es el que se usa para liquidar/saldar la cuenta.
					$idx = $oAsiento->addMove($ccEntidad,$monto,$acLadoEfecto);
					$oAsiento->setConcept($idx,$concepto);
					$oAsiento->setMoveDate($idx,$fecha);

					$idx = NULL;
					$idx = $oAsiento->addMove($ccEfecto,$monto,$acLadoAbono);
					$oAsiento->setConcept($idx,$concepto);
					$oAsiento->setMoveDate($idx,$fecha);
				}
				break;

			case 'cargo':
				$this->debug("Paid : $importe ID: ".$oAsiento->getId(),'Account');

				if (!empty($importe)) {
					debug("Asentando: Hemos cambiao monto.. Fecha: ".$fecha.' id_abono: '.$id_fra_abono);

					/** **
					if ( ($bVenta AND !$pago_cobro) OR (!$bVenta AND $pago_cobro) ) {
						$concepto = 'Devolucion ';
					} else {
						$concepto = '';
					}
					/** **/

					if (is_numeric($id_fra_abono)) {
						$ccAbono = $ccEntidad;
						$concepto .= 'Saldo por Abono en Fra '.$oE->getAttribute('referencia','Abono').' ('.$oE->getAttribute('fecha','Abono').')'.' ==> ';
					}

					$ref_ext = $oE->getAttribute('referencia_externa','Factura');
					$concepto .= 'Adeudo Fra '.(($es_abono || $bInvertido) ? 'de Abono ' : '').
									$oE->getAttribute('referencia','Factura')." (".$oE->getAttribute('fecha','Factura').')'.
									( (!empty($ref_ext)) ? ' ['.$ref_ext.']' : '');

					debug($concepto);
					debug((($acLadoEfecto & ICEntry_MOVE_MUST) ? 'Cargamos ' : 'Abonamos ').' a la '.$ccEfecto.' un importe de '.$importe);
					debug((($acLadoAbono & ICEntry_MOVE_MUST) ? 'Cargamos ' : 'Abonamos ').' a la '.$ccAbono.' un importe de '.$importe);

					$monto = abs($monto);
					$idx = $oAsiento->addMove($ccEfecto,$importe,$acLadoEfecto);
					$oAsiento->setConcept($idx,$concepto);
					$oAsiento->setMoveDate($idx,$fecha);
					$idx = NULL;
					$idx = $oAsiento->addMove($ccAbono,$importe,$acLadoAbono);
					$oAsiento->setConcept($idx,$concepto);
					$oAsiento->setMoveDate($idx,$fecha);
				}
				break;

			case 'devolucion':
				if ( !empty($ccEntidad) ) {
					debug("<b>Devolvemos</b> Efecto ... ".get_class($oE));
					if ($oE->checkFlag($oE->ST_DEL) ) {
						// Ya invierto lados por ser una devolucion (ccEfecto al lado del Abono)

						debug("_ya_ Invirtiendo por ser Delete ");
						// $tmpLado = $acLadoEfecto;
						// $acLadoEfecto = $acLadoAbono;
						// $acLadoAbono = $tmpLado;
						$concepto = 'Borrado ';
					} else {
						$concepto = 'Devolucion ';
					}

					$ref_ext = $oE->getAttribute('referencia_externa','Factura');
					if (is_numeric($id_fra_abono)) {
						$concepto .= 'Saldo por Abono en Fra '.$oE->getAttribute('referencia','Abono').' ('.$oE->getAttribute('fecha','Abono').')'.' ==> ';
						$ccAbono = $ccEntidad;
					}
					$concepto .= 'Adeudo Fra '.(($es_abono || $bInvertido) ? 'de Abono ' : '').
										$oE->getAttribute('referencia','Factura')." (".$oE->getAttribute('fecha','Factura').')'.
										( (!empty($ref_ext)) ? ' ['.$ref_ext.']' : '');
					// $monto = abs($oE->getAmmount('total'));
					// $fecha = date('Y-m-d H:i');
					debug("monto de $importe .. ");

					debug($concepto);
					debug((($acLadoAbono & ICEntry_MOVE_MUST) ? 'Cargamos ' : 'Abonamos ').' a la '.$ccEfecto.' un importe de '.$importe);
					debug((($acLadoEfecto & ICEntry_MOVE_MUST) ? 'Cargamos ' : 'Abonamos ').' a la '.$ccAbono.' un importe de '.$importe);

					// El lado del efecto, es el que se usa para liquidar/saldar la cuenta. Cuando se borra, se hace a la inversa. 
					$idx = $oAsiento->addMove($ccEfecto,$importe,$acLadoAbono);
					$oAsiento->setConcept($idx,$concepto);
					$oAsiento->setMoveDate($idx,$fecha);
					$idx = NULL;
					$idx = $oAsiento->addMove($ccAbono,$importe,$acLadoEfecto);
					$oAsiento->setConcept($idx,$concepto);
					$oAsiento->setMoveDate($idx,$fecha);
				}
				break;

			case 'eliminacion':
				if ( !empty($ccEntidad) ) {
					debug("<b>Borramos</b> Efecto ... ");
					if ($oE->checkFlag($oE->ST_DEL) ) {
						debug("_ya_ Invirtiendo por ser Eliminacion ");
						// $tmpLado = $acLadoEfecto;
						// $acLadoEfecto = $acLadoAbono;
						// $acLadoAbono = $tmpLado;
						$concepto = 'Eliminacion y Borrado ';
						if (is_a($oE,'Draft')) $concepto .= 'Reconocimiento ';
					} 
					$concepto .= 'Adeudo Fra '.(($es_abono || $bInvertido) ? 'de Abono ' : '').
							$oE->getAttribute('referencia','Factura')." (".$oE->getAttribute('fecha','Factura').')';
					// $monto = abs($oE->getAmmount('total'));
					// $fecha = date('Y-m-d H:i');
					debug("monto de $importe .. ");

					debug($concepto);
					debug((($acLadoAbono & ICEntry_MOVE_MUST) ? 'Cargamos ' : 'Abonamos ').' a la '.$ccEfecto.' un importe de '.$importe);
					debug((($acLadoEfecto & ICEntry_MOVE_MUST) ? 'Cargamos ' : 'Abonamos ').' a la '.$ccEntidad.' un importe de '.$importe);

					// El lado del efecto, es el que se usa para liquidar/saldar la cuenta. Cuando se borra, se hace a la inversa. 
					$idx = $oAsiento->addMove($ccEfecto,$importe,$acLadoAbono);
					$oAsiento->setConcept($idx,$concepto);
					$oAsiento->setMoveDate($idx,$fecha);
					$idx = NULL;
					$idx = $oAsiento->addMove($ccEntidad,$importe,$acLadoEfecto);
					$oAsiento->setConcept($idx,$concepto);
					$oAsiento->setMoveDate($idx,$fecha);
				}
				break;
		}

		return true;
	}

	/** Metodos de Atributos **/

	function getId() {
		return $this->getAttribute('id_efecto');
	}

	function updateAmmount($val,$fld = NULL) {
		if (!is_numeric($val)) return false;
		if (empty($fld)) $fld = 'monto_pagado';

		$retval = false;
		switch ($fld) {
			case 'monto_pagado' :
				$pendiente = $this->_getVar('monto_pendiente');
				if (!$pendiente) $pendiente = $this->getAttribute('monto');
				$pago = trim($val);
				settype($pago,'float');
				$pago = round($pago,10);
				settype($pendiente,'float');
				$pendiente = round($pendiente,10);
				// $this->debug("Almacenando ($pago) .. pendiente ($pendiente) ".($pendiente-$pago),'updateAmmount');
				if ( ($pago > $pendiente) ) {
					debug("Error: No se puede pagar mas de lo que hay pendiente");
					return false;
				}
				if ( ($pendiente-$pago) > 0) {
					$pagado = (int)$this->getAttribute('pagado');
					if ($pagado) {
						$this->_setAttribute('pagado',0);
						$this->_setAttribute('devuelto',1);
						$this->_setAttribute('fecha_abono',NULL);
						$fecha = $this->getDate('devolucion');
						if (empty($fecha)) $this->setDate($this->getDate('now'),'devolucion');
					}
				} else {
					$pagado = (int)$this->getAttribute('pagado');
					if (!$pagado) {
						$this->_setAttribute('devuelto',0);
						$this->_setAttribute('pagado',1);
						$fecha = $this->getDate('abono');
						if (empty($fecha)) $this->setDate($this->getDate('now'),'abono');
						$this->_setAttribute('fecha_devolucion',NULL);
					}
				}
				$this->debug('Pendiente de pago: '.($pendiente-$pago),'updateAmmount');
				$this->_setVar('monto_pendiente',($pendiente-$pago));
				$pagado = $this->_getVar('monto_apagar');
				$this->_setVar('monto_apagar',($pago+$pagado));
				$retval = true;
				break;

			case 'monto' :
				if ($this->checkFlag($this->ST_NEW)) 
					$this->_setAttribute($fld,$val);
				break;
		}

		return $retval;
	}

	function updateBank($val,$fld = NULL) {
		if (!is_numeric($val)) return false;
		if (empty($fld)) $fld = 'monto_pagado';

		$retval = true;

		$id_banco = $this->getAttribute('id_banco');
		if ($id_banco != $val) {
			$upt = 'Banco';
			if (!empty($val)) {
				$newBank = $this->dbFillEntity(array('id_banco' => $val),'Banco');
				$aUpt = $newBank;
			} else {
				$aUpt = $this->getData('Banco');
				if (is_array($aUpt) AND sizeof($aUpt))
					foreach ($aUpt as $campo => $valor) $aUpt[$campo] = NULL;
			}

			if (!empty($upt)) 
				if (is_array($aUpt) AND sizeof($aUpt)) {
					foreach ($aUpt as $campo => $valor) 
						$this->setAttribute($campo,$valor,$upt);
				}
		}
		$this->_setAttribute('id_banco',$val);


		return $retval;
	}


	function getAmmount($tipo = NULL) {
		// FixMe: Falta el monto 'accounted'
		if (!strcasecmp($tipo,'pending')) return ( ($this->_getVar('monto_pendiente')) ? $this->_getVar('monto_pendiente') : $this->getAttribute('monto'));
		if (!strcasecmp($tipo,'paid')) return $this->getAttribute('monto_pagado');
		if (!strcasecmp($tipo,'accounted')) {
			$retval = 0;
			$bReconocido = false;
			if (is_array($this->_acList) AND sizeof($this->_acList))
				foreach ($this->_acList as $idx => $aAE) {
					if (!strcasecmp($idx,'new')) {
						if (!$bReconocido) {
							foreach ($aAE as $newAE) {
								if ($newAE['operacion']=='reconocimiento') {
									debug("Se pretende reconocer el efecto ahora... ");
									$bReconocido = true;
								}
							}
						}
						continue;
					}
					switch ($aAE['operacion']) {
						case 'reconocimiento':
							$bReconocido = true;
							break;

						case 'cargo':
							$retval += $aAE['importe'];
							break;

						case 'devolucion':
							$retval -= $aAE['importe'];
							break;
					}
				}

			debug("Socorroco!! cantidad contabilizada cual es? ".$retval);
			return $retval;
		}
		if (empty($tipo) OR !strcasecmp($tipo,'total') ) return $this->getAttribute('monto');
	}

	function getPaymentType() {
		return (int)$this->getAttribute('pago_cobro');
	}

	function setDate($val = NULL,$fld = NULL) {

		if (empty($fld)) {
			$this->debug('setDate sin fld definido -vto por defecto-','setDate');
			$fld = 'fecha_vencimiento';
		}
		if (empty($val) OR !strcasecmp(wol_db::formatear_fecha($val,false),'null')) {
			$fecha = $this->getDate('now');
		} else $fecha = $val;
		$this->debug('('.$fecha.' , '.$fld.') val '.$val,'setDate');
		switch ($fld) {
			case 'abono':
				$fld = 'fecha_abono';
				break;

			case 'fecha_abono':
				$fld = 'fecha_abono';
				break;

			case 'devolucion':
				$fld = 'fecha_devolucion';
				break;

			case 'fecha_devolucion':
				$fld = 'fecha_devolucion';
				break;

			case 'vencimiento':
				$fld = 'fecha_vencimiento';
				break;

			case 'fecha_vencimiento':
				$fld = 'fecha_vencimiento';
				break;

			default :
				$fld = 'fecha_vencimiento';
				break;
		}

		if (!empty($fecha) AND !empty($fld)) {
			if (!is_a($oPer,'Periodo')) $oPer = &Periodo::factoryActivePeriod();
			if (is_a($oPer,'Periodo')) $aTmp = $oPer->getAssignments(array($fld => $fecha),'Efectos',false);
			$this->_setAttribute($fld,wol_db::formatear_fecha($fecha,false));
			if (is_array($aTmp) and sizeof($aTmp)) foreach ($aTmp as $fldn => $nval) $this->_setAttribute($fldn,$nval);
			return true;
		} else return false;
	}

	function getDate($tipo = NULL) {
		if (empty($tipo)) $tipo = 'vencimiento';

		switch ($tipo) {
			case 'abono':
				$fld = 'fecha_abono';
				break;

			case 'fecha_abono':
				$fld = 'fecha_abono';
				break;

			case 'devolucion':
				$fld = 'fecha_devolucion';
				break;

			case 'fecha_devolucion':
				$fld = 'fecha_devolucion';
				break;

			case 'vencimiento':
				$fld = 'fecha_vencimiento';
				break;

			case 'fecha_vencimiento':
				$fld = 'fecha_vencimiento';
				break;

			case 'now':
				$retval = date('d/m/Y H:m:i');
				break;

			default :
				$fld = 'fecha_vencimiento';
				break;
		}

		if (empty($retval) AND !empty($fld)) $retval = $this->getAttribute($fld);

		return $retval;
	}


	function updateExpiration($val,$fld = NULL) {
		$retval = false;
		$this->debug("<b>updateExpiration</b> actualizando vencimiento a $val ",'updateExpiration');
		$retval = $this->setDate($val,'vencimiento');
		return $retval;
		/** 
		if (strcasecmp(wol_db::formatear_fecha($val,false),'null')) {
			$this->_setAttribute('fecha_vencimiento',$val);
			$retval = true;
		}
		/** */
	}

	/** Metodos de Apoyo */
	function _setVar($fld,$val) {
		if (empty($fld)) return false;
		$this->_aVars[$fld] = $val;
		return true;
	}

	function _getVar($fld) {
		if (empty($fld)) return NULL;
		return $this->_aVars[$fld];
	}

	function _unsetVar($fld) {
		if (empty($fld)) return false;
		if (!isset($this->_aVars[$fld])) return false;
		$this->_aVars[$fld] = NULL;
		unset($this->_aVars[$fld]);
		return true;
	}


}

/** Remesas y Normativa Bancaria **/

class DraftItem extends dbListItem {

	function DraftItem(&$oRemesa,$idx,$aData) {
		if (!parent::dbListItem($oRemesa,$idx,$aData,$aAcciones)) {
			$this->setFlag($this->ST_CORRUPT);
			return false;
		}
	}

}

class RecvDraftList extends IndexList {

	function RecvDraftList ($AppName,$dataconn = 'data') {
		if (empty($AppName)) {
			$this->setFlag($this->ST_CORRUPT);
			return false;
		}

		$Sesion = &$GLOBALS[$AppName];
		if (!is_a($Sesion,'wolSesion')) {
			$this->setFlag($this->ST_CORRUPT);
			return false;
		}
			
		$itemclass = 'DraftItem';

		$tabla = 'Efectos';
		$aCampos['Efectos:Efecto'] = array(
			'id_efecto', 'id_factura','id_banco','concepto','fecha_vencimiento','fecha_abono','fecha_devolucion','monto','monto_pagado','pago_cobro',
				'emitido','devuelto','pagado'
			);
		$aCampos['Clientes:Ordenante'] = array(
				'id_cliente','razon_social'
				);
		$aCampos['Empresas:Presentador'] = array(
				'id_empresa','razon_social'
				);
		$aCampos['Bancos:Banco'] = array(
				'id_banco','nombre'
				);

		// $aIndices = array('id_comentario','id_documento','Usuarios.id_usuario','Empleados.id_empleado');
		// $aAcciones['id_prioridad'] = array('method' => 'updatePriority');
		// $aAcciones[$oComentarios->clave_evento] = array('exclude' => array('new' => false, 'edit' => false) );

		return parent::IndexList($AppName,$dataconn,$tabla,$aCampos,$aIndices,$itemclass);
	}

	function dbFill($aIDs) {
		$retval = parent::dbFill( array('Efecto.id_efecto' => $aIDs) );
		return $retval;
	}

}

class NormaCSB {
}

class N19CSB extends NormaCSB {
}

?>
