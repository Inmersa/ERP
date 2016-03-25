<?php 

class wolSearchAPI {

	 /**
		* Instancia padre. clase wol_search
		*/
	var $parent;
	var $aSelects;
	var $aWheres;
	var $_aFrom;
	var $id_busqueda;
	var $db_data;
	var $db_name;
	var $bUseLeftJoin = false;

	function wolSearchAPI (&$oSearch) {
		$this->parent = $oSearch;
	}

	function init (&$oSearch) {
		$this->parent = &$oSearch;
		if (!empty($this->db_name)) $this->db_data = &$oSearch->sesion->get_db($this->db_name);
	}

	function set_search_id ($id = NULL) {
		if ($id)
			$this->id_busqueda = (int) $id;
	}

	function set_distinct ($type = NULL) {
		if (!$type)
			return 0;
		$this->parent->set_param_query ("DISTINCT", $type);
	}

	function _add_from ($table, $as_name = NULL) {
		if (empty ($table))
			return 0;
		if (is_array ($this->_aFrom)) {
			foreach ($this->_aFrom as $aFrom)
				if (!strcmp ($aFrom[0], $table))
				if (!strcmp ($aFrom[1], $as_name) OR (empty ($as_name) AND empty ($aFrom[1])))
					return 0;
			array_push ($this->_aFrom, array ($table, $as_name));
		} else {
			$this->_aFrom = array ();
			array_push ($this->_aFrom, array ($table, $as_name));
		}

		return 1;
	}

	function get_from () {
		if (!is_array ($this->_aFrom))
			return NULL;
		$aRetVal = array ();
		foreach ($this->_aFrom as $aFrom)
			array_push ($aRetVal, array ($aFrom[0], $aFrom[1]));
		return $aRetVal;
	}

	function add_select ($select = "", $bFrom = TRUE) {
		if (!isset ($bFrom))
			$bFrom = TRUE;
		if (!empty ($select)) {

			$sel = trim($select);
			$sele = split(" ",$sel);
			$fld = array_shift($sele);
			$aTmp = split ("\.", $fld);
			$fromresto = trim(array_pop($aTmp));
			$from = implode (".", $aTmp);
			if (strchr ($from, "(")) {
				$aTmpI = array ();
				$aTmpI = split ("[()]", $from);
				$from = $aTmpI[sizeof($aTmpI)-1];

				$aTmpII = split("[()]",$fromresto);
				$truefield = $aTmpII[0];
			} else {
				$truefield = $fromresto;
			}

			if (preg_match('/[\"\'](.*)[\"\']/',$select,$aTmp)) {
				$fromas = $aTmp[1];
			}

			if ($bFrom AND !empty ($from)) $this->_add_from ($from);
			
			if (!is_object($this->db_data)) $this->set_db('data');

			$oDb = &$this->get_db();
			$aFlds = $oDb->get_fields($from);
			$this->_aCache['EntityDataTypes'][$from] = $aFlds;
			if (!$this->parent->sesion->gotEntityDataType($from)) {
				$this->parent->sesion->setEntityDataType($from,$aFlds);
			}
			if (!empty($fromas)) $this->parent->sesion->setEntityDataLink($fromas,$from,$truefield);

			$this->aSelects[] = $select;
		}
	}

	function add_where ($where = "", $sep = "AND", $bFrom = TRUE) {
		if (strcasecmp ($sep, "AND") AND strcasecmp ($sep, "OR"))
			return 0;
		if (empty ($where))
			return 0;
		if (!isset ($bFrom))
			$bFrom = TRUE;
		$aFlds = split ("[ =!<>&()]", trim ($where));
		if ($bFrom)
			foreach ($aFlds as $fld) {
				if (is_numeric ($fld) OR strchr ($fld, "'") OR strchr ($fld, '"'))
					continue;
				if (strchr ($fld, ".")) {
					$aTmp = split ("\.", $fld);
					array_pop ($aTmp);
					$from = implode (".", $aTmp);
					$this->_add_from ($from);
				}
			}
		$this->aWheres[] = array ($where, $sep);
	}

	function get_selects () {
		$ret_val = NULL;
		$nSelects = sizeof ($this->aSelects);
		if (is_array ($this->aSelects))
			foreach ($this->aSelects as $campo_select)
				$ret_val .= $campo_select.((++$i == $nSelects) ? "" : ", ");
		return $ret_val;
	}

	function get_wheres () {
		$ret_val = NULL;
		$nWheres = sizeof ($this->aWheres);
		if (!$nWheres)
			return NULL;
		if (is_array ($this->aWheres)) {
			foreach ($this->aWheres as $aCond) {
				$ret_val .= ((!$i++) ? ' ( ' : $aCond[1].' ').'('.$aCond[0].') ';
			}
			$ret_val .= " ) ";
			return $ret_val;
		}
		return NULL;
	}

	function set_hits_page ($num = 10) {
		$this->parent->hits_page = (int) $num;
	}

	function get_hits_page () {
		return $this->parent->hits_page;
	}

	function groupby ($groupby = "") {
		$this->parent->set_param_query ("GROUP BY", $groupby);
	}

	function orderby ($orderby = NULL) {
		$this->parent->set_param_query ("ORDER BY", $orderby);
	}

	function useLeftJoin($bool = true) {
		$this->bUseLeftJoin = $bool;
	}

	function add_ruta ($a) {
		$this->set_ruta_path ($a);
	}

	function set_ruta_path ($ruta = NULL) {
		if (!is_array ($ruta))
			return FALSE;
		$this->ruta_path = $ruta;
	}

	function set_not_ruta_path ($ruta = NULL) {
		if (!is_array ($ruta))
			return FALSE;
		$this->not_ruta_path = $ruta;
	}

	function get_not_ruta_path () {
		return $this->not_ruta_path;
	}

	function get_ruta_path () {
		return $this->ruta_path;
	}

	function set_db ($dbname) {
		if (!is_object ($this->parent)) return false;

		$retval = true;
		if (!empty($dbname)) {
			$this->db_data = &$this->parent->sesion->get_db($dbname);
			if (is_object($this->db_data) AND is_a($this->db_data,'wol_db')) {
				// debug("wolSearchAPI->set_db -- aNames[$dbname]");
				$this->parent->_aNames['data'] = $dbname;
				$this->db_name = $dbname;
			}
		} else {
			$this->db_data = NULL;
			// debug("wolSearchAPI->set_db -- aNames[data]  NULL");
			$this->_aNames['data'] = NULL;
			$retval = false;
		}
		return $retval;
	}

	function &get_db () {
		if (is_a($this->db_data,'wol_db')) return $this->db_data;
		else return NULL;
		// elseif (is_object($this->parent)) return $this->parent->db_data;
	}

	function cerrar () {

		unset($this->parent);
		unset($this->db_data);
		/** **
		if (is_object($this->db_data))
		  $this->db_data->cerrar();
		/** **/
		// $this->parent = NULL;
	}

}

/**
        * Clase de busquedas en un objeto wol_db
        */
class wol_search {
	var $sesion;					  // objeto sesion
	var $App_Name;					  // nombre de la aplicacion, y por consiguiente el global de la variable de sesion

	var $id = "";					  // Identificador de consulta
	var $id_secc;					  /* id de seccion */
	var $aPlantillas = array (); // Plantillas ha cambiado/a�adido el buscador
	var $iden_busq = 0;			  /* identificador del tipo de busqueda o buscador. */
	var $search_name = 0;		  /* identificador del tipo de busqueda o */
	var $bTriggered = false; 	  /* Se ha disparado la busqueda desde fuera? */
	var $hits_page = 0;			  /* Golpes por pagina */
	var $pagina = 0;				  /* Pagina actual */
	var $aConf = array();			/** Array con varias variables de configuracion **/

	var $aBloqueos = array(		  // Array de bloqueos sobre las busquedas.
			'id' => 0,				 	// ID bloqueado
			'order' => 0				// Order By bloqueado (no modificacle en esta carga);
			);
	var $cons_secc;				  // Tabla de querys-seccion y numero de resultados.
	var $busqueda_forzada;
	var $tb_tipo_busq;			  /* Tabla con tipos de busqueda */
	var $tb_tipbus_subse;		  /* Tabla que relaciona tipos de busqueda */
	/*
	 * con subsecciones.
	 */
	var $tb_tipo_plant;			  /* Tabla que relaciona tipo de busqueda */
	/*
	 * con plantillas 
	 */
	var $tb_campos_tipo;			  /* Tabla con parametros para tipo busqueda */
	var $tb_selects;				  /* Tabla con parametros para parte selec */
	var $tb_wheres;				  /* Tabla con parametros para parte where */
	var $inc;						  /* Para realizar los includes (script) */
	var $inc_path;					  /* Para saber la ruta de los includes */
	var $aPltWheres;				  /* Tabla auxiliar de nombres de wheres */
	var $orderby;					  /* Parametro de query order by */
	var $resultados;				  /* Resultados de la query */
	var $activao;					  /* Para distinguir entre buscadores */
	var $script_dir = "scripts/";

	var $_aCache = NULL; 			/* Cache mixto con limpieza antes de llamar a hacer_consulta() - es decir, componer - */
	var $_aoMod = NULL; 				/* Lista de Modulos a los que llamar despues de la form_data proc */

 /**
 *Base de datos de configuracion activa
 */
	var $db;

 /**
 *Base de datos de datos activa
 */
	var $db_data;

 /**
         * Instancia de Interface con la funcion de proceso de datos del buscador
         */
	var $oSearchAPI = NULL;

//definicion de metodos

/*
 function wol_search()   //constructor
 {
//aviso("tamos nel constructo");
 } //Fin del constructor*/

	function off__wakeup () {
		// echo "Despertando Instancia: ";
		$fd = fopen ('/tmp/krnbug.log', 'w+');
		fputs ($fd, 'Despertando Instancia ... wakeup');
		fflush ($fd);
		fclose ($fd);
	} 
	
	function set_conf (&$oDb) {
		/*
		 * Se cargan los valores para tablas de buscadores 
		 */
		$this->tb_tipo_busq = $this->sesion->read_main_value ("tb_tipo_busq");
		$this->tb_tipbus_subse = $this->sesion->read_main_value ("tb_tipbus_subse");
		$this->tb_tipo_plant = $this->sesion->read_main_value ("tb_tipo_plant");
		$this->tb_campos_tipo = $this->sesion->read_main_value ("tb_campos_tipo");
		$this->tb_selects = $this->sesion->read_main_value ("tb_selects");
		$this->tb_wheres = $this->sesion->read_main_value ("tb_wheres");
	}

	function get_search_name () {
		return $this->search_name;
	}

