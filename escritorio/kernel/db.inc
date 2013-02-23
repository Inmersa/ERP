<?php

/*****************************************************************
** Aplicacion diseñada para Web On Line Studios S.L.            **
**    Todos los derechos reservados.                            **
**    Este programa se podra modificar con el consentimiento    **
**    de Web On Line Studios S.L. Su distribucion queda         **
**    limitada a Web On Line Studios S.L.                        **
**    Las posibles modificaciones sobre esta aplicacion ajenas  **
**    a Web On Line Studios S.L. deberan ser consultadas y         **
**    enviadas a Web On Line Studios en C/Alcala 18 3º Izda,    **
**    28014 Madrid. Cualquier otra operacion realizada sobre         **
**    esta aplicacion queda limitada a Web On Line Studios S.L. **
**    infringiendo en delito cualquier otra entidad que asi lo         **
**    hiciese.                                                       **
**                                                                **
** Para mas informacion referente a la licencia de esta         **
**    aplicacion referirse al fichero LICENCIA. Caso de que Ud. **
**    no tenga una copia de este fichero, contacte con Web On         **
**    Line Studios S.L. para recibir una copia del mismo        **
**                                                                **
** Informacion de Contacto                                        **
**    Josafat Moragrega Fernandez                                **
**    Engineering                                                **
**    Director Tecnico                                                 **
**    tite@wolstudios.com                                        **
**    C/Alcala 18 3º Izda, 28014 Madrid, España                        **
**                                                                **
**                                 (c) Web On Line Studios S.L.         **
**                                                              **
******************************************************************
*****************************************************************/

/*include("config.php");
include("errores.php");

include("misc.php");
include("mysql.php");*/

