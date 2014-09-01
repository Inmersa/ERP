<?php

/**
Asiento - entry
movimiento - movement
diario - journal
balance sheet - balance
account booker - libro mayor
asset - activo(s)
liability - pasivo(s)
purchase journal - diario de compras
spendetures journal - diario de gastos
revenue - beneficio
balance reconciliation - conciliacion de balances (?)
close accounting period - cierre de año
carryover - apertura de año
account = cuenta contable
contra-account = contra partida
plan account
  **/
if (!defined('__inmersa_accountentry_class_inc')) {
define('__inmersa_accountentry_class_inc',TRUE);

// Cambios de estado de las lineas de Movimientos y del Asiento en gnrl -_fAsiento y _aModif-
//Primer Bloque de 4bits = Acciones realizadas.
define(ICEntry_AC_MODIFIED,	bindec("000000000001"));
define(ICEntry_AC_DELETED,		bindec("000000000010"));
define(ICEntry_AC_DBCOMMIT,	bindec("000000000100"));
define(ICEntry_AC_RECALC,		bindec("000000001000"));
//Segundo Bloque de 4bits = _Donde_ se ha realizado la accion indicada por el primer bloque.
define(ICEntry_MAIN,				bindec("000000010000"));
define(ICEntry_MOVE,				bindec("000000100000"));
define(ICEntry_DIARY,			bindec("000001000000"));
define(ICEntry_TAXMOVE,			bindec("000010000000"));
// Tercer bloque de 4bits = 'semaforos' - Estado general del Asiento
define(ICEntry_OK,				bindec("000100000000"));
define(ICEntry_LOCKED,			bindec("010000000000"));
define(ICEntry_BLOCKALL,		bindec("100000000000"));

// Mascaras de Tipos de registro y acciones (para entradas en Movimientos)
define(ICEntry_MOVE_HAVE,		bindec("0001"));
define(ICEntry_MOVE_MUST,		bindec("0010"));
define(ICEntry_MOVE_AUTO,		bindec("0100"));

// Mascaras de Estado general del Asiento (_fTipo)
//(constructor) Si este asiento tiene comprobacion de IVA.
define(ICEntry_MODE_CHECK_TAX,		bindec("0001"));	
define(ICEntry_MODE_SALE,		bindec("0010"));
define(ICEntry_MODE_BUY,		bindec("0100"));
define(ICEntry_MODE_AUTO,		bindec("1000"));
// Mascaras de Estado de los Movimientos

// Mascaras para el Filtrado.
define(ICEntry_FILTER_COMPACT,		bindec("0001"));	
define(ICEntry_FILTER_EXTENDED,		bindec("0010"));
define(ICEntry_FILTER_ARRAY,			bindec("0100"));


class AccountEntry {
	var $App_Name = ""; // Nombre de aplicacion y por tanto de instancia global de sesion.

	// Variables Privadas a la clase
	var $_fAsiento; 					// int: Opciones Generales del asiento (ver mascaras)
	var $_aFlags = array(			// Mascaras de estado por 'estructura' de datos.
			'main' => 0,				// Estado de la cabecera (tabla Asiento)
			'ivas' => 0,				// Estado del libro de iva (tabla Movimientos_iva)
			'diarios' => 0,			// Estado de los Diarios  (tabla Asiento_diario)
			'movimientos' => 0		// Estado de los Movimientos  (tabla Movimiento)
			);
	var $_aCfg = array(						// Configuracion General para el tratamiento de Asientos.
		'iempresa_diario' => 0,				// id_diario donde se vuelcan los datos de gestion
		'iempresa_canal' => 0,				// canal, dentro del id_diario, donde se vuelcan los datos de gestion
		'notacion_cc' => 0,					// Notacion Compacta en CC (bool)
		'cc_bancos' => NULL,					// CC de Bancos (para pagar o cobrar)
		'cc_caja' => NULL,					// CC de Caja (para pagar o cobrar)
		'cc_clientes' => NULL,				// CC de Clientes
		'cc_efectos_cliente' => NULL,		// CC de Efectos de Clientes
		'cc_proveedores' => NULL,			// CC de Proveedores
		'cc_efectos_proveedor' => NULL,	// CC de Efectos de Proveedores
		'cc_acreedores' => NULL,			// CC de Acreedores
		'cc_compras' => NULL,				// CC General de Compras
		'cc_ventas' => NULL,					// CC General de Ventas
		'grp_abonoscompras' => NULL,		// CC General de Abonos en Compras
		'grp_abonosventas' => NULL,		// CC General de Abonos en Ventas
		'grp_ppventas' => NULL,				// CC General de ProntoPago en Ventas
		'grp_ppcompras' => NULL,			// CC General de ProntoPago en Compras
		'cc_gan_per' => NULL,				// CC de Ganancias y Perdidas
		'cc_retenciones' => NULL,			// CC de retenciones aplicadas
		'cc_hacienda_pagocta' => NULL,	// CC de Pagos a Cta (y de retenciones) a Hacienda
		'cc_iva_hacienda' => NULL			// CC de Hacienda acreedora por IVA 
			);
	// Indices:
	var $_Idx_act = 0;				// Indice de detalle actualmente en curso (modificandose).
	var $_aIdxDB = array(			// Indice de id_movimiento en la BBDD e idx en la instancia 
			);
	var $_aIdxCCs = array(
			array());					// Array de idxs por CC
	var $_aIdxIVA = array(			// Indices de/para IVA
		'bases_libre' => array(),		// idxs de apuntes base sin iva enlazado.
		'bases_ocupadas' => array(),	// idxs de apuntes base con iva(s) enlazado(s).
		'ivas_pendiente' => array(),	// idxs de cuotas(iva) sin lincar a una base.
		'idx_contra_apuntesiva' =>NULL // idx de la cuenta a la que se Repercute(cli) o Soporta(prov)
			);

	// Estructuras de Datos Inherentes:
	var $_aIVA = array(array( 		// Libros de IVA Disponibles (indexados por plan contable)
		'id_plan_contable' => NULL,		// PlanContable al que pertenece
		'id_libro_iva' => 0,					// ID del libro de IVA.
		'nombre' => NULL,						// Nombre del Libro de IVA
		'soportado_repercutido' => TRUE,	// Si el libro es Repercutido(venta) o no.
		'tipo_libro' => 'Soportado',		// Texto indicativo de si el libro es Repercutido o Soportado
		'nombre_plan_contable' => NULL	// Nombre del PLanContable
			));
	var $_aMain = array(				// Cabecera y Pie del Asiento.
			'id_ejercicio' => 0,			// Id de Ejercicio Actual.
			'id_asiento' => 0,			// ID del Asiento actual en la bbdd.
			'nombre' => '',				// Nombre identificativo del asiento.
			'descripcion' => '',			// Descripcion del asiento
			'documento' => '',			// Nombre de documento asociado al asiento (informativo)
			'factura_gestion' => '',	// id_factura en IEmpresa enlazado al asiento 
			'fecha_apertura' => NULL,	// Fecha de apertura del Asiento
			'fecha_cierre' => NULL,		// Fecha de Cierre del Asiento.
			'estado' => 0,					// Estado del Asiento (ver mascaras de Estado)
			'punteo' => 0,					// Punteo relizado al  Asiento (ver mascaras de Punteo y Grupo de Usuarios)
			'saldo_debe' => 0,			// Suma de los debe's del Asiento
			'saldo_haber' => 0,			// Suma de los haber's del Asiento
			'saldo' => 0					// saldo: debe - haber (ambos saldos)
			);
				
	var $_aEjercicio = array(
			'id_ejercicio' => 0,
			'contador' => 0,
			'nombre' => NULL,
			'fecha_inicio' => NULL,
			'fecha_fin' => NULL,
			'id_asiento_apertura' => NULL,
			'id_asiento_cierre' => NULL
			);
	var $_aEmpresa = array(
			'id_empresa' => 0,
			'razon_social' => NULL,
			'cif' => NULL,
			'nombrecorto' => NULL
			);
	var $_aMovimientos = array(	// Todos los detalles del asiento (junto con sus datos)
			array(						// El indice de este array es el identificador de manejo del detalle.
		 'id_movimiento'	=> 0,			// ID del movimiento en la base de datos
		 'id_plan_contable'	=> '',	// ID del plan contable de la cuenta del movimiento (4 digitos, zerofill)
		 'id_cuenta'	=> '',			// ID de la cuenta contable del movimiento (6 digitos, zero-left-fill)
		 'fecha' => '',					// Fecha del Movimiento
		 'concepto' => NULL,				// Concepto de la entrada
		 'debe' => 0,						// Importe del DEBE
		 'haber' => 0,						// Importe del HABER
		 'saldo' => 0,						// Saldo de este movimiento especifico.
		 'idx_iva' => array()			// Caso de ser la base de cotizacion de iva, cuales son los indice de dichos apuntes
		 )
			);
	var $_aDiarioIVA = array(		// Entradas al diario de IVA. Indexado por el mismo idx que el de movimientos.
		array (
		'id_libro_iva' => 0,					// ID del libro al que pertenece (en la BBDD)
		'id_movimiento' => 0,				// Apunte del Asiento al que esta enlazado (el de IVA propiamente dicho)
		'concepto' => NULL,					// Concepto del Apunte en diario de iva.
		'fecha' => NULL,						// Fecha del apunte (coincidira con la del asiento)
		'base_imponible' => 0,				// Base de Cotizacion
		'cuota' => 0,							// Cuota cotizada
		'total' => 0,							// La base mas la cuota
		'orden' => 0,							// Orden que ocupa dentro del Diario (post bbdd)
		'idx_base' => NULL					// Indice de Enlace con el _aMovimiento base de Cotizacion
			)
			);

	var $_aDiarios = array(			// Relaciones de este asiento con los Libros (tabla Diario). Indice = id_diario
		array( 'id_diario' => 0,	// ID del diario asociado
		'canal' => 0, 					// Canal , para el id_diario, en el que esta.
		'nombre' => NULL,				// Nombre del diario en question
		'cuadrar_iva' => TRUE)		// Si, segun el diario, hay que cuadrar el IVA de este asiento.
			);

	var $_aMarks = array(			// Posibles marcadores del asiento. Indexados por id_marcador
		array( 'id_marcador' => 0,	// ID del marcador (tb indice)
		'mascara' => 0, 				// Mascara binaria del marcador .
		'nombre' => NULL,				// Nombre del marcador en question
		'imagen' => NULL)				// Imagen del marcador.
			);

	var $_aModif = array(
			"dbdel_det" => array( 	// id_movimiento's borrados (para eliminar de la bbdd)
				), 	
			"dbdel_ivas" => array( 	// id_movimiento_iva's borrados (para eliminar de la bbdd)
				), 	
			"diarioiva" => array( 	// Mascaras del los Movimientos del Diario de IVA
				), 	
			"detalles" => array(), 	// Mascara de modificadiones indexadas por idx.
			"diarios" => array() 	// Mascara de modificadiones indexadas por id_diario.
						 );

	var $_db = ""; //  = wolDB::init(); // Base de datos conectada a los datos de gestion donde estan los pedidos.
	var $_db_name=""; 					// Nombre de la conexion a la base de datos dentro de la aplicacion actual.

	function AccountEntry($App_Name = NULL,$db_name,$db_cfg = 'conf',$mode = ICEntry_MODE_CHECK_TAX,$id = NULL) {
		if (!$App_Name) $this->App_Name = "Sesion";
		else $this->App_Name = $App_Name;

		$App_Name = $this->App_Name;
		$oSess = &$GLOBALS[$App_Name];
		$oDb_cfg = &$oSess->get_db($db_cfg);
		$this->_db = NULL;
		$this->setDb($db_name);
		$this->_aMovimientos = array();
		$this->_aDiarioIVA = NULL;
		$this->_aDiarios = NULL;
		$this->_aMarks = NULL;
		$this->_aEjercicio = NULL;
		$this->_aEmpresa = NULL;
		$this->_aIdxIVA['bases_libre'] = array();
		$this->_aIdxIVA['ivas_pendiente'] = array();
		$this->_aIdxIVA['idx_contra_apuntesiva'] = NULL;

		// Obteniendo las variable de configuracion. cfg_* en _main
		if (is_array($this->_aCfg))
			foreach ($this->_aCfg as $campo => $nah) {
				$this->_aCfg[$campo] = $oDb_cfg->read_main_value('cfg_'.$campo);
				if (!strcasecmp('cc_',substr($campo,0,3))) {
					$aTmp = $this->filterAccount($this->_aCfg[$campo],NULL,(ICEntry_FILTER_ARRAY | ICEntry_FILTER_EXTENDED));
					if (is_array($aTmp)) $this->_aCfg[$campo] = $aTmp[0];
					$aTmp = NULL;
				}
			}

		$this->setMode($mode);

		// Mientras no haya ejercicio, el asiento queda bloqueado
		$this->_fAsiento |= ICEntry_BLOCKALL;
		$this->_fAsiento |= ICEntry_LOCKED;
		if (is_numeric($id)) $this->setAccountPeriod($id);

		// Obteniendo los Libros de Iva que Existen.
		$this->_aIVA = NULL;
		// BBDDFix: Sobra id_ejercicio y porcentaje
		$cons="SELECT ".
				"L.id_plan_contable as 'id_plan_contable', ".
				"L.id_libro_iva as 'id_libro_iva', ".
				"L.id_ejercicio as 'id_ejercicio', ".
				"L.nombre as 'nombre', ".
				"L.soportado_repercutido as 'soportado_repercutido', ".
				"IF(L.soportado_repercutido,'Repercutido','Soportado') as 'tipo_libro', ".
				"PC.nombre as 'nombre_plan_contable' ".
				"FROM Libro_ivas as `L`, Plan_general_contable as `PC` ".
				"WHERE L.id_plan_contable = PC.id_plan_contable ";
		$idrs = $this->_db->query($cons);
		if ($this->_db->num_rows($idrs)) {
			while ($aTmp = $this->_db->fetch_assoc($idrs)) {
				$this->_aIVA[$aTmp['id_plan_contable']] = $aTmp;
			}
		}
		$this->_db->libera($idrs);

	}

	/** Metodos de mantenimiento e internos **/
	function init() {
		// debug("init.... (".$this->App_Name.")");
		// print_r($this);
		$this->setDb($this->_db_name);
		$this->debug = 1;
	}

	function cerrar() {
		if ($this->debug) debug("cerramos Chiringo... ".$this->App_Name);
		// $this->_db = NULL;
		unset($this->_db);
	}

	/**
	  * Este metodo deberia ser uno sobre-escrito a la clase base. (Al igual que init y cerrar ?)
	  * 	De tal forma que la clase que extiende AccountEntry sea la que sea un 'plug-in' del kernel inmersa.
	  **/
	function error($err_code,$aParams = NULL) {
		$Sesion = $GLOBALS[$this->App_Name];
		if (!is_object($Sesion)) {
			echo "Error (AccountEntry.class:$err_code) $msg";
			/** **
			global $$this->App_Name;
			array_push($this->_err_msg,$msg);
			array_push($this->_err_no,$err_code);
			echo "Error (inmPedido.class:$err_code) $msg";
			// $$this->App_Name->error($err_code,$msg);
			/** **/
		} else {
			$Sesion->lcMessage($err_code,$aParams);
		}
	}

	/**
	  * Este metodo tambien deberia ser sobre-escrito al igual que el metodo error().
	  **/
	function setDb($db_name) {
		$app = $this->App_Name;
		// global $$app;
		$Sesion = &$GLOBALS[$this->App_Name];
		if (empty($db_name)) $db = &$Sesion->get_db($this->_db_name);
		else {
			$this->_db_name = $db_name;
			$db = &$Sesion->get_db($this->_db_name);
		}
		$this->_db = &$db;
		return TRUE;
	}

	/* Metodos privados */
	/**
	  * Metodo encargado de actualizar las banderas caso de producirse un cambio en el pedido.
	  * @param $tipo	-	Tipo de cambio realizado. (ver defines).
	  * @return NULL
	  **/
	function _changeFlags($tipo = 0,$id = NULL) {
		if (empty($tipo)) return;

		$tmpmask = 0;
		if ($tipo & ICEntry_AC_MODIFIED) {
			$tmpmask |= ICEntry_AC_MODIFIED;
			$tmpmask |= ICEntry_AC_DBCOMMIT;
			$tmpmask &= ~ICEntry_AC_DELETED;
		}
		if ($tipo & ICEntry_AC_DBCOMMIT) {
			$tmpmask |= ICEntry_AC_DBCOMMIT;
		}
		if ($tipo & ICEntry_AC_DELETED) {
			// debug("_changeFlags(): Marcando para borrado...");
			$tmpmask |= ICEntry_AC_DELETED;
			$tmpmask |= ICEntry_AC_DBCOMMIT;
		}
		if ($tipo & ICEntry_OK) {
			$tmpmask &= ~ICEntry_AC_DELETED;
			$tmpmask &= ~ICEntry_AC_MODIFIED;
			$tmpmask &= ~ICEntry_AC_DBCOMMIT;
			$tmpmask |= ICEntry_OK;
		}
		// if ($this->debug) debug("_changeFlags(".decbin($tipo).") - (".decbin($tmpmask).") (".$id.")");

		if ( ($tipo & ICEntry_MOVE) ) {
			// debug("Tocando movimientos: $id ");
			if ($id == -1 AND is_array($this->_aMovimientos) AND sizeof($this->_aMovimientos)) {
				foreach ($this->_aMovimientos as $idx => $aMov) {
					if ($tipo & ICEntry_OK) {
						$tmpmask = $this->_aModif['detalles'][$idx];
						$tmpmask &= ~ICEntry_AC_DELETED;
						$tmpmask &= ~ICEntry_AC_MODIFIED;
						$tmpmask &= ~ICEntry_AC_DBCOMMIT;
						$tmpmask |= ICEntry_OK;
						$this->_aModif['detalles'][$idx] = $tmpmask;
					} else {
						$this->_aModif['detalles'][$idx] |= $tmpmask;
					}
				}
			} elseif (is_array($this->_aMovimientos[$id])) {
				if ($tipo & ICEntry_OK) {
					$tmpmask = $this->_aModif['detalles'][$id];
					$tmpmask &= ~ICEntry_AC_DELETED;
					$tmpmask &= ~ICEntry_AC_MODIFIED;
					$tmpmask &= ~ICEntry_AC_DBCOMMIT;
					$tmpmask |= ICEntry_OK;
					$this->_aModif['detalles'][$id] = $tmpmask;
				} else {
					$this->_aModif['detalles'][$id] |= $tmpmask;
				}
				// if ($this->debug) debug("aModif para el detalle $id - ".decbin($this->_aModif['detalles'][$id])." = ".$this->_aModif['detalles'][$id]);
			} 
			$this->_aFlags['movimientos'] |= $tmpmask;

			$this->_fAsiento |= (ICEntry_MOVE | $tmpmask) ;
			if ($tipo & ICEntry_AC_MODIFIED) {
				$tipo |= ICEntry_MAIN | ICEntry_AC_RECALC;
				if ($this->debug) debug("Movimiento($id) tocado, solicitando un Re-Calculo de Main");
			}
		}

		if ( ($tipo & ICEntry_TAXMOVE) AND is_numeric($id)) {
			if ($id == -1 AND is_array($this->_aDiarioIVA) AND sizeof($this->_aDiarioIVA)) {
				foreach ($this->_aDiarioIVA as $idxiva => $aIva) {
					if ($tipo & ICEntry_OK) {
						$tmpmask = $this->_aModif['diarioiva'][$idxiva];
						$tmpmask &= ~ICEntry_AC_DELETED;
						$tmpmask &= ~ICEntry_AC_MODIFIED;
						$tmpmask &= ~ICEntry_AC_DBCOMMIT;
						$tmpmask |= ICEntry_OK;
						$this->_aModif['diarioiva'][$idxiva] = $tmpmask;
					} else {
						$this->_aModif['diarioiva'][$idxiva] |= $tmpmask;
					}
				}
				$this->_aFlags['ivas'] |= $tmpmask;
			} elseif (is_array($this->_aDiarioIVA[$id])) {
				if ($tipo & ICEntry_OK) {
					$tmpmask = $this->_aModif['diarioiva'][$id];
					$tmpmask &= ~ICEntry_AC_DELETED;
					$tmpmask &= ~ICEntry_AC_MODIFIED;
					$tmpmask &= ~ICEntry_AC_DBCOMMIT;
					$tmpmask |= ICEntry_OK;
					$this->_aModif['diarioiva'][$id] = $tmpmask;
				} else {
					$this->_aModif['diarioiva'][$id] |= $tmpmask;
				}
			} else { // El general
				$this->_aFlags['ivas'] |= $tmpmask;
			}
		}

		if ( ($tipo & ICEntry_MAIN)) {
			// debug("_changeFlags(MAIN)");
			$bTouch = FALSE;
			if ($tipo & ICEntry_AC_RECALC) {
				$this->_aMain['saldo'] = (double)$this->_aMain['saldo_debe'] - (double)$this->_aMain['saldo_haber'];
				$this->_fAsiento |= (ICEntry_AC_DBCOMMIT | ICEntry_MAIN);
				$this->_aFlags['main'] |= ICEntry_AC_DBCOMMIT;
				$bTouch = TRUE;
				// $this->_aFlags[total_bases] |= (inmPed_MODIFIED | inmPed_DB_COMMIT);
				// $tipo |= inmPed_CHG_DISCOUNTS | inmPed_CHG_TAXES | inmPed_MODIFIED;
			} elseif ($tipo & ICEntry_OK) {
				$this->_aFlags['main'] &= ~ICEntry_AC_DBCOMMIT; 
				$this->_aFlags['main'] &= ~ICEntry_AC_DELETED; 
				$this->_aFlags['main'] &= ~ICEntry_AC_MODIFIED; 
				$this->_aFlags['main'] |= ICEntry_OK;
				$this->_fAsiento &= ~ICEntry_MAIN;
				$this->_fAsiento &= ~ICEntry_BLOCKALL;
			} 
			if ($tipo & ICEntry_LOCKED) {
				$this->_fAsiento |= ICEntry_LOCKED;
				// if ($this->debug) 
					debug("Constructor:: Blokeamos! :".ICEntry_LOCKED);
			}
			if ($tipo & ICEntry_AC_DELETED) $bTouch = true;
				
			if ($bTouch) $this->_fAsiento |= (ICEntry_MAIN | ICEntry_AC_DBCOMMIT);
			$this->_aFlags['main'] |= $tmpmask;
			/** **
			if ($tipo & inmPed_DB_NEWRECORD) {
				$this->_fAsiento |= inmPed_DB_COMMIT;
				$this->_fAsiento |= inmPed_DB_NEWRECORD;
			}
			/** **/
			// $this->_fAsiento |= (ICEntry_MAIN | $tmpmask);
		}

		if ( ($tipo & ICEntry_DIARY)) {
			// debug("_changeFlags(DIARY)($id) - ".bindec($tmpmask));
			if ($tipo & ICEntry_OK) {
				$this->_aFlags['diarios'] &= ~ICEntry_AC_DBCOMMIT; 
				$this->_aFlags['diarios'] &= ~ICEntry_AC_DELETED; 
				$this->_aFlags['diarios'] &= ~ICEntry_AC_MODIFIED; 
				$this->_aFlags['diarios'] |= ICEntry_OK;
				$this->_fAsiento &= ~ICEntry_DIARY;
			} 
			if ($id == -1 AND is_array($this->_aDiarios) AND sizeof($this->_aDiarios)) {
				foreach ($this->_aDiarios as $idx => $aMov) {
					$this->_aModif['diarios'][$idx] |= $tmpmask;
				}
			} elseif (is_array($this->_aDiarios[$id])) {
				$this->_aModif['diarios'][$id] |= $tmpmask;
				if ($this->debug) debug("aModif para el diario $id - ".decbin($this->_aModif['diarios'][$id])." = ".$this->_aModif['diarios'][$id]);
			} 
				
			$this->_aFlags['diarios'] |= $tmpmask;
		}


	}

	function _zeroRightFill($number,$ndig) {
		if (!is_numeric($number) OR !is_numeric($ndig)) return NULL;
		settype($number,'string');
		if (strlen($number) > $ndig)
			$retval = substr($number,0,$ndig);
		elseif (strlen($number) != $ndig) {
			$ntmp = pow(10,$ndig-strlen($number));
			settype($ntmp,'string');
			$retval = $number.substr($ntmp,1);
		} else $retval = $number;
		return $retval;
	}

	function _zeroLeftFill($number,$ndig) {
		if (!is_numeric($number) OR !is_numeric($ndig)) return NULL;
		settype($number,'string');
		if (strlen($number) > $ndig)
			$retval = substr($number,(-1 * $ndig));
		elseif (strlen($number) != $ndig) {
			$ntmp = pow(10,$ndig-strlen($number));
			settype($ntmp,'string');
			$retval = substr($ntmp,1).$number;
		} else $retval = $number;
		return $retval;
	}

	function _findTax ($plan_contable) {
		if (is_array($this->_aIVA[$plan_contable])) return $plan_contable;
		else return NULL;
	}

	/**
	  * Comprueba si una Plan de Cuentas pertenece a algun IVA.
	  *  TODO: Comprobar si estamos vendiendo o comprando, para marcar solo
	  *	los ivas repercutido o soportado (dependiendo de lo que toque)
	  **/
	function _isTax ($plan_contable) {
		if (is_array($this->_aIVA[$plan_contable])) $retval = TRUE;
		else $retval = FALSE;
		return $retval;
	}

	/**
	  * Comprueba si la Cuenta indicada pertenece a alguna que sea base de cotizacion (cc_compras o cc_ventas)
	  **/
	function _isTaxBase ($plan_contable) {
		if (empty($plan_contable)) return FALSE;
		$retval = false;
		if ($this->debug) debug("Comprobando $plan_contable Como base de cotizaciones");

		if ($this->getMode() & ICEntry_MODE_SALE) {
			if ($plan_contable == $this->_aCfg['cc_ventas']) 
				$retval = true;
		} elseif ($this->getMode() & ICEntry_MODE_BUY) {
			if ($plan_contable == $this->_aCfg['cc_compras']) 
				$retval = true;
		} else {
			if ($plan_contable == $this->_aCfg['cc_ventas']) {
				$retval = true;
			} elseif ($plan_contable == $this->_aCfg['cc_compras']) {
				$retval = true;
			}
		}
		// debug("isTaxBase($plan_contable) : ".$retval." Modo : ".$this->getMode());
		return $retval;
	}

	/**
	  * Establece un idx como Impuesto para ser apuntado contra el diario de ivas.
	  **/
	function _setTax($idx,$bCalc = TRUE) {
		if (!is_numeric($idx)) return FALSE;
		if (!is_array($this->_aMovimientos[$idx])) return FALSE;
		$plan_contable = $this->_aMovimientos[$idx]['id_plan_contable'];
		$ivaidx = $this->_findTax($plan_contable);
		if ($ivaidx != NULL) {
			$aLibro = $this->_aIVA[$ivaidx];
		}
		if (!isset($bCalc)) $bCalc = TRUE;
		if ($this->debug) debug("setTax($idx) Calcular? :: $bCalc - $ivaidx");

		$venta = -1;
		if ($this->getMode() & ICEntry_MODE_SALE) {
			if ((int)$aLibro['soportado_repercutido']) $venta = 1;
		} elseif ($this->getMode() & ICEntry_MODE_BUY) {
			if (!(int)$aLibro['soportado_repercutido']) $venta = 0;
		} elseif ($this->getMode() & ICEntry_MODE_AUTO) { 
			if ((int)$aLibro['soportado_repercutido'] ) {
				$this->setMode(ICEntry_MODE_SALE);
				$venta = 1;
			} else {
				$this->setMode(ICEntry_MODE_BUY);
				$venta = 0;
			}
		}
		// debug("_setTax($idx) : $venta ");
		if ($venta == -1) return false;
		if (is_array($this->_aDiarioIVA[$idx])) return FALSE;
		
		// Poblando parte de los datos:
		$this->_aDiarioIVA[$idx]['id_libro_iva'] = $aLibro['id_libro_iva'];
		$this->_aDiarioIVA[$idx]['id_movimiento'] = 
										$this->_aMovimientos[$idx]['id_movimiento'];
		$this->_aDiarioIVA[$idx]['concepto'] = 
										$this->_aMovimientos[$idx]['concepto'];
		$this->_aDiarioIVA[$idx]['fecha'] = 
										$this->_aMain['fecha_apertura'];

		if (is_array($this->_aIdxIVA['bases_libre']) AND 
				sizeof($this->_aIdxIVA['bases_libre']) > 0) {
			if ($this->debug) debug("Hay base libre contra la que lincar el IVA ..");
			$this->_linkTaxToBase($idx,NULL,$bCalc);
		} else {
			// Necesitamos una base, asi que vamos a ver si hay mas ivas de este libro, y lo licamos a su base:
			for ($i=($idx-1);$i>=0;$i--)
				if ($this->_aDiarioIVA[$i]['id_libro_iva']==$aLibro['id_libro_iva']) {
					// Encontrado, buscando la base de cotizacion
					$this->_linkTaxToBase($idx,$this->_aDiarioIVA[$i]['idx_base'],$bCalc);
					break;
				}
			array_push($this->_aIdxIVA['ivas_pendiente'],$idx);
			$this->_changeFlags(ICEntry_TAXMOVE | ICEntry_AC_MODIFIED | ICEntry_AC_DBCOMMIT,$idx);
		}

		return TRUE;
	}

	function _setTaxAmount($idxiva, $base = NULL,$cuota = NULL) {
		if ($this->debug) debug("Set tax($idxiva) amount($base) = $cuota");
		$retval = FALSE;
		if (!is_numeric($idxiva)) return FALSE;
		if (!is_numeric($base) AND !is_numeric($cuota)) return FALSE;
		if (is_numeric($base) AND $this->_isTax($this->_aMovimientos[$idxiva]['id_plan_contable'])) {
			// debug("ES impuesto si...");
			// print_r($this->_aDiarioIVA[$idxiva]);
			$this->_aDiarioIVA[$idxiva]['base_imponible'] = $base;
			if (!is_numeric($cuota)) {
				if ($this->debug) debug("CUota no es numerico ...");
				$pto = (int)$this->_aMovimientos[$idxiva]['id_cuenta'];
				$this->_aDiarioIVA[$idxiva]['cuota'] = $base * ($pto / 100);
			} else {
				$this->_aDiarioIVA[$idxiva]['cuota'] = $cuota;
			}
			$this->_aDiarioIVA[$idxiva]['total'] = $this->_aDiarioIVA[$idxiva]['cuota'] + $this->_aDiarioIVA[$idxiva]['base_imponible'];
			$this->_changeFlags(ICEntry_TAXMOVE | ICEntry_AC_DBCOMMIT,$idxiva);
			$retval = TRUE;
			if ($this->debug) print_r($this->_aDiarioIVA[$idxiva]);
		}
		return $retval;
	}

	/**
	  * Indica que dicho idx es un apunte que puede sservir como base de cotizacion de IVA.
	  **/
	function _setTaxBase($idx,$bCalc = TRUE) {
		if (!is_numeric($idx)) return FALSE;
		if (!is_array($this->_aMovimientos[$idx])) return FALSE;
		$plan_contable = $this->_aMovimientos[$idx]['id_plan_contable'];
		if (empty($plan_contable)) return FALSE;
		if (!isset($bCalc)) $bCalc = TRUE;
		
		if ($this->debug) debug("_setTaxBase($idx,$bCalc)");
		$bDoIt = false;
		if ($this->getMode() & ICEntry_MODE_SALE) {
			if ($plan_contable == $this->_aCfg['cc_ventas']) 
				$bDoIt = true;
		} elseif ($this->getMode() & ICEntry_MODE_BUY) {
			if ($plan_contable == $this->_aCfg['cc_compras']) 
				$bDoIt = true;
		} elseif ($this->getMode() & ICEntry_MODE_AUTO) {
			if ($plan_contable == $this->_aCfg['cc_ventas']) {
				$this->setMode(ICEntry_MODE_SALE);
				$bDoIt = true;
			} elseif ($plan_contable == $this->_aCfg['cc_compras']) {
				$this->setMode(ICEntry_MODE_BUY);
				$bDoIt = true;
			}

		}

		$retval = FALSE;
		if ($bDoIt) {
			if (sizeof($this->_aIdxIVA['ivas_pendiente']) > 0) {
				$this->_linkTaxToBase($idxiva,$idx,$bCalc);
			} else {
				if (!in_array($idx,$this->_aIdxIVA['bases_libre']) AND !in_array($idx,$this->_aIdxIVA['bases_ocupadas'])) {
					array_push($this->_aIdxIVA['bases_libre'],$idx);
				}
			}
		}
		return $retval;
	}

	function _delTax($idx) {
		if ($this->debug) debug("_delTax($idx) Borrando un IVA ...");
		if (!is_numeric($idx)) return FALSE;
		if (!is_array($this->_aDiarioIVA[$idx])) return FALSE;
		if (is_numeric($this->_aDiarioIVA[$idx]['idx_base']))
			$this->_unlinkTaxFromBase($idx);
		if (is_numeric($this->_aDiarioIVA[$idx]['id_movimiento_iva'])) {
			if ($this->debug) debug("($idx) ha venido de la bbdd ..");
			array_push($this->_aModif['dbdel_ivas'],$this->_aDiarioIVA[$idx]['id_movimiento_iva']); //AQUI!!!
		}
		unset($this->_aDiarioIVA[$idx]);
		$this->_changeFlags(ICEntry_TAXMOVE | ICEntry_AC_DELETED);
	}

	function _linkTaxToBase($idx_tax = NULL,$idx_base = NULL,$bCalc = FALSE) {
		if ($idx_tax == NULL AND $idx_base == NULL) return FALSE;
		if ($this->debug) debug("linktaxtobase ($idx_tax, $idx_base, $bCalc)");
		if (!isset($bCalc)) $bCalc = FALSE;

		if ($this->getMode() & ICEntry_MODE_SALE) $venta = 1;
		elseif($this->getMode() & ICEntry_MODE_BUY) $venta = 0;
		else return FALSE;

		// Control de Errores:
		$bOk = FALSE;
		if (is_numeric($idx_tax) AND is_array($this->_aIdxIVA['bases_libre']) AND 
				sizeof($this->_aIdxIVA['bases_libre']) > 0) {
			if (!is_numeric($idx_base)) 
				$idx_base = array_shift($this->_aIdxIVA['bases_libre']);
			$continue = 1;
			while ($continue) {
				$continue = 0;
				if (is_numeric($idx_base) AND is_array($this->_aMovimientos[$idx_base])) {
					if ($this->_isTaxBase($this->_aMovimientos[$idx_base]['id_plan_contable'])) {
						// debug("Todo Correcto, me vale $idx_base");
						if (!is_array($this->_aIdxIVA['bases_ocupadas'])) 
							$this->_aIdxIVA['bases_ocupadas'] = array();
						array_push($this->_aIdxIVA['bases_ocupadas'],$idx_base);
						$bOk = TRUE;
					} else {
						// debug("venta($venta) id_plan($idx_base) = ".$this->_aMovimientos[$idx_base]['id_plan_contable']);
						// print_r($this->_aMovimientos[$idx_base]);
						if (!is_array($aTmp)) $aTmp = array();
						if (!in_array($idx_base,$aTmp)) array_push($aTmp,$idx_base);
						$idx_base = array_shift($this->_aIdxIVA['bases_libre']);
						// debug("Obtenemos otro: $idx_base");
						$continue = 1;
					}
				} elseif (is_array($this->_aIdxIVA['bases_libre']) AND 
								sizeof($this->_aIdxIVA['bases_libre']) > 0) {
					// No volvemos a reciclar este IDx, ha fallado => fuera
					$idxbase = array_shift($this->_aIdxIVA['bases_libre']);
					$continue = 1;
				} 
			}
			if (is_array($aTmp))
				foreach ($aTmp as $tmpidx)
					array_push($this->_aIdxIVA['bases_libre'],$tmpidx);
		} elseif (is_numeric($idx_base) AND is_array($this->_aIdxIVA['ivas_pendiente']) AND
				sizeof($this->_aIdxIVA['ivas_pendiente'])>0) {
			// debug("Hay algun iva colgando... ");
			$bOk = TRUE;
			$continue = 1;
			while ($continue) {
				$continue = 0;
				$idx_tax = array_shift($this->_aIdxIVA['ivas_pendiente']);
				if (!is_array($this->_aMovimientos[$idx_tax])) {
					// if (!is_array($aTmp)) $aTmp = array();
					// array_push($aTmp,$idx_base);
					$idx_tax = array_shift($this->_aIdxIVA['ivas_pendiente']);
					$continue = 1;
				}
			}
		} else {
			if (!is_numeric($idx_tax) OR !is_numeric($idx_base)) {
				if ($this->debug) debug("ni $idx_tax - ni $idx_base parece ser que fonan");
				$bOk = FALSE;
			} elseif ($this->_isTaxBase($this->_aMovimientos[$idx_base]['id_plan_contable']) 
					AND $this->_isTax($this->_aMovimientos[$idx_tax]['id_plan_contable'])) {
				$bOk = TRUE;
			}
		}

		if ($bOk) {
			if ($this->debug) debug("Procedemos a Realizar el enlace entre $idx_tax e $idx_base ... ($bCalc)");
			// FixMe: Convertir esto en un vector para que una base de cotizacion pueda tener mas de un impuesto
			if (!is_array($this->_aMovimientos[$idx_base]['idx_iva'])) $this->_aMovimientos[$idx_base]['idx_iva'] = array();
			if (!in_array($idx_tax,$this->_aMovimientos[$idx_base]['idx_iva'])) {
				if ($this->debug) debug("Metido idx $idx_tax en vector de impuestos de la base en idx $idx_base");
				array_push($this->_aMovimientos[$idx_base]['idx_iva'],$idx_tax);
			}
			$this->_aDiarioIVA[$idx_tax]['idx_base'] = $idx_base;
			$base = $this->getAmount($idx_base,ICEntry_MOVE_AUTO);
			$this->_aDiarioIVA[$idx_tax]['base'] = $base;
			if ($bCalc) {
				// debug("Calculando Bases y cuotas..");
				$pto = (double)$this->_aMovimientos[$idx_tax]['id_cuenta'];
				if (!empty($pto)) {
					$cuota = $base * ($pto / 100);
					$this->_setTaxAmount($idx_tax,$base,$cuota);
					$this->setAmount($idx_tax,$cuota,ICEntry_MOVE_AUTO);
				} 
				// debug("Base = $base al $pto % = $cuota");
			} else {
				$this->_setTaxAmount($idx_tax,$base,$this->getAmount($idx_tax,ICEntry_MOVE_AUTO));
			}
			$this->_changeFlags(ICEntry_TAXMOVE | ICEntry_AC_MODIFIED | ICEntry_AC_DBCOMMIT,$idx_tax);
		}
		return TRUE;
	}

	function _unlinkTaxFromBase($idx_tax = NULL,$idx_base = NULL) {
		if ($this->debug) debug("_unlinkTaxToBase");
		if (!is_numeric($idx_tax) AND !is_numeric($idx_base)) return FALSE;
		if (!isset($bCalc)) $bCalc = FALSE;

		// Control de Errores:
		if (is_numeric($idx_tax) AND is_numeric($idx_base)) {
			if (!in_array($idx_tax,$this->_aMovimientos[$idx_base]['idx_iva']) OR $this->_aDiarioIVA[$idx_tax]['idx_base']!=$idx_base) {
				debug("Los Indices no coinciden.... imposible el unlink");
				return FALSE;
			}
		} elseif (!is_numeric($idx_base)) {
			$idx_base = $this->_aDiarioIVA[$idx_tax]['idx_base'];
		} elseif (!is_numeric($idx_tax)) {
			$idx_tax = array_pop($this->_aMovimientos[$idx_base]['idx_iva']);
		} else return FALSE;
		if ($this->debug) debug("DesLincando Iva($idx_tax) - Base($idx_base) ...");
		// unset($this->_aMovimientos[$idx_base]['idx_iva']);
		unset($this->_aDiarioIVA[$idx_tax]['idx_base']);
		array_push($this->_aIdxIVA['bases_libre'],$idx_base);
		array_push($this->_aIdxIVA['ivas_pendiente'],$idx_tax);

		return TRUE;
	}

	function _buildTaxIndex() {
		if (!is_array($this->_aMovimientos)) return TRUE;
		if ($this->debug) debug("Re-Construyendo Indices de Impuestos ...");

		$los_mov = NULL;
		foreach ($this->_aMovimientos as $idx => $aMov) 
			if (is_numeric($aMov['id_movimiento'])) {
				$los_mov .= ( (!empty($los_mov)) ? ' OR ' : '').'Iva.id_movimiento = '.$aMov['id_movimiento'];
				$aTmpIdx[$aMov['id_movimiento']] = $idx;
			}

		if (!empty($los_mov) AND is_numeric($this->_aMain['id_asiento'])) {
			$cons = "SELECT ".
						"Iva.id_movimiento as 'id_movimiento', ".
						"Iva.id_libro_iva as 'id_libro_iva', ".
						"Iva.id_movimiento_iva as 'id_movimiento_iva', ".
						"Iva.id_plan_contable as 'id_plan_contable', ".
						"Iva.id_cuenta as 'id_cuenta', ".
						"Iva.concepto as 'concepto', ".
						"Iva.fecha as 'fecha', ".
						"Iva.base_imponible as 'base', ".
						"Iva.cuota as 'cuota', ".
						"Iva.total as 'total', ".
						"Iva.orden as 'orden' ".
						"FROM Movimientos_iva `Iva` ".
						"WHERE ".
						"Iva.id_asiento = ".$this->_aMain['id_asiento']." AND ".
						"( $los_mov )";
			$idres = $this->_db->query($cons);
			while ($aIva = $this->_db->fetch_assoc($idres)) {
		
				if ($this->_isTax($this->_aMovimientos[$aTmpIdx[$aIva['id_movimiento']]]['id_plan_contable'])) {
					if ($this->debug) debug("Comprobando Impuestos. ");

					/** No tocar estos debug() hasta que no este bien testada la clase **/
					$idx = (int)$aTmpIdx[$aIva['id_movimiento']];
					if (!$this->isTaxContraAccount($aIva['id_plan_contable'].$aIva['id_cuenta'])) {
						if ($this->debug) debug("No esta establecido ni el tipo de asiento.. ni la contrapartida del iva");
						$aIds = $this->getIdxFromAccount($aIva['id_plan_contable'].$aIva['id_cuenta']);
						if (is_array($aIds)) 
							foreach ($aIds as $idx_contraiva) 
								if ($this->setTaxContraAccount($idx_contraiva)) break;
						// debug("Comprobar que la contrapartida se ha puesto bien.");
					} else {
						$idx_contraiva = $this->getTaxContraAccount();
						if (!is_numeric($idx_contraiva)) $this->setTaxContraAccount($idx);
						elseif (!is_array($this->_aMovimientos[$idx_contraiva])) {
							$this->delTaxContraAccount();
							$this->setTaxContraAccount($idx);
						} elseif ($this->_aMovimientos[$idx_contraiva]['id_plan_contable'] != $aIva['id_plan_contable']) {
							if ($this->debug) debug("El plan contable de la Cuenta de Contra-Partida de IVA no coincide con los Registros de IVA. Reset");
							$this->delTaxContraAccount();
							if ($this->debug) debug("Sobre-Escribien la Cuenta de Contrapartida de los IVAs...");
							$this->setTaxContraAccount($idx);
						} elseif ($this->_aMovimientos[$idx_contraiva]['id_cuenta'] != $aIva['id_cuenta'] AND ($this->getMode() & ICEntry_MODE_CHECK_TAX)) {
							$this->error('ACENTRY_TAX_WITHOUT_BASE');
						}
					}
					unset($aIva['id_plan_contable']);
					unset($aIva['id_cuenta']);
					$this->_aDiarioIVA[$idx] = $aIva;
					if (!empty($aIva['fecha'])) $this->_aDiarioIVA[$idx]['fecha'] = colocar_fecha($aIva['fecha']);
					// Presuponemos que este bien, si se enlaza con algo, linkTax lo marcara como modificado
					if (is_array($this->_aIdxIVA['bases_libre']) AND 
							sizeof($this->_aIdxIVA['bases_libre']) > 0) {
						if ($this->debug) debug("Hay base libre contra la que lincar el IVA ..");
						if ($this->debug) debug("Lincamos $idx a la base que ande libre.");
						$this->_linkTaxToBase($idx,NULL,FALSE);
					} elseif (is_array($this->_aIdxIVA['bases_ocupadas']) AND
							sizeof($this->_aIdxIVA['bases_ocupadas']) > 0) {
						if ($this->debug) debug('Lincando idx '.$idx.' a alguna de las bases existentes ...');
						sort($this->_aIdxIVA['bases_ocupadas']);
						for ($i = sizeof($this->_aIdxIVA['bases_ocupadas']); $i > 0; $i--) {
							if ($this->_aIdxIVA['bases_ocupadas'][$i-1] < $idx) {
								// debug("Me vale ".$this->_aIdxIVA['bases_ocupadas'][$i-1]." para $idx");
								$this->_linkTaxToBase($idx,$this->_aIdxIVA['bases_ocupadas'][$i-1],FALSE);
								break;
							}
						}
					} else {
						// print_r($this->_aIdxIVA['bases_ocupadas']);
						if ($this->debug)debug("Metemos IVA ($idx) sin poder lincarlo contra nada...");
						array_push($this->_aIdxIVA['ivas_pendiente'],$idx);
					}
					$this->_changeFlags(ICEntry_TAXMOVE | ICEntry_OK,$idx);
				}

				// $this->_changeFlags(ICEntry_MAIN | ICEntry_MOVE | ICEntry_AC_MODIFIED | ICEntry_AC_DBCOMMIT,$idx_det);
			}
		}
		// debug("El IVA");
		// print_r($this->_aDiarioIVA);

	}

	/** FIN de los Metodos de Mantenimiento e internos **/

	/** Metodos de NAVEGACION **/

	/**
	  * Metodo encargado de devolver el puntero al primer detalle
	  * @param $bSetPointer	-	Booleano indicativo de si se ha de modificar el puntero a los detalles o no.
	  * @return idx or NULL	-	Si la operacion se ha realizado con exito.
	  **/
	function firstMove($bSetPointer = TRUE) 
	{
		if ($this->_fAsiento & ICEntry_LOCKED) {
			$this->error('ACENTRY_LOCKED');
			return NULL;
		}
		if (!isset($bSetPointer)) $bSetPointer = TRUE;
		if (is_array($this->_aMovimientos) AND sizeof($this->_aMovimientos)) {
			reset($this->_aMovimientos);
			list($clave,$valor) = each($this->_aMovimientos);
			reset($this->_aMovimientos);
			if ($bSetPointer AND isset($clave)) $this->_Idx_act = $clave;
			if (!isset($clave)) $clave = NULL;
		} else $clave = NULL;
		return $clave;
	}

	/**
	  * Este metodo obtiene el siguiente detalle al actualmente indicado por el puntero a las lineas de detalle.
	  * @param $bSetPointer	-	Booleano indicativo de si se ha de modificar el puntero a los detalles o no.
	  * @return idx or NULL	-	Si la operacion se ha realizado con exito.
	  **/
	function nextMove($bSetPointer = TRUE) 
	{
		if ($this->_fAsiento & ICEntry_LOCKED) {
			$this->error('ACENTRY_LOCKED');
			return NULL;
		}
		if (!is_array($this->_aMovimientos) OR !sizeof($this->_aMovimientos)) return NULL;
		if (!isset($this->_Idx_act)) return NULL;
		$aKeys = array_keys($this->_aMovimientos);
		$continuar = TRUE;
		$retval = NULL;
		foreach ($aKeys as $key) {
			if ($key > $this->_Idx_act) {
				if ($bSetPointer) $this->_Idx_act = $key;
				$retval = $key;
				break;
			} 
		}

		return $retval;
	}

	/**
	  * Metodo encargado de establecer el puntero activo a las lineas de detalle.
	  **/
	function setActiveMove($idx_det) 
	{
		if (!is_array($this->_aMovimientos[$idx_det])) return FALSE;
		$this->_Idx_act = $idx_det;
		return TRUE;
	}

	/**
	  * Este metodo obtiene el actual detalle indicado por el puntero a las lineas de detalle.
	  * @return idx or NULL	-	Si la operacion se ha realizado con exito.
	  **/
	function currentMove() 
	{
		if ($this->_fAsiento & ICEntry_LOCKED) {
			$this->error('ACENTRY_LOCKED');
			return NULL;
		}
		// debug("current_detail(".$this->_Idx_act.")");
		if (!is_array($this->_aMovimientos) OR !sizeof($this->_aMovimientos)) return NULL;
		if (!isset($this->_Idx_act)) return NULL;
		if (is_array($this->_aMovimientos[$this->_Idx_act]))
			return $this->_Idx_act;
		else return NULL;
	}

	/**
	  * Este metodo obtiene el anterior detalle al actualmente indicado por el puntero a las lineas de detalle.
	  * @param $bSetPointer	-	Booleano indicativo de si se ha de modificar el puntero a los detalles o no.
	  * @return idx or NULL	-	Si la operacion se ha realizado con exito.
	  **/
	function prevMove($bSetPointer = TRUE) 
	{
		if ($this->_fAsiento & ICEntry_LOCKED) {
			$this->error('ACENTRY_LOCKED');
			return NULL;
		}
		if (!is_array($this->_aMovimientos) OR !sizeof($this->_aMovimientos)) return NULL;
		if (!isset($this->_Idx_act)) return NULL;
		if (!isset($bSetPointer)) $bSetPointer = TRUE;
		$aKeys = array_keys($this->_aMovimientos);
		$continuar = TRUE;
		$retval = NULL;
		while ( ($key=array_pop($aKeys)) ) {
			if ($key < $this->_Idx_act) {
				if ($bSetPointer) $this->_Idx_act = $key;
				$retval = $key;
				break;
			}
		}
		return $retval;
	}

	/**
	  * Metodo encargado de devolver el puntero al ultimo detalle
	  * @param $bSetPointer	-	Booleano indicativo de si se ha de modificar el puntero a los detalles o no.
	  * @return idx or NULL	-	Si la operacion se ha realizado con exito.
	  **/
	function lastMove($bSetPointer = TRUE) 
	{
		if ($this->_fAsiento & ICEntry_LOCKED) {
			$this->error('ACENTRY_LOCKED');
			return NULL;
		}
		if (!isset($bSetPointer)) $bSetPointer = TRUE;
		if (is_array($this->_aMovimientos) AND sizeof($this->_aMovimientos)) {
			end($this->_aMovimientos);
			list($clave,$valor) = each($this->_aMovimientos);
			reset($this->_aMovimientos);
			if ($bSetPointer AND isset($clave)) $this->_Idx_act = $clave;
			if (!isset($clave)) $clave = NULL;
		} else $clave = NULL;
		return $clave;
	}

	/**
	  * Metodo encargado de anyadir una linea de detalle al asiento.
	  * @param 	$cc			-	Cuenta Contable contra la que se añadie el Importe deseado
	  * @param 	$importe		-	Importe que se añade a dicha Cuenta-Contable.
	  * @param 	$fTipo		-	Donde insertar el importe (debe, haber o Auto -dep de activo/pasivo-).
	  **/
	function addMove($cuenta_contable,$importe = 0,$fTipo = ICEntry_MOVE_AUTO) 
	{
		if ($this->_fAsiento & ICEntry_LOCKED) {
			$this->error('ACENTRY_LOCKED');
			return NULL;
		}

		if ($this->debug) debug("addMove($cuenta_contable,$importe,$fTipo)");
		// Obtenemos las condiciones de compra/venta:
		//Cambiar lo de compacto/extendido a una variable inicializada en el Constructor.
		$full_cc = $this->filterAccount($cuenta_contable,NULL,ICEntry_FILTER_COMPACT);
		$aTmp = split('\.',$full_cc);
		$pc = $aTmp[0];
		$cc = $aTmp[1];
		$plan_contable = $this->_zeroRightFill($pc,4);
		$cuenta_contable = $this->_zeroLeftFill($cc,6);
		$aCC = $this->dbfetchAccount($full_cc);
		if (!is_array($aCC)) {
			$this->error('ACENTRY_NOCC',array('cc' => $full_cc));
			return NULL;
		}

		$idx_det = $this->lastMove(FALSE);
		if (!is_numeric($idx_det)) $idx_det = 0;
		else $idx_det++;

		$this->_aMovimientos[$idx_det] = $aCC;
		$this->_aMovimientos[$idx_det]['id_plan_contable'] = $plan_contable;
		$this->_aMovimientos[$idx_det]['id_cuenta'] = $cuenta_contable;
		$fa = $this->getDate();
		if (!empty($fa)) $this->_aMovimientos[$idx_det]['fecha'] = $this->getDate();
		else $this->_aMovimientos[$idx_det]['fecha'] = date('d/m/Y H:i:s');

		$bAutoTax = FALSE;
		if (($fTipo & ICEntry_MOVE_AUTO)) {
			if ($this->debug) debug("addMove() en modo AUTO");
			if ((int)$aCC['activo']) {
				$this->_aMovimientos[$idx_det]['debe'] = $importe;
				$this->_aMovimientos[$idx_det]['haber'] = 0;
			} elseif ((int)$aCC['pasivo']) {
				$this->_aMovimientos[$idx_det]['haber'] = $importe;
				$this->_aMovimientos[$idx_det]['debe'] = 0;
			}
			$bAutoTax = TRUE;
		} elseif( $fTipo & ICEntry_MOVE_MUST ) {
			$this->_aMovimientos[$idx_det]['debe'] = $importe;
		} elseif( $fTipo & ICEntry_MOVE_HAVE ) {
			$this->_aMovimientos[$idx_det]['haber'] = $importe;
		} else {
			$this->_aMovimientos[$idx_det]['debe'] = 0;
			$this->_aMovimientos[$idx_det]['haber'] = 0;
		}
		$this->_aMovimientos[$idx_det]['saldo'] = ((double)$this->_aMovimientos[$idx_det]['debe']) - ((double)$this->_aMovimientos[$idx_det]['haber']);
		$this->_aMain['saldo_debe'] += $this->_aMovimientos[$idx_det]['debe'];
		$this->_aMain['saldo_haber'] += $this->_aMovimientos[$idx_det]['haber'];

		if ($this->_isTaxBase($plan_contable)) {
			// debug("Comprobado bases ");
			$this->_setTaxBase($idx_det,$bAutoTax);
		} elseif ($this->_isTax($plan_contable)) {
			// debug("Comprobado Impuestos. ");
			$this->_setTax($idx_det,$bAutoTax);
		} elseif ($this->isTaxContraAccount($plan_contable)) {
			$this->setTaxContraAccount($idx_det);
		}

		if (!is_array($this->_aIdxCCs[$plan_contable.$cuenta_contable])) 
			$this->_aIdxCCs[$plan_contable.$cuenta_contable] = array();
		if (!in_array(($idx_det),$this->_aIdxCCs[$plan_contable.$cuenta_contable]))
			array_push($this->_aIdxCCs[$plan_contable.$cuenta_contable],$idx_det);

		$this->_changeFlags(ICEntry_MAIN | ICEntry_MOVE | ICEntry_AC_MODIFIED | ICEntry_AC_DBCOMMIT,$idx_det);

		// Fixme: la comprobacion de ofertas molaria tenerlas en un solo query con un inner join
		// Buscar los descuentos del cliente por articulo y luego familia
		// Si el cliente no tiene descuento ni por articulo ni por familia se comprueba
		//	 primero las ofertas por articulo y luego las de familia (generales ambas)
		if ($bCheck_dtos) {
			//Aki seria lo suyo comprobar si hay IVAs asociados o no...
			// No son ivas asociados, si el plan pertenece al de algun libro, se registra en Movimiento_iva

			//if ($this->debug) 
				// print_r($aTmp);
		}

		/** **
		debug("--");
		debug("Detalle recien insertado");
		print_r($this->_aDetalles[$idx_det]);
		debug("--");
		/** **/
		return $idx_det;

	}

	/**
	  * Metodo encargado de borrar un detalle de las lineas de detalle del pedido.
	  * @param $idx_det	-	Identificador del detalle que se ha de borrar (caso de NULL el actualmente en uso).
	  * @param $bDtos		-	Comprueba se se han de comprobar las ofertas/promos a la hora de borrar.
	  * @return	bool		- 	Si la operacion se ha realizado con exito o no.
	  **/
	function delMove($idx_det = NULL,$mask = 0) {
		if ($this->_fAsiento & ICEntry_LOCKED) {
			$this->error('ACENTRY_LOCKED');
			return NULL;
		}
		if (!isset($idx_det)) $idx_det = $this->_DetIdx_act;

		if ($this->debug) debug(" del_detail($idx_det) ");
		if (!is_array($this->_aMovimientos[$idx_det])) return false;
		if ($this->debug) debug(" del_detail($idx_det) --> Existe! ");

		if ($this->_isTax($this->_aMovimientos[$idx_det]['id_plan_contable']) AND is_array($this->_aDiarioIVA[$idx_det])) {
			$this->_delTax($idx_det);
		} elseif ($this->_isTaxBase($this->_aMovimientos[$idx_det]['id_plan_contable']) AND 
				is_array($this->_aMovimientos[$idx_det]['idx_iva']) AND sizeof($this->_aMovimientos[$idx_det]['idx_iva'])) {
			if ($mask & ICEntry_MOVE_AUTO) {
				foreach ($this->_aMovimientos[$idx_det]['idx_iva'] as $idxiva) {
					// $idxiva = $this->_aMovimientos[$idx_det]['idx_iva'];
					if ($this->debug) debug("del_detail($idx_det) en modo AUTO...");
					$this->delMove($idxiva);
					if ($this->debug) debug("Borrando una bASe del iva $idxiva ...");
				}
			} else {
				if ($this->debug) debug("Borrando una Base de Un IVA sin modo AUTO");
				// $this->_delTax($idxiva);
				$this->_unlinkTaxFromBase($idxiva,$idx_det,TRUE);
			}
		}

		if ((int)$this->_aMovimientos[$idx_det]['id_movimiento']) {
			// Marcamos el registro para ser borrado de la base de datos.
			// $this->_aModif['detalles'][$idx_det] |= inmPed_DB_DELETE;
			// $this->_aModif['detalles'][$idx_det] |= inmPed_DB_COMMIT;

			// Estas modificaciones de indices.. seria mejor por un _build_indexes o por el changeFlags()
			// Aqui mejor lo restamos directamente de los saldos del asiento, en vez de guardarlo.
			array_push($this->_aModif['dbdel_det'],$this->_aMovimientos[$idx_det]['id_movimiento']);
			// Rompemos enlaces
			$this->_aIdxDB[$this->_aMovimientos[$idx_det]['id_movimiento']] = NULL;
			unset($this->_aIdxDB[$this->_aMovimientos[$idx_det]['id_movimiento']]);
			// $this->_aModif['dbdel_det'][$idx_det][cantidad_recibida] = $this->_aDetalles[$idx_det][cantidad_recibida];
		} else {
			debug("Movimiento($idx_det) no extraido de la bbdd, quitandole el commit");
			// Esto lo suyo es que se hiciese llamando al metodo _changeFlags (con un apoyo en _getFlags())
			$this->_aModif['detalles'][$idx_det] &= ~ICEntry_AC_DBCOMMIT;
		}

		// Actualizamos Saldos:
		$this->_aMain['saldo_debe'] -= $this->_aMovimientos[$idx_det]['debe'];
		$this->_aMain['saldo_haber'] -= $this->_aMovimientos[$idx_det]['haber'];
		$this->_aMain['saldo'] = $this->_aMain['saldo_debe'] - $this->_aMain['saldo_haber'];
		$this->_changeFlags(ICEntry_MAIN | ICEntry_AC_MODIFIED);

		if (is_array($this->_aIdxCCs[$this->_aMovimientos[$idx_det]['id_plan_contable'].$this->_aMovimientos[$idx_det]['id_cuenta']])) {
			if (in_array($idx_det,$this->_aIdxCCs[$this->_aMovimientos[$idx_det]['id_plan_contable'].$this->_aMovimientos[$idx_det]['id_cuenta']])) {
				$i = array_search($idx_det,$this->_aIdxCCs[$this->_aMovimientos[$idx_det]['id_plan_contable'].$this->_aMovimientos[$idx_det]['id_cuenta']]);
				if (is_numeric($i)) {
					$this->_aIdxCCs[$this->_aMovimientos[$idx_det]['id_plan_contable'].$this->_aMovimientos[$idx_det]['id_cuenta']][$i] = NULL;
					unset($this->_aIdxCCs[$this->_aMovimientos[$idx_det]['id_plan_contable'].$this->_aMovimientos[$idx_det]['id_cuenta']][$i]);
				}
			}
		}

		// Borramos el registro de las lineas de detalle. (moviendo si es preciso el puntero a los detalles).
		// Nos cepillamos los indices que apuntente a esta linea de detalle.
		$id_detalle = $this->_aDetalles[$idx_det][id_detalle];
		$this->_aDetIdx[$id_detalle] = NULL;
		unset($this->_aDetIdx[$id_detalle]);
		// $this->_aDetIdx_Art[$this->_aDetalles[$idx_det][id_articulo]] = array_diff(
		// 				$this->_aDetIdx_Art[$this->_aDetalles[$idx_det][id_articulo]],array($idx_det));

		$this->_aMovimientos[$idx_det] = NULL;
		unset($this->_aMovimientos[$idx_det]);

		$this->_changeFlags(ICEntry_MOVE | ICEntry_AC_DELETED );
	}

	function getMove($idx = NULL) {
		return $this->_aMovimientos[$idx];
	}

	/** FIN de los Metodos de NAVEGACION **/


	/** Metodos Set y Get **/
	// De Cabecera y Pie:

	function setAccountPeriod($id = NULL) {
		$oDb = $this->_db;
		$cons="SELECT ".
				"Ej.id_ejercicio as 'eje_id_ejercicio', ".
				"Ej.nombre as 'eje_nombre', ".
				"Ej.contador as 'eje_contador', ".
				"Ej.fecha_inicio as 'eje_fecha_inicio', ".
				"Ej.fecha_fin as 'eje_fecha_fin', ".
				"Ej.id_asiento_apertura as 'eje_id_asiento_apertura', ".
				"Ej.id_asiento_cierre as 'eje_id_asiento_cierre', ".
				"E.id_empresa as 'emp_id_empresa', ".
				"E.razon_social as 'emp_razon_social', ".
				"E.cif as 'emp_cif', ".
				"E.nombrecorto as 'emp_nombrecorto' ".
				'FROM Ejercicios Ej '.
				'LEFT JOIN Empresas E ON (Ej.id_empresa=E.id_empresa) '.
				'WHERE '.
				( (is_numeric($id))
				  ?  'Ej.id_ejercicio = '.$id
				  :  'Ej.fecha_inicio < NOW() '
				).' ORDER BY fecha_inicio desc LIMIT 1';
		$idrs = $oDb->query($cons);
		if (!$oDb->num_rows($idrs)) return false;
		$aRec = $oDb->fetch_assoc($idrs);
		foreach($aRec as $clave => $valor) {
			$ref_arr = substr($clave,0,4);
			$ref_resto = substr($clave,4);
			if (!strcasecmp($ref_arr,'aso_')) {
				$this->_aMain[$ref_resto] = $valor;
			} elseif (!strcasecmp($ref_arr,'eje_')) {
				$this->_aEjercicio[$ref_resto] = $valor;
			} elseif (!strcasecmp($ref_arr,'emp_')) {
				$this->_aEmpresa[$ref_resto] = $valor;
			}
		}
		$oDb->libera($idrs);
		$this->_fAsiento &= ~ICEntry_BLOCKALL;
		$this->_fAsiento &= ~ICEntry_LOCKED;
		$this->_aCfg['id_ejercicio'] = $this->_aEjercicio['id_ejercicio'];
		$this->_aMain['id_ejercicio'] = $this->_aCfg['id_ejercicio'];
	}

	function setReference($num = NULL) {
		if ($this->_fAsiento & ICEntry_LOCKED) {
			$this->error('ACENTRY_LOCKED');
			return false;
		}

		$retval = true;
		if (!is_numeric($num) OR empty($num)) {
			$cons = 'SELECT contador FROM Ejercicios WHERE id_ejercicio = '.$this->_aEjercicio['id_ejercicio'];
			$consupt = 'UPDATE Ejercicios SET contador=contador+1 WHERE id_ejercicio = '.$this->_aEjercicio['id_ejercicio'];
			$tmprs = $this->_db->query($cons);
			if ($this->_db->num_rows($tmprs)) {
				$aTmp = $this->_db->fetch_assoc($tmprs);
				$this->_aMain['numero'] = $aTmp['contador'];
				$this->_changeFlags(ICEntry_MAIN | ICEntry_AC_MODIFIED);
				$this->_db->query($consupt);
			} else $retval = false;
			$this->_db->libera($tmprs);
		} else {
			$num = (int)$num;
			$this->_aMain['numero'] = $num;
			if ($this->_aEjercicio['contador'] <= $num) {
				$cons = 'UPDATE Ejercicios SET contador=IF(contador<='.$num.','.($num+1).',contador) WHERE id_ejercicio = '.$this->_aEjercicio['id_ejercicio'];
				$this->_db->query($cons);
			}
		}

		return $retval;
	}

	function getReference() {
		return $this->_aMain['numero'];
	}

	function getIdxFromAccount($cc) {
		if (empty($cc)) return NULL;
		else return $this->_aIdxCCs[$this->filterAccount($cc,NULL,ICEntry_FILTER_EXTENDED)];
	}

	function getIdxFromDbId($dbid) {
		if (empty($dbid)) return NULL;
		else return $this->_aIdxDB[$dbid];
	}

	function getCfg($name = NULL) {
		if (empty($name)) return $this->_aCfg;
		else return $this->_aCfg[$name];
	}

	function setDocument($texto) {
		if (empty($texto)) return FALSE;
		if (!strcmp($this->_aMain['documento'],$texto)) return FALSE;
		if ($this->debug) debug("setDocument");
		$this->_aMain['documento'] = $texto;
		$this->_changeFlags(ICEntry_MAIN | ICEntry_AC_DBCOMMIT);
		return TRUE;
	}

	function getDocument() {
		return $this->_aMain['documento'];
	}

	function setInvoice($id_fra) {
	   if (!is_numeric($id_fra)) return false;
		if ($this->_aMain['factura_gestion'] == $id_fra) return true;
		$this->_aMain['factura_gestion'] = $id_fra;
		$this->_changeFlags(ICEntry_MAIN | ICEntry_AC_DBCOMMIT);
		return TRUE;
	}

	function getInvoice() {
		return $this->_aMain['factura_gestion'];
	}

	function setName($nombre = NULL) {
		if (empty($nombre)) return FALSE;
		if (!strcmp($this->_aMain['nombre'],$nombre)) return FALSE;
		if ($this->debug) debug("setName");
		$this->_aMain['nombre'] = $nombre;
		$this->_changeFlags(ICEntry_MAIN | ICEntry_AC_DBCOMMIT);
		return TRUE;
	}

	function getName($nombre = NULL) {
		return $this->_aMain['nombre'];
	}

	function setDate($fecha = NULL) {
		if (empty($fecha)) return false;
		if (wol_db::formatear_fecha($fecha) == wol_db::formatear_fecha($this->_aMain['fecha_apertura'])) 
			return false;
		if ($this->debug) debug("setDate $fecha ".$this->_aMain['fecha_apertura']);
		$this->_aMain['fecha_apertura'] = $fecha;
		$this->_changeFlags(ICEntry_MAIN | ICEntry_AC_DBCOMMIT);
		return true;
	}

	function getDate() {
		return $this->_aMain['fecha_apertura'];
	}

	function setOpenningDate($fecha = NULL) {
		return $this->setDate($fecha);
	}

	function getOpenningDate() {
		return $this->getDate();
	}

	function setFechaApertura($fecha = NULL) {
		if (empty($fecha)) $fecha = date('Y-m-d H:i:s');
		return $this->setDate($fecha);
	}

	function getFechaApertura() {
		return $this->getDate();
	}

	function setDescription($texto = NULL) {
		if (empty($texto)) return FALSE;
		if (!strcasecmp($this->_aMain['descripcion'],$texto)) return FALSE;
		$this->_aMain['descripcion'] = $texto;
		$this->_changeFlags(ICEntry_MAIN | ICEntry_AC_DBCOMMIT);
	}

	function getDescription() {
		return $this->_aMain['descripcion'];
	}

	function setId() {
		debug("el setId pa que?");
	}

	function getId() {
		return $this->_aMain['id_asiento'];
	}

	function setMode($mask = 0) {
		if ( !($mask & ($this->_fTipo)) ) { // Si cambia el tipo, rompemos enlace entre IVAs y cta-contrapartida de ivas
			if (is_numeric($this->_aIdxIVA['idx_contra_apuntesiva']) AND
				!$this->isTaxContraAccount($this->_aIdxIVA['idx_contra_apuntesiva'])) {
				if ($this->debug) debug("Limpiando la cuenta de contrapartida ... ");
				$this->_aIdxIVA['idx_contra_apuntesiva'] = NULL;
			}
		}
		$this->_fTipo |= $mask;
	}

	function getMode() {
		return $this->_fTipo;
	}

	function addMark($id) {
		if (!is_numeric($id)) return FALSE;
		if (is_array($this->_aMarks[$id]) AND sizeof($this->_aMarks[$id])) {
			if ( ($this->_aMain['punteo'] & $this->_aMarks[$id]['mascara']) ) return TRUE;
			else {
				$this->_aMain['punteo'] |= $this->_aMarks[$id]['mascara'];
				$this->_changeFlags(ICEntry_MAIN | ICEntry_AC_DBCOMMIT);
				return TRUE;
			}
		}
		$oDb = $this->_db;

		$retval = FALSE;
		// Obteniendo los Marcadores que Existen.
		$cons="SELECT ".
				"M.id_marcador as 'id_marcador', ".
				"M.mascara as 'mascara', ".
				"M.imagen as 'imagen', ".
				"M.nombre as 'nombre' ".
				"FROM Marcadores as `M` ".
				"WHERE M.id_marcador = $id AND M.mascara != 0";
		$idrs = $oDb->query($cons);
		if ($oDb->num_rows($idrs)) {
			while ($aTmp = $oDb->fetch_assoc($idrs)) {
				settype($aTmp['mascara'],'int');
				$this->_aMarks[$aTmp['id_marcador']] = $aTmp;
				$this->_aMain['punteo'] |= $aTmp['mascara'];
				$this->_changeFlags(ICEntry_MAIN | ICEntry_AC_DBCOMMIT);
				$retval = TRUE;
			}
		} 
		$oDb->libera($idrs);

		return $retval;
	}

	function delMark($id) {
		if (!is_numeric($id)) return FALSE;
		if (!is_array($this->_aMarks[$id]) OR !sizeof($this->_aMarks[$id]) ) return FALSE;

		$this->_aMain['punteo'] &= ~$this->_aMarks[$id]['mascara'];
		$this->_changeFlags(ICEntry_MAIN | ICEntry_AC_DBCOMMIT);
		return TRUE;
	}

	function getMark($id = NULL) {
		if (is_numeric($id)) {
			if (!is_array($this->_aMarks[$id]) OR !sizeof($this->_aMarks[$id]) OR
					!($this->_aMain['punteo'] & $this->_aMarks[$id]['mascara']) ) return NULL;
			else return $this->_aMarks[$id];
		} else {
			if (!is_array($this->_aMarks) OR !sizeof($this->_aMarks)) return NULL;
			$aRetVal = array();
			foreach ($this->_aMarks as $id => $aM) {
				if ( ($this->_aMain['punteo'] & $aM['mascara']) )
					$aRetVal[$aM['id_marcador']] = $aM;
			}
		}
		return $aRetVal;
	}

	function getBalance() {
		return $this->_aMain['saldo'];
	}

	function addDiary($id_diario,$canal = 0) {
		if (!is_numeric($id_diario)) return FALSE;
		if (is_array($this->_aDiarios[$id_diario]) AND sizeof($this->_aDiarios[$id_diario]) AND 
				!($this->_aModif['diarios'][$id_diario] & ICEntry_AC_DELETED) ) return FALSE;
		if (!is_numeric($canal)) $canal = 0;
		$oDb = $this->_db;

		$cons="SELECT ".
				"D.id_diario as 'id_diario', ".
				"D.nombre as 'nombre', ".
				"D.cuadrar_iva as 'cuadrar_iva' ".
				"FROM Diario `D` ".
				"WHERE D.id_diario = ".$id_diario;
		$idrs = $oDb->query($cons);
		if ($oDb->num_rows($idrs)) {
			$aD = $oDb->fetch_assoc($idrs);
			$aD['canal'] = $canal;
			$this->_aDiarios[$aD['id_diario']] = $aD;
			$this->_changeFlags(ICEntry_DIARY | ICEntry_AC_MODIFIED,$id_diario);
		}
		$oDb->libera($idrs);
		return TRUE;
	}

	function delDiary($id_diario) {
		if (!is_numeric($id_diario)) return FALSE;
		if (!is_array($this->_aDiarios[$id_diario]) OR !sizeof($this->_aDiarios[$id_diario]) ) return FALSE;

		$this->_changeFlags(ICEntry_DIARY | ICEntry_AC_DELETED,$id_diario);
		return TRUE;
	}

	function setDiary($id_diario,$canal = 0) {
		if (!is_numeric($id_diario)) return FALSE;
		if (!is_array($this->_aDiarios[$id_diario]) OR !sizeof($this->_aDiarios[$id_diario]) OR
				($this->_aModif['diarios'][$id_diario] & ICEntry_AC_DELETED) ) return FALSE;
		if (!is_numeric($canal)) $canal = 0;
		if ($this->_aDiarios[$id_diario]['canal'] != $canal) {
			$this->_aDiarios[$id_diario]['canal'] = $canal;
			$this->_changeFlags(ICEntry_DIARY | ICEntry_AC_DBCOMMIT,$id_diario);
		}
		return TRUE;
	}

	function getDiary($id = NULL) {
		if (is_numeric($id)) {
			if (!is_array($this->_aDiarios[$id_diario]) OR !sizeof($this->_aDiarios[$id_diario]) OR
					($this->_aModif['diarios'][$id_diario] & ICEntry_AC_DELETED) ) return NULL;
			else return $this->_aDiarios[$id_diario];
		} else {
			if (!is_array($this->_aDiarios) OR !sizeof($this->_aDiarios)) return NULL;
			$aRetVal = array();
			foreach ($this->_aDiarios as $id => $aD) {
				if (! ($this->_aModif['diarios'][$id] & ICEntry_AC_DELETED) )
					array_push($aRetVal,$this->_aDiarios[$id]);
			}
		}
		return $aRetVal;
	}


	/**
	  * Comprueba si el PlanContable indicado es alguno de cliente/proveedor (cc_clientes cc_proveedores o cc_acreedores)
	  **/
	function isTaxContraAccount($plan_contable){
		if (empty($plan_contable)) return FALSE;
		$aTmp = $this->filterAccount($plan_contable,NULL,(ICEntry_FILTER_EXTENDED | ICEntry_FILTER_ARRAY));
		$cc = $aTmp[0];

		$aCtas = array();
		if ($this->getMode() & ICEntry_MODE_SALE) {
			array_push($aCtas,'cc_clientes');
		} elseif ($this->getMode() & ICEntry_MODE_BUY) {
			array_push($aCtas,'cc_proveedores');
			array_push($aCtas,'cc_acreedores');
		} else {
			array_push($aCtas,'cc_clientes');
			array_push($aCtas,'cc_proveedores');
			array_push($aCtas,'cc_acreedores');
		}

		$retval = FALSE;
		if (sizeof($aCtas)>0) 
			foreach ($aCtas as $var) 
				if ($this->_aCfg[$var] == $cc) {
					$retval = TRUE;
					break;
				}

		// debug("isTaxContraAccount() Comprobando contrapartida en $plan_contable :: ".$retval);

		return $retval;
	}

	/**
	  * Con este metodo indicamos cual es la cuenta de contrapartida de todos los ivas, es decir, a quien se repercute o soporta.
	  **/
	function setTaxContraAccount($idx) {
		if (!is_array($this->_aMovimientos[$idx])) return FALSE;
		$plan_contable = $this->_aMovimientos[$idx]['id_plan_contable'];
		if (empty($plan_contable)) return FALSE;
		$aTmp = $this->filterAccount($plan_contable,NULL,(ICEntry_FILTER_EXTENDED | ICEntry_FILTER_ARRAY));
		$cc = $aTmp[0];

		$aCtas = array();
		if ($this->getMode() & ICEntry_MODE_SALE) {
			array_push($aCtas,'cc_clientes');
		} elseif ($this->getMode() & ICEntry_MODE_BUY) {
			array_push($aCtas,'cc_proveedores');
			array_push($aCtas,'cc_acreedores');
		} else {
			array_push($aCtas,'cc_clientes');
			array_push($aCtas,'cc_proveedores');
			array_push($aCtas,'cc_acreedores');
		}

		$retval = FALSE;
		if (sizeof($aCtas)>0) 
			foreach ($aCtas as $var) 
				if ($this->_aCfg[$var] == $cc) {
					if (!is_numeric($this->_aIdxIVA['idx_contra_apuntesiva'])) {
						$retval = true;
						if ($this->getMode() & ICEntry_MODE_AUTO) {
							if (!strcasecmp($var,'cc_clientes')) $this->setMode(ICEntry_MODE_SALE);
							else $this->setMode(ICEntry_MODE_BUY);
						}
						$this->_aIdxIVA['idx_contra_apuntesiva'] = $idx;
						$this->_changeFlags(ICEntry_TAXMOVE | ICEntry_AC_DBCOMMIT,-1);
					}
					break;
				}

		if ($this->debug) {
			if ($retval) debug("setTaxContraAccount($idx) Establecido ContraPartida de IVAs");
			else debug("setTaxContraAccount($idx) NO establecido como Contra-Partida ..");
		}
		return $retval;

	}

	function getTaxContraAccount() {
		if (!is_numeric($this->_aIdxIVA['idx_contra_apuntesiva'])) return NULL;
		else return $this->_aIdxIVA['idx_contra_apuntesiva'];
	}
	
	function delTaxContraAccount() {
		if ($this->debug) debug("BORRANDO cuenta base de cotizaciones de IVA");
		$this->_aIdxIVA['idx_contra_apuntesiva'] = NULL;
	}


	// De Escandallo:
	function getMust($idx) {
		return $this->_aMovimientos[$idx]['debe'];
	}

	function getHave($idx) {
		return $this->_aMovimientos[$idx]['haber'];
	}

	function setAmount($idx_det,$importe,$fTipo = ICEntry_MOVE_AUTO,$bSuma = FALSE) {
		if (!is_numeric($importe)) $importe = 0;
		if ($this->_fAsiento & ICEntry_LOCKED) {
			$this->error('ACENTRY_LOCKED');
			return NULL;
		}
		debug("setAmount($idx_det)");
		if (!is_array($this->_aMovimientos[$idx_det])) return FALSE;

		if (!$bSuma) $bSuma = FALSE;
		if ($this->debug) debug("setAmmount de idx($idx_det) = $importe");
			  
		$old_debe = $this->_aMovimientos[$idx_det]['debe'];
		$old_haber = $this->_aMovimientos[$idx_det]['haber'];
		// debug("olddebe = $old_debe , haber = $old_haber");
		if (($fTipo & ICEntry_MOVE_AUTO)) {
			if (!empty($old_debe) OR (int)$this->_aMovimientos[$idx_det]['activo']) {
			 	$this->_aMovimientos[$idx_det]['debe'] = ( ($bSuma) 
					  ? $this->_aMovimientos[$idx_det]['debe'] : 0 ) + $importe;
				$base = $this->_aMovimientos[$idx_det]['debe'];
			} elseif (!empty($old_haber) OR (int)$this->_aMovimientos[$idx_det]['pasivo']) {
				$this->_aMovimientos[$idx_det]['haber'] = ( ($bSuma)
					  ? $this->_aMovimientos[$idx_det]['haber'] : 0 ) + $importe;
				$base = $this->_aMovimientos[$idx_det]['haber'];
			}
			if (is_numeric($base) AND is_array($this->_aMovimientos[$idx_det]['idx_iva']) 
						AND sizeof($this->_aMovimientos[$idx_det]['idx_iva'])) {
				foreach ($this->_aMovimientos[$idx_det]['idx_iva'] as $idxiva) {
					//$idxiva = $this->_aMovimientos[$idx_det]['idx_iva'];
					$this->_setTaxAmount($idxiva,$base);
				}
			} elseif (is_numeric($base) AND $this->_isTax($this->_aMovimientos[$idx_det]['id_plan_contable'])) {
				// debug("Establecemos la cuota a pincho... vale?");
				$this->_setTaxAmount($idxiva,NULL,$base);
			}
		} elseif( $fTipo & ICEntry_MOVE_MUST ) {
			$this->_aMovimientos[$idx_det]['debe'] = ( ($bSuma)
					  ? $this->_aMovimientos[$idx_det]['debe'] : 0 ) + $importe;
		} elseif( $fTipo & ICEntry_MOVE_HAVE ) {
			$this->_aMovimientos[$idx_det]['haber'] = ( ($bSuma)
					  ? $this->_aMovimientos[$idx_det]['haber'] : 0 ) + $importe;
		}

		if ($old_debe != $this->_aMovimientos[$idx_det]['debe'] OR $old_haber != $this->_aMovimientos[$idx_det]['haber']) {
			$this->_aMovimientos[$idx_det]['saldo'] = ((double)$this->_aMovimientos[$idx_det]['debe']) - ((double)$this->_aMovimientos[$idx_det]['haber']);
			$this->_aMain['saldo_debe'] += ($this->_aMovimientos[$idx_det]['debe'] - $old_debe);
			$this->_aMain['saldo_haber'] += ($this->_aMovimientos[$idx_det]['haber'] - $old_haber);
			$this->_changeFlags(ICEntry_MOVE | ICEntry_AC_MODIFIED,$idx_det);
		}

		return TRUE;
	}

	function getAmount($idx,$fTipo = ICEntry_MOVE_AUTO) {
		if (($fTipo & ICEntry_MOVE_AUTO)) {
			$retval = NULL;
			if ((int)$this->_aMovimientos[$idx_det]['activo']) {
			 	$retval = $this->_aMovimientos[$idx_det]['debe'];
			} elseif ((int)$this->_aMovimientos[$idx_det]['pasivo']) {
			 	$retval = $this->_aMovimientos[$idx_det]['haber'];
			}
		} elseif( $fTipo & ICEntry_MOVE_MUST ) {
			$retval = $this->_aMovimientos[$idx_det]['debe'];
		} elseif( $fTipo & ICEntry_MOVE_HAVE ) {
			$retval = $this->_aMovimientos[$idx_det]['haber'];
		}

		if (empty($retval) AND $fTipo & ICEntry_MOVE_AUTO) {
			if (empty($this->_aMovimientos[$idx]['debe']))
				$retval = $this->_aMovimientos[$idx]['haber'];
			else 
				$retval = $this->_aMovimientos[$idx]['debe'];
		}
		return $retval;
	}

	function setConcept($idx,$texto = NULL) {
		if ($this->_fAsiento & ICEntry_LOCKED) {
			$this->error('ACENTRY_LOCKED');
			return NULL;
		}
		if (!is_array($this->_aMovimientos[$idx])) return FALSE;
		if (!strcmp($texto,$this->_aMovimientos[$idx]['concepto'])) return TRUE;

		$this->_aMovimientos[$idx]['concepto'] = $texto;
		if ($this->_isTax($this->_aMovimientos[$idx]['id_plan_contable']) AND is_array($this->_aDiarioIVA[$idx])) {
			$this->_aDiarioIVA[$idx]['concepto'] = $texto;
			$this->_changeFlags(ICEntry_TAXMOVE | ICEntry_AC_DBCOMMIT,$idx);
		}
		$this->_changeFlags(ICEntry_MOVE | ICEntry_AC_DBCOMMIT,$idx);
		return TRUE;
	}

	function getConcept($idx) {
		if ($this->_fAsiento & ICEntry_LOCKED) {
			$this->error('ACENTRY_LOCKED');
			return NULL;
		}
		if (!is_array($this->_aMovimientos[$idx])) return NULL;
		return $this->_aMovimientos[$idx]['concepto'];
	}
	
	function setMoveDate($idx,$fecha = NULL) {
		if ($this->_fAsiento & ICEntry_LOCKED) {
			$this->error('ACENTRY_LOCKED');
			return NULL;
		}
		if (!is_array($this->_aMovimientos[$idx])) return FALSE;
		if (wol_db::formatear_fecha($fecha) == wol_db::formatear_fecha($this->_aMovimientos[$idx]['fecha'])) 
			return TRUE;

		$this->_aMovimientos[$idx]['fecha'] = $fecha;
		$this->_changeFlags(ICEntry_MOVE | ICEntry_AC_DBCOMMIT,$idx);
		return TRUE;
	}

	function getMoveDate($idx) {
		if ($this->_fAsiento & ICEntry_LOCKED) {
			$this->error('ACENTRY_LOCKED');
			return NULL;
		}
		if (!is_array($this->_aMovimientos[$idx])) return NULL;
		return $this->_aMovimientos[$idx]['fecha'];
	}

	function getMoveBalance($idx) {
		return $this->_aMovimientos[$idx]['saldo'];
	}

	/**
	  * Metodo encargado de modificar la CC de una linea de detalle del asiento.
	  * @param 	$idx					-	Indice de detalle que se desea modificar
	  * @param 	$cuenta_contable	-	Cuenta Contable nueva a poner.
	  * @param 	$fTipo				-	Donde insertar el importe (Auto o No ).
	  * @return bool					- Si la operacion se ha realizado con exito
	  **/
	function setCC($idx,$cuenta_contable,$fTipo = 0) 
	{
		if ($this->_fAsiento & ICEntry_LOCKED) {
			$this->error('ACENTRY_LOCKED');
			return FALSE;
		}
		if ($this->debug) debug("setCC($idx,$cuenta_contable,$fTipo)");

		// Obtenemos las condiciones de compra/venta:
		//Cambiar lo de compacto/extendido a una variable inicializada en el Constructor.
		$full_cc = $this->filterAccount($cuenta_contable,NULL,ICEntry_FILTER_COMPACT);

		$plan_contable = $this->_zeroRightFill($pc,4);
		$cuenta_contable = $this->_zeroLeftFill($cc,6);
		$aCC = $this->dbfetchAccount($full_cc);
		if (!is_array($aCC)) {
			$this->error('ACENTRY_NOCC',array('cc' => $full_cc));
			return FALSE;
		}

		$idx_det = $idx;
		$aMov = $this->getMove($idx_det);
		if (!is_array($aMov)) return FALSE;

		/** **/
		debug("Borrando ? ..");
		// Borrar los IVAs relacionados con este idx.
		if ($this->_isTax($this->_aMovimientos[$idx_det]['id_plan_contable']) AND is_array($this->_aDiarioIVA[$idx_det])) {
			debug("Es un impuesto ...");
			$this->_delTax($idx_det);
		} elseif ($this->_isTaxBase($this->_aMovimientos[$idx_det]['id_plan_contable']) AND 
				is_array($this->_aMovimientos[$idx_det]['idx_iva']) AND sizeof($this->_aMovimientos[$idx_det]['idx_iva']) ) {
			debug("Tiene un impuesto asociado ..");
			if ($fTipo & ICEntry_MOVE_AUTO) {
				if ($this->debug) debug("del_detail($idx_det) en modo AUTO...");
				foreach ($this->_aMovimientos[$idx_det]['idx_iva'] as $idxiva) {
					// $idxiva = $this->_aMovimientos[$idx_det]['idx_iva'];
					$this->delMove($idxiva);
					if ($this->debug) debug("Borrando una bASe del iva $idxiva ...");
				}
			} else {
				if ($this->debug) debug("Borrando una Base de Un IVA sin modo AUTO");
				// $this->_delTax($idxiva);
				$this->_unlinkTaxFromBase($idxiva,$idx_det,TRUE);
			}
		}
		/** **/
		if (is_array($this->_aIdxCCs[$this->_aMovimientos[$idx_det]['id_plan_contable'].$this->_aMovimientos[$idx_det]['id_cuenta']])) {
			if (in_array($idx_det,$this->_aIdxCCs[$this->_aMovimientos[$idx_det]['id_plan_contable'].$this->_aMovimientos[$idx_det]['id_cuenta']])) {
				$i = array_search($idx_det,$this->_aIdxCCs[$this->_aMovimientos[$idx_det]['id_plan_contable'].$this->_aMovimientos[$idx_det]['id_cuenta']]);
				if (is_numeric($i)) {
					$this->_aIdxCCs[$this->_aMovimientos[$idx_det]['id_plan_contable'].$this->_aMovimientos[$idx_det]['id_cuenta']][$i] = NULL;
					unset($this->_aIdxCCs[$this->_aMovimientos[$idx_det]['id_plan_contable'].$this->_aMovimientos[$idx_det]['id_cuenta']][$i]);
				}
			}
		}

		foreach ($aCC as $clave => $valor)
			$this->_aMovimientos[$idx_det][$clave] = $valor;

		// print_r($this->_aMovimientos[$idx_det]);
		$bAutoTax = FALSE;
		if (($fTipo & ICEntry_MOVE_AUTO)) {
			$bAutoTax = TRUE;
		}
		// Anyadir los ivas si le corresponden:
		if ($this->_isTaxBase($this->_aMovimientos[$idx_det]['id_plan_contable'])) {
			debug("Comprobando bases ".$bAutoTax);
			$this->_setTaxBase($idx_det,$bAutoTax);
		} elseif ($this->_isTax($this->_aMovimientos[$idx_det]['id_plan_contable'])) {
			debug("Comprobando Impuestos. ");
			$this->_setTax($idx_det,$bAutoTax);
		} elseif ($this->isTaxContraAccount($this->_aMovimientos[$idx_det]['id_plan_contable'])) {
			$this->setTaxContraAccount($idx_det);
		}

		$this->_changeFlags( ICEntry_MOVE | ICEntry_AC_DBCOMMIT,$idx);

		if (!is_array($this->_aIdxCCs[$this->_aMovimientos[$idx_det]['id_plan_contable'].$this->_aMovimientos[$idx_det]['id_cuenta']])) 
			$this->_aIdxCCs[$this->_aMovimientos[$idx_det]['id_plan_contable'].$this->_aMovimientos[$idx_det]['id_cuenta']] = array();
		if (!in_array(($idx_det),$this->_aIdxCCs[$this->_aMovimientos[$idx_det]['id_plan_contable'].$this->_aMovimientos[$idx_det]['id_cuenta']]))
			array_push($this->_aIdxCCs[$this->_aMovimientos[$idx_det]['id_plan_contable'].$this->_aMovimientos[$idx_det]['id_cuenta']],$idx_det);

		return TRUE;

	}

	function getCC($idx) {
		if (!is_array($this->_aMovimientos[$idx]) OR !sizeof($this->_aMovimientos[$idx])) return NULL;
		return $this->_aMovimientos[$idx]['cuenta_contable_formateada'];
	}


	/** FIN de los metodos Set y Get **/


	/** Metodos OPERATIVOS **/

	function delete() {
		$this->_changeFlags(ICEntry_MAIN | ICEntry_AC_DELETED);
		return true;
	}

	function isDeleted() {
		if ($this->_aFlags['main'] & ICEntry_AC_DELETED) return TRUE;
		else return FALSE;
	}


	/**
	  * @param $pc		-	PlanContable
	  * @param $cc		-	CuentaContable
	  * @param $tipo	-	1=Compacto; 0=Extendido; 2=Extendido en Array; 3=Compacto en Array
	  */
	function filterAccount($pc,$cc = NULL,$tipo = 1) {
		$retval = NULL;

		if (is_numeric($pc)) $Args[0] = $pc;
		if (is_numeric($cc)) $Args[1] = $cc;

		if (!is_numeric($tipo)) return NULL;
		else {
			if ($tipo & ICEntry_FILTER_ARRAY ) {
				$inarray = TRUE;
			} else $inarray = FALSE;
		}
		$tipo &= ~ICEntry_FILTER_ARRAY;

		switch($tipo) {
			case ICEntry_FILTER_EXTENDED: // Modo extendido
				if (sizeof($Args) > 1) {
					// Extendemos la nuemracion del plan contable
					$Args[0] = AccountEntry::_zeroRightFill(ltrim($Args[0],'0'),4);
					// Extendemos el numero de cuenta contable
					$Args[1] = AccountEntry::_zeroLeftFill($Args[1],6);
					if ($inarray) {
						$retval[0] = $Args[0];
						$retval[1] = $Args[1];
					} else $retval = $Args[0].$Args[1];
				} elseif (strstr($Args[0],'.')) {
					$aTmp = split('\.',$Args[0]);
					if ($inarray) {
						$retval[0] = AccountEntry::_zeroRightFill($aTmp[0],4);
						$retval[1] = AccountEntry::_zeroLeftFill($aTmp[1],6);
					} else $retval = AccountEntry::_zeroRightFill($aTmp[0],4).AccountEntry::_zeroLeftFill($aTmp[1],6);
				} else {
					$pc = AccountEntry::_zeroRightFill(substr(ltrim($Args[0],'0'),0,4),4);
					$cc = AccountEntry::_zeroLeftFill(substr(ltrim($Args[1],'0'),4),6);
					if (!is_numeric($cc)) {
						if (strlen($Args[0]) <= 6)
							$cc = '000000';
						else {
							$cc = AccountEntry::_zeroLeftFill(substr($Args[0],6,4),6);
						}
					}
					if ($inarray) {
						$retval[0] = $pc;
						$retval[1] = $cc;
					} else $retval = $pc.$cc;
				}
				break;

			case ICEntry_FILTER_COMPACT: // Modo Compacto
				if (sizeof($Args) > 1) {
					$Args[0] = trim($Args[0],'0');
					$Args[1] = ltrim($Args[1],'0');
					if ($inarray) {
						$retval[0] =  $Args[0];
						$retval[1] = ((is_numeric($Args[1])) ? $Args[1] : '0');
					} else $retval = $Args[0].'.'.((is_numeric($Args[1])) ? $Args[1] : '0');
				} elseif (strstr($Args[0],'.')) {
					$aTmp = split('\.',$Args[0]);
					if ($inarray) {
						$retval[0] = trim($aTmp[0],'0');
						$retval[1] = (((int)$aTmp[1]) ? ltrim($aTmp[1],'0') : $aTmp[1]);
					} else $retval = trim($aTmp[0],'0').'.'.(((int)$aTmp[1]) ? ltrim($aTmp[1],'0') : $aTmp[1]);
				} elseif (strlen($Args[0])>4) {
					$pc = trim(substr($Args[0],0,4),"0");
					$cc = substr($Args[0],4);
					if ((int)$cc) $cc = ltrim($cc,"0");
					else $cc = substr($Args[0],4,1);
					if ($inarray)  {
						$retval[0] = $pc;
						$retval[1] = $cc;
					} else $retval = $pc.'.'.$cc;
				} else {
					if ($inarray) {
						$retval[0] = trim($Args[0],"0");
						$retval[1] = '0';
					} else $retval = trim($Args[0],"0").'.0';
				}
				break;
		}
		return $retval;
	}

	function dbFetchAccount($cuenta,$bCreate = false,$nombre = NULL,$oDb = NULL) {
		if (empty($cuenta)) return NULL;
		$cta = AccountEntry::filterAccount($cuenta,NULL,ICEntry_FILTER_EXTENDED);
		if (is_null($cta)) return NULL;

		if (!is_a($oDb,'wol_db')) {
			$oDb = $this->_db;
			if (!is_object($oDb)) return NULL;
		}
		$id_empresa = $this->_aEmpresa['id_empresa'];
		if (!is_numeric($id_empresa)) return NULL;

		list($pc,$cc) = AccountEntry::filterAccount($cuenta,NULL,ICEntry_FILTER_EXTENDED | ICEntry_FILTER_ARRAY);

		$cons = "SELECT ".
					"CC.nombre as 'nombre_cuenta', ".
					"CC.id_cuenta as 'cuenta_contable', ".
					"CC.id_cuenta as 'id_cuenta', ".
					"PC.nombre as 'nombre_plan_contable', ".
					"PC.id_plan_contable as 'plan_contable', ".
					"PC.id_plan_contable as 'id_plan_contable', ".
					"IF(PC.activo_pasivo = 0,'activo','pasivo') as 'tipo_cuenta' ".
					"FROM Plan_general_contable `PC`, Cuenta_contable `CC` ".
					"WHERE PC.id_plan_contable = CC.id_plan_contable AND ".
					"CC.id_plan_contable = $pc AND CC.id_cuenta = $cc AND CC.id_empresa = $id_empresa ";
		$idrs = $oDb->query($cons);
		if (!$oDb->num_rows($idrs) AND !$bCreate) return NULL;
		elseif (!$oDb->num_rows($idrs)) {
			if (empty($nombre)) $nombre = $pc.$cc;
			$oDb->tb_insert('Cuenta_contable',array('id_empresa' => $id_empresa,'id_cuenta' => $cc,'id_plan_contable' => $pc,'nombre' => $nombre));
			$aTmp['plan_contable'] = $pc;
			$aTmp['cuenta_contable'] = $cc;
		}
		$aTmp = $oDb->fetch_assoc($idrs);

		if (!strcasecmp($aTmp['tipo_cuenta'],'activo')) $aTmp['activo'] = true;
		elseif (!empty($aTmp['tipo_cuenta'])) $aTmp['pasivo'] = true;

		$cuenta_formateada = AccountEntry::filterAccount($aTmp['plan_contable'].$aTmp['cuenta_contable'],NULL,(int)$this->_aCfg['notacion_cc']);
		$aTmp['cuenta_contable_formateada'] = $cuenta_formateada;

		return $aTmp;
	}

	function dbFill($id = NULL,$num = NULL) {
		if (!is_objecT($this->_db)) return false;
		if (!(int)$id AND !(int)$num) return false;
		$oDb = $this->_db;
		if ($this->debug) debug("dbFill($id)");

		if (empty($id)) {
			$id = NULL;
			$num = (int)$num;
		} else {
			$num = NULL;
			$id = (int)$id;
		}

		$cons="SELECT ".
				"D.id_diario as 'id_diario', ".
				"D.nombre as 'nombre', ".
				"D.cuadrar_iva as 'cuadrar_iva', ".
				"AD.canal as 'canal' ".
				"FROM Asiento_diario `AD`, Diario `D`, Asiento A ".
				'WHERE AD.id_diario = D.id_diario AND A.id_asiento = AD.id_asiento AND '.
				( ($id)
				  ?  'AD.id_asiento = '.$id
				  :  'A.numero = '.$num.' AND A.id_ejercicio = '.$this->_aEjercicio['id_ejercicio']
				);
		$idrs = $oDb->query($cons);
		if ($oDb->num_rows($idrs)) {
			while ($aD = $oDb->fetch_assoc($idrs)) {
				$this->_aDiarios[$aD['id_diario']] = $aD;
			}
			$this->_changeFlags(ICEntry_DIARY | ICEntry_OK,-1);
		}
		$oDb->libera($idrs);

		$cons="SELECT ".
				"Aso.id_asiento as 'aso_id_asiento', ".
				"Aso.id_ejercicio as 'aso_id_ejercicio', ".
				"Aso.numero as 'aso_numero', ".
				"Aso.nombre as 'aso_nombre', ".
				"Aso.descripcion as 'aso_descripcion', ".
				"Aso.fecha_apertura as 'aso_fecha_apertura', ".
				"Aso.fecha_cierre as 'aso_fecha_cierre', ".
				"Aso.saldo_debe as 'aso_saldo_debe', ".
				"Aso.saldo_haber as 'aso_saldo_haber', ".
				"Aso.saldo as 'aso_saldo', ".
				"Aso.documento as 'aso_documento', ".
				"Aso.factura_gestion as 'aso_factura_gestion', ".
				"Aso.punteo as 'aso_punteo', ".
				"Ej.id_ejercicio as 'eje_id_ejercicio', ".
				"Ej.nombre as 'eje_nombre', ".
				"Ej.contador as 'eje_contador', ".
				"Ej.fecha_inicio as 'eje_fecha_inicio', ".
				"Ej.fecha_fin as 'eje_fecha_fin', ".
				"Ej.id_asiento_apertura as 'eje_id_asiento_apertura', ".
				"Ej.id_asiento_cierre as 'eje_id_asiento_cierre', ".
				"E.id_empresa as 'emp_id_empresa', ".
				"E.razon_social as 'emp_razon_social', ".
				"E.cif as 'emp_cif', ".
				"E.nombrecorto as 'emp_nombrecorto', ".
				"Aso.estado as 'aso_estado' ".
				"FROM Asiento as `Aso` LEFT JOIN Ejercicios Ej ON (Aso.id_ejercicio=Ej.id_ejercicio) ".
				'LEFT JOIN Empresas E ON (Ej.id_empresa=E.id_empresa) '.
				'WHERE '.
				( ($id)
				  ?  'Aso.id_asiento = '.$id
				  :  'Aso.numero = '.$num
				).
				( (is_numeric($this->_aEjercicio['id_ejercicio']))
				  ? ' AND Aso.id_ejercicio = '.$this->_aEjercicio['id_ejercicio']
				  : '' 
				 );
		$idrs = $oDb->query($cons);
		if (!$oDb->num_rows($idrs)) return false;
		$aRec = $oDb->fetch_assoc($idrs);
		foreach($aRec as $clave => $valor) {
			$ref_arr = substr($clave,0,4);
			$ref_resto = substr($clave,4);
			if (!strcasecmp($ref_arr,'aso_')) {
				$this->_aMain[$ref_resto] = $valor;
			} elseif (!strcasecmp($ref_arr,'eje_')) {
				$this->_aEjercicio[$ref_resto] = $valor;
			} elseif (!strcasecmp($ref_arr,'emp_')) {
				$this->_aEmpresa[$ref_resto] = $valor;
			}
		}
		$oDb->libera($idrs);
		$this->_changeFlags(ICEntry_MAIN | ICEntry_OK);
		$this->_fAsiento &= ~ICEntry_BLOCKALL;
		$this->_fAsiento &= ~ICEntry_LOCKED;
		$this->_aCfg['id_ejercicio'] = $this->_aEjercicio['id_ejercicio'];

		// Estableciendo las Marcas del Asiento.
		if (is_numeric($this->_aMain['punteo']) AND !empty($this->_aMain['punteo'])) {
			$cons = "SELECT ".
						"M.id_marcador as 'id_marcador', ".
						"M.mascara as 'mascara', ".
						"M.imagen as 'imagen', ".
						"M.nombre as 'nombre' ".
						"FROM Marcadores as `M` ".
						"WHERE M.mascara & ".$this->_aMain['punteo']." AND M.mascara != 0";
			$idrs = $oDb->query($cons);
			if ($oDb->num_rows($idrs)) {
				while ($aTmp = $oDb->fetch_assoc($idrs)) {
					settype($aTmp['mascara'],'int');
					$this->_aMarks[$aTmp['id_marcador']] = $aTmp;
				}
			} 
			$oDb->libera($idrs);
		}


		$cons="SELECT ".
				"Mov.id_movimiento as 'id_movimiento', ".
				"Mov.id_plan_contable as 'id_plan_contable', ".
				"Mov.id_cuenta as 'id_cuenta', ".
				"Mov.concepto as 'concepto', ".
				"Mov.fecha as 'fecha', ".
				"Mov.debe as 'debe', ".
				"Mov.haber as 'haber', ".
				"Mov.saldo as 'saldo', ".
				"CC.nombre as 'nombre_cuenta', ".
				"CC.id_cuenta as 'cuenta_contable', ".
				"PC.nombre as 'nombre_plan_contable', ".
				"PC.id_plan_contable as 'plan_contable', ".
				"IF(PC.activo_pasivo = 0,'activo','pasivo') as 'tipo_cuenta' ".
				"FROM Movimiento `Mov`, Cuenta_contable `CC`, Plan_general_contable `PC` ".
				"WHERE Mov.id_cuenta = CC.id_cuenta AND PC.id_plan_contable = Mov.id_plan_contable ".
				"AND CC.id_plan_contable = PC.id_plan_contable AND Mov.id_asiento = $id ".
				"ORDER BY Mov.fecha asc, Mov.id_movimiento asc ";
		$idrs = $oDb->query($cons);
		if ($oDb->num_rows($tmprs)) {
			$i = 0;
			while ($aTmp = $oDb->fetch_assoc($idrs)) {
				$idx = ++$i;
				$cuenta_formateada = $this->filterAccount($aTmp['id_plan_contable'].$aTmp['id_cuenta'],NULL,(int)$this->_aCfg['notacion_cc']);
				$this->_aMovimientos[$idx] = $aTmp;
				$this->_aMovimientos[$idx]['cuenta_contable_formateada'] = $cuenta_formateada;

				if (!empty($aTmp['fecha']))
					$this->_aMovimientos[$idx]['fecha'] = colocar_fecha($aTmp['fecha']);
				if ($this->_isTaxBase($aTmp['id_plan_contable'])) {
					$this->_setTaxBase($idx);
				} elseif ($this->isTaxContraAccount($aTmp['id_plan_contable'])) {
					$this->setTaxContraAccount($idx);
				}
				// Metodo build indexes?
				if (!is_array($this->_aIdxCCs[$this->_aMovimientos[$idx]['id_plan_contable'].$this->_aMovimientos[$idx]['id_cuenta']])) 
					$this->_aIdxCCs[$this->_aMovimientos[$idx]['id_plan_contable'].$this->_aMovimientos[$idx]['id_cuenta']] = array();
				if (!in_array($idx,$this->_aIdxCCs[$this->_aMovimientos[$idx]['id_plan_contable'].$this->_aMovimientos[$idx]['id_cuenta']])) 
					array_push($this->_aIdxCCs[$this->_aMovimientos[$idx]['id_plan_contable'].$this->_aMovimientos[$idx]['id_cuenta']],$idx);
				$this->_aIdxDB[$aTmp['id_movimiento']] = $idx;
			}
		}
		$oDb->libera($idrs);
		$this->_changeFlags(ICEntry_MOVE | ICEntry_OK,-1);
		if ($this->debug) debug("Aki tamos! reconstruyendo indices de impuestos desde dbFill()");
		$this->_buildTaxIndex();
		return TRUE;
	}

	/**
	  * Vuelca TOD-O el contenido del pedido a la base de datos. Borrando registros si es preciso.
	  **/
	function dbDump() {
		if ($this->debug) debug("probando el dump...");
		if ($this->_fAsiento & ICEntry_BLOCKALL) return false;

		if ($this->debug) {
			debug("Mascara = ".decbin($this->_fAsiento)."; Dec = ".$this->_fAsiento);
			debug("Main = ".decbin(ICEntry_MAIN)."; Dec = ".ICEntry_MAIN);
			debug("DBC = ".decbin(ICEntry_AC_DBCOMMIT)."; Dec = ".ICEntry_AC_DBCOMMIT);
		}

		if ( $this->_aFlags['main'] & (ICEntry_AC_DBCOMMIT ) ) {
			if ($this->debug) debug("pedido tocado...");
			if ($this->_aFlags['main'] & ICEntry_AC_DELETED) {
				if ($this->debug) debug("BORRANDO (marcando flags)... ".($this->_fAsiento & ICEntry_LOCKED));
				$this->_changeFlags(ICEntry_MOVE | ICEntry_AC_DELETED,-1);
				$this->_changeFlags(ICEntry_DIARY | ICEntry_AC_DELETED);
				$this->_changeFlags(ICEntry_TAXMOVE | ICEntry_AC_DELETED,-1);
				$this->_db->tb_delete("Asiento",array("id_asiento" => $this->getId()));
				if (is_numeric($this->_aEjercicio['id_ejercicio'])) {
					$tmpcons = 'UPDATE Ejercicios SET '.
								'id_asiento_regularizacion=IF(id_asiento_regularizacion='.$this->getId().',NULL,id_asiento_regularizacion), '.
								'id_asiento_cierre=IF(id_asiento_cierre='.$this->getId().',NULL,id_asiento_cierre) '.
								' WHERE id_ejercicio = '.$this->_aEjercicio['id_ejercicio'];
					$this->_db->query($tmpcons);
				}
			} elseif ($this->_aFlags['main'] & ICEntry_AC_DBCOMMIT) {
				$ref = $this->getDocument();
				if ($this->debug) debug("Documento : $ref");
				$date = $this->getFechaApertura();
				if (empty($date)) $this->setFechaApertura();

				if ((int)$this->_aMain['id_asiento']) {
					if ($this->debug) debug("Updateamos el asiento...");
					$this->_db->tb_update("Asiento",$this->_aMain);
				} else {
					if (empty($this->_aMain['numero'])) $this->setReference();
					$ref = $this->getReference();

					if (!empty($ref)) {
						if ($this->debug) debug("Insertando un nuevo asiento en la db...");
						$this->_db->tb_replace("Asiento",$this->_aMain);
						$this->_aMain['id_asiento'] = $this->_db->last_insert_id();
					}
				}
				if ($this->debug) print_r($this->_aMain);
			}
			$this->_changeFlags(ICEntry_MAIN | ICEntry_OK);
		} elseif ($this->debug) debug("Cabecera de Asiento Intacta...");


		if ($this->debug) debug("<b>INICIAreMOS LOS DIARIOS</b>");
		if ($this->_aFlags['diarios'] & ICEntry_AC_DBCOMMIT) {
			if ($this->debug) debug("Volcamos los diarios...");
			if ($this->_aFlags['diarios'] & ICEntry_AC_DELETE AND (int)$this->getId()) {
				$aTmp['id_asiento'] = $this->getId();
				$this->_db->tb_delete('Asiento_diario',$aTmp);
			} elseif ((int)$this->getId()) {
				if (is_array($this->_aDiarios) AND sizeof($this->_aDiarios)) {
					foreach($this->_aModif['diarios'] as $idx => $acc) {
						if (!is_array($this->_aDiarios[$idx]) OR !sizeof($this->_aDiarios[$idx])) {
							continue;
						}
						if ($acc & ICEntry_AC_DELETED) {
							$aTmp = $this->_aDiarios[$idx];
							$aTmp['id_asiento'] = $this->getId();
							$this->_db->tb_delete('Asiento_diario',$aTmp);
						} elseif($acc & ICEntry_AC_DBCOMMIT) {
							$aTmp = $this->_aDiarios[$idx];
							$aTmp['id_asiento'] = $this->getId();
							$this->_db->tb_replace('Asiento_diario',$aTmp);
						}
						$aTmp = NULL;
					}
				} elseif ($this->debug) debug("No hay Diarios que volcar...");
			} else $this->error('ACENTRY_NODBID',array('Asiento'));
			$this->_changeFlags(ICEntry_DIARY | ICEntry_OK);
		} else if ($this->debug) debug("Los DIARIOS NO se han tocado...");

		if ($this->_fAsiento & (ICEntry_AC_DBCOMMIT | ICEntry_MOVE ) ) {
			$aBorrarDet = array();

			if ($this->debug) {
				debug("amodif-MAIN");
				print_r($this->_aModif);
			}
			foreach($this->_aModif['detalles'] as $idx_det => $estado) {
				if ($estado & ICEntry_AC_DELETED) {
					if ($this->debug) debug("Borrando Movimiento $idx_det ...");
					$this->delMove($idx_det);
				} elseif ($estado & ICEntry_AC_DBCOMMIT) {
					if ($this->debug) debug("Detalle ($idx_det) no actualizado, Procediendo...");
					$aTmp = $this->getMove($idx_det);
					$aTmp['id_asiento'] = $this->_aMain['id_asiento'];
					$aTmp['id_plan_contable'] = $aTmp['id_plan_contable'];
					$aTmp['id_cuenta'] = $aTmp['id_cuenta'];

					if ($this->debug) debug("Movimientos de detalle");
					if ($this->debug) print_r($aTmp);

					if (!(int)$aTmp['id_movimiento']) {
						if ($this->debug) debug("Detalle $idx_det No esta en la DB. Actualizando indices...");
						$this->_db->tb_replace("Movimiento",$aTmp);
						$this->_aMovimientos[$idx_det]['id_movimiento'] = (int)$this->_db->last_insert_id();
						$this->_aIdxDB[$this->_aMovimientos[$idx_det]['id_movimiento']] = $id;
					} else {
						$this->_db->tb_update("Movimiento",$aTmp);
					}
				} else if ($this->debug) debug("Nada que hacer para este detalle($idx_det)...");
			}

			if (is_array($this->_aModif['dbdel_det']) AND sizeof($this->_aModif['dbdel_det'])) {
				foreach ($this->_aModif['dbdel_det'] as $i => $id) {
					if (!is_array($aDelete_Det)) $aDelete_Det = array();
					array_push($aDelete_Det,array('id_movimiento' => $id));
					if ($this->debug) debug("Detalle borrado($id), Actualizando ...");
				}
				if (is_array($aDelete_Det)) $this->_db->tb_delete("Movimiento",$aDelete_Det);
			}
			$aDelete_Det = NULL;
			$this->_changeFlags(ICEntry_MOVE | ICEntry_OK,-1);
		} else if ($this->debug) debug("Los DETALLES NO se han tocado");

		// Esto podia servir para los Movimientos de IVA!
		if ($this->_aFlags['ivas'] & (ICEntry_AC_DBCOMMIT ) ) {
			if ($this->debug) debug("<b>Volcamos los ivas</b>...");
			if (!(int)$this->_aMain['id_asiento']) {
				if ($this->debug) debug("Me falta el IDAsiento para poder Insertar IVAs");
			} elseif (is_array($this->_aModif['diarioiva']) AND sizeof($this->_aModif['diarioiva'])) {
				if ($this->debug) debug("Contrapartida: ".$this->_aIdxIVA['idx_contra_apuntesiva']);
				$pc_contra = $this->_aMovimientos[$this->_aIdxIVA['idx_contra_apuntesiva']]['id_plan_contable'];
				$cc_contra = $this->_aMovimientos[$this->_aIdxIVA['idx_contra_apuntesiva']]['id_cuenta'];

				if ($this->debug) debug("Es $pc_contra - $cc_contra  cnt:".sizeof($this->_aDiarioIVA));
				foreach ($this->_aModif['diarioiva'] as $idx_det => $estado) {
					if ($estado & ICEntry_AC_DELETED AND (int)$this->_aMain['id_asiento']) {
						$this->_delTax($idx_det);
					} elseif ($estado & ICEntry_AC_DBCOMMIT ) {
						if (is_array($this->_aDiarioIVA[$idx_det])) {
							$aTmp = array();
							$aIva = $this->_aDiarioIVA[$idx_det];
							$aTmp['id_asiento'] = $this->_aMain['id_asiento'];
							$aTmp['id_movimiento'] = $this->_aMovimientos[$idx_det]['id_movimiento'];
							$aTmp['id_plan_contable'] = $pc_contra;
							$aTmp['id_cuenta'] = $cc_contra;
							$aTmp['id_libro_iva'] = $aIva['id_libro_iva'];
							if (is_numeric($aIva['id_movimiento_iva'])) $aTmp['id_movimiento_iva'] = $aIva['id_movimiento_iva'];
							if (is_numeric($aIva['orden'])) $aTmp['orden'] = $aIva['orden'];
							// $aTmp['concepto'] = $this->_aMovimientos[$id_iva]['concepto'];
							$aTmp['concepto'] = $aIva['concepto'];
							if (empty($aIva['fecha'])) $this->_aDiarioIVA[$idx_det]['fecha'] = date('Y-m-d H:i:s');
							$aTmp['fecha'] = $this->_aDiarioIVA[$idx_det]['fecha'];
							$aTmp['base_imponible'] = $aIva['base_imponible'];
							$aTmp['cuota'] = $aIva['cuota'];
							$aTmp['total'] = $aIva['total'];
							if ($this->debug) debug("Movimiento de iva:");
							if ($this->debug) 
								print_r($aIva);
							if (!is_numeric($aTmp['id_movimiento_iva']) OR !is_numeric($aTmp['orden'])) {
								$cons = "SELECT contador_orden FROM Libro_ivas WHERE id_libro_iva = ".$aTmp['id_libro_iva'];
								$tmprs = $this->_db->query($cons);
								if ($this->_db->num_rows($tmprs)) {
									$aLibro = $this->_db->fetch_row($tmprs);
									$aTmp['orden'] = $aLibro[0];
									$cons = "UPDATE Libro_ivas SET contador_orden = contador_orden + 1 ".
													"WHERE id_libro_iva=".$aTmp['id_libro_iva'];
									$this->_db->query($cons);
									if (!is_numeric($aTmp['id_movimiento_iva'])) $this->_db->tb_replace('Movimientos_iva',$aTmp);
									else $this->_db->tb_update('Movimientos_iva',$aTmp);
								}
								$this->_db->libera($tmprs);
							} else $this->_db->tb_update('Movimientos_iva',$aTmp);
						} else {
							// No tocar:
							debug("IVA $idx_det aparece en el vector de mascaras de modificacion, pero no en la estructura del Diario");
						}
					} elseif ($this->debug) debug("IVA $idx_det _no_ hace falta volcarlo ...");
				}
			} 
			if (is_array($this->_aModif['dbdel_ivas'])) {
				foreach ($this->_aModif['dbdel_ivas'] as $i => $id) {
					if (!is_array($aDelete_Det)) $aDelete_Det = array();
					array_push($aDelete_Det,array('id_movimiento_iva' => $id));
					if ($this->debug) debug("IVA borrado($id), Actualizando ...");
				}
				if (is_array($aDelete_Det)) $this->_db->tb_delete("Movimientos_iva",$aDelete_Det);
			}
			$this->_changeFlags(ICEntry_TAXMOVE | ICEntry_OK,-1);
		} else if ($this->debug) debug("Los IVAs no se han tocado...");

	} // Fin del dbdump()
	/** FIN de los Metodos OPERATIVOS **/


} /** Fin de la Clase **/

} /** Fin del #ifndef <modulo> **/

?>