	function getName() {
		return $this->get_search_name();
	}

/** empty_search():
  * Esta funcion nos limpia la busqueda actual. 
  *  Todas las variables que puedan disparar o incordiar la busqueda
  */
	function empty_search () {
		if ($this->debug)
			debug ("Vaciamos busquedas");
		// Reseteamos el identificador de busquedas.
		$this->iden_busq = 0;
		$this->search_name = NULL;
		$this->id = 0;
		$this->ignorar_iden = 1;
		$this->busqueda_forzada = 0;
		$this->pagina = 0;

		// Vaciamos el script
		$this->incluido = 0;
		$this->inc = NULL;

		// Vaciamos variables de agrupacion
		$this->distinct = NULL;
		$this->groupby = NULL;
		$this->orderby = NULL;

		unset ($this->oSearchAPI);
		$this->oSearchAPI = new wolSearchAPI ($this);

		$this->sesion->unset_var('_searchPersistentData');
		$this->sesion->unset_var('_searchOrderRequest');

		// debug("<b>empty_search()</b> .. ");
		$this->_aNames['data'] = NULL;
		unset($this->db_data);
	}

	function registerModule(&$oInstance,$method = NULL) {
		if (!is_array($this->_aoMod)) $this->_aoMod = array();
		if (empty($method)) $method = 'triggerSearch';
		$rval = false;
		if (is_array($this->_aoMod) and sizeof($this->_aoMod)) {
			$clase = get_class($oInstance);
			foreach ($this->_aoMod as $aM) {
				if (!strcmp($clase,get_class($aM['instance']))) {
					return false;
				}
			}
		}
		if (method_exists($oInstance,$method)) {
//			$this->_aoMod[sizeof($this->_aoMod)] = array('instance' => &$oInstance, 'method' => $method);
			$this->_aoMod[sizeof($this->_aoMod)] = array('instance' => $oInstance, 'method' => $method);
			$rval = true;
		}
		return $rval;
	}

	function init (&$obj_sesion) {
		$this->debug = 0;
		if (empty($this->App_Name)) {
			$this->App_Name = $obj_sesion->App_Name;
			$this->_aNames['data'] = 'data';
			$this->_aNames['conf'] = 'conf';
		}
		if (!is_array($this->_aNames) OR !sizeof($this->_aNames)) return false;

		$this->db = &$obj_sesion->get_db ($this->_aNames['conf']);
		$this->sesion = &$obj_sesion;
//		$this->set_conf (&$this->db);
		$this->set_conf ($this->db);
		if (!empty($this->_aNames['data'])) {
			// debug("db_data obtenido extrayendo ".$this->_aNames['data']." de la sesion ");
			$this->db_data = &$obj_sesion->get_db($this->_aNames['data']);
		}
		// documentar db
		// $this->sesion = &wol_db::fetchVar($this->App_Name,'GLOBAL');

		/*
		 * Para evitar conflictos con otras sesiones
		 */
		$this->aBloqueos['id'] = 0;
		// $this->conexion=&$obj_sesion->get_db_conn();

		/*
		 * Acordarse de hacer comprobacion de si el obj db esta conectado ya o no 
		 */
		// $this->conexion->conecta();

		// if (empty($this->id_secc)) $this->id_secc = $obj_sesion->id_secc;

	/** Esta mierda impide que se lance la busqueda deseada (no forzada) desde un formulario 
	  de otra subseccion, al hacer la busqueda de nom_var de la subsecc antitua (que ya no importa)
	if (!$obj_sesion->bRecarga)
		$id = $obj_sesion->get_old_id_subsecc();
	else $id = $obj_sesion->get_id_subsecc(); 
	/** **/
		$id = $obj_sesion->get_id_subsecc ();

		// if (!$id) $id = $obj_sesion->id_secc;

		// debug("Recarga = ".$obj_sesion->bRecarga);

		/**  Chequeo si hay algun buscador activado mediante un Submit **/
		// if (!empty ($id) AND !$obj_sesion->bRecarga ) 
		if (!empty ($id) ) {
			$cons = "select distinct nom_var from ".$this->sesion->read_main_value ("tb_tipbus_subse");
			$cons .= " where id_sub=".$id;
			unset ($id);
			// salida("cons0 ".$cons."<br>");
			$rs = $this->db->query ($cons);
			while ($row = $this->db->fetch_array ($rs)) {
				$nom_var = $this->sesion->fetchVar ($row['nom_var'], 'POST GET');
				if (!(empty ($nom_var))) {
					$valor_var = $nom_var;
					break;
				}
			}
		}
		// debug("valor_var : $valor_var\n");

		/*
		 * NO HAY SUBMIT 
		 */
		if (!(isset ($valor_var))) {	/* Si no hay ningun submit */
			$this->bTriggered = false;
			if ($this->debug)
				debug ("(fuera) iden_busq ".$this->iden_busq." But OldIDB(".$this->old_iden.")<BR>\n");

		  	/** no hay submit, comprobamos el resto entorno **/
			// if ($this->id_secc!=$obj_sesion->id_secc)  /* ha cambiado */
			switch ($obj_sesion->bRecarga) {
				case 2:					  /* $seccion no establecida */
					// $this->iden_busq = 0;
					if ($this->debug)
						debug (" Seccion: ".$obj_sesion->get_subsecc_name ()."(".$obj_sesion->get_id_subsecc ().")".
								 " Antigua: ".$this->old_secc_name."(".$this->old_secc.")");
					if ($this->old_secc != $obj_sesion->get_id_subsecc ()) {
						/*
						 * la seccion antigua no es igual a la actual 
						 */
						// $this->empty_search();
						if ($this->debug)
							debug ("No coinciden las subsecciones. ignoramos busqueda");
						$this->ignorar_iden = 1;
					}
					elseif ($this->iden_busq > 0) {
						/*
						 * ES de esta seccion (la buskeda) 
						 */
						if ($this->debug)
							debug ("this->old_secc == id_secc & iden_busq");
						$this->id_secc = $obj_sesion->id_secc;
						$this->ignorar_iden = 0;
					}
					else {
						$this->empty_search ();
					}

					break;
				case 1:		  /* recarga simple */
					// todo como estaba (este caso no se da)
					if ($this->debug)
						debug ("recarga simple Act(".$this->iden_busq.") Old(".$this->old_iden.")");
					// kk $this->id_secc = $obj_sesion->id_secc;
					// kk $hay_b = 0;
					if ($this->debug)
						debug ("idsec : ".$this->id_secc." Old : ".$this->old_secc);
					if (!$this->iden_busq AND empty ($this->old_iden)) {
						$this->empty_search ();
					}
					elseif ($this->old_secc == $this->id_secc) {
						$this->ignorar_iden = 0;
					}
					break;
				case 0:					  /* navegacion directa (cambio seccion) */
					if ($this->debug)
						debug ("Cambio directo de subseccion");
					if ($this->iden_busq > 0) {	/* hay buskda guardada */
						// $this->old_iden = $this->iden_busq;
						if ($this->debug)
							debug ("La busqueda es del id_subsecc $this->old_secc, estamos en la ".$obj_sesion->get_id_subsecc ());
						if ($this->old_secc != $obj_sesion->get_id_subsecc ()) {
							/*
							 * Si no es d esta secc, pasamos.  
							 */
							if ($this->debug)
								debug ("La Buskeda (no es d esta secc), la ignoramos ");
							// if ($this->debug) debug("Reseteamos la pagina actual ");
							// $this->pagina =0;
							// $this->empty_search();
							$this->ignorar_iden = 1;
							// old_secc es nuevo. a�adir descripcion
							if ($this->debug)
								debug ("IDB-Act(".$this->iden_busq.") - IDB-Old(".$this->old_iden.")");
							if ($this->debug)
								debug ("IDS-Act(".$this->id_secc.") - IDS-Old(".$this->old_secc.")");
							/*
							 * * ** No lo metemos, dado que a la siguiente recarga se va a pensar que la busqueda es de este id 
							 */
							if (empty ($this->old_secc)) {
								if ($this->debug)
									debug ("Metemos en old_secc id_secc");
								$this->old_secc = $this->id_secc;
							}
							/*
							 */
						} else {			  /* la buskeda ES de esta seccion */
							if ($this->debug)
								debug ("Hay una buskeda, Y ES de esta seccion<BR>\n");
							// $this->iden_busq = (int) $this->old_iden;
							$this->ignorar_iden = 0;
						}
						// kk $this->id_secc = $obj_sesion->id_secc;
					} else {				  /* Navegacion directa desde sin buskeda */
						if ($this->debug)
							debug ("Navegacion directa. Origen sin ID");
						if ($this->old_secc == $obj_sesion->get_id_subsecc ()) {
							if ($this->iden_busq = (int) $this->old_iden)
								$this->ignorar_iden = 0;
							else {
								$this->empty_search ();
							}
						} else {
							$this->empty_search ();
						}
					}
			} /* final del switch */
			$this->id_secc = $obj_sesion->get_id_subsecc ();
			if ($this->debug)
				debug ("Asignamos el IDSecc actual - ".$this->id_secc);

			/*
			 * EXISTE Buskeda en Sesion 
			 */
			if (!$this->ignorar_iden) {
				if ($this->debug)
					debug ("No ignoramos la busqueda que hay en el buscador almacenada");
				$hay_b = 1;
				$this->incluido = 0;
				$this->get_includes ();
				// $this->set_plts($obj_sesion);

				if (!$obj_sesion->bRecarga OR empty($this->aConf['nombre_pg'])) {
				  /** Buscamos ahora el paginado.. **/
					$cons = "select nombre_pg from ".$this->tb_tipo_busq." where id_tip=";
					$cons .= $this->iden_busq;
					$rs = $this->db->query ($cons);
					$row = $this->db->fetch_array ($rs);
					$new_npg = $row['nombre_pg'];
					$this->aConf['nombre_pg'] = $new_npg;
				} else $new_npg = $this->aConf['nombre_pg'];

				if ($new_npg) {
					$pg = $this->sesion->fetchVar($new_npg, 'POST GET');
					if ($this->debug)
						debug ("nombre pg = ".$new_npg." recarga = ".$obj_sesion->bRecarga." forzada = ".$this->busqueda_forzada." pagina = ".$this->pagina);

					if (isset ($pg)) {
						/*
						 * Asignamos la pagina en la que estamos 
						 */
						$this->pagina = (int) $pg;

						/*
						 * Recontamos a ver si sige habiendo el mismo num de resultados 
						 */
						$this->get_numresults (TRUE);

						$this->store_persistent_form();
					} elseif (!$obj_sesion->bRecarga) {
						$this->get_includes ();
						// $this->set_plts($obj_sesion);
					}
					// aviso("Recargamos, hay busqueda y no hay pagina??");
					// $hay_b=0;
					// return 0;
					// else aviso("hemos recargao creo. hay b? ".$obj_sesion->hay_b);
				} elseif (!$obj_sesion->bRecarga) {
					if (!$this->busqueda_forzada) $hay_b = 0;
					// return $hay_b;
				} else debug ("hemos recargao ");
				// salida("HayB = $hay_b");

			} else {			/** NO EXISTE buskeda en la sesion **/
				if ($this->debug)
					debug ("_ignoramos!_ la busqueda almacenada. Buscamos una nueva");

				/*** Procesamos busquedas de esta seccion (iden)***/
				$cons = "select distinct t1.busq_forzada,t2.hits_page,t1.id_tipo from ".
					$this->sesion->read_main_value ("tb_tipbus_subse");
				$cons .= " t1, ".$this->sesion->read_main_value ("tb_tipo_busq")." t2 ".
					" where t1.id_tipo=t2.id_tip AND t1.id_sub=".$obj_sesion->get_id_subsecc ();
//salida("cons0 ".$cons."<br>\n");
				$rs = $this->db->query ($cons);
				// Jode las busquedas en ventana nueva: $this->busqueda_forzada=0;
				$this->ignorar_iden = 1;
				while ($row = $this->db->fetch_array ($rs)) {
					if ($row["busq_forzada"]) {
						if ($this->debug)
							debug ("Hay una busqueda forzada. golpespag($row[hits_page])");
						$this->hits_page = $row["hits_page"];
						if ((int) $row["id_tipo"] == (int) $this->old_iden) {
							if ($this->debug)
								debug ("La busqueda anterior era $this->old_iden, esta forzada es $row[id_tipo]");
							$this->iden_busq = $this->old_iden;
							$this->search_name = $this->old_name;
						} else {
							$this->empty_search ();
						}
						$this->busqueda_forzada = (int) $row["busq_forzada"];
						break;
					} else {
						if ($this->debug)
							debug ("NO hay busqueda forzada");
						$this->busqueda_forzada = 0;
					}
				}
				$cons = "select busc_defecto from ".$this->sesion->read_main_value ("tb_sub_secc")." where id_sub_secc=";
				$cons .= $obj_sesion->get_id_subsecc ();
				$rs = $this->db->query ($cons);
				/*
				 * OJITO que una subseccion puede tener mas de un tipo de buskeda 
				 */
				$row = $this->db->fetch_array ($rs);
				$id_busc = (int) $row[0];
				$this->ignorar_iden = 0;
				if ($this->debug)
					debug ("id busqueda = $id_busc");
				if (!empty ($id_busc))
					$this->set_iden_busq ($id_busc);
				else
					$this->ignorar_iden = 1;

			}/** if (iden and !ignorar) **/

		} else {
 			/** HAY UN SUBMIT ($valor_var)**/
			$this->bTriggered = true;
			$this->busqueda_forzada = 0;	/* Si hay un submit, no hay bforzada */
			if ($this->debug) debug ("reseteando la pagina (Envio de Form)");
			$this->pagina = 0;
			unset ($this->cons_secc);

			// Reseteamos la api del buscador
			$this->oSearchAPI = new wolSearchAPI ($this);
			$this->distinct = NULL;
			$this->groupby = NULL;
		}

		if ($this->debug) {
			debug ("BUSCADOR (acabamos de averiguar si hay busqueda que realizar):");
			debug ("bRecarga         : (".$obj_sesion->bRecarga.")");
			debug ("iden_busq : (".$this->iden_busq.")");
			debug ("Old ID_busq : (".$this->old_iden.")");
			debug ("ignorar_iden:(".$this->ignorar_iden.")");
			debug ("valor_var: (".$valor_var.")");
			debug ("id_secc                 : (".$this->id_secc.")");
			debug ("_old_ id_secc           : (".$this->old_secc.")");
			debug ("Forzada         : (".$this->busqueda_forzada.")");
			debug ("Script         : (".$this->inc.")");
			debug ("Incluido         : (".$this->incluido.")");
		}

		  /** HAY BUSKEDA k realizar **/
		if (isset ($valor_var) OR (0 AND (int) $this->busqueda_forzada) OR (!(int) $this->ignorar_iden)) {
			if ($this->id_secc != $obj_sesion->id_secc) {
				// debug("Parece ser que algo habra que buscar ....");
				$this->old_secc = $this->id_secc;
				$this->id_secc = $obj_sesion->id_secc;
			}
			if ($this->debug)
				debug ("asignado id_secc : ".$this->id_secc);

			/*
			 * borramos las querys anteriores 
			 */
			$this->activao = 1;

			if (isset ($valor_var)) {
				if ($this->debug) debug ("SI se ha enviado un formulario ...");
				$this->empty_search ();
				$cons = "select id_tipo from ".$this->sesion->read_main_value ("tb_tipbus_subse")." where id_sub=";
				$cons .= $this->id_secc." and nombre_tipo=\"".$valor_var."\"";
//echo "cons1 ".$cons."<br>";
				$rs = $this->db->query ($cons);

/* OJITO que una subseccion puede tener mas de un tipo de buskeda */
				$row = $this->db->fetch_array ($rs);
				$id_busc = $row[0];
				$this->set_iden_busq ($id_busc);

			  /** pa Miguel: aki tenias this->includes.
				si puedes, mejor no accedas directamente a las propiedades d un obj*/
				$this->get_includes ();

				$cons = "select hits_page from ".$this->sesion->read_main_value ("tb_tipo_busq")." where id_tip=";
				$cons .= $this->iden_busq;
				$rs = $this->db->query ($cons);
				$row = $this->db->fetch_array ($rs);
//echo "consulti ".$cons."<br>";

				if ($row["hits_page"])
					$this->hits_page = $row["hits_page"];
				$this->set_plts ($obj_sesion);
			} elseif ($this->busqueda_forzada) {	// es busqueda forzada o estamos paginando
//echo "es busqueda forzada <br>";
				if ($this->iden_busq != $this->old_iden) {
					if ($this->debug) debug ("Estamos Forzando la Busqueda por Defecto ...");
					$this->cons_secc = array ();
				} else {
					if ($this->debug) debug ("No limpiamos la busqueda, por muy forzada que sea.");
					$this->busqueda_forzada = 0;
				}
				// Lets see (no se de donde sale este valor, subseccion o tipbusqsubsecc): $this->hits_page=$this->busqueda_forzada;
				/*
				 * Se hace include y se especifica en vble se_forzo 
				 */
				$this->get_includes ();
//				$this->set_plts (&$obj_sesion);
				$this->set_plts ($obj_sesion);
			} else {
				$this->get_includes ();
//				$this->set_plts (&$obj_sesion);
				$this->set_plts ($obj_sesion);
			}							  // end if de isset valor_var

			/* Se registra el n�mero de pagina en el objeto */
			if (!$obj_sesion->bRecarga OR empty($this->aConf['nombre_pg'])) {
				$cons = "select nombre_pg from ".$this->sesion->read_main_value ("tb_tipo_busq")." where id_tip=";
				$cons .= $this->iden_busq;
				$rs = $this->db->query ($cons);
				$row = $this->db->fetch_array ($rs);
				$new_npg = $row['nombre_pg'];
				$this->aConf['nombre_pg'] = $new_npg;
			} else $new_npg = $this->aConf['nombre_pg'];

			if ($new_npg) {
				$pg = $this->sesion->fetchVar ($new_npg, 'POST GET');
				if (!(empty ($pg)) && !($this->pagina)) {
					$this->pagina = (int) $pg;
					// debug ("Buen momento para almacenar los checkboxes ...");
					$this->store_persistent_form();
					if ($this->debug) debug ("asignando pagina desde nombre_pg(".$row['nombre_pg'].") = ".$this->pagina);
				}
			}

			if (!empty ($this->iden_busq) AND is_numeric ($this->iden_busq)) {
				if ($this->debug) debug ("Seteando en _old_ la Busqueda ...");
				$this->old_iden = $this->iden_busq;
				$this->old_name = $this->search_name;
				$this->old_secc = $this->sesion->get_id_subsecc ();
			}
			$hay_b = 1;
		}
		$this->activao = (int) $hay_b;
		return (int) $hay_b;
	}

