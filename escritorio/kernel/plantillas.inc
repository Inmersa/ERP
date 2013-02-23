<?php

//debug("Antes de nada ");

/******* Descripcion :

  V 1.0
  Este es un motor de plantillas para Wol Studios. Utiliza un sistema
  recursivo ligeramente enrevesado dado que asi lo requieren las necesidades.
  Este motor de plantillas soporta bucles anidados en las mismas. El sistema
  de funcionamiento esta todavia por documentar. :O
  Presunciones:
  - Este modulo necesita que quien lo incluya use el modulo db.inc como modulo
  de conexion a bases de datos.
  *******************/

/** Funciones de Parseo de Plantillas:
NOTA: Cada comando de parseo ha de tener 2 funciones. Una la que lee la linea
de la plantilla y otra la que lee la linea de la estructura de arbol de
memoria. Ambas dos se complementan **/
$parser_func = array ();
$parser_func["db"] = array ("datos_db", "wdatos_db");
$parser_func["css"] = array ('','datatype_css');

$parser_func["img"] = array ("load_imgs", "wload_imgs");

$parser_func["where"] = array ("do_where", "wdo_where");
$parser_func["end-where"] = array ("undo_where", "wundo_where");

$parser_func["set"] = array ("do_set", "wdo_set");
$parser_func["unset"] = array ("do_unset", "wdo_unset");
$parser_func["get"] = array ("do_get", "wdo_get");
$parser_func["func"] = array ("", "wdo_func");

$parser_func["env"] = array ("", "do_env");

$parser_func["calc"] = array ("", "wdo_calc");

$parser_func["plt"] = array ("", "wdo_plt");

$parser_func["if"] = array ("", "wdo_if");
$parser_func["else"] = array ("", "wdo_else");
$parser_func["end-if"] = array ("", "wdo_endif");

$recur_func["lector"] = "lector_plantilla";
$recur_func["scanner"] = "scanner";

/** Array con el contenido de nuestra plantilla **/
$Plantilla = array ();
$fPoint = 0;						  /* Este es el puntero del fichero contenido en $Plantilla * */
$aPlantillas = array (array ());
$afPoint = array ();
$nPlantilla = -1;

//debug("Antes del bucle-class ");
/*** Descripcion :
  La clase bucle es primordial para el funcionamiento de este motor.
  TODO es considerado como un bucle, hasta el registro que figura en la
  raiz.
  ***/
class bucle {
	var $nombre = "";				  /* Nombre identificativo del objeto */
	var $modo = "array";			  /* Distingue si volcado de id o array completo */
	var $contador;					  /* Vble para contar las iteraciones del bucle */
	var $lineas = array ();		  /* lineas de plantillas a repetir */
	var $tablas;					  /* Array bidimensional con todas las tablas (en pos 0) y campos necesarios */
			/** soporte extra from **/
	var $aExtraFroms = array();
			/** **/
	var $tabla;						  /* Tabla principal */
	var $clave;						  /* Clave principal para la buskeda */
	var $grf_dir = "../grfx";	  /* Directorio donde se almacenan los graficos */

	var $resultados;				  /* Id de resultados de la buskeda */
	var $aDatos;					  /* Tabla de datos del registro actual. Estos son los datos que se filtraran con las lineas de
										   * plantilla */
	var $bDirecto;					  /* Indica si se saca la plantilla directa a navegador */
	var $hacerquery;				  /* si el motor se encarga de obtener los datos */


	var $hijos;						  /* Array de instancias bucle. las distintas ramas del arbol */
	var $hijos_point = 0;		  /* Puntero al siguiente hijo que le toke */
	var $padre;						  /* Puntero a la instancia padre (caso de existir). Tenemos un arbol doblemente enlazado.  */
	var $completo = 0;			  /* flag indicativo de si el bucle esta completito o no.  */


	var $cfunc;						  /* Funcion condicional de visualizacion. va a recibir como parametros la sesion y el array de
										   * datos actual.  */
	var $omitir;					  /* Para if,else...  */
	var $nodb;						  /* Funcion k devuelve el aDatos. va a recibir la sesion y el array de datos actual.  */
	var $warnlev = 0;				  /* Nivel de salida de warnings */
	var $debug;						  /* verbose level */
	var $seguir;					  /* */

		/** variable booleana que indica si se escapan las secuencias de
			* escape html de la base de datos o no
		 */
	var $html_escape = 0;
	var $format_fields = true;

	var $nores = 0;					 /** Valor por defecto para la visualizacion de un msg standard de 
	 																	no se han encontrado resultados **/

	var $funciones = array ();	  /* Array con funciones para comando db */
	var $nolink;					  /* Flag para la opcion no link al padre */
	// var $nombre; /* Opcion del comando where para identificarlo
	// mediante un nombre.  */
	var $where;
	var $extra_select;			  /* Opciones especiales de la SELECT cosas como un SUM o paranoias del estilo */
	var $group;						  /* Clausula GROUP BY de la consulta */
	var $limit;						  /* Parte limit de la query , opcion del cmd where */
	// var $aPunteros;				  /* Array de punteros actuales a campos para la opcion */
	/*
	 * trocear referenciado por el nombre del campo 
	 */
	var $ruta_path = array ();	  // Array para las tablas intermedias
	var $not_ruta_path = array ();	// Array para las tablas por las que no queremos pasar 

	function bucle ($arg = NULL) {
		$this->debug = 0;
	} 
	
	function get_debug () {
		return $this->debug;
	}
	function set_debug ($arg = 1) {
		$this->debug = (int) $arg;
	}

function add_func ($funcion) { 
	$tope = count ($this->funciones);
	$this->funciones[$tope] = $funcion;
	return $tope;
}

	function set_ruta_path ($ruta_path) {
		// debug("<h1>PAso por set_ruta_path</h1>");
		$this->ruta_path = split ("\,", $ruta_path);
		// depurar_array ($this->ruta_path);

	}
	function get_ruta_path () {
		return $this->ruta_path;
	}
	function set_not_ruta_path ($not_ruta_path) {
		// debug ("PAsamos por set_not_ruta_path");
		$this->not_ruta_path = split ("\,", $not_ruta_path);

	}
	function get_not_ruta_path () {
		return $this->not_ruta_path;
	}

	function set_where ($where) {
			/** soporte extra from **/
		if (!empty($this->where)) return;
		$aTmp = array();
		if (preg_match_all('/[ =\!]([A-Za-z0-9]+\..*?)[ =\!]/',' '.$where.' ',$aTmp)) {
			if (sizeof($aTmp)) 
				foreach ($aTmp as $aTb) 
					if (is_array($aTb))
						foreach ($aTb as $match) {
							$aFr = split('\.',$match);
							// Si no se indica una bdd, sino solo tabla.campo
							if (sizeof($aFr) == 2) {
								$aFr[0] = trim($aFr[0]);
								if (!empty($aFr[0]) AND !in_array($aFr[0],$this->aExtraFroms)) {
									array_push($this->aExtraFroms,$aFr[0]);
								}
							}
						}
		}
			/** **/

		$this->where = $where;
		if (!is_numeric($this->get_nolink())) $this->set_nolink(1);
	}

	function get_where () {		  // Fixme: Limpiar todo esto de mierda. Es mas sencillo, seguir $w_final.
// $this->debug = 1;
// debug($this->where);

			/** Esta funcion esta muy endeble.
         no comprueba el inicio de la cadena, si es variable o no, si hay mas
         de un $variable etc... **/
//         debug("get_where de ".$this->where."<BR>\n");
//separamos en cachitos
		if ($this->get_debug ())
			debug ("oBucle->get_where()");
		if ($this->where && strchr ($this->where, "\$")) {
			if ($this->where[0] == '\$')
				$this->where .= ' ';
			$temp = split ("[\$]", $this->where);
			$w_final = $this->where;
			$i = 0;
			$aRep = array ();
			foreach ($temp as $we) {
				// El primero no cuenta.
				if (!$i++)
					continue;
				$clean = $we;
				if (is_numeric (($dpos = strpos ($we, "%"))))
					$clean = substr ($clean, 0, $dpos);
				if (is_numeric (($dpos = strpos ($we, "'"))))
					$clean = substr ($clean, 0, $dpos);
				if (is_numeric (($dpos = strpos ($we, "\""))))
					$clean = substr ($clean, 0, $dpos);
				if (is_numeric (($dpos = strpos ($we, " "))))
					$clean = substr ($clean, 0, $dpos);
				if (!in_array ($clean, $aRep)) {
					array_push ($aRep, $clean);
					$sess_val = wdo_get ($this, array ($clean));
					$w_final = str_replace ("\$".$clean, $sess_val, $w_final);
					// debug("Tenemos ($clean) ($sess_val) ");
				}
			}
			return $w_final;
		}
		elseif (!empty ($this->where))
			return $this->where;
		else
		return NULL;
	}

	function set_visto ($arg = 1) {
		if (!$this->omitir AND (int) $arg)
			  $this->ya_visto = (int) $arg;
		elseif (!$this->omitir) $this->ya_visto = $arg;
	}
	function get_visto () {
		return (int) $this->ya_visto;
	}
	// function get_visto() { return (((int)$this->omitir) ? (int)$this->omitir : (int) $this->ya_visto) ; }

	function set_warnlev ($warn) {
		$warn = (int) $warn;
		$this->warnlev = $warn;
	}

	function get_warnlev () {
		return $this->warnlev;
	}

	/** Establecemos la funcion condicional */
	function set_modo ($modo) {
		if (empty ($modo))
			return 0;
		$this->modo = $modo;
		return 1;
	}

	function get_modo () {
		return $this->modo;
	}

	function set_tablabase ($tabla) {
		if (empty ($tabla)) return false;
		$this->tabla = $tabla;
		return 1;
	}

	function get_tablabase () {
		if (!($this->get_nolink()) AND is_object($this->padre)) {
			return $this->padre->tabla;
		} else return $this->tabla;
	}

	function set_nombre ($nombre) {
		if (empty ($nombre))
			return 0;
		$this->nombre = $nombre;
//salida("set_nombre(".$this->nombre.")<BR>\n");
		return 1;
	}

	function get_nombre () {
		if (!empty($this->nombre)) $retval = $this->nombre;
		else {
			$retval = $this->get_nodb();
		}
		return $retval;
	}

	function set_limit ($limit) {
		if (empty ($limit))
			return 0;
		$this->limit = $limit;
		return 1;
	}

	/*
	 * DOCUMENTAR propiedad html_escape 
	 */
	function set_html_escape ($bool = 1) {
//aviso("set_order($orden)");
		$this->html_escape = ($bool) ? 1 : 0;
		return 1;
	}

	function get_html_escape () {
		return $this->html_escape;
	}

	function set_formatfields($bool = true) {
		if (!is_object($this->sesion)) return false;
		if (!$this->sesion->_getKrnCfg('format_data')) return true;
		$this->format_fields = ($bool) ? true : false;
		return true;
	}

	function get_formatfields () {
		if (!(bool)$this->sesion->_getKrnCfg('format_data')) return false;
		return $this->format_fields;
	}

	function set_formatfields_name($name) {
		if (!is_object($this->sesion)) return false;
		if (!$this->sesion->_getKrnCfg('format_data')) return true;
		$this->format_fields_name = $name;
		return true;
	}
	function get_formatfields_name () {
		if (!$this->sesion->_getKrnCfg('format_data')) return NULL;
		if (empty($this->format_fields_name))
			for ($oB = $this->padre; is_object($oB); $oB=$oB->padre) {
				if (!empty($oB->format_fields_name)) {
					$this->format_fields_name = $oB->format_fields_name;
					break;
				}
			}
		// debug("get-formatfields_name :: ".$this->nombre. " ::: ".$this->format_fields_name);
		return $this->format_fields_name;
	}