/************
  Descripcion :
  Este modulo ha de ser capaz en un futuro de conectarse a distintos motores
  de bases de datos (oracle, db2, mysql etc..) simultaneamente con multiples
  servidores simultaneos, logins y passwords.
  ***********/
	class wol_db {
	var $ruta_log = "/home/usuarios/lizard/logs/query.log";
	var $_bAlive;					  /* Indica si el objeto esta vivo/iniciado(1) o cerrado(0) * */
	var $nombre;					  /* Nombre de la base de datos */
	var $claves = array ();		  /* Array referencial de tabla-clave(s) */
	var $cfgServer = array ();	  /* array de direcciones de servidores sql */
	var $login = array ();		  /* los distintos logins para cada conexion */
	var $passwd = array ();		  /* las distintas pass de cada conexion */
	var $dbase = array ();		  /* las distintas dbs por defecto de conexion */
	var $port = array ();		  /* los distintos puertos por defecto de conexion */
	var $SQL = array ();			  /* Sockets para Multiples conexiones */
	var $SQL_point = 0;			  /* Indice de conexion, este indice lo vamos a usar para referencia todas las tablas superiores.
										   * obteniendo asi todos los datos necesarios para rellenar la tabla SQL */
	var $aListaCampos = array ();	 /* Array referencial de tabla-campos(s) */

	/** Los identificadores de resultados en un futuro tendran que ir
     en un array bidimensional, donde el primer indice venga indicado por
     nuestro puntero de conexion SQL_point */
	var $consulta;					  /* consulta actual */
	var $res_id = array ();		  /* Identificadores de resultados */
	var $res_point = 1;			  /* Nuestro puntero al resultados actual * */
	/*
	 * Actualmente $tablas contiene los datos de una db, y cuando se añada el soporte select_db, ese metodo habra de cargarnos en
	 * esta tabla la nueva estructura de la db. Hay que analizar la repercusion en los recursos del sistema que la implementacion
	 * del select_db de esta forma tendria. Existe la posibilidad de tener cargadas en memoria varias estructuras de bases de
	 * datos, es un tema que hay que estudiar 
	 */
	var $tablas = array (array ());	/* Listado de las tablas que dispone la base de datos actual y sus campos. En la posicion 0
												 * iria el nombre de tabla, el resto de posiciones es para los campos */

	var $debug = 0;		/** msgs de debug si/no -> 1/0 **/

		/** Metodo Ruta **/
	var $aDestinos;				  /* Array con las tablas destino */

	var $aAnalizadas;				  /* Array con las tablas que se llevan /* analizadas */

	var $aEncontradas;			  /* Array con las tablas que llevo encontradas */

	var $aLocalizadas;			  /* Array con las tablas destino a las que se ha llegado ya */

	var $partes_wer;				  /* Array con las parte where que contendrá la consulta */

	var $relaciones = array ();  /* Matriz con las relacion de la base de datos */
	var $indicesOrigen = array ();	/* los indices de las tablas de origen */
	var $indicesDest = array (); /* los indices de las tablas destino */
	var $camposDest = array ();  /* los campos de las tablas destino */
	var $camposOrigen = array ();	/* los campos de las tablas origen */
	/*
	 * El Constructor: Nuestro constructor actualmente se encarga de inicializarnos como queremos para este caso. Fase
	 * Preliminiar. NOTA: Este constructor ha de ser modificado por uno que realice una primera conexion al servidor sql y
	 * consulte en la db de nuestra aplicacion cual es el login y passwd de conexion para este site. Actualmente se esta haciendo
	 * a pelo. :O 
	 */
	function wol_db ($nombre, $login = NULL, $passwd = NULL, $cfgServer = NULL, $dbase = NULL, $port = NULL) {

		$this->debug = 0;

		if (empty ($login) OR empty ($passwd) OR empty ($cfgServer) OR empty ($dbase)) {
			$login = $GLOBALS['login'];
			$passwd = $GLOBALS['passwd'];
			$cfgServer = $GLOBALS['cfgServer'];
			$dbase = $GLOBALS['dbase'];
			$port = $GLOBALS['port'];
			if ($this->debug) debug ("Recogiendo datos de conexion de config.php");
		}

		$this->nombre = $nombre;
		$this->cfgServer[1] = $cfgServer;
		$this->login[1] = $login;
		$this->passwd[1] = $passwd;
		$this->dbase[1] = $dbase;
		$this->port[1] = $port;

		if ($this->debug)
			debug ("new wol_db $nombre, $cfgServer, $login, $passwd, $dbase, $port");

		// Nos conectamos a la base de datos
		$this->reset_pointers ();
		$this->conecta (1);
		$this->get_prim_keys ($dbase);

		// debug(" el site es $cfgServer");
		// Aqui hay que crear una funcion par conseguir todas las claves de las tablas de la base
		// de datos a la que nos conectamos...
// Claves primarias de las tablas de la base de datos

		/*
		 * Conseguimos las claves primarias de cada tabla de la base de datos 
		 */
		/*
		 * Construimos una matriz que representa las relaciones existentes en la base de datos (off)
		 */
		$this->cons_relaciones ();

		/*
		 * / Prueba de el nuevo procedimiento ruta $paso = array (); // Array de destinos $paso[0] = "Sites"; $paso[1] =
		 * "Sites_info"; $clave = 5; depurar_array($this->rutaprobe(Sites,$paso,$clave)); /* 
		 */

	}
	/*
	 * Funcion que construye una matriz que representa las relaciones de la base de datos 
	 */
	function cons_relaciones () {
//debug ("pasamos pon cons_relaciones");
		// Inicializaciones de indices.
		if (!$this->conectado(1)) return false;

		$consulta = "SELECT distinct(tabla_origen),campo_origen,tabla_destino,campo_destino FROM Relaciones order by tabla_origen";
		$rs = $this->query ($consulta);	// Lanzamos la busqueda
		$numTablas = $this->num_rows ($rs);	// Conseguimos el numero de tablas
		// Inicializamos los indices de tablas origen y destino a cero
		for ($j = 0; $j < $numTablas; $j++) {
			$row = $this->fetch_array ($rs);
//debug("Tabla origen = $row[0]");
//                  debug ("Esta vacio $row[0]");
			// Fix distancias no infinitas en nodos forzados
			if (!in_array($row[0],$this->indicesOrigen)) $this->indicesOrigen[$j] = $row[0];
			// $this->camposOrigen[$row[0]][$row[2]] = $row[0].".".$row[1]."=".$row[2].".".$row[3];
			if (!is_array($this->camposOrigen[$row[0]][$row[2]])) $this->camposOrigen[$row[0]][$row[2]] = array();
			array_push($this->camposOrigen[$row[0]][$row[2]],$row[1]);
			array_push($this->camposOrigen[$row[0]][$row[2]],$row[3]);
		}

		$consulta = "select distinct(tabla_destino),campo_destino from Relaciones order by tabla_destino";
		$rs = $this->query ($consulta);	// Lanzamos la busqueda
		$numTablas = $this->num_rows ($rs);	// Conseguimos el numero de tablas
		// Inicializamos los indices de tablas origen y destino a cero
		for ($j = 0; $j < $numTablas; $j++) {
			$row = $this->fetch_array ($rs);
//debug("Tabla destino = $row[0]");
//                  debug ("Esta vacio $row[0]");
			// Fix distancias no infinitas en nodos forzados
			if (!in_array($row[0],$this->indicesDest)) $this->indicesDest[$j] = $row[0];
			$this->camposDest[$row[0]] = $row[1];
		}

		$consulta = "select tabla_origen,tabla_destino from Relaciones order by tabla_origen,tabla_destino";
		$rs = $this->query ($consulta);	// Lanzamos la busqueda
		$i = $j = 1;				  // Variables que nos sevira de indices
		if ($this->num_rows ($rs)) {	// Si existe la tabla Relaciones
			while ($row = $this->fetch_array ($rs)) {	// Mientras queden registros por procesar
				$primTabla = $row[0];	// Primera tabla
				$segTabla = $row[1];	// Segunda tabla
				// El 1 indica que hay relacion entre primTabla y segTabla
				$this->relaciones[$primTabla][$segTabla] = 1;
			}
		} else {
			salida ("No hay relaciones en la base de datos<br/>\n");
		}
//    foreach ($this->relaciones as $fila)
		// foreach ($fila as $campo)
		// debug ("Campo de result = $campo");
//debug ("Campo de prueba : " . $result[Tipo_busq][Wheres]);
//debug ("Campo de prueba2  : "  . $this->indicesDest[0]);
//debug ("Salimos por cons_relaciones");
		// debug("<b>Depurando las relaciones de la base de datos</b>");
		// depurar_array($this->relaciones);
		// return $result;

	}

/* Funcion que resetea los punteros de conexiones y de resultados de busqueda SQL */
	function reset_pointers () {
		$this->SQL = array ();
		$this->res_id = array ();
		$this->SQL_point = 0;
		$this->res_point = 1;
	}

	function get_dbase_name () {
		return $this->dbase[$this->SQL_point];
	}

	 /**
	 	* Obtener las claves primarias de una tabla.
		*/
	function get_keys ($tabla) {
// debug("get_keys($tabla)");
		if (!$this->conectado()) return NULL;
		if (empty ($tabla))
			return NULL;
		$aTablas = $this->get_fields($tabla);
		if (!is_array($aTablas)) {
			return NULL;
		}
// debug("query realizada....");
		$num_flds = sizeof($aTablas);
		$aKeys = NULL;
		for ($i = 0; $i < $num_flds; $i++) {
			// debug("nombre = ".$this->field_name($tmp_id,$i));
			// debug("flags = ".$this->field_flags($tmp_id,$i));
			// $oFields[$this->field_name($tmp_id,$i)] = $oCampo;
			if (stristr ($aTablas[$i]['flags'],'primary_key'))
				$aKeys[] = $aTablas[$i]['name'];
		}
		// no mientras no pertenezca a un puntero interno de wol_db: $this->libera($tmp_id);
		return $aKeys;
	}

/* 
* Funcion que consigue todas las claves primarias de la base de datos (Fixme: en vez de describe, usar fetch_field) 
*	Mejor seria incluso utilizar get_keys(tabla)
*/
	function get_prim_keys ($dbase = "") {
		if (!$this->conectado()) return false;
		if (!empty ($dbase)) {
			// Conseguimos el nombre de todas las tablas de la base de datos
			$rs = $this->list_tables ();
			while ($row = $this->fetch_row ($rs)) {	// Mientras nos queden tablas en la base de datos
				$aTmp = $this->get_keys ($row[0]);
				if (!empty ($aTmp[0]))
					$this->claves[$row[0]] = $aTmp;
			}
			$this->libera ();
			return;
		} else
			return 0;
		return 1;
	}

	function init () {
		if ($this->_bAlive)
			return 1;
		$this->debug = 0;
		if ($this->debug)
			debug ("wol_db->init()");
		$this->SQL_point = 1;
		$this->_bAlive = TRUE;
		return 1;
	}

	/*
	 * obtener_clave($tabla) : Esta funcion recibe el nombre de tabla, y nos dice el nombre del campo primary key de $tabla 
	 */
	function obtener_clave ($tabla = "") {
		if (!$tabla)
			return NULL;
		else {
			$clave = $this->claves[$tabla];
			if (empty($clave))
				$clave = $this->claves[strtolower ($tabla)];
			return $clave;
		}
	}

	function ruta_ant ($tb_orig, $tb_dest, $key_orig = "") {
		/*
		 * Dado que me he dado cuenta que esto ha de ser implementado de otra manera, y que no tengo tiempo para hacerlo ahora. Voy 
		 * a lo basto y pongo ifs anidados de mala manera. :) esto ha de ser cambiado cuanto antes 
		 */

//salida("ruta de $tb_orig a $tb_dest<BR>\n");
		if (!empty ($key_orig))
			$Where_key = $tb_orig.".".$this->obtener_clave ($tb_orig)."=$key_orig ";

		if (!strcmp ($tb_orig, $tb_dest)) {
			$aRetVal[0] = $tb_dest." ";
			$aRetVal[2] = array ($tb_dest);
			if (!empty ($key_orig)) {
				$aRetVal[1] = $Where_key;
			} else
				$aRetVal[1] = " ";
			return $aRetVal;
		}
		elseif (!strcmp ($tb_dest, "Preguntas")) {
			$Where = "Encuestas_votacion.id_encuesta=Preguntas.id_encuesta ";
			if (!empty ($key_orig))
				$where .= " AND ".$Where_key;

			$aRetVal = array ("Encuestas_votacion, Preguntas", $Where, array ("Encuestas_votacion", "Preguntas"));
			return $aRetVal;
		}
		elseif (!strcmp ($tb_dest, "Respuestas")) {
			if (!empty ($key_orig))
				return array ("", "$tb_orig.".$this->obtener_clave ($tb_orig)."=$key_orig ", array ());
			else
				return NULL;
		}
		elseif (!strcmp ($tb_dest, "Maestro_respuestas")) {
			return array ("Preguntas, Respuestas, Maestro_respuestas",
							  "Preguntas.id_pregunta=Respuestas.id_pregunta AND ".
							  "Respuestas.id_mae_resp=Maestro_respuestas.id_mae_resp ",
							  (empty ($key_orig)) ? ""
							  : " AND Preguntas.id_pregunta=$key_orig ", array ("Preguntas", "Respuestas", "Maestro_respuestas"));
		}
		else
		return NULL;

/* este algoritmo puede ser interesante. :??
           $nTablas = sizeof($this->tablas);
        $ClaveOrg = $this->obtener_clave($tb_orig);
        $ClaveDest = $this->obtener_clave($tb_dest);
        $aTablas = array();
        $pTablas = 0;
           for ($i = 0; $i<$nTablas; $i++) { // Nos recorremos todas las tablas
            /* Si estamos en la tabla origen, no hacemos nada. seguimos */
		if (!strcmp ($this->tablas[$i], $tb_orig))
			continue;
		/*
		 * Caso de k nos encontremos la clave origen en una tabla.... * if (encuentra($this->tablas[$i],$ClaveOrg)!=-1) { if
		 * (!strcmp($this->tablas[$i],$tb_dest)) { $FROM = "$tb_orig as $tb_orig, $tb_dest as $tb_dest "; $WHERE =
		 * "$tb_orig.$ClaveOrg = $tb_dest.$ClaveOrg "; /* OJO: aki hay k meterle un chekeo de tipo de datos * if
		 * (!empty($key_orig)) $WHERE .= "AND $tb_orig.$ClaveOrg = $key_orig"; return array($FROM,$WHERE,array($tb_orig,$tb_dest));
		 * } else { $aTablas[$pTablas++] = $this->tablas[$i][0]; } } if (!strcmp($this->tablas[$i],$tb_dest)) $posDest = $i; } 
		 */
	}

	function errores ($msg = NULL) {
		if (!$msg) {
			$msg = "(".mysql_error ($this->SQL[$this->SQL_point])." - ".mysql_error ($this->SQL[$this->SQL_point]).") ".substr($this->consulta,0,100);
		}
		elseif (mysql_errno ($this->SQL[$this->SQL_point])) {
			$msg = "(".mysql_errno ($this->SQL[$this->SQL_point])."-".mysql_error ($this->SQL[$this->SQL_point]).") ".substr($msg,0,100);
		}
		debug ("Error (db): $msg");
	}


	/*
	 * conecta () : Esta funcion nos crea un socket con el servidor sql pertinente y nos lo mete en una de las propiedades de
	 * nuestro objeto. 
	 */
	function conecta ($SQL = NULL) {

				/** **
        if (!is_numeric($SQL)) $this->SQL_point = sizeof($this->SQL) + 1;
        else $this->SQL_point = $SQL;
				/** **/
		if ($SQL)
			$this->SQL_point = (int) $SQL;

		if ($this->debug)
			debug ("db->conecta(".$this->SQL_point." - ".$this->nombre.
					 $this->SQL[$this->SQL_point]."); dbase = ".$this->dbase[$this->SQL_point]);

		if (!($this->SQL[$this->SQL_point] =
				mysql_connect ($this->cfgServer[$this->SQL_point].( (is_numeric($this->port[$this->SQL_point])) ? ':'.$this->port[$this->SQL_point] : '' ),
									$this->login[$this->SQL_point], $this->passwd[$this->SQL_point]))) {
			/** **
			errores (__FILE__, __LINE__);
			// session_destroy ();
			exit;
			/** **/
			mysql_close($this->SQL[$this->SQL_point]);
			$this->reset_pointers();
		}
		if (!@mysql_select_db ($this->dbase[$this->SQL_point], $this->SQL[$this->SQL_point])) {
			$this->errores();
			mysql_close($this->SQL[$this->SQL_point]);
			$this->reset_pointers();
		}
		return $this->SQL_point;
	}

	/**
	* Leer valor de configuracion
	* Si el valor de nombre esta en la propiedad $configuracion[$nombre]
	*lo retorn .Sino lo lee de la tabla _main y lo inserta en el array
	*
	* @param $nombre para leer
	* @return el valor de nombre
	*/
	function read_main_value ($nombre = "") {
		if ($nombre == "")
			return "";
		else {
			if (!empty ($this->claves["_main"])) {
				$consulta = "SELECT valor FROM _main WHERE nombre='$nombre'";
				$id = $this->query ($consulta);
				if ($this->num_rows ($id)) {
					$aTmp = $this->fetch_row ($id);
					$ret_val = $aTmp[0];
				} else
					$retval = NULL;
				$this->libera ($id);
			} else
				$ret_val = NULL;
			return $ret_val;
		}
	}

	/**
	* Escribir valor de configuracion
	* Si el valor de nombre esta en la propiedad $configuracion[$nombre]
	*lo retorn .Sino lo lee de la tabla _main y lo inserta en el array
	*
	* @param $nombre para leer
	* @return el valor de nombre
	*/
	function write_main_value ($nombre, $valor) {
		if (empty ($nombre) OR empty ($valor))
			return 0;
		else {
			if (!empty ($this->claves["_main"])) {
				$consulta = "UPDATE _main SET valor = '$valor' WHERE nombre='$nombre'";
				$id = $this->query ($consulta);
				$ret_val = 1;
			} else
				$ret_val = 0;
			return $ret_val;
		}
	}

	function last_insert_id () {
		$tmp_res = $this->query ("SELECT LAST_INSERT_ID()");
		$row = $this->fetch_row ($tmp_res);
		$this->libera ($tmp_res);
		return $row[0];
	}

/**  tb_insert($tb_name,$aFields) :
*     Esta funcion nos ejecuta una consulta en el socket sql ($SQL) con
*     valor REPLACE $tb_name VALUES ($aFields)
*     OBSERVACIONES: Si el campo correspondiente a la clave primaria
*     contenida en la tabla $aFields tiene un valor nulo (NULL para
*     string o 0 para numerics) el registro sera insertado en vez de
*     reemplazado.
*     MUCHO OJO!!! Esta funcion solo funciona si la tabla $aFields puede
*      ser referenciada por el nombre de campo (ej usando mysql_fetch_array)
*      de otra forma los valores insertados son 0 o ''.
*/
	function tb_insert ($tb_name, $aField) {
		// global $SQL;
		$init = 1;
		$i = 0;

		$aFieldList = $this->get_fields ($tb_name);

		$consulta = "INSERT INTO ";
		foreach ($aFieldList as $aTb) {
			if (!isset ($aField[$aTb['name']]) OR ! isset ($aField[$aTb['name']]))
				continue;

			if (!$init) {
				$valores .= ",";
				$campos .= ",";
			} else
				$init = 0;
			$campos .= $aTb['name'];
			$valores .= $this->sql_format_field ($aField[$aTb['name']], $aTb);
		}
		$consulta .= "$tb_name ($campos) VALUES (".$valores.")";

		// salida($consulta."<BR>\n");
		if (!($ins_tb_id = $this->query ($consulta))) {
			aviso ("ha fallado la consulta!! ($consulta)");
			return 0;
		}
		// debug("ins id y tal = $ins_tb_id");
		return 1;
	}


/**  tb_replace($tb_name,$aFields) :
*     Esta funcion nos ejecuta una consulta en el socket sql ($SQL) con
*     valor REPLACE $tb_name VALUES ($aFields)
*     OBSERVACIONES: Si el campo correspondiente a la clave primaria
*     contenida en la tabla $aFields tiene un valor nulo (NULL para
*     string o 0 para numerics) el registro sera insertado en vez de
*     reemplazado.
*     MUCHO OJO!!! Esta funcion solo funciona si la tabla $aFields puede
*      ser referenciada por el nombre de campo (ej usando mysql_fetch_array)
*      de otra forma los valores insertados son 0 o ''.
*/
	function tb_replace ($tb_name, $aField) {
		// global $SQL;
		$init = 1;
		$i = 0;

		$aFieldList = $this->get_fields ($tb_name);

		$consulta = "REPLACE INTO ";
		foreach ($aFieldList as $aTb) {
			if (!isset ($aField[$aTb['name']]) OR ! isset ($aField[$aTb['name']]))
				continue;

			if (!$init) {
				$valores .= ",";
				$campos .= ",";
			} else
				$init = 0;
			$campos .= $aTb['name'];
			$valores .= $this->sql_format_field ($aField[$aTb['name']], $aTb);
		}
		$consulta .= "$tb_name ($campos) VALUES (".$valores.")";

		// salida($consulta."<BR>\n");
		if (!($ins_tb_id = $this->query ($consulta))) {
			aviso ("ha fallado la consulta!! ($consulta)");
			return false;
		}
		return true;
	}

 /**  tb_update($tb_name,$aFields) :
   *     Esta funcion nos ejecuta una consulta en el socket sql ($SQL) con
   *     valor SET $aFields->key = $aFields->value ... WHERE (PKs assigned [AND $aKey_fld extra conditions])
   *     OBSERVACIONES: Si el campo correspondiente a la clave primaria
   *     contenida en la tabla $aFields tiene un valor nulo (NULL para
   *     string o 0 para numerics) el registro sera insertado en vez de
   *     reemplazado.
   *     MUCHO OJO!!! Esta funcion solo funciona si la tabla $aFields puede
   *      ser referenciada por el nombre de campo (ej usando mysql_fetch_array)
   *      de otra forma los valores insertados son 0 o ''.
	* @param $tb_name	-	Nombre de la tabla que se va a actualizar.
	* @param $aField	-	Array asociativo de campos(nombre) y valores a actualizar.
	*		Si alguno de estos campos, es una clave primaria, este campo pasa a la clausula WHERE en vez de quedarse en el SET del update.
	* @param $aKey_fld-	Si no se desea updatear por claves primarias (pordefecto), lista de campos para poner en la condicion.
	*		Si desea cambiar el valor de una clave primaria, el campo debera estar en esta tabla, como valor antiguo y en $aFields
	*			con el valor al que se desea actualizar. Este array puede contener varios arrays referenciales contenedores de claves y valores,
	*			caso de ser asi, se añaden todos a la clausula where de la siguiente forma (dado que seran representables mediante 1 matriz):
	*								 |-  AND -|	 |-  AND -|
	*							campo1		campo2		campoN
	*				idx1	-	 val11		 val12		 null		-|
	*																		OR
	*				idx2	-	 null			 val22		 val2n	-|
	*																		OR
	*				idxN	-	 valn1		 null			 valn2	-|
	*		De tal forma que el resultado producido en la clausula WHERE seria el siguiente:
	*			WHERE [ ... AND ] ( (campo1=val11 AND campo2=val12) OR (campo2=val22 AND campoN=val2n) OR (campo1=valn1 AND campoN=valn2) )
	*				
	* @param $bForce	-	Caso de no encontrar ningun dato para meter en las condiciones del update -es decir, clausula where vacia-, si lanzarlo igualmente.
   */
	function tb_update ($tb_name, $aField, $aKey_fld = NULL, $bForce = FALSE) {
		if (empty ($tb_name))
			return 0;
		$init = 1;
		$aGetField = $aCampos = $this->get_fields ($tb_name);
		$aPKs = $this->get_keys ($tb_name);
		$aPK_fld = array ();
		if (!isset ($bForce))
			$bForce = FALSE;
		if (is_array ($aKey_fld) AND ! sizeof ($aKey_fld)) {
			$aKey_fld = NULL;
		}
		$consulta = "UPDATE $tb_name SET ";
		$chunk = NULL;
		while ($aTb = array_shift ($aCampos)) {
			if (is_array ($aKey_fld) AND isset ($aKey_fld[$aTb['name']])) {
				array_push ($aPK_fld, $aTb);
				if (!isset ($aField[$aTb['name']]) OR ! isset ($aField[$aTb['name']]))
					continue;
			}
			// Lo de despues del and, evita que , teniendo definido el segundo array (las claves), valores del primer array, que si sean clave,
			//		pasen a formar parte de las condiciones, en vez de las asignaciones.
			elseif (in_array ($aTb['name'], $aPKs) AND (!is_array($aKey_fld) OR !sizeof($aKey_fld)) ) {
				// debug($aTb['name']." anyadido a las PKs");
				array_push ($aPK_fld, $aTb);
				continue;
			}
			elseif (!isset ($aField[$aTb['name']]) OR ! isset ($aField[$aTb['name']])) {
				// debug("no me has mandado $aTb[name]");
				continue;
			}

			$fmt = $this->sql_format_field ($aField[$aTb['name']], $aTb);
			if (!empty ($fmt))
				$chunk = $aTb['name'].' = '.$fmt;

			if (!$init AND ! empty ($chunk))
				$consulta .= ",";
			else
				$init = 0;
			if (!empty ($chunk))
				$consulta .= $chunk;
		}
		$doit = FALSE;
		$init = 1;
		// debug("chunk = ($chunk)");
		if (empty ($chunk))
			return -1;
		// debug("pk2");
		// print_r($aPK_fld);
		// debug("ak2");
		// print_r($aKey_fld);

	  /** Seccion de composion de la parte WHERE **/
		$chunk = NULL;
		foreach ($aPK_fld as $aPK) {
			if (is_array ($aKey_fld) AND isset ($aKey_fld[$aPK['name']])) {
				$aField[$aPK['name']] = $aKey_fld[$aPK['name']];
			}
			if (!isset ($aField[$aPK['name']]))
				continue;
			if ($init)
				$consulta .= " WHERE ";
			$doit = TRUE;

			$fmt = $this->sql_format_field ($aField[$aPK['name']], $aPK);
			if (!empty ($fmt))
				$chunk = $aPK['name'].' = '.$fmt;

			/** **
			if ($this->es_null ($aField[$aPK['name']]))
				$chunk = $aPK['name']." = NULL";
			elseif ($this->es_entero ($aPK['type']))
				$chunk = $aPK['name']." = ".$aField[$aPK['name']];
			elseif ($this->es_decimal ($aPK['type']))
				$chunk = $aPK['name']." = ".$aField[$aPK['name']];
			elseif ($this->es_timestamp ($aPK['type']))
				$chunk = $aPK['name']." = ".(empty ($aField[$aPK['name']])
													  ? 'NULL' : $aField[$aPK['name']]);
			elseif ($this->es_date ($aPK['type']))
				$chunk = $aPK['name']." = ".$this->formatear_fecha ($aField[$aPK['name']]);
			elseif ($this->es_string ($aPK['type']))
				$chunk = $aPK['name']." = '".addslashes ($aField[$aPK['name']])."'";
			else
			debug ("tb_update($tb_name) no reconoce el tipo $aPK[type], campo $aPK[name]");
			/** **/

			if (!$init AND ! empty ($chunk)) {
				$consulta .= " AND ";
			} else
				$init = 0;

			if (!empty ($chunk))
				$consulta .= $chunk;
			$chunk = NULL;
		}
		if (is_array ($aKey_fld)) {
			$i = 0;
			$docond = 0;
			foreach ($aKey_fld as $aKey)
				if (is_array ($aKey) AND sizeof ($aKey)) {
				if ((int) $init AND ! $docond)
					$sep .= " WHERE ( ";
				else
					$sep = NULL;
				$sep .= (($i++) ? " OR " : (($doit) ? " AND (" : ""));

				$j = 0;
				foreach ($aKey as $campo  =>$valor) {
					foreach ($aGetField as $aFld) {
						if (!strcasecmp ($campo, $aFld['name'])) {
							$fmt = $this->sql_format_field ($valor, $aFld);
							if (!empty ($fmt))
								$chunk = $campo.' = '.$fmt;

							/** **
							if ($this->es_null ($campo))
								$chunk = $campo." = NULL";
							elseif ($this->es_entero ($aFld['type']))
								$chunk = $campo." = ".$valor;
							elseif ($this->es_decimal ($aFld['type']))
								$chunk = $campo." = ".$valor;
							elseif ($this->es_timestamp ($aFld['type']))
								$chunk = $campo." = ".$valor;
							elseif ($this->es_string ($aFld['type']))
								$chunk = $campo." = '".addslashes ($valor)."'";
							else
							$chunk = NULL;
							/** **/

							if (!empty ($chunk)) {
								if (!empty ($sep)) {
									$consulta .= $sep;
									$sep = NULL;
								}
								$docond = 1;
								$consulta .= (($j++) ? " AND " : " ( ").$chunk;
							}
							break;
						}
					}
				}
				if (empty ($sep))
					$consulta .= " )";
			}
			if ($docond) {
				$consulta .= " )";
				$doit = 1;
			}
		}

		if ($doit OR $bForce)
			if (!($ins_tb_id = $this->query ($consulta))) {
				aviso ("ha fallado la consulta!! ($consulta)");
				return 0;
			}
		$retval = $this->affected_rows();
		$this->libera($ins_tb_id);
		return $retval;
	}

/**
  * Metodo encargado de borrar el contenido de una tabla para unas claves/campos determinados.
  */
	function tb_delete ($tb_name, $aFields_list = NULL, $bCommit = TRUE) {
		if (empty ($tb_name))
			return 0;

		if (!isset ($bCommit))
			$bCommit = TRUE;

		if (is_array ($aFields_list)) {
			$b = current ($aFields_list);
			reset ($aFields_list);
			if (!is_array ($b)) {
				$aTmp = $aFields_list;
				$aFields_list = array ();
				array_push ($aFields_list, $aTmp);
			}
		} else {
			if (isset ($aFields_list))
				$aTmp = $aFields_list;
			else
				$aTmp = "";
			$aFields_list = array ();
			array_push ($aFields_list, $aTmp);
		}

		if (is_array($tb_name) AND sizeof($tb_name)) {
			reset($tb_name);
			$tb_base = current($tb_name);
			$aDestinosRuta = $tb_name;
		} else $tb_base = $tb_name;

		/** Obtenemos/Parseamos las condiciones de borrado **/
		foreach ($aFields_list as $aFields) {
			if (empty ($cons) AND !$init) {
				$init = 1;
			} else {
				$init = 2;
			}
			$aCampo = NULL;
			while (list($clave,$valor) = each($aFields)) {
				if ( strchr($clave,'.') ) {
					$aTmp = split('\.',$clave);
					if (strcasecmp($aTmp[0],$tb)) {
						$tb = $aTmp[0];
						$aCampos = $this->get_fields($tb);
						if (is_array($tb_name) AND is_array($aCampos) AND sizeof($aCampos) AND !in_array($tb,$aDestinosRuta))
							array_push($aDestinosRuta,$tb);
					}
					$campo_act = $aTmp[1];
				} else {
					if (empty($tb) OR strcmp($tb,$tb_base) ) $tb = $tb_base;
					$aCampos = $this->get_fields ($tb);
					if (!is_array ($aCampos) OR ! sizeof ($aCampos)) continue;
					$campo_act = $clave;
				}

				foreach ($aCampos as $aCampoSearch) 
					if (!strcasecmp($aCampoSearch['name'],$campo_act)) {
						$aCampo = $aCampoSearch;
						break;
					}

				if (is_array($aCampo)) {
					$fmt = $this->sql_format_field ($valor, $aCampo);
					if (!empty ($fmt)) {
						// Si estamos borrando multiples tablas, ponemos referencia a la tabla
						if (is_array($tb_name) AND sizeof($tb_name)) $chunk = $tb.'.';
						else $chunk = '';
						$chunk .= $aCampo['name'].' = '.$fmt;
					}

					if ($init == 1 AND ! empty ($chunk)) {
						$cons .= " WHERE ( $chunk ";
						$init = 0;
					}
					elseif ($init == 0 AND ! empty ($chunk)) {
						$cons .= " AND $chunk ";
						$init = 0;
					}
					elseif ($init == 2 AND ! empty ($chunk)) {
						$cons .= ") OR ( $chunk ";
						$init = 0;
					}
					$chunk = NULL;
				}
			}

		}
		$cons .= " ) ";

		$cons_ini = "DELETE FROM $tb_name ";
		if (is_array($tb_name)) {
			// $aCampos = $this->get_fields ($tb_name);
			// if (!is_array ($aCampos) OR ! sizeof ($aCampos)) return NULL;
			if (sizeof($tb_name) <= 1) $cons = 'DELETE FROM '.array_shift($tb_name).$cons;
			else {
				$aRes = $this->ruta($tb_base,$aDestinosRuta);
				$i = 0;
				foreach ($tb_name as $tb) $consulta .= ( (!$i++) ? 'DELETE ' : ', ' ).$tb;
				if (!empty($consulta)) $cons = $consulta.' FROM '.$aRes['left_join_from'].' '.$cons;
			}
		} else {
			$cons = 'DELETE FROM '.$tb_name.$cons;
		}

		/** **/
		if (!($del_tb_id = $this->query ($cons))) {
			aviso ("ha fallado la consulta!! ($consulta)");
			return NULL;
		}
		/** **/
		$retval = $this->affected_rows();
		$this->libera($del_tb_id);
		return $retval;
	}

	/***  Reconocimiento de Tipos de datos  ***/
	function es_null ($sql_val) {
		if (!strcasecmp ($sql_val, "NULL"))
			return 1;
		return 0;
	}

	function es_entero ($sql_type) {
		$retval = 0;
		if (stristr ($sql_type, "int"))
			$retval = 1;
		// elseif (stristr($sql_type,"decimal")) $retval = 1;
		return $retval;
	}

	function es_decimal ($sql_type) {
		$retval = 0;
		if (stristr ($sql_type, "real"))
			$retval = 1;
		elseif (stristr ($sql_type, "decimal")) $retval = 1;
		return $retval;
	}

	function es_timestamp ($sql_type) {
		$retval = 0;
		if (stristr ($sql_type, "timestamp"))
			$retval = 1;
		return $retval;
	}

	function es_string ($sql_type) {
		$retval = 0;
		if (stristr ($sql_type, "varchar"))
			$retval = 1;
		elseif (stristr ($sql_type, "string")) $retval = 1;
		elseif (stristr ($sql_type, "blob")) $retval = 1;
		return $retval;
	}

	function es_date ($sql_type) {
		$retval = 0;
		if (stristr ($sql_type, "datetime") OR stristr ($sql_type, 'time') OR stristr ($sql_type, "date"))
			$retval = 1;
		return $retval;
	}

	function formatear_fecha ($fecha, $bTag = TRUE, $bNull = TRUE) {
		if (empty ($fecha))
			return 'NULL';
		if (!isset ($bTag))
			$bTag = TRUE;
		if (strstr ($fecha, ' ')) {
			$aTmp = split (' ', $fecha);
			$first = TRUE;
			for ($i = 0; isset ($aTmp[$i]); $i++) {
				if (!empty ($aTmp[$i])) {
					if ($first) {
						$date = $aTmp[$i];
						$first = FALSE;
					} else {
						$hour = $aTmp[$i];
					}
				}
			}
		} else
			$date = $fecha;

		if (strstr ($date, '/'))
			$sep = '/';
		elseif (strstr ($date, '-')) $sep = '-';
		else
		$sep = NULL;

		if ($sep) {
			$aTmp = split ($sep, $date);
			if (sizeof ($aTmp) != 3)
				$retfecha = NULL;
			elseif (is_numeric ($aTmp[0]) AND is_numeric ($aTmp[1]) AND is_numeric ($aTmp[2])) {
				if (strlen ($aTmp[2]) == 4) {	// Año al final.
					$retfecha = $aTmp[2].'-'.$aTmp[1].'-'.$aTmp[0].((!empty ($hour)) ? ' '.$hour : '');
				}
				elseif (strlen ($aTmp[0]) == 4) {
					$retfecha = $aTmp[0].'-'.$aTmp[1].'-'.$aTmp[2].((!empty ($hour)) ? ' '.$hour : '');
				}
				else
				$retfecha = NULL;
			}
			else
			$retfecha = NULL;
		}
		elseif (strstr ($date, ':') OR is_numeric ($date)) {
			$retfecha = $date;
		}
		else
		$retfecha = NULL;

		if (empty($retfecha)) {
			if ($bNull) $retval = "NULL";
			else $retval = '0000-00-00';
		}
		elseif ($bTag) $retval = "'".$retfecha."'";
		elseif (!$bTag) $retval = $retfecha;
		return $retval;
	}

	function sql_format_field ($value, $FieldDesc) {
		if (!is_array ($FieldDesc))
			return NULL;

		if ($this->es_null ($value)) {
			$retval = "NULL";
		}
		elseif ($this->es_entero ($FieldDesc['type'])) {	// AND is_numeric($aField[$aTb[0]])) {
			// $valores .= $aField[$aTb[0]];
			$retval = "'".addslashes ($value)."'";
		}
		elseif ($this->es_decimal ($FieldDesc['type'])) {	// AND is_numeric($aField[$aTb[0]])) {
			// $valores .= $aField[$aTb[0]];
			$retval = "'".addslashes ($value)."'";
		}
		elseif ($this->es_timestamp ($FieldDesc['type']) AND is_numeric ($value)) {
			$retval = (empty ($value) ? 'NULL' : $value);
		}
		elseif ($this->es_date ($FieldDesc['type'])) {
			$retval = $this->formatear_fecha ($value);
			if (!strcasecmp ($retval, 'null') AND strstr ($FieldDesc['flags'], 'not_null'))
				$retval = '0000-00-00';
				// $retval = $this->formatear_fecha (date ('Y-m-d'));
		}
		elseif ($this->es_string ($FieldDesc['type'])) {
			$retval = "'".addslashes ($value)."'";
		}

		return $retval;
	}

	/*
	 * query($consulta) : Esta funcion es la encargada de lanzar la consulta que consideremos oportuna contra el servidor SQL. 
	 */
	function query ($consulta) {
		if (empty ($consulta))
			$this->errores ("Consulta vacia");
		// else debug("Log (db) : $consulta");

		/* *
		 * Aqui se pueden desviar los logs de cada usuario a un fichero o consola *
		 * 
		 * if (!($fh = fopen($this->ruta_log,"a"))) { aviso("No se pudo crear el fichero de logs en $this->ruta_log"); }
		 * 
		 * $today = getdate(); $seconds = $today['seconds']; $min = $today['minutes']; $hours = $today['hours'];
		 * 
		 * $consulta2 = $hours . ":" . $min . ":" . $seconds . " " . $this->SQL_point ." " . $consulta . "\n"; if
		 * (!fwrite($fh,$consulta2)) { aviso ("No se pudo escribir en el fichero de logs en $this->ruta_log"); } if (!fclose($fh))
		 * { aviso ("No se pudo cerrar el fichero de logs en $this->ruta_log"); }  
		 * */

		if (!(int) $this->conectado ()) $this->conecta (1);

		if (strcasecmp($DEBUG,'ON') AND is_a($GLOBALS[$GLOBALS['APP_NAME']],'wolSesion')) {
			$logp = $GLOBALS[$GLOBALS['APP_NAME']]->getFromKrn('db_logpath');
			// debug("log path para ".$GLOBALS['APP_NAME']." : $logp ");
			// print_r($GLOBALS[$GLOBALS['APP_NAME']]->_aKrnConf);
			$today = getdate(); 
			if (strlen($today['mon'])==1) $today['mon'] = '0'.$today['mon'];
			$logf = $logp.'/'.$today['year'].$today['mon'].$today['mday'].'.log';
			if (!empty($logp) AND is_dir($logp) AND !empty($logf)) {
				if ( ($fh = fopen($logf,"a"))) { 
					$seconds = $today['seconds']; 
					$min = $today['minutes']; 
					$hours = $today['hours'];
					$consulta2 = $hours . ":" . $min . ":" . $seconds . " " . $this->SQL_point ." " . $consulta . "\n"; 
					fwrite($fh,$consulta2);
					fclose($fh);
				}
			}
		}

		$this->consulta = $consulta;
		$this->res_point = sizeof ($this->res_id) + 1;
		if ($this->debug)
			debug ("wolDB->query; link(".$this->SQL_point.") link_id (".$this->SQL[$this->SQL_point].")");
		$tmp_res = @mysql_query ($consulta, $this->SQL[$this->SQL_point]);
		if ($tmp_res) {
			$this->res_point = sizeof ($this->res_id) + 1;
			$this->res_id[$this->res_point] = $tmp_res;
			$retval = $this->res_point;
		} else
			$retval = NULL;
		if (mysql_errno ($this->SQL[$this->SQL_point])) {
			$this->errores ($consulta);
			if ($tmp_res) mysql_free_result($tmp_res);
		}
//debug("db.inc - query(".$this->res_point."-".$this->res_id[$this->res_point].")");
//debug("dbQuery = $consulta");

		return $retval;
	}

	function unbuffered_query ($consulta) {
		if (empty ($consulta)) $this->errores ("Consulta vacia");

		if (!(int) $this->conectado ()) $this->conecta (1);

		if ($this->debug) debug ("wolDB->query; link(".$this->SQL_point.") link_id (".$this->SQL[$this->SQL_point].")");
			@mysql_unbuffered_query ($consulta, $this->SQL[$this->SQL_point]);
		if (mysql_errno ()) $this->errores ($consulta);

		return $retval;
	}

	function num_rows ($id = -1) {
		if (!isset ($id) OR $id == -1)
			$id = $this->res_point;
//salida("en db id = $id<BR>\n");
//debug("db.inc hay_rows($id) res_id = ".$this->res_id[$id]);
//salida("numero de ids = ".sizeof($this->res_id)."<BR>\n");
//salida("SQL = ".$this->SQL[1]."<BR>\n");
		return @mysql_num_rows ($this->res_id[$id]);
	}

	function affected_rows ($idrs = NULL) {
	   if (!is_numeric($idrs)) $idrs = $this->SQL_point;
	   return @mysql_affected_rows ($this->SQL[$idrs]);
	}

/** Ojo que estos no tienen identificadores internos **/
	function num_fields ($id_flds) {
		if (empty ($id_flds))
			return NULL;
		return mysql_num_fields ($id_flds);
	}

	function list_fields ($tabla) {
		if (empty ($tabla))
			return NULL;
// debug("List fields de $tabla");
		if (!$this->conectado(1)) $this->conecta($this->SQL_point);
		$tmprs = mysql_list_fields ($this->dbase[$this->SQL_point], $tabla, $this->SQL[$this->SQL_point]);
		if (!$tmprs) {
			if (mysql_errno ()) {
				$this->errores ('Field List '.$tabla);
			}
			return NULL;
		} else return $tmprs;
	}

/* fetch_field_type($id = -1) :
 */
	function field_type ($id = -1, $i = 0) {
		if (!isset ($id) OR $id == -1)
			return NULL;
		$res_str = mysql_field_type ($id, $i);
		if (mysql_errno ())
			$this->errores ($this->consulta);	/* nuevo */
		return $res_str;
	}

/* fetch_field_name($id = -1) :
 */
	function field_name ($id = -1, $i = 0) {
		if (!isset ($id) OR $id == -1)
			return NULL;
		$res_str = mysql_field_name ($id, $i);
		// debug("field len : $res_str");
		if (mysql_errno ())
			$this->errores ($this->consulta);	/* nuevo */
		return $res_str;
	}

/* fetch_field_flags($id = -1) :
 */
	function field_flags ($id = -1, $i = 0) {
		if (!isset ($id) OR $id == -1)
			return NULL;
		$res_str = mysql_field_flags ($id, $i);
		if (mysql_errno ())
			$this->errores ($this->consulta);	/* nuevo */
		return $res_str;
	}

/* fetch_field_flags($id = -1) :
 */
	function field_len ($id = -1, $i = 0) {
		if (!isset ($id) OR $id == -1)
			return NULL;
		$res_str = (int) mysql_field_len ($id, $i);
		if (mysql_errno ())
			$this->errores ($this->consulta);	/* nuevo */
		return $res_str;
	}

/**
  * Esta funcion obtiene todos los campos de una tabla de la base de datos.
  **/
	function get_fields ($tabla) {
		if (!isset ($tabla) OR empty ($tabla))
			return NULL;

		if (!is_array($this->aListaCampos[$tabla])) {
			$tmp_rs = $this->list_fields ($tabla);
			if (!$tmp_rs)
				return NULL;
			$tmp = $this->num_fields ($tmp_rs);
			$aTablas = array ();
			for ($i = 0; $i < $tmp; $i++)
				// array_push($aTablas,array(
				$aTablas[] = array ("name" => $this->field_name ($tmp_rs, $i),
										  "type" => $this->field_type ($tmp_rs, $i),
										  "len" => $this->field_len ($tmp_rs, $i), "flags" =>$this->field_flags ($tmp_rs, $i)
					);
			$this->aListaCampos[$tabla] = $aTablas;
		} else {
			$aTablas = $this->aListaCampos[$tabla];
		}
		return $aTablas;
	}

	// Estas funciones deberian ser privadas:
	function list_tables () {
		if (!$this->conectado()) return NULL;
		$this->res_point = sizeof ($this->res_id) + 1;
		$this->res_id[$this->res_point] = mysql_list_tables ($this->dbase[$this->SQL_point], $this->SQL[$this->SQL_point]);
		return $this->res_point;
	}

			/** /Ojo que estos no tienen identificadores internos **/
	function tablename ($id, $i = 0) {
		return mysql_tablename ($this->res_id[$id], $i);
	}
	// Fin de los metodos privados

	// OJO aqui tampoco se usan los identificadores internos de wol_db sino los de mysql.
	function get_tables () {
		$tmp_rs = $this->list_tables ();
		$tmp = $this->num_rows ($tmp_rs);
		for ($i = 0; $i < $tmp; $i++)
			$aTablas[] = $this->tablename ($tmp_rs, $i);
		$this->libera ($tmp_rs);
		return $aTablas;
	}


	/*
	 * fetch_array($id = -1) : Esta funcion se encarga de devolvernos un array con el siguiente elemento de la consulta contenida
	 * en $id. 
	 */
	function fetch_array ($id = -1) {
		if (!isset ($id) OR $id == -1)
			$id = $this->res_point;
// debug("fetch_array($id); id = ".$this->res_id[$id]);
		$res_id = mysql_fetch_array ($this->res_id[$id]);
		if (mysql_errno ())
			$this->errores ($this->consulta);	/* nuevo */
		return $res_id;
	}

	/*
	 * fetch_assoc($id = -1) : Esta funcion se encarga de devolvernos un array con el siguiente elemento de la consulta contenida
	 * en $id. 
	 */
	function fetch_assoc ($id = -1) {
		if (!isset ($id) OR $id == -1)
			$id = $this->res_point;
//debug("fetch_array; id = ".$this->res_id[$id]);
		$res_id = mysql_fetch_assoc ($this->res_id[$id]);
		if (mysql_errno ())
			$this->errores ($this->consulta);	/* nuevo */
		return $res_id;
	}

	function fetch_row ($id = -1) {
		if (!$this->conectado()) return NULL;
		if (!isset ($id) OR $id == -1)
			$id = $this->res_point;
		// debug($id);
		return mysql_fetch_row ($this->res_id[$id]);
	}

	/*
	 * fetch_field($id = -1) : Esta funcion se encarga de devolvernos un array con el siguiente elemento de la consulta contenida
	 * en $id. 
	 */
	function fetch_field ($id = -1) {
		if (!isset ($id) OR $id == -1)
			$id = $this->res_point;
//debug("fetch_field; id = ".$this->res_id[$id]);
		$res_id = mysql_fetch_field ($this->res_id[$id]);
		if (mysql_errno ())
			$this->errores ($this->consulta);	/* nuevo */
		return $res_id;
	}


	/*
	 * Documenta gilipichi 
	 */
	function data_seek ($id = "", $pos = 0) {
//debug("data_seek de $id - ".$this->res_id[$id]);
		if (!isset ($id) or empty ($id))
			$id = $this->res_point;
		if (!$this->res_id[$id])
			return 0;
		if (!@mysql_data_seek ($this->res_id[$id], $pos)) {
			// debug("wolDB->data_seek(".$this->res_id[$id]."):".mysql_errno()." : ".mysql_error());
			return 0;
		} else
			return 1;
		// return mysql_data_seek($this->res_id[$id],$pos);
	}

	/*
	 * libera ($id) : Esta funcion es la encargada de liberarnos el resultado que deseemos. 
	 */
	function libera ($id = -1) {
		if (empty ($id) OR $id == -1)
			$id = $this->res_point;
//debug("liberando... ($id) (".$this->res_id[$id].")");
		@mysql_free_result ($this->res_id[$id]);
//debug("liberado ($id)");

												/** Acuerdate de añadir soporte aki para poder liberar resultados
				intermedios, es decir, que el puntero de resultados no tenga pork
				ser el ultimo necesariamente **/
		$nResSize = sizeof ($this->res_id);
		unset ($this->res_id[$id]);
		$this->res_id[$id] = NULL;
		if ($this->res_point == $nResSize)
			$this->res_point--;
	}

	/*
	 * conectado($SQL) : Esta funcion nos devuelve TRUE caso de existir un socket abierto o FALSE caso contrario 
	 */
	function conectado ($SQL = NULL) {
		if (!$SQL)
			$SQL = $this->SQL_point;
		// if (mysql_ping($this->SQL[$SQL]))
		// debug("conectado el $SQL ? => ".$this->SQL[$SQL]);
		if (!empty ($this->SQL[$SQL]))
			return true;
		else
			return false;
	}


	/*
	 * desconecta ($SQL) : Esta funcion nos desconecta una conexion del servidor SQL 
	 */
	function desconecta ($SQL = -1) {
		if (!isset ($SQL) OR $SQL == -1)
			$SQL = $this->SQL_point = (((int) $this->SQL_point) ? $this->SQL_point : 1);
		if ((int) $SQL == $this->SQL_point)
			$this->SQL_point--;
//debug("Cerrando socket $SQL(".$this->SQL[$SQL].") que esta ".$this->conectado());
		if (!empty ($this->SQL[$SQL]) AND $this->conectado ($this->SQL[$SQL]))
			@mysql_close ($this->SQL[$SQL]);
		$this->SQL[$SQL] = NULL;
		unset ($this->SQL[$SQL]);
	}

	/*
	 * Preparar el objeto para ser guardado 
	 */
	function cerrar () {
		// Pierde la conexion cuando restablece una instancia almacenada
		// distinta de data o conf: if (!$this->_bAlive) return 1;
		$this->desconecta ();
		$this->SQL = array ();
		$this->SQL_point = 0;
		$this->res_id = array ();
		$this->aAnalizadas = array ();
		$this->aEncontradas = array ();
		$this->aLocalizadas = array ();
		$this->aDestinos = array ();
		$this->partes_wer = array ();
		$this->_bAlive = FALSE;
		return 1;
	}

	/*
	 * Funcion que busca un elemento en un array y devuelve la posicion del elemento 
	 */
	function esta_en ($tabla, $elem, &$posicion) {
		$max = count ($tabla);	  // Numero de posiciones de la tabla
		$encontrado = 0;			  // Encontrado a falso
		$i = 0;						  // Primera posicion donde buscar
		// echo "elemento :".$elem."<br>";
		while (($i < $max) && (!($encontrado))) {
			if ($tabla[$i] == $elem) {
				$encontrado = 1;
				$posicion = $i;
			}
			$i++;
		}
		// echo "encontrado:".$encontrado."<br>";
		return $encontrado;
	}


	function buscar (&$tab_dest, &$longi) {

//echo "long: ".$longi."-- Tab:".$tab_dest."<br>";
		$cons = "select * from Relaciones where tabla_origen='".$tab_dest."'"." order by id_relacion";
//echo $cons."<br>";
		$rs = $this->query ($cons);

		/*
		 * Tite: k pasa si nuestro destino ya ha sido analizado (bucle infinito?) 
		 */
		if (!esta_en ($this->aAnalizadas, $tab_dest)) {
			if ($this->debug)
				debug ("<B>$tab_dest</B> va a Ser analizada");
			$p = count ($this->aAnalizadas);
			$this->aAnalizadas[$p] = $tab_dest;
		} else {
			if ($this->debug)
				debug ("$tab_dest? ya hemos pasao por esta. Arrevolvemos 0");
			return 0;
		}

//echo "Tiene ".$this->num_rows($rs)." tablas Destino<br>";

/*
if ($this->num_rows($rs)) {
        while ($aTmp=$this->fetch_array($rs)) {
                salida($aTmp[tabla_destino]."<BR>\n");
        }
        $this->data_seek($rs,0);
}*/

		if ($this->num_rows ($rs) == 0)
			return 0;

		while ($row = $this->fetch_array ($rs)) {

			// echo "tab_orig".$row["tabla_origen"]."<br>";
			// echo "tab_dest:::".$row["tabla_destino"]."<br><br>";

			/*
			 * Al final se ha decidido que no se van a dar bucles luego esto sobra 
			 */
			// if ($this->esta_en($this->aAnalizadas,$row["tabla_destino"],$posic))
			// continue;
			if (esta_en ($this->aAnalizadas, $row[tabla_destino])) {
				// debug($row["tabla_destino"]." ya habia sido analizada.");
				continue;
			}

			/*
			 * Aqui si destino es de los destinos a llegar pone retval a 1 
			 */
			// echo "Ha devuelto false ".$row["tabla_destino"]."<br><br>";
			// echo "tab-- ".$row["tabla_destino"]."<br>";

			if ($this->esta_en ($this->aDestinos, $row["tabla_destino"], $posic)) {

				$this->aDestinos[$posic] = "vacio";
				// echo "longitud: ".$longi."-- ".$row["tabla_destino"]."<br>";
				$longi = 0;
				$p = count ($this->partes_wer);

				// echo $p."<br>";
				$this->partes_wer[$p] = $row["tabla_origen"].".".$row["campo_origen"];
				$this->partes_wer[$p] .= " = ".$row["tabla_destino"].".".$row["campo_destino"];

				$p = count ($this->aEncontradas);

				// echo "meto tabla ".$row["tabla_destino"]."en posicion ".$p."<br>";

				$this->aEncontradas[$p] = $row["tabla_destino"];
				$vRetval = 1;
			}
		}								  // Fin del while

		$this->data_seek ($rs);

		while ($row = $this->fetch_array ($rs)) {

			// echo "tab_orig".$row["tabla_origen"]."<br>";
			// echo "tab_dest:::".$row["tabla_destino"]."<br><br>";

			/*
			 * Al final se ha decidido que no se van a dar bucles luego esto sobra 
			 */
			// if ($this->esta_en($this->aAnalizadas,$row["tabla_destino"],$posic))
			// continue;

			$longi++;
			if ($this->buscar ($row["tabla_destino"], $longi)) {

				/*
				 * Aqui amplia were por cuyons y además debe comprobar si algun intermedio es otro de 
				 */
				/*
				 * los destinos 
				 */
				/*
				 * Tite: Defineme intermedio 
				 */
				// salida("this->buscar = 1<BR>\n");
				// echo "tabla_de: ".$row["tabla_destino"]." y origen ".$row["tabla_origen"]."<br>";

				$p = count ($this->partes_wer);
				// echo $p."<br>";
				$this->partes_wer[$p] = $row["tabla_origen"].".".$row["campo_origen"];
				$this->partes_wer[$p] .= " = ".$row["tabla_destino"].".".$row["campo_destino"];
				$p = count ($this->aEncontradas);
				// echo "meto tablita aEncontradas ".$row["tabla_destino"].
				// " en posicion ".$p."<br>\n";
				$this->aEncontradas[$p] = $row["tabla_destino"];

				if ($this->esta_en ($this->aDestinos, $row["tabla_destino"], $posic)) {
					// salida("long: ".$longi." -estaendest- ".$row["tabla_destino"]."<br>");
					$this->aDestinos[$posic] = "vacio";
				}
				$vRetval = 1;

			}							  // Fin del primer if
		}								  // Fin del while


		return $vRetval;
	}

/** Aplicaremos el algoritmo de Dijstra para conseguir los caminos mininos entre la tabla y los destinos
*	 Pasaremos al explicar el algoritmo, que es un poquillo complicado.
*	 Pseudocodigo :
*	 Dijstra(G(N,N)) : array [2..N] de distancias
*	 C <- [2..N]
*	 for i<-2 to N do D[i]<-G[1,i] // Inicializamos las distancias minimas
*	 repeat (N-2)
*					v <- min(D) //Distancia minima que este en C
*					C <- C\{v} // Quitamos el elemento del conjunto
*					foreach (C as W) do
*							if (D[W] > (D(v) + L[v,W]) {
*										D[W] <- D[v] + L[v,W]
*										P[W] <- P[W] . v
*							}
*					end-repeat
*	 fin alg.
*	 N: Numero de tablas (distintas) existentes en la Tabla relaciones
*	 P[i]: Where necesaria para llegar a esta tabla.
*	 Q[i]: Matriz de tablas recorridas (con valor bool) indexadas por destino
*	 C: Conjunto de tablas que nos queden por visitar
*	 D[i]: Array de distancias desde la tabla origen
*	 Problemas :
*	 - Construir la matriz que represente las relaciones entre tablas. :-)
*	 - Llevar dos arrays de indices: Uno de tablas de destinos y otro de tablas de origen. :-)
*	 - Conseguir los campos de origen y destino que relacionan dos tablas.
*  Debug de Estos metodos = 5;
**/

/** ruta ($tb_orig,$tb_dest,$val_clave,$ruta_path,$not_ruta_path):
*      Esta funcion recibe como parametros la tabla inicio y las tablas destino
*      y nos devuelve en un array de 3 posiciones los valores que han de tomar
*      en la consulta los apartados FROM (posicion 0) y WHERE (posicion 1). Si
*      se indica el campo $val_clave (clave primaria de la tabla origen), nos
*      metera esta condicion en la WHERE. La 3a posicion de nuestro array es
*      un array unidimensional con el nombre de todas las tablas de nuestro
*      FROM.
*      El cuarto parametro $ruta_path nos indica las tablas intermedias que queremos incluir en
*			 nuestra busqueda.
*      El quinto parametro $not_ruta_path nos indica las tablas intermedias por las que no queremos pasar.
*/

	function ruta ($tabla = "", $aDestinos = "", $valclave = NULL, $ruta_path = NULL, $not_ruta_path = NULL, $bStraightJoin = false ) {
		static $C;
		static $D;
		static $Q;
		static $F;

		// Variables para cachear el resultado 
		static $last_table;
		static $last_aDest;
		static $last_ruta;
		static $last_result;

		if (!isset($bStraightJoin)) $bStraightJoin = false;
		define ('MAX', 3000);	  // Definimos una constante ficticia que representa un valor infinito

		/** **
		debug("Datos de cache:");
		debug ("Tabla de origen $last_table");
		debug("Array de destinos:");
		print_r($last_aDest);
		debug("Ultima ruta");
		print_r($ruta);
		debug("Ultimo resultado");
		print_r($last_result);
		/** **/

		// print_r($aDestinos);
		// Fitramos los elementos del array de destino,para que no haya repeticiones
		$atmp[] = $tabla;
		if (!is_array ($aDestinos))
			$aDestinos[] = ((!empty ($aDestinos)) ? $aDestinos : $tabla);
		elseif (sizeof ($aDestinos) > 1) $aDestinos = array_diff (array_unique ($aDestinos), $atmp);
		 /* *
		 debug("Datos de <b>entrada</b>"); 
		 debug("Tabla de origen = $tabla"); 
		 debug("Clave = $valclave"); 
		 debug("Array de destinos"); 
		 print_r($aDestinos); 
		 debug("<br>Array de ruta_path"); 
		 print_r($ruta_path); 
		 debug("<br>Array de not_ruta_path");
		 print_r($not_ruta_path); 
		 /* */


		/*
		 * Si la peticion nueva coincide con la ultima realizada, devovelmos los datos almacenados en la cache,concatenando el
		 * valor de la clave, si lo hubiese
		 */
		if (!strcmp ($tabla, $last_table)
			 AND (is_array ($last_aDest)
					and (count (array_diff ($last_aDest, $aDestinos)) == 0)
					and (count (array_diff ($aDestinos, $last_aDest)) == 0))
			 AND (is_array ($last_ruta)
					and (count (array_diff ($last_ruta, $ruta_path)) == 0)
					and (count (array_diff ($ruta_path, $last_ruta)) == 0))
			) {
			if ($this->debug) debug("Utilizando cache de datos".count(array_diff($last_aDest,$aDestinos))); 
			$resultado = $last_result;
			if (isset ($valclave)) {	// Si nos dan un valor de clave lo concatenamos
				$aKeys = $this->obtener_clave($tabla);
				if (!is_array($valclave)) {
					if (!empty ($resultado[0])) $resultado[0] .= ' and ';
					$resultado[0] .= $tabla.'.'.array_shift($aKeys).'='.$valclave;
				} else {
					foreach ($valclave as $keyname => $keyval) {
						if (!is_numeric($keyname)) {
							if (strchr($keyname,'.')) {
								// debug("ENTRO : ".$keyname);
								$aTmp = split('\.',$keyname);
								$tmpk = array_pop($aTmp);
								// debug("fldname : $tmpk ");
							} else $tmpk = $keyname;
							foreach ($aKeys as $idx => $kn) 
								if (!strcasecmp($fldname,$kn)) {
									$tmpk = $kn;
									$aKeys[$idx] = NULL;
								}
						} else {
							foreach ($aKeys as $idx => $kn) 
								if (!empty($kn) AND is_numeric($idx)) {
									$tmpk = $idx;
									$aKeys[$idx] = NULL;
								}
						}
						$resultado[0] .= ((!empty($resultado[0])) ? ' and ' : '' ).$tabla.'.'.$tmpk.'='.$keyval;
					}
				}
			}
			return $resultado;
		}
		// Antes de nada... Si solo tenemos como destino la misma tabla origen,
		// para que hacer nada mas... o no?
		if ((sizeof ($aDestinos) == 1) and ! strcmp ($aDestinos[0], $tabla)) {
			// debug("El origen coincide con el destino");
			$resultado[0] = "";
			$resultado[1][0] = $tabla;
			$resultado['left_join_from'] = $tabla.' ';

			$last_result = $resultado;
			$last_table = $tabla;
			$last_ruta = $ruta_path;
			$last_aDest = $aDestinos;
			if (isset ($valclave)) {	// Si nos dan un valor de clave lo concatenamos
				$aKeys = $this->obtener_clave($tabla);
				if (!is_array($valclave)) {
					if (!empty ($resultado[0])) $resultado[0] .= ' and ';
					$resultado[0] .= $tabla.'.'.array_shift($aKeys).'='.$valclave;
				} else {
					foreach ($valclave as $keyname => $keyval) {
						if (!is_numeric($keyname)) {
							if (strchr($keyname,'.')) {
								$aTmp = split('\.',$keyname);
								$fldname = array_pop($aTmp);
							} else $fldname = $keyname;
							foreach ($aKeys as $idx => $kn) 
								if (!strcasecmp($fldname,$kn)) {
									$tmpk = $kn;
									$aKeys[$idx] = NULL;
								}
						} else {
							foreach ($aKeys as $idx => $kn) 
								if (!empty($kn) AND is_numeric($idx)) {
									$tmpk = $idx;
									$aKeys[$idx] = NULL;
								}
						}
						$resultado[0] .= ((!empty($resultado[0])) ? ' and ' : '' ).$tabla.'.'.$tmpk.'='.$keyval;
					}
				}
			}
			/*
			 * Cacheamos los datos para la siguiente vez 
			 */

			return $resultado;
		}


		$rel_aux = $this->relaciones;	// Copia de las relaciones

		// Quitamos peso (distancia 0 = DistIni - 1) A las tablas destino.
		// Metemos la tabla base como primero de los destinos para asignar pesos por arista de destinos.
		array_unshift ($aDestinos, $tabla);
		foreach ($aDestinos as $tb) {
			// Soporte de Aliasing con nombre de alias separado por : (solo cambia el nombre en los From y where)
			if (strstr($tb,':')) {
				$aTmp = split('\:',$tb);
				$t = $aTmp[0];
				$a = $aTmp[1];
			} else $t = $tb;
			foreach ($aDestinos as $destino) {
				if (is_numeric ($rel_aux[$t][$destino]))
					$rel_aux[$t][$destino] -= 1;
				// if (is_numeric($rel_aux[$destino][$t])) $rel_aux[$destino][$t] -= 1;
				if ($this->debug)
					debug ("Primando en UN(".$rel_aux[$t][$destino]."/".$rel_aux[$destino][$t].") peso $t - $destino");
			}
		}

		// Marcamos con una distacia muy pequeña las tablas por las que queremos pasar
		// if (!is_array($ruta_path) OR !sizeof($ruta_path)) $ruta_path = $aDestinos;
		if (is_array ($ruta_path) AND sizeof ($ruta_path))
			foreach ($ruta_path as $tb) {
				$c = NULL;
				if (strstr($tb,'.')) {
					$aTmp = split('\.',$tb);
					$t = $aTmp[0];
					$c = $aTmp[1];
					if ($this->debug) debug("_Incluyendo_ arista de $t con $c ");
				} else $t = $tb;
				foreach ($this->indicesDest as $destino) {
					if (!empty($c)) {
						// Si el destino no coincide con la arista pedida ... continuamos
						$bCont = true;
						for ($i=0; $i < sizeof($this->camposOrigen[$t][$destino]); $i=$i+2) {
							// Si la arista a forzar existe, seguimos
							if (!strcmp($this->camposOrigen[$t][$destino][$i],$c)) {
								$bCont = false;
								break;
							}
						}
						if ($bCont) continue;
					}
					if (is_numeric ($rel_aux[$t][$destino])) {
						$rel_aux[$t][$destino] -= 2;
						// $rel_aux[$t][$destino] = -1 * MAX;
					}
					if (is_numeric ($rel_aux[$destino][$t])) {
						$rel_aux[$destino][$t] -= 2;
						// $rel_aux[$destino][$t] = -1 * MAX;
					}
					if ($this->debug AND (is_numeric ($rel_aux[$t][$destino]) OR is_numeric ($rel_aux[$destino][$t])))
						debug ("Forzando Ruta $t - $destino (".$rel_aux[$t][$destino]."/".$rel_aux[$destino][$t].")");
				}
			}
		// Marcamos con una distacia muy grande las tablas por las que no queremos pasar
		if (is_array ($not_ruta_path) AND sizeof ($not_ruta_path))
			foreach ($not_ruta_path as $tb) {
				$c = NULL;
				if (strstr($tb,'.')) {
					$aTmp = split('\.',$tb);
					$t = $aTmp[0];
					$c = $aTmp[1];
					if ($this->debug) 
						debug("Excluyendo arista de $t con $c ");
				} else {
					$t = $tb;
				}
				foreach ($this->indicesDest as $destino) {
					if (!empty($c)) {
						// Si el destino no coincide con la arista rechazada... continuamos
						$bCont = true;
						for ($i=0; $i < sizeof($this->camposOrigen[$t][$destino]); $i=$i+2) {
							// SI la arista a excluir existe, seguimos
							if (!strcmp($this->camposOrigen[$t][$destino][$i],$c)) {
								$bCont = false;
								break;
							}
						}
						if ($bCont) continue;
					}
					if (is_numeric ($rel_aux[$t][$destino])) {
						$rel_aux[$t][$destino] = (MAX-1) ;
					}
					if (is_numeric ($rel_aux[$destino][$t])) {
						$rel_aux[$destino][$t] = (MAX-1) ;
					}
				}
			}
		// Quitamos la tabla base de la tabla de destinos.
		array_shift ($aDestinos);

		if ($this->debug) {
			foreach ($rel_aux as $origen => $aDest) {
				foreach ($aDest as $d => $v) if ($v != 1) debug("De $origen a $d : $v");
				// print_r($aDest);
			}
		}

		// Conseguimos el maximo entre las tablas de destino y las tablas de origen
		$N = max (sizeof ($this->indicesOrigen), sizeof ($this->indicesDest));
		// debug("ruta()->Origenes :");
		// print_r($this->indicesOrigen);
		// debug("ruta()->Destinos :");
		// print_r($this->indicesDest);
		$veces = $N - 2;		  // Numero de veces que se va a repetir el bucle ****
		// debug("debug = ".$this->debug);
		// if ($this->debug==5) debug("Tamanyo $N");
		// debug ("<b>Tabla de origen = $tabla </b>");
		// Variables para minima distancia
		$C = array ();			  // Conjunto que representa los destinos que no hemos visitado
		$D = array ();			  // Array de distancias minimas desde la tabla origen a todos los destinos

		// Fixme: Una vez testado todo, hay que _eliminar_ el array $P, dado que la composicion de la query, se hace usando $Q (distancias minimas a destino, con recorrido). 
		$Q = array ();			  // Array que nos lleva el trayecto/aristas de las tablas recorridas hasta un destino (Partes where)

		$F = array ();			  // Array para llevar las tablas(solo nombre) por las que paso (Partes from)

		// Inicializamos el conjunto de destinos, las distancias minimas y el camino recorrido
		foreach ($this->indicesDest as $destino) {
			//debug ("Tabla de destino = $destino");
			$F[$destino] = array ();
			$C[$destino] = 1;	  // El 1 representa la inclusion en el conjunto
			if (isset ($rel_aux[$tabla][$destino]) AND is_numeric ($rel_aux[$tabla][$destino])) {	// Si existe arista entre
																																// origen
				// y destino ...
				// Inicializamos al valor de la arista (/* TODAS = 1 */)
				$D[$destino] = (int) $rel_aux[$tabla][$destino];

				$Q[$destino][$tabla][$destino] = 1;

			} else {
				$D[$destino] = MAX;	// Si no, ponemos un valor artificial (infinito) ...
			}
		}

		$C[$tabla] = 0;		  // Quitamos del conjunto la tabla de origen
		do {						  // Bucle *****
			$minimo = MAX;		  // Minimo = infinito
			// Seleccionamos la distancia minima desde la tabla origen a cualquier tabla
			foreach ($this->indicesDest as $destino) {
				if ($C[$destino]
					 and ($D[$destino] < $minimo)) {
					$v = $destino;	// Mejor hijo posible
					$minimo = $D[$destino];
				}
			}
			$aEntidadesMultiples = array();
			$C[$v] = 0;			  // Eliminamos el destino del conjunto de no visitados (e.d. 'visitamos esta tabla')
			foreach ($this->indicesDest as $W) {	// Para cada Tabla que sea destino

				if ($C[$W]) {
					if ($this->debug > 1)
						debug ("($W)en el conjunto C a($D[$W]) cuando hasta($v) llevamos($D[$v]) y esta arista pesa(".
								 $rel_aux[$v][$W].") ");
					// Si el destino esta por visitar
					// Si no hay relacion entre la tabla minima y la seleccionada
					if (!is_numeric ($rel_aux[$v][$W]))
						continue;
					// $rel_aux[$v][$W] = MAX;
					// if (is_numeric($rel_aux[$v][$W]) AND ($rel_aux[$v][$W] <= (-1 * MAX)) ) $rel_aux[$v][$W] = 1;

					if ($this->debug)
						debug ("Dst: $W($D[$W]) desde $v($D[$v]) Arista($v -> $W) ==(".$rel_aux[$v][$W].")");
					// Si la distancia a W es mayor que la distancia a v mas la distancia de la arista...
					if ($D[$W] > ($D[$v] + $rel_aux[$v][$W])
						 // OR ( ($D[$W] == ($D[$v] + $rel_aux[$v][$W])) AND ($D[$W] == MAX OR in_array($W,$aDestinos)) )
						) {

						// $query = trim ($this->camposOrigen[$v][$W]);
						// if (empty($query)) continue;
						//debug ("Cambiamos distancia a <b>$W</b> porque su distancia $D[$W] es mayor que <b>de $v($D[$v]) a $W(".$rel_aux[$v][$W].") </b>: ");

						if (is_numeric ($rel_aux[$v][$W]) AND ($rel_aux[$v][$W] <= (-1 * MAX)))
							$rel_aux[$v][$W] = 0;
						// $D[$W] = $D[$v] + $rel_aux[$v][$W];
						$D[$W] = $D[$v] + $rel_aux[$v][$W];

						if ($this->debug > 1)
							debug ("Compongo la query <b>de $v a $W</b> que esta a $D[$W] saltos de $tabla : ");

						$Q[$W] = $Q[$v];

						/**
						// Si $W tiene una clave primaria multiple, hay que incluir las trayectorias derivadas del resto de sus aritas primarias.
						**/
						$aKeys = $this->obtener_clave($W);
						if (sizeof($aKeys)>1) array_push($aEntidadesMultiples,$W);

						$Q[$W][$v][$W] = 1;

						$F[$W] = $F[$v];
						$tam = sizeof ($F[$W]);

						//debug ("Inserto en la posicion $tam la tabla $v en las from de $W");
						$F[$W][$tam] = $v;	// Incluimos esta tabla al final en las from de la tabla
					} else {
						if ($this->debug > 1 AND in_array ($W, $aDestinos))
							debug ("$W ya no esta en el Conjunto : distancia($D[$W])");
					}
					//debug("Distancia total de $tabla hasta $W es : $D[$W]");
				}
			}	// fin del foreach 
			//debug("Distancia total de $tabla hasta $W es : $D[$W]");
		} while ($veces--);	  // Repetimos el proceso

		// Ponemos aqui (fuera del algoritmo dijistra) el manejo de entidades de arista multiple, dado que interesa anyadir unas rutas, para el resto de aristas
		//   necesarias para el transito sobre entidad de multiple arista, siendo estas las mas optimas.
		foreach ($aEntidadesMultiples as $W) {
			foreach ($this->camposOrigen[$W] as $otrodestino => $aAristas) {
				if (!strcmp($otrodestino,$v)) {
					// debug("ya estamos en $otrodestino, pasando");
					continue;
				} else {
					/**
					  * Pasar tambien por $otrodestino , _SI_ es arista de clave primaria!
					  * Dado que caso de ser tabla de transito, solo nos interesan las claves primarias (?) y de si es destino,
					  * ya se analizaran el resto de relaciones.
					  **/
					$aKeys = $this->obtener_clave($W);
					if (in_array($aAristas[0],$aKeys)) {
						if ($this->debug AND in_array($W,$aDestinos) ) {
							debug("entidad con clave multiple $W, _ademas_ de por la arista con $v,  pasar tambien por $otrodestino ");
							debug($aAristas[0]." parece estar en : ");
							print_r($aKeys);
						}

						if (is_array($Q[$otrodestino]) AND sizeof($Q[$otrodestino]))
							foreach ($Q[$otrodestino] as $tmptb => $aTmp) {
								if ($this->debug AND in_array($W,$aDestinos) ) {
									debug("desde $tmptb saltar a : ");
									print_r($aTmp);
								}
								$Q[$W][$tmptb] = $aTmp;
							}
					}
				}
			}
		}

		// Sacamos los Alias que tienen los destinos
		$aAliasList = array(); // Soporte de Alias
		$aTransitList = array(); // Lista de elementos de travesia
		$aTbVisited = array(); // Muesca a las ya incluidas/visitadas 
		// Cerramos todas las querys
		foreach ($aDestinos as $tb) {
			$aliasdestino = NULL;
			// Soporte de Aliasing con nombre de alias separado por : (solo cambia el nombre en los From y where)
			if (strstr($tb,':')) {
				$aTmp = split('\:',$tb);
				$destino = $aTmp[0];
				$a = $aTmp[1];
			} else $destino = $tb;
			$tam = sizeof ($F[$destino]);
			$F[$destino][$tam] = $destino;	// Incluimos el destino al final en las from de la tabla

			// Soporte de Aliasing:
			if (!empty($a) AND empty($aALiasList[$destino]) ) { 
				$aAliasList[$destino] = $a;
			}

			// Preparamos un listado de tablas de destino o de transito 
			if (is_array($Q[$destino]) AND sizeof($Q[$destino])) 
				foreach ($Q[$destino] as $aristai => $aDest) {
					if (!in_array($aristai,$aTransitList)) array_push($aTransitList,$aristai);
					foreach ($aDest as $aristaf => $bool)
						if (!in_array($aristaf,$aTransitList)) array_push($aTransitList,$aristaf);
				}
		}

		// Preparamos el resultado para devolverlo
		$resultado = array ();
		$res = array ();
		$aAristas = array ();

		$join_from = $tabla.' '.( (!empty($aAliasList[$tabla])) ? $aAliasList[$tabla] : '' );

		foreach ($aDestinos as $tb) {
			// Soporte de Aliasing con nombre de alias separado por : (solo cambia el nombre en los From y where)
			if (strstr($tb,':')) {
				$aTmp = split('\:',$tb);
				$dest = $aTmp[0];
			} else $dest = $tb;

			// Si hay una ruta minima, la devolvemos
			if ($D[$dest] < MAX) {
				/** 
				  * Dado que todas las distancias entre aristas son iguales (en el caso que nos ocupa), no nos hace falta comprobar la
				  * 	distancia contenida en $Q[destino_X_para_este_origen][destino_intermedio] , dado que sabemos que sera un destino de paso,
				  *	y el valor es irrelevante, el grupo completo compone la distancia minima. Y el orden representado, en este caso, nos es indistinto
				  * 	$Q[mi_destino][origen_intermedio][destino_intermedio]
				  **/

				if ($this->debug) {
					debug("<hr/>$dest"); 
				}

				$bAny = false; // Existe alguna relacion
				$tmp_join = '';
				if (is_array ($Q[$dest])) {
					foreach ($Q[$dest] as $orig => $aDest) {
						if ($this->debug) {
							$strd='';
							foreach($aDest as $tmpt => $tmpb) $strd .= $tmpt.'('.$tmpb.') ';
							reset($aDest);
							debug("Para el objetivo $dest saltar desde $orig  hay que visitar $strd");
						}
						foreach ($aDest as $das => $bool) {
							if ($this->debug) debug("vistiando  $das .. ");
							if (!is_array($aAristas[$orig])) $aAristas[$orig] = array();

							if ((int) $bool AND sizeof($this->camposOrigen[$orig][$das]) AND !in_array($das, $aAristas[$orig])) {

								if (!in_array($das,$aDestinos)) {
									if ($this->debug) debug("_NO_ incluido en destino, vease, transito");
									if (!is_array($resultado[1])) $resultado[1] = array();

									if (!in_array($das,$resultado[1])) array_push($resultado[1],$das);
								}

								$aMClavesAristas = array();

								$link = $orig.'.'.$this->camposOrigen[$orig][$das][0].'='.$das.'.'.$this->camposOrigen[$orig][$das][1];
								$res[0] .= ((!empty ($res[0])) ? ' AND ' : '').$link;
								array_push($aMClavesAristas,$this->camposOrigen[$orig][$das][1]);
								if ($this->debug) {
									debug("Link str: $link");
								}

								array_push ($aAristas[$orig], $das);

								$tmp_join .= ((!$bStraightJoin) ? ' LEFT' : '').' JOIN '.$das.' '.( (!empty($aAliasList[$das])) ? $aAliasList[$das] : '' ).' ON (';

								// Engance de aristas de las 2 tablas
								$tmp_join .= ( (!empty($aAliasList[$orig])) ? $aAliasList[$orig] : $orig).'.'.$this->camposOrigen[$orig][$das][0].
									'='. ( (!empty($aAliasList[$das])) ? $aAliasList[$das] : $das).'.'.$this->camposOrigen[$orig][$das][1];

								// Comprobando si otra arista de esta misma tabla se engancha alguna tabla visitada, para hacer otro enlace.
								$aKeys = $this->obtener_clave($das);
								if ($this->debug) {
									debug("Claves de $das: ");
									print_r($aKeys);
								}

								// Tendra prioridad cualquier otra arista con $dest desde $orig
								if (sizeof($this->camposOrigen[$orig][$das]) > 2 ) {
									if ($this->debug) {
										debug("Tendra prioridad cualquier otra arista con $dest desde $orig ");
										print_r($this->camposOrigen[$orig][$das]);
									}
									$aTmpK = $this->camposOrigen[$orig][$das];
									for ($i=0; $i < sizeof($aTmpK); $i=$i+2) {
										// Quitamos el primer juego de claves, que ya estan puestas
										if ($i==0) continue;

										if (in_array($aTmpK[$i+1],$aKeys)) {
											// Si la clave en destino, es primaria, la incluimos sin dudar
											debug($aTmpK[$i+1]." _es_ clave primaria en destino");
											$tmp_join .= ' AND '.( (!empty($aAliasList[$orig])) ? $aAliasList[$orig] : $orig).'.'.$this->camposOrigen[$orig][$das][$i].
													'='. ( (!empty($aAliasList[$das])) ? $aAliasList[$das] : $das).'.'.$this->camposOrigen[$orig][$das][$i+1];

											$res[0] .= ((!empty ($res[0])) ? ' AND ' : '').
															( (!empty($aAliasList[$orig])) ? $aAliasList[$orig] : $orig).'.'.$this->camposOrigen[$orig][$das][$i].
															'='. ( (!empty($aAliasList[$das])) ? $aAliasList[$das] : $das).'.'.$this->camposOrigen[$orig][$das][$i+1];
											array_push($aMClavesAristas,$aTmpK[$i+1]);
										} else {
											// la clave de $orig a $das _no_ es primaria en $das, puede ser una relacion auxiliar para algo.
											// De momento, solo incluimos esta arista si _esta_ premiada (hay que ver que se hace en otros casos)
											debug("La clave de $orig a $das _no_ es primaria en $das => excluida esta arista ");
										}
									}
								}
										
								if (sizeof($aKeys)>1 AND is_array($this->camposOrigen[$das]) AND sizeof($this->camposOrigen[$das]))  {
									// Otras relaciones existentes para nuestro destino (con clave multiple) solicitado
									if ($this->debug) {
										debug("Otras relaciones existentes para nuestro destino -de clave multiple- solicitado ".$das);
										print_r(array_keys($this->camposOrigen[$das]));
										debug("Con las siguientes claves primarias ");
										print_r($aKeys);
									}

									foreach ($this->camposOrigen[$das] as $tb2 => $aClaves) {
										// Si la tabla destino de esta arista, es alguna de las que esta en juego ahora, ya la hemos incluido.
										if (!strcmp($tb2,$orig) OR !strcmp($tb2,$das)) {
											continue;
										}
										/** 
											_NO_ hace falta comprobar si se va a incluir en la query la relacion entre $tb y $dest 
											dato que el numero de claves se comprobo cuando se construyo las trayectorias en $Q, donde si habia clave 
											multiple, se anyadio a la trayectoria para llegar a esta tabla, la trayectoria del resto de aristas que son clave 
											PeRo, si excluimos las claves que no sean primarias (al igual, y dado que, que en la composicion de la ruta se excluyen esas entidades)

											FixMe - Hay casos en los que el left join, con claves multiples no funciona bien. Estos casos tienen el inconveniente
											de que se repiten claves (asociacion de foraneas), esto suecede por ej al pasar por Facturas a Facturas_agentes, que 
											inserta las 2 claves de Facturas_agentes, y cuando pasa por Agentes, vuelve a meter la clave Facturas_agentes->Agentes que ya habia
											metido antes. Lo que hay que hacer, es dejarlo para el final con un ', Agentes'
										**/
										for ($i=0; $i < sizeof($aClaves); $i=$i+2) {
											/** **
												TransitList es la lista de travesia. destinos y transitos todos juntos.
												Fix MySQL 5.0 ; sustituida la tabla aTransitList por aTBVisited . El motor SQL no soporta
													incluir una arista contra una tabla todavia no incluida en el from. Ojito con el ordenamiento
													de las tablas a incluir entonces.
											/** **/
											$bTbVisited = false;
											if (is_array($aTbVisited) and sizeof($aTbVisited))
												foreach ($aTbVisited as $tbv) {
													// if ($this->debug) debug("$das::>$tb2 tbVisited $tbv or ".substr($tbv,0,strlen($tb2)));
													if ( substr($tbv,0,strlen($tb2))==$tb2 ) {
														$bTbVisited=true;
														break;
													}
												}
											if ($this->debug) {
												debug("$das::-visible-> a $tb2 (Vista? ".(int)$bTbVisited." ) con clave arista ".$aClaves[$i]);
											}
											// if (in_array($aClaves[$i],$aKeys) AND in_array($tb2,$aTbVisited) AND !in_array($aClaves[$i],$aMClavesAristas)  ) 
											if (in_array($aClaves[$i],$aKeys) AND $bTbVisited AND !in_array($aClaves[$i],$aMClavesAristas)  ) {
												$tmp_join .= ' AND '.( (!empty($aAliasList[$das])) ? $aAliasList[$das] : $das).'.'.$this->camposOrigen[$das][$tb2][$i].
														'='. ( (!empty($aAliasList[$tb2])) ? $aAliasList[$tb2] : $tb2).'.'.$this->camposOrigen[$das][$tb2][$i+1];

												$res[0] .= ((!empty ($res[0])) ? ' AND ' : '').
																( (!empty($aAliasList[$das])) ? $aAliasList[$das] : $das).'.'.$this->camposOrigen[$das][$tb2][$i].
																'='. ( (!empty($aAliasList[$tb2])) ? $aAliasList[$tb2] : $tb2).'.'.$this->camposOrigen[$das][$tb2][$i+1];
												array_push($aMClavesAristas,$aClaves[$i]);
												if ($this->debug) debug("Nueva union entre $das y $tb2 . Where: ".$res[0]);
												// debug("Nuevo res de $das : ".$res[0]);
												// print_r($this->camposOrigen[$das]);
											}
										}
									}
								}

								$tmp_join .= ') ';
								if ($this->debug) {
									debug($tmp_join);
								}
								$bAny = TRUE;
								array_push($aTbVisited,$tb);
							} else {
								if ($this->debug) debug("Ya esta o no existe ");
							}
							// debug("NEW $orig con $das ($bool): ".$this->camposOrigen[$orig][$das]);
						}
					}
				}

				if ($this->debug) {
					debug("<hr>");
				}

				if ($bAny) $join_from .= $tmp_join;

				// $resultado[1] = array_concat($resultado[1],$F[$dest]); // Partes from
				// $resultado[1] = array_merge($resultado[1],$F[$dest]);
				if (!is_array ($resultado[1]))
					$resultado[1] = $F[$dest];
				else
					$resultado[1] = array_merge ($resultado[1], $F[$dest]);	// Partes from
			}
		}
		// debug("Q -res- : ".$res[0]);
		// debug("Q -res:left join from- : ".$join_from);
		$resultado[0] = $res[0];

		// debug("OQ: ".$resultado[0]);
// debug ("La distancia desde $tabla hasta  $dest es $dist");
//foreach ($F[$dest] as $campo) debug ("La from de $dest es  $campo");
		$resultado[1][] = $tabla;	// Añadimos a los from del resultado la tabla inicial
		// debug("Filtramos la from del resultado ");
		// depurar_array($resultado[1]);
		$resultado[1] = array_unique ($resultado[1]);
		$resultado['left_join_from'] = $join_from;
		$resultado['join_from'] = $join_from;
		// debug("Depuramos las from que vamos a devolver");
		// print_r($resultado);
		// depurar_array($resultado[1]);
		/*
		 * Cacheamos los datos para la siguiente vez 
		 */
		// debug("Cacheamos los datos de entrada");
		$last_result = $resultado;
		$last_table = $tabla;
		$last_ruta = $ruta_path;
		$last_aDest = $aDestinos;

		if (isset ($valclave) && !empty ($valclave)) {	// Si nos dan un valor de clave lo concatenamos a las partes where del
																		// resultado
			// aKeys puede ser un vector.
			$aKeys = $this->obtener_clave($tabla);
			if (!is_array($valclave)) {
				if (!empty ($resultado[0])) $resultado[0] .= ' and ';
				$resultado[0] .= $tabla.'.'.array_shift($aKeys).'='.$valclave;
			} else {
				// Soporte de claves multiples:
				foreach ($valclave as $keyname => $keyval) {
					if (!is_numeric($keyname)) {
						if (strchr($keyname,'.')) {
							$aTmp = split('\.',$keyname);
							$fldname = array_pop($aTmp);
						} else $fldname = $keyname;
						foreach ($aKeys as $idx => $kn) 
							if (!strcasecmp($fldname,$kn)) {
								$tmpk = $kn;
								$aKeys[$idx] = NULL;
							}
					} else {
						foreach ($aKeys as $idx => $kn) 
							if (!empty($kn) AND is_numeric($idx)) {
								$tmpk = $idx;
								$aKeys[$idx] = NULL;
							}
					}

					$resultado[0] .= ((!empty($resultado[0])) ? ' and ' : '' ).$tabla.'.'.$tmpk.'='.$keyval;
				}
			}
		}
		/*
		 * * debug("Depurando <b>distancias</b>"); depurar_array($D); debug("Y vamos a retornar...."); debug("En el FROM:");
		 * depurar_array($resultado[1]); /* 
		 */

		return $resultado;
	}  // Fin de funcion

	function rutaprobe ($tabla = NULL, $aDestinos = NULL, $valclave = NULL, $ruta_path = NULL, $not_ruta_path = NULL) {
		return $this->ruta($tabla,$aDestinos,$valclave,$ruta_path,$not_ruta_path);
	}

}	 // Fin de la clase

function db_aliaslist_has_tbname($itm,$key,$tb) {
	if ( substr($itm,0,strlen($tb))==$tb ) return true;
	else return false;
}

?>