	function doSearch() {
		if (!empty($this->iden_busq)) {
			$obj_sesion = &$this->sesion;
			// Establecemos los datos de la busqueda para mandarselos a la funcion de proceso de datos.
			if (is_object ($this->oSearchAPI)) {
				if ($this->debug) debug("Inicializando API de Busquedas");
//				$this->oSearchAPI->init (&$this);
				$this->oSearchAPI->init ($this);
				$this->oSearchAPI->set_search_id ($this->iden_busq);
			}

			/* Cambio las plantillas en la tabla de plantillas de la sesion */
			// $this->set_plts($obj_sesion);
			// if ((bool)$this->activao) 
			if ((!$this->ignorar_iden && $this->busqueda_forzada) || $this->bTriggered) {
				// Compruebo si llamar a hacer consulta
				$cons = "select form_data_func from ".$this->sesion->read_main_value ("tb_tipbus_subse")." where id_tipo=";
				$cons .= $this->iden_busq." and id_sub=".$this->id_secc;
				$rs = $this->db->query ($cons);
				$row = $this->db->fetch_array ($rs);
				if ($this->debug) debug("funcion proceso de datos: ".$row['form_data_func']);
				if (!empty ($row["form_data_func"]))
					$vari = $row["form_data_func"] ($obj_sesion, $this->oSearchAPI);
				if (is_array($this->_aoMod) and sizeof($this->_aoMod))
					foreach (array_keys($this->_aoMod) as $i) {
						$mname = $this->_aoMod[$i]['method'];
						if (empty($mname) or !is_object($this->_aoMod[$i]['instance'])) continue;
						$this->_aoMod[$i]['instance']->$mname($this->oSearchAPI);
					}
				if ($this->debug) debug('Resultado de proceso de datos: '.$vari);
			}

			  /** Antes de llamar a hacer_consulta comprobamos cual va a ser la conexion de datos **/
			if (!is_object ($this->oSearchAPI) OR ! is_object ($this->oSearchAPI->get_db ())) {
				if ($this->debug) debug ("db_data sacado de la sesion (".$this->_aNames['data'].") ");
				if (empty($this->_aNames['data'])) $this->_aNames['data'] = 'data';
				$this->db_data = &$obj_sesion->get_db ( $this->_aNames['data'] );
			} elseif (is_object ($this->oSearchAPI) AND is_object ($this->oSearchAPI->get_db ())) {
				if ($this->debug) debug ("db_data sacado de la SearchAPI");
				$this->db_data = &$this->oSearchAPI->get_db ();
				$this->_aNames['data'] = $this->oSearchAPI->db_name;
				if (!$this->db_data->conectado ()) {
					$this->db_data->conecta ();
				}
			} elseif ($this->debug) debug ("Imposible determinar una base de datos de conexion");

			// if ((bool)$this->activao) 
			if ((!$this->ignorar_iden && $this->busqueda_forzada) || $this->bTriggered) {
				if ($this->debug) debug ('No ignorar la almacenada y forzada, o formulario?  <b>hacer_consulta</b>()'.$this->ignorar_iden);
				$this->_aCache = array();
				$Ret_Val = $this->hacer_consulta ($obj_sesion);
				// Jode la Recarga con OrderBy: $this->orderby = NULL;
			} else {
				// debug("No preparamos de nuevo la consulta.. ");
				if (is_array($this->_aCache['EntityDataTypes']) and sizeof($this->_aCache['EntityDataTypes'])) {
					foreach ($this->_aCache['EntityDataTypes'] as $ent => $aFlds) {
						// print_r($aFlds);
						if (!$this->sesion->gotEntityDataType($ent)) {
							$this->sesion->setEntityDataType($ent,$aFlds);
						}
					}
				}
			}

		}	// end-if de HAY una buskeda k realizar

		if ((bool)$this->activao) {
			$sumatorio = 0;
			if ($this->debug) debug ("hay busqueda, guardamos valores");

			$sumatorio = $this->get_numresults (TRUE);
			if ($this->debug)
				debug ("golpes_pag:".$this->hits_page."<br/>\n"."pag_actual:".$this->pagina."<br/>\n"."num_resultados".$sumatorio);

			$obj_sesion->set_var ("golpes_pag", $this->hits_page);
//si es una nueva busqueda la pagina es la 0

			$obj_sesion->set_var ("pag_actual", $this->pagina);
			// $obj_sesion->set_var("pag_actual",0);

			$this->resultados = $sumatorio;
		} else {
			// Si no hay busqueda, no jodamos la que pueda haber almacenada.
			// $this->empty_search();
			// unset($this->aPlantillas);
			// unset($this->orderby);
		}
		return;
		/*
		 * $inc = $this->get_include(); if (!empty($inc)) include($inc);
		 */
		// salida("(init) RETURN ".(int)$hay_b);
	}									  // Fin de funcion init