	/** Metodo encargado de obtener las CSS de un campo, si no se opone ningun modulo antes **/
	function getCSS($entidad) {
		if (!strchr($entidad,'.')) {
			$root_ent = $this->get_formatfields_name();
			if (!empty($root_ent)) $entidad = $root_ent.'.'.$entidad;
		}
		$bShow = true;
		$plt = $this->sesion->get_plt_name();
		$aTmp = $this->sesion->activeModuleCall('fldAvailable',array($entidad),$plt);
		if (is_array($aTmp) and sizeof($aTmp))
			foreach ($aTmp as $val)
				if (is_numeric($val) or is_bool($val)) {
					if (!$val) $bShow = false; // Si alguno lo quiere ocultar, el resto que se abstenga
					else { // Si algun modulo lo quiere mostrar, el resto da igual, se muestra.
						$bShow = true;
						break;
					}
				} elseif (is_array($val) and (!empty($val['label']) or !empty($val['data'])) ) {
					$aCSS = $val;
					$bShow = true;
					break;
				}

		if (!$bShow) {
			$hcss = $this->sesion->getFromKrn('css_hide');
			$aCSS['label'] = $hcss;
			$aCSS['data'] = $hcss;
		} elseif (!is_array($aCSS) or sizeof($aCSS)) {
			$aCSS = $this->sesion->getDataCSS($entidad);
		}
		return $aCSS;
	}

	/*
	 * DOCUMENTAR propiedad order 
	 */
	function set_order ($orden = "") {
//aviso("set_order($orden)");
	   $orden = trim($orden);
	   if (empty ($orden))
	      return 0;
	   $this->order = $orden;
	   return 1;
	}

	function get_order () {
		return $this->order;
	}

	function get_limit () {
		return $this->limit;
	}

	function set_contador ($contador) {
//debug("set_contador($contador)");
		if (empty ($contador))
			return 0;
		$this->contador = $contador;
		return 1;
	}

	function get_contador () {
		return $this->contador;
	}

			/**
                 Este metodo indica al bucle si ha de hacer query o no en el scanner, asi
                 como si ha de no procesar nada (caso de no hacer query) o no. **/
	function hacer_query ($oSesion) {
// debug("hacer_query de ".$oSesion->get_plt_name()."<BR>\n");
		if ($this->nodb)
			$RetVal = 0;
		else {
			// TMP: if ($oSesion->do_query()) 
			if ($this->sesion->do_query ()) {
//salida("la sesion dice k si hagamos query<BR>\n");
				if (empty ($this->tabla)) {
					$this->bDirecto = 1;
					$RetVal = 0;
				} else {
					$this->bDirecto = 0;
					$RetVal = 1;
				}
			} else {
				// $this->bDirecto = 1;
				$RetVal = !$this->sesion->reconocer_bloque ($this->get_nombre ());
			}
		}
		$this->hacerquery = (int) $RetVal;
		return $this->hacerquery;
	}

			/**
         *       Este metodo indica si hay registros para visualizar o no. nos lanza la query y nos obtiene y resetea
			*			 (caso de existir -nolink-) el id_resultados (no deja de ser
         *       una comprobacion gilipichi, dado que no se va a dar el caso) 
			*/
	function hay_rows (&$oSesion, $consulta = "") {
		if (!$this->hacerquery) {
			if ($this->get_debug () > 4)
				debug ("hay_rows: Confirmado, NO hay k hacer query<BR>\n");
			$this->resultados = 0;
			return 1;
		}

		if (!$this->nodb AND $this->hacerquery AND ! $this->omitir) {
			if (!$this->get_visto ()) {
				$this->resultados = $this->db->query ($consulta);
				if ($this->get_debug () > 3)
					debug ("Resultado: ".$this->resultados." Lanzamos sobre ".$this->db->get_dbase_name()." la query: ".$consulta);
				// $this->consulta SIN DOCUMENTAR
				if ($this->get_nolink ()) {
					// debug("hay_rows(): Guardamos la query");
					$this->consulta = $consulta;
				}
			} elseif ($this->get_nolink ()) {
				// debug("hay_rows(nolink)");
				// debug("resultadoxxxx: $this->resultados");
				if ($this->get_debug () > 3)
					debug ("nolink ya visto");
//debug("timestamp: $this->stamp");
//print_r($this->db->res_id);
debug("resultados = ($this->resultados); consulta=($this->consulta)");
				if (!empty ($this->resultados))
					$this->db->data_seek ($this->resultados);
				elseif (!empty ($this->consulta)) $this->resultados = $this->db->query ($this->consulta);
				else
				$this->resultados = NULL;
				// debug("resultados: $this->resultados");
//print_r($this->db->res_id);
			} elseif (!empty ($consulta)) {
				$this->resultados = $this->db->query ($consulta);
			}
			$RetVal = $this->db->num_rows ($this->resultados);
			// debug("retval de hay_rows(): $RetVal");
			if ($this->resultados)
				$this->db->data_seek ($this->resultados);
		}
		elseif (!$this->nodb AND ! $this->omitir) {
			$this->resultados = $this->db->get_id ();
debug("fuego el 2");
			if (is_numeric($this->resultados)) {
				$this->db->data_seek ($this->resultados);
				$RetVal = 1;
			} else
				$RetVal = 0;
		}
		elseif ($this->nodb AND ! $this->omitir) $RetVal = 1;
		elseif ($this->omitir) $RetVal = 0;
		else $RetVal = $this->db->num_rows ();

		if ($this->get_debug () > 3)
			debug ("query; FROM contiene ".(($from) ? $from : "NULL"));
		return $RetVal;
	}									  // FIn de hay_rows

	function preparar_query (&$oSesion) {

						 /** lo primero que hacemos es construir la consulta para obtener todos los
						 resultados que nos interesen
						 **/
		if ($this->get_debug ())
			debug ($this->tabla." nolink = ".$this->nolink);
		if (!($this->get_nolink ())) {
			$aClave = $this->clave_compuesta();
			$tb_origen = $this->get_tablabase();
			if ($this->get_debug() > 6) debug("Clavepadre: $aClave");
		} else {						  /* si es un nolink... comprobamos si ya lo hemos visto */
			if (!$this->get_visto ())
				$tb_origen = $this->tabla;
			else
				return $this->hay_rows ($oSesion);
			// else return $this->hay_rows($oSesion);
		}

		if (!is_a($this->db,'wol_db')) return 0;
		/*
		 * consulta de las tablas actuales 
		 */
		$nTablas = sizeof ($this->tablas);
		if ($this->get_debug ())
			debug ("Tablas: $nTablas con tabla base ".$this->tabla."<BR>\n");
		$bSelect = FALSE;
		for ($i = 0; $i < $nTablas; $i++) {
			$nCampos = sizeof ($this->tablas[$i]);
			for ($j = 1; $j < $nCampos; $j++) {
				if ($bSelect)
					$select .= ", ";
				$lngFld = $this->tablas[$i][0].".".$this->tablas[$i][$j];
				$select .= $lngFld." as \"$lngFld\" ";
				$bSelect = TRUE;
			}
			$aTablas[$i] = $this->tablas[$i][0];
			if (!$this->sesion->gotEntityDataType($aTablas[$i])) {
				$this->sesion->setEntityDataType($aTablas[$i],$this->db->get_fields($aTablas[$i]));
			}
		}
		/*
		 * Nota: Falta añadir a la consulta el nombre (no valor) del campo clave de la tabla base del siguiente(o quizas todos?)
		 * hijo(s). 
		 */

		// debug("joooooodeeeeeerrrrrr ($tb_origen)<BR><BR>\n ");
		$g = $this->get_group ();
		if (empty ($g)) {
			// $key_fld = $this->tabla.".".$this->db->obtener_clave ($this->tabla);
			// $select .= ((!empty ($select)) ? "," : NULL)." $key_fld as \"$key_fld\" ";
			$key_fld = $this->clave_compuesta();
			if (!empty($key_fld)) $select .= ((!empty ($select)) ? ', ' : ' ').$key_fld['select'];
		}
		if (empty ($tb_origen))
			$tb_origen = $aTablas[0];
			/** soporte extra from **/
		if (is_array($this->aExtraFroms) AND sizeof($this->aExtraFroms)) {
			if (!is_array($aTablas)) $aTablas = array();
			foreach ($this->aExtraFroms as $tb) 
				if (!in_array($tb,$aTablas)) array_push($aTablas,$tb);
		}
			/** **/
		$aConsulta = $this->db->ruta ($tb_origen, $aTablas, $aClave['raw'], $this->ruta_path, $this->not_ruta_path);
		$where = $aConsulta[0];
		$aFrom = $aConsulta[1];
		$nFrom = sizeof ($aFrom);
		$bVacio = FALSE;
		$nPartes_from = sizeof ($aConsulta[1]);
		$i = 0;
		$from = "";
		// debug("Depuramos el Array que se le mando a ruta");
		// depurar_array($aTablas);
		// debug("Depuramos el Array que devuelve ruta");
		// print_r($aConsulta);
		if (!$this->get_join('left')) {
			foreach ($aConsulta[1] as $parte_del_from)
				$from .= $parte_del_from.((++$i == $nPartes_from) ? "" : ", ");
		} else {
			$from = $aConsulta['left_join_from'];
			$where = '';
		}

		$extra_sel = $this->get_extra_select ();
		if (!empty ($extra_sel))
			$select = "$extra_sel".((!empty ($select)) ? ", ".$select : '');
		$limit = $this->get_limit ();
		$groupby = $this->get_group ();
		$orden = $this->get_order ();
		$having = $this->get_having();
		$consulta = "SELECT $select FROM $from ";
		// salida("uissssss select con $from");
		if ($extra_where = $this->get_where ()) {
			$where .= (($where) ? " AND" : "")." ( ".$extra_where." ) ";
		}
		if (!empty ($where))
			$consulta .= " WHERE ".$where;
		if (!empty ($groupby))
			$consulta .= " GROUP BY ".$groupby;
		if (!empty ($having))
			$consulta .= " HAVING ".$having;
		if (!empty ($orden))
			$consulta .= " ORDER BY ".$orden;
		if (!empty ($limit))
			$consulta .= " LIMIT ".$limit;
		if ($this->get_debug () > 6)
			debug ("consulta = $consulta");
		$nHayRows = $this->hay_rows ($oSesion, $consulta);

		return $nHayRows;
	}

				/**
								Este metodo nos obtiene los datos a usar en esta plantilla
								(utilizando el metodo que sea) **/
	function set_array (&$oSesion) {
		if ($this->debug)
			debug ("set_array; ");
		if (!empty ($this->nodb)) {
			$func = $this->nodb;
			$this->aDatos = array ();
			$this->resultados = 0;
			// if ($this->aDatos = $func($oSesion)) return 1;
			if ( ($this->aDatos = $func ($this->sesion, $this->nombre)) ) {
				if (is_array($this->aDatos) AND sizeof($this->aDatos)) {
					// Si tenemos un nombre de 'entidad' -aunque sea ficticia- asociado a los datos nodb, lo ponemos.
					$fmtentity = $this->get_formatfields_name();
					if ( !empty($fmtentity) AND !$this->sesion->gotEntityDataType($fmtentity)) {
						if (is_object($this->db)) $aTmp = $this->db->get_fields($fmtentity);
						if (is_array($aTmp) AND sizeof($aTmp) AND sizeof($this->aDatos))
							foreach (key($this->aDatos) as $k) if (!is_numeric($k)) $aTmp[] = array('name' => $k);
						$this->sesion->setEntityDataType($fmtentity,$aTmp);
						$aTmp = NULL;
					}
				}
				return 1;
			} else {
				return 0;
			}
		}

		if ($this->hacerquery) {
			// debug("set_array(): resultados = ".$this->resultados);
			if (!$this->resultados OR empty ($this->resultados)) {	// OR !$this->db->num_rows($this->resultados)) 
				return 0;
				//Fixme: Comprobar que este codigo no Ofende en ningun sitio.
				// No es logico, si es el motor de plantillas quien compone la query, que vaya a preguntar a la sesion
				// Si no obtiene resultados, o se ha producido un error.
				// $this->resultados = $oSesion->get_id();
				$this->resultados = $this->sesion->get_id ();
				if ($this->get_debug ())
					debug ('obtenemos resultados');
				if ($this->resultados)
					$this->sesion->data_seek ($this->resultados);
				// if ($this->resultados) $oSesion->data_seek($this->resultados);
			}
			if ($this->debug)
				debug ('nombre ('.$this->nombre.
						 ') id_res('.$this->resultados.') num_rows('.$this->db->num_rows ($this->resultados).')');

			if ($this->db->num_rows ($this->resultados))
				$this->aDatos = $this->db->fetch_assoc ($this->resultados);
			else
				return 0;

			if ($this->debug)
				debug ('aDatos tiene '.sizeof ($this->aDatos).' valores');
			if ($this->debug)
				print_r ($this->aDatos);
			if (!($this->aDatos)) {
				if ($this->stamp)
					return 0;
				$retval = 0;
				// $this->db->libera();
				/*
				 * AKI 
				 */
				$retval = 1;		  // un bucle ajeno y lo parseamos 1 vez
				if ($this->get_noresults ())
					$retval = 1;
				else
					$retval = 0;
				/*
				 * aki se podrian analizar mas cosas a parte de la opcion no_results 
				 */
			} else
				$retval = 1;
			$this->stamp = time (NULL);
			if ($this->debug)
				debug ("stamp ".$this->stamp);
			if ($this->debug)
				debug (($retval) ? "Seguimos..." : "Paramos...($retval)");
			if ($this->debug)
				debug ("aDatos[vacio] = (".$this->aDatos[vacio].")");
			if ($this->get_debug ())
				debug ("return de set_array: $retval");
			return $retval;
		}


		if (!strcmp ($this->modo, "id")) {
			if ($this->debug)
				debug ("modo=id: asignamos aDatos de ".$this->nombre);
			$this->resultados = $this->sesion->get_id ();
			// $this->resultados = $oSesion->get_id();
		} else {
			if ($this->debug)
				debug ("modo = array");
			$this->resultados = 0;
			if ($this->debug)
				debug ("nombrerr ".$this->nombre);
			// $this->aDatos = $oSesion->get_plt_data($this->nombre);
			$this->aDatos = $this->sesion->get_plt_data ($this->nombre);
			if (!$this->aDatos) {
				if ($this->stamp)
					return 0;
				$retval = 1;
			} else {
				$retval = 1;
			}
			if ($this->debug)
				debug ("stamp ".$this->stamp);
			if ($this->debug)
				debug (($retval) ? "Seguimos..." : "Paramos...");
			if ($this->debug)
				debug ("aDatos[vacio] = (".$this->aDatos[vacio].")");
			$this->stamp = time (NULL);
			return $retval;
		}

		debug ("Ultimo caso (no deberia ocurrir), fetch_array(sesion->get_id())");
		$this->resultados = 0;
		// if (!$this->aDatos = $oSesion->fetch_array($oSesion->get_id()))
		if (!$this->aDatos = $this->sesion->fetch_assoc ($this->sesion->get_id ()))
			return 0;
		else
			return 1;
		return 0;
	}

	function set_nodb ($nodb) {
		if (empty ($nodb))
			return 0;
//aviso("juel, si nodb = $nodb");
		$this->nodb = $nodb;
		return 1;
	}

	function get_nodb () {
		return $this->nodb;
	}

	 /**
    * añadir control de errores y documentar el atributo
    */
	function set_db ($db_name = NULL) {

		if (substr($db_name,0,1)=='$') {
			$db_name = wdo_get ($this, substr($db_name,1));
		}

		if (!empty ($db_name)) {
			// debug("plantillas.inc: set_db($db_name)");

			$this->db_conn_name = $db_name;
			$this->db = $this->sesion->get_db ($db_name);
			// debug("db es un objeto? =".is_object($this->db));
		} else {
			// debug("plantillas.inc: No db_name");
			$this->db = $this->sesion->get_db('data');
		}
	}

	function get_db () {
//                        debug("plantillas.inc : db_conname = $this->db_conn_name");
		return $this->db_conn_name;
	}

	function &getApp() {
		return $this->sesion;
	}

	function get_data($fldname = NULL) {
		if (empty($fldname)) return $this->aDatos;
		if (!isset($this->aDatos[$fldname]) and !strchr($fldname,'.') and is_array($this->aDatos) and sizeof($this->aDatos)) {
			$aKs = array_keys($this->aDatos);
			$fld = '';
			foreach ($aKs as $k) 
				if (strchr($k,'.')) {
					$aTmp = split('\.',$k);
					if ($aTmp[1]==$fldname) {
						// if (!empty($fld)) debug("Campo repetido.. lo dejaremos pasar. ");
						$fld = $k;
					}
				}
			if (!empty($fld)) $fldname = $fld;
		}
		return $this->aDatos[$fldname];
	}

	function set_noresults ($nores = "") {
		if (empty ($nores))
			return 0;
		$this->nores = 1;
		return 1;
	}

	function get_noresults () {
		return ($this->nores) ? 1 : 0;
	}

	function set_nolink ($nolink) {
		if (!is_numeric($nolink)) return 0;
		$this->nolink = $nolink;
		return 1;
	}

	function get_nolink () {
		return $this->nolink;
	}

	function set_cfunc ($func) {
		if (empty ($func)) return 0;
		$this->cfunc = $func;
		return 1;
	}

	function get_cfunc () {
		return $this->cfunc;
	}

	function set_join ($tipo) {
		switch ($tipo) {
			case 'left':
				$this->aSQLParams['bUseLeftJoin'] = true;
			default: 
				return false;
		}
	}

	function get_join ($tipo) {
		switch ($tipo) {
			case 'left':
				return $this->aSQLParams['bUseLeftJoin'];
			default: 
				return NULL;
		}
	}

	function set_having ($have) {
		if (empty($have)) return false;
		$this->aSQLParams['having'] = $tipo;
		return true;
	}

	function get_having () {
		return $this->aSQLParams['having'];
	}

	function set_group ($grupo) {
		$this->group = $grupo;
		return true;
		/** **
		if (empty ($grupo))
			return 0;
		if (strchr($grupo,"\."))
			$this->group = $grupo;
		else {
			// global $oSesion;
			if (is_object ($this->db)) {
				$aTmp = $this->clave_compuesta();
				$clave = $aTmp['groupby'];
// debug("$clave 2");
			} else {
				aviso("Error Interno: Agrupacion no soportada en inmTemplateSystem::set_group($grupo), contacte con su distribuidor"); 
				// $temp = explode (".", $grupo);
				// $tabla = $temp[0];
				// $clave = $this->sesion->obtener_clave ($tabla);
			}

			if (empty ($clave))
				return false;
			$this->group = $grupo.".".$clave;
		}
		return true;
		/** **/
	}

	function get_group () {
		return $this->group;
	}

	function set_import($type,$bool) {
		$this->_aImports[$type] = (bool)$bool;
		return true;
	}

	function get_import($type) {
		if (!isset($this->_aImports[$type])) return NULL;
		else return $this->_aImports[$type];
	}

	function add_extra_select ($select) {
		$this->extra_select .= ((!empty ($this->extra_select)) ? "," : "").$select;
	}

	function get_extra_select () {
		return $this->extra_select;
	}

	/** Metodo que nos añade una linea a este objeto **/
	function add_line ($linea) {
		$this->lineas[count ($this->lineas)] = $linea;
	}

	/** Metodo que nos añade una rama a este objeto **/
	function mas_ramas ($tabla) {
		$nRamas = count ($this->hijos);
		$this->hijos[$nRamas] = new bucle;
		$this->hijos[$nRamas]->padre = &$this;
		$this->hijos[$nRamas]->tabla = $tabla;
		// $this->hijos[$nRamas]->sesion = &$oSesion;
		$this->hijos[$nRamas]->sesion = &$this->sesion;
		if (!$this->sesion->_getKrnCfg('format_data')) $this->hijos[$nRamas]->format_fields = false;
		else $this->hijos[$nRamas]->set_formatfields($this->get_formatfields());
		//salida("pos = $nRamas, padre = ".$this->tabla.", hijo = $tabla<BR>\n");
		return $nRamas;
	}

	function &get_parent () {
		return $this->padre;
	}  

	/** Este metodo es el encargado de devolvernos el siguiente hijo a
   analizar/obtener. Puede recibir un parametro que es el numero de hijo **/
	function sig_hijo ($hijo = "") {
		if (empty ($hijo))
			$hijo = $this->hijos_point;
//salida("buscando hijo $hijo<BR>\n");
		// if (!is_object($this->hijos[$this->hijos_point])) return NULL;
		$this->hijos_point++;
		return $hijo;
	}

	function nextChild() {
		return $this->sig_hijo();
	}

	function check_sig_hijo () {
		return $this->hijos_point;
	}

	function setCurrentChildNum($n) {
		if (!is_numeric($n)) return false;
		if (!is_object($this->hijos[$n])) return false;
		$this->hijos_point = $n;
		return true;
	}

	function getCurrentChildNum() {
		return $this->hijos_point;
	}

	function &getChild($num = NULL) {
		if (empty($num)) $num = $this->hijos_point;
		return $this->hijos[$num];
	}

			/** reset de los punteros **/
	function reset_pointers () {
		$this->hijos_point = 0;
		$this->aDatos = array ();

		 /** NONES
		if ($this->resultados AND !$this->get_nolink()) {
						$this->db->libera($this->resultados);
						$this->resultados = NULL;
						unset($this->resultados);
		}
		**/
		return 1;
	}

	/** Este metodo es el que se encarga de sacar el valor de la clave
     primaria del padre, asi como el nombre del campo. El sistema observa que
     si no existe padre, se devuelve la clave principal de la tabla actual
     (la cual se consulta a la instancia wol_db) y el valor del campo clave.
     Caso de existir padre, se comprueba la existencia de la tabla aDatos. Si
     aDatos existe, devolvemos la clave ahi contenida, sino, devolvemos el
     contenido del campo clave de la instancia padre. Caso de no existir nada
     de lo anterior, retornaremos NULL.
   Presunciones :
     Esta funcion presupone la existencia de una variable global de tipo
    wol_db con el nombre de $oDb
    **/
	function clave_compuesta () {
		$oSesion = $this->sesion;
		if (!is_object($this->db)) return NULL;

		$tb_origen = $this->get_tablabase();
		if (!($this->get_nolink()) AND is_object($this->padre)) {
				$rootblock = $this->get_parent();
				$bParent = TRUE;
				if ($this->get_debug() > 6) debug("Root es el padre : ".$this->padre->tabla.' === '.$this->padre->nombre);
		} else {
				$rootblock = &$this;
				$bParent = FALSE;
		}
		if ($this->get_debug() > 6) debug("Clavecompuesta para $tb_origen ");

		$aKeys = $this->db->obtener_clave($tb_origen);
		if ($this->get_debug() > 6) print_r($aKeys);
		$retval = NULL;
		if (is_array($aKeys))
			foreach ($aKeys as $key) {
				$dato = $rootblock->get_data($key);
				if ($this->get_debug() > 6) debug("dato : $dato");
				if (empty($dato) AND !is_numeric($dato)) {
					$dato = $rootblock->get_data($tb_origen.'.'.$key);
					if (empty($dato) AND !is_numeric($dato) AND !($bParent)) {
						if (is_array($rootblock->clave) AND sizeof($rootblock->clave)) 
							foreach ($rootblock->clave as $aK) 
								if ( !empty($aK[$key]) OR is_numeric($aK[$key]) ) $dato = $aK[$key];
					}
				}
				if (empty($dato) AND !is_numeric($dato)) continue;
				$retval['where'] .= ((!empty($retval['where'])) ? ' and ' : '' ).$tb_origen.'.'.$key.'=\''.$dato.'\'';
				$retval['raw'][$tb_origen.'.'.$key] = $dato ;
				$retval['select'] .= ((!empty($retval['select'])) ? ' , ' : '' ).$tb_origen.'.'.$key.' as "'.$tb_origen.'.'.$key.'" ';
				$retval['groupby'] .= ((!empty($retval['groupby'])) ? ' , ' : '' ).$tb_origen.'.'.$key.' ';
				if (!is_array($retval['from'])) $retval['from'] = array();
				if (!in_array($tb_origen,$retval['from'])) array_push($retval['from'],$tb_origen);
			}
		if ($this->get_debug() > 6) {
			debug("retonamos $retval ");
			print_r($retval);
		}
		return $retval;
	}									  // fin del metodo clave_padre