	function store_persistent_form() {
		// debug ("Otro buen momento para almacenar checkboxes ...".$this->search_name);
		$aStored = $this->sesion->get_var('_searchPersistentData');
		$chunk = trim($this->sesion->fetchVar('checked_boxes','POST'));
		// debug("chunk : $chunk");

		$aVars = split(' ',$chunk);
		if (!sizeof($aVars) AND strlen($chunk)) $aVars[0]=$chunk;
		if (sizeof($aVars)) {
			$aProc = array();
			$aArr = array();
			$bArray = TRUE;
			foreach ($aVars as $val) {
				$aKey = split('=',$val);
				array_push($aProc,$aKey);
				if (!strchr($aKey[0],'[') ) {
					$bArray = FALSE;
				} else {
					// debug($aKey[0]." Es vector ");
					$aTmp = split('\[',$aKey[0]);
					if ($bArray AND (empty($array_name) OR !strcasecmp($array_name,$aTmp[0]))) {
						$array_name = $aTmp[0];
						$key = str_replace(']','',$aTmp[1]);
						// debug('Va coincidiendo('.$array_name.') ..'.$key.' - '.$aKey[1]);
						$aArr[$key] = $aKey[1];
					} else {
						$bArray = FALSE;
					}
				}
			}
			if ($bArray) $aProc = $aArr;
			
			if ($bArray) {
				$aRetVal['container_name'] = $array_name;
			}

			if (!is_array($aStored) OR !sizeof($aStored)) {
				$aRetVal['contents'] = $aProc;
			} else {
				$aRetVal = $aStored;
				foreach ($aProc as $key => $val) {
					if (!isset($aRetVal['contents'][$key]) OR ($aRetVal['contents'][$key]!=$val AND $val!=-1)) {
						// debug("metiendo clave $key ...");
						$aRetVal['contents'][$key] = $val;
					} elseif ($val == -1 AND isset($aRetVal['contents'][$key])) {
					   // debug("Borrando $key ...");
					   $aRetVal['contents'][$key] = NULL;
					   unset($aRetVal['contents'][$key]);
					}
				}
			}
			$this->sesion->set_var('_searchPersistentData',$aRetVal,'SUBSECCION');
		} 
	}

	function set_plts (&$obj_sesion) {
//aviso("Buscamos Plantillas de seccion ".$this->id_secc);

/*Cambio las plantillas en la tabla de plantillas de la sesion*/
		$cons = "select ".$this->sesion->read_main_value ("tb_tipo_plant").".hacer_query as 'hacer_query',".
			$this->sesion->read_main_value ("tb_tipo_plant").".nom_plt_sub as 'nom_plt_sub',";
		$cons .= $this->sesion->read_main_value ("tb_plantillas").".nombre as 'nombre'";
		$cons .= " from ".$this->sesion->read_main_value ("tb_tipo_plant");
		$cons .= ",".$this->sesion->read_main_value ("tb_plantillas")." where ";
		$cons .= $this->sesion->read_main_value ("tb_tipo_plant").".id_tipo=";
		$cons .= $this->iden_busq." and ".$this->sesion->read_main_value ("tb_tipo_plant").".id_plantilla = ";
		$cons .= $this->sesion->read_main_value ("tb_plantillas").".id_plantilla";
		$rs = $this->db->query ($cons);
		if ($this->db->num_rows ($rs))
			$this->aPlantillas = array ();
		while ($row = $this->db->fetch_array ($rs)) {
			if ($this->debug)
				debug ("set_plts()---> ".$row["nom_plt_sub"]);
			if (!($obj_sesion->change_plt ($row["nom_plt_sub"], $row["nombre"])))
				$obj_sesion->add_plt ($row["nom_plt_sub"], $row["nombre"]);
			$aTmp[0] = $row["nom_plt_sub"];
			$aTmp[1] = $row["hacer_query"];
			$this->aPlantillas[] = $aTmp;
		}
		$this->db->libera ($rs);

		$cons = "select ".$this->sesion->read_main_value ("tb_tipo_plant").".hacer_query as 'hacer_query',".
			$this->sesion->read_main_value ("tb_tipo_plant").".nom_plt_sub as 'nom_plt_sub'".
			" from ".$this->sesion->read_main_value ("tb_tipo_plant").
			" where ".$this->sesion->read_main_value ("tb_tipo_plant").".id_tipo=".
			$this->iden_busq." AND ".$this->sesion->read_main_value ('tb_tipo_plant').".id_plantilla = 0";
		$rs = $this->db->query ($cons);
		if ($this->db->num_rows ($rs))
			$this->aPlantillas = array ();
		while ($row = $this->db->fetch_array ($rs)) {
			// debug("set_plts()---> ".$row["nom_plt_sub"]);
			$aTmp[0] = $row["nom_plt_sub"];
			$aTmp[1] = $row["hacer_query"];
			$this->aPlantillas[] = $aTmp;
		}

	}

 /**
         * Atributo $distinct sin documentar (valor para el distinct 'tabla.campo', 'DISTINCT', 'ROW')
         * Atributo $groupby sin documentar (valor para el groupby 'tabla.campo', 'numero_de_campo_en_select')
         */
	function set_param_query ($tipo, $param = NULL) {
		if ($this->debug)
			debug ("wolSearch->set_param_query($param)::activao = ($this->activao)");
		$param = trim ($param);
		if ($this->activao) {
			if (!strcmp ("ORDER BY", $tipo)) {
				if ($this->aBloqueos['order']) return 1;
				if (empty ($param)) {
					$param = trim($this->sesion->fetchVar ('_search_sort', 'GET'));
					if (empty ($param)) {
						if (!empty ($this->orderby))
							return 1;
						else
							return 0;
					} else { 		// Tenemos parametro de ordenacion, y nos toca.
						if (!empty($this->orderby)) {
							// Eliminamos el order by para obtener solo los terminos
							if (stristr($this->orderby,'order by')) {
								$clausulas = trim(str_replace('ORDER BY','',$this->orderby));
							} else $clausulas = $this->orderby;
							
							// los terminos de ordenacion van separados por , (v1=>solo nos importa el primero)
							$aTmp = split(',',$clausulas);
							if (sizeof($aTmp) AND sizeof($aTmp)>1) {
								$term = array_shift($aTmp);
								$term_extras = '';
								foreach ($aTmp as $t) $term_extras .= $t;
							} else $term = $clausulas;

							if (strstr($term,$param)) { // Si es el mismo campo, cambiamos de sentido
								if (stristr($term,'asc')) {
									$dir .= 'desc';
								} elseif (stristr($term,'desc')) {
									$dir .= 'asc';
								}
							} else { 		// Si no es el mismo campo de ordenacion, manda el que nos acaba de llegar.
								$term = $param;
							}
							if ($this->debug) debug("dir: $dir");
							if (empty($dir)) $dir = 'Desc';

							$aTerm = split(' ',$term);
							$term = $aTerm[0]; // Ya solo nos interesa el campo, no la direccion.
							$aSearchOrder['field'] = $term;
							$aSearchOrder['type'] = $dir;
							if ($this->debug) debug("Setting OrderRequest ");
							// Bloqueamos el order by, ya no puede ser seteado, manda el del usuario
							$this->sesion->set_var('_searchOrderRequest',$aSearchOrder,'SUBSECCION');
							$this->aBloqueos['order'] = 1;
							$param = $term.' '.$dir;
						} elseif (!empty($param)) {
							$aSearchOrder['field'] = trim($param);
							$aSearchOrder['type'] = 'Desc';
							$this->sesion->set_var('_searchOrderRequest',$aSearchOrder,'SUBSECCION');
							$this->aBloqueos['order'] = 1;
							$param .= ' '.$aSearchOrder['type'];
						}
					}
				} elseif (!empty ($this->orderby)) return 1;

				$this->orderby = ' ORDER BY '.$param;
				if ($this->debug)
					debug ("orderby seteao (".$this->orderby.")");

			  /** **
			  for ($i=0;$i<sizeof($this->cons_secc);$i++)
				  if (!empty($this->cons_secc[$i][0])) $this->cons_secc[$i][0].= " ".$this->orderby;
			  /** **/
				return 1;
			}
			elseif (!strcmp ("GROUP BY", $tipo)) {
				if (empty ($param))
					return 0;
				if (!empty ($this->groupby))
					return 0;
				// $this->groupby = " GROUP BY ".$param;
				$this->groupby = $param;
				return 1;
			}
			elseif (!strcmp ("DISTINCT", $tipo)) {
				// if (!empty($this->distinct)) return 1;
				if (empty ($param))
					return 0;
				$this->distinct = (!strcasecmp ("ROW", $param))
					? " DISTINCTROW " : ((!strcasecmp ("DISTINCT", $param))
												? " DISTINCT " : " DISTINCT ".$param." ");
				for ($i = 0; $i < sizeof ($this->cons_secc); $i++)
					if (!empty ($this->cons_secc[$i][0]))
						$this->cons_secc[$i][0] = $this->distinct.$this->cons_secc[$i][0];
				return 1;
			}
		}
		return 0;
	}