	/*
	 * Metodo que nos añade una $tabla y $campo a nuestro objeto 
	 */
	function add_field ($tabla, $campo = "") {

//debug("oBucle->add_field($tabla,$campo)");
		$nTbCount = sizeof ($this->tablas);
		if (empty ($this->tabla))
			$this->tabla = $tabla;
// salida("<BR>añadiendo en ".$this->tabla." y ya tenemos $nTbCount<BR>\n");
		if (!$nTbCount) {
			$this->tablas = array (array ());
			$this->tablas[0][0] = $tabla;
			if (!empty ($campo))
				$this->tablas[0][1] = $campo;
		}
		elseif (!empty ($tabla)) {
			for ($i = 0; $i < $nTbCount; $i++) {
				if (encuentra ($this->tablas[$i], $tabla) != -1) {
					if (encuentra ($this->tablas[$i], $campo) == -1 AND ! empty ($campo)) {
						$this->tablas[$i][sizeof ($this->tablas[$i])] = $campo;
					}
				}
				elseif ($i == ($nTbCount - 1)) {
					$this->tablas[$i + 1][0] = $tabla;
					if (!empty ($campo))
						$this->tablas[$i + 1][1] = $campo;
				}
			}
		}

//salida("Prueba de firestone (".$this->tabla.") :<BR>\n");
//for ($i=0;$i<sizeof($aTablas_Global[$this->tabla]);$i++)
//    for ($j=0;$j<sizeof($aTablas_Global[$this->tabla][$i]); $j++)
//            salida($aTablas_Global[$this->tabla][$i][$j]." *<BR>\n");
	}									  // fin add_field();

}

////////////////////////FINAL DE LA CLASE/////////////////////////////////////////////////

function plantillas (&$Sesion) {
	// global $oSesion;
	// global $oDb;

	$oSesion = &$Sesion;
	$oDb = &$Sesion->get_db ("data");
	// global $oDb;
	motor_plantilla (&$Sesion);
	// return $Sesion;
	// unset($oSesion);
	// unset($oDb);
}

/** motor_plantilla ($plantilla,$tabla,$key) :
  Esta es la funcion de entrada a nuestro motor. Esta funcion va a hacer
  2 cosas principalmente. Por un lado va a abrirnos el fichero de plantilla
  y meter los datos de la plantilla en una estructura de arbol en memoria. Y
  por otro lado nos llamara a un scanner que nos recorrera el arbol en memoria
  para generar la salida al navegador.
PARAMETROS:
  $planti - Esta es la plantilla que usaremos para visualiza.
  Esta plantilla ha de tener alusiones a tablas y campos.
  $tabla - Esta es nuestra tabla base, a partir de la cual obtendremos el
  resto de los datos posibles de nuestra plantilla.
  $key - Esta es la clave primaria de $tabla, caso de no indicarse la clave,
  se visualizarian todos los registros de la misma.
  **/
function motor_plantilla (&$oSesion, $plt = "",$aStartUpData = NULL) {
	global $Plantilla;
	global $fPoint;
	global $APP_NAME;
	global $oDb;
	global $nPlantilla;
	global $aPlantillas;
	global $afPoint;
	global $seccion_plt;
	// global $oSesion;

	$old_plt = $oSesion->plt_name;
	if (empty ($old_plt))
		$old_plt = $oSesion->get_plt_name ();
// debug("plt = ($plt)");
	if (!isset ($plt) OR empty ($plt))
		$planti = $oSesion->get_plt (0);
	else
		$planti = $oSesion->get_plt ($plt);

// debug("1er planti = $planti");
	if (empty ($planti)) {
		debug ("Plantilla($plt) no Reconocida");
		return;
	}
// debug("planti = $planti - $plt");

	$raiz = new bucle;
	$raiz->sesion = &$oSesion;

	// $raiz->tabla = $oSesion->get_tb_base();

	/*
	 * Estamos presuponiendo que cuando no hay $subsecc, la llamada proviene de otra plantilla (no principal) 
	 */
	$raiz->padre = NULL;

	$oSesion->storeRootBlock(&$raiz);

	$plt = trim($plt);
	$tmp = $oSesion->exec_plt ($plt);
	if (!empty ($tmp)) $planti = $tmp;
	$pii = $oSesion->get_plt_name();

	$key = $oSesion->get_key();
	$raiz->clave = $key;

	$tmp_path = $oSesion->get_pltdir();
	if (!$tmp_path) {
		aviso("No se encuentra $planti");
		return NULL;
		// $oSesion->set_error();
		// $planti = $oSesion->get_pltdir(NULL).$oSesion->error_plt();
	} else $planti = $tmp_path.$planti;
// debug("2o planti = $planti");

	if ($nPlantilla == -1)
		$nPlantilla = 0;
	else
		$nPlantilla++;
	$fPoint = (int) $afPoint[$nPlantilla];
	$aPlantillas[$nPlantilla] = file_inm ($planti);
	$Plantilla = $aPlantillas[$nPlantilla];

	if (!isset ($oDb)) {
		// $oDb = new wol_db($APP_NAME);
		$oDb = &$oSesion->get_db ("data");
		if (!$oDb->conectado ()) $oDb->conecta (1);
	}
	lector_plantilla (&$raiz);
	unset ($Plantilla);
	$raiz->completo = 1;

	if ($raiz->get_import('data')) {
		$raiz->aDatos = $aStartUpData;
	}

	if (!isset ($oDb)) {
		$oDb = new wol_db ($APP_NAME);
		$oDb->conecta ();
	}

	$oSesion->activeModuleCall('preRenderPII',array($pii),$pii);

	scanner (&$raiz);
// debug("old_plt = $old_plt<BR>\n");
	$oSesion->get_plt ($old_plt);
}

/*** lector_plantilla ($raiz) :
Descripcion:
  Esta funcion es la encargada de leer el contenido de la variable global
  $Plantilla, el cual es un array con cada una de las lineas de nuestro array,
  y de cargarnos en memoria la estructura de arbol de nuestros bucles para su
  posterior interpretacion.
Presunciones:
  Esta funcion presupone que el nombre del array con todas las lineas de nuestra
  plantilla se llama $Plantilla, y que el puntero de este array se llama $fPoint
  ambas 2 variables se presupone son globales.
  **/
function lector_plantilla (&$oBucle) {
	global $Plantilla;
	global $fPoint;

	static $fEnd;
	$fEnd = (sizeof ($Plantilla));

	for (; $fPoint < $fEnd AND ! $oBucle->completo; $fPoint++) {
		$oBucle->add_line ((parser (&$oBucle, $Plantilla[$fPoint])));
	}
}

/** scanner($oBucle) :
  Scanner se va a encargar de escanearnos el arbol de bucles que tenemos en
memoria, realizar la consulta para cada bucle, y reparsear las lineas del
bucle, esta vez metiendo los datos sacados de la consulta.
  Presunciones:
  - Esta funcion presupone la existencia de un objeto llamado $oDb de tipo
  wol_db.
  Procedimiento:
  - La primera fase de esta funcion es la de enlazar las consultas sql. Digo
  las porque son 2. Por un lado, estando en un bucle n, tenemos que los
  datos de este han de enlazar con el bucle n-1 asi como las tablas contenidas
  en este bucle. A la hora de enlazar con el bucle padre (n-1) tenemos el
  problema de que el bucle raiz no tiene padre. Para ello tenemos una
  propiedad clave que sera manejada por el metodo clave_padre, que nos
  devolvera un array bidimensional con el la tabla.campo del padre y su
  valor para realizar la consulta sobre esta tabla.
  Asimismo, hay que realizar la consulta contra las tablas de este mismo
  bucle. Para todos los enlaces entre tablas usarmos los metodos de nuestro
  objeto wol_db que nos indicaran la ruta a seguir para el enlace.
  Una vez todo enlazado, lanzaremos la consulta y almacenaremos los resultados
  en la propiedad aDatos de nuestro objeto bucle.
  - La segunda fase comienza cuando tenemos todos los datos del registro
  actual en nuestra tabla aDatos. La cual iremos repitiendo hasta que se
  acaben todos los registros de la consulta lanzada, e iremos parseando
  estos datos con la plantilla para obtener la salida deseada para el navegador
  ***/
function scanner (&$oBucle) {
	// global $oSesion;
	// $oBucle->set_visto(0);
	$oSesion = &$oBucle->sesion;

	$db_name = $oBucle->get_db ();
	if ($oBucle->get_debug ())
		debug ("plantillas.inc :db_name $db_name<BR>\n");
	if (empty ($db_name))
		$oBucle->set_db ();
	// CRASO ERROR: Si reseteamos la instancia db, perdemos sus resultados :O - else $oBucle->set_db($db_name);

	// $oDb = $oSesion->get_db_conn();
	$nHacerQuery = $oBucle->hacer_query ($oSesion);
	if ($oBucle->get_debug ())
		debug ("hacer query = $nHacerQuery<BR>\n");

	/*
	 * Si este bucle no tiene ninguna consulta a realizar, simplemente parseamos el contenido de sus lineas una vez y nos largamos 
	 * de la funcion. 
	 */
	if ($oBucle->bDirecto) {
		if ($oBucle->get_debug ())
			debug ("Entramos por bDirecto<BR>\n");
		$nLineas = sizeof ($oBucle->lineas);
		for ($i = 0; $i < $nLineas; $i++) {
			$linea = parser ($oBucle, $oBucle->lineas[$i]);
			/** soporte email **/
			if (!$oBucle->omitir) {
				$aMod = $oBucle->sesion->_getStdOutMod();
				if (!is_array($aMod) OR $aMod['bBrowser']) salida ($linea);
				if (is_array($aMod) AND function_exists($aMod['handler'])) $aMod['handler']($oBucle->sesion,$linea);
			}
			/** **/
		}
		return;
	}

	if ((int) $nHacerQuery) {	  // Si tenemos que hacer el query....
		/*
		 * Fase Uno 
		 */
		$nHayRows = $oBucle->preparar_query ($oSesion);
		if ($oBucle->get_debug ())
			debug ("plantillas.inc :nHayRows $nHayRows<BR>\n");
	} else {							  // Fin si NO hay k hacer query...
		// debug("no hay k hacer el query y orden tiene ($orden)");
		// if (!empty($orden)) $oSesion->set_query_param("ORDER BY",$orden);
		$fmtname = $oBucle->get_formatfields_name();
		if (!empty($fmtname)) $oBucle->sesion->setEntityDataType($fmtname);
		// debug("fmt: $fmtname ");

		$orden = trim($oBucle->get_order());
		// Se dispara siempre, por si se han introducido terminos de ordenacion por parametro.
		// $oBucle->sesion->set_query_param ("ORDER BY", $orden);
		if (!empty($orden) AND strlen($orden)) $oBucle->sesion->set_query_param("ORDER BY",$orden);
		// debug("<b>Preguntandole</b> a la Sesion si hay_rows() .. ");
		$nHayRows = $oBucle->sesion->hay_rows ();
	}

	/*
	 * Fase Dos 
	 */

  /** Una vez construida la consulta la lanzamos y entramos en un bucle, que
    mientras nos queden registros por visualizar... interpretamos con esos
    datos todas las lineas del objeto bucle. **/
	$nLineas = sizeof ($oBucle->lineas);
	if ($oBucle->get_debug ()AND (int) $nLineas)
		  debug ($oBucle->get_nombre ()." tiene lineas y rows = ($nHayRows)");
	$vistos = 0;
	for ($k = 1; $oBucle->set_array ($oSesion); $k++) {
		if ($oBucle->get_debug ()) debug ("Hacemos pasada");
		if ($nHayRows) {
			if ($oBucle->get_debug ()) debug ("hay rows");
		} else {
			if ($oBucle->get_debug ()) debug ("no hay rows");
			if ($oBucle->get_noresults ()) {	// AND !(int)$oSesion->get_var(num_resultados)) { 
				/*
				 * Esto tan simple, como es visualizar un texto de no hay resultados... se hara en un futuro (esperemos proximo) con
				 * una plantilla. 
				 */
				motor_plantilla(&$oBucle->sesion,'::pltcfg:emptysearch');
				// global $__wol_no_results;
				// salida ($__wol_no_results);
				continue;
			}							  // Not yest tested: else continue;
		}

		if (!empty ($oBucle->contador)) $oBucle->aDatos[$oBucle->contador] = $k;
		$cfunc = $oBucle->get_cfunc ();
		if (!empty($cfunc)) $aF = &$oBucle->sesion->_getCallBackMethod($cfunc);
		if ($oBucle->get_debug()) debug ("cfunc = $cfunc");

		if (is_array($aF) and sizeof($aF)) {

			// if ($cfunc($oSesion,$oBucle->aDatos)) {
			// if ($cfunc ($oBucle->sesion, $oBucle->aDatos)) 
			if ($aF['type'] == 'Function') $bCont = call_user_func(&$aF['call'],&$oBucle->sesion,&$oBucle->aDatos);
			else $bCont = call_user_func(&$aF['call'],&$oBucle);
			if ($bCont) {
				/** Temporalmente removido para comprobar funcionamiento del metodo clave_compuesta(): **
				  * 	Ademas de que no se a que viene asignar el atributo clave, cuando solo se necesita para 
				  *	lanzar/preparar la query
				  *
				if (empty ($func_nodb)) {
					$oBucle->clave = $oBucle->aDatos[$key_fld];
				}
				/** **/
				for ($i = 0; $i < $nLineas; $i++) {
					$linea = parser ($oBucle, $oBucle->lineas[$i]);
					/** soporte email **/
					if (!$oBucle->omitir) {
						$aMod = $oBucle->sesion->_getStdOutMod();
						if (!is_array($aMod) OR $aMod['bBrowser']) salida ($linea);
						if (is_array($aMod) AND function_exists($aMod['handler'])) $aMod['handler'](&$oBucle->sesion,$linea);
					}
  					/** **/
				}
			}
			$vistos++;
		} else {
			/** Temporalmente removido para comprobar funcionamiento del metodo clave_compuesta(): **
			  * 	Ademas de que no se a que viene asignar el atributo clave, cuando solo se necesita para 
			  *	lanzar/preparar la query
			  *
			if (empty ($func_nodb))
				$oBucle->clave = $oBucle->aDatos[$key_fld];
			else 
			/** **/
			if ($oBucle->get_debug ())
				debug ("func_nodb : $func_nodb");
			if ($oBucle->get_debug () > 7)
				debug ("PARSER");
			for ($i = 0; $i < $nLineas; $i++) {
				$linea = parser ($oBucle, $oBucle->lineas[$i]);
				/** soporte email **/
				if (!$oBucle->omitir) {
					$aMod = $oBucle->sesion->_getStdOutMod();
					if (!is_array($aMod) OR $aMod['bBrowser']) salida ($linea);
					if (is_array($aMod) AND function_exists($aMod['handler'])) $aMod['handler']($oBucle->sesion,$linea);
				}
				/** **/
			}
			// $oBucle->reset_pointers();
			$vistos++;
		}								  // fin del if $cfunc

		/*
		 * } else { if ($oBucle->get_warnlev()) { salida("La Busqueda no ha tenido Exito\n"); $nLineas = 1; } return; } // Fin del
		 * if (hay_rows) 
		 */

		$oBucle->reset_pointers ();
	}									  // Fin de for(keden datos)
	$oBucle->set_visto (0);
	/*
	 * if ($oBucle->resultados) { $oSesion->libera($this->resultados); unset($this->resultados); } 
	 */
	if (!$vistos AND $nLineas AND $oBucle->get_warnlev ())
		salida ("<H1>No existen registros visibles para Ud.</H1>");
}										  // FIN del scanner()

/** parser ($linea) :
  Esta funcion se va a encargar de parsearnos las distintas lineas de la
  plantilla en busca de nuestros tags (@%...%@) y llamar a la funcion que
  correspanda para parsear dicha linea.
Presunciones:
  Esta funcion presupone la existencia de una tabla referencial llamada
  $parser_func donde se encuentran todas la claves posibles, asi como la
  funcion que nos va a procesar esa informacion.
NOTAS:
Retocar el puto parser para que no tenga k por cojones ir un ; al final
de la linea para k te parse una opcion referencial.

  **/
function parser (&$oBucle, $linea) {
	global $parser_func;
	$Ret_Val = "";
	$tenio = "";
//salida("linea: ".$linea."<br>");

	 /** Comprobamos si existe en esta linea nuestros tags **/
	if ((se_encuentra ("@%", $linea)) != -1) {

		 /** Dividimos la linea actual en cachitos separados por los
                                                 tags de nuestras plantillas **/
		$aTramos = split ("[@%][%@]", $linea);
		$num = count ($aTramos);
		for ($j = 0; $j < $num; $j++) {
			if (($j % 2)) {		  // Si es impar estamos en un comando de plantilla
				if ($oBucle->get_debug () > 7)
					debug ("tramo = ".$aTramos[$j]."<BR>\n");
				$pos = se_encuentra (":", $aTramos[$j]);
				if ($pos == -1)
					continue;
				$senyal = substr ($aTramos[$j], 0, $pos);
				$aFuncion = NULL;
				$aFuncion = $parser_func[$senyal];
				if ($oBucle->get_debug () > 7)
					debug ("señal(antes): ".$senyal."  completo ".$oBucle->completo);
				if (empty ($aFuncion[$oBucle->completo])) {
					$Ret_Val .= "@%".$aTramos[$j]."%@";
					if ($oBucle->get_debug () > 7)
						debug ("no parseado ".$aTramos[$j]."<BR>\n");
					$pos = se_encuentra ("%@", $linea);
					continue;
				}
				if ($oBucle->get_debug () > 7)
					debug ("señal: ".$senyal."  com ".$oBucle->completo);
				$resto = substr ($aTramos[$j], $pos + 1);
				$aParam = array();
				if (se_encuentra (";", $resto) == -1)
					$aParam[0] = $resto;
				else {
					if ($oBucle->get_debug () > 7)
						debug ("resto ".$resto."<br>");
					$aTmp = split ("\;", $resto);
					$nTmp = sizeof ($aTmp);

					for ($m = 0; $m < $nTmp; $m++) {
						// salida("aTmp[m] ".$aTmp[$m]." con m:".$m." y numero ".$nTmp."<br>");
						$aTmp2 = split ("\|", $aTmp[$m]);
						if (sizeof ($aTmp2) > 1) {
							// salida("aTmp2[m] ".$aTmp2[0]." con m:".$m."<br>");
							if (!empty($aTmp2[1]) OR is_numeric($aTmp2[1])) $aParam[$aTmp2[0]] = $aTmp2[1];
						} else {
							if (!empty($aTmp[$m]) OR is_numeric($aTmp[$m])) $aParam[$m] = $aTmp[$m];
							// salida("aParam[aTmp[m]]: ".$aParam[$aTmp[$m]]."<br>");
						}
						// salida("m es ".$m." y aParam[$m] ".$aTmp[$m]."<br>");
						// aviso("para caso tmp[2]".$aTmp2[0]);
					}					  // end-for
				}						  // end-if

				// salida("aParam[0]:".$aParam[0]." aParam[s]".$aParam["s"]."<br>");
				if ($oBucle->get_debug () > 7)
					debug ($aFuncion[$oBucle->completo].'('.$aParam[0].' - '.$aParam[1].')');
				$tenio = "";
				$tenio = $aFuncion[$oBucle->completo] ($oBucle, $aParam);
				// if(!$oBucle->completo)
				if ($oBucle->get_debug () > 7)
					debug ("recivimos  $tenio de ".$aFuncion[$oBucle->completo]." (".$oBucle->completo.')');
				if (!($oBucle->completo))
					$Ret_Val .= "@%$senyal:$tenio%@";
				else
					$Ret_Val .= $tenio;
				$tenio = "";
				$pos = se_encuentra ("%@", $linea);

			} else {					  // si es par...
				$Ret_Val .= $aTramos[$j];
			}							  // end-if es par o impar

		}								  // fin-for numero de tramos.
	} else {							  // Si no encontramos los tags...
		if ($oBucle->get_debug () > 8)
			debug ("linea sin tags");
		return $linea;
	}									  // end-if existe %@

	if ($oBucle->get_debug () > 7 AND (!$oBucle->completo))
		debug ("retval = ".$Ret_Val."y completo:".$oBucle->completo."<br>");

	return $Ret_Val;
}

function subir_padre (&$oBucle, $campo) {
	for (; is_object ($oBucle->padre); $oBucle = $oBucle->padre) {
		if (!empty ($oBucle->aDatos[$campo]))
			return $oBucle->aDatos[$campo];
	}
	return "";
}

/** Documentar ...... */
function wdo_else (&$oBucle, $aParams) {
	if ($oBucle->omitir > 1) {
		if ($oBucle->debug > 5)
			debug ("<b>Esta omtido</b>, restamos");
		if ($oBucle->debug > 5 AND sizeof ($aParams) > 1)
			print_r ($aParams);
		$oBucle->omitir--;
		return 0;
	} else {
		if ($oBucle->debug > 5) debug ("pre-des-omitimos (".$oBucle->omitir.")");
		if ($oBucle->debug > 5 AND sizeof ($aParams) > 1) print_r ($aParams);

		if (is_array($oBucle->stkIfs) ANd sizeof($oBucle->stkIfs)) {
			$valant = $oBucle->stkIfs[sizeof($oBucle->stkIfs)-1];
			// Si ya estabamos en un bloque que se omite, seguimos omitiendo siempre
			if ((int)$valant) $oBucle->omitir = $valant;
			else {
				if (!$oBucle->omitir) $oBucle->omitir = 1;
				else $oBucle->omitir = 0;
			}
		} else {
			if (!$oBucle->omitir) $oBucle->omitir = 1;
			else $oBucle->omitir = 0;
		}
		if ($oBucle->debug > 5) debug ("des-omitimos (".$oBucle->omitir.")");
	}
}

/** Documentar ...... */
function wdo_if (&$oBucle, $aParams) {
	// global $oSesion;
	$oSesion = &$oBucle->sesion;
	if (!is_array ($oBucle->stkIfs)) $oBucle->stkIfs = array ();
	array_push ($oBucle->stkIfs, (int) $oBucle->omitir);
	if ($oBucle->debug > 5)
		debug ("If: omitir = ".$oBucle->omitir);
	if ((int) $oBucle->omitir) {
		if ($oBucle->debug > 5)
			debug ("omitir ++ - <b>return</b>");
		$oBucle->omitir++;
		return 0;
	}
	$func = array_shift ($aParams);
	if ($oBucle->debug > 5)
		debug ("func: <b>$func</b>");
	if (empty ($func)) return;
	/** Soporte negacion funciones if **/
	if ($func[0] == '!') {
		$func = substr($func,1);
		$bNegar = true;
	} else $bNegar = false;
	/** **/

	$aFuncParams = NULL;
	foreach ($aParams as $param) {
		$param = trim($param);
		if (empty($param) AND !is_numeric($param)) continue;
		if (!is_array ($aFuncParams))
			$aFuncParams = array ();
		$sess_val = NULL;
		if (!empty($param) AND !is_numeric($param)) $sess_val = wdo_get($oBucle,array($param));
		elseif (empty($param) AND !is_numeric($param)) continue;
		// if (!empty($param)) $oSesion->get_var($param);
		if ($oBucle->debug > 5) debug ("wdo_get $param (".$sess_val.")");
		if (is_numeric ($param))
			array_push ($aFuncParams, $param);
		elseif (isset ($oBucle->aDatos[$param])) {
			if ($oBucle->debug > 5)
				debug ("in aDatos: ".$oBucle->aDatos[$param]);
			$aFuncParams[$param] = $oBucle->aDatos[$param];
		}
		elseif (!empty ($sess_val) OR is_numeric ($sess_val)) $aFuncParams[$param] = $sess_val;
		else
		array_push ($aFuncParams, $param);
		// Solo se aceptan variables y numeros como parametro. No texto: 
	}
	/** Soporte negacion funciones if **/
	$aF = &$oSesion->_getCallBackMethod($func);
	if (isset($aF)) {
		if (!is_array($aFuncParams) or !sizeof($aFuncParams)) $aFuncParams = $oBucle->aDatos;
			
		if ($aF['source']=='__App__') {
			$oBucle->omitir = (int) !call_user_func (&$aF['call'],$aFuncParams);
		} else {
			$oBucle->omitir = (int) !call_user_func (&$aF['call'],&$oBucle->sesion, $aFuncParams);
		}

		if ($bNegar) $oBucle->omitir = !$oBucle->omitir;
	} else {
		//FixMe: Escupir error a salida de errores
		$oBucle->omitir = 1;
	}
	/** **/

	if ($oBucle->debug > 5) debug ("If func = $func  retval(". ! $oBucle->omitir.")");
}