	function hay_rows () {
		if (!$this->activao)
			return -1;
		if (!$this->resultados)
			$this->resultados = $this->get_numresults ();
		return $this->resultados;
	}

	function set_iden_busq ($id = 0) {
		if (!$id)
			return 0;
//aviso("entramos en set_iden_busq con $id");
		if ($id != $this->iden_busq) {
//aviso("Cambia iden_busq, reasignamos old_secc");
			$this->old_secc = $this->id_secc;
			$this->old_name = $this->search_name;
		}
		$this->iden_busq = $id;
		$this->get_includes ();
	}

	function get_script_dir () {
		return $this->script_dir;
	}

	/**
	  * Este metodo no solo dispara los includes de la busqueda, sino que tambien establece el nombre de la busqueda.
	  */
	function get_includes () {
		/*
		 * incluido sin documentar 
		 */
		if ($this->debug)
			debug ("get_includes(); incluido = ($this->incluido)");
		if ($this->incluido)
			return 1;
		if (!empty ($this->inc) AND ! $this->incluido) {
			/*
			 * si hay inc y no ha cambiado el iden (no se ignoro) 
			 */
			include_inm ("scripts/buscador/".$this->inc);
			$this->incluido = 1;
		} else {						  /* si se ignoro y estamos aki es pk ha cambiado */
			if (!empty ($this->iden_busq)) {
				$oDb = &$this->db;
				$consulta = "select script,nombre_tipo from ".$this->sesion->read_main_value ("tb_tipbus_subse");
				$consulta .= " where id_tipo=".$this->iden_busq;
				$consulta .= " and id_sub=".$this->sesion->get_id_subsecc ();
				$rs = $oDb->query ($consulta);
				$row = $oDb->fetch_row ($rs);
				if (!empty ($row[0])) {
					$this->set_include ($row[0]);
					// debug("include de ".$row[0]);
					include_inm ("scripts/buscador/".$row[0]);
					$this->incluido = 1;
					$this->search_name = $row[1];
				} else
					$this->incluido = 0;
			}
		}
	}

  /**
	 * Este metodo se encarga de obtener los terminos de busqueda para un determinado campo/variable formatead@ de forma
	 *	  est�ndard. Esto es : "frase exacta" +termino1 termino2 -termino3
	 * @param  $search_string	- Cadena de busqueda formateada.
	 * @return $aTerms	- Array contenedor de los distintos terminos individuales resultantes.
	 **/
	function get_search_terms ($search_string = NULL) {
		static $old_search;
		static $last_return;

		if ((empty ($search_string) OR ! isset ($search_string)) AND ! is_numeric ($search_string)) return NULL;

		$old_search = $search_string;
		$search_string = stripslashes ($search_string);
		if ($this->debug)
			debug ("get_search_terms($search_string)");

		// Todas estas regexp estan probadas y no surtieron el efecto deseado:
		// $aRetVal = preg_split("/\W\b\W/iAD",$search_string,-1,PREG_SPLIT_NO_EMPTY);
		// $aRetVal = preg_split("/([+-])?(\")(.*)(\")([+-])?/i",$search_string,-1,PREG_SPLIT_DELIM_CAPTURE);
		// $aRetVal = preg_split("/([+-]|\")(\"|\s)?/i",$search_string,-1,PREG_SPLIT_DELIM_CAPTURE);
		// $aRetVal = preg_split("/(([+-]\"|\")(.*)?(\"))|(([+-]+|\s+)(.+?)(\s)?)/i",$search_string);
		// //,-1,PREG_SPLIT_DELIM_CAPTURE);
		// $aRetVal =
		// preg_split("/(([+\-]\"|\")(.*?)(\"))|(([+\-]+|\s+)(.+?)(\s|\"))/i",$search_string,-1,PREG_SPLIT_DELIM_CAPTURE);
		// ascii: while ($s =~ s/^([+\-]?([\w]+)|[+\-]*?"([\w ]+)") *// ) { $r[$i++] = $2 || $3 }
		// $aRetVal = preg_split("/([+\-]?([\w]+)|[+\-]*?\"([\w ]+?)\") */i",$search_string,-1,PREG_SPLIT_DELIM_CAPTURE);
		// print_r($aRetVal);
		// $aRetVal = preg_split("/(([+\-]?)([\w]+)|([+\-]*?\")([\w ]+)(\")) */i",$search_string,-1,PREG_SPLIT_DELIM_CAPTURE);
		// $aRetVal = preg_split("/(([+\-]?[\w]+)|([+\-]*?)(\")([\w ]+)(\")) */i",$search_string,-1,PREG_SPLIT_DELIM_CAPTURE);
		// $aRetVal = preg_split("/(([+\-]?)[\w]+|([+\-]*?\"))/i",$search_string,-1,PREG_SPLIT_DELIM_CAPTURE);
		// ascii (simpler): while ($s =~ s/^[-+]*?((\w+)|"([\w ]+)") *// ) {$r .= ($2 || $3) . '|'} 
		// Para quitar tambien las comillas simples:
		// $aTerms = preg_split("/([-+]?[\w]+|[-+]*?[\"'][\w ]+[\"']) */i",$search_string,-1,PREG_SPLIT_DELIM_CAPTURE);

  /** **/
		$aOR = split (" / ", $search_string);
		foreach ($aOR as $search) {
			// El \. ha sido anyadido el 22/07/2004 despues de los \w para que estos incluyan las palabras con . (decimales)
			$aTerms = preg_split ("/([-+]?[\w\.]+|[-+]*?[\"][\w\. ]+[\"]) */i", $search, -1, PREG_SPLIT_DELIM_CAPTURE);
			if ($aTerms) {
				if (is_array ($aRetVal))
					array_push ($aRetVal, array ("joint" => "OR"));
				else
					$aRetVal = array ();
				$aTmpVal = array ();
				foreach ($aTerms as $sT) {
					$sT = trim ($sT);
					if (empty ($sT) AND ! is_numeric ($sT))
						continue;
					if (is_numeric ($npos = strpos ($sT, "-"))) {
						$exclude = 1;
						$sT = substr ($sT, ++$npos);
						$npos = NULL;
					}
					elseif (is_numeric ($npos = strpos ($sT, "+"))) {
						$exclude = 0;
						$sT = substr ($sT, ++$npos);
						$npos = NULL;
					}
					else
					$exclude = 0;
					$sT = str_replace ("\"", NULL, $sT);
					$aTmp['term'] = $sT;
					$aTmp['not'] = $exclude;
					array_push ($aTmpVal, $aTmp);
					$aTmp = NULL;
				}
			} else
				$aTmpVal = NULL;
			foreach ($aTmpVal as $tmp) array_push ($aRetVal, $tmp);
		}

		return $aRetVal;
	}