/** Documentar ..... **/
function wdo_endif (&$oBucle, $aParams) {
	if (sizeof ($oBucle->stkIfs)) {
		$oBucle->omitir = array_pop ($oBucle->stkIfs);
		if ($oBucle->debug > 5 AND sizeof ($aParams) > 1)
			print_r ($aParams);
		if ($oBucle->debug > 5)
			debug ("pop-end-if(".$oBucle->omitir.")");
	} else {
		if ($oBucle->debug > 5 AND sizeof ($aParams) > 1)
			print_r ($aParams);
		$oBucle->omitir = 0;
		if ($oBucle->debug > 5)
			debug ("end-if(".$oBucle->omitir.")");
	}
}

function do_unset (&$oBucle, $aParams) {
	$nParm = sizeof ($aParams);
	foreach ($aParams as $clave => $valor) {
		if (!is_numeric ($valor) AND empty ($valor))
			continue;
		if ($i++)
			$Ret_Val .= ";";
		$Ret_Val .= ((!is_numeric ($clave)) ? "$clave"."|" : '').$aParams[$clave];
	}
	return $Ret_Val;
}

function wdo_unset (&$oBucle, $aParams) {
	// global $oSesion;
	$oSesion = &$oBucle->sesion;
	if ($oBucle->omitir)
		return;
	$nParm = sizeof ($aParams);
	// Recorremos todos los parametros
	foreach ($aParams as $unsetvar) {
		if (strchr($aTmp[0],'[') AND strchr($aTmp[0],']')) {
			$aTmpSet = split(' ',str_replace(array('[',']'),' ',$aTmp[0]));
			while (list($k,$v) = each($aTmpSet)) if (!empty($v)) array_push($aVarToSet,$v);

			if (sizeof($aVarToSet) <= 2) {
				if (!empty($aVarToSet[1])) {
					$sessvar = $oSesion->get_var($aVarToSet[0]);
					if (!is_array($sessvar)) continue;
					if (isset($sessvar[$aVarToSet[1]])) {
						$sessvar[$aVarToSet[1]] = NULL;
						unset($sessvar[$aVarToSet[1]]);
						// debug("deleting from ".$aVarToSet[0]);
						$Sesion->set_var($aVarToSet[0],$sessvar);
					}
				}
			} else {
				// debug("deleting $unsetvar");
				$oSesion->unset_var($unsetvar);
			}
		} else {
			// debug("deleting $unsetvar");
			$oSesion->unset_var($unsetvar);
		}
	}
	return;
}

/** Documentar ..... **/
function do_set (&$oBucle, $aParams) {
//aviso("set 0 ".$aParams[0]);
	$nParm = sizeof ($aParams);
	foreach ($aParams as $clave => $valor) {
		if (!is_numeric ($valor) AND empty ($valor))
			continue;
		if ($i++)
			$Ret_Val .= ";";
		$Ret_Val .= ((!is_numeric ($clave)) ? "$clave"."|" : '').$aParams[$clave];
	}
//aviso("set de $Ret_Val con nparm = $nParm");
	return $Ret_Val;
}

/** Documentar ..... **/
function wdo_set (&$oBucle, $aParams) {
	// global $oSesion;
	$oSesion = &$oBucle->sesion;
	if ($oBucle->omitir)
		return;
	$nParm = sizeof ($aParams);
	for ($i = 0; $i < $nParm; $i++) {
		$aTmp = split ("=", $aParams[$i]);
		if (sizeof ($aTmp) < 2)
			continue;
		$aTmp[0] = trim ($aTmp[0]);
		$aTmp[1] = trim ($aTmp[1]);

		// Si a la izda del =, existen [] estamos asignando un valor a un vector.
		if (strchr($aTmp[0],'[') AND strchr($aTmp[0],']')) {
			// caso de ser un vector, la variable $sessvar contendra el vector, y $varaddr un vector a la posicion a la que se debera asignar.
			$bVector = FALSE;
			$aVarToSet = array();
			$aTmpSet = split(' ',str_replace(array('[',']'),' ',$aTmp[0]));
			// Limpiamos el vector (con variable e indice) de posibles valores vacios.
			while (list($k,$v) = each($aTmpSet)) if (!empty($v)) array_push($aVarToSet,$v);

			// Solo se soportan vectores (1 dimension):
			if (sizeof($aVarToSet) <= 2) {
				$varname = $aVarToSet[0];
				$sessvar = $oSesion->get_var($aVarToSet[0]);
				if (!is_array($sessvar)) $sessvar = array();
				// Si no se nos indica un indice (ej: nombrevar[]), se anyade al ultimo.
				if (empty($aVarToSet[1])) {
					$varaddr = &$sessvar[];
				} else {
					$varaddr = &$sessvar[$aVarToSet[1]];
				}
				// debug("en $sessvar meteremos $varaddr");
				$bVector = TRUE;
			} else {
				$varname = $aTmp[0];
				$sessvar = $oSesion->get_var($aTmp[0]);
				$varaddr = $sessvar;
			}
		} else {
			// Si no hay [] (no es vector) la asignacion que se hara a varaddr, sera la misma que sessvar
			$bVector = FALSE;
			$varname = $aTmp[0];
			$sessvar = $oSesion->get_var($aTmp[0]);
			$varaddr = $sessvar;
		}
	
		// Buscamos, con el valor de la dcha del =, si es numerico, si existe en la capa de datos, o si existe en la capa logica.
		//   Caso de no encontrarse conincidencias en ninguna capa, se asigna el valor directamente
		// debug("Buscando $aTmp[1]");
		if (is_numeric ($aTmp[1])) {
			$varaddr = $aTmp[1];
		} elseif (isset($oBucle->aDatos[$aTmp[1]])) {
			if ((bool)$aParams['fmt'] and $oBucle->get_formatfields()) {
				$varaddr = $oBucle->sesion->getDataFormated(
						( ($oBucle->get_formatfields_name() and !strchr($aTmp[1],'.')) 
						  	? $oBucle->get_formatfields_name().'.' 
							: '' ).$aTmp[1],$oBucle->get_data($aTmp[1]),&$oBucle);
			} else {
				$varaddr = $oBucle->get_data($aTmp[1]);
			}
		} else {						  // Si no esta en los datos ni es numerico, lo metemos a pelo en la sesion
			if (!strcasecmp($aParams['value'],'val')) $varaddr = $aTmp[1];
			else {
				$tmp = wdo_get ($oBucle, $aTmp[1]);
				// debug("Obtenemos ($tmp) de ".$aTmp[1]);
				if (!isset($tmp) OR (!is_numeric($tmp) AND empty($tmp))) {
					// Si el valor _es_ una variable (no vale otra cosa). Asignamos null (no encontrado)
					if (!strcasecmp($aParams['value'],'var')) $varaddr = NULL;
					else $varaddr = $aTmp[1];
				} else $varaddr = $tmp;
			}
		}	// De momento nada: else $oSesion->unset_var($aTmp[0]);
			
		// Si el almacenamiento no es a un vector. Igualamos el vector con el valor obtenido.
		if (!$bVector) {
			$sessvar = $varaddr;
			// debug("::set_var($varname,$sessvar)");
		}

		// Asignamos en la sesion.
		$oSesion->set_var ($varname, $sessvar, ((!empty ($aParams['tipo'])) ? $aParams['tipo'] : "INMED"));
	}
	return;
}

/** Documentar ..... **/
function do_get (&$oBucle, $aParams) {
	$nParm = sizeof ($aParams);
	for ($i = 0; $i < $nParm; $i++) {
//        if ($i) $Ret_Val .= ";";
		$Ret_Val .= $aParams[$i];
	}
	return $Ret_Val;
}

/** Documentar ..... **/
function wdo_get (&$oBucle, $aParams) {
	// global $oSesion;
	$oSesion = &$oBucle->sesion;
	$reg_globals = (int) $oSesion->_getKrnCfg('register_globals');
	// debug("getit!");
	// print_r($aParams);
	if (!is_array ($aParams))
		$aParams = array ($aParams);
	foreach ($aParams as $idx => $par) {
		if (strchr ($par, '[') AND strchr ($par, ']')) {
			$aParts = explode ("[", $par);
			$varname = array_shift ($aParts);
			$aVar = $oSesion->get_var ($varname);
			if (!is_array ($aVar))
				return NULL;
			$finalvar = "[".implode ("[", $aParts);
			$toeval = "\$result = \$aVar".$finalvar.";\n";
			@eval ($toeval);
			return $result;
		} else {
			$sess_var = $oSesion->get_var ($par);
			if (!empty ($sess_var) OR is_numeric ($sess_var)) {
				$Ret_Val .= $sess_var;
			}
			elseif ($reg_globals) {
				$Ret_Val .= $_GET[$par];
			}
		}
	}
	return $Ret_Val;
}

/** Documentar ..... **/
function wdo_calc (&$oBucle, $aParams) {
	// global $oSesion;
	$oSesion = &$oBucle->sesion;
	$base = $aParams[0];
	if (empty ($base))
		return NULL;
	if ((int) $oBucle->omitir)
		return NULL;

	$_output = (int) $aParams["output"];
	if (!isset ($aParams[round]))
		$_round = -1;
	else
		$_round = (int) $aParams[round];
	if (empty ($aParams['vartype']))
		$_vartype = "INMED";
	else
		$_vartype = strtoupper ($aParams['vartype']);
	if (empty($aParams['lcfmt'])) $_lcfmt = false;
	else $_lcfmt = true;
	if (empty($aParams['fmt'])) $_lcfmt = false;
	else $_lcfmt = true;
	if (!empty($aParams['fmtas'])) {
		if (!$_lcfmt) $_lcfmt = true;
		$_lcfmtas = $aParams['fmtas'];
	}

	$aEq = split ("=", $base);
	if (sizeof ($aEq) > 2) {
		return "Bad Formed";
	}
	elseif (sizeof ($aEq) > 1) {
		$sess_var = trim ($aEq[0]);
		// debug("sess_var = $sess_var");
		$aVars = array ($aEq[1]);
	}
	else
	$aVars = array ($base);
	$aOps = array ('\/', '\*', '\%', '\-', '\+', '\(', '\)');
	$aFinal = array ();
	foreach ($aOps as $op) {
		$op = trim ($op);
		if (is_array ($aVars)) {
			$aFinal = array ();
			foreach ($aVars as $idx => $var) {
				// debug("variable $var indice $idx operador $op");
				if (is_array ($var)) {
					array_push ($aFinal, $var);
					continue;
				}
				$var = trim ($var);
				if (!is_array ($var) AND strchr ($var, $op[1])) {
					// debug("hemos encontrado el operador $op en $var pos $idx");
					$a = split ($op, $var);
					// $aVars = array();
					// debug("Tras el split:");
					// print_r($a);
					foreach ($a as $ix => $chunck) {
						if ($ix != 0) {
							// debug("Metiendo operador para cacho $chunck");
							array_push ($aFinal, array (substr ($op, 1), 1));
							array_push ($aVars, array (substr ($op, 1), 1));
						}
						if (is_numeric($chunck) OR !empty($chunck)) {
							// debug("La pos ".$ix." no esta vacio2: ".trim($chunck));
							array_push ($aFinal, trim ($chunck));
							array_push ($aVars, trim ($chunck));
						}
					}
					// print_r($aFinal);
					// debug("-------");
					$cambiar = 1;
				} else
					array_push ($aFinal, $var);
			}
			if ($cambiar) {
				// debug("Este operador habia sido encontrado");
				$aVars = $aFinal;
				// print_r($aFinal);
			}
			$cambiar = 0;
		}
	}

	$retval = '';
	// print_r($aFinal);
	reset ($aFinal);
	// debug("----------");
	// debug("el primero = $aFinal[0]");
	foreach ($aFinal as $idx => $var) {
		// debug ("var = ($var) - idx = ($idx)");
		if (!is_array ($var)) {
			if (!is_numeric ($var) AND ! empty ($var)) {
				// $tmp = $oSesion->get_var($var);
				$tmp = wdo_get ($oBucle, array ($var));
				if (empty ($tmp) AND ! is_numeric ($tmp))
					$tmp = $oBucle->aDatos[$var];
				 // De aqui se ha quitado los parentesis encerrando expr
				$val = "'".((empty($tmp)) ? 0 : $tmp)."'";
			} else
				$val = trim ($var);
		}
		elseif (!empty ($var[0]) OR is_numeric($var[0])) $val = $var[0];
		// debug("var = ($var) -> value = ($val)");
		$retval .= $val;
	}
	// debug("Calc expr: $retval");
	$base = '$_base = '.$retval.';';
	if (!eval ($base)) {
		// debug("retval antes($retval): (".eval($retval).")");
		$retval = ($_round == -1)
			? $_base					  // No hay redondeo
			: (($_round == -2) ? floor ((float) $_base) : round ($_base, $_round));

		// debug("output = $_output; round = $_round; base = $_base; retval = $retval; fmt? = ".$oBucle->sesion->_getKrnCfg('format_data'));
		if ($oBucle->sesion->_getKrnCfg('format_data')) {
			settype($retval,'float');
			if (!$_lcfmt) {
				if ($_round < 0) $_round = 2;
				$retval = number_format($retval,$_round);
				// debug("_no_ formatear ".$retval);
			} else {
				if (empty($_lcfmtas)) {
					$retval = lcdec($retval,&$oSesion);
				} else {
					$retval = $oBucle->sesion->getDataFormated($_lcfmtas,$retval,&$oBucle);
				}
				// debug("_si_ formatear ".$retval);
			}
		}

		if (!empty ($sess_var)) {
			// debug("metemos variable de sesion $sess_var con ($retval)");
			$oSesion->set_var ("$sess_var", $retval, $_vartype);
		}
		if ($_output)
			return $retval;
		else
			return NULL;
	} else
		return "Computing Error";

}