		  /** hacer_consulta nos compones las querys que va a realizar el buscador.
                * hacer_consulta se encarga de hacer querys sobre las tablas Selects y Wheres y componer
                * tantas querys como distintas secciones haya indicadas en el campo id_secc de las tablas
                * antes mentadas.
                *@param $obj_sesion objeto sesion activo, lo recibe por referencia aunque no lo modifique.
                *@return $this->cons_secc array con todas las querys que realizara el buscador.
                */
	function hacer_consulta (&$obj_sesion) {
		if ($this->debug)
			debug ("wol_search->hacer_consulta()");

		$cons = "SELECT * from ".$this->sesion->read_main_value ("tb_selects");
		$cons .= " WHERE id_tipo=".$this->iden_busq." order by id_secc, id_selec";
//echo "cons3 ".$cons."<br>";
		$rs = $this->db->query ($cons);
		/*
		 * Esta linea no deberia existir, y en el primer if de este while, tener un if !isset($seccion) 
		 */
		$seccion = 88;	// Tite: pk 88 ??????
		if ($this->db->num_rows ($rs))
			while ($row_selec = $this->db->fetch_array ($rs)) {
				// Componemos la parte del SELECT de las querys
				if ($seccion != $row_selec["id_secc"]) {
					/*
					 * Si nos ha cambiado la seccion, tenemos que volver a iniciar una nueva query, pero esta vez en otra posicion de
					 * array 
					 */
					// echo "secc: ".$seccion;
					$j = 0;
					$seccion = (int) $row_selec["id_secc"];
					// salida("seccion = $seccion<BR>\n");
					if ($row_selec["tiene_secc"]) {
						/*
						 * si tiene multiples busquedas (por seccion) la tabla base es la de la seccion 
						 */
						// echo "secc1: ".$seccion;
						$consult = "select tb_base from Secciones where id_seccion=".$seccion;
						$res = $this->db->query ($consult);
						if ($this->db->num_rows ($res))
							$row = $this->db->fetch_array ($res);
						if (empty ($row["tb_base"]))
							$aOrigen[$seccion] = $row_selec["tabla"];
						else
							$aOrigen[$seccion] = $row["tb_base"];
					} else {
						/*
						 * Si no tiene busquedas por seccion, la tabla base es la primera que encontremos en la tabla de Selects 
						 */
						$tabla_agrup = $row_selec["tabla"];
						$aOrigen[$seccion] = $row_selec["tabla"];
					}
					/*
					 * Empezamos (por tanto ponemos el SELECT) a componer la(s) query(s) 
					 */
					if ($this->debug)
						debug ("Componemos SELECT. Acabamos de entrar");
					$partes_selec[$seccion] = ((!empty ($row_selec["tabla"])) ? $row_selec['tabla']."." : "").$row_selec["campo"];
					$partes_selec[$seccion] .= " AS \"".$row_selec["as_campo"]."\"";
					$a_destinos[$seccion][$j] = $row_selec["tabla"];
					$j++;
				} else {
					/*
					 * Si seguimos en la misma seccion... 
					 */
					// echo "secc2: ".$seccion;
					// debug("campo select: ".$row_selec[tabla]);
					$partes_selec[$seccion] .= ", ".((!empty ($row_selec["tabla"])) ? $row_selec['tabla']."." : "").$row_selec["campo"];
					$partes_selec[$seccion] .= " as \"".$row_selec["as_campo"]."\"";

					/*
					 * $partes_selec[$seccion].=",".$row_selec["tabla"].".".$row_selec["campo"]; $partes_selec[$seccion].=" as
					 * \"".$row_selec["as_campo"]."\""; 
					 */
					if (!(in_array ($row_selec['tabla'], $a_destinos[$seccion]))) {
						$a_destinos[$seccion][$j] = $row_selec["tabla"];
						$j++;
					}
				}
					
				$aFlds = $this->db_data->get_fields($row_selec['tabla']);
				$this->_aCache['EntityDataTypes'][$row_selec['tabla']] = $aFlds;
				if (!$this->sesion->gotEntityDataType($row_selec['tabla'])) {
					$this->sesion->setEntityDataType($row_selec['tabla'],$aFlds);
				}
			}							  // while
		reset ($aOrigen);

		$cons = "SELECT * from ".$this->sesion->read_main_value ("tb_wheres");
		$cons .= " WHERE id_tipo=".$this->iden_busq." ORDER by id_secc, nom_var_form, id_where";
//echo "cons4: ".$cons."<br>";
		$rs = $this->db->query ($cons);
		$j = 0;
		$aVistos = array ();
		$visto = 0;
		$visto_old = 0;

		$n_vars = $this->db->num_rows($rs);
		if ($this->db->num_rows ($rs))
			for ($i=0;$row_where=$this->db->fetch_array($rs);$i++) {
				// Componemos las partes WHERE de las querys (recuerda que por seccion)
				$var_form = NULL;
				$var_form = $this->sesion->fetchVar($row_where['nom_var_form'],'GLOBAL SESSION POST GET');

				$seccion=(int)$row_where['id_secc'];
				if ($this->debug) debug ("nom_var_form = ".$row_where['nom_var_form']);

				if (isset ($var_form) OR $this->busqueda_forzada OR $row_where["operator"] == "between") {
					if (!is_array ($aVistos[$seccion]))
						$aVistos[$seccion] = array ();
					/*
					 * hay que tener en cuenta que la clausula where tiene 2 partes una entre () para las condiciones de busqueda y
					 * otra sin () para las condiciones de enlace que vienen de wol_db->ruta(). Sin embargo, cuando ponemos los )(
					 * para agrupar los or y los and dentro de las condiciones de busqueda se 'rompen' los parentesis que lo
					 * contienen. Ojito con esto, sobretodo porque va por seccion. 
					 */
					// if (empty($mi_where[$seccion])) $mi_where[$seccion] .= "( ";
					if ($row_where["operator"] == "between" OR $row_where['operator'] == 'date') {

						/*
						 * Lo primero que comprobamos es la busqueda por fechas 
						 */
						$__f1 = $this->sesion->fetchVar($row_where['nom_var_form'].'_inicio','GLOBAL SESSION POST GET');
						$__f2 = $this->sesion->fetchVar($row_where['nom_var_form'].'_fin','GLOBAL SESSION POST GET');
						$__fX = $var_form;

						if (isset ($__f1)) {
							$__f1 = wol_db::formatear_fecha($__f1);
							if ($__f1=='NULL') $__f1 = NULL;
						}
						if (isset ($__f2)) {
							$__f2 = wol_db::formatear_fecha($__f2);
							if ($__f2=='NULL') $__f2 = NULL;
						}
						if (isset ($__fX)) {
							$__fX = wol_db::formatear_fecha($__fX);
							if ($__fX=='NULL') $__fX = NULL;
						}

						// debug("Fechas ($__f1) ($__f2) ($__fX) ");
						if ((isset ($__f1) AND ! empty ($__f1)) OR (isset ($__f2) AND ! empty ($__f2))
							 OR (isset ($__fX) AND ! empty ($__fX))) {

							// Si nos ha quedado un parentesis abierto, debido al ultimo cambio de nom_var_form, lo cerramos
							if ($bParOpen) {
								$mi_where[$seccion] .= ") ";
								$bParOpen = FALSE;
							}

							$campo = $row_where['tabla'].'.'.$row_where['campo'];
							$strWhere = NULL;
							if (!empty ($__fX)) {	// Fecha exacta.
								$strWhere = $campo.' = '.$__fX;
							} elseif (!empty ($__f1) AND ! empty ($__f2)) {	// Rango de fechas.
								$strWhere = $campo." between ".$__f1." and ".$__f2;
							} elseif (!empty ($__f1)) {	// fechas superiores a __f1
								$strWhere = $campo." >= ".$__f1;
							} elseif (!empty ($__f2)) {	// fechas inferiores a __f2
								$strWhere = $campo." <= ".$__f2;
							}

							if (!empty ($strWhere)) {
								if (!empty ($mi_where[$seccion]))
									$mi_where[$seccion] .= " and ";
								$mi_where[$seccion] .= " ($strWhere) ";
							}

							if (!in_array ($row_where['tabla'], $a_destinos[$seccion])) {
								if ($this->debug) debug ($row_where['tabla']." NO estaba en la tabla Selects");
								array_push ($a_destinos[$seccion], $row_where['tabla']);
							}
						} else continue;
					} elseif (isset ($var_form)) {	// AND !empty($$row_where["nom_var_form"])) 
						$new_var = $row_where['nom_var_form'];
						$visto_old = $visto;
						$tmp_check = trim ($var_form);
						if ($this->debug)
							debug ("Contenido($new_var) : $tmp_check - ".is_numeric($tmp_check));

						//Si el termino tiene contenido, componemos.
						if (!empty($tmp_check) OR is_numeric($tmp_check)) {

							if (!in_array ($row_where['tabla'], $a_destinos[$seccion])) {
								if ($this->debug)
									debug ($row_where['tabla']." NO estaba en la tabla Selects");
								array_push ($a_destinos[$seccion], $row_where['tabla']);
							}

							if (!in_array ($row_where['nom_var_form'], $aVistos[$seccion])) {
								$aVistos[$seccion][sizeof ($aVistos[$seccion])] = $row_where['nom_var_form'];
								$visto = 0;
							} else {
								$visto = 1;
							}

							if ($this->debug)
								debug ($row_where['nom_var_form'].
										 (($visto) ? " Ya vista (OR) ($old_var - $new_var - $visto)"
										  : " Nueva (AND) ($old_var - $new_var - $visto)"));

							// cierre de parentesis abierto cuando cambia un nom_var_form

							if ( (!empty($old_var) OR is_numeric($old_var))  AND strcmp ($old_var, $new_var)
								 AND in_array($old_var,$aVistos[$seccion]) AND !$visto AND $bParOpen) {
								$mi_where[$seccion] .= ") ";
								$bParOpen = false;
							}

							if (!empty ($mi_where[$seccion]))
								$mi_where[$seccion] .= ($visto) ? " or " : " and ";

							// Apertura de parentesis al comenzar a analizar un nombre de variable (no de campo) -ord por nom_var_form-
							if ( ( (!empty($old_var) OR is_numeric($old_var)) AND strcmp ($old_var, $new_var)
								AND in_array($old_var,$aVistos[$seccion]) AND !$visto) OR (empty($old_var) AND !$visto) ) {
								$mi_where[$seccion] .= " (";
								$bParOpen = true;
							}

							$mi_where[$seccion] .= " (";

						  /** **
								$mi_where[$seccion] .= $row_where["tabla"].".".$row_where["campo"];
								if(  ( (gettype($$row_where["nom_var_form"])=="string") AND
												  ($row_where["operator"]=="like") ) ) //or ($this->busqueda_forzada)  )
									 $mi_where[$seccion] .= " like \"%".$$row_where["nom_var_form"]."%\"";
								elseif ((gettype($$row_where["nom_var_form"])=="integer"))
									 $mi_where[$seccion] .= $row_where["operator"]. $$row_where["nom_var_form"];
						  /** **/

							$aTerms = $this->get_search_terms ($var_form);

							if ($this->debug) {
								debug ("Terminos de busqueda: ");
								print_r ($aTerms);
							}

						  /** **/
							$tabla = $row_where['tabla'];
							$campo = $row_where['campo'];
							$operador = $row_where['operator'];
							if (is_array ($aTerms)) {
								$mi_where[$seccion] .= "( ";
								$do_and = 0;
								$do_or = 0;
								foreach ($aTerms as $idx => $aTerm) {
									if (!empty ($aTerm['joint'])) {
										$mi_where[$seccion] .= ") ".$aTerm['joint']." ( ";
										$do_and = 0;
									}
									if (empty ($aTerm['term']) AND ! is_numeric ($aTerm['term']))
										continue;
									if ($do_and)
										$mi_where[$seccion] .= " AND ";
									// $mi_where[$seccion] .= "( ";
									$mi_where[$seccion] .= $tabla.".".$campo." ";
									if ($operador == "like") {
										$string = TRUE;
										if ($aTerm['not'])
											$oper = "not ".$operador;
										else
											$oper = $operador;
									} else {
										if (!is_numeric ($aTerm['term']))
											$string = TRUE;
										else
											$string = FALSE;
										if ($aTerm['not'])
											$oper = "!$operador";
										else
											$oper = $operador;
									}
									$mi_where[$seccion] .= "$oper ";
									$mi_where[$seccion] .= (($string)
																	? "'".((!strcmp ($operador, 'like')) ? '%' : '')
																	: NULL).$aTerm['term'].(($string)
																								 ? ((!strcmp ($operador, 'like')) ? "%" : '')."'" : NULL);
									// $mi_where[$seccion] .= " )";
									$do_and = 1;
								}
								$mi_where[$seccion] .= " )";
							}

						  /** **/
							$old_var = $row_where['nom_var_form'];
							$mi_where[$seccion] .= ") ";
							// kitao, pue tar a unset else aviso("No se encontro el tipo de comparacion por campo");
							// ninguno de los anteriores
							// debug($mi_where[$seccion]." ($seccion)");
						}
					}	// if de nom_var_form ultimo
				} // end-if de nom_var_form o busqueda forzada.. o betwees
				// Si nos ha quedado un parentesis abierto, debido al ultimo cambio de nom_var_form, lo cerramos
				if ($bParOpen AND ($i == ($n_vars-1) OR $seccion != $old_seccion)) {
					$mi_where[$seccion] .= ") ";
					$bParOpen = FALSE;
					$old_seccion = $seccion;
				}
			}	// while

		for ($i = 0; list ($clave, $valor) = each ($aOrigen); $i++) {
			$origenes[$i] = $valor;
		}
		reset ($aOrigen);

		for ($i = 0; list ($clave, $valor) = each ($a_destinos); $i++) {
			$tope = count ($valor);
//salida("(hacer_consulta) tope ".$tope."<br>");
			for ($j = 0; $j < $tope; $j++) {
				if (strcmp($valor[$j],$origenes[$i])) {
				$destinos[$i][$j] = $valor[$j];
// debug("dessss".$valor[$j]."i:".$i."<br>");
				}
			}
		}
		reset ($a_destinos);

		for ($i = 0; list ($clave, $valor) = each ($partes_selec); $i++) {
			/** Volviendo atras fix-insercion en llamada a metodo ruta desde la busqueda **
			  * Ejemplo de mal funcionamiento:
			  *	El buscador de pedidos, inserta un campo select "SUM(IVAs.monto) as 'iva'", por consiguiente esto se inserta
			  * en los from de la api (la tabla IVAs), y si tenemos este parche, entrara a formar parte del conjunto de tablas
			  * destino de la llamada al metodo ruta. Dicha busqueda, tiene como destinos previos: Direcciones_entrega, Clientes, Pedidos
			  * (en ese orden). Al insertar esta nueva tabla en destinos, pasa por Facturas, enlazando Clientes con Facturas, y Facturas
			  * con IVAs, cuando una de las tablas ya indicadas en los destinos, esta mas cerca de IVAs, sin necesidad de insertar 
			  * una nueva tabla no solicitada.
			  ***/
			// Obtenemos los From de la API (las que se puedan meter directamente a ruta -es decir, sin alias-)
			if (is_object($this->oSearchAPI)) {
				$bUseLeftJoin = (bool) $this->oSearchAPI->bUseLeftJoin;
				$aFrom_api = $this->oSearchAPI->get_from();
				if (is_array($aFrom_api)) {
					if (!is_array($destinos[$i])) $destinos[$i] = array();
					foreach ($aFrom_api as $aFrom) 
						if (is_array($aFrom) AND empty($aFrom[1])) { // No nos interesan los from XXXX as YYY, dado que no los soporta ruta()
							if (!is_array($aFrom[0]) AND !in_array($aFrom[0],$destinos[$i])) {
								array_push($destinos[$i],$aFrom[0]);
							}
						} else {
							if (!is_array($aFrom[0]) AND !in_array($aFrom[0].':'.$aFrom[1],$destinos[$i])) {
								//TODO: De momento, no hay soporte de aliasin en metodo ruta
								// array_push($destinos[$i],$aFrom[0].':'.$aFrom[1]);
							}
						}
				}
			} else $bUseLeftJoin = false;

			/** **/
			$resultados = $this->db_data->ruta ($origenes[$i], $destinos[$i], NULL,
															(($tmpruta = $this->oSearchAPI->get_ruta_path ())? $tmpruta : NULL),
															(($tmpruta = $this->oSearchAPI->get_not_ruta_path ())? $tmpruta : NULL));

			// return;
			/** **/

			if (!$bUseLeftJoin) {
				foreach ($resultados[1] as $parte_del_from) {
					$partes_from[$clave] .= ((!empty ($partes_from[$clave])) ? ", " : " FROM ").$parte_del_from;
				}
			} else {
				/** ** Fixme: Activar este codigo, comprabndo que las busquedas en ventas van bien.,
				/** **/
				$partes_from[$clave] .= ((!empty ($partes_from[$clave])) ? ", " : " FROM ").$resultados['left_join_from'];
			}

	  /** **/
			// Obtenemos los From de la API (El resto, es decir, los que no se hayan insertado ya)
			if (is_object ($this->oSearchAPI)) {
				$aFrom_api = $this->oSearchAPI->get_from ();
				if (!empty ($aFrom_api) AND is_array ($aFrom_api)) {
					foreach ($aFrom_api as $aFrom) {
						if (empty ($aFrom[1]) AND in_array ($aFrom[0], $resultados[1]))
							continue;
						$chorizo = $aFrom[0].((!empty ($aFrom[1])) ? ' as `'.$aFrom[1].'` ' : '');
						if (!empty ($partes_from[$clave]))
							$partes_from[$clave] .= ", ".$chorizo;
						else
							$partes_from[$clave] .= " FROM ".$chorizo;
					}
				}
			}

	  /** **/

			if ($this->debug)
				debug ("clave (".$clave.") mi where (".$mi_where[$clave].")");

			$this_where = trim ($mi_where[$clave]);
			if (!empty ($resultados[0])) {
				if (!empty ($this_where)) {
					if (!$bUseLeftJoin) {
						$partes_where[$clave] = " where ( ".$this_where." ) and ".$resultados[0];
					} else {
						/** ** Fixme: Activar este codigo, comprabndo que las busquedas en ventas van bien.,
						/** **/
						$partes_where[$clave] = " where ( ".$this_where." ) ";
					}
				} else {
					if (!$bUseLeftJoin) {
						$partes_where[$clave] = " where (".$resultados[0].") ";
					}
					/** ** Fixme: Activar este codigo, comprabndo que las busquedas en ventas van bien.,
					  Esta parete desapareceria. las condiciones no estarian en el where, sion en el from
					/** **/
				}
			} else if (!empty ($this_where)) {
				$partes_where[$clave] = " where (".$this_where.") ";
			}

			// else $partes_where[$clave] = " WHERE ";
			if ($this->debug)
				debug ("El where base = |".$partes_where[$clave]."|");

			$cons = "select titulo,ficha_sub from Secciones where id_seccion=".$clave;
			$rs = $this->db->query ($cons);
			if ($row = $this->db->fetch_array ($rs)) {
				$select_seccion = " \"".$row['titulo']."\" as \"Nombre_de_seccion\", '".$row['ficha_sub']."' as 'SubSecc_Ficha' ";
			} else {
				$select_seccion = " \"".$tabla_agrup."\" as \"Nombre_de_seccion\" ";
			}

			// Separamos los from y las condiciones para obtener info mas exclusiva.
			$tmp_from = NULL;
			$tmp_where = NULL;
			$tmp_from = $partes_from[$clave];
			$tmp_where = $partes_where[$clave].
						( ( ($tmp_w=$this->oSearchAPI->get_wheres()) ) 
						  ?  ((!empty($partes_where[$clave])) ? " AND " : " WHERE ")." $tmp_w " 
						  : "" );

			$consult = ((!strcasecmp ($this->distinct, " DISTINCT ") ||	// Caso de no tener nombre de campo el distinct
							 !strcasecmp ($this->distinct, " DISTINCTROW "))	// o de ser un distinctrow
							? $this->distinct	// Lo metemos directamente al tener en
													// en partes_select el primer nombre de campo.
							: (($this->distinct) ? $this->distinct.", " : "")	// Si no es asi...
																								// Ponemos el distinct campo si existe
							).$partes_selec[$clave].					// A�adimos la parte SELECT
							((($tmpvar = $this->oSearchAPI->get_selects ()))
							 ? ", $tmpvar" : "").										// A�adimos los campos extra que se necesiten
																								// A�adimos el nombre de seccion como parte de la query
							((!empty ($select_seccion)) ? ", ".$select_seccion : "").
							$partes_from[$clave].$partes_where[$clave].
							((($tmp_w = $this->oSearchAPI->get_wheres ()))		// A�adimos las  condiciones extra que se necesiten
							 ? ((!empty ($partes_where [$clave])) ?  " AND " : " WHERE ").
							 " $tmp_w " : "").
							((!empty ($this-> groupby)) ?  " GROUP BY ".  $this-> groupby : "");
// echo "<b>xo</b>sul ".$consult."<br>";

//Calculo del incremento en el numero de resultados a mostrar
			if ($this->debug)
				debug ("Justo antes del count distinct tiene.... ($this->distinct)");
			$last_groupby = NULL;
			$aT = split(',',$this->groupby);
			if (is_array($aT)) $last_groupby = $aT[sizeof($aT)-1];
			$aT = NULL;
			unset($aT);
			if (!empty($tabla_agrup)) {
				$aK = $this->db_data->obtener_clave ($tabla_agrup);
				if (is_array($aK) AND sizeof($aK)) 
					foreach ($aK as $k) 
						$str_groupkeys .= ( (!empty($str_groupkeys)) ? ', ' : ' ' ).$tabla_agrup.'.'.$k;
			}

			$cons = "select count(".((!strcasecmp ($this->distinct, " DISTINCT ") ||	// Si es un distinct sin campo
											  !strcasecmp ($this->distinct, " DISTINCTROW "))	// o un distinctrow (tb sin campo)
											 ? ((!empty ($str_groupkeys) )	// Si tiene tabla de agrupacion
												 ? $this->distinct.$str_groupkeys	// le metemos campos primary_key
												 : "*")	// sino... NO ponemos distinct
											 : (($this->distinct)	// Si Hay un distinct con nombre de campo
												 ? $this->distinct	// lo ponemos
												 : ((!empty ($last_groupby))	// Sino hay distinct, comprobamos el groupby
													 ? "DISTINCT ".$last_groupby // Si hay agrupacion, contamos solo los result agrupados
													 : "*")	// Sino agrupamos, .. NO ponemos distinct
											 )
											 ).")".$partes_from[$clave].$partes_where[$clave].
											((($tmp_w = $this->oSearchAPI->get_wheres ()))	// A�adimos las condiciones extra que se necesiten 
											 ? ((!empty ($partes_where[$clave])) ? " AND " : " WHERE ")." $tmp_w "
											 : "");

			if ($this->debug)
				debug ("La query del count!:\n $cons");
			// $rs= $this->db_data->query($cons);
			// $row=$this->db_data->fetch_array($rs);
			$consulta = "SELECT ".$consult;

			$aTmp[0] = $consulta;
			$aTmp[1] = $cons;
			$aTmp['from'] = $tmp_from;
			$aTmp['where'] = $tmp_where;
			$this->cons_secc[] = $aTmp;

			if ($this->debug)
				debug ("La query!:\n$consulta");
		}								  // for

		if ($this->debug) {
			debug ("wol_search->hacer_consulta() --> return this->cons_secc(".sizeof ($this->cons_secc).")");
		}
		return $this->cons_secc;

	}									  // Fin de hacer_consulta