/** do_where ($oBucle,$aParams) :
  Esta funcion se encarga de Tratar los tags where que nos encontremos en
  nuestra plantilla. La forma de tratarlos es recursiva. Nos va a crear un
  nuevo objeto bucle colgando del actual y va a volver a llamar a la funcion
  que parsea las lineas de nuestra plantilla para que las lineas que contenga
  nuestro nuevo bucle sean las comprendidas entre este tag y el end-where.
  ************/
function do_where (&$oBucle, $aParams) {
	global $recur_func;
	global $fPoint;

	$fPoint++;
	if ($oBucle->get_debug () > 7)
		debug ("detectado un bloke");
	if ($oBucle->get_debug () > 8)
		debug ("reset de flag final de bucle (completo)");
	$oBucle->completo = 0;

	if (sizeof ($oBucle->lineas)) {
//debug("Tos a follar! (".sizeof($aParams).")<BR>\n");
//debug("valor = ".$aParams[nombre]."<BR>\n");
		$nuevo = $oBucle->mas_ramas ($aParams["tabla"]);
		if (!empty ($aParams["nombre"]))
			$oBucle->hijos[$nuevo]->set_nombre ($aParams["nombre"]);
		if (is_numeric($aParams["no_results"]))
			$oBucle->hijos[$nuevo]->set_noresults ($aParams["no_results"]);
		if (!empty ($aParams["db"]))
			$oBucle->hijos[$nuevo]->set_db ($aParams["db"]);
		if (!empty ($aParams["where"]))
			$oBucle->hijos[$nuevo]->set_where ($aParams["where"]);
		if (is_numeric($aParams['nolink']))
			$oBucle->hijos[$nuevo]->set_nolink ($aParams["nolink"]);
		if (!empty ($aParams["nodb"]))
			$oBucle->hijos[$nuevo]->set_nodb ($aParams["nodb"]);
		if (!empty ($aParams["cfunc"]))
			$oBucle->hijos[$nuevo]->set_cfunc ($aParams["cfunc"]);
		if (!empty ($aParams["select"]))
			$oBucle->hijos[$nuevo]->add_extra_select ($aParams["select"]);
		if (!empty ($aParams["group"]))
			$oBucle->hijos[$nuevo]->set_group ($aParams["group"]);
		if (!empty ($aParams["limit"]))
			$oBucle->hijos[$nuevo]->set_limit ($aParams["limit"]);
		if (!empty ($aParams["modo"]))
			$oBucle->hijos[$nuevo]->set_modo ($aParams["modo"]);
		if (!empty ($aParams["contador"]))
			$oBucle->hijos[$nuevo]->set_contador ($aParams["contador"]);
		if (!empty ($aParams["order"]))
			$oBucle->hijos[$nuevo]->set_order ($aParams["order"]);
		if (!empty ($aParams["warn"]))
			$oBucle->hijos[$nuevo]->set_warnlev ($aParams["warn"]);
		if (is_numeric ($aParams["debug"]))
			$oBucle->hijos[$nuevo]->set_debug ($aParams["debug"]);
		if (!empty ($aParams["ruta_path"]))
			$oBucle->hijos[$nuevo]->set_ruta_path ($aParams["ruta_path"]);
		if (!empty ($aParams["not_ruta_path"]))
			$oBucle->hijos[$nuevo]->set_not_ruta_path ($aParams["not_ruta_path"]);
		if (is_numeric ($aParams["escape_html"]))
			$oBucle->hijos[$nuevo]->set_html_escape ((int) $aParams["escape_html"]);
		if (is_numeric ($aParams["format"]))
			$oBucle->hijos[$nuevo]->set_formatfields ((int) $aParams["format"]);
		if (!empty($aParams['format_name']))
			$oBucle->hijos[$nuevo]->set_formatfields_name ($aParams['format_name']);
		if (!empty($aParams['join']))
			$oBucle->hijos[$nuevo]->set_join ($aParams['join']);
		if (!empty($aParams['having']))
			$oBucle->hijos[$nuevo]->set_having ($aParams['having']);
		if (!empty($aParams['import_data']))
			$oBucle->hijos[$nuevo]->set_import ('data',$aParams['import_data']);

		$recur_func["lector"] ($oBucle->hijos[$nuevo]);
		return $aParams[0];
	} else {
		if (!empty ($aParams["nombre"]))
			$oBucle->set_nombre ($aParams["nombre"]);
		if (is_numeric($aParams["no_results"]))
			$oBucle->set_noresults ($aParams["no_results"]);
		if (!empty ($aParams["db"]))
			$oBucle->set_db ($aParams["db"]);
		if (!empty ($aParams["where"]))
			$oBucle->set_where ($aParams["where"]);
		if (is_numeric($aParams['nolink']))
			$oBucle->set_nolink ($aParams["nolink"]);
		if (!empty ($aParams["nodb"]))
			$oBucle->set_nodb ($aParams["nodb"]);
		if (!empty ($aParams["cfunc"]))
			$oBucle->set_cfunc ($aParams["cfunc"]);
		if (!empty ($aParams["select"]))
			$oBucle->add_extra_select ($aParams["select"]);
		if (!empty ($aParams["group"]))
			$oBucle->set_group ($aParams["group"]);
		if (!empty ($aParams["limit"]))
			$oBucle->set_limit ($aParams["limit"]);
		if (!empty ($aParams["modo"]))
			$oBucle->set_modo ($aParams["modo"]);
		if (!empty ($aParams["contador"]))
			$oBucle->set_contador ($aParams["contador"]);
		if (!empty ($aParams["order"]))
			$oBucle->set_order ($aParams["order"]);
		if (is_numeric ($aParams["warn"]))
			$oBucle->set_warnlev ($aParams["warn"]);
		if (!empty ($aParams["debug"]))
			$oBucle->set_debug ($aParams["debug"]);
		if (!empty ($aParams["ruta_path"]))
			$oBucle->set_ruta_path ($aParams["ruta_path"]);
		if (!empty ($aParams["not_ruta_path"]))
			$oBucle->set_not_ruta_path ($aParams["not_ruta_path"]);
		if (is_numeric ($aParams["escape_html"]))
			$oBucle->set_html_escape ((int) $aParams["escape_html"]);
		if (is_numeric ($aParams['format']))
			$oBucle->set_formatfields((int) $aParams['format']);
		if (!empty ($aParams['format_name']))
			$oBucle->set_formatfields_name($aParams['format_name']);
		if (!empty ($aParams['join']))
			$oBucle->set_join($aParams['join']);
		if (!empty ($aParams['having']))
			$oBucle->set_having($aParams['having']);
		if (!empty($aParams['import_data']))
			$oBucle->set_import ('data',$aParams['import_data']);

		$recur_func["lector"] ($oBucle);
	}

	return;
}

/** undo_where($oBucle,$aParams) :
  Esta funcion se limita a activarnos el flag de bucle completo para de
  esta manera terminar la recursividad provocada por el bucle where.
  **/
function undo_where (&$oBucle, $aParams) {
//debug("undo_where()");
	$oBucle->completo = 1;
	return;
}

/** wundo_where($oBucle,$aParams) :
        Esta funcion se llama cuando termina la segunda pasada de un bloke (where)
        **/
function wundo_where (&$oBucle, $aParams) {
	debug ("wundo_where(Esta funcion NUNCA se ejecuta)");
	$oBucle->reset_pointers ();
	if ($oBucle->get_debug () > 7)
		debug ('wundo_where('.$oBucle->get_nombre ().'): reseteamos punteros bucle');
	return;
}


/** datos_db ($oBucle, $aParams) :
  Esta funcion nos trata los db que se encuentran en la plantilla. El sitema
  de lectura e interpretacion de plantilla tiene 2 fases. Esta funcion nos
  hace la primera fase, para este caso nos tiene que rellenar el objeto bucle
  con el nombre de tabla actual y los campos que este tenga. Posteriormente
  esto es usado para saber, antes de reparsear el bucle, cual es la consulta
  a realizar.
 **/