	function get_id (&$obj_sesion, $nom_plt) {
		static $nPeticion;
		static $final;
		static $puntero;

		// aviso("nalisando $nom_plt");
		if (empty ($nom_plt)) {
			aviso ("b get_id ($nom_plt)");
			return 0;
		}
		if (!(isset ($nPeticion)))
			$nPeticion = 0;
		$nPeticion++;
		if ($this->id AND $this->aBloqueos['id']) {
			if ($this->debug) debug("Id ".$this->id." blokeado... a tomar pol culo");
			return $this->id;
		}
//Obtengo el puntero a las consultas
		$reg_act = ($this->pagina * $this->hits_page);
		$tope = sizeof ($this->cons_secc);
		if ($this->debug) debug ("habra id activo? ".$this->id." y num consultas = $tope<BR>\n");

		// Fix click en otro enlace antes de guardar la sesion anterior, con lo cual la instancia de busquedas se recuperaba de la sesion
		//  (en la siguiente recarga) con un id de resultados no vigente en la carga actual.
		if ($this->id AND $this->get_numresults() AND !$this->db_data->num_rows($this->id)) {
			$this->id = NULL;
		}

		if (!($this->id)) {		  // I1
			// Averiguamos el limite que vamos a poner en la consulta k toke.
			// Mirar a ver como 00 lo hacemos
			if ($this->debug)
				debug ("no hay id de busqueda activo");

			$this->get_numresults ();
			$acumulado = 0;
			for ($i = 0; $i < $tope; $i++) {
				$acumulado += $this->cons_secc[$i][2];
				if ($this->debug)
					debug ("acumulado = $acumulado; reg_act = $reg_act");
				if ($acumulado > $reg_act) {
					$acumulado -= $this->cons_secc[$i][2];
					$inicio = $reg_act - $acumulado;
					$final = $this->cons_secc[$i][2] - $inicio;
					/*
					 * Si hay registros bastantes en esta query , o si no hay mas querys blokeamos el id y metemos el limite k sea 
					 */
					if ($final >= $this->hits_page OR ! is_array ($this->cons_secc[$i + 1])) {
						$this->aBloqueos['id'] = 1;
						$final = $this->hits_page;
					}
					$puntero = $i;
					break;
				}
			}							  // fin for i<tope

			// if (!empty($this->orderby)) $this->cons_secc[$puntero][0].= " ".$this->orderby;
			if ($this->debug)
				debug ("puntero = $puntero");

			if ((int) $this->hits_page) {
				if ($i != $tope) {
					$cons =
						$this->cons_secc[$puntero][0].((!empty ($this->orderby)) ? $this->orderby : '')." limit ".(int) $inicio.
						",".(int) $final;
				} else {
					$puntero = 0;	  // cue
					if (!empty ($this->cons_secc[$puntero][0]))
						$cons = $this->cons_secc[$puntero][0].((!empty ($this->orderby)) ? $this->orderby : '').
							" limit ".(int) $inicio.",".(int) $this->hits_page;
				}
			} else
				$cons = $this->cons_secc[$puntero][0].((!empty ($this->orderby)) ? $this->orderby : '');
			if ($this->debug)
				debug ("get id cons = $cons; tope=$tope; inicio = $inicio; final=$final;");

		} else {						  // else de I1 (hay id_activo)
			/*
			 * Recordemos que $final es el puntero al ultimo resultado 
			 */
			if ($this->debug)
				debug ("peticion $nPeticion ; final $final");
			if ($nPeticion <= $final OR empty ($final)) {
				if ($this->debug)
					debug ("Sin final, retornamos este id ($this->id)");
				return $this->id;
			}
			if ($this->debug)
				debug ("Comprobando si hay mas consultas ... en($puntero) hp(".$this->hits_page.") pet($nPeticion)");
			/*
			 * Si los resultados actuales son inferiores a los k necesitamos para completar la pagina.... 
			 */
			$inicio = 0;
			/*
			 * Preparamos la parte de la consulta k es comun 
			 */
			if ((int) $this->hits_page) {
				// $puntero++; 
				// Avanzamos a la siguiente consulta.
				while (is_array ($this->cons_secc[++$puntero])) {
					if ($this->debug)
						debug ("Avanzando ... $puntero");
					$cons = $this->cons_secc[$puntero][0].((!empty ($this->orderby)) ? $this->orderby : '').
						" limit ".(int) $inicio.",";
					if ($this->cons_secc[$puntero][2] > 0 AND $this->cons_secc[$puntero][2] < ($this->hits_page - $final)) {
						if ($this->debug)
							debug ("El numero de resultados de la Siguiente: ".$this->cons_secc[$puntero][2]);
						if ($this->debug)
							debug ("Nos quedan: ".($this->hits_page - $final));
						/*
						 * Comprobamos si hay mas consultas para blokear id o no 
						 */
						if (!isset ($this->cons_secc[$puntero + 1])) {
							if ($this->debug)
								debug ("No hay mas querys, bloqueamos esta.");
							$cons .= ($this->hits_page - $final);
							$this->aBloqueos['id'] = 1;
							break;
						}
						elseif ($this->debug) debug ("No bloqueamos el ID, hay mas...".$this->cons_secc[$puntero][2]);
						/*
						 * Extraemos tantos registros como tenga la cons (son insuficientes)
						 */
						$cons .= $this->cons_secc[$puntero][2];
						/*
						 * Ponemos un nuevo final (punto donde re-analizar el invento) 
						 */
						$final += $this->cons_secc[$puntero][2];
						break;
					}
					elseif ($this->cons_secc[$puntero][2] > 0) {	// en esta consulta hay los reg k necesitamos
						/*
						 * blokeamos pk no necesitamos mirar mas, aki estan todos 
						 */
						$this->aBloqueos['id'] = 1;
						/*
						 * Cogemos solo los k necesitamos 
						 */
						$cons .= ($this->hits_page - $final);
						break;
					}
					else {
						$cons = NULL;
					}
				}
			} else {
				if ($this->debug)
					debug ("Todos los resultados, no hay hits_page");
				$cons = $this->cons_secc[++$puntero][0];
			}
		}								  // I1

		/*
		 * hacemos consulta 
		 */
		if (!empty ($cons)) {
			// debug("Lanzamos consulta $cons ... ");
			$this->id = $this->db_data->query ($cons);
		} else {
			$this->id = NULL;
		}

		/*
		 * devolvemos id 
		 */
		return $this->id;
	}									  // Fin de get_id