function datos_db (&$oBucle, $aParams) {
	$display = trim ($aParams[0]);
	// debug("display = $display"."<br>");
	$aTmp = split (" as ", $display);
	if (sizeof ($aTmp) > 1) {
		$oBucle->add_extra_select ($aParams[0]);
		$display = trim ($aTmp[0]);
		$final = ereg_replace ("[\'\"]", "", trim ($aTmp[1]));
	} elseif (!(strpos ($display, "(") === false)) {
		//debug("hay extra $display");
		$aTmp = split ("[()]", $display);
		//debug("limpio = $aTmp[1]");
		$final = ereg_replace ("[\'\"]", "", trim ($aTmp[1]));
		$oBucle->add_extra_select ($display." as '$final'");
		//debug("final = $final");
	}

	if ((strpos ($display, "(") === false)) {
		// debug("no hay parentesis ($display)");
		if ((strpos ($display, "{") == false)) {
			$aTmp = split ("\.", $display);
			$tabla = $aTmp[0];
			$campo = $aTmp[1];
			if (!isset ($aParams["search"])) {
				// Ignoramos el db: que se usa para el contador
				// FixMe: No se puede tener una tabla con nombre identico al del campo contador
				// debug("contador = ".$oBucle->contador.", tabla = $tabla");
				if (!$oBucle->contador || strcmp ($oBucle->contador, $tabla))
					$oBucle->add_field ($tabla, $campo);
				if (!(isset ($final)))
					if (!(empty ($campo)))
						$final = $tabla.".".$campo;
					else
						$final = $tabla;
			} else {
				if (!(isset ($final)))
					if (!(empty ($campo)))
						$final = $tabla.".".$campo.";p";
					else
						$final = $tabla.";p";
			}
		} else {
			// aviso("hay llaves");
			$aTmp = split ("[{}]", $display);
			$funcion = $aTmp[0];
			$id_func = $oBucle->add_func($funcion);
			$display = $aTmp[1];
			$aTmp = split ("\.", $display);
			if (sizeof ($aTmp) > 1) {
				$tabla = $aTmp[0];
				$campo = $aTmp[1];
				if (!$oBucle->contador || strcmp ($oBucle->contador, $tabla))
					$oBucle->add_field ($tabla, $campo);
			} else {
				$tabla = $aTmp[0];
				if (!$oBucle->contador || strcmp ($oBucle->contador, $tabla))
					$oBucle->add_field ($tabla);
			}
			if (!isset ($final))
				if (!empty ($campo))
					$final = $tabla.".".$campo.";f|".$id_func;
				else
					$final = $tabla.";f|".$id_func;
		}
	} else {
		// debug("en $display si k hay parentesis");
		$aTmp = split ("[()]", $display);
		// aviso("de 0 = ".$aTmp[0]);
		// aviso("de 1 = ".$aTmp[1]);
		// aviso("de 2 = ".$aTmp[2]);
		$display = $aTmp[1];
		// aviso("y ara display = $display");
		$aTmp = split ("\.", $display);
		if (sizeof ($aTmp) > 1) {
			// aviso("de 0 = ".$aTmp[0]);
			// aviso("de 1 = ".$aTmp[1]);
			$tabla = $aTmp[0];
			$campo = $aTmp[1];
			if (!$oBucle->contador || strcmp ($oBucle->contador, $tabla))
				$oBucle->add_field ($aTmp[0]);
		} else {
			$tabla = $aTmp[0];
			if (!$oBucle->contador || strcmp ($oBucle->contador, $tabla))
				$oBucle->add_field ($aTmp[0]);
		}
		if (!isset ($final))
			if (!empty ($campo))
				$final = $tabla.".".$campo;
			else
				$final = $tabla;
	}

	if (is_array($aParams) AND sizeof($aParams)) 
		foreach ($aParams as $tipo => $val) {
			if (is_numeric($tipo)) continue;
			switch ($tipo) {
				case 's':
					if (strstr($val,',')) {
						$aTmp = split (',', $val);
						if (sizeof ($aTmp) > 1) {
							// $oBucle->$aPunteros[$aParams[0]] = $aTmp[0];
							$hasta = $aTmp[1];  // parche 18-05-01: $aTmp[0]+$aTmp[1];
							$final .= ";c|".$aTmp[0].",".$hasta;
						} else {
							// $oBucle->$aPunteros[$aParams[0]] = $aTmp[0];
							$final .= ";c|".$aTmp[0].",fin";
						}
					} else {
						$oBucle->$aPunteros[$aParams[0]] = 0;
						$final .= ";c|".$aParams["s"];
					}
					break;

				case 'fmt':
					$final .= ';fmt|'.(int)$val;
					break;
			}
		}
	//debug("final = ".$final."---".$oBucle->funciones[$id_func]."<br>");
	return $final;

}

/** load_img (&$oBucle,$aParams):
   Esta funcion se limita a hacer lo mismo que datos_db, dejando preparada la
   linea para el parseo por wload_img **/
function load_imgs (&$oBucle, $aParams) {
	$aTmp = split ("\.", $aParams[0]);
	$tabla = $aTmp[0];
	$campo = $aTmp[1];
	$oBucle->add_field ($tabla, $campo);
	return $aParams[0];
}

/** wdo_where (&$oBucle,$aParams) :
  Esta funcion es la que se encarga de hacernos la recursividad el arbol en
  memoria. Realiza de nuevo una llamada a la funcion que escanea la memoria.
  pero esta vez la llama con uno de los bucles hijo que contiene.
  **/
function wdo_where (&$oBucle, $aParams) {
	global $recur_func;
	// global $oSesion;
	$oSesion = &$oBucle->sesion;

	$nuevo = $oBucle->sig_hijo ();
	// Re-Fix where dentro de if de _no_ visualizacion (no se llama al scanner, si se avanza el puntero.
	if ((int) $oBucle->omitir) return;

	if (is_object ($oBucle->hijos[$nuevo])) {
		// Temporalmente deshabilitado para comprobar funcionamiento de metodo clave_compuesta(). Que _si_ deberia subir
		//		al padre a por _las_ claves primarias.
		// $campo = $oBucle->tabla.".".$oSesion->obtener_clave ($oBucle->tabla);
		// $oBucle->hijos[$nuevo]->clave = $oBucle->aDatos[$campo];
		if ($oBucle->get_debug () > 4)
			debug ('scanner ('.$oBucle->hijos[$nuevo]->get_nombre ().')');
		$oBucle->hijos[$nuevo]->omitir = $oBucle->omitir;
		$recur_func["scanner"] ($oBucle->hijos[$nuevo]);
	} else {
		// aki poner una llamada a obucle->errores()
		if ($oBucle->get_debug ())
			debug ('bloke sig_hijo inexistente (punteros no resetados)');
	}
	return;
}

/** wload_img ($oBucle,$aParams) :
  Esta funcion se encarga de sacar el tag html img con la ruta necesaria.
  **/
function wload_imgs (&$oBucle, $aParams) {
	if (!empty ($oBucle->aDatos[$aParams[0]])) {
		$Ret_Val = "<IMG SRC=\"".$oBucle->grf_dir."/";
		$Ret_Val .= $oBucle->aDatos[$aParams[0]]."\"";
		$Ret_Val .= " ALT=\"".$oBucle->aDatos[$aParams[0]]."\" >";
	}
	return $Ret_Val;
}

/** wdatos_db (&$oBucle,$aParam) :
  Esta funcion se encarga de sacar el contenido de la DB.
  **/
function wdatos_db (&$oBucle, $aParam) {
	// global $oSesion;
	$oSesion = &$oBucle->sesion;

	$datos = $oBucle->get_data($aParam[0]);
	$bFmt = $oBucle->get_formatfields();
	for ($i = 0; list ($clave, $valor) = each ($aParam); $i++) {
		if (is_numeric($clave)) continue;
		switch ($clave) {
			case 'c':
				$aTmp = split (",", $valor);
				if (!strcasecmp($aTmp[1],'fin')) $aTmp[1] = NULL;
				$datos = substr ($datos, $aTmp[0], $aTmp[1]);
				break;

			case 'f':
				$id = (int) $valor;
				$funcion = $oBucle->funciones[$id];
				$datos = $funcion ($datos, $oSesion);
				break;

			case 'p':
				if (is_object($oBucle->padre)) $datos = $oBucle->padre->get_data($aParam[0]);
				break;

			case 'fmt':
				$bFmt = (bool)$valor;
				break;
		}
	}

	// SI hay que formatear el campo, se formatea.
	if ($bFmt) {
		$datos = $oBucle->sesion->getDataFormated(
				( ($oBucle->get_formatfields_name() AND !strchr($aParam[0],'.')) ? $oBucle->get_formatfields_name().'.' : '' ).$aParam[0],$datos,&$oBucle);
	}
	$retval = ($oBucle->get_html_escape ())? htmlspecialchars(stripslashes($datos)) : stripslashes ($datos);

//debug("retval($aParam[0]) = $retval");
	// if ($oBucle->omitir) $retval = NULL;
	return $retval;
}

/**
  * Hoja de estilo CSS (2 o lo que sea) por tipo de dato, o dato.
  **/
function datatype_css(&$oBucle,$aParam) {
	if (!is_array($aParam) OR !sizeof($aParam)) return NULL;

	$entidad = array_shift($aParam);
	foreach ($aParam as $nombre => $valor) 
		switch ($nombre) {
			case 'type' :
				if (!strcasecmp($valor,'data')) $tipo = 'data';
				elseif (!strcasecmp($valor,'label')) $tipo = 'label';
				break;
		}

	// Se podria obtener de la configuracion del kernel cual es el tipo por defecto.
	if (empty($tipo)) $tipo='data';
	$aCSS = $oBucle->getCSS($entidad);
	if (!empty($aCSS[$tipo])) $retval = $aCSS[$tipo];

	return $retval;
}

/** Documentar y meter en misc.php **/
function se_encuentra ($cadena, $texto) {
	$encontrado = 0;
	$j = 0;
	while ($encontrado == 0 && $j < strlen ($texto)) {
		if (substr ($texto, $j, strlen ($cadena)) == $cadena) {
			$encontrado = 1;
			$posicion = $j;
		}
		$j++;
	}

	if ($encontrado == 0) {
		return -1;
	} else {
		return $posicion;
	}
}

/*** Documentar esto **/
function do_env (&$oBucle, $aParam) { 
	global $$aParam[0];
	// global $oSesion;
	$oSesion = &$oBucle->sesion;
	if (empty ($$aParam[0])) {
		if ($pos = strpos ($aParam[0], "[")) {
			$aTmp = split ("\[", $aParam[0]);
			$tabla = $aTmp[0];
			$l = strlen ($aTmp[1]) - 1;
			$resto = substr ($aTmp[1], 0, $l);
			global $$tabla;
			$aVar = unserialize (serialize ($$tabla));
			$var = $aVar[$resto];
		} else
			$var = $oSesion->get_var ($aParam[0]);
		return $var;

	} else
		return $$aParam[0];
}

function wdo_plt (&$oBucle, $aParam) { 
	global $afPoint;
	global $nPlantilla;
	global $fPoint;
	global $Plantilla;
	global $ID;
	// global $oSesion;
	$oSesion = &$oBucle->sesion;
	if ((int) $oBucle->omitir)
		return;
//salida("Creo k he visto un lindo gatito (".$aParam[0].")...<BR>\n");

	$afPoint[$nPlantilla] = (int) ++$fPoint;
	$aTmp = split (";", $aParam[0]);
	for ($k = 0; $k < sizeof ($aTmp); $k++) {
// salida("entro<BR>\n");
		$aTmp2 = split ("\|", $aTmp[$k]);
		$nTmp2 = sizeof ($aTmp2);
		if ($nTmp2 > 1)
			$aPlt[$aTmp2[0]] = $aTmp2[1];
		else
			break;
	}
	$secc = trim ($aParam[0]);
// debug("antes de mandar nah ".$secc);
	if ($nTmp2 == 1)
		motor_plantilla(&$oSesion,$secc,$oBucle->get_data());
	else {

			/** 
			* Fixme: Para recuperar el nombre de plantilla caso de que este nombre
			**/
		$old_plt_name = $oSesion->plt_name;
		$oSesion->plt_fwd ();
		motor_plantilla (&$oSesion,NULL,$oBucle->get_data());
		if ($old_plt_name)
			$oSesion->plt_name = $old_plt_name;
	}

// debug("Despues de nah... esto es una mierda");
}

function wdo_func (&$oBucle, $aParams) { 
	// global $oSesion;
	$oSesion = &$oBucle->sesion;
	if (!is_array ($aParams))
		return NULL;
	$func = array_shift ($aParams);
	$aFuncParams = NULL;
	// while ($param = array_shift ($aParams)) 
	foreach ( $aParams as $param ) {
		$param = trim ($param);
		// if (empty($param)) continue;
		if (!is_array ($aFuncParams))
			$aFuncParams = array ();
		$sess_val = NULL;
		if (!empty ($param))
			$sess_val = wdo_get ($oBucle, array ($param));
		if (is_numeric ($param))
			array_push ($aFuncParams, $param);
		elseif (isset ($oBucle->aDatos[$param])) $aFuncParams[$param] = $oBucle->aDatos[$param];
		elseif (!empty ($sess_val) OR is_numeric ($sess_val)) $aFuncParams[$param] = $sess_val;
		else
		array_push ($aFuncParams, $param);
	}

	if (!is_array($aFuncParams) or !sizeof($aFuncParams)) $aFuncParams = $oBucle->aDatos;
	$aF = &$oSesion->_getCallBackMethod($func);
	if ($aF['source']=='__App__')
		$retval = call_user_func (&$aF['call'],$aFuncParams);
	else {
		$retval = call_user_func (&$aF['call'],&$oBucle->sesion, $aFuncParams);
	}
	return $retval;
}


?>