	function get_numresults ($bForce = FALSE) {
		$retval = 0;
		if (!isset ($bForce)) $bForce = FALSE;
		if (!$this->activao) return 0;
		if (is_array ($this->cons_secc))
			foreach ($this->cons_secc as $idx => $aTmp) {
				if (is_numeric ($aTmp[2]) AND !$bForce) {
					$retval += $aTmp[2];
				} else {
					// Si todavia no sabemos el numero de resultados total. Lo calculamos.
					if (!empty ($aTmp[1])) {
						$tmprs = $this->db_data->query ($aTmp[1]);
						if ($this->db_data->num_rows ($tmprs)) {
							$aCount = $this->db_data->fetch_row ($tmprs);
							$this->cons_secc[$idx][2] = NULL;
							$this->cons_secc[$idx][2] = (int) $aCount[0];
						}
						$this->db_data->libera ($tmprs);
					} else
						$this->cons_secc[$idx][2] = 0;
					$retval += $this->cons_secc[$idx][2];
					$this->sesion->set_var ("num_resultados", $retval, "SUBSECCION");
				}
			}
		return $retval;
	}

	function cerrar () {
		// debug("Cerrando joder!");
		if (0 AND $this->busqueda_forzada) {
			unset ($this->busqueda_forzada);
			// unset($this->aPlantillas);
		}

		$this->incluido = 0;
		if ($this->debug)
			debug ("(1)Chapamos el buscador y reseteamos incluido($this->incluido)");

		// $this->sesion = NULL;
		unset($this->sesion);

		// Esto esta tovia por ver
		// -no- unset($this->db);
		// -no- unset($this->db_data);
		if (is_object ($this->db)) {
			unset($this->db);
		}
		if (is_object ($this->db_data)) {
			unset($this->db_data);
		}

		if ($this->debug)
			debug ("(2)Chapamos el buscador y reseteamos incluido($this->incluido)");
		if (is_object ($this->oSearchAPI))
			$this->oSearchAPI->cerrar ();

		$this->aBloqueos['order'] = 0;
		if ($this->debug)
			debug ("(3)Chapamos el buscador y reseteamos incluido($this->incluido)");
		unset ($this->id);
		unset ($this->aPltWheres);

		if (is_array($this->_aoMod) and sizeof($this->_aoMod))
			foreach (array_keys($this->_aoMod) as $i) {
				$clase = get_class($this->_aoMod[$i]['instance']);
				unset($this->_aoMod[$i]['instance']);
				$this->_aoMod[$i] = NULL;
				unset($this->_aoMod[$i]);
			}

	}

/* Funcion que indica si el buscador reconoce una plantilla para trabajar con ella */
	function reconocer_plt ($plantilla) {
	   static $old_plt;
	   if ($this->debug)
	      debug ("reconocer_plt($plantilla) (".$this->activao.")");

	   if (!$this->activao) return 0;
		
	   // if ($this->debug) depurar_array($this->aPlantillas);
	   $tope = count ($this->aPlantillas);
	   for ($i = 0; $i < $tope; $i++) {
	      if ($this->aPlantillas[$i][0] == $plantilla) {	/* AND ($this->aPlantillas[$i][1]=="Si" OR
																			 * $this->aPlantillas[$i][1]=="No") ) */
		 // Tst: $this->activao=1;
		 if (strcmp ($old_plt, $plantilla)) {
		    $old_plt = $plantilla;
		    unset ($this->aPltWheres);
		 }
		
		 // debug("Colocar aqui($blok_name) el Orderby (".$this->orderby.")?");
		 // Antes de que el orden lo indique la plantilla, aceptamos peticiones.
		 $this->set_param_query ('ORDER BY');
		 if ($this->debug) debug ("PLANTILLA RECONOCIDA");
		 return 1;
	      }
	   }
	
	   // Tst: $this->activao=0;
	   return 0;
	}

	function get_include () {
		return $this->inc;
	}

	function set_include ($inc) {
		$this->inc = $inc;
	}

	function reconocer_bloque ($blok_name) {
		if (empty ($blok_name) OR !strcasecmp($blok_name, "busc")) {
			return 1;
		} else
			return 0;
	}

/** Metodo que nos devuelve el array con los datos a presentar en el
    bucle indicado por $nom_bcl */
	function get_plt_data (&$obj_sesion, $nom_bcl = "") {
		if (!$this->activao)
			return array ();

/* para k trage los bucles vacios ;)
        if (!isset($nom_bcl) OR empty($nom_bcl)) {
    return 0;
  }
        */
		if ($this->debug)
			debug ("b_activa->get_plt_data($nom_bcl)");
		if (!strcmp ($nom_bcl, "busc")) {
			$id = $this->get_id ($obj_sesion, $obj_sesion->get_plt_name ());
			if (is_numeric($id)) {
				$RetVal = $this->db_data->fetch_array ($id);
			} else $RetVal = NULL;

			return $RetVal;
		}
		if (is_array ($this->aPltWheres) AND ! in_array ($nom_bcl, $this->aPltWheres)) {
			$tope = count ($this->aPltWheres);
			$this->aPltWheres[$tope] = $nom_bcl;
			// $RetVal = array();
			$RetVal["vacio"] = "nada";
		} else
			$RetVal = array ();
		return $RetVal;

	}

}										  // Fin de la clase

?>
