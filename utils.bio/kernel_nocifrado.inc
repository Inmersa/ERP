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

//debug("constructor wol_db");
		$this->debug = 0;
		if (empty ($login) OR empty ($passwd) OR empty ($cfgServer) OR empty ($dbase)) {
			global $login;
			global $passwd;
			global $cfgServer;
			global $dbase;
			global $port;
			if ($this->debug)
				debug ("Recogiendo datos de conexion de config.php");
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
		if (!$this->conectado()) return false;

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
		$tmp_id = $this->list_fields ($tabla);
		if (!$tmp_id) {
			$this->libera ($tmp_id);
			return NULL;
		}
// debug("query realizada....");
		$num_flds = $this->num_fields ($tmp_id);
		$aKeys = NULL;
		for ($i = 0; $i < $num_flds; $i++) {
			// debug("nombre = ".$this->field_name($tmp_id,$i));
			// debug("flags = ".$this->field_flags($tmp_id,$i));
			// $oFields[$this->field_name($tmp_id,$i)] = $oCampo;
			if (stristr ($this->field_flags ($tmp_id, $i), "primary_key"))
				$aKeys[] = $this->field_name ($tmp_id, $i);
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
			$msg = "(".mysql_error ($this->SQL[$this->SQL_point])." - ".mysql_error ($this->SQL[$this->SQL_point]).") ".$this->consulta;
		}
		elseif (mysql_errno ($this->SQL[$this->SQL_point])) {
			$msg = "(".mysql_errno ($this->SQL[$this->SQL_point])."-".mysql_error ($this->SQL[$this->SQL_point]).") $msg";
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

	function formatear_fecha ($fecha, $bTag = TRUE) {
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

		if (!$retfecha AND $this->debug)
			debug ("Formato de fecha($fecha) _no_ valido");
		if (empty ($retfecha))
			$retval = "NULL";
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

		/*
		 * Aqui se pueden desviar los logs de cada usuario a un fichero o consola *
		 * 
		 * if (!($fh = fopen($this->ruta_log,"a"))) { aviso("No se pudo crear el fichero de logs en $this->ruta_log"); }
		 * 
		 * $today = getdate(); $seconds = $today['seconds']; $min = $today['minutes']; $hours = $today['hours'];
		 * 
		 * $consulta2 = $hours . ":" . $min . ":" . $seconds . " " . $this->SQL_point ." " . $consulta . "\n"; if
		 * (!fwrite($fh,$consulta2)) { aviso ("No se pudo escribir en el fichero de logs en $this->ruta_log"); } if (!fclose($fh))
		 * { aviso ("No se pudo cerrar el fichero de logs en $this->ruta_log"); } /* 
		 */

		if (!(int) $this->conectado ())
			$this->conecta (1);
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
		if (mysql_errno ())
			$this->errores ($consulta);
//debug("db.inc - query(".$this->res_point."-".$this->res_id[$this->res_point].")");
//debug("dbQuery = $consulta");

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
		if (!$this->conectado()) $this->conecta($this->SQL_point);
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
		$chk = $this->obtener_clave($tabla);
		if (empty($chk)) return NULL;

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

	function ruta ($tabla = "", $aDestinos = "", $valclave = NULL, $ruta_path = NULL, $not_ruta_path = NULL) {
		static $C;
		static $D;
		static $Q;
		static $F;

		// Variables para cachear el resultado 
		static $last_table;
		static $last_aDest;
		static $last_ruta;
		static $last_result;
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
			// debug("Utilizando cache de datos".count(array_diff($last_aDest,$aDestinos))); 
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
		$aTransitList = array(); 
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
							debug("Para el objetivo $dest saltar desde $orig .. ");
							print_r($aDest);
						}
						foreach ($aDest as $das => $bool) {
							if ($this->debug) debug(".. hasta  $das ");
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

								$tmp_join .= ' LEFT JOIN '.$das.' '.( (!empty($aAliasList[$das])) ? $aAliasList[$das] : '' ).' ON (';

								// Engance de aristas de las 2 tablas
								$tmp_join .= ( (!empty($aAliasList[$orig])) ? $aAliasList[$orig] : $orig).'.'.$this->camposOrigen[$orig][$das][0].
									'='. ( (!empty($aAliasList[$das])) ? $aAliasList[$das] : $das).'.'.$this->camposOrigen[$orig][$das][1];

								// Comprobando si por otra arista de esta misma tabla se engancha alguna tabla visitada, para hacer otro enlace.
								$aKeys = $this->obtener_clave($das);
								if ($this->debug) {
									debug("Claves de $das: ");
									print_r($aKeys);
								}

								// Tendra prioridad cualquier otra arista con $dest desde $orig
								if (sizeof($this->camposOrigen[$orig][$das]) > 2 ) {
									$aTmpK = $this->camposOrigen[$orig][$das];
									for ($i=0; $i < sizeof($aTmpK); $i=$i+2) {
										// Quitamos el primer juego de claves, que ya estan puestas
										if ($i==0) continue;

										if (in_array($aTmpK[$i+1],$aKeys)) {
											// Si la clave en destino, es primaria, la incluimos sin dudar
											// debug($aTmpK[$i+1]." _es_ clave primaria en destino");
											$tmp_join .= ' AND '.( (!empty($aAliasList[$orig])) ? $aAliasList[$orig] : $orig).'.'.$this->camposOrigen[$orig][$das][$i].
													'='. ( (!empty($aAliasList[$das])) ? $aAliasList[$das] : $das).'.'.$this->camposOrigen[$orig][$das][$i+1];

											$res[0] .= ((!empty ($res[0])) ? ' AND ' : '').
															( (!empty($aAliasList[$orig])) ? $aAliasList[$orig] : $orig).'.'.$this->camposOrigen[$orig][$das][$i].
															'='. ( (!empty($aAliasList[$das])) ? $aAliasList[$das] : $das).'.'.$this->camposOrigen[$orig][$das][$i+1];
											array_push($aMClavesAristas,$aTmpK[$i+1]);
										} else {
											// la clave de $orig a $das _no_ es primaria en $das, puede ser una relacion auxiliar para algo.
											// De momento, solo incluimos esta arista si _esta_ premiada (hay que ver que se hace en otros casos)
										}
									}
								}
										
								if (sizeof($aKeys)>1 AND is_array($this->camposOrigen[$das]) AND sizeof($this->camposOrigen[$das]))  {
									// Otras relaciones existentes para nuestro destino (con clave multiple) solicitado

									foreach ($this->camposOrigen[$das] as $tb => $aClaves) {
										// Si la tabla destino de esta arista, es alguna de las que esta en juego ahora, ya la hemos incluido.
										if (!strcmp($tb,$orig) OR !strcmp($tb,$das)) {
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
											if (in_array($aClaves[$i],$aKeys) AND in_array($tb,$aTransitList) AND !in_array($aClaves[$i],$aMClavesAristas)  ) {
												$tmp_join .= ' AND '.( (!empty($aAliasList[$tb])) ? $aAliasList[$tb] : $tb).'.'.$this->camposOrigen[$das][$tb][$i].
														'='. ( (!empty($aAliasList[$das])) ? $aAliasList[$das] : $das).'.'.$this->camposOrigen[$das][$tb][$i+1];

												$res[0] .= ((!empty ($res[0])) ? ' AND ' : '').
																( (!empty($aAliasList[$tb])) ? $aAliasList[$tb] : $tb).'.'.$this->camposOrigen[$das][$tb][$i].
																'='. ( (!empty($aAliasList[$das])) ? $aAliasList[$das] : $das).'.'.$this->camposOrigen[$das][$tb][$i+1];
											}
										}
									}
								}

								$tmp_join .= ') ';
								if ($this->debug) {
									debug($tmp_join);
								}
								$bAny = TRUE;
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
		$resultado[0] = $res[0];

		// debug("OQ: ".$resultado[0]);
// debug ("La distancia desde $tabla hasta  $dest es $dist");
//foreach ($F[$dest] as $campo) debug ("La from de $dest es  $campo");
		$resultado[1][] = $tabla;	// Añadimos a los from del resultado la tabla inicial
		// debug("Filtramos la from del resultado ");
		// depurar_array($resultado[1]);
		$resultado[1] = array_unique ($resultado[1]);
		$resultado['left_join_from'] = $join_from;
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

  
     

/*****************************************************************
** Aplicacion diseñada para Web On Line Studios S.L.            **
**    Todos los derechos reservados.                            **
**    Este programa se podra modificar con el consentimiento    **
**    de Web On Line Studios S.L. Su distribucion queda         **
**    limitada a Web On Line Studios S.L.												**
**    Las posibles modificaciones sobre esta aplicacion ajenas  **
**    a Web On Line Studios S.L. deberan ser consultadas y			**
**    enviadas a Web On Line Studios en C/Alcala 18 3º Izda,    **
**    28014 Madrid. Cualquier otra operacion realizada sobre		**
**    esta aplicacion queda limitada a Web On Line Studios S.L. **
**    infringiendo en delito cualquier otra entidad que asi lo	**
**    hiciese.																									**
**																															**
** Para mas informacion referente a la licencia de esta					**
**    aplicacion referirse al fichero LICENCIA. Caso de que Ud. **
**    no tenga una copia de este fichero, contacte con Web On		**
**    Line Studios S.L. para recibir una copia del mismo				**
**																															**
** Informacion de Contacto																			**
**    Josafat Moragrega Fernandez																**
**    Engineering																								**
**    Director Tecnico																					**
**    tite@wolstudios.com																				**
**    C/Alcala 18 3º Izda, 28014 Madrid, España									**
**																															**
**											(c) Web On Line Studios S.L.						**
**                                                              **
******************************************************************
*****************************************************************/

/****************************************************************/
/************** Libreria JERARQUIA DE ACCESOS *******************/
/****************************************************************/

/*** DESCRIPCION : 
  Esta libreria esta preparada para interactuar con la API de dessarrollo
  de Wol Studios recibiendo su Objeto para Soporte de Sesiones.

								 DOCUMENTACION :				<nombre_de_modulo>.doc
  **/

class wolUsr {
	var $realm;
	var $authed;
	var $db_name;		/** nombre de la bdd de autenticacion en la sesion **/
	var $login;
	var $passwd;
	var $crypt;
	var $group_mask;				
	var $usr_mask;
	var $id_usr;		/** Clave primaria del usuario en la tabla Users **/
	var $usr_name;		/** Nombre del usuario en la tabla Users **/
	var $_aDesktops;  /** Desktops de aplicacion a los que tiene acceso el usuario **/
	var $recent_login = 0; // Si el usuario acaba de hacer login en esta subseccion o ya viene de antes.
	var $send_home = 0; 		// Si el usuario hay que mandarle a la home de escritorio o app.
	var $_aIface = array(
			'iface' 	=> NULL, 	// Iface por defecto del usuario.
			'lang' 	=> NULL,		// Idioma por defecto del usuario.
			'tema' 	=> NULL		// Tema por defecto del usuario.
			);
	var $_aLastDeskIface = array();	// Ultimo Iface seteado

	function wolUsr($nombre) {
		$this->realm = $nombre;					
	}

	function init(&$oAV) {
		if (is_object($oAV->sesion)) $this->sesion = &$oAV->sesion;
		$this->db_name = $oAV->db_name;
	}

	function get_mask() {
		return $this->group_mask;
	}

	function set_mask($mask) {
		if (!is_numeric($mask)) return FALSE;
		$this->group_mask = $mask;
	}

	function get_desktop($bAll = FALSE) {
		if (!isset($bAll)) $bAll = FALSE;
		if (!$bAll) {
			if (is_array($this->_aDesktops)) {
				list($n,$aDesk) = each($this->_aDesktops);
				reset($this->_aDesktops);
			} else $aDesk = NULL;
		} else $aDesk = $this->_aDesktops;
		return $aDesk;
	}

	function get_user() {
		return array("id_usr" => $this->id_usr, "login" => $this->login, "name" => $this->usr_name);
	}

	function get_login() {
		return $this->login;
	}

	function get_id() {
		return $this->id_usr;
	}

	function set_desktops($oDb,$bForce = FALSE) {
		if (!isset($bForce)) $bForce = FALSE;
		$RetVal = -1;
		if ($this->debug) debug("set_desktops() -  login: ".$this->login." grupo: ".$this->group_mask);
		if (!empty($this->login) AND is_numeric($this->group_mask) AND !empty($this->group_mask)) {
			if (!is_array($this->_aDesktops) OR !sizeof($this->_aDesktops) OR $bForce) {
				$cons = "SELECT ".
							"t1.*,".
							"t1.tabla as 'table', ".
							"t1.auth_field as 'auth_field', ".
							"t1.trigger_subsec as 'base_trigger_subsec' ".
							"FROM Desktops t1 ".
							"WHERE ".
							"mask & ".$this->get_mask().
							" ORDER BY orden asc";
				$rs = $oDb->query($cons);
				$seccion = NULL;
				if ($oDb->num_rows($rs)) {
					$RetVal = 0;
					while ($aDesk = $oDb->fetch_assoc($rs)) {
						$db_name = $aDesk['db_name'];
						if (!empty($db_name)) $db = $this->sesion->get_db($db_name);
						if (!is_object($db)) $db = $this->sesion->get_db('data');

						if (empty($aDesk['auth_field']) ) {
							if ($aDesk['auth_scheme'] == 'id') 
								$aDesk['auth_field'] = 'id_usr';
							else $aDesk['auth_field'] = 'mask';
						}

						$cons = "SELECT $aDesk[table].$aDesk[field] as 'value' ".
									( (!empty($aDesk['extra_fields'])) 
										?  ", $aDesk[extra_fields] "
										: "" ).
									"FROM $aDesk[table] ".
									"WHERE ".
									( ($aDesk["auth_scheme"] == 'id') 
										? $aDesk['auth_field']." = ".$this->get_id()
										: $aDesk['auth_field']." & ".$this->get_mask() );
						$tmp_rs = $db->query($cons);
						if ($db->num_rows($tmp_rs)) {
							$RetVal = 1;
							$aTmp = $db->fetch_assoc($tmp_rs);
							$aDesk['value'] = $aTmp['value'];
							unset($aTmp['value']);
							foreach ($aTmp as $fld => $val) $aDesk['extras'][$fld] = $val;
						} else {
							$this->sesion->perror(10,'Desktop Auth','La pertenencia del usuario '.$this->login.' al Escritorio '.$aDesk['nombre'].
									' _no_ se ha podido determinar al carecer de entrada en la entidad '.$aDesk['table']);
							debug("peaso error!");
							$RetVal = 0;
						}
						$db->libera($tmp_rs);
						unset($db);

						if ($RetVal) {
							$this->_aDesktops[$aDesk['id_desktop']] = $aDesk;

							/** dado que es login() de nuestra clase padre quien obtiene los valores por defecto del usuario
							  * (en cuanto a iface) y los parametros de iface se han analizado antes. De la que obtenemos el/los
							  * escritorios podemos comprobar si la solicitud/valor por defecto del iface es correcto o no.
							  **/
							$aIface = $this->sesion->get_iface();
							$this->get_desktop_ifaces($oDb,$aDesk['id_desktop'],$aIface,TRUE);
							$this->set_desktop_trigger($oDb,$aDesk['id_desktop']);
							// print_r($aIface);
						}
					}
				}
				if (!$this->authed) $RetVal = 0;
			} else {
				// print_r($this->_aLastDeskIface);
				if ($this->debug) debug("Ya habia y tal ");
				$aIface = $this->sesion->get_iface();
				if (0 && $this->debug) print_r($aIface);
				if ((is_numeric($aIface['iface']['id']) AND 
						$aIface['iface']['id'] != $this->_aLastDeskIface['iface'])
						OR (is_numeric($aIface['lang']['id'])
								AND $aIface['lang']['id'] != $this->_aLastDeskIface['lang'])
						) {
					$aDesk = $this->get_desktop();
					$id_trigger = $aDesk['trigger_subsec'];
					if ($this->debug) debug("trigger = $id_trigger ");
					$this->get_desktop_ifaces($oDb,$aDesk['id_desktop'],$aIface,TRUE);
					if (0 && $this->debug) print_r($this->_aDesktops[$aDesk['id_desktop']]);
					// debug("trigger before: $id_trigger   and now: ".$this->_aDesktops[$aDesk['id_desktop']]['trigger_subsec']);
					if ($id_trigger != $this->_aDesktops[$aDesk['id_desktop']]['trigger_subsec']) {
						if ($this->debug) debug("comprobando trigger ... ");
						$this->set_desktop_trigger($oDb,$aDesk['id_desktop']);
					}
				}
				if ($this->debug) debug("Ya habia Escritorios: ");
				if (0 && $this->debug) print_r($this->_aDesktops);
				$RetVal = 1;
			}
		}
		return $RetVal;
	} //Fin de set_desktops();
	
	/**
	  * Funcion que se encarga de establecer los posibles ifaces de un escritorio.
	  * $oDb			-	Conector BBDD donde se realizara la comprobacion.
	  * $id_desk	-	ID del desktop sobre el cual se realizara la comprobacion.
	  * $aIface		-	array() con el iface que hay que comprobar (caso de existir, se hace la comprobacion)
	  * $bSet		-	bool para saber si se ha de establecer el id_trigger_subsecc caso de existir en el iface de comprobacion.
	  * return		:  -1 => error
	  *					0	=> No hay restricciones de Iface.
	  *					n	=> ID de la subsecc trigger
	  * NOTA: Este metodo ha de ser llamado antes de set_desktop_trigger, dado que puede setearse id_trigger_subsecc
	  **/
	function get_desktop_ifaces($oDb,$id_desk,$aIface = NULL,$bSet) {
		if (!is_object($oDb)) return -1;
		if (!is_numeric($id_desk)) return -1;

		if ($this->debug) debug("get_desktop_ifaces() sobre $id_desk comprobar($bSet) ");
		if (!is_array($this->_aDesktops[$id_desk]['ifaces']) OR !sizeof($this->_aDesktops[$id_desk]['ifaces'])) {
			$cons = 'SELECT nombre, '.
						'id_tipo_iface as "iface", '.
						'id_idioma as "lang", '.
						'id_tema as "tema", '.
						'id_trigger_subsec as "trigger_subsec" '.
						'FROM Ifaces WHERE id_desktop = '.$id_desk;
			$ifrs = $oDb->query($cons);
			if (!$oDb->num_rows($ifrs)) {
				$this->_aDesktops[$id_desk]['ifaces'] = NULL;
				return 0;
			} 
			while ($aTmp = $oDb->fetch_assoc($ifrs)) {
				if (!is_array($this->_aDesktops[$id_desk]['ifaces']))
					$this->_aDesktops[$id_desk]['ifaces'] = array();
				array_push($this->_aDesktops[$id_desk]['ifaces'],$aTmp);
			}
		}

		// Si hay restriccion de ifaces, e iface que comprobar...
		if (is_array($aIface) AND sizeof($aIface) AND is_array($this->_aDesktops[$id_desk]['ifaces']) AND sizeof($this->_aDesktops[$id_desk]['ifaces'])) {
			// Colocamos la peticion en un array mas comodo de usar
			if (is_numeric($aIface['iface']['id'])) 
				$aReq['iface'] = $aIface['iface']['id'];
			if (is_numeric($aIface['lang']['id'])) 
				$aReq['lang'] = $aIface['lang']['id'];
			if (is_numeric($aIface['tema']['id'])) 
				$aReq['tema'] = $aIface['tema']['id'];

			if ($this->debug) {
				debug("Se quiere comprobar la validez de: ");
				print_r($aReq);
			}
			$aFinal = current($this->_aDesktops[$id_desk]['ifaces']);
			$bGotLast = FALSE;
			// Recorremos los posibles ifaces para este escritorio
			foreach ($this->_aDesktops[$id_desk]['ifaces'] as $aIf) {
				$bFound = FALSE;
				// Comprobamos si coincide el tipo de iface
				if (is_numeric($aIf['iface']) AND ( empty($aReq['iface']) OR 				// Si le da = el iface :O
						(is_numeric($aReq['iface']) AND $aIf['iface'] == $aReq['iface'])) // o Si el iface coincide
						) {
					if ($this->debug) debug("Iface ".$aIf['iface'].' Coincidente ...');
					// Si el tipo de iface coincide, vamos a presuponer que el idioma coincidira.
					$bFound = TRUE;
					$aFinal['iface'] = $aIf['iface'];
					// Por si acaso no coincide el idioma solicitado, le ponemos uno en el que si puede entrar.
					//	 si resulta que si puede ir a su idioma, estos valores se sobreescribiran.
					$aFinal['lang'] = $aIf['lang'];
					$id_trigger = $aIf['trigger_subsec'];
				} else continue; // Si no coincide no miramos mas

				// debug("amoh a ver:");
				// print_r($aIf);
				if ( is_numeric($aIf['lang']) AND ( empty($aIf['lang']) OR (				// Si da igual el idioma
							(is_numeric($aReq['lang']) AND $aIf['lang'] == $aReq['lang']) 	// Si coincide el idioma
							OR !is_numeric($aReq['lang']))) 											//  o no especificado
						) {																					// Hemos encontrado nuestro Iface
					if ($this->debug) debug("Lang ".$aIf['lang'].' Coincidente ...');
					$bFound = TRUE;
					$aFinal['lang'] = $aIf['lang'];
					$id_trigger = NULL;
				} else continue; // Sino, buscaremos otro

				// Comprobamos si hay se quiere un tema especifico, o le ponemos el que este tenga por defecto.
				if ( is_numeric($aIf['tema']) AND !is_numeric($aReq['tema']) ) {
					$aFinal['tema'] = $aIf['tema'];
				} elseif (is_numeric($aReq['tema'])) $aFinal['tema'] = $aReq['tema'];

				$id_trigger = $aIf['trigger_subsec'];
				$bGotLast = TRUE;
				// Si hemos llegado hasta aqui, es que lo hemos encontrado. No buscamos mas.
				break;
			}
			// debug("Tamos: ($id_trigger) ($bFound)");
			// print_r($aFinal);

			if ($bFound) {
				if (is_numeric($id_trigger)) $this->_aDesktops[$id_desk]['trigger_subsec'] = $id_trigger;
				elseif (1 OR $aFinal['iface']!=$this->_aLastDeskIface['iface'] OR $aFinal['lang']!=$this->_aLastDeskIface['lang']) {
					if ($this->debug) debug("Comprobar el trigger raiz! ".$this->_aDesktops[$id_desk]['base_trigger_subsec']);
					if (is_numeric($this->_aDesktops[$id_desk]['base_trigger_subsec']))
						$this->_aDesktops[$id_desk]['trigger_subsec'] = $this->_aDesktops[$id_desk]['base_trigger_subsec'];

				}
				if (!$bGotLast) {
					debug("Su escritorio no tiene el idioma solicitado.");
				}
				if (is_array($aFinal) AND sizeof($aFinal)) {
					$this->sesion->set_iface($aFinal);
					$this->_aLastDeskIface = $aFinal;
				} else $this->_aLastDeskIface = NULL;
			} else {
				// print_r($this->_aDesktops[$id_desk]['trigger_subsec']);
				// debug("Un auth");
				// print_r($aFinal);
				if (is_array($aFinal)) {
					if ($this->debug) debug("No se te ha mandado al Iface solicitado por estar mal configurado. (Metido en el primero)");
					$this->sesion->set_iface($aFinal);
					$this->_aLastDeskIface = $aFinal;
				} else {
					if ($this->debug) debug("Vaciando last 2");
					$this->_aLastDeskIface = NULL;
					if ($this->debug) debug("Houston! Houston! We have a problem here...");
				}
			}

		} elseif (!is_array($this->_aDesktops[$id_desk]['ifaces']) OR !sizeof($this->_aDesktops[$id_desk]['ifaces'])) {
			if ($this->debug) debug("Vaciando last 3 ($id_desk)");
			if ($this->debug) print_r($this->_Desktops[$id_desk]);
			$this->_aLastDeskIface = NULL;
			return 0;
		} else {
			if ($this->debug) debug("Vaciando last 4 ");
			if ($this->debug) $this->_aLastDeskIface = NULL;
			return -1;
		}

	}

	function set_desktop_trigger($oDb,$id_desk) {
		if ((int)$this->_aDesktops[$id_desk]['trigger_subsec']) {
			$cons = "SELECT ".
							"t2.nombre as 'subsec_name',".
							"t2.id_sub_secc as 'id_subsec' ".
							"FROM Sub_Secc t2 ".
							"WHERE t2.id_sub_secc = ".$this->_aDesktops[$id_desk]['trigger_subsec'];
			$tmprs = $oDb->query($cons);
			if ($oDb->num_rows($tmprs)) {
				$aTmp = $oDb->fetch_assoc($tmprs);
				$seccion = $this->_aDesktops[$id_desk]['subsec_name'] = $aTmp['subsec_name'];
				$this->_aDesktops[$id_desk]['id_subsec'] = $aTmp['id_subsec'];
			}
		}
	}

	function cerrar() {
		// $this->sesion = NULL;
		unset($this->sesion);
		$this->recent_login = 0;
		$this->send_home = 0;
	}

	function unauth() {
			if ($this->debug) debug("still guest login, checking ...");
			$this->authed = 0;
			$this->group_mask = 0;
			$this->usr_mask = 0;
			$this->usr_name = NULL;
			$this->_aDesktops = NULL;
			$this->_aIface = array();
	}

	function dbReplaceUser($aUsr,$desktop_name = NULL) {
		if (!is_object($this->sesion)) return -1;
		if (empty($this->db_name)) {
			$this->sesion->lcMessate('LCS_DBNULL');
			return -1;
		}
		$oDb = $this->sesion->get_db($this->db_name);
		if (!is_object($oDb)) {
			$this->sesion->lcMessage('LCS_DBNULL');
			return -1;
		}
		if (empty($aUsr['login']) AND !is_numeric($aUsr['id_usr'])) {
			$this->sesion->lcMessage('IKRN_AUTH_NOLOGIN');
			return -1;
		} elseif (is_numeric($aUsr['id_usr']) AND empty($aUsr['login'])) {
			$oDb->tb_delete('Users',array('id_usr' => $aUsr['id_usr']));
			return 0;
		}
		if (!is_numeric($aUsr['id_usr'])) $aUsr['id_usr'] = NULL;
		$aDesk = $this->get_desktop();
			
		// Si el usuario no tiene mascara de acceso ...
		if (!is_numeric($aUsr['av_group'])) { 				
			// .. Y Si recibimos por parametro el escritorio donde meterlo (le asignamos ese)
			if (!empty($desktop_name)) {						
				// Si el indicado es el actual, no buscamos la mascara en ningun lao.
				if (!strcmp($desktop_name,$aDesk['nombre'])) {	
					$aUsr['av_group'] = $aDesk['mask'];
				// Sino, lanzamos consulta para obtener la mascara del escritorio (la cachearemos esta?)
				} else {
					$idrs = $oDb->query('SELECT mask FROM Desktops WHERE nombre = "'.$desktop_name.'"');
					// Si no existe el escritorio deseado ... no insertamos al usuario
					if (!$oDb->num_rows($idrs)) {
						$this->sesion->lcMessage('IKRN_AUTH_NODESK',array('desktop' => $desktop_name));
						return -1;
					} else {
						$aTmp = $oDb->fetch_row($idrs);
						if (is_numeric($aTmp[0])) {
							$aUsr['av_group'] = $aTmp[0];
						} else {
							$this->sesion->lcMessage('IKRN_AUTH_NODESK',array('desktop' => $desktop_name));
							return -1;
						}
					}
				}

			// .. Pero si no se ha indicado escritorio donde ponerlo, y es nuevo usr => en escritorio actual
			} elseif (!is_numeric($aUsr['id_usr'])) {		
				$aUsr['av_group'] = $aDesk['mask'];
			} 
		}

		if (empty($aUsr['passwd']) AND !empty($aUsr['password'])) $aUsr['passwd'] = $aUsr['password'];
		if (empty($aUsr['passwd']) AND isset($aUsr['passwd'])) unset($aUsr['passwd']);
		else {
			$pass = $aUsr['passwd'];
			$aUsr['passwd'] = NULL;
			unset($aUsr['passwd']);
		}

		$cons = 'SELECT id_usr FROM Users WHERE login = "'.$aUsr['login'].'" '.
					( (is_numeric($aUsr['id_usr'])) ? 'AND id_usr != '.$aUsr['id_usr'] : '');
		$tmprs = $oDb->query($cons);
		if ($oDb->num_rows($tmprs)) {
			$this->sesion->lcMessage('IKRN_AUTH_USR_EXISTS',array('login' => $aUsr['login']));
			return -1;
		}

		if (!is_numeric($aUsr['id_usr'])) {
			$oDb->tb_insert('Users',$aUsr);
			$aUsr['id_usr'] = $oDb->last_insert_id();
		} else {
			$oDb->tb_update('Users',$aUsr);
		}
			
		if (!empty($pass) AND is_numeric($aUsr['id_usr'])) {
			$oDb->query('UPDATE Users SET passwd=PASSWORD("'.$pass.'") WHERE id_usr = '.$aUsr['id_usr']);
		}

		return $aUsr['id_usr'];

	}

	function isGuest() {
		if (empty($this->login) ) return true;
		else return false;
	}

}

	/*** WolStudios Access Validator Class  ***/
	/*** escalafonAV = new wolAV(); ***/
class wolAV { 
	/********** VARIABLES DE CONFIGURACION GENERAL *******************/
    var $App_Name;			/* Nombre de la app a la k pertenece */
	 var $aConfSess;		/* Array con la configuracion de la sesion */

												/* Configuracion */
	 var $aConf = 
				array(	"tb_sec_subsecc"	=> "",	/* tabla para el grupo de acceso necesario actualmente */
								"tb_users"				=> "",	/* tabla de usuarios */
								"tb_groups"				=> "",	/* tabla de grupos de usuarios */
								"tb_auth_classes"	=> "",	/* Clases de autentificacion */
								"plt_denied"			=> "",	/* id del tipo de notificacion activado */
								"plt_vis_name"		=> "",	/* nombre del tipo de notificacion */
								"security"				=> "",	/* Nivel de Seguridad (retroactivos)
																								 0 - Ninguno
																								 1 - Comprobar login
																								 2 - Comprobar grupo de usr (y machacar)
																								 3 - Comprobar SubSeccion (ade+ de Seccin)
																				 */
								"auth_class_id"		=> "", /* clase de la notificacion */
								"auth_class"			=> "", /* clase de la notificacion */
								"auth_script"			=> ""		 /* clase de la notificacion */
								 );
	 var $oUsr;						/* Informacion del usuario authed */
	 var $id_subsecc;			/* Id de la sub_secc actual */
	 var $def_tipo;				/* Tipo de notificacion por defecto */
	 var $activa_var;			/* Nombre de Variable de activacion de este modulo.
														Esta variable contendra un tipo de notificacion */
	 var $inc_dir;				/* Directorio de inclusion de los tipos de notificacion */
	 var $debug;					/* modo debug */
	 var $db;							/* Objeto wol_db con la conexion activa */
	 var $db_name;				/* Nombre de la instancia wol_db en la sesion */
	 var $sesion;					/* Objeto wolSesion actual (deshuso)*/

									/********** Variables *************/
	 var $aSecConf	= array(
										"id_subsec"			=>	"",		/* Sub-Seccion actual (screen) */
										"subsec_mask"		=>	"",		/* mascara de grupo para el screen */
										"sec_mask"			=>	""		/* mascara de grupo para la seccion */
										);															

	 var $aPlts			= array( array(			/* Plantillas sustiuidas */
										0 => NULL,	/* src de la plantilla */
										1 => NULL		/* id_subseccion de la plantilla */
										) );

												/***** Metodos de API WOL ******/
   function wolAV($nombre) {
      /* Nota: 
			 */
      if (empty($nombre) OR !isset($nombre) OR !is_string($nombre))
					$nombre = "Sesion";
		$nombre = trim($nombre);
		$this->App_Name = $nombre;
		$this->oUsr = new wolUsr($nombre);
		$this->oUsr->crypt = 1; /* passwd encriptadas */
		$this->debug = 0;
		$this->aConf = NULL;
   }

				 /** Inicializacion de las tablas de configuracion **/
	function cargar_conf() {
				/* NOTA:
				*/							 
		if (is_array($this->aConf) AND sizeof($this->aConf)) return TRUE;

		$oDb = $this->db;
		//$sess = $this->sesion;
		//global $$sess;

		$this->aConfSess = $aConfSess = $this->sesion->get_conf_tbs();
		if (!empty($aConfSess['sec_subsecc'])) $aConfTbs['subsec'] = $aConfSess['sec_subsecc'];

				/** notificacion por defecto (caso de tener) (por si no se encuentra la indicada) **/
      $consulta = "SELECT valor FROM _main WHERE nombre='av_tb_usr'";
      $id = $oDb->query($consulta);
      $aTmp = $oDb->fetch_array($id);
      $oDb->libera($id);
      $this->aConf['tb_users'] = (!empty($aTmp[0])) ? $aTmp[0] : NULL;
												if (!$this->aConf['tb_users']) return 0;
												
												/** variable clave de activacion (con el tipo de notificacion) **/
      $consulta = "SELECT valor FROM _main WHERE nombre='av_tb_groups'";
      $id = $oDb->query($consulta);
      $aTmp = $oDb->fetch_array($id);
      $oDb->libera($id);
      $this->aConf['tb_groups'] = (!empty($aTmp[0])) ? $aTmp[0] : NULL;
												if (!$this->aConf['tb_groups']) return 0;

												/** Tabla con las class de autentificacion **/
      $consulta = "SELECT valor FROM _main WHERE nombre='av_tb_classes'";
      $id = $oDb->query($consulta);
      $aTmp = $oDb->fetch_array($id);
      $oDb->libera($id);
      $this->aConf['tb_auth_classes'] = (!empty($aTmp[0])) ? $aTmp[0] : NULL;
												if (!$this->aConf['tb_auth_classes']) return 0;

												/** Directorio de inclusion **/
      $consulta = "SELECT valor FROM _main WHERE nombre='av_inc_dir'";
      $id = $oDb->query($consulta);
      $aTmp = $oDb->fetch_array($id);
      $oDb->libera($id);
      $this->inc_dir = (!empty($aTmp[0])) ? $aTmp[0] : NULL;
												if (!$this->inc_dir) return 0;

												/** Nivel de Seguridad **/
      $consulta = "SELECT valor FROM _main WHERE nombre='av_security_lev'";
      $id = $oDb->query($consulta);
      $aTmp = $oDb->fetch_array($id);
      $oDb->libera($id);
      $this->aConf['security'] = (!empty($aTmp[0])) ? (int) $aTmp[0] : 0;

		$this->get_default_subsec();
		$this->get_default_class();							

		return 1;
	}

	function get_default_subsec() {
			global $BACKOFFICE; //Fixme: obtener de wolSesion.

			$oDb = $this->db;
			$aConfSess = $this->aConfSess;

			if ($BACKOFFICE) $var = "av_bologin_subsec";
			else $var = "av_login_subsec";
			$subsec = $oDb->read_main_value($var);

			$this->aConf['sub_seccion'] = (!empty($subsec)) ? $subsec : NULL;

			return 1;
	}

	function get_default_class() {
			$oDb = $this->db;
			$aConfSess = $this->aConfSess;

      $consulta = "SELECT valor FROM _main WHERE nombre='av_auth_class'";
      $id = $oDb->query($consulta);
      $aTmp = $oDb->fetch_array($id);
      $oDb->libera($id);
      $tmp = (int) (!empty($aTmp[0])) ? $aTmp[0] : NULL;
			if ($tmp) {
				$consulta = "SELECT * FROM ".$this->aConf['tb_auth_classes']." WHERE id_auth_class=".$tmp;
				$id = $oDb->query($consulta);
				$aTmp = $oDb->fetch_array($id);
				$oDb->libera($id);
				$this->aConf['auth_class_id'] = (int) (!empty($aTmp['id_auth_class'])) ? $aTmp['id_auth_class'] : NULL;
				$this->aConf['auth_class'] = (!empty($aTmp['class_name'])) ? $aTmp['class_name'] : NULL;
				$this->aConf['auth_script'] = (!empty($aTmp['script'])) ? $aTmp['script'] : NULL;
				if (!$this->aConf['auth_class_id'] OR
						!$this->aConf['auth_class'] OR
						!$this->aConf['auth_script'] ) return 0;
			}
			return 1;
   
	}

	function includes() {
			if (!empty($this->aConf['auth_script'])) {
						$tmp = $this->inc_dir."/".$this->aConf['auth_script'];
						//salida($tmp);
						include($tmp);
			}								
	}
				 
				 /** Inicializamos  **/
   function init(&$oSesion) {
      /* Nota :
				 El objeto wol_notifica carga los modulos de notificacion (tipos) y se pasa
				 a si mismo.
				 Los metodos de acceso a datos seran de 2 tipos: set("nombre",valor) o set_to(valor)
								(es decir, 2 niveles de acceso)
			 */

			$this->debug=0;		/* obtener db y seccion actual */

			$this->sesion = &$oSesion; //->obj_var_name;
			$this->set_db();

			$this->oUsr->init($this);
			$this->oUsr->debug = $this->debug;
			$this->id_subsecc = $oSesion->get_id_subsecc();

			/* Cargamos la configuracion */
			if (!$this->cargar_conf()) {
				$this->error("No se han podido cargar la configuracion");
				return 0;
			}

			/* Cargamos la autentificacion de esta seccion */
			if (!$this->load_auth()) $this->error("Imposible cargar sistema de autenticacion");
			// $this->_aSec();

			/* Comprobamos la autenticacion en la sub-secc y cargamos valores. */
			if (!$this->auth()) {
				if ($this->debug) debug("_no_ autenticado");
				$this->oUsr->unauth();
				$seccion = $this->aConf['sub_seccion'];
				$oSesion->reset_plts();
				$oSesion->set_idsecc($seccion);
				$oSesion->set_plts();
				$RetVal = 0;
			} else {
				if ($this->debug) debug("Autenticado ... set? ".$this->oUsr->send_home);
				// if (!strcmp($oSesion->def_secc,$oSesion->get_section_name()) OR !strcmp($oSesion->def_secc,$oSesion->get_subsecc_name())) 
				if ($this->oUsr->send_home) {
					$aDesk = $this->oUsr->get_desktop();
					if (is_array($aDesk) AND sizeof($aDesk)) $seccion = $aDesk['subsec_name'];
					if (!empty($seccion)) {
						$oSesion->reset_plts();
						$oSesion->set_idsecc($seccion,TRUE);
						$oSesion->set_plts();
					}
				} else {
					if ($this->oUsr->recent_login) {
						$oSesion->set_plts();
					}
				}
				$RetVal = 1;
			}

			return $RetVal; /*		0 - Renderiza con lo k tenemos 
														1 - Carga los modulos		*/
   } /* Fin de init() */

 	 /** Metodo encargado de reconocer si la plantilla que esta siendo
				 procesada en estos instantes nos pertenece o no */
 	 function reconocer_plt($plt_name) {
				if (!isset($plt_name) OR empty($plt_name)) return 0;						 
				/* hay k darle un repaso a la funcion encuentra */
				$idx = $this->aIndices[$plt_name];
				if ($idx) {
												$this->i = $idx;
												$this->activaos = 1;
												return 1;
				}
				$this->activaos = 0;
				return 0;
 	 } /* Fin de reconocer_plt()*/

 	 /** Metodo para indicar si hay o no rows para este menu 
				 (si es nuestra plantilla, siempre devolvemos si. ya se encargara
				 get_plt_data de parar el bucle) **/
 	 function hay_rows() {
				if ($this->activaos) return 1;
				else return -1;
 	 }
 
 	 function set_db() {
		 if (!is_object($this->sesion)) {
			 $this->error("No existe instancia valida de sesion en set_db");
			 return FALSE;
		 }
		 if (empty($this->db_name)) $this->db_name='auth';
		 $this->db = &$this->sesion->get_db($this->db_name);
		 if (!is_object($this->db)) {
			 // debug($this->db_name." _no_ es instancia wolDb. fetching conf ..");
			 $this->db = &$this->sesion->get_db('conf');
			 $this->db_name = 'conf';
		 }
		 if (!is_object($this->db)) return FALSE;
		 return TRUE;
 	 }

 	 function get_db() {
				if (!is_object($this->db)) {
								$this->error("No se pudo devolver un Objeto wol_db valido");
								return NULL;
				} else return $this->db;
 	 }

 	 function error($msg) {
			 aviso("Error(Access Validator): $msg");
			 //break;
 	 }

   function cerrar() {
		// $this->sesion = NULL;
		unset($this->sesion);
		$this->oUsr->cerrar();
		unset($this->db);
		unset($this->aConfSess);
   } /* Fin de cerrar */


				/******* Metodos ESPECIFICOS del Modulo **********/
	function load_auth() {

				/** Miramos a ver si cargamos la plantilla y clase por defecto **/
				$this->includes();

				$oDb = $this->db;

				if ($this->login) debug("Llamando al login desde load_auth()");
				if (!$this->login()) return 1;

				$doCheck = FALSE;
				$aTmp = $this->oUsr->get_desktop();
				$id_trigger = $aTmp['trigger_subsec'];
				$aTmp = NULL;
				if ($this->debug) debug("gotit : $id_trigger ");
				$set_status = $this->oUsr->set_desktops($oDb);
				if ($set_status == -1) {
					if ($this->debug) debug("No hay desktops... tiramos");
					$doCheck = TRUE;
					$id_check = $this->sesion->get_id_subsecc();
				} elseif (!$set_status) {
					// Si el usuario no esta autenticado en ningun escritorio...
					// ... recogemos el resultado de set_desktops()=
					if ($this->debug) debug("Si hay pero no autenticado!");
					$aTmp = $this->oUsr->get_desktop();
					$id_trigger = $aTmp['trigger_subsec'];
				} else {
					if ($this->debug) debug("hay escritorios definidos anteriormente...");
					// print_r($this->oUsr->_aIface);
					// debug("es ".$this->sesion->def_secc." = ".$this->sesion->get_section_name());
					// debug("last");
					// print_r($this->oUsr->_aLastDeskIface);
				}

				$aIface = $this->sesion->get_iface();
				$aDesk = $this->oUsr->get_desktop();
				if ($this->debug) debug("trigger = $id_trigger contra ".$aDesk['trigger_subsec']);
				if ($this->debug) debug("home = ".$this->sesion->def_secc." esta ".$this->sesion->get_subsecc_name());
				if (is_array($aDesk) AND sizeof($aDesk) AND 
						( //No nos importa el nombre de seccion: !strcasecmp($this->sesion->def_secc,$this->sesion->get_section_name()) OR 
						  !strcasecmp($this->sesion->def_secc,$this->sesion->get_subsecc_name())
						OR (is_numeric($id_trigger) AND $id_trigger != $aDesk['trigger_subsec']) )
						) {
					if (!is_numeric($aDesk['trigger_subsec'])) $id_check = $this->sesion->get_id_subsecc();
					else {
						$id_check = $aDesk['trigger_subsec'];
						// if (is_numeric($id_trigger) AND $id_trigger != $aDesk['trigger_subsec'])
					}
					$this->oUsr->send_home = 1;
					$doCheck = TRUE;
				} else {
					if ($this->debug) debug("Dado que no es una 'home', comrprobaremos esta : ".$this->sesion->get_id_subsecc());
					$doCheck = TRUE;
					$id_check = $this->sesion->get_id_subsecc();
				}
				// $doCheck = TRUE;

				if ($this->debug) debug("load-auth -> check? ($doCheck)($id_check) :".$this->oUsr->recent_login);
				if ($doCheck AND is_numeric($id_check)) {
						 /* obtener seccion y cargar su auth_conf (a traves de id_seccion) */
					/* nota: aki molaria k ademas por sub_secc se comprobase por seccion */
					$cons = "SELECT t1.id_seccion, t1.id_sub_secc, t2.av_mask, t1.av_group FROM ".
	//aConfSess no se resete  y no pilla bien Sec_Subsec
	//								$this->aConfSess[sec_subsecc]." t1, ".$this->aConfSess[secciones]." t2 ".
									" Sec_Subsecc t1 , Secciones t2" .
									"			WHERE t1.id_sub_secc=".$id_check.
									" AND t1.id_seccion=t2.id_seccion";
					$aTmp = $oDb->fetch_array($oDb->query($cons));
					$this->aSecConf['id_seccion'] = $aTmp['id_seccion'];
					$this->aSecConf['id_subsec'] = $aTmp['id_sub_secc'];
					$this->aSecConf['subsec_mask'] = $aTmp['av_group'];
					$this->aSecConf['sec_mask'] = $aTmp['av_mask'];

						 /* Obtener la clase y script k va a autentificar * (esta seccion)
					$this->aConf[auth_class_id];
					$this->aConf[auth_class];
					$this->aConf[auth_script];
					*/
				}

				return 1; // todo ok 
	}

	function login() {
				if ($this->oUsr->authed AND !$this->oUsr->isGuest()) return 1;

						/* Llamar a la clase con el objeto wolUsr */
		 		$oDb = $this->get_db();
				if (empty($this->aConf['auth_class'])) return 0;
				$auth_class = new $this->aConf['auth_class']($this->App_Name);
				if (!$auth_class->init($this->oUsr,$oDb)) return 0;
				else {
					/* Asignar mask de grupo 
							nota: en un futuro, esto deberia permitirsele a la clase que autentifica */
					$bSet = FALSE;
					if (!$this->oUsr->get_mask()) {
						$this->oUsr->_aIface = array();
						$authrs = $oDb->query('SELECT av_group,id_tipo_iface,id_idioma,id_tema '.
													'FROM '.$this->aConf['tb_users'].' WHERE activo=1 AND login = "'.$this->oUsr->get_login().'"');
						if ($oDb->num_rows($authrs)) {
							$aTmp = $oDb->fetch_array($authrs);
							$this->oUsr->set_mask($aTmp['av_group']);
							if (is_numeric($aTmp['id_tipo_iface'])) {
								$this->oUsr->_aIface['iface'] = $aTmp['id_tipo_iface'];
								$bSet = TRUE;
							}
							if (is_numeric($aTmp['id_idioma'])) {
								$this->oUsr->_aIface['lang'] = $aTmp['id_idioma'];
								$bSet = TRUE;
							}
							if (is_numeric($aTmp['id_tema'])) {
								$this->oUsr->_aIface['tema'] = $aTmp['id_tema'];
								$bSet = TRUE;
							}
							
						}
						$oDb->libera($authrs);
					} 
					// debug("Auth:set_iface()");
					if ($bSet) $this->sesion->set_iface($this->oUsr->_aIface);
				}

				if ($this->debug) debug("auth(): authed...".$this->oUsr->authed);

				if (strcmp($this->oUsr->realm,$this->App_Name)) $this->oUsr->authed=0; 
				if ($this->debug) debug("realm ".
																(($this->oUsr->authed) ? "ok" : "fail"));

				if (!$this->oUsr->authed) { /* si no authed, invitado */
					$this->oUsr->unauth();
				} else {
					$this->oUsr->recent_login = 1;
				}
				return 1;
	}

	function auth() {
				/** si esta authed **/
				/* comprobamos login del usuario */
				if (!empty($this->oUsr->login) AND $this->aConf['security']) {
					if ($this->debug) 
						debug("secure(".$this->aConf['security'].
								"): comprobando login(".$this->oUsr->login.")....");
					$cons = "SELECT login,passwd,av_group FROM ".$this->aConf['tb_users'].
								" WHERE activo=1 AND login='".$this->oUsr->login."'";
					$id = $this->db->query($cons);
					if (!$this->db->num_rows($id)) {
						if ($this->debug) 
							debug("secure(".$this->aConf[security]."): login ".
									(($this->oUsr->authed=0) ? "" : "<b>fail</b>") );
						//$this->oUsr->authed = 0;
					} else {
						if ($this->debug)
							debug("secure(".$this->aConf['security']."): login ok");
						$aTmp = $this->db->fetch_array($id);
					}
					$this->db->libera($id);

					/* comprobamos tambien su grupo (k sea correcto)*/
					if ($this->aConf['security']>1) {
						if ($this->debug) 
							debug("secure(".$this->aConf['security'].
									"): comprobando grupo....");
						if ($aTmp['av_group']!=$this->oUsr->group_mask) {
							if ($this->debug) 
								debug("secure(".$this->aConf['security'].
										"): grupo <b>fail</b> ".
										"reasignando...".$aTmp['av_group'].
										" desde ".$this->oUsr->group_mask);
							$this->oUsr->group_mask = (int) $aTmp['av_group'];
						} else {
							if ($this->debug) 
								debug("secure(".$this->aConf['security'].
										"): grupo ok");
						}
					}
				}

				/* comprobacion de seccion */
				if ($this->debug) debug("comprobando seccion...");
				// debug(decbin($this->oUsr->group_mask)." & ".decbin($this->aSecConf['sec_mask']));
				// debug("Res: ".((int)$this->oUsr->group_mask & (int)$this->aSecConf['sec_mask']));
				if ($this->aSecConf['sec_mask'] AND
						!((int)$this->oUsr->group_mask & (int)$this->aSecConf['sec_mask'])) {
					if ($this->debug) 
						debug(	"secure(".$this->aConf['security']."): ".
								"seccion (".$this->aSecConf['sec_mask'].") login (".$this->oUsr->group_mask.") <b>fail</b>");
					return 0;
				} else {
					if ($this->debug) 
						debug("secure(".$this->aConf['security']."): ".
								"seccion login ok");
					$this->oUsr->authed=1;
				}

				/* comprobacion de subseccion */
				if ($this->aConf['security']>2) {
								if ($this->debug) debug("comprobando mascara subseccion(".$this->aSecConf['subsec_mask'].")... (".$this->oUsr->get_mask().")");
								if ($this->aSecConf['subsec_mask'] AND
										!((int)$this->oUsr->group_mask & (int)$this->aSecConf['subsec_mask'])) {
												$this->oUsr->authed=0;
												if ($this->debug) 
																debug(	"secure(".$this->aConf['security']."): ".
																				"sub-seccion <b>fail</b>");
												return 0;
								} else {
												if ($this->debug) 
																debug(	"secure(".$this->aConf['security']."): ".
																				"sub-seccion ok");
												$this->oUsr->authed=1;
								}
				}

				if ($this->oUsr->authed) { return 1;
				} elseif (!$this->aSecConf['sec_mask'] AND
									!$this->aSecConf['subsec_mask']) {
												if ($this->debug)
																debug(	"secure(".$this->aConf[security]."): ".
																				"seccion y sub-seccion publicos");
												return 1;
				} else	return 0;

	} /* fin del metodo auth() */
   

} /***** FIN DE LA CLASE *******/


  
      

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
			if ($bFrom) {
				$fld = array_shift (split (" ", trim ($select)));
				$aTmp = split ("\.", $fld);
				array_pop ($aTmp);
				$from = implode (".", $aTmp);
				if (strchr ($from, "(")) {
					$aTmp = array ();
					$aTmp = split ("[()]", $from);
					$from = $aTmp[1];
				}
				if (!empty ($from))
					$this->_add_from ($from);
			}
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
		$aFlds = split ("[ =!<>&]", trim ($where));
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
				// debug("wolSearchAPI->set_db -- aNames[data]");
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
		return $this->db_data;
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

//definicion de propiedades


	var $sesion;					  // objeto sesion
	var $App_Name;					  // nombre de la aplicacion, y por consiguiente el global de la variable de sesion



	var $id = "";					  // Identificador de consulta
	var $id_secc;					  /* id de seccion */
	var $aPlantillas = array (); // Plantillas ha cambiado/añadido el buscador
	var $iden_busq = 0;			  /* identificador del tipo de busqueda o buscador. */
	var $search_name = 0;		  /* identificador del tipo de busqueda o */
	var $hits_page = 0;			  /* Golpes por pagina */
	var $pagina = 0;				  /* Pagina actual */

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
		if (!empty ($id)) {
			$cons = "select distinct nom_var from ".$this->sesion->read_main_value ("tb_tipbus_subse");
			$cons .= " where id_sub=".$id." order by id_sub";
			unset ($id);
			// salida("cons0 ".$cons."<br>");
			$rs = $this->db->query ($cons);
			while ($row = $this->db->fetch_array ($rs)) {
				$nom_var = $this->sesion->fetchVar ($row['nom_var'], 'POST');
				if (empty ($nom_var))
					$nom_var = $this->sesion->fetchVar ($row['nom_var'], 'GET');
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
			if ($this->debug)
				debug ("(fuera) iden_busq ".$this->iden_busq." But OldIDB(".$this->old_iden.")<BR>\n");

		  /** no hay submit, comprobamos el resto entorno **/
			// if ($this->id_secc!=$obj_sesion->id_secc) { /* ha cambiado */
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
			case 1:					  /* recarga simple */
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
						// old_secc es nuevo. añadir descripcion
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
			}							  /* final del switch */
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

			  /** Buscamos ahora el paginado.. **/
				$cons = "select nombre_pg from ".$this->tb_tipo_busq." where id_tip=";
				$cons .= $this->iden_busq;
				$rs = $this->db->query ($cons);
				$row = $this->db->fetch_array ($rs);
				if ($row["nombre_pg"]) {
					$pg = $this->sesion->fetchVar($row['nombre_pg'], 'POST');
					if (!is_numeric($pg)) $pg = $this->sesion->fetchVar($row['nombre_pg'],'GET');
					if ($this->debug)
						debug ("nombre pg = ".$row["nombre_pg"].
								 " recarga = ".$obj_sesion->bRecarga." forzada = ".$this->busqueda_forzada." pagina = ".$this->pagina);

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
					// } else aviso("hemos recargao creo. hay b? ".$obj_sesion->hay_b);
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
					" where t1.id_tipo=t2.id_tip AND t1.id_sub=".$obj_sesion->get_id_subsecc ()." order by t1.id_sub";
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
				$this->set_plts ($obj_sesion);
			} else {
				$this->get_includes ();
				$this->set_plts ($obj_sesion);
			}							  // end if de isset valor_var

/*Se registra el número de pagina en el objeto*/
			$cons = "select nombre_pg from ".$this->sesion->read_main_value ("tb_tipo_busq")." where id_tip=";
			$cons .= $this->iden_busq;
			$rs = $this->db->query ($cons);
			$row = $this->db->fetch_array ($rs);
			if ($row["nombre_pg"]) {
				$pg = $this->sesion->fetchVar ($row['nombre_pg'], 'POST');
				if (!is_numeric($pg)) $pg = $this->sesion->fetchVar ($row['nombre_pg'], 'GET');
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
			// Establecemos los datos de la busqueda para mandarselos a la funcion de proceso de datos.
			if (is_object ($this->oSearchAPI)) {
				$this->oSearchAPI->init ($this);
				$this->oSearchAPI->set_search_id ($this->iden_busq);
			}

/*Cambio las plantillas en la tabla de plantillas de la sesion*/
			// $this->set_plts($obj_sesion);
			$hay_b = 1;
			if ((!$this->ignorar_iden && $this->busqueda_forzada) || isset ($valor_var)) {
				// Compruebo si llamar a hacer consulta
				$cons = "select form_data_func from ".$this->sesion->read_main_value ("tb_tipbus_subse")." where id_tipo=";
				$cons .= $this->iden_busq." and id_sub=".$this->id_secc;
				$rs = $this->db->query ($cons);
				$row = $this->db->fetch_array ($rs);
				// debug("funcion: ".$row["form_data_func"]);
				if (!empty ($row["form_data_func"]))
					$vari = $row["form_data_func"] ($obj_sesion, $this->oSearchAPI);
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
					debug("ReConectando db_data .. ");
					$this->db_data->conecta ();
				}
			} elseif ($this->debug) debug ("Imposible determinar una base de datos de conexion");

			if ((!$this->ignorar_iden && $this->busqueda_forzada) || isset ($valor_var)) {
				if ($this->debug) debug ('No ignorar la almacenada y forzada, o formulario?  hacer_consulta()'.$this->ignorar_iden);
				$Ret_Val = $this->hacer_consulta ($obj_sesion);
				// Jode la Recarga con OrderBy: $this->orderby = NULL;
			}

		}								  // end-if de HAY una buskeda k realizar

		if ($hay_b) {
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
		$this->activao = (int) $hay_b;
		/*
		 * $inc = $this->get_include(); if (!empty($inc)) include($inc);
		 */
		// salida("(init) RETURN ".(int)$hay_b);
		return (int) $hay_b;
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
				$oDb = $this->db;
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
	 *	  estándard. Esto es : "frase exacta" +termino1 termino2 -termino3
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
		$seccion = 88;				  // Tite: pk 88 ??????
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
				if ($bParOpen AND $i == ($n_vars-1)) {
					$mi_where[$seccion] .= ") ";
					$bParOpen = FALSE;
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
							).$partes_selec[$clave].					// Añadimos la parte SELECT
							((($tmpvar = $this->oSearchAPI->get_selects ()))
							 ? ", $tmpvar" : "").										// Añadimos los campos extra que se necesiten
																								// Añadimos el nombre de seccion como parte de la query
							((!empty ($select_seccion)) ? ", ".$select_seccion : "").
							$partes_from[$clave].$partes_where[$clave].
							((($tmp_w = $this->oSearchAPI->get_wheres ()))		// Añadimos las  condiciones extra que se necesiten
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
											((($tmp_w = $this->oSearchAPI->get_wheres ()))	// Añadimos las condiciones extra que se necesiten 
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

		if ($this->debug)
			debug ("wol_search->hacer_consulta() --> return this->cons_secc(".sizeof ($this->cons_secc).")");
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

  
     

/**
* Aplicacion diseñada para Web On Line Studios S.L.
*    Todos los derechos reservados.
*    Este programa se podra modificar con el consentimiento
*    de Web On Line Studios S.L. Su distribucion queda
*    limitada a Web On Line Studios S.L.
*    Las posibles modificaciones sobre esta aplicacion ajenas
*    a Web On Line Studios S.L. deberan ser consultadas y
*    enviadas a Web On Line Studios en C/Alcala 18 3º Izda,
*    28014 Madrid. Cualquier otra operacion realizada sobre
*    esta aplicacion queda limitada a Web On Line Studios S.L.
*    infringiendo en delito cualquier otra entidad que asi lo
*    hiciese.
*
* Para mas informacion referente a la licencia de esta
*    aplicacion referirse al fichero LICENCIA. Caso de que Ud.
*    no tenga una copia de este fichero, contacte con Web On
*    Line Studios S.L. para recibir una copia del mismo
*
* Informacion de Contacto
*    Josafat Moragrega Fernandez
*    Engineering
*    Director Tecnico
*    tite@wolstudios.com
*    C/Alcala 18 3º Izda, 28014 Madrid, España
* @author    Josafat Moragrega Fernandez
*
* @copyright  Web On Line Studios S.L.
*
*/

/*
* $Id: sesiones.inc,v 1.1.2.1.4.22.4.11.4.36.2.8 2004/11/09 19:26:18 tite Exp $
* $Header: /cvs/gestion/escritorio/kernel/sesiones.inc,v 1.1.2.1.4.22.4.11.4.36.2.8 2004/11/09 19:26:18 tite Exp $
* $Author: tite $
* $Date: 2004/11/09 19:26:18 $
* $Name: V1_05b $
*/

/* Este modulo tiene como objeto crear un objeto sesion con unos atributos
   y unos metodos que permitan la comunicacion entre los distintos modulos
   de un portal web.
   Presunciones :
   - Esta funcion necesita usar el modulo db.inc, asi como tener una instancia
de WOl_db en la variable $oDb, la cual habra de ser global.
 */

define('IKRN_VAR_CRC_KEYMATCH',			bindec('00001'));
define('IKRN_VAR_CRC_VALUEMATCH', 		bindec('00010'));
define('IKRN_VAR_CRC_MATCH', 			bindec('00011'));
define('IKRN_VAR_CRC_NEW', 				bindec('00100'));
define('IKRN_VAR_CRC_CHANGE',	 		bindec('01000'));
define('IKRN_VAR_CRC_AUTHED',	 		bindec('10000'));

define('IKRN_VAR_ORIG_POST', 			bindec('00001'));
define('IKRN_VAR_ORIG_GET', 				bindec('00010'));
define('IKRN_VAR_ORIG_REQUEST',			bindec('00100'));
define('IKRN_VAR_ORIG_GLOBAL',			bindec('01000'));

define ('DBUG_DB', 		bindec ("00000001"));
define ('DBUG_INC', 	bindec ("00000010"));
define ('DBUG_VARS', 	bindec ("00000100"));
define ('DBUG_MODS', 	bindec ("00001000"));

class wolSesion {
	/*
	 * Configuracion General de la sesion 
	 */

	/**
    *Nombre de la App donde esta esta seccion
    */
	var $App_Name;

	/*
	 * Tablas de configuracion (esto tendria k estar en 1 sola tabla, pero weno 
	 */

	/**
   * Tabla donde estan todas las secciones
   */
	var $tb_secciones;

	/**
   * Tabla relacional entre Secciones y SubSecciones (screens)*/
	var $tb_sec_subsecc;

	/**
   * Tabla con las Sub-secciones (se tratan como si fuesen secciones)                    */
	var $tb_sub_secc;

	/**
   * Tabla que relaciona secciones(sub) con plantillas                              */
	var $tb_sub_plts;

	/**
   * Tabla donde estan todas las plantillas  */
	var $tb_plantillas;

	/**
   * Configuracion General del Kernel 
	*	register_globals 	-	Si el get ha de obtener las variables recibidas por QUERY_STRING (como si fueran de sesion)
	**/
	var $_aKrnConf = array (
		'register_globals' => FALSE,		// Si register_globals esta activado.
		'doc_root' => NULL,					// Ruta al virtualhost raiz de la aplicacion
		'locale_path' => NULL,				// Ruta al directorio de los msgs por idioma
		'locale_kernmsgs' => NULL,			// Fichero con los mensajes del Kernel. 
		'default_subsecc_fo' => NULL,		// Sub-Seccion por defecto del FO
		'default_subsecc_bo' => NULL,		// Sub-Seccion por defecto del BO
		'default_iface' => NULL,			// InterFace por Defecto
		'default_lang' => NULL,				// Idioma por Defecto
		'action_access' => FALSE,			// Control de acceso a acciones (bool: activacion)
		'default_theme' => NULL				// Tema por Defecto
			);

	/*
	 * RUTAS Y PATHS 
	 */

	/**
   * Directorio donde reside el document root */
	var $root_dir;

	/**
   * Directorio(relativo) de imagenes por subsec*/
	var $img_dir = "catalogo/";
	var $script_dir = "scripts/";	/* Directorio donde residen los scrips */

	/** Informacion de (SUB)Secciones **/

	/**
   * nombre identificativo de la seccion anterior
   * (aki faltaria con un nombre de visualizacion, hay k mirar a ver si esta contemplado en la tabla Sub_Secc, sino ponerlo. */
	var $old_secc_name;

	/**
   * id de la sub_secc anterior */
	var $old_secc;

	/**
   * QUERY_STRING de la seccion anterior
	 */
	var $old_secc_querystring;

	/**
   * Nombre de la seccion */
	var $seccion;

	/**
   * Tabla base de la seccion(subsecc) actual */
	var $tb_base;

	/**
     * Nombre de la seccion por defecto (obsolete)
	  */
	var $def_secc;

	/**
   * Id de la SUBseccion en la tabla de Sub_Secc */
	var $id_secc;

	/**
   * Nos indica si ha sido recargada la pg o no */
	var $bRecarga = 0;

	/*
	 * Informacion de Plantillas 
	 */

	/**
   * Una seccion puede tener varias plantillas */
	var $plantillas = array ();

	/**
   * Puntero a la plantilla que toca */
	var $plt_point = 0;

	/**
   * Puntero a la ultima plantilla */
	var $plt_point_end = 0;

	/**
   * Directorio de las plantillas */
	var $plt_dir;

	/**
   * Script donde estan las funciones que necesitan las plantillas */
	var $include;

	/**
   * Funciones a Ejecutar por las distintas Plantillas (pos 0 = pre_code, 1=post_code) */
	var $code = array (array ());

	/**
   * Nombre de variable (o array) de argumentos pasables a cada plantilla */
	var $plt_arg = array ();

	/**
	* Plantillas a Mostrar caso de solicitarse un punto de informacion no localizable */
	var $aNullPlt = NULL;

	/*
	 * LIBRERIAS LINCADAS : 
	 */
	/*
	 * Conexion DB 
	 */
	// var $db_conf;
	/*
	 * Objeto conexion a la db de configuracion 
	 */

	/**
   * Objeto de conexion a la base de datos   */
	var $db;
	/*
	 * Soporte Multiples conexiones db 
	 */

	/**
   * Array referencial de instancias wolDB  "nombre_de_conexion" => wolDB */
	var $dbs = array ();

	/**
   * Nombre de conexion db actual */
	var $db_name;

	/**
   * Soporte Conexiones Persistentes (reales)
   * Array referencial indicativo de conexion persistente  "nombre_de_conexion" => BOOL */
	var $dbs_pconn = array ();

	/*
	 * SOPORTE MODULOS * Tablas: Modulos y Modulos_SubSecc * Notas: * - Hay dos tipos de modulos. Los base y los de subsecciones.
	 * * - Los campos allow_mask y deny_mask de la tabla Modulos no son considerados * cuando se cargan los modulos base. * - La
	 * carga de modulos consta de 2 fases: Inclusion-Creacion(carga) e Inicializacion * - Justo despues de las conexiones DB se
	 * cargan los modulos base. * - Despues de la comprobacion de subseccion se cargan los modulos de subsecciones. * 
	 */

	var $modulos = array ();	  // class wolModule?

	/**
     * Jerarkia de Accesos 
	  */

	/**
	 * Objeto contenedor de la instancia de validacion (wolAV)
	 */
	var $Access = NULL;
	var $_aIfaces = array( 			// Lista de Ifaces/Idiomas/Temas Disponibles en la app actual
			'iface' => array(),		// Array de Tipos de iface 
			'lang' => array(),			// Array de Idiomas
			'tema' => array()			// Array de Temas
			);		
	var $_aActiveIface = array (  // Iface/idioma/tema activos 
			'iface' 	=> NULL,			// tipo de iface activo (id)
			'lang'	=> NULL,
			'tema'	=> NULL
			);

	/*
	 * Buscador 
	 */

	/**
    Objeto busqueda que nos indica el tipo de busqueda */
	var $b_activa = "";

	/**
   * Variable Booleana que nos indica si el  motor de buskedas esta activo o no         */
	var $hay_b = 0;

	/*
	 * Menus 
	 */

	/**
   * Nos indica si esta seccion tiene o no menus */
	var $hay_menu = 0;

	/*
    * OBJETO menu que nos contendra todos los menus 
	 */
	var $menu = "";

	/*
	 * Instancia de control de Errores y Mensajes.
	 */
	var $oMsgs = NULL;

	 /**
	 * Variable de control de depuracion.
	 * 1 - Depuracion de los procesos de bases de datos y sesiones.
	 */
	var $debug = 0;


	/** Seccion de datos miscelaneos */

	/**
   * Array de 2 dimensiones.
   Significado :
   *                             1(indice).- Indice del nombre de variable .
   *                             2(valor) .- valor de la variable */
	var $aData = array ();

	var $_aCrcCheck = array(		// Vector de Comprobaciones CRC32 sobre variables (GET y POST) y los tipos
			'var_name' => array(		//  Indexado por nombre de variable.
				'orig' => 0,			// 	Contiene el origen de la variable.
				'crckeys' => 0,		// 	CRC32 de las claves (si es una sequencia)
				'crcvalues' => 0,		// 	CRC32 del valor(es) de la variable
				'status_last' => 0	// 	Flags de estado con respecto a navegaciones anteriores (IKRN_VAR...)
				)
			);

	/**
   *Array de configuracion del site actual
   */
	var $configuracion = array (
			'def_secc' => NULL		// Subseccion por defecto.
			);

	/**
	  * Vector con plantillas de configuracion.
	  **/
	var $_aCfgPlts = array(
			'null' => NULL,			// Plt de 'plantilla no encontrada, o acceso denegado'
			'err_full' => NULL,		// Plt de Errores en los modulos (sustituye al pii-base)
			'err_pii' => NULL,		// Plt de Errores en el precode (sustituye el pii asociado al codigo fallido).
			'err_output' => NULL,	// Plt de salida de errores y mensajes.
			'emptysearch' => NULL	// Plt de salida de 'La busqueda no ha producido ningun resultado'
			);
		/**
        * Constructor
        * Constructor de sesiones
        *             Crea un objeto wol_db y lo conecta acorde a su configuracion
        * @param        $nombre  Nombre de sla aplicacion
        * @param        $var     Variable ke se crea en el index
        */
	function wolSesion ($nombre, $var) {
		$this->oMsgs = new IMessages();

		$this->App_Name = $nombre;

		$oDb = new wol_db($this->App_Name);
		// el new te crea un objeto ya conectado: $oDb->conecta();
		$this->set_db ("conf", $oDb);
		$this->activate_db ('conf');

		$this->_set_conf_tbs ();
		$this->_setKrnCfg();

		/*
		 * Compatibilidad hacia atras.
		 */
		$this->set_script_dir = $this->getFromConf("scripts_dir");
		$this->root_dir = $this->getFromConf('doc_root');
		$this->doc_root = $this->getFromConf('doc_root');
		$this->def_secc = $this->getFromConf('def_secc');

		$this->_setIfaceList();

		$this->obj_var_name = $var;

	}

					 /********** PROTOTIPOS DE FUNCIONES ***************

                ****** Soporte Conexiones DB *******
                wolDB get_db(string db_conn_name)
                                ---> obtiene la instancia wolDB referenciada por db_conn_name o NULL
                bool  set_db(string db_conn_name,objeto wolDB,bool persistente)
                                --> pconns para
                set_db_conn(string db_conn_name,wolDB)
                                --> Establece la instancia wolDB BASE(this->db) en wolSession (no la de configuracion)
                wolDB get_db_conn(string db_conn_name)
                                --> obtener conexion actual O la conexion base(this->db)
                set_db(string db_conn_name,wolDB oDb)
                                --> establecer conexion actual O la base(this->db)
                wolDB get_db(string db_conn_name)
                                --> obtener instancia wolDB con el nombre <db_conn_name>
                reset_db(db_conn_name)
                                --> elimina la conexion del array de instancias wolDB
                string get_dbconname()
                                --> Obtener el nombre de la conexion actual.
                activate_db(string db_conn_name)
                                --> estable la db activa
                restore_dbspoints()
                                --> resetea puntero wolDB s a NULL para obtener wolDB base
                cerrar_dbs()
                                --> arregla todas las instancias wolDB para ser guardadas en la sesion
                conectar_dbs(db_conn_type)
                                --> reconecta TODAS las instancias wolDB si no coincide tipo con 'data' o 'conf'.
                                Caso de coincider conecta data o conf.
                *********************************


                ****** Soporte de Modulos *******
                load_internal_modules()


                **************************************************/

					 /**************** INIT ******************/

	/**
	* Obtenemos los parametros de configuracion del kernel.
	**/
	function _setKrnCfg () {
		$BACKOFFICE = wolSesion::fetchVar('BACKOFFICE','GLOBAL');

		$db = $this->get_db('conf');
		if (!is_object ($db)) return FALSE;

		if (is_array($this->_aKrnConf) AND sizeof($this->_aKrnConf)) {
			$tmpcons = NULL;
			foreach ($this->_aKrnConf as $var => $none) {
				// Ojito que esto crea dependencia severa con Zend
				$tmp = ini_get($var);
				if (empty($tmp) AND !is_numeric($tmp)) {
					//Ahora una sola query. $tmp = $db->read_main_value ('krncfg_'.$var);
					$tmpcons .= ((!empty($tmpcons)) ? ' OR ' : ' ').'nombre = "krncfg_'.$var.'"';
				} elseif (isset($tmp)) {
					$this->_aKrnConf[$var] = $tmp;
				}
				$tmp = NULL;
			}
			if (!empty($tmpcons)) {
				$cons = 'SELECT nombre,valor FROM _main WHERE '.$tmpcons;
				$cfgrs = $db->query($cons);
				if ($db->num_rows($cfgrs)) 
					while($aTmp = $db->fetch_assoc($cfgrs)) 
						$this->_aKrnConf[substr($aTmp['nombre'],7)] = $aTmp['valor'];
				$db->libera($cfgrs);
				$cfgrs = NULL;
			}
		}

		if (is_array($this->_aCfgPlts) AND sizeof($this->_aCfgPlts)) {
			$tmpcons = NULL;
			foreach ($this->_aCfgPlts as $var => $none) {
				$tmpcons .= ((!empty($tmpcons)) ? ' OR ' : ' ').'nombre = "pltcfg_'.$var.'"';
			}
			if (!empty($tmpcons)) {
				$cons = 'SELECT nombre,valor FROM _main WHERE '.$tmpcons;
				$cfgrs = $db->query($cons);
				if ($db->num_rows($cfgrs)) {
					$aPltSearch = array();
					$aPltVars = array();	// el valor indice corresponde a N variables de configuracion (vector valor)
					while($aTmp = $db->fetch_assoc($cfgrs)) {
						if (!in_array($aTmp['valor'],$aPltSearch)) {
							array_push($aPltSearch,$aTmp['valor']);
						}
						if (!is_array($aPltVars[$aTmp['valor']])) $aPltVars[$aTmp['valor']] = array();
						array_push($aPltVars[$aTmp['valor']],substr($aTmp['nombre'],7));
					}

					if (is_array($aPltSearch) AND sizeof($aPltSearch)) {
						$tmpcons = NULL;
						foreach ($aPltSearch as $plt) 
							$tmpcons .= ( (!empty($tmpcons)) ? ' OR ' : ' ' ).( (is_numeric($plt)) ? 'id_plantilla = '.$plt : 'nombre = "'.$plt.'"' );

						if (!empty($tmpcons)) {
							$cons = "SELECT id_plantilla,nombre,pre_code,post_code,arg_var FROM Plantillas WHERE ".$tmpcons;
							$rs = $db->query ($cons);
							if ($db->num_rows ($rs)) {
								while ($aPlt = $db->fetch_assoc($rs)) {
									if (is_array($aPltVars[$aPlt['id_plantilla']])) {
										$fld = 'id_plantilla';
									} elseif (is_array($aPltVars[$aPlt['nombre']])) {
										$fld = 'nombre';
									} else $fld = NULL;

									if (!empty($fld)) 
										while (sizeof($aPltVars[$aPlt[$fld]])) 
											$this->_aCfgPlts[array_shift($aPltVars[$aPlt[$fld]])] = $aPlt;
								}
							}
							$db->libera($rs);
						}
					}

				}
			}
		}

		// Obtener via aKrnConf (todo)
		$this->configuracion['set_script_dir'] = $db->read_main_value ("scripts_dir");
		$this->configuracion['root_dir'] = $db->read_main_value ("doc_root");

		if ($BACKOFFICE) {
			$this->configuracion['def_secc'] = $this->_aKrnConf['default_subsecc_bo'];
		} else {
			$this->configuracion['def_secc'] = $this->_aKrnConf['default_subsecc_fo'];
		}

		if (!is_object($this->oMsgs)) $this->oMsgs = new IMessages();
		if (!empty($this->_aKrnConf['locale_path'])) $this->oMsgs->setPath($this->_aKrnConf['locale_path']);
		if (!empty($this->_aKrnConf['locale_kernmsgs'])) $this->oMsgs->addModule('IKernel',$this->_aKrnConf['locale_kernmsgs'],TRUE);

		// Cargando los posibles modulos de la aplicacion.
		$cons = 'SELECT '.
					'id_modulo as "id_modulo", '.
					'nombre as "nombre", '.
					'base as "es_base", '.
					'source as "src_file", '.
					'class as "class" '.
					'FROM Modulos '.
					'ORDER BY base desc;';
		$idrs = $db->query ($cons);
		if ($db->num_rows ($idrs)) 
			while ($aMod = $db->fetch_assoc($idrs)) {
				$idxm = (!empty($aMod['nombre']) ? $aMod['nombre'] : $aMod['id_modulo']);
				$this->_aModulos[$idxm] = $aMod;
			}

		return TRUE;
	}

	function _setIfaceList() {
		$oDb = $this->get_db('conf');

		/** Obtencion de Ifaces disponibles **/
		$cons = 'SELECT * FROM Tipos_iface';
		$tmprs = $oDb->query($cons);
		if ($oDb->num_rows($tmprs)) {
			while ($aTmp = $oDb->fetch_assoc($tmprs)) {
				$this->_aIfaces['iface'][$aTmp['id_tipo_iface']]['id'] = $aTmp['id_tipo_iface'];
				$this->_aIfaces['iface'][$aTmp['id_tipo_iface']]['nombre'] = $aTmp['nombre'];
				$this->_aIfaces['iface'][$aTmp['id_tipo_iface']]['nemonico'] = $aTmp['nemonico'];
				$this->_aIfaces['iface'][$aTmp['id_tipo_iface']]['path'] = $aTmp['path'];
				if ((int)$aTmp['var_func']) 
					$this->_aIfaces['iface'][$aTmp['id_tipo_iface']]['func'] = $aTmp['util_deteccion'];
				else 
					$this->_aIfaces['iface'][$aTmp['id_tipo_iface']]['var'] = $aTmp['util_deteccion'];
			}
		}
		$oDb->libera($tmprs);

		/** Obtencion de Idiomas disponibles **/
		$cons = 'SELECT * FROM Idiomas';
		$tmprs = $oDb->query($cons);
		if ($oDb->num_rows($tmprs)) {
			while ($aTmp = $oDb->fetch_assoc($tmprs)) {
				$this->_aIfaces['lang'][$aTmp['id_idioma']]['id'] = $aTmp['id_idioma'];
				$this->_aIfaces['lang'][$aTmp['id_idioma']]['nombre'] = $aTmp['nombre'];
				$this->_aIfaces['lang'][$aTmp['id_idioma']]['nemonico'] = $aTmp['nemonico'];
				$this->_aIfaces['lang'][$aTmp['id_idioma']]['path'] = $aTmp['path'];
				if ((int)$aTmp['var_func']) 
					$this->_aIfaces['lang'][$aTmp['id_idioma']]['func'] = $aTmp['util_deteccion'];
				else 
					$this->_aIfaces['lang'][$aTmp['id_idioma']]['var'] = $aTmp['util_deteccion'];
			}
		}
		$oDb->libera($tmprs);

		/** Obtencion de Temas disponibles **/
		$cons = 'SELECT * FROM Temas';
		$tmprs = $oDb->query($cons);
		if ($oDb->num_rows($tmprs)) {
			while ($aTmp = $oDb->fetch_assoc($tmprs)) {
				$this->_aIfaces['tema'][$aTmp['id_tema']]['id'] = $aTmp['id_tema'];
				$this->_aIfaces['tema'][$aTmp['id_tema']]['nombre'] = $aTmp['nombre'];
				$this->_aIfaces['tema'][$aTmp['id_tema']]['nemonico'] = $aTmp['nemonico'];
				$this->_aIfaces['tema'][$aTmp['id_tema']]['style_sheet'] = $aTmp['style_sheet'];
				if ((int)$aTmp['var_func']) 
					$this->_aIfaces['tema'][$aTmp['id_tema']]['func'] = $aTmp['util_deteccion'];
				else 
					$this->_aIfaces['tema'][$aTmp['id_tema']]['var'] = $aTmp['util_deteccion'];
			}
		}
		$oDb->libera($tmprs);

	}

	function _fillIfaceWithDefaults() {
		// Si no hay un Iface definido, buscamos el predefinido del sistemal.
		$aI = $this->get_iface();
		$bSet = FALSE;
		// Si falta algun parametro que afecte a rutas...
		if (!is_array($aI) OR (!sizeof($aI['iface'])) OR (!sizeof($aI['lang'])) ) {
			$def_lng = $this->_getKrnCfg('default_lang');
			$def_ifc = $this->_getKrnCfg('default_iface');
			$def_thm = $this->_getKrnCfg('default_theme');
			if (!empty($def_lng) OR !empty($def_ifc) OR !empty($def_thm)) {
				if ($this->debug) debug("_fillIfaceWithDefaults(); CHeking ifaces ...");
				$aTmp = array();
				// Metemos en un array temporal el iface ya obtenido.
				if (is_numeric($aI['lang']['id'])) $aTmp['lang'] = $aI['lang']['id'];
				if (is_numeric($aI['iface']['id'])) $aTmp['iface'] = $aI['iface']['id'];
				if (is_numeric($aI['theme']['id'])) $aTmp['theme'] = $aI['theme']['id'];
				// Si falta algun aspecto del iface en el que hemos obtenido, lo sustiumos por su valor por defecto.
				if (!is_numeric($aTmp['lang']) AND !empty($def_lng)) {
					$bSet = TRUE;
					$aTmp['lang'] = $def_lng;
				}
				if (!is_numeric($aTmp['iface']) AND !empty($def_ifc)) {
					$bSet = TRUE;
					$aTmp['iface'] = $def_ifc;
				}
				if (!is_numeric($aTmp['theme']) AND !empty($def_thm)) {
					$bSet = TRUE;
					$aTmp['theme'] = $def_thm;
				}
				if ($bSet) {
					if ($this->debug) debug("_fillIfaceWithDefaults(); Setting def ifaces ...");
					$this->set_iface($aTmp);
				}
			}
		}
		return !$bSet;
	}

	/**
	* Obtenemos los parametros de configuracion del kernel.
	**/
	function _getKrnCfg ($var = NULL) {
		if (!is_array ($this->_aKrnConf) OR !sizeof ($this->_aKrnConf)) return NULL;
		if (isset($var) AND !empty($var)) {
			return $this->_aKrnConf[$var];
		} else return $this->_aKrnConf;
	}

	function getFromKrn($var = NULL) {
		if (!is_array ($this->_aKrnConf) OR !sizeof ($this->_aKrnConf)) return NULL;
		if (isset($var) AND (!empty($var) OR is_numeric($var)) ) {
			return $this->_aKrnConf[$var];
		} else return NULL;
	}

	function getFromConf($var = NULL) {
		if (!is_array ($this->configuracion) OR !sizeof ($this->configuracion)) return NULL;
		if (isset($var) AND !empty($var)) {
			return $this->configuracion[$var];
		} else return $this->configuracion;
	}

		  /**
        * Poner tablas de configuracion
        * @param       $tabla vale pa algo ???
        */
	function _set_conf_tbs ($tabla = "") {
		// global $oDb;
		$oDb = $this->get_db('conf');
		$this->tb_secciones = $oDb->read_main_value ("tb_secciones");
		$this->tb_plantillas = $oDb->read_main_value ("tb_plantillas");
		$this->tb_sub_secc = $oDb->read_main_value ("tb_sub_secc");
		$this->tb_sec_subsecc = $oDb->read_main_value ("tb_sec_subsecc");
		$this->tb_sub_plts = $oDb->read_main_value ("tb_sub_plts");
		$this->tb_modulos = $oDb->read_main_value ("tb_modulos");
		$this->tb_modulos_subsecc = $oDb->read_main_value ("tb_modulos_subsecc");

		return;
	}

		  /**
        *Coger configuracion de tablas
        *"secciones"                             => $this->tb_secciones,
        *"sub_secciones"                         => $this->tb_sub_secc,
        *"sec_subsecc"                           => $this->tb_sec_subsecc,
        *"subsecc_plantillas"                    => $this->tb_sub_plts,
        *"plantillas"                            => $this->tb_plantillas
        *      @return  un array asociativo con los nombres de las tablas
        */
	function get_conf_tbs () {
		$oDb = $this->get_db ('conf');
		return array ("secciones" => $this->tb_secciones,
						  "sub_secciones" => $this->tb_sub_secc,
						  "sec_subsecc" => $this->tb_sec_subsecc,
						  "subsecc_plantillas" => $this->tb_sub_plts,
						  "plantillas" => $this->tb_plantillas
			);
	}

	/**
	  * FixMe: Esta funcion se llama justo antes de unserializar la sesion. Lo que esta habra de hacer es incluir y unserializar los modulos
	  *   y sus variables. Para ello, no se puede dejar al php que lo haga, dado que logicamente lo hace en orden ascentente por profundidad, con lo cual,
	  *   al ser esta la ultima clase que se despierta, no puede incluir los scripts necesarios para despertar las clases que le cuelgan.
	  *		En primera instancia se me ocurre como solucion que el metodo cerrar, despues de cerrar() sus clases, las serialice el mismo en un string y luego 
	  * 	las guarde para recuperarlas con el __wakeup() e iniciarlas con el load_modules(). Las ventajas que esta solucion icorpora es que permite conocer
	  *	que variables/clases -que suele ser lo mas pesado- pertenecen a que sesiones, y que permite una carga selectiva de clases por subseccion, de tarl forma que 
	  *	las instancias que no se necesiten en una determinada subseccion no se cargen.
	  *		Otra posibilidad es tener una clase padre al mas purto estilo 'Serializable' de java, de la cual han de heredar todas las intancias que quieran 
	  *	ser serializables por el kernel. Este 'soporte', caso de ser posible, seria mas ligero que andar haciendo comprobaciones para las clases. Esta dudo 
	  * 	que sea posible, a no ser que el wake_up del padre se ejecute antes que el del hijo, y se puede hacer el include en se momento.
	  **/
	function __wakeup () {
		// debug("wakeup de sesion...".$this->obj_var_name);
		if (is_array($this->_aModulos))
			foreach ($this->_aModulos as $name => $aMod) {
				// if ($this->debug & DBUG_MODS) debug("__wakeup(): marcando $name... $aMod[src_file]");
				// FIXME: serializar o incluir los modulos antes?
				// FIXME: Soporte de modulos todavia incompleto.
				// include_inm("modulos/".$this->_aModulos[$name]['src_file'].'.inc');
				$this->_aModulos[$name]['incluido'] = 1;
			}

		return 1;					  // Fixme: El soporte de modulos no funciona correctamente. (inclusion de las clases)
	}

	/** soporte email **/
	function _setStdOutMod($modname) {
		if (!empty($modname)) {
			$modname = strtolower($modname);
			switch($modname) {
				case 'email':
					$email = $this->fetchVar('_email','POST');
					$subj = $this->fetchVar('_subject','POST');
					$this->set_var('__output__email',$email,'INMED');
					if (!empty($subj)) $this->set_var('__output__email__subject',$subj,'INMED');
					$this->set_var('__output__browser',TRUE,'INMED');
					$this->set_var('__output__handle','emailoutput','INMED');
					$this->set_var('__output__finish','emailsender','INMED');
					$this->set_var('__output__name','email','INMED');
					$mod = 'email';
			}
		}

		if (!empty($mod)) $this->set_var('__output__',$mod,'INMED');
		else $this->unset_var('__output__');
	}

	/** 
	  * Metodo encargado de informar el formato de salida de datos:
	  *
	  * @return 	- 	[bBrowser] 	=> bool		Si la salida tambien ha de mandarse al navegador.
	  *					[ModName] 	=> string	Nombre de modulo de salida.
	  *					[handler] 	=> string	Nombre de la funcion que maneja la salida.
	  *					[finish] 	=> string	Nombre de funcion de cierre de salida.
	  **/
	function _getStdOutMod($modname = NULL) {
		$n = $this->get_var('__output__');
		$aRetVal = NULL;
		if (!empty($n)) {
			$aRetVal['bBrowser'] = (bool)$this->get_var('__output__browser');
			$aRetVal['ModName'] = $this->get_var('__output__name');
			$aRetVal['handler'] = $this->get_var('__output__handle');
			$aRetVal['finish'] = $this->get_var('__output__finish');
		}
		return $aRetVal;
	}
  /** **/


	/*
	 * Init nos va a buscar en la db nuestra seccion 
	 */
	function init ($seccion) {
		global $force_;			  // Forzamos la recarga de todas las plantillas de subseccion?
		// Definiciones de mascaras de control de Debug:

		$this->debug = DBUG_DB | DBUG_INC ;
		$this->debug = (DBUG_INC | DBUG_VARS) ;
		$this->debug = (DBUG_DB | DBUG_INC) ;
		$this->debug |= (DBUG_MODS ) ;
		$this->debug |= (DBUG_VARS | DBUG_INC);
		$this->debug = (DBUG_VARS );
		$this->debug = 0;

				/**** Conectamos los objetos wolDB que tenemos almacenados ****/
		$this->conectar_dbs ('conf');

				/**** Cargamos los Modulos Internos *****/
		// $this->load_internal_modules();

				/*** comprobaciones de secciones y subsecciones ****/
		if (empty ($this->tb_secciones)) {
			$this->perror(1,'KERNEL_CONF','Error interno de configuracion, Leaks en las sesiones');
			return 0;
		}

		/** soporte email **/
		$stdout = $this->fetchVar('__stdout__','GET');
		if (!empty($stdout)) $this->_setStdOutMod($stdout);
		/** **/

		if (empty ($this->seccion)) {
			/*
			 * Si ta vacia la seccion, acabamos de entrar y por tanto entramos por la seccion por defecto. 
			 */
			if ($this->debug & DBUG_MODS)
				debug ("Seccion por defecto: $this->def_secc($seccion) - $this->seccion");
			if (empty ($seccion))
				$seccion = $this->def_secc;

			// Acuerdate de Traerte el parche de 'acceso directo a subsecciones' de postalfree variable en config.php
			$this->set_idsecc ($seccion, TRUE);

			$this->set_plts();
			$this->bRecarga = 0;
			//$this->hay_b=0;
			//salida("Acabas de entrar en $seccion<BR>\n");
		} elseif (empty ($seccion) OR ! isset ($seccion)) {
			/*
			 * Si la seccion esta vacia (pero this->seccion no) entonces Estamos paginando(recargando estando un modulo en marcha) y 
			 * se conservan las plts 
			 */
			if ($this->debug & DBUG_MODS)
				debug ("Param-Seccion Vacia. Busqueda : ".(($this->hay_b) ? "Si" : "No"));

			// old_secc_name nuevo. documentar
			if (!empty($this->old_secc_name)) {
				if (!$this->kick_the_baby ()) {
					// Si no hay busqueda, porque recarga la anterior?
					$seccion = $this->old_secc_name;
					$this->set_idsecc($seccion);
					//salida("renice - Old_Secc : ".$this->old_secc_name."<BR>\n" );
					// unset($this->old_secc_name);
				} else {
					$seccion = $this->seccion;
					$this->set_idsecc ($seccion);
				}

				$this->reset_plts ();
				$this->set_plts ();
			} else {
				//salida("Establecemos old_secc_name (".$this->seccion.")");
				$seccion = $this->seccion;
			}
			$this->bRecarga = 2;
			if ($this->debug & DBUG_MODS)
				debug ("Recarga de Modulo ($this->bRecarga) o Paginado ");
		} elseif (!strcmp ($seccion, $this->seccion)) {
			/*
			 * Si seccion y this->seccion son =, entonces se ha producido una recarga de la pagina. conservamos las plts * -ojo- 
			 */
			if ($this->debug & DBUG_MODS)
				debug ("Recarga(1) de subseccion");
			$this->bRecarga = 1;
			$this->set_idsecc ($seccion);
			// $this->set_pltdir();
			// unset($this->plantillas);
			if ($force_) {
				// unset($this->plantillas);
				$this->set_plts ();
			}
			/*
			 * tb limpiamos las buskedas * if ($this->debug & DBUG_MODS) debug("Unset de buskedas.(no se pk)"); $this->hay_b = 0;
			 * $this->b_activa = NULL; unset($this->b_activa); /** *
			 */
			// $this->hay_b = 0;
			//salida("Has recargao... a k si!<BR>\n");
		} else {
			/*
			 * Unico caso k nos keda, cambio de seccion. Limpiamos plts 
			 */
			if ($this->debug & DBUG_MODS)
				debug ("Cambiaaaaaando de Seccion (act:$seccion -> old:$this->seccion - $this->id_secc)");
			$this->reset_plts ();
			$this->bRecarga = 0;
			$this->unset_vars ("SUBSECCION");

			$this->set_idsecc ($seccion);
			$this->set_plts ();

		}

/**** Conectamos la conexion de Datos *****/
		$this->conectar_dbs ("data");
		$this->activate_db ('conf');

		$this->set_var('_krn_ss_name',$this->get_subsecc_name(),'INMED');
		$this->set_var('_krn_old_ss_name',$this->get_old_subsecc_name(),'INMED');
		$this->set_var('_krn_ss_querystring',$this->get_subsecc_querystring(),'INMED');

				/** Miramos a ver los accesos para esta seccion ** (off) */
		if (!is_object($this->Access)) {
			// Reemplazar obj_var_name por App_Name cuando estos coincidan.
			$this->Access = new wolAV ($this->obj_var_name);
		}

		$this->detect_ifaces();

		if (!$this->Access->init ($this)) {
			$this->activate_db ('data');
			$this->_fillIfaceWithDefaults();
			$this->set_pltdir();
			return 0;
		}

		// Algun modulo puede necesitar alguna DB, las conectamos todas.
		$this->conectar_dbs("el_resto");

		// Soporte de Modulos:
		$this->load_modules();

		/*
		 * Este metodo nos va a establecer la ruta del iface que esta activo.
		 */
		$this->_fillIfaceWithDefaults();
		$this->set_pltdir();

		// Si se ha producido algun error (Al cargar los modulos por ejemplo)..
		if ($this->oMsgs->haveCode(IM_FATALERROR)) {
			$pltpii = $this->get_plt_name(0);
			if (!empty($pltpii)) {
				$this->change_plt_precode($pltpii,
					$this->_aCfgPlts['err_full']['nombre'],
					$this->_aCfgPlts['err_full']['pre_code'],
					$this->_aCfgPlts['err_full']['post_code'],
					$this->_aCfgPlts['err_full']['arg_var']
						);
				$this->perror_link('LOGOUT');
			}
		}

		/** Incluimos los includes **/
		$this->includes();

					  /********** MODULOS *************/

	  /** Inicializamos el buscador (si procede) */
		if (!is_object ($this->b_activa)) {
// debug("bactiva no es un objeto<BR>\n");
			$this->b_activa = new wol_search ($this->App_Name);
//salida("como tengas algo te parto las piernas ".$this->b_activa->iden_busq."<BR>\n");
		}
// debug("Es en el buscador :O");
		$this->hay_b = $this->b_activa->init ($this);
// debug("!ojo que buscador devuelve ".$this->hay_b."<BR>\n");

				/** Inicializamos los Menus *
				if (!is_object($this->menu))
												 $this->menu = new wol_menu($this->App_Name);
				$this->hay_menu = $this->menu->init($this);
				*/
		$this->hay_menu = 0;

				/** Inicializamos las Notificaciones **
				if (!is_object($this->notifica))
												 $this->notifica = new wol_notifica($this->App_Name);
				$this->hay_noti = $this->notifica->init($this);
				/* */

				/**** Conectamos la conexion de Datos *****/
		$this->activate_db ('data');

		return TRUE;
	}

					 /********** Comprobaciones de init() ***************/

	/*
	 * pandora 
	 */
	function detect_ifaces() {

		$retval = FALSE;
		/** Detectando Iface **/
		foreach ($this->_aIfaces['iface'] as $aIface) {
			if (!empty($aIface['var']) AND !empty($aIface['nemonico'])) {
				$val = $this->fetchVar($aIface['var'],'GET');
				if (empty($val)) $val = $this->fetchVar($aIface['var'],'POST');
				if (!strcasecmp($val,$aIface['nemonico'])) {
					$aI['iface'] = $aIface['id'];
					$retval = TRUE;
					break;
				}
			}
		}

		/** Detectando Idioma **/
		foreach ($this->_aIfaces['lang'] as $aLang) {
			if (!empty($aLang['var']) AND !empty($aLang['nemonico'])) {
				$val = $this->fetchVar($aLang['var'],'GET');
				if (empty($val)) $val = $this->fetchVar($aLang['var'],'POST');
				if (!strcasecmp($val,$aLang['nemonico'])) {
					$aI['lang'] = $aLang['id'];
					$retval = TRUE;
					break;
				}
			}
		}

		/** Detectando Tema **/
		foreach ($this->_aIfaces['tema'] as $aTema) {
			if (!empty($aTema['var']) AND !empty($aTema['nemonico'])) {
				$val = $this->fetchVar($aTema['var'],'GET');
				if (empty($val)) $val = $this->fetchVar($aTema['var'],'POST');
				if (!strcasecmp($val,$aTema['nemonico'])) {
					$aI['tema'] = $aTema['id'];
					$retval = TRUE;
					break;
				}
			}
		}

		if (is_array($aI) AND sizeof($aI)) $this->set_iface($aI);

		return $retval;
	}

	function set_iface($aIface = array()) {
		if (!sizeof($aIface) OR !is_array($aIface)) return 0;

		foreach ($aIface as $type => $value) {
			if (!empty($value) AND !is_numeric($value)) {
				if (is_array($this->_aIfaces[$type]) AND sizeof($this->_aIfaces[$type])) {
					$tmp = NULL;
					foreach ($this->_aIfaces[$type] as $id => $aIn) {
						if ($aIn['nemonico'] == $value) {
							$tmp = $id;
							break;
						}
					}
					$aIface[$type] = $tmp;
				}
			}
		}

		if (is_numeric($aIface['iface']) AND is_array($this->_aIfaces['iface'][$aIface['iface']])) {
			$this->_aActiveIface['iface'] = $aIface['iface'];
		}
		if (is_numeric($aIface['lang']) AND is_array($this->_aIfaces['lang'][$aIface['lang']])) {
			$this->_aActiveIface['lang'] = $aIface['lang'];
			if (!is_object($this->oMsgs)) {
				$this->oMsgs = new IMessages();
				//TODO: Anyadir mensaje de error: perdida de clase de msgs.
			}
			$this->oMsgs->setLocale($this->_aIfaces['lang'][$aIface['lang']]['nemonico']);
		}
		if (is_numeric($aIface['tema']) AND is_array($this->_aIfaces['tema'][$aIface['tema']])) {
			$this->_aActiveIface['tema'] = $aIface['tema'];
		}

	}

	function get_iface($aIDs = NULL) {
		if (!is_array($aIDs) OR !sizeof($aIDs)) 
			$aIDs = $this->_aActiveIface;

		foreach ($aIDs as $type => $value) {
			if (!empty($value) AND !is_numeric($value)) {
				if (is_array($this->_aIfaces[$type]) AND sizeof($this->_aIfaces[$type])) {
					$tmp = NULL;
					foreach ($this->_aIfaces[$type] as $id => $aIn) {
						if ($aIn['nemonico'] == $value) {
							$tmp = $id;
							break;
						}
					}
					$aIDs[$type] = $tmp;
				}
			}
		}

		if (is_array( $this->_aIfaces['iface'][$aIDs['iface']]) AND sizeof( $this->_aIfaces['iface'][$aIDs['iface']]))
			$aI['iface'] =  $this->_aIfaces['iface'][$aIDs['iface']];
		if (is_array( $this->_aIfaces['lang'][$aIDs['lang']]) AND sizeof( $this->_aIfaces['lang'][$aIDs['lang']]))
			$aI['lang'] =  $this->_aIfaces['lang'][$aIDs['lang']];
		if (is_array( $this->_aIfaces['tema'][$aIDs['tema']]) AND sizeof( $this->_aIfaces['tema'][$aIDs['tema']]))
			$aI['tema'] =  $this->_aIfaces['tema'][$aIDs['tema']];
		return $aI;
	}

	 /**
	 *  Coger el usuario activo
	 *  @return  identificador del usuario activo (como no)
	 */
	function get_user () {
		$a = $this->Access->oUsr->id_usr;
		// debug("usr =". $a);
		return $a;
	}

	function get_authed_user () {
		return $this->Access->oUsr;
	}

			/**
         * nos dice si seguimos en esta seccion o cambiamos
         * Cuando la variable seccion no esta establecida
         * @return $this->hay_b
         */
	function kick_the_baby () {
		return $this->hay_b;
	}

		  /** 
		  	 * Carga la configuracion de los modulos.
			 **/
	function load_modules () {	  // Fixme: Documentar estos metodos.
		if ($this->debug & DBUG_MODS)
			debug ("load_modules() ...");
		if (!is_array($this->_aModulos) OR !sizeof($this->_aModulos)) return TRUE;

		foreach ($this->_aModulos as $idxm => $aMod) {
			if ($this->debug & DBUG_MODS)
				debug ("load_modules( Incluido $aMod[nombre] - $aMod[class] ($aMod[src_file]) ) ...");
			// Aqui se deberia comprobar si es persistente o no. Actualmente se toman todos como persistentes.
			if (!(int) $this->_aModulos[$idxm]['incluido']) {
				//TODO: Actualmente no esta soportada la feature de inclusion de modulos a causa
				//	del comportamiento de la sesion al intentar poblar una estructura/clas no incluida todavia:
				// include_inm ("modulos/".$this->_aModulos[$idxm]['src_file'].'.inc');

				$this->_aModulos[$idxm]['incluido'] = 1;
			}
			if (!$this->oMsgs->getModuleInfo($aMod['nombre'])) {
				// Anyadimos el fichero de mensajes.
				$this->oMsgs->addModule($aMod['nombre'],$this->_aModulos[$idxm]['src_file'].'.lm',TRUE);
			}
		}

		if (is_array($this->_aClasses))
			foreach ($this->_aClasses as $var_name => $aCont) {
			if ($this->debug & DBUG_MODS)
				debug ("init de $var_name ... ");
			if (is_object($this->_aClasses[$var_name][0]))
				$this->_aClasses[$var_name][0]->init();
			// print_r($this->_aClasses[$var_name][0]);
			}
		// debug("comprobacion extra...");
		// $this->unload_modules();
		return TRUE;
	}

	/***
		* Prepara los modulos para ser Guardados en Sesion.
		***/
	function unload_modules () {
		if ($this->debug & DBUG_MODS)
			debug ("unload_modules() ...");

		if (is_array ($this->_aClasses))
			foreach ($this->_aClasses as $var_name => $aCont) {
				if ($this->debug & DBUG_MODS)
					debug ("unload_modules($var_name $aCont[0]) ... (nada)");
				if (is_object ($this->_aClasses[$var_name][0])) {
					if ($this->debug & DBUG_MODS) debug("disparando cierre de $var_name ");
					$this->_aClasses[$var_name][0]->cerrar ();
				}
			} 
		else if ($this->debug & DBUG_MODS)
			debug ("No hay NINGUNA clase de modulo");
		if (is_array ($this->_aModulos))
			foreach ($this->_aModulos as $mod => $aVal) {
				$this->_aModulos[$mod]['incluido'] = 0;
				if ($this->debug & DBUG_MODS) debug("unload_module($mod)::incluido = 0");
			}

	}

	/***
	  * Devuelve TRUE si la clase indicada pertenece a una clase de modulo.
	  **/
	function check_class_module ($class_name = NULL) {
		if (empty ($class_name))
			return FALSE;
		if (!class_exists ($class_name))
			return FALSE;
		$retval = FALSE;
		if (is_array ($this->_aModulos))
			foreach ($this->_aModulos as $nombre => $aMod)
				if (!strcasecmp ($aMod['class'], $class_name)) {
					$retval = TRUE;
					break;
				}
		if ($this->debug & DBUG_MODS)
			debug ("check_class_module($class_name) Found ? = ".(($retval) ? "Si" : "No"));
		return $retval;
	}


	/********** RUTAS y PATHS *********************/

		  /**
        * Hacemos los include propio de esta seccion
        */
	function includes () {

								 /** Hacemos los include propio de esta seccion **/
		$inc = $this->get_include ();
		if (!empty ($inc)) {
			// $tmp = $this->get_doc_root()."scripts/".$inc;
			$tmp = $this->get_script_dir ();
			$tmp .= $inc;
			if ($this->debug & DBUG_INC)
				debug ("include-> $tmp");
			include_inm ($tmp);
		}
	}

	/**
   *      Coger el directorio relativo donde se encuentran los scripts
   *      @return $this->script_dir
   */
	function get_script_dir () {
		return $this->script_dir;
	}

	/**
   *      establecer el directorio relativo donde se encuentran los scripts
   *      @return BOOL
   */
	function set_script_dir ($path = NULL) {
		if (!$path)
			return 0;
		$this->script_dir = $path;
		return 1;
	}

	/**
   *      Coger include
   *      @return $this->include
   */
	function get_include () {
		return $this->include;
	}

	/**
   *      Coger directorio raiz
   *      @return  un string con el nombre del directorio raiz
   */
	function get_doc_root () {
		return $this->root_dir;
	}

	/**
   *      Coger directorio de imagenes
   *      @return  un string con el nombre relativo del directorio de imagenes
   */
	function get_img_path () {
		return $this->img_dir;
	}

	/**
   * Introduce el path de las plantilas
   * TODO: k sea a la db-conf
   * @param $path ruta , sin path lo va a buscar a la db.
   */
	function set_pltdir ($path = "") {
		if (!empty ($path))
			$this->plt_dir = $path;
		else {
			// global $oDb;
			$oDb = $this->get_db ("conf");
			if (!$this->id_secc)
				$this->set_idsecc();
			if (!$this->id_secc)
				$this->errores ("Error Interno");

			$consulta = "SELECT plt_dir FROM ".$this->tb_secciones;
			$consulta .= " WHERE nombre ='".$this->seccion."'";
			$id = $oDb->query ($consulta);
			$aSecc = $oDb->fetch_array ($id);
			if (empty ($aSecc[0]) OR ! strcmp ($aSecc[0], "NULL")) {
				$oDb->libera ($id);
				$consulta = "SELECT valor FROM _main WHERE nombre='plt_dir'";
				$id = $oDb->query ($consulta);
				$aTmp = $oDb->fetch_array ($id);
				$oDb->libera ($id);
				$base_path = $aTmp[0];
			} else {
				$base_path = $aSecc[0];
			}

			$path = $base_path;
			$aI = $this->get_iface();

			if (is_numeric($aI['iface']['id']) AND is_array($this->_aIfaces['iface'][$aI['iface']['id']])) {
				if (!empty($this->_aIfaces['iface'][$aI['iface']['id']])) 
					$path .= ((!empty($path)) ? '/' : '').$this->_aIfaces['iface'][$aI['iface']['id']]['path'];
			}
			if (is_numeric($aI['lang']['id']) AND is_array($this->_aIfaces['lang'][$aI['lang']['id']])) {
				if (!empty($this->_aIfaces['lang'][$aI['lang']['id']])) 
					$path .= ((!empty($path)) ? '/' : '').$this->_aIfaces['lang'][$aI['lang']['id']]['path'];
			}

			$this->plt_dir = $path.'/';
		}
		return;
	}

	/**
   *      Coger directorio de plantillas
   *      @return  un string con el nombre relativo  del directorio de slas plantilas
   */
	function get_pltdir () {
		return $this->plt_dir;
	}

	/********** CONFIGURACION GENERAL *****************/

	/*
	 * documentar -motor plantillas, comentado :??- 
	 */

	/**
   * Coger las tablas base
   * @return   $this->tb_base
   */
	function get_tb_base () {
		return $this->tb_base;
	}

	function get_id_subsecc () {
		return $this->id_secc;
	}
	function get_subsecc_name () {
		return $this->seccion;
	}
	function get_subsecc_display () {
		return $this->seccion_visual;
	}
	function get_subsecc_querystring () {
		return $this->secc_querystring;
	}
	// Documentar!!
	function get_section_name () {
		return $this->_seccion['name'];
	}
	function get_section_title () {
		return $this->_seccion['titulo'];
	}
	function get_old_subsecc_name () {
		return $this->old_secc_name;
	}
	function get_old_id_subsecc () {
		return $this->old_secc;
	}
	function get_old_subsecc_querystring () {
		return $this->old_secc_querystring;
	}

			/**
         *Obtiene el nombre de seccion antigua para la comprobacion en init()
         *de si se refresca la configuracion del objeto total o parcialmente.
         */
	function get_oldsecc () {
		return $this->old_secc;
	}

	/**
   *Devuelve al motor de plantillas el id que tiene k usar caso de
   *no tener que hacer la query el motor de plantillas.
   */
	function get_id ($plt = "") {
		$nombre = $this->get_plt_name ($plt);
		if (is_object($this->b_activa)) $id = $this->b_activa->get_id ($this, $nombre);
		return $id;
	}

	function set_idsecc ($seccion = "", $bOverride = FALSE) {
		// global $oDb;
		if (!isset ($bOverride))
			$bOverride = FALSE;
		$oDb = $this->get_db ("conf");
		if (empty ($this->tb_secciones)) {
			$this->perror(1,'KERNEL_CONF','Error interno de configuracion, Leaks en las sesiones');
			return 0;
		}

		if (!isset ($bOverride))
			$bOverride = FALSE;
		if (empty ($seccion))
			$seccion = $this->seccion;
		else {
			$ss_act = $this->get_subsecc_name ();
			if ($this->debug & DBUG_MODS)
				debug ("SubSeccion - Act = $ss_act ; Ant = $this->old_secc_name ");
			if (strcasecmp ($this->old_secc_name, $ss_act) AND ! $bOverride) {
				$ss_secc_name = $this->get_subsecc_name ();
				$ss_secc = $this->get_id_subsecc ();
				$ss_secc_querystring = $this->secc_querystring;
			}
		}

		// Log-out no cuenta como query_string.
		if (strcmp($GLOBALS['QUERY_STRING'],'logout=1')) {
			$this->secc_querystring = $GLOBALS['QUERY_STRING'];	// Atributo sin documentar
		} else $this->secc_querystring = NULL;

		$retval = FALSE;
		$consulta = "SELECT * FROM ".$this->tb_secciones;
		$consulta .= " WHERE nombre = '$seccion'";
		$id = $oDb->query ($consulta);
		/*
		 * Este error de db corrupta (caso de haber 2 registros en la tabla de secciones con el mismo nombre) ha de ser tratado de
		 * otra forma (por ejemplo con el modulo de logs? ;) 
		 */
		$num_rows = $oDb->num_rows ($id);
		if ($num_rows > 1) {
			$this->id_secc = 0;
			$this->errores ("Base de Datos Corrupta: Dos secciones con el nombre $seccion");
			return;
		}
		elseif (!$num_rows) {	  // El nombre ($seccion) no es de una Seccion.
			$oDb->libera ($id);
			$consulta = "SELECT * FROM ".$this->tb_sub_secc;
			$consulta.= " WHERE nombre='$seccion'";
			$id = $oDb->query ($consulta);
			$num_rows = $oDb->num_rows ($id);
			if ($num_rows) {		  /* hemos encontrado la sub-seccion */
				$aTmp = $oDb->fetch_array ($id);
				$this->id_secc = $aTmp["id_sub_secc"];
				$this->seccion = $seccion;
				$this->seccion_visual = $aTmp["nombre_visual"];
				if ($this->debug & DBUG_MODS)
					debug ("set_idsecc():this->seccion = $this->seccion");
				$this->tb_base = $aTmp["tb_base"];
//aviso("asignando include ".$aTmp["script"]);
				$this->include = $aTmp["script"];
			}
			elseif (is_numeric ($seccion)) {	// Probamos a ver si por id_sub_secc coincide.
				$oDb->libera ($id);
				$consulta = "SELECT * FROM ".$this->tb_sub_secc;
				$consulta.= " WHERE id_sub_secc=".(int) $seccion;
				$id = $oDb->query ($consulta);
				$num_rows = $oDb->num_rows ($id);
				if ($num_rows) {
					$oDb->fetch_array ($id);
					$this->id_secc = $aTmp["id_sub_secc"];
					$this->seccion = $aTmp["nombre"];
					$this->seccion_visual = $aTmp["nombre_visual"];
					if ($this->debug & DBUG_MODS)
						debug ("set_idsecc(nombre subsecc):this->seccion = $this->seccion");
					$this->tb_base = $aTmp["tb_base"];
					$this->include = $aTmp["script"];
				} else {
					$this->id_secc = 0;
					$this->errores ("No existe esa seccion");
				}
			}
			$oDb->libera ($id);

			  /** Documentar la variable _seccion_name **/
			if ((int) $this->id_secc) {	// Si hemos encontrado la subseccion, buscamos su Seccion.
				$cons = "SELECT t2.nombre, t2.titulo, t2.id_seccion ".
					"FROM ".$this->tb_secciones." t2, ".$this->tb_sec_subsecc." t1 ".
					"WHERE t2.id_seccion = t1.id_seccion AND t1.id_sub_secc = ".$this->id_secc;
				$rs = $oDb->query ($cons);
				if ($oDb->num_rows ($rs)) {
					$aTmp = $oDb->fetch_assoc ($rs);
					if (!is_numeric ($this->_seccion['id']) OR $this->_seccion['id'] != $aTmp['id_seccion']) {
						$this->unset_vars ('SECCION');
					}
					$this->_seccion['name'] = $aTmp['nombre'];
					$this->_seccion['titulo'] = $aTmp['titulo'];
					$this->_seccion['id'] = $aTmp['id_seccion'];
				} else {
					if (is_numeric ($this->_seccion['id'])) {
						$this->unset_vars ('SECCION');
					}
					$this->_seccion['name'] = NULL;
					$this->_seccion['titulo'] = NULL;
				}
			} else {
				if (is_numeric ($this->_seccion['id'])) {
					$this->unset_vars ('SECCION');
				}
				$this->_seccion['name'] = NULL;
				$this->_seccion['titulo'] = NULL;
			}
			$retval = TRUE;
		}
		if (!$retval) {			  // Si no estaba en 'Secciones' y por tanto hayamos buscado su sub-seccion (indep del exito)
			$aSeccion = $oDb->fetch_array ($id);
			if (!is_numeric ($this->_seccion['id']) OR $this->_seccion['id'] != $aSeccion['id_seccion']) {
				$this->unset_vars ('SECCION');
			}
			$this->_seccion['name'] = $aSeccion['nombre'];	// Documentar!
			$this->_seccion['titulo'] = $aSeccion['titulo'];	// Documentar!
			$this->_seccion['id'] = $aSeccion['id_seccion'];	// Documentar!
			$this->id_secc = $aSeccion["main_sub"];
			if (!empty ($aSeccion["script"]) OR strcmp ($aSeccion["script"], "NULL"))
				$this->include = $aSeccion["script"];
			$this->tb_base = $aSeccion["tb_base"];
			$oDb->libera ($id);
			$consulta = "SELECT nombre,script,nombre_visual FROM ".$this->tb_sub_secc;
			$consulta.= " WHERE id_sub_secc = ".$this->get_id_subsecc ();
			$oDb->query ($consulta);
			if ($oDb->num_rows ()) {
				$aSeccion = $oDb->fetch_row ();
				// No poner el nombre de Seccion donde va el nombre de la subseccion.
				$this->seccion = $aSeccion[0];
				//debug("Secicon : ".$this->seccion);
				// $this->seccion = $seccion;

				$this->seccion_visual = $aSeccion[2];
				if (!empty ($aSeccion[1]) OR strcmp ($aSeccion[1], "NULL"))
					$this->include = $aSeccion[1];
				if ($this->debug & DBUG_MODS)
					debug ("set_idsecc(por seccion):this->seccion = $this->seccion");
			} else
				$this->seccion = $seccion;
		}

		if (!$bOverride) {
			if (empty ($ss_secc_name))
				$ss_secc_name = $this->get_old_subsecc_name ();
			if ($this->debug & DBUG_MODS)
				debug ("SubSeccion - Act = $seccion ; Ant = $ss_secc_name ");
			if (strcasecmp ($seccion, $ss_secc_name) AND ! $bOverride) {
				$this->old_secc_name = $ss_secc_name;
				$this->old_secc = $ss_secc;
				$this->old_secc_querystring = $ss_secc_querystring;
			}
		}
		if ($bOverride) {
			$this->old_secc_name = $this->get_subsecc_name ();
			$this->old_secc = $this->get_id_subsecc ();
			$this->old_secc_querystring = $this->secc_querystring;
		}
		return $retval;
	}

			/******** Manejo objeto(s) wolDB ****************/

	/**
   *Introducir un valor en la tabla _main
   * @param     $nombre de la variable a modificar
   * @param     $valor a meter
   * @param     $oDb Objeto wol_db a usar [opt]
   */
	function set_main_value ($nombre = "", $valor = "", $oDb = "") {
		// global $oDb;
		if ($nombre == "") {
			return 0;
		} else {
			// $oDb = $this->get_db("conf");
			$consulta = "INSERT INTO _main VALUES (NULL, '$nombre', '$valor')";
			if (!is_object ($oDb)) {
				$id = $this->query ($consulta);
				$this->libera ($id);
			} else {
				$id = $oDb->query ($consulta);
				$oDb->libera ($id);
			}
		}
		return 1;
	}

	/**
   * Leer valor de configuracion
   * Si el valor de nombre esta en la propiedad $configuracion[$nombre]
   *lo retorn .Sino lo lee de la tabla _main y lo inserta en el array
   *
   * @param $nombre para leer
   * @param    $oDb Objeto wol_db a usar [opt]
   * @return el valor de nombre
   *
	 * Tenemos 2 Versiones de este metodo. Una para el kernel de los proyectos y otra para la herramienta Pulsar.
	 */
	function read_main_value ($nombre = "") {
//debug("leyendo $nombre");
		if ($nombre == "")
			return "";
		else {
			$main_values = $this->get_var ("main_values");
//     depurar_array($main_values);     
			if (isset ($main_values[$nombre])) {
//      debug("de sesion $main_values[$nombre]");
				return $main_values[$nombre];
			} else {
				$consulta = "SELECT nombre , valor  FROM _main";
				$oDb = $this->get_db ("conf");
				$id = $oDb->query ($consulta);
				$tabla = array ();
				while ($par = $oDb->fetch_array ($id)) {
//              depurar_array($par);
					$tabla[$par['nombre']] = $par['valor'];
				}
//          depurar_array($tabla);      
				$this->set_var ("main_values", $tabla);
				$this->libera ($id);
//        debug("de primera$tabla[$nombre]");
				return $tabla[$nombre];
			}
		}
	}
	/*
	 * Version para Pulsar *(off) function read_main_value($nombre = "",$oDb = "") { //global $oDb; if($nombre == "") return "";
	 * else{ $consulta = "SELECT valor FROM _main WHERE nombre='$nombre'"; if (!is_object($oDb)) { $id = $this->query($consulta);
	 * $aTmp = $this->fetch_row($id); $this->libera($id); } else { $id = $oDb->query($consulta); $aTmp = $oDb->fetch_row($id);
	 * $oDb->libera($id); } return $aTmp[0]; } } 
	 */


					 /***** Sacar a wolIndex ****/

				/****** conectar_dbs($typo)
				*                Este metodo conecta los distintos tipos de instancias wolDB almacenadas.
				*                Actualmente solo hay de datos (data) y de configuracion (conf), se crean los
				*                objetos si es necesario, y son conectados y almacenados de nuevo.
				*                El tipo por defecto es conf.
				*                Actualmente solo hay una conexion por tipo. (set_db(tipo))
				*                Asimismo este objeto reconecta todas las instancias contenidas en la sesion
				*                        caso de que se le haga una solicitud que no coincida en tipo con 'data'
				*                        o 'conf' y que el set_db se haya hecho persistente.
				********/
	function conectar_dbs ($type = NULL) {
		if ($this->debug & DBUG_DB)
			debug ("conectar_dbs($type)");

		if (!$type || ($type AND ! strcmp ($type, "conf"))) {
			$oDb = $this->get_db ("conf");
			if (is_object ($oDb) AND ($this->debug & DBUG_DB))
				debug ("oDb(conf) es un objeto");

			if (!is_object ($oDb)) {
				if ($this->debug & DBUG_DB)
					debug ("creamos wolDB para la configuracion");
				$oDb = new wol_db ($this->App_Name);
				$oDb->init ();
			} else
				$oDb->init ();

			$oDb->conecta (1);
			$this->set_db ("conf", $oDb);
			$this->activate_db ('conf');
			if ($this->debug & DBUG_DB)
				debug ("El sql point ta en ".$oDb->SQL_point);

			// $oDb=$this->db;
		}
		elseif (!strcmp ($type, "data")) {
			if (!is_object ($this->db)) {	// Si no existe lo creamos
				$l = $this->read_main_value ("db_data_login");
				$p = $this->read_main_value ("db_data_passwd");
				$s = $this->read_main_value ("db_data_server");
				$db = $this->read_main_value ("db_data_dbase");
				$pt = $this->read_main_value ("db_data_port");
				if ($this->debug & DBUG_DB)
					debug ("Creando this->db apuntando a $db");
				$this->db = new wol_db ($this->App_Name, $l, $p, $s, $db, $pt);
				$this->db->init ();
			} else
				$this->db->init ();

			$this->db->conecta (1);
			$this->set_db ("data", $this->db, 1);
			$this->activate_db ("data");
		}

		else {							 /** si no es data ni conf... conectamos el resto de instancias **/
			if ($this->debug & DBUG_DB)
				debug ("conectar_dbs ni data ni conf");
			for (; list ($dbconname, $oWolDB) = each ($this->dbs);) {
				if ($this->debug & DBUG_DB)
					debug ("revisando $dbconname");
				// comprobacion
				if (!is_object ($oWolDB) ||	// errores -ignore-
					 !strcmp ($dbconname, "data") ||	// si data o conf
					 !strcmp ($dbconname, "conf"))
					continue;		  // ignorar

				if ($this->dbs_pconn[$dbconname] AND	// Si pconn
					 ! $this->dbs[$dbconname]->conectado ()) {	// y no conectado
					if ($this->debug & DBUG_DB)
						debug ("conectado = ".$this->dbs[$dbconname]->conectado ()."; reconectando $dbconname...");
					$this->dbs[$dbconname]->conecta (1);	// conectar obj
				}
			}							  // fin del for this->dbs
		}								  // fin del if (data o conf)
		if ($this->debug & DBUG_DB)
			debug ("fin de conectar dbs");
	}

					  /**
                 *Cierra la base de datos
                 */
	function cerrar_dbs () {
		// $this->dbs[data] = NULL;
		// unset($this->dbs[data]);
		for (; list ($r, $o) = each ($this->dbs);) {
			if ($this->debug & DBUG_DB)
				debug ("cerrar_dbs($r)");
			if (!is_object ($o)) {
				$this->dbs[$r] = NULL;
				unset ($this->dbs[$r]);
			} else
				$this->dbs[$r]->cerrar ();
		}
		reset ($this->dbs);
	}

					 /**
                *Pone el nombre de la base de datos a NULL */
	function restore_dbpoint () {

//debug("wolsesion->restore($db_name)");
		$this->db_name = NULL;
	}

					 /**
                * Establece valor de this->db */
	function set_db_conn (&$oDb) {
		$this->db = &$oDb;
		return;
	}

										  /**
                                * Obtienes conexion activa y sino this->db. 
																*/
	function get_db_conn () {
		if (!empty ($this->db_name))
			return $this->dbs[$this->db_name];
		else
			return $this->db;
	}

	/**
	 * Obtienes conexion activa y sino this->db. 
	 */
	function set_db ($name, &$oDb, $persistente = 0) {
		if ($this->debug & DBUG_DB)
			debug ("sesiones.inc:set_db($name,$persistente)");
		$this->dbs[$name] = &$oDb;
		$this->dbs_pconn[$name] = (int) $persistente;
	}

	function &get_db ($name = NULL) {
		if ($this->debug & DBUG_DB)
			debug ("sesiones.inc:get_db($name)");
		if (empty ($name) OR ! isset ($name))
			$name = $this->db_name;
		if (is_object ($this->dbs[$name])) {
			return $this->dbs[$name];
		} else {
			$oDb = $this->get_db ('conf');
			$db = $oDb->read_main_value ('db_'.$name.'_dbase');
			$login = $oDb->read_main_value ('db_'.$name.'_login');
			$passwd = $oDb->read_main_value ('db_'.$name.'_passwd');
			$server = $oDb->read_main_value ('db_'.$name.'_server');
			$port = $oDb->read_main_value ('db_'.$name.'_port');
			if (!empty ($db) AND ! empty ($login) AND ! empty ($server)) {

				/** **/
				$this->dbs[$name] = new wol_db ($this->App_Name, $login, $passwd, $server, $db, $port);
				if (is_object ($this->dbs[$name])) {
					$this->dbs[$name]->init ();
					if (!is_numeric($this->dbs_pconn[$name])) $this->dbs_pconn[$name] = 1;
					if (!$this->dbs[$name]->conectado()) $this->dbs[$name]->conecta();
					return $this->dbs[$name];
				} else
					$this->dbs[$name] = NULL;

				/** **
				$tmpdb = new wol_db($this->App_Name,$login,$passwd,$server,$db);
				if (is_object($tmpdb)) {
					$tmpdb->init();
					debug("Ahora le damos el INIT");
					$this->set_db($name,$tmpdb,1);
					return $tmpdb;
				} else $this->dbs[$name] = NULL;
				/** **/
			}
		}
		return NULL;
	}

	function get_dbconname () {
		return $this->db_name;
	}

	function reset_db ($name) {
		unset ($this->dbs[$name]);
	}

				/**
				* Establece la instancia wolDB activa
				*/
	function activate_db ($db_name) {
		if ($this->debug & DBUG_DB)
			debug ("wolsesion->activate_db($db_name)");
		if (is_object ($this->dbs[$db_name]))
			$this->db_name = $db_name;
	}

								/***** FIN de Sacar a wolIndex ****/


	function query ($a = "") {
//debug("query de $a");
		if (!empty ($this->db_name)) {
			if ($this->debug & DBUG_DB)
				debug ("query($a) conn = ".$this->db_name);
			return $this->dbs[$this->db_name]->query ($a);
		} else
			return $this->db->query ($a);
		return $db->query ($a);
	}

	function num_rows ($a = "") {
		if (!empty ($this->db_name))
			return $this->dbs[$this->db_name]->num_rows ($a);
		else
			return $this->db->num_rows ($a);
		return $db->num_rows ($a);
	}

	function fetch_array ($a = "") {
//debug("fetch array de $a");
		if (!empty ($this->db_name)) {
//debug("db activa = (".$this->db_name.")");
			return $this->dbs[$this->db_name]->fetch_array ($a);
		} else
			return $this->db->fetch_array ($a);
//debug("fetch array de $a");
		$c = $db->fetch_array ($a);
//debug("devolvio $c");
		return $c;
	}

	function fetch_field ($a = "") {
//debug("fetch field de $a");
		if (!empty ($this->db_name)) {
//debug("db activa = (".$this->db_name.")");
			return $this->dbs[$this->db_name]->fetch_field ($a);
		} else
			return $this->db->fetch_array ($a);
//debug("fetch field de $a");
		$c = $db->fetch_field ($a);
//debug("devolvio $c");
		return $c;
	}

	function fetch_row ($a = "") {
		if (!empty ($this->db_name))
			return $this->dbs[$this->db_name]->fetch_row ($a);
		else
			return $this->db->fetch_row ($a);
		return $db->fetch_row ($a);
	}
	function data_seek ($a = "", $b = "") {
		if (!empty ($this->db_name))
			return $this->dbs[$this->db_name]->data_seek ($a);
		else
			return $this->db->data_seek ($a);
		return $db->data_seek ($a, $b);
	}
	function libera ($a = "") {
		if (!empty ($this->db_name))
			return $this->dbs[$this->db_name]->libera ($a);
		else
			return $this->db->libera ($a);
		return $db->libera ($a);
	}
	function desconecta ($a = "") {
		if (!empty ($this->db_name))
			return $this->dbs[$this->db_name]->desconecta ($a);
		else
			return $this->db->desconecta ($a);
		return $db->desconecta ($a);
	}
	function obtener_clave ($a = "") {
		if (!empty ($this->db_name))
			return $this->dbs[$this->db_name]->obtener_clave ($a);
		else
			return $this->db->obtener_clave ($a);
		return $db->obtener_clave ($a);
	}
	function ruta ($a = "", $b = "", $c = "") {
		if (!empty ($this->db_name))
			return $this->dbs[$this->db_name]->ruta ($a, $b, $c);
		else
			return $this->db->ruta ($a, $b, $c);
		return $db->ruta ($a, $b, $c);
	}


	/*
	 * Tite: mirar a ver que es esto. * function esta_en($a="",$b="",$c=""){ if (!empty($this->db_name)) $db =
	 * &$this->dbs[$this->db_name]; return $db->esta_en($a,$b,$c); } 
	 */


					 /********** API con el MOTOR de PLANTILLAS ************/

					 /***** Info y PUNTEROS de PLANTILLAS ******/
	function set_plts () {
		// global $oDb;
		$oDb = $this->get_db ("conf");
		if (!$this->id_secc)
			$this->set_idsecc ();
		$oUsr = $this->get_authed_user ();
		if ((int) $oUsr->authed) {
			$authed = TRUE;
			$usr_mask = $oUsr->get_mask ();
		} else
			$authed = FALSE;
		$consulta = "SELECT t1.*,t2.nombre as 'plt_name' ";
		$consulta.= ", t2.pre_code as 'ss_pre_code' ";
		$consulta.= ", t2.post_code as 'ss_post_code'";
		$consulta.= " FROM ".$this->tb_plantillas." t1, ";
		$consulta.= $this->tb_sub_plts." t2 ";
		$consulta.= " WHERE t2.id_sub=".$this->id_secc;
		$consulta.= " AND t2.id_plt=t1.id_plantilla ";
		if ($authed)
			$consulta.= " AND ( (allow_mask IS NULL OR allow_mask & $usr_mask) AND ".
				" ( deny_mask IS NULL OR !(deny_mask & $usr_mask)) ) ";
		else
			$consulta.= "AND allow_mask IS NULL ";
		$consulta.= " ORDER BY t2.orden";

		$idp = $oDb->query ($consulta);
		$i = $this->plt_point;
		// Ojo... Esto puede dar problemas con el cache?
		if ($oDb->num_rows ($idp))
			$this->plantillas = array ();

		while ($aPlant = $oDb->fetch_array ($idp)) {
			$plt_name = $aPlant["plt_name"];
			$plt_src = $aPlant["nombre"];

			if (!empty ($aPlant["ss_pre_code"]))
				$fld = "ss_pre_code";
			else
				$fld = "pre_code";
// debug("($plt_name,$plt_src) $fld = ".$aPlant[$fld]);
			if (!empty ($aPlant[$fld]) OR strcmp ($aPlant[$fld], "NULL")) {
				$precode = $aPlant[$fld];
			} else {
				$precode = NULL;
			}

			if (!empty ($aPlant["ss_post_code"]))
				$fld = "ss_post_code";
			else
				$fld = "post_code";
			if (!empty ($aPlant[$fld]) OR strcmp ($aPlant[$fld], "NULL")) {
				$postcode = $aPlant[$fld];
			} else {
				$postcode = NULL;
			}
			$argvar = $aPlant['arg_var'];
			if (!strcasecmp ($argvar, "NULL"))
				$argvar = NULL;
			$this->add_plt ($plt_name, $plt_src, $precode, $postcode, $argvar);

			$i++;
		}
		$oDb->libera ($idp);
	}

	function plt_fwd () {
		return ++$this->plt_point;
	}

	function plt_bkw () {
		return --$this->plt_point;
	}

	/*
	 * esta funcion tendria k llamarse get_arg_var() 
	 */
	function get_key ($plt = "") {
		if (!isset ($plt) OR empty ($plt))
			$plt = $this->plt_point;
// debug("plantilla = ".$this->plantillas[$this->plt_point]);
// aviso("plt = ($plt)");
		$key = $this->plt_arg[$plt];
		// debug("clave = ($key)");
		$aTmpK = split(',',$key);
		$retval = NULL;
		foreach ($aTmpK as $tmpv) {
			$aK = split(':',$tmpv);
			$varname = ( (!empty($aK[1])) ? $aK[1] : $aK[0] ) ;
			$keyname = $aK[0];
			$valor = $this->fetchVar($varname ,'GET');
			if ( (empty($valor) AND !is_numeric($valor)) ) $valor = $this->get_var($varname);
			if ( (empty($valor) AND !is_numeric($valor)) ) $valor = $this->fetchVar($varname ,'POST');
			if ( (empty($valor) AND !is_numeric($valor)) ) $valor = $this->fetchVar($varname ,'GLOBAL');
		  // debug("valor de $keyname = (".$valor.")");
			if ( (empty($valor) AND !is_numeric($valor)) ) continue;
			if (!is_array($retval)) $retval = array();
			array_push($retval,array($keyname => $valor));
		}

		if ((empty($retval) AND !is_numeric($retval)) ) return NULL;
		else {
			// debug("retornada clave ");
			return $retval;
		}
	}


	function get_plt_num ($plt) {
		if (empty ($plt))
			return $this->plt_point;
		else {
			$plt_src = $this->plantillas[$plt];
			if (is_int ($plt)) {
				if (!empty ($plt_src))
					return $plt;
				else
					return 0;
			} else {
				if (!empty ($plt_src)) {
					$i = -1;
					foreach ($this->plantillas as $idx => $valor)
						if (is_int ($idx) && !strcmp ($plt_src, $this->plantillas[$idx])) {
							$i = $idx;
							break;
						}
					return $i;
				} else {				  /* No encontramos la plantilla */
					return -1;
				}
			}
		}
	}

	/*
	 * Obtener el nombre de una plantilla a partir de su indice 
	 */
	function get_plt_name ($plt = "") {
		if (empty ($plt))
			$plt = $this->plt_point;

		$plt_src = $this->plantillas[$plt];
//aviso("joer plt_src = $plt_src para plt = $plt");
		if (empty ($plt_src))
			return NULL;

		foreach ($this->plantillas as $clave => $valor) {
//aviso("clave = $clave, valor = $valor");
			if (is_int ($clave))
				continue;
			if (!strcmp ($plt_src, $valor)) {
//aviso("get_plt_name devolemos $clave para plt ($plt)");
				return $clave;
			}
		}
		return NULL;
	}									  // Fin de get_plt_name()

	/*
	 * Obtener el nombre de una plantilla a partir de su indice 
	 */
	function get_plt_array ($plt = "") {
		if (empty ($plt))
			$plt = $this->plt_point;

		$plt_src = $this->plantillas[$plt];
// debug("joer plt_src = $plt_src para plt = $plt");
		if (empty ($plt_src))
			return NULL;
//debug("PLANTILLAS:");
//depurar_array($this->code);
		foreach ($this->plantillas as $clave => $valor) {
//debug("clave = $clave, valor = $valor");
			if (is_int ($clave))
				continue;
			if (!strcmp ($plt_src, $valor)) {
//debug("get_plt_name devolemos $clave para plt ($plt) Nº(".$this->code[$clave][0].")");
				return array ($clave, $valor, $this->code[$clave][0]);
				// return array($clave,$valor,$this->code[$this->get_plt_num($clave)][0]);
				// return array($clave,$valor);
			}
		}
		return NULL;
	}									  // Fin de get_plt_name()


/** Retorna un array  de array formados por nombre puunto de informacion  , nombre de la plantilla , nombre del precode de la subseccion actual 
*/
	function get_plt_array_all () {
		foreach ($this->plantillas as $clave => $valor) {
			if (!is_int ($clave))
				$aRetVal[] =
					array ($clave, $valor, $this->code[$this->get_plt_num ($clave)][0], $this->code[$this->get_plt_num ($clave)][1]);
		}
		return $aRetVal;

	}									  // Fin de get_plt_name()

	function reset_plts () {
		$this->plantillas = array ();
		$this->code = array ();
		$this->plt_arg = array ();
		$this->plt_point = 0;
		$this->plt_point_end = 0;
		$this->plt_name = NULL;
		return 1;
	}

	function change_plt ($plt, $src) {
		if (empty ($this->plantillas[$plt]))
			return 0;
		$num = $this->get_plt_num ($plt);
		if ($num == -1)
			return 0;
		$this->plantillas[$num] = $src;
		$this->plantillas[$plt] = $src;
//debug("change_plt($plt,$src)");
		// $this->code[$num][0] = NULL;
		// $this->code[$plt][0] = NULL;
		/*
		 * parche 
		 */
//                        $this->old_secc_name = NULL;
		return 1;
	}

	/*
	 * Este metodo cambia el precode de una plantilla a NULL plt - puntero a la plantilla (o punto de informacion) 
	 */
	function reset_plt_precode ($plt) {
//debug("plt: $plt");
		if (empty ($this->plantillas[$plt]))
			return 0;
		$num = $this->get_plt_num ($plt);
		if ($num == -1)
			return 0;
		$this->code[$num][0] = NULL;
		$this->code[$plt][0] = NULL;
		return 1;
	}

	/*
	 * Este metodo cambia el precode de una plantilla: plt - puntero a la plantilla src - fichero.ext nuevo precode - precode()
	 * nuevo 
	 */
	function change_plt_precode ($plt, $src, $precode = NULL, $postcode = NULL, $argvar = NULL) {
		if (empty ($this->plantillas[$plt]))
			return 0;
		$num = $this->get_plt_num ($plt);
		if ($num == -1)
			return 0;
		if (!empty($src)) {
			$this->plantillas[$num] = $src;
			$this->plantillas[$plt] = $src;
		}
		if (!empty($precode)) $this->code[$num][0] = $precode;
		if (!empty($postcode)) $this->code[$num][1] = $postcode;
		if ($this->debug)
			debug ("wolSesion->change_plt_precode($plt,$src) ..");
		if ($argvar == -1)
			$this->plt_arg[$num] = NULL;
		elseif ($argvar) $this->plt_arg[$num] = NULL;
		return 1;
	}

	/*
	 * Metodo para añadir una plantilla al array de plantillas 
	 */
	function add_plt ($plt, $src, $precode = NULL, $postcode = NULL, $arg_var = NULL) {
		if ($this->debug)
			debug ("wolSesion->add_plt($plt,$src,$precode,$postcode,$arg_var)  :: ".$this->plt_point_end);
		if (empty ($src) OR empty ($plt))
			return -1;
		if ($this->get_plt_num ($plt) != -1) {
			if ($this->debug)
				debug ("PII Ya existia, no se anyade nada");
			return -1;
		}
		$this->plantillas[$this->plt_point_end++] = $src;
		if (!is_int ($plt)) {
			$this->plantillas[$plt] = $src;
			if (!empty ($precode))
				$this->code[$plt][0] = $precode;
			if (!empty ($postcode))
				$this->code[$plt][1] = $postcode;
			if (!empty ($arg_var))
				$this->plt_arg[$plt] = $arg_var;
		}
		if ($precode)
			$this->code[$this->plt_point_end - 1][0] = $precode;
		if ($postcode)
			$this->code[$this->plt_point_end - 1][1] = $postcode;
		if ($arg_var)
			$this->plt_arg[$this->plt_point_end - 1] = $arg_var;

		return ($this->plt_point_end - 1);
	}

	/** Funcion que nos devuelve cual es la siguiente plantilla a inter
     pretar por esta funcion.
         OJITO! Esta funcion modifica el puntero de plantillas. grrrr        **/
	function get_plt ($plt) {
		// debug("next_plt.plt_point(".$this->plt_point.") ($plt)");
		if (empty ($plt)) {
			foreach ($this->plantillas as $idx => $src)
				if (is_int ($idx)) {
					$this->plt_point = $idx;
					break;
				}
			$plt = $this->plt_point;
		} else {
			if (is_int ($plt)) {
				$plt_src = $this->plantillas[$plt];
				if (!empty ($plt_src))
					$this->plt_point = $plt;
				else
					$this->plt_point = 0;
				$this->plt_name = NULL;	/* Documentar! */
			} else {
				// Plantillas especiales obtenidas de configuracion
				if (!strcmp('::',substr($plt,0,2))) {
					$tmp = substr($plt,2);
					$aPlt = split(':',$tmp);
					if (!strcasecmp($aPlt[0],'pltcfg')) {
						if (is_array($this->_aCfgPlts[$aPlt[1]])) {
							$aRetPlt = $this->_aCfgPlts[$aPlt[1]];
						} else $aRetPlt = $this->_aCfgPlts['null'];
						if (is_array($aRetPlt)) return $aRetPlt['nombre'];
						else return NULL;
					}
				} else { // Plantillas obtenidas de las posibles de esta subseccion.
					$plt_src = $this->plantillas[$plt];
					if (!empty ($plt_src)) {
						$nPlts = -1;
						foreach ($this->plantillas as $idx => $src)
							if (is_numeric ($idx) AND ! strcmp ($plt_src, $src)) {
								// debug("Encontrado!! ($plt_src - $i - $plt) ");
								$nPlts = (int) $idx;
								break;
							}
						if ($nPlts == -1) {
							$this->errores ("Referencias incoherentes en los Indices de Plantillas");
							exit;
						} else {
							$this->plt_point = $nPlts;
							$this->plt_name = $plt;
						}
					} else {				  /* No encontramos la plantilla */
						if (!is_array ($this->_aCfgPlts['null'])) {
							$this->errores ("No he encontrado la plantilla ($plt)");
	//aviso("puntero = ".$this->plt_point);
	//aviso("plantillas = ".sizeof($this->plantillas));
							exit;
						} else {
							return $this->_aCfgPlts['null']['nombre'];
						}
					}
				}
			}
		}

// debug("Retonno($plt): ".$this->plantillas[$plt]);
		// if ($plt != -1) {
		return $this->plantillas[$plt];
		// } else { return; }
	}


					 /*** EJECUCION de codigo de las Plantillas ***/

	function exec_plt ($plt = "") {
		if (empty ($plt)) {
			$plt = $this->get_plt_name ($this->plt_point);
			$func = $this->code[$plt][0];
		} else {
			// Plantillas especiales obtenidas de configuracion
			if (!strcmp('::',substr($plt,0,2))) {
				$tmp = substr($plt,2);
				$aPlt = split(':',$tmp);
				if (!strcasecmp($aPlt[0],'pltcfg')) {
					if (is_array($this->_aCfgPlts[$aPlt[1]])) {
						$aRetPlt = $this->_aCfgPlts[$aPlt[1]];
					} else $aRetPlt = $this->_aCfgPlts['null'];
					if (is_array($aRetPlt)) $func = $aRetPlt['pre_code'];
					else $func = NULL;
				}
			} else {
				$func = $this->code[$plt][0];
			}
		}

		if (!empty ($func)) {
			if ($this->debug & DBUG_INC) debug("exec_plt($plt) : $func ");
			$plantilla = $func ($this);
		}
		if (!empty($plantilla)) $plt_retorno = $plantilla;
		else {
			$plt_retorno = NULL;
			$plt_num = $this->get_plt_num($plt);
			if ($this->oMsgs->haveCode(IM_FATALERROR) AND !empty($func)) {
				// Si es la plantilla base la que 'casco' se lanza la plt full de errores
				if (empty($plt_num)) {
					$plt_retorno = $this->_aCfgPlts['err_full']['nombre'];
					if (!empty($this->_aCfgPlts['err_full']['pre_code']))
						$this->_aCfgPlts['err_full']['pre_code']($this);
					// $plt_link = 'LOGOUT';
				} else {
					$plt_retorno = $this->_aCfgPlts['err_pii']['nombre'];
					if (!empty($this->_aCfgPlts['err_pii']['pre_code']))
						$this->_aCfgPlts['err_pii']['pre_code']($this);
				}
				if (!empty($plt_retorno)) {
					//debug("link $plt_link");
					$this->perror_link($plt_link);
				}
			}
		}
		return $plt_retorno;
	}

					 /*** cebadores de DATOS a las PLANTILLAS ***/

					 /** Indica al motor de plantillas si ha de hacer la query(1) o no(0) */
	function do_query ($plt_name = "") {
		if (!isset ($plt_name) OR empty ($plt_name)) {
			if (!empty ($this->plt_name))
				$plt_name = $this->plt_name;
			else
				$plt_name = $this->get_plt_name ($this->plt_point);
			if ($this->debug & DBUG_MODS)
				debug ("1 do_query de $plt_name (".$this->hay_b.") (".$this->hay_menu.")");
		}
		if ((!is_object ($this->b_activa) OR ! $this->hay_b) AND (!is_object ($this->menu) OR ! $this->hay_menu)) {
			if ($this->debug & DBUG_MODS)
				debug ("do_query de $plt_name");
			return 1;
		}
		if ($this->hay_b AND $val = (int) ($this->b_activa->reconocer_plt ($plt_name))) {
			if ($this->debug & DBUG_MODS)
				debug ("el buscador ha reconocido $plt_name ($val)");
			return !$val;
		}
		elseif ($this->hay_menu AND $val = (int) ($this->menu->reconocer_plt ($plt_name)))
			return !$val;
		else return 1;
	}

	function reconocer_bloque ($bloque) {
		if ($this->hay_b)
			return $this->b_activa->reconocer_bloque ($bloque);
		return 0;
	}


			/** Obtiene el siguiente array de datos para un bucle de plantilla **/
	function get_plt_data ($bName = "") {
//salida("bname $bName <BR>\n");
		if (!isset ($bName) OR empty ($bName))
			$bName = "exterior";
		if (is_object ($this->menu) AND $this->hay_menu) {
//salida("get_plt de menu");
			$RetVal = $this->menu->get_plt_data ($bName);
//salida("menu ha devuerto tantos como ".sizeof($RetVal)."<BR>\n");
		} else
			$RetVal = array ();

		if (!$RetVal AND is_object ($this->b_activa) AND $this->hay_b) {
//salida("get_plt de buscador<BR>\n");
			$RetVal = $this->b_activa->get_plt_data ($this, $bName);
		}
		if (!sizeof ($RetVal))
			$RetVal = array ();

/*
salida("(get_plt_data) retval: ".sizeof($RetVal)."<BR>\n");
for (;list($a,$b) = each($RetVal);) {
salida(" $a  $b <BR>\n");
}
reset($RetVal);
*/
		return $RetVal;
	}

	/** documentar tb *
          Añadir parametros a una busqueda.
                */
	function set_query_param ($type, $val) {
		$retval = 1;
		if ($this->hay_b AND !empty($type) AND !empty($val)) {
			$retval = $this->b_activa->set_param_query ($type, $val);
		}
		return $retval;
	}

	function hay_rows () {
		$val = -1;
		if ($this->hay_b)
			$val = $this->b_activa->hay_rows ();
		if ($val != -1)
			return $val;
		elseif ($this->hay_menu) {
			$val = $this->menu->hay_rows ();
			if ($val == -1)
				$val = 0;			  /* ultimo, si no la reconoce.  a la shit */
			return $val;
		}
		else
		return 0;
	}


					 /**** soporte para MODULOS *****/
	function load_internal_modules () {
		$cons = "SELECT * FROM ".$this->tb_modulos." WHERE base=1";
		$this->query ($cons);
	}

	 /**** soporte para MODULOS *****/

/**
        * PLT_???? (al salir de la plantilla)
        * NOEXPIRE (obivio)
        * INMED (al cerrar la sesion)
        * SUBSECCION (al cambiar de subseccion)
        */
	function set_var ($var_name, $value, $expire = NULL) {
		// if (!strcmp ($expire, "EXPIRE")) $expire = "INMED";

		if (is_object ($value) AND $this->check_class_module (get_class ($value))) {
			if ($this->debug & (DBUG_VARS | DBUG_MODS))
				debug ("set_var($var_name, Objeto de Clase ,$expire) - ".get_class($value));
			$this->_aClasses[$var_name][0] = $value;
			if (!isset($this->_aClasses[$var_name][1])) $this->_aClasses[$var_name][1] = ( (!empty($expire)) ? $expire : 'NOEXPIRE' );
			$this->_aClasses[$var_name][2] = time (NULL);
		} else {
			if ($this->debug & DBUG_VARS) 
				debug ("<b>set_var</b>($var_name,$value,$expire)");
			$this->aData[$var_name][0] = $value;
			if (!isset($this->aData[$var_name][1])) $this->aData[$var_name][1] = ( (!empty($expire)) ? $expire : 'NOEXPIRE' );
			$this->aData[$var_name][2] = time (NULL);
		}
	}

	function get_var ($var_name) {
		if (is_array ($this->aData[$var_name])) {
			if (($this->debug & DBUG_VARS))
				debug ("get_var($var_name) =>".$this->aData[$var_name][0]);
			return $this->aData[$var_name][0];
		}
		elseif (is_array ($this->_aClasses[$var_name])) {
			if (($this->debug & (DBUG_VARS | DBUG_MODS)))
				debug ("get_-object-_var($var_name) =>".$this->_aClasses[$var_name][0]);
			return $this->_aClasses[$var_name][0];
		}
		return NULL;
	}

	function setVarByRef ($var_name, &$value, $expire = NULL) {
		// if (!strcmp ($expire, "EXPIRE")) $expire = "INMED";

		if (is_object ($value) AND $this->check_class_module (get_class ($value))) {
			if ($this->debug & (DBUG_VARS | DBUG_MODS))
				debug ("set_var($var_name, Objeto de Clase ,$expire) - ".get_class($value));
			$this->_aClasses[$var_name][0] = &$value;
			if (!isset($this->_aClasses[$var_name][1])) $this->_aClasses[$var_name][1] = ( (!empty($expire)) ? $expire : 'NOEXPIRE' );
			$this->_aClasses[$var_name][2] = time (NULL);
		} else {
			if ($this->debug & DBUG_VARS) 
				debug ("<b>set_var</b>($var_name,$value,$expire)");
			$this->aData[$var_name][0] = &$value;
			if (!isset($this->aData[$var_name][1])) $this->aData[$var_name][1] = ( (!empty($expire)) ? $expire : 'NOEXPIRE' );
			$this->aData[$var_name][2] = time (NULL);
		}
	}

	function &getVarByRef ($var_name) {
		if (is_array ($this->_aClasses[$var_name])) {
			if (is_array ($this->aData[$var_name])) debug("Error: Existe _TAMBIEN_ la variable NO de Objeto $var_name ");
			if (($this->debug & (DBUG_VARS | DBUG_MODS)))
				debug ("get_-object-_var($var_name) =>".$this->_aClasses[$var_name][0]);
			return $this->_aClasses[$var_name][0];
		} elseif (is_array ($this->aData[$var_name])) {
			if (($this->debug & DBUG_VARS))
				debug ("get_var($var_name) =>".$this->aData[$var_name][0]);
			return $this->aData[$var_name][0];
		}
		return NULL;
	}

	function fetchVar($var_name,$origtype = NULL, $bCheckSums = TRUE) {
		if (empty($var_name)) return NULL;

		if (empty($origtype)) {
			$regglobals = $this->_getKrnCfg('register_globals');
			if ($regglobals) $aType = array('GET');
			else $aType = array('GLOBAL');
		} else $aType = split(' ',$origtype);

		foreach ($aType as $type) {
			switch ($type) {
				case 'GET':
					$retval = $_GET[$var_name];
					break;

				case 'POST':
					$retval = $_POST[$var_name];
					break;

				case 'REQUEST':
					$retval = $_REQUEST[$var_name];
					break;

				case 'GLOBAL':
					$retval = $GLOBALS[$var_name];
					break;

				case 'SESSION':
					$retval = $this->get_var($var_name);
					break;

				default:
					break;
				// Por defecto de ..  $retval = $GLOBALS['_GET'][$var_name];
			}
			if (!empty($retval) OR is_numeric($retval)) break;
		}

		if (is_array($retval) ANd $bCheckSums) {
			$keys = implode('',array_keys($retval));
			$crc_keys = crc32($keys);
			$values = implode_r(NULL,$retval);
			$crc_values = crc32($values);

			if (!is_array($this->_aCrcCheck[$var_name])) {
				$this->_aCrcCheck[$var_name] = array();
				$this->_aCrcCheck[$var_name]['status_last'] = IKRN_VAR_CRC_NEW;
			} else {
				$this->_aCrcCheck[$var_name]['status_last'] = 0;
				if ($this->_aCrcCheck[$var_name]['crckeys'] == $crc_keys) 
					$this->_aCrcCheck[$var_name]['status_last'] |= IKRN_VAR_CRC_KEYMATCH;
				if ($this->_aCrcCheck[$var_name]['crcvalues'] == $crc_values) 
					$this->_aCrcCheck[$var_name]['status_last'] |= IKRN_VAR_CRC_VALUEMATCH;

				if (empty($this->_aCrcCheck[$var_name]['status_last'])) {
					$this->_aCrcCheck[$var_name]['status_last'] = IKRN_VAR_CRC_CHANGE;
				}
			}
			$this->_aCrcCheck[$var_name]['crckeys'] = $crc_keys;
			$this->_aCrcCheck[$var_name]['crcvalues'] = $crc_values;
			
		}

		return $retval;
	}

	function verifyVar($var_name, $check = IKRN_VAR_CRC_CHANGE) {

		return TRUE;
		if (!is_numeric($check)) return FALSE;
		if ($check & IKRN_VAR_CRC_AUTHED) return TRUE;

		if (!is_array($this->_aCrcCheck[$var_name]) OR 
				!is_numeric($this->_aCrcCheck[$var_name]['status_last'])) {
			// Este caso no se produce dado que fetchVar asigna un IKRN_VAR_CRC_NEW y crea el array de la variable si no existe.
			if ( (($check & IKRN_VAR_CRC_CHANGE) OR ($check & IKRN_VAR_CRC_NEW)) 
					AND (is_array($this->_aCrcCheck[$var_name])) ) return TRUE;
			else return FALSE;
		}

		$bRetval = FALSE;
		if ($check & IKRN_VAR_CRC_CHANGE) {
			// debug("checking: Cambio de crc ... ".($this->aCrcCheck[$var_name]['status_last'] & ~IKRN_VAR_CRC_VALUEMATCH));
			// debug("st: ".decbin($this->_aCrcCheck[$var_name]['status_last'])." chk: ".decbin(~IKRN_VAR_CRC_VALUEMATCH));
			if ($this->_aCrcCheck[$var_name]['status_last'] & IKRN_VAR_CRC_NEW) return TRUE;
			elseif ($this->_aCrcCheck[$var_name]['status_last'] & IKRN_VAR_CRC_VALUEMATCH) return FALSE; 	// Si los valores coinciden, no hay cambio
			elseif ($this->_aCrcCheck[$var_name]['status_last'] & ~IKRN_VAR_CRC_VALUEMATCH) return TRUE;		// Si hay alguna otra marca, hay cambio (generoso)
			else return FALSE;
		} 

		if ($this->_aCrcCheck[$var_name]['status_last'] & $check) return TRUE;
		else return FALSE;
	}

	function unset_vars ($type) {
		if ($this->debug & DBUG_VARS)
			debug ("unset_vars($type)");
		if (is_array ($this->aData))
			foreach ($this->aData as $clave => $valor)
				if (!strcmp ($valor[1], $type))
					$this->unset_var ($clave);
		if (is_array ($this->_aClasses))
			foreach ($this->_aClasses as $clave => $valor)
				if (!strcmp ($valor[1], $type))
					$this->unset_var ($clave, 1);
	}

	/** 
	  * Elimina una variable de la sesion. El tipo es 0 - Normal; 1 - Objeto de un Modulo
	  **/
	function unset_var ($var_name, $type = 0) {
		if (!$type) {
			if (!is_array ($this->aData[$var_name]))
				$type = 1;
			else {
				if ($this->debug & DBUG_VARS)
					debug ("unset_var($var_name)");
				$this->aData[$var_name][0] = NULL;
				$this->aData[$var_name][1] = NULL;
				unset ($this->aData[$var_name]);
			}
		}
		if ($type) {
			if ($this->debug & DBUG_VARS)
				debug ("unset_var($var_name) -> Object");
			$this->_aClasses[$var_name][0] = NULL;
			$this->_aClasses[$var_name][1] = NULL;
			unset ($this->_aClasses[$var_name]);
			// debug("$var_name unsetted y tal (".$this->_aClasses[$var_name].")");
		}
		return;
	}

					 /**** ERRORES y CERRAR ****/

	function lcMessage($sErr,$aErrParams = NULL,$iType = NULL) {
		return $this->oMsgs->addMsg($sErr,$aErrParams,$iType);
	}

	function &getMsgs() {
		return $this->oMsgs;
	}

	function perror_link($lnk = 'BACK') {
		$errlink = $this->get_var('__error_return_link');
		if (!empty($errlink)) return ; // SI ya esta setteado, nada.

		if ($lnk == 'BACK') {
			$pss = $this->get_old_subsecc_name();
			if (!empty($pss)) $link = '?seccion='.$pss;
			else $link = '?logout=1';
		} elseif ($lnk == 'LOGOUT') {
			$link = '?logout=1';
		} elseif ($lnk == 'HOME') {
			debug("Falta por configurar el enlace a _home_");
			$link = '?logout=1';
		} elseif ($lnk == 'SECCION') {
			$link = '?seccion='.$this->get_section_name();
		} else $link = $lnk;
		$this->set_var('__error_return_link',$link,'INMED');
	}

	function cerrar () {
		/** Antes de cerrar la sesion renderizamos su contenido **/
		$this = plantillas ($this);
		/** soporte email **/
		$aMod = $this->_getStdOutMod();
		if (is_array($aMod)) {
			if (function_exists($aMod['finish'])) $aMod['finish']($this);
		}
		/** **/
		$this->unload_modules ();
		$this->quit ();
	}

	function quit () {
		if ($this->debug & DBUG_DB)
			debug ("Callin quit()");

		if (is_object ($this->Access))
			$this->Access->cerrar ();

			 /** 
       $func = $this->code[$this->plt_point][1]; /* post_code esto en plts *
       if (!empty($func)) return $func($this);
			 **/

								 /** Mandamos senyal de cierre a todos los modulos **/
		// debug("y b_activa?");
		// print_r(is_object($this->b_activa));
		if (is_object ($this->b_activa))
			$this->b_activa->cerrar ();
		if (is_object ($this->menu))
			$this->menu->cerrar ();

		if (is_object ($this->db))
			$this->db->cerrar ();

								 /** Preparamos los punteros para ser guardados **/
		$this->plt_point = 0;

		$this->cerrar_dbs ();
		// unset($this->dbs);
		$this->restore_dbpoint ();

		$this->unset_vars ("INMED");

		$this->oMsgs->cerrar();
				 /** Guardamos el objeto en la sesion **/
		if (!session_register ($this->obj_var_name))	/* cambiar por $this->error() */
			salida ("ERROR Interno, no se ha podido guardar la sesion.<BR>\n");
		// exit;
		/*
		 */
//debug("Cerramos la sesion($this->obj_var_name)! con nombre ".session_name()."(".session_id().")");
		// session_write_close();

		return;
	}

// Funciones Obsoletas:
	function errores ($msg = "Error") {
		aviso ("Error(Sesion) : $msg");
		return;
	}

	function perror ($code = 0, $where = NULL, $what = NULL) {
		$aErrMsg = $this->get_var ('_elementos_fail');
		if (!is_array ($aErrMsg))
			$aErrMsg = array ();
		$aErr['campo'] = $where;
		$aErr['campo_msg'] = $what;
		array_push ($aErrMsg, $aErr);
		$this->set_var ("_elementos_fail", $aErrMsg, "INMED");
	}

	function perror_plt ($link = NULL) {
		if (!$link)
			$link = "javascript: history.go(-1);";
		$this->set_var ('__error_return_link', $link, "INMED");
		return "errores.plt";
	}

} /******* FIN DE LA CLASE **********/

/**
  * Listado de Logs:
  * $Log: sesiones.inc,v $
  * Revision 1.1.2.1.4.22.4.11.4.36.2.8  2004/11/09 19:26:18  tite
  * Fixes sistema de pestanyas para safari, y metodo de abono por defecto en configuracion. Tite
  *
  * Revision 1.1.2.1.4.22.4.11.4.36.2.7  2004/07/28 16:17:52  tite
  * fixes de kernel aplicados en el crm para la compibilidad de las modificaciones del metodo ruta, con la api de modulos. Tite
  *
  * Revision 1.1.2.1.4.22.4.11.4.36.2.6  2004/07/19 10:26:50  tite
  * Escritorio de operador. mas o menos ok. Gestion de notas de cliente, personas de contacto, enlaces y servicios, ok. Tite
  *
  * Revision 1.1.2.1.4.22.4.11.4.36.2.5  2004/06/20 16:18:30  tite
  * Gestion con soporte RFQs y documental, a falta de pii de seleccion de productos de presupuesto en ficha de rfq. Tite
  *
  * Revision 1.6.4.6  2004/06/08 12:49:29  tite
  * Actualizado kernel para anyadirle soporte de aliasing en metodo ruta. Tite
  *
  * Revision 1.1.2.1.4.22.4.11.4.36.2.4  2004/05/23 14:54:07  tite
  * doc_roto anyadido a la cfg del kernel. Tite
  *
  * Revision 1.1.2.1.4.22.4.11.4.36.2.3  2004/05/23 09:39:39  tite
  * Fix -de nuevo- de denegacion de pii's por grupos caso de ser varios los denegados. Tite
  *
  * Revision 1.1.2.1.4.22.4.11.4.36.2.2  2004/05/20 16:42:13  tite
  * Fixes varios. Tite
  *
  * Revision 1.1.2.1.4.22.4.11.4.36.2.1  2004/05/20 10:25:13  tite
  * Envio de documentos por email. Tite
  *
  * Revision 1.1.2.1.4.22.4.11.4.36  2004/03/11 16:40:32  tite
  * Fixes varios . Tite
  *
  * Revision 1.1.2.1.4.22.4.11.4.35  2004/02/24 14:39:01  tite
  * soporte left_join en ruta
  *
  * Revision 1.2.2.3.4.4  2004/02/23 14:41:36  tite
  * Soporte de left join en metodo ruta, como un parametro mas de retorno, llamado 'left_join_from' y en el metodo tb_delete() que ahora puede recibir una lista de tablas que se desea borrar, con unas condiciones que da igual si pertenecen a las tablas seleccionadas o no, encuentra su camino en la bdd, pone las condiciones y los delete. De esta forma, se permite borrar aunque haya relaciones intermedias inexistentes\!
  *
  * Revision 1.1.2.1.4.22.4.11.4.34  2004/02/21 16:31:12  tite
  * anyadida directiva --cfgpath como ruta donde residan los ficheros de configuracion. Tite
  *
  * Revision 1.1.2.1.4.22.4.11.4.33  2004/02/08 19:44:38  tite
  * Impresion de factura remaquetada con oja de estilos xaxi.
  * El salto de pagina esta hecho, pero falta que el pie se alinee abajo del todo en el div de contenido. Tite
  *
  * Revision 1.1.2.1.4.22.4.11.4.32  2004/02/08 10:48:08  tite
  * Escritorio de cliente. A falta de control de acceso en facturas a emision e impresion normal y de ticket. Tite
  *
  * Revision 1.1.2.5  2004/02/05 20:40:57  tite
  * Fixes al kernel en la obtencion de las variables de tipo arg_var de plantillas, cuando el nombre de variable no coincide
  * con el nombre de clave primaria de la entidad de cual se desea obtener un registro unitario. Tite
  *
  * Revision 1.1.2.1.4.22.4.11.4.31  2004/02/05 17:40:23  tite
  * Soporte multipuerto bdd en kernel. Tite
  *
  * Revision 1.1.2.1.4.22.4.11.4.30  2004/01/28 19:04:19  tite
  * Parche claves multiples en busquedas con clausula group by (al final si hizo falta tocar las busquedas) . Tite
  *
  * Revision 1.1.2.1.4.22.4.11.4.29  2004/01/27 11:41:23  tite
  * Soporte para claves multiples en los enganches de bloques de datos en el motor de plantillas. En el buscador, esta sin comprobar, pero
  * no deberia hacerse necesario. Tite
  *
  * Revision 1.1.2.1.4.22.4.11.4.28  2003/12/21 18:24:42  tite
  * KernelFix: uno de los ultimos parches aplicados al almacenamiento de variables de sesion, en el cual no se sobre-escribia la caducidad de una variable, tenia el problema de asignar la caducidad (en el caso de instancias) en el vector de variables. Corregido. Tite
  *
  * Revision 1.1.2.1.4.22.4.11.4.27  2003/12/17 18:38:17  tite
  * Fin de la maquetacion de los maestros. _todos_ Tite
  *
  * Revision 1.1.2.1.4.22.4.11.4.26  2003/12/10 15:49:54  tite
  * Traducidos los Informes. Tite
  *
  * Revision 1.1.2.1.4.22.4.11.4.25  2003/12/10 11:15:07  tite
  * Fix almacenamiento de variables. De tal forma que _solo_ la primera asignacion de una variable define su scope (NOEXPIRE,SUBSECCION,...) Tite
  *
  * Revision 1.1.2.1.4.22.4.11.4.24  2003/12/02 12:14:29  tite
  * fillIfaceWithDefaults() sobreescribia los que ya habia seleccionados. Tite
  *
  * Revision 1.1.2.1.4.22.4.11.4.23  2003/11/28 19:50:18  tite
  * Cambiados los metodos intrusivos en el indice del vector de plantillas en wolSession a un iterador no intrusivo como es el foreach (en vez del while (list=each)) que existia. TIte2
  *
  * Revision 1.1.2.1.4.22.4.11.4.22  2003/11/17 20:52:21  tite
  * Fix ningun_resultado:
  * Acabo de parchear el motor de plantillas y las sesiones para que cuando un where no produce ningun resultado se llame al motor de plantillas para que procese
  * la plantilla de configuracion 'pltcfg_emptysearch' -caso de haberse configurado en _main- o la plantilla null. Actualmente funciona bien pero me surgen dudas de
  * como funcionara en casos no considerados a momento de ahora, es decir, en casos _no_ simples, como es el de que visualice una plt sin programacion ni llamadas a ninguna
  * bdd. Pero si se permite poner una plantilla en lugar de un where, con todas las consecuencias (esto es -pre_code y post_code, llamadas bdd-), debe tenerse en cuenta
  * que ahora mismo los indices de la sesion para mantener pista de las plantillas recorridas, no se estan actualizando. Este hecho podria tener efectos colaterales
  * no deseados que ahora mismo no se pueden testar en profundidad. Cierto es tambien, que el formato de este tipo de llamadas a las plantillas de configuracion es del
  * nombre con formato '::pltcfg:<nombre_xxx>', y por consiguiente no esta en los indices, sino que los metodos get_plt() y exec_plt() lo tienen en cuenta para ir a buscar
  * esta informacion de plantillas al vector de plantillas de configuracion en vez de al de plantillas de la subseccion.
  * Tite
  *
  * Revision 1.1.2.1.4.22.4.11.4.21  2003/11/14 20:24:26  tite
  * Fix arg_var, que ahora no solo se obtiene por get, sino que tambien ser busca en la sesion. Tite
  *
  * Revision 1.1.2.1.4.22.4.11.4.20  2003/11/14 20:21:37  tite
  * Fix arg_var, que ahora no solo se obtiene por get, sino que tambien ser busca en la sesion. Tite
  *
  * Revision 1.1.2.1.4.22.4.11.4.19  2003/11/07 09:50:37  tite
  * Deteccion de iface _antes_ de la autenticacion para que si existe seleccion de iface, no se vea sobrescrito por el valor predefinido por la cfg del usuario que hace login. Tite
  *
  * Revision 1.1.2.1.4.22.4.11.4.18  2003/11/01 21:46:40  tite
  * Actualizando kernel. minor fixes en get_plt_array(). Tite
  *
  * Revision 1.1.2.1.4.22.4.11.4.17  2003/11/01 18:03:13  tite
  * Reponiendo la hoja de estilos de la v 1.4 para impresion. Dado que estas plantillas de impresion no se han tocado, y sino saldrian mal. Tite
  *
  * Revision 1.1.2.1.4.22.4.11.4.16  2003/10/31 18:56:15  tite
  * Subiendo los fixes de Maquetacion. Tite
  *
  * Revision 1.1.2.1.4.22.4.11.4.15  2003/10/14 09:43:07  tite
  *
  * Soporte de mensajes y salida controlada de errores.
  *
  * En escritorio/kernel/errores.inc:
  * Nueva clase IMessage encargada de almacenar y obtener los mensajes en el soporte linguistico deseado. Soporta el envio de
  * parametros junto con el mensaje de tal forma que salgan parseados junto con el mismo. En esta clase destacan los siguientes
  * metodos:
  *
  * 	- setPath($path): Establece la ruta hacia los directorios de idioma con los mensajes. (ej: modulos/locale/)
  * 	- setLocale($locale): Establece el locale/idioma de salida de mensajes (es, en, pt...), que representa el directorio,
  * 	tras setPath() bajo el que cuelgan los ficheros de idioma.
  * 	- addModule($modname,$langfile,$bPersistent): Mediante un modulo, indicamos que existen los ficheros de idioma (y su nombre).
  * 	- addMsg($msgname,$aParametros,$tipo): Esta es la forma de anyadir un mensaje, con un nombre (primera palabra de una linea de
  * 		fichero de idioma) -por ej IKRN_MSG_NOTFOUND-, y vector de parametros (referencial o indexado) para fundir con el idioma.
  * 		El tipo puede ser alguno de los siguientes defines: IM_FATALERROR, IM_ERROR, IM_WARNING, IM_MESSAGE, IM_DEBUG
  * 	- getMsg(): Obtiene el siguiente mensaje en forma de vector con claves 'code', 'name' y 'msg' con el codigo de error, el nombre
  * 		y el contenido del mensaje.
  * 	- haveCode($nTipo): Comprueba si alguno de los mensajes de la lista tiene pertenece al tipo indicado por alguno de los defines
  * 		de tipo.
  *
  * 	Cada fichero de idioma podra tener lineas en blanco, y es una lista con 1 registro por linea separada por tabulador con primer termino
  * 	el nombre del mensaje (a ser posible en mayusculas), segundo el codigo de mensaje por defecto (los Fatales < 100) sustituyen el pii que
  * 	se esta mostrando. El resto de la linea es considerado el mensaje con los parametros encerrados entre {{ y }}
  *
  * El resto de metodos de la clase, mirarlo en el fichero errores.inc
  *
  * En este fichero tambien encontramos la funcion nodb nodb_IMessages_getmsg, encargada de listarnos los valores de retorno del metodo getMsg()
  *
  *
  * prelang/:
  * 	la plantilla errores.lng ha cambiado para acoplarse al nuevo formato.
  * 	nueva plantilla errores_modulos.lng con formato de documento completo, que sustituye a la plantilla base cuando se ha producido algun
  * error en un modulo, o en el precode de la plantilla base.
  *
  * escritorio/kernel/sesiones.inc:
  * 	Por un lado se han conservado los metodos error(), perror() y perror_plt() por compatibilidad del kernel hacia atras.
  *
  * 	La clase IMessages se construye en el constructor y se almacena en el atributo oMsgs.
  *
  * 	_setKrnCfg(): A pesar de ejecutarse solo en el constructor, ahora solo realiza una consulta para todas las variables de nombre 'krncfg_%'
  * 		en la tabla _main de la bdd de configuracion. Y la configuracion de plantillas pasa a llamarse todas 'pltcfg_%' y estar contenida en
  * 		el vector _aCfgPlts[nombre]. Tenemos 4 plantillas configurables, y estas son:
  * 			.- null: Esta es la plantilla que se muestra cuando no se ha encontrado el pii solicitado. bien sea por accesos o por no estar configurado
  * 			.- err_full: Esta es la plantilla que se muestra en caso de error en un modulo o en el precode de la plantilla base.
  * 			.- err_pii: Esta es la plantilla que sustituye al pii del pre_code que ha producido un errorfatal.
  * 			.- err_output: Esta es la plantilla para mostrar el resto de mensajes que no han probocado interrupcion en la ejecucion. (bo_mensajero.plt)
  *
  * 		En todos los casos, el valor de _main en pltcfg_xxxx puede ser el id de la plantilla o el nombre fisico, buscandose ocurrencia en la tabla
  * 		Plantillas en cualquiera de los casos.
  *
  * 	load_modules(): El script de los modulos (a pesar de no ser incluido actualmente en el metodo __wakeup()), ya no contiene la extension, dado que se
  * 		va a presuponer siempre una extension '.inc', y se anyade el modulo a la clase IMessages con fuente de idioma igual que el nombre del script
  * 		pero con extension '.lm'
  *
  * 	set_iface(): Una vez establecido/encontrado el iface definitivo, se indica a la clase IMessages el locale mediante el parametro nemonico del idioma
  * 		activo. De tal forma que sea ese el directorio donde habran de colgar los ficheros correspondiente a ese idioma para todos los modulos.
  *
  * 	init(): Comprobacion de modulos justo depues de la comprobacion de iface e idioma que hay despues de la autenticacion, y acto seguido la comprobacion
  * 		de la existencia de errores en la carga de modulos o no, para sustituir la plantilla base por la plantilla plt_err_full.
  *
  * 	exec_plt(): Comprobacion de que el codigo ejecutado no ha producido mensajes IM_FATALERROR, y caso de ser asi, sustituir el pii actual por la plt
  * 		de salida de mensajes/errores oportuna.
  *
  * 	lcMessage($sErr,$aParam,$nTipo): Nuevo Metodo interfaz con la insercion de mensajes en la clase IMessages. Inserta el mensaje $sErr con los parametros dados
  * 		en la cola de mensajes. metodo setMsg de la clase IMessages.
  *
  * 	getMsgs(): Nuevo Metodo que Devuelve el atributo oMsgs, es decir, la clase IMessages que contiene los mensajes/errores de ejecucion activos. (por referencia);
  *
  * 	perror_link($lnk): Establece el valor del atributo href de la entidad html ANCHOR correspondiente al enlace de volver en la plantilla de visualizacion de errores
  * 		que se muestra caso de interrumpirse la ejecucion -pltcfg_full y pltcfg_pii-. El parametro puede tener varios valores especiales, y estos son:
  * 			BACK: Compone un enlace con '?seccion=<la_subseccion_anterior>' o caso de no existir la subseccion anterior, con un logout.
  * 			LOGOUT: Compone el enlace de log-out.
  * 			HOME: (actualmente no funciona) compone un enlace a la subseccion por defecto del sistema -caso de no existir escritorios- o a la home del escritorio del usuario.
  * 			SECCION: El enlace compuesto apuntara al nombre de _Seccion_ actual, de tal forma que se dispare su atributo main_sub (subseccion predef de la seccion).
  *
  * Tite.
  *
  * PD: La proxima vez desglosare estos mensajes uno a uno por fichero (es lo suyo no?)
  *
  * Revision 1.1.2.1.4.22.4.11.4.14  2003/10/09 09:24:21  tite
  * Fix en el kernel para que la funcion if equals() soporte comparacion de cadena de caracteres. Tite
  *
  * Revision 1.1.2.1.4.22.4.11.4.13  2003/10/07 11:30:45  tite
  * Actualizacion del kernel y comprobacion de secuencias recibidas via post mediante el nuevo metodo verifyVar() y su complemento fetchVar() que ahora hace un calculo crc y lo almacena en un array, junto con el resultado de contrastar el ultimo crc de la secuencia y el actual. el resultado de la comprobacion se obtiene en un bool de retorno de verifyVar, que recibe 3 parametros. 1 con el nombre de la variable, otro con la comprobacion a realizar (definidos por las mascaras IKRN_VAR_CRC_*) y otro con el tipo de comprobacion -que de momento es solo 'prev' y a posteriori sera auth- indicando si el crc del array/sequencia es contrastado con el crc anterior, o con los permisos de usuario -futuro- (msg del crm). Tite
  *
  * Revision 1.1.2.1.4.22.4.11.4.12  2003/10/04 12:42:09  tite
  * Wrong parameter count in function implode: separador = ''. Tite
  *
  * Revision 1.8  2003/10/04 12:18:49  tite
  * Comprobacion de CRCs sobre las claves y valores de las variables recibidas bien sea por post, o por get.
  * Tenemos un nuevo metodo en la clase wol_session , es verifyVar, que nos hace una comprobacion de la 'integridad' de una variable previamente obtenida
  * via fetchVar(). Este metodo admite 3 parametros, con el primero obligatorio. El primero es el nombre de variable de la que se desa comprobar la integridad.
  * El segundo parametro es las banderas del tipo de comprobacion que se desea (IKRN_VAR_CRC_... de momento), asi por ej la bandera IKRN_VAR_CRC_CHANGE -valor predefinido-
  * devuelve TRUE en el caso de que la variable sea nueva, o el crc de los valores del vector, no coincida con el ultimo obtenido, pudiendo por consiguiente filtrar los
  * formularios recibido por recarga de un post. El tercer parametro se usara en un futuro, es el tipo, actualmente solo 'prev' para este tipo de comprobacion, mas
  * adelante existira 'auth' para comprobar el nivel de acceso de un grupo/usuario a un determinado formulario. Tite
  *
  * Revision 1.1.2.1.4.22.4.11.4.10  2003/09/03 10:39:58  tite
  * Correccion de algunos errores en la deteccion de iface, y puesto metodo _fillIfaceWithDefaulst() en el metodo set_plts() que rellene las partes del iface que atanyen a rutas, con los valores por defecto definidos en el kernel. Obtencion de variables de configuracion del kernel en el construcctor, asi como de nombres de tablas para que no se repitan esas consultas mas que una vez en toda la sesion. Tite
  *
  * Revision 1.1.2.1.4.22.4.11.4.9  2003/09/02 15:40:52  tite
  * Algunas funciones menos en el kernel, y mejoradas funciones de cabecera. TIte
  *
  * Revision 1.1.2.1.4.22.4.11.4.8  2003/08/16 19:34:28  tite
  * parches para almacenamiento de checkboxes en busquedas y ordenacion de resultados de busqueda por enlace en encabezado de listado. Tite
  *
  * Revision 1.1.2.1.4.22.4.11.4.7  2003/08/05 17:14:13  tite
  * Patch ordenacion de listado en busquedas enviando la variable _search_sort por GET, e indentado el motor de plantillas.inc. Tite
  *
  * Revision 1.1.2.1.4.22.4.11.4.6  2003/07/29 17:12:52  tite
  * Merge con la version 1_04b en la que se incluye patch de macosx. Tite
  *
  * Revision 1.1.2.1.4.22.4.11.4.5  2003/07/23 19:08:46  tite
  * programacion cambio de pestanyas en cabecera. Tite
  *
  * Revision 1.1.2.1.4.22.4.11.4.4  2003/07/20 19:34:16  tite
  * Movida la palabre clave Log al final del fichero. asi no incomoda en el uso diario del fichero. Tite
  *
  **/

  
     

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
	var $aPunteros;				  /* Array de punteros actuales a campos para la opcion */
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
		return $this->nombre;
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
			// TMP: if ($oSesion->do_query()) {
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
			// salida("aTablas[$i] = ".$aTablas[$i]."<BR>\n");
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
		// print_r($aConsulta[0]);
		foreach ($aConsulta[1] as $parte_del_from)
			$from .= $parte_del_from.((++$i == $nPartes_from) ? "" : ", ");

		$extra_sel = $this->get_extra_select ();
		if (!empty ($extra_sel))
			$select = "$extra_sel".((!empty ($select)) ? ", ".$select : '');
		$limit = $this->get_limit ();
		$groupby = $this->get_group ();
		$orden = $this->get_order ();
		$consulta = "SELECT $select FROM $from ";
		// salida("uissssss select con $from");
		if ($extra_where = $this->get_where ()) {
			$where .= (($where) ? " AND" : "")." ( ".$extra_where." ) ";
		}
		if (!empty ($where))
			$consulta .= " WHERE ".$where;
		if (!empty ($groupby))
			$consulta .= " GROUP BY ".$groupby;
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
			if ($this->aDatos = $func ($this->sesion, $this->nombre))
				return 1;
			else
				return 0;
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
				$this->aDatos = $this->db->fetch_array ($this->resultados);
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
		if (!$this->aDatos = $this->sesion->fetch_array ($this->sesion->get_id ()))
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

	function get_data($fldname) {
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
		if (!is_numeric($nolink))
			return 0;
		$this->nolink = $nolink;
		return 1;
	}

	function get_nolink () {
		return $this->nolink;
	}

	function set_cfunc ($func) {
		if (empty ($func))
			return 0;
		$this->cfunc = $func;
		return 1;
	}

	function get_cfunc () {
		return $this->cfunc;
	}

	function set_group ($grupo) {
		$this->group = $grupo;
		return true;
		/** **
		if (empty ($grupo))
			return 0;
		if (strchr ("\.", $grupo))
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
		$this->hijos_point++;
		return $hijo;
	}

	function check_sig_hijo () {
		return $this->hijos_point;
	}

			/** reset de los punteros **/
	function reset_pointers () {
		global $oSesion;
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

	$oSesion = $Sesion;
	$oDb = &$Sesion->get_db ("data");
	global $oDb;
	motor_plantilla ($Sesion);
	return $Sesion;
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
function motor_plantilla (&$oSesion, $plt = "") {
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
//debug("plt = ($plt)");
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

	$plt = trim ($plt);
	$tmp = $oSesion->exec_plt ($plt);
	if (!empty ($tmp))
		$planti = $tmp;

	$tmp_path = $oSesion->get_pltdir();
	if (!$tmp_path) {
		aviso("No se encuentra $planti");
		return NULL;
		// $oSesion->set_error();
		// $planti = $oSesion->get_pltdir(NULL).$oSesion->error_plt();
	} else
		$planti = $tmp_path.$planti;

	if ($nPlantilla == -1)
		$nPlantilla = 0;
	else
		$nPlantilla++;
	$fPoint = (int) $afPoint[$nPlantilla];
	$aPlantillas[$nPlantilla] = file_inm ($planti);
	$Plantilla = $aPlantillas[$nPlantilla];

	$raiz = new bucle;
	$raiz->sesion = &$oSesion;

	// $raiz->tabla = $oSesion->get_tb_base();
	$key = $oSesion->get_key ();
	$raiz->clave = $key;

	/*
	 * Estamos presuponiendo que cuando no hay $subsecc, la llamada proviene de otra plantilla (no principal) 
	 */
	$raiz->padre = NULL;

	if (!isset ($oDb)) {
		// $oDb = new wol_db($APP_NAME);
		$oDb = $oSesion->get_db ("data");
		if (!$oDb->conectado ())
			$oDb->conecta (1);
	}
	lector_plantilla ($raiz);
	unset ($Plantilla);
	$raiz->completo = 1;
	if (!isset ($oDb)) {
		$oDb = new wol_db ($APP_NAME);
		$oDb->conecta ();
	}
	scanner ($raiz);
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
		$oBucle->add_line ((parser ($oBucle, $Plantilla[$fPoint])));
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
	global $oSesion;
	// $oBucle->set_visto(0);

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
		if ($oBucle->get_debug ())
			debug ("Hacemos pasada");
		if ($nHayRows) {
			if ($oBucle->get_debug ())
				debug ("hay rows");
		} else {
			if ($oBucle->get_debug ())
				debug ("no hay rows");
			if ($oBucle->get_noresults ()) {	// AND !(int)$oSesion->get_var(num_resultados)) { 
				/*
				 * Esto tan simple, como es visualizar un texto de no hay resultados... se hara en un futuro (esperemos proximo) con
				 * una plantilla. 
				 */
				motor_plantilla($oBucle->sesion,'::pltcfg:emptysearch');
				// global $__wol_no_results;
				// salida ($__wol_no_results);
				continue;
			}							  // Not yest tested: else continue;
		}

		if (!empty ($oBucle->contador))
			$oBucle->aDatos[$oBucle->contador] = $k;
		$cfunc = $oBucle->get_cfunc ();
		if (!empty ($cfunc)) {
			if ($oBucle->get_debug ())
				debug ("cfunc = $cfunc");
			// if ($cfunc($oSesion,$oBucle->aDatos)) {
			if ($cfunc ($oBucle->sesion, $oBucle->aDatos)) {
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
						if (is_array($aMod) AND function_exists($aMod['handler'])) $aMod['handler']($oBucle->sesion,$linea);
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
							$aParam[$aTmp2[0]] = $aTmp2[1];
						} else {
							$aParam[$m] = $aTmp[$m];
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
		if ($this->debug > 5)
			debug ("<b>Esta omtido</b>, restamos");
		if ($this->debug > 5 AND sizeof ($aParams) > 1)
			print_r ($aParams);
		$oBucle->omitir--;
		return 0;
	} else {
		if ($this->debug > 5) debug ("pre-des-omitimos (".$oBucle->omitir.")");
		if ($this->debug > 5 AND sizeof ($aParams) > 1) print_r ($aParams);

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
		if ($this->debug > 5) debug ("des-omitimos (".$oBucle->omitir.")");
	}
}

/** Documentar ...... */
function wdo_if (&$oBucle, $aParams) {
	// global $oSesion;
	$oSesion = &$oBucle->sesion;
	if (!is_array ($oBucle->stkIfs)) $oBucle->stkIfs = array ();
	array_push ($oBucle->stkIfs, (int) $oBucle->omitir);
	if ($this->debug > 5)
		debug ("If: omitir = ".$oBucle->omitir);
	if ((int) $oBucle->omitir) {
		if ($this->debug > 5)
			debug ("omitir ++ - <b>return</b>");
		$oBucle->omitir++;
		return 0;
	}
	$func = array_shift ($aParams);
	if ($this->debug > 5)
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
		if ($this->debug > 5) debug ("wdo_get $param (".$sess_val.")");
		if (is_numeric ($param))
			array_push ($aFuncParams, $param);
		elseif (isset ($oBucle->aDatos[$param])) {
			if ($this->debug > 5)
				debug ("in aDatos: ".$oBucle->aDatos[$param]);
			$aFuncParams[$param] = $oBucle->aDatos[$param];
		}
		elseif (!empty ($sess_val) OR is_numeric ($sess_val)) $aFuncParams[$param] = $sess_val;
		else
		array_push ($aFuncParams, $param);
		// Solo se aceptan variables y numeros como parametro. No texto: 
	}
	/** Soporte negacion funciones if **/
	if (function_exists($func)) {
		if (is_array($aFuncParams) AND sizeof($aFuncParams))
			$oBucle->omitir = (int) !$func ($oBucle->sesion, $aFuncParams);
		else
			$oBucle->omitir = (int) !$func ($oBucle->sesion, $oBucle->aDatos);
		if ($bNegar) $oBucle->omitir = !$oBucle->omitir;
	} else {
		//FixMe: Escupir error a salida de errores
		$oBucle->omitir = 1;
	}
	/** **/

	if ($this->debug > 5) debug ("If func = $func  retval(". ! $oBucle->omitir.")");
}

/** Documentar ..... **/
function wdo_endif (&$oBucle, $aParams) {
	if (sizeof ($oBucle->stkIfs)) {
		$oBucle->omitir = array_pop ($oBucle->stkIfs);
		if ($this->debug > 5 AND sizeof ($aParams) > 1)
			print_r ($aParams);
		if ($this->debug > 5)
			debug ("pop-end-if(".$oBucle->omitir.")");
	} else {
		if ($this->debug > 5 AND sizeof ($aParams) > 1)
			print_r ($aParams);
		$oBucle->omitir = 0;
		if ($this->debug > 5)
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
			$varaddr = $oBucle->aDatos[$aTmp[1]];
		} else {						  // Si no esta en los datos ni es numerico, lo metemos a pelo en la sesion
			$tmp = wdo_get ($oBucle, $aTmp[1]);
			// debug("Obtenemos ($tmp) de ".$aTmp[1]);
			if (!isset($tmp) OR (!is_numeric($tmp) AND empty($tmp))) {
				// Si el valor _es_ una variable (no vale otra cosa). Asignamos null (no encontrado)
				if (!strcasecmp($aParams['value'],'var')) $varaddr = NULL;
				else $varaddr = $aTmp[1];
			} else $varaddr = $tmp;
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
	if (empty($aParams['lcfmt'])) $_lcfmt = FALSE;
	else $_lcfmt = TRUE;

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
		if (is_numeric ($aParams["nolink"]))
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
		if (!empty ($aParams["debug"]))
			$oBucle->hijos[$nuevo]->set_debug ($aParams["debug"]);
		if (!empty ($aParams["where"]))
			$oBucle->hijos[$nuevo]->set_where ($aParams["where"]);
		if (!empty ($aParams["ruta_path"]))
			$oBucle->hijos[$nuevo]->set_ruta_path ($aParams["ruta_path"]);
		if (!empty ($aParams["not_ruta_path"]))
			$oBucle->hijos[$nuevo]->set_not_ruta_path ($aParams["not_ruta_path"]);
		if (!empty ($aParams["escape_html"]))
			$oBucle->hijos[$nuevo]->set_html_escape ((int) $aParams["escape_html"]);

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
		if (is_numeric ($aParams["nolink"]))
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
		if (!empty ($aParams["warn"]))
			$oBucle->set_warnlev ($aParams["warn"]);
		if (!empty ($aParams["debug"]))
			$oBucle->set_debug ($aParams["debug"]);
		if (!empty ($aParams["ruta_path"]))
			$oBucle->set_ruta_path ($aParams["ruta_path"]);
		if (!empty ($aParams["not_ruta_path"]))
			$oBucle->set_not_ruta_path ($aParams["not_ruta_path"]);
		if (!empty ($aParams["escape_html"]))
			$oBucle->set_html_escape ((int) $aParams["escape_html"]);

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
//aviso("split de as, tamaño = ".sizeof($aTmp));
	if (sizeof ($aTmp) > 1) {
		$oBucle->add_extra_select ($aParams[0]);
		$display = trim ($aTmp[0]);
		$final = ereg_replace ("[\'\"]", "", trim ($aTmp[1]));
//salida("parte as ".$aTmp[1]."<br>");
//debug("final = $final");
	}
	elseif (!(strpos ($display, "(") === false)) {
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
			$id_func = add_func ($oBucle, $funcion);
			$display = $aTmp[1];
			$aTmp = split ("\.", $display);
			if (sizeof ($aTmp) > 1) {
				$tabla = $aTmp[0];
				$campo = $aTmp[1];
				if (!$this->contador || strcmp ($this->contador, $tabla))
					$oBucle->add_field ($tabla, $campo);
			} else {
				$tabla = $aTmp[0];
				if (!$this->contador || strcmp ($this->contador, $tabla))
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
			if (!$this->contador || strcmp ($this->contador, $tabla))
				$oBucle->add_field ($aTmp[0]);
		} else {
			$tabla = $aTmp[0];
			if (!$this->contador || strcmp ($this->contador, $tabla))
				$oBucle->add_field ($aTmp[0]);
		}
		if (!isset ($final))
			if (!empty ($campo))
				$final = $tabla.".".$campo;
			else
				$final = $tabla;
	}

	if (isset ($aParams["s"])) {
		if (strstr ($aParams["s"], ",")) {
			$aTmp = split (",", $aParams["s"]);
			if (sizeof ($aTmp) > 1) {
				$oBucle->$aPunteros[$aParams[0]] = $aTmp[0];
				$hasta = $aTmp[1];  // parche 18-05-01: $aTmp[0]+$aTmp[1];
				$final .= ";c|".$aTmp[0].",".$hasta;
			} else {
				$oBucle->$aPunteros[$aParams[0]] = $aTmp[0];
				$final .= ";c|".$aTmp[0].",fin";
			}
		} else {
			$oBucle->$aPunteros[$aParams[0]] = 0;
			$final .= ";c|".$aParams["s"];
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
	for ($i = 0; list ($clave, $valor) = each ($aParam); $i++) {
		if (!strcmp ($clave, "c")) {
			$aTmp = split (",", $valor);
			$datos = substr ($oBucle->aDatos[$aParam[0]], $aTmp[0], $aTmp[1]);
			$retval = ($oBucle->get_html_escape ())? htmlspecialchars (stripslashes ($datos)) : stripslashes ($datos);
			return $retval;
		}
		if (!strcmp ($clave, "f")) {
			$id = (int) $valor;
			$funcion = get_func ($oBucle, $id);
			$datos = $funcion ($oBucle->aDatos[$aParam[0]], $oSesion);
			$retval = ($oBucle->get_html_escape ())? htmlspecialchars (stripslashes ($datos)) : stripslashes ($datos);
			return $retval;
		}
		if (!strcmp ($clave, "p"))
			return subir_padre ($aParam[0]);
	}
	$retval = ($oBucle->get_html_escape ())?
		htmlspecialchars (stripslashes ($oBucle->aDatos[$aParam[0]])) : stripslashes ($oBucle->aDatos[$aParam[0]]);
//debug("retval($aParam[0]) = $retval");
	// if ($oBucle->omitir) $retval = NULL;
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
		motor_plantilla ($oSesion, $secc);
	else {

			/** 
			* Fixme: Para recuperar el nombre de plantilla caso de que este nombre
			**/
		$old_plt_name = $oSesion->plt_name;
		$oSesion->plt_fwd ();
		motor_plantilla ($oSesion);
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
	while ($param = array_shift ($aParams)) {
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

	if (is_array ($aFuncParams))
		return $func ($oSesion, $aFuncParams);
	else
		return $func ($oSesion, $oBucle->aDatos);
}

function add_func (&$oBucle, $funcion) { 
	$tope = count ($oBucle->funciones);
	$oBucle->funciones[$tope] = $funcion;
	return $tope;
}

function get_func (&$oBucle, $id) {
	return $oBucle->funciones[$id];
}

  
      

## MODULO  -  error_mod.php3
## Este modulo Contiene funciones de control e interrupcion de errores asi como funciones genericas.

define(IM_FATALERROR,	1);
define(IM_ERROR,			2);
define(IM_WARNING,		3);
define(IM_MESSAGE,		4);
define(IM_DEBUG,			5);

class IMessages {

	var $_aModules = array( 		// Vector indexado por nombre de modulo con los modulos disponibles.
		'modname' => array(
			'src' => NULL,				// Nombre del fichero de  idioma
			'persistent' => TRUE,	// Si se ha de incluir siempre este modulo o no.
			'included' => TRUE,		// Si ya se ha incluido el fichero de idiomas o no
			'rawmsgs' => array(		// Vector indexado por _nombre de mensaje_ con el contenido de la linea del mensaje.
				'code' => 0,			// Codigo del mensaje (severidad)
				'msg' => NULL			// Mensaje completo.
				)
			)
			);

	/**
	  * Pila contenedora de los mensajes disponibles para salida.
	  */
	var $_aMsg = array(
		'' => array(					// El vector esta indexado por _nombre_ de mensaje.
			'name' => NULL,			// Otra vez nombre del mensaje.
			'code' => 0,				// Codigo del mensaje.
			'msg' 	=> NULL			// Texto, ya procesado, del mensaje.
			)
			);
	/**
	  * Pila contenedora de los mensajes _no_ preparados para salida.
	  **/
	var $_aPreMsgs = array(
			'id' => NULL,				// codigo o nombre del mensaje solicitado
			'param' => array(),		// vector de parametros para procesar el mensaje
			'codegiven' => 0			// nivel/codigo de severidad deseado
			);
	/**
	  * Vector indexado por nombre de mensaje apuntando al contenido del mensaje.
	  */
	var $_rawMsgs = array(
			'name' => NULL
			);

	/**
	  * Rangos de codigos aplicables.
	  **/
	var $_aCodeRange = array(
			IM_FATALERROR => array(0,99),
			IM_ERROR => array(100,299),
			IM_WARNING => array(300,499),
			IM_MESSAGE => array(500,999),
			IM_DEBUG => array(1000,2000)
			);

	var $activeLocale = NULL;		// Locale/Idioma activado.
	var $path = NULL;					// Ruta al directorio de los locales.

   function IMessages() {
		// Modulos/Ficheros de mensajes
		$this->_aModules=NULL;

		// Mensajes:
		$this->_aMsg = array();
		$this->_aPreMsgs = array();

		// Rango de Codigos.
   }

   function init($lang) {
   }

   function setLocale($locale) {
		// TODO: Hacer comprobacion sobre la existencia del locale en cuestion.
      // debug("setlocale(): meteremos $locale no?");
		$this->activeLocale = $locale;
		return TRUE;
   }

   function getLocale($locale) {
		return $this->activeLocale;
   }

   function setPath($path) {
		// TODO: Hacer comprbaciones sobre el path.
		$this->path = $path;
      // debug("El locale path sera $path");
		return TRUE;
   }

   function addModule($mod_name,$lang_file,$bPersist = FALSE) {
      // debug("Anyadimos module $mod_name con file $lang_file Persistente: ".$bPersist);
		if (empty($mod_name)) return FALSE;
		if (!is_array($this->_aModules[$mod_name]) OR !sizeof($this->_aModules[$mod_name]))
			$this->_aModules[$mod_name] = array();
		$this->_aModules[$mod_name]['nombre'] = $mod_name;
		// TODO: Hacer comprobaciones sobre la validez del fichero.
		$this->_aModules[$mod_name]['src'] = $lang_file;
		$this->_aModules[$mod_name]['persistent'] = $bPersist;
		return TRUE;
   }

	function delModule($mod_name) {
		$this->_aModules[$mod_name] = NULL;
		unset($this->_aModules[$mod_name]);
		return TRUE;
	}

	function getModuleInfo($mod_name) {
		return $this->_aModules[$mod_name];
	}

	function activateModule($modname) {
		if (!is_array($this->_aModules[$modname]) OR !sizeof($this->_aModules[$modname])) return FALSE;
		if ($this->_aModules[$modname]['included']) return FALSE;

		// Para que no de la conya si no encuentra el fichero o algo
		$this->_aModules[$modname]['included'] = TRUE;
		// debug("Activating module $modname ..");

		$actpath = $this->path.'/'.$this->activeLocale;
		if (!is_dir($actpath)) {
			$this->addMsg('IKRN_SYS_NODIR',array($actpath));
			return FALSE;
		}
		$srcfile = $actpath.'/'.$this->_aModules[$modname]['src'];
		if (!is_file($srcfile)) {
			$this->addMsg('IKRN_SYS_NOFILE',array($srcfile));
			return FALSE;
		}

		$aTmp = file($srcfile);

		foreach ($aTmp as $line) {
			$l = trim($line);
			if (empty($l)) continue;
			if (!strcasecmp('#',substr($l,0,1))) continue;

			$aLine = preg_split("/[\t= ]+/",$l);

			$msgname = $aLine[0];
			$l = str_replace($msgname,'',$l);
			if (is_numeric($aLine[1])) {
				$msgcode = (int)$aLine[1];
				$l = str_replace($msgcode,'',$l);
			}
			$msgtext = trim($l);

			// debug("name: $msgname   code: $msgcode  y text: $msgtext");
			$this->_aModules[$modname]['rawmsgs'][$msgname] = array('code' => $msgcode, 'msg' => $msgtext);

		}

		return FALSE;
	}

   function addMsg($msg,$aParam = NULL,$msg_no = NULL) {
		$aTmp ['id'] = $msg;
		if (is_array($aParam)) $aTmp['param'] = $aParam;
		if (is_numeric($msg_no)) $aTmp['codegiven'] = $msg_no;
		array_push($this->_aPreMsgs,$aTmp);

		return 0;
   }

	function haveCode($cod) {
		if (!is_numeric($cod) OR empty($cod)) return FALSE;
		if (!is_array($this->_aCodeRange[$cod]) OR !sizeof($this->_aCodeRange[$cod])) 
			return FALSE;
		$aCod = $this->_aCodeRange[$cod];
		$this->flushMessages();
		if (!is_array($this->_aMsg) OR !sizeof($this->_aMsg)) return FALSE;
		$bFound = FALSE;
		foreach ($this->_aMsg as $aM) {
			if ($aM['code'] >= $aCod[0] AND $aM['code'] <= $aCod[1]) {
				$bFound = TRUE;
				break;
			}
		}
		return $bFound;
	}

	function getMsg() {
		$this->flushMessages();

		if (!is_array($this->_aMsg) OR !sizeof($this->_aMsg)) return NULL;
		else {
			// Realizar comprobaciones de nivel de verbosidad.
			return array_shift($this->_aMsg);
		}
	}

	function flushMessages() {
		if (!is_array($this->_aPreMsgs) OR !sizeof($this->_aPreMsgs)) return FALSE;
		if (!is_array($this->_aMsg)) $this->_aMsg = array();

		$goOn = TRUE;
		while (sizeof($this->_aPreMsgs)) {
			$aPre = array_shift($this->_aPreMsgs);
			if (sizeof($this->_aPreMsgs)) $goOn = TRUE;
			else $goOn = FALSE;

			$codegiven = NULL;
			if (is_numeric($aPre['codegiven']) AND is_array($this->_aCodeRange[$aPre['codegiven']])) {
				$codegiven = $this->_aCodeRange[$aPre['codegiven']][1];
			}

			// Si no hay id ni nombre para buscar, no se saca el mensaje (Mejor seria cambiarlo no? por un mensaje desconocido)
			$aRawmsg = $this->rawMsg($aPre['id']);
			if (!$aRawmsg) {
				if (!strcasecmp($aPre['id'],'IKRN_MSG_NOTFOUND')) {
					array_push($this->_aMsg,array('name' => 'Error de Configuracion', 'code' => $codegiven, 
								'msg' => 'No se han encontrado mensajes del kernel en '.$this->path.'/'.$this->activeLocale));
				} else {
					$this->addMsg('IKRN_MSG_NOTFOUND',array($aPre['id']),$aPre['codegiven']);
				}
				continue;
			}

			if (is_array($aPre['param']) AND sizeof($aPre['param'])) {
				$aRawmsg['msg'] = $this->parseMsg($aRawmsg['msg'],$aPre['param']);
			}

			// Insertando el mensaje en la cola.
			array_push($this->_aMsg,array('name' => $aPre['id'], 
													'code' => ( (is_numeric($codegiven)) ? $codegiven : $aRawmsg['code']),
													'msg' => $aRawmsg['msg']));

		}
			
	}

	/**
	  * Obtiene el mensaje 'puro' a partir de un id o un nombre.
	  **/
	function rawMsg($idmsg) {

		if (!is_array($this->_aModules) OR !sizeof($this->_aModules)) return NULL;

		foreach ($this->_aModules as $idxmod => $aMod) {
			if (is_array($this->_aModules[$idxmod]['rawmsgs'][$idmsg])) {
				return $this->_aModules[$idxmod]['rawmsgs'][$idmsg];
			}
			if (!$aMod['included']) {
				$this->activateModule($idxmod);
			}
			if (is_array($this->_aModules[$idxmod]['rawmsgs'][$idmsg])) {
				return $this->_aModules[$idxmod]['rawmsgs'][$idmsg];
			}
		}

		return NULL;
	}

	function parseMsg($msg,$aParam = NULL) {
		if (!is_array($aParam) OR !sizeof($aParam)) {
			$pat[] = '/(.*)({{.*}})(.*)/';
			$rep[] = "\\1"."\\3";
			$retmsg = preg_replace($pat,$rep,$msg);
			$retmsg = str_replace('\n',"\n",$retmsg);
			return $retmsg;
		}

		$bFoundAny = FALSE;
		$retmsg = $msg;
		foreach ($aParam as $idx => $val) {
			if (strstr($msg,'{{'.$idx.'}}')) {
				$bFoundAny = true;
				$retmsg = str_replace('{{'.$idx.'}}',$val,$retmsg);
				$retmsg = str_replace('\n',"\n",$retmsg);
			}
		}

		if (!$bFoundAny) {
			// Obtenemos el numero de variables que hay que sustituir.
			$ni = substr_count($retmsg,'{{');
			$nf = substr_count($retmsg,'}}');
			if ($ni == $nf) $n = $ni;
			if ($ni < $nf) $n = $ni;
			else $n = $nf;

			// Ajustamos el tamanyo de aParam para que coincida con el numero de variables a sustituir
			if (sizeof($aParam) > $n) {
				while (sizeof($aParam) != $n) array_pop($aParam);
			} elseif (sizeof($aParam) < $n) {
				while (sizeof($aParam) != $n) array_push($aParam,'');
			}

			$bTiene = TRUE;
			while ($bTiene) {
				// Obtenemos los elementos en orden inverso dado que la regexp tb los reemplaza en orden inverso.
				$val = array_pop($aParam);
				if (sizeof($aParam)) $bTiene = TRUE;
				else $bTiene = FALSE;
				$pat[] = '/(.*)({{.*}})(.*)/';
				$rep[] = "\\1".$val."\\3";
			}
			$retmsg = preg_replace($pat,$rep,$retmsg);
			$retmsg = str_replace('\n',"\n",$retmsg);
		}

		return $retmsg;
	}

   function cerrar() {
      // debug("Chapando errores => marcando los includes como _no_ incluidos, y cepillandose los no persistentes");
		if (is_array($this->_aModules) ANd sizeof($this->_aModules))
			foreach ($this->_aModules as $idxm => $aM) {
				if (!$aM['persistent']) {
					$this->delModule($idxm);
				} else {
					$this->_aModules[$idxm]['included'] = FALSE;
				}
			}

		// debug("premensajes ....");
		// print_r($this->_aPreMsgs);
   }

}

function nodb_IMessages_getmsg(&$Sesion) {

	$aRetVal = NULL;
	$oMsgs = &$Sesion->getMsgs();
	if (is_object($oMsgs)) {
		$aMsg = $oMsgs->getMsg();
		if (is_array($aMsg)) {
			$aRetVal['code'] = $aMsg['code'];
			$aRetVal['name'] = $aMsg['name'];
			$aRetVal['message'] = $aMsg['msg'];
		}
	}
	return $aRetVal;
}

# Funcion de manejo de errores:
// Funcion nodb
function elementos_fallidos(&$oSesion) {
		static $aCampos;
		static $done = 0;
		if ((!$aCampos OR !is_array($aCampos)) AND !$done) {
				$aCampos = $oSesion->get_var("_elementos_fail");
				$oSesion->unset_var("_elementos_fail");
				$done = 1;
		}
		if (is_array($aCampos) AND $campo = array_shift($aCampos)) {
				$aRet_Val = $campo;
		}
		return $aRet_Val;
}

function errores($fichero,$linea){
## Esta funcion recibe como parametros el nombre del fichero y la linea donde se produjo.
## Necesita una variable global que sea $ADMIN con el email del admin.

   global $ADMIN;

   echo "<FONT COLOR=\"#FF0000\">";
   if (mysql_errno()!=0) {
	   echo "\n<BR><BR>Se ha producido un Error:<BR>";
	   echo "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Error Nº ".mysql_errno()." : ".mysql_error()." En $fichero Linea $linea <BR>\n";
	   echo "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Por favor informe de ello a <A href=\"mailto:$ADMIN\">";
	   echo $ADMIN."</A> para posibles soluciones.<BR>\n";
   } else {
	   echo "<BR>Fichero : $fichero - Linea : $linea <BR>";
	   echo "<BR>Problemas con el login o el Password. Contacte con <A href=\"mailto:$ADMIN.\">";
	   echo $ADMIN."</A> para posibles soluciones.<BR>\n";
   }
   echo "</FONT>";
}


# Funcion de aviso (emite una ventana javascript):

function aviso($texto) {
#Recibe como parametro el texto que hay que visualizar.

	salida("<SCRIPT LANGUAGE=\"javascript\">\n");
	salida("alert('".ereg_replace("\n"," ",$texto)."');\n");
	// echo "alert('".ereg_replace(" ","\"+\" ",$texto)."');\n";
	salida("</SCRIPT>\n");
}

function debug($texto) {
#Recibe como parametro el texto que hay que visualizar.
global $DEBUG;
if($DEBUG =="ON")
	salida("debug: ".ereg_replace("\n","<br>",$texto)."<br>\n");
	// echo "alert('".ereg_replace(" ","\"+\" ",$texto)."');\n";

}

### Funcion que nos busca un valor dentro de una tabla.
### Si no lo encuentra devuelve -1 y si lo encuentra, la posicion en la k esta
### Con un array de mas de 2 dimensiones esta funcion casca.
function encuentra($tabla,$objetivo) {

	$length=sizeof($tabla);
	$i=0;
	while($i<$length) {
	    if (sizeof($tabla[$i])>1) {
		$tmp = encuentra($tabla[$i],$objetivo);
		if ($tmp != -1)
		    return $i;
	    } elseif (is_string($tabla[$i])) {
		if (strcmp($tabla[$i],$objetivo)==0) {
		    return $i;
		}
	    } else {
		if($tabla[$i]==$objetivo) 
		    return $i;
	    }
	    $i++;
	}
	return -1;
}


# Funcion de impresion de la cabecera de un documento html.
# 
function cabecera($titulo,$bgcolor,$txcolor,$link,$vlink,$alink,$fondo){

	if ($fondo=="") {
		$fondo="NADA";
	}
	if ($bgcolor=="") {
		$bgcolor = "#FFFFFF";
	} 
	if ($txcolor=="") {
		$txcolor = "#000000";
	}
# he kitao la var $fondo  ----   BACKGROUND=\"$fondo\"
	echo "<HTML><HEAD>\n<TITLE>$titulo</TITLE>\n";
	echo "<SCRIPT LANGUAGE=\"javascript\" SRC=\"funciones.js\">\n";
	echo "</SCRIPT>\n";
	echo "</HEAD>\n<BODY BGCOLOR=\"$bgcolor\" TEXT=\"$txcolor\"";
	echo " BACKGROUND=\"$fondo\" ";
	echo " link=\"$link\" vlink=\"$vlink\" alink=\"$alink\">\n";

}


### Esta funcion cierra todos los html.
function pie($strVuelta = "",$sAction = "") {
// global $imagenes;

echo "</CENTER></FORM><CENTER>";
if (empty($sAction)) $sAction = getenv("SCRIPT_NAME");
echo "<FORM ACTION=\"$sAction\">\n";
if (!empty($strVuelta)) put_hidden($strVuelta);
echo "<BR><INPUT TYPE=SUBMIT VALUE=Volver>\n";
echo "</FORM>\n";

}

### Esta funcion cierra todos los html.
function pie_back() {
    echo "</CENTER></FORM><CENTER>";
    echo "<FORM ACTION=\"".getenv("SCRIPT_NAME")."\">\n";
    echo "<BR><INPUT TYPE=SUBMIT VALUE=Volver ";
    echo "OnClick=\"history.go(-1); return false;\">\n";
    echo "</FORM>\n";
}

### Esta funcion nos pasa a formato HTML cualquier string que nos llege.
function to_html($cadena) {
    //return ereg_replace("ñ","[&ntilde;]",$cadena);
    return $cadena;
}

/** put_hidden($string) :
  *	Esta funcion sopone la existencia de un formulario en cual se desea
  *	insertar LOS valores de $string como elementos HIDDEN dentro del 
  * 	mismo.
  *	PRESUNCIONES: Esta funcion presupone la existencia YA creada del 
  *	tag <FORM>
  */
function put_hidden($string)
{
    if (!empty($string)) {
	$aVuelta = split("\&",$string);
	$lVuelta = sizeof($aVuelta);
	for ($i=0; $i<$lVuelta; $i++) {
	    $tmpVuelta = split("\=",$aVuelta[$i]);
	    echo "<INPUT TYPE=HIDDEN NAME=\"".$tmpVuelta[0];
	    echo "\" VALUE=\"".$tmpVuelta[1]."\">\n";
	}
    } else return 0;
    return 1;
}

/***  std_error($string) :
  *	Esta funcion se limita a visializarnos por pantalla un error con 
  *	un pknyo formato (H3).
  */
function std_error($string)
{
    echo "<BR><CENTER><H3> $string </H3></CENTER><BR>";
    return;
}

/** **
function salida ($contenido) {
	//ahora mismo sabemos si tenemos ke imprimir por la variable global
	global $factura_emitida;
	global $id_fichero_factura;
	if(isset($factura_emitida) and !empty($factura_emitida) 
			and isset($id_fichero_factura) and !empty($id_fichero_factura)){
		fwrite($id_fichero_factura,$contenido);
	}	
	echo  $contenido;
}
/** **/

  
      

/***************************************************************
** Motor de Búsqueda diseñado para www.mundobio.com           **
**    Todos los derechos reservados.                          **
**    Este programa se podra modificar previa notificacion a  **
**    su creador. Su distribucion queda limitada a su creador **
**    que cede derechos de uso a la empresa WIOIL studios.    **
**    Las posibles modificaciones hechas por WIOIL studios    **
**    tanto para la página www.mundobio.com como para otros   **
**    sitios deberan ser notificadas al creador de esta       **
**    aplicacion bien sea por correo electronico en           **
**    tite@mrbit.es o bien llamando a los telefonos 649308160 **
**    o 985112020.                                            **
**                                                            **
**                            (c) Josafat Moragrega Fernandez **
**                                                            **
****************************************************************
***************************************************************/


function lcdec($dato,&$Sesion) {
	static $lcfmt;
	if (!is_array($lcfmt)) $lcfmt = localeconv();
	// print_r($lcfmt);
	return number_format($dato,$lcfmt['frac_digits'],$lcfmt['decimal_point'],$lcfmt['thousands_sep']);
}

function lcpto($dato,&$Sesion) {
	static $lcfmt;
	if (!is_array($lcfmt)) $lcfmt = localeconv();
	return number_format($dato,2,$lcfmt['decimal_point'],$lcfmt['thousands_sep']);
}

function lcmon($dato,&$Sesion) {
	// http://php.mirror.wol/manual/en/function.money-format.php
	// $nums = ereg_replace('[0..9]','',$dato);
	// return money_format('%.2i',$dato);
	// return money_format('%=*#'.strlen($nums).'.2i',$dato);
	return money_format('%=*#4.2i',$dato);
}

function nombre_pii(&$Sesion) {
	return $Sesion->get_plt_name();
}

function selected_value($dato,$oSesion) {
	$tmp = $oSesion->get_var("_selected_value");
	return (($dato==$tmp) ? 'selected="selected"' : NULL);
}

function store_checkmany ($dato = NULL,&$oSesion) {
	static $reset;
	if (is_object($dato)) {
		$reset = 1;
		return;
	}
	if (!$dato) return;

	if (!$reset)
		$tmp = $oSesion->get_var("_checkmany");
	else {
		$reset = 0;
		$oSesion->unset_var("_checkmany");
		$tmp = NULL;
		checkmany(NULL,$oSesion,1);
	}
	if (!is_array($tmp) OR empty($tmp)) $tmp = array();
	array_push($tmp,$dato);
	$oSesion->set_var("_checkmany",$tmp,"INMED");
}

function checkmany ($dato,&$oSesion) {
	static $tmp;
	if ($bReset) {
		$tmp = NULL;
		return;
	}
	if (!$tmp) $tmp = $oSesion->get_var("_checkmany");
	if (!is_array($tmp) OR empty($tmp)) return;
	return (((int)in_array($dato,$tmp)) ? "CHECKED" : NULL);
}

function check_flag ($dato,$Sesion) {
	if (is_object($dato) AND is_array($Sesion)) {
		$dato = NULL;
		$dato = array_shift($Sesion);
	}
	return ( ((int)$dato) ? 'checked="checked"' : NULL);
}

function si_no_flag($dato,$Sesion) {
	if (is_object($dato) AND is_array($Sesion)) {
		$dato = NULL;
		$dato = array_shift($Sesion);
	}

	if (method_exists($Sesion,'getMsgs')) $oMsg = $Sesion->getMsgs();
	if ((int)$dato) {
		if (is_object($oMsg)) $aMsg = $oMsg->rawMsg('IKRN_MSG_YES');
		else $aMsg['msg'] = 'Si';
	} else {
		if (is_object($oMsg)) $aMsg = $oMsg->rawMsg('IKRN_MSG_NO');
		else $aMsg['msg'] = 'No';
	}
   return $aMsg['msg'];
}

function not_empty ($dato,$Sesion) {
	return ( (is_numeric($dato) OR !empty($dato)) ? $dato : "[- -]" );
}

function do_chop($dato,$Sesion) {
	$len = (int)$Sesion->get_var("_chop_length");
	if (!(int)$len) return $dato;
	else return substr($dato,0,$len);
}

function es_numero(&$Sesion,$Param) {
	$dato = array_shift($Param);
	return is_numeric($dato);
}

function a_mayorfecha_b(&$Sesion,$aParams) {
	$fecha_i = array_shift($aParams);
	if (empty($fecha_i)) $fecha_i = time();
	elseif ( ($fecha_i = strtotime($fecha_i)) === -1 ) return 0;
	$fecha_f = array_shift($aParams);
	if (empty($fecha_f)) $fecha_f = time();
	elseif ( ($fecha_f = strtotime($fecha_f)) === -1 ) return 0;

	if ($fecha_i > $fecha_f) return 1;
	else return 0;
}

function inm_count(&$Sesion,$aData) {
	static $i;
	static $ntimes;

	$reset = (int)$Sesion->get_var("_inm_count_reset");
	$tmp = (int)$Sesion->get_var("_inm_count_times");
	if (!isset($i) OR $reset) { // AND $tmp AND $ntimes != $tmp) {
		$ntimes = $tmp;
		$i = 0;
		$Sesion->set_var("_inm_count_reset",0,"INMED");
	}

	if (++$i>=$ntimes) {
			$i=0;
			$r = 1;
	} else $r = 0;

	return $r;
}

function equals(&$Sesion,$Param) {
	$loque = NULL;
	$retval = 0;
	if (is_array($Param)) {
		$val = 0;
		foreach ($Param as $dato) {
			// if (empty($dato) AND !is_numeric($dato)) continue;
			if (!isset($loque)) $loque = $dato;
			elseif (is_numeric($loque) != is_numeric($dato) ) {
				$retval = 0;
				break;
			} elseif (is_numeric($loque) AND $loque != $dato) {
				$retval = 0;
				break;
			} elseif (!is_numeric($loque) AND strcasecmp($loque,$dato)) {
				$retval = 0;
				break;
			} else $val = 1;
		}
		$retval = $val;
	} else $retval = 0;
	return $retval;
}

function equals_all(&$Sesion,$Param) {
	$loque = NULL;
	if (is_array($Param))
		foreach ($Param as $dato) {
			if (empty($dato) AND !is_numeric($dato)) continue;
			if (!$loque) $loque = $dato;
			elseif ($loque != $dato) return 0;
		}
	return 1;
}

function equals_any(&$Sesion,$Param) {
	$loque = NULL;
	if (is_array($Param))
		foreach ($Param as $dato) {
			if (empty($dato) AND !is_numeric($dato)) continue;
			if (!is_numeric($loque) AND empty($loque)) $loque = $dato;
			elseif ($loque == $dato) return 1;
		}
	return 0;
}

function esta_vacio($Sesion,$Param) {
	$vacio = 1;
	if (is_array($Param))
		foreach ($Param as $idx => $par) {
			if (is_numeric($idx)) continue;
			if (!empty($par) AND !is_numeric($par)) $vacio = 0;
			elseif (is_numeric($par) AND (float)$par) $vacio = 0;
		}
	return $vacio;
}

function switch_alfa_dec(&$Sesion,$aParams) {
	$estado = array_shift($aParams);
	if (is_numeric($estado)) {
		$i = 0;
		foreach ($aParams as $key => $val) {
			if ($i++ == $estado) return $val;
		}
	} else {
		$retval=$aParams[$estado];
	}
	return $retval;
}

function primer_novacio(&$Sesion,$Param) {
	$retval = NULL;
	if (is_array($Param))
		foreach ($Param as $idx => $par) {
			if (is_numeric($idx)) continue;
			if (!empty($par) OR is_numeric($par)) return $par;
		}
	return $retval;
}

function nodb_iterate(&$Sesion,$aData) {
	static $i;
	static $ntimes;

	$reset = (int)$Sesion->get_var("_iterate_reset");
	$tmp = (int)$Sesion->get_var("_iterate_times");
	if (!isset($i) OR $reset) { // AND $tmp AND $ntimes != $tmp) {
		$ntimes = $tmp;
		$i = 0;
		$Sesion->set_var("_iterate_reset",0,"INMED");
	}

	if (++$i>$ntimes) 
			$r = NULL;
	else $r = array("iterate_num" => $i);

	return $r;
}

function CheckMail($Email,$Debug=false)
{
    global $HTTP_HOST;
    $Return =array();
    // Variable for return.
    // $Return[0] : [true|false]
    // $Return[1] : Processing result save.

    if (!eregi("^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,3})$", $Email)) {
        $Return[0]=false;
        $Return[1]="${Email} is E-Mail form that is not right.";
        if ($Debug) echo "Error : {$Email} is E-Mail form that is not right.<br>";
        return $Return;
    }
    else if ($Debug) echo "Confirmation : {$Email} is E-Mail form that is right.<br>";

    // E-Mail @ by 2 by standard divide. if it is $Email this "lsm@ebeecomm.com"..
    // $Username : lsm
    // $Domain : ebeecomm.com
    // list function reference : http://www.php.net/manual/en/function.list.php
    // split function reference : http://www.php.net/manual/en/function.split.php
    list ( $Username, $Domain ) = split ("@",$Email);

    // That MX(mail exchanger) record exists in domain check .
    // checkdnsrr function reference : http://www.php.net/manual/en/function.checkdnsrr.php
    if ( checkdnsrr ( $Domain, "MX" ) )  {
        if($Debug) echo "Confirmation : MX record about {$Domain} exists.<br>";
        // If MX record exists, save MX record address.
        // getmxrr function reference : http://www.php.net/manual/en/function.getmxrr.php
        if ( getmxrr ($Domain, $MXHost))  {
      if($Debug) {
                echo "Confirmation : Is confirming address by MX LOOKUP.<br>";
              for ( $i = 0,$j = 1; $i < count ( $MXHost ); $i++,$j++ ) {
            echo "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Result($j) - $MXHost[$i]<BR>";
        }
            }
        }
        // Getmxrr function does to store MX record address about $Domain in arrangement form to $MXHost.
        // $ConnectAddress socket connection address.
        $ConnectAddress = $MXHost[0];
    }
    else {
        // If there is no MX record simply @ to next time address socket connection do .
        $MXHost[0] = $Domain;
        if ($Debug) echo "Confirmation : MX record about {$Domain} does not exist.<br>";
    }

		foreach ($MXHost as $ConnectAddress) {

						// fsockopen function reference : http://www.php.net/manual/en/function.fsockopen.php
						$Connect = @fsockopen ( $ConnectAddress, 25 );

						// Success in socket connection
						if ($Connect)
						{
								if ($Debug) echo "Connection succeeded to {$ConnectAddress} SMTP.<br>";
								// Judgment is that service is preparing though begin by 220 getting string after connection .
								// fgets function reference : http://www.php.net/manual/en/function.fgets.php
								if ( ereg ( "^220", $Out = fgets ( $Connect, 1024 ) ) ) {

										// Inform client's reaching to server who connect.
										fputs ( $Connect, "HELO $HTTP_HOST\r\n" );
												if ($Debug) echo "Run : HELO $HTTP_HOST<br>";
										$Out = fgets ( $Connect, 1024 ); // Receive server's answering cord.

										// Inform sender's address to server.
										fputs ( $Connect, "MAIL FROM: <{$Email}>\r\n" );
												if ($Debug) echo "Run : MAIL FROM: &lt;{$Email}&gt;<br>";
										$From = fgets ( $Connect, 1024 ); // Receive server's answering cord.

										// Inform listener's address to server.
										fputs ( $Connect, "RCPT TO: <{$Email}>\r\n" );
												if ($Debug) echo "Run : RCPT TO: &lt;{$Email}&gt;<br>";
										$To = fgets ( $Connect, 1024 ); // Receive server's answering cord.

										// Finish connection.
										fputs ( $Connect, "QUIT\r\n");
												if ($Debug) echo "Run : QUIT<br>";

										fclose($Connect);

												// Server's answering cord about MAIL and TO command checks.
												// Server about listener's address reacts to 550 codes if there does not exist
												// checking that mailbox is in own E-Mail account.
												if ( !ereg ( "^250", $From ) || !ereg ( "^250", $To )) {
														$Return[0]=false;
														$Return[1]="${Email} is address done not admit in E-Mail server.";
														if ($Debug) echo "{$Email} is address done not admit in E-Mail server.<br>";
														return $Return;
												}
								}
								break;
						} else {
						// Failure in socket connection
								if ($Debug) echo "Can not connect E-Mail server ({$ConnectAddress}).<br>";
								continue;
						}
		}
		if (!$Connect) {
        $Return[0]=false;
        $Return[1]="Can not connect E-Mail server ({$ConnectAddress}).";
        if ($Debug) echo "Can not connect E-Mail server ({$ConnectAddress}).<br>";
        return $Return;
		}
    $Return[0]=true;
    $Return[1]="{$Email} is E-Mail address that there is no any problem.";
    return $Return;
}
  
function make_seed() {
	 list($usec, $sec) = explode(' ', microtime());
	 return (float) $sec + ((float) $usec * 100000);
}

function mkpasswd($maxc = 6) {
	// Coinstruimos una paswd de longitud $maxc
	if (!$maxc) $maxc = 6;
	$aAlf[0][0] = 48;
	$aAlf[0][1] = 57;
	$aAlf[1][0] = 65;
	$aAlf[1][1] = 90;
	$aAlf[2][0] = 97;
	$aAlf[2][1] = 122;
	$retval = '';
	for ($i=0; $i < $maxc; $i++) {
		srand(make_seed());
		$cua = rand(0,2);
		$retval .= chr(rand($aAlf[$cua][0],$aAlf[$cua][1]));
	}
	return $retval;
}

function cambia_var_x(&$sesion) {
	static $valor;
	$tmp = $sesion->get_var("_var_x");
// debug("nos llega ($tmp); tenemos ($valor)");
	if ($tmp != $valor) {
		$valor = $tmp;
		return 1;
	} else return 0;
}

function primera_vez(&$Sesion,$aData) {
	static $i;

	$aCRCs = $Sesion->get_var('_aPrimeraVezCRC');
	if (!is_array($aCRCs)) $aCRCs = array();
	if (!is_array($aData)) $aData = array($aData);

	foreach ($aData as $key => $val) {
		$vallist .= $val;
		$keylist .= $kay;
	}
	$strcrc = crc32($keylist);
	// $strcrc = crc32($vallist);

	$tmp_reset = (int)$Sesion->get_var("reset_listados");
	if (!in_array($strcrc,$aCRCs)) {
		$tmp_reset = 1;
		array_push($aCRCs,$strcrc);
		$Sesion->set_var('_aPrimeraVezCRC',$aCRCs,'INMED');
	}

	if ($tmp_reset OR !isset($i)) $i = 0;
	else $i = 1;
	if ($tmp_reset) $Sesion->unset_var('reset_listados');
	return !$i;
}

function allowed_link(&$Sesion,$aParam) {
	$sub = array_shift($aParam);
	// debug("parm");
	// print_r($aParam);
	if (empty($sub)) return 1;
	$aSubGrants = $Sesion->get_var("_aSubsecGrants");
	if (!is_array($aSubGrants) OR !is_numeric($aSubGrants[$sub])) {
		$db_conf = $Sesion->get_db('conf');
		$usr = $Sesion->get_authed_user();
		$retval = verify_grants($db_conf,$sub,$usr);
		$aSubGrants[$sub] = (int)$retval;
		$Sesion->set_var("_aSubsecGrants",$aSubGrants,"NOEXPIRE");
	} else $retval = $aSubGrants[$sub];
	return $retval;
}

function verify_grants($oDb,$subseccion,$oUsr) {
	if (!is_object($oDb)) return -1;
	$mask = $oUsr->get_mask();
	$cons = "SELECT t1.id_seccion ".
				"FROM Sec_Subsecc t1, Sub_Secc t2, Secciones t3 ".
				"WHERE t1.id_sub_secc = t2.id_sub_secc AND t3.id_seccion = t1.id_seccion AND ".
				"(t2.nombre = '$subseccion' OR t3.nombre = '$subseccion') AND ".
				"(t1.av_group & $mask OR (t1.av_group IS NULL AND t3.av_mask & $mask)) ";
	$rs = $oDb->query($cons);
	if ($oDb->num_rows($rs)) $retval = 1;
	else $retval = 0;
	$oDb->libera($rs);

	return $retval;
}

function allowed_action(&$Sesion,$aParam) {
	$ent = array_shift($aParam);
	$acc = array_shift($aParam);

	$control = (int)$Sesion->getFromKrn('action_access');
	if ($control AND (empty($ent) OR empty($acc)) ) return false;
	elseif (empty($ent) OR empty($acc)) return true;

	if (!strcasecmp($acc,'new') OR !strcasecmp($acc,'nuevo')) $tipo='NEW';
	elseif (!strcasecmp($acc,'edit') OR !strcasecmp($acc,'editar')) $tipo='EDIT';
	elseif (!strcasecmp($acc,'del') OR !strcasecmp($acc,'borrar')) $tipo='DEL';
	elseif ($control) return false;
	else return true;

	$aGrants = $Sesion->get_var("_aActionGrants");
	if (!is_array($aGrants) OR !is_array($aGrants[$ent])) {
		$db_conf = $Sesion->get_db('conf');
		$usr = $Sesion->get_authed_user();
		$aAcc = verify_action($db_conf,$ent,$usr);
		$aGrants[$ent] = $aAcc;
		$Sesion->set_var("_aActionGrants",$aGrants,"NOEXPIRE");
	}
	return (bool)$aGrants[$ent][$tipo];
}

function verify_action($oDb,$entidad,$oUsr) {
	if (!is_object($oDb)) return NULL;
	$mask = $oUsr->get_mask();
	if (!is_numeric($mask) OR empty($entidad)) return NULL;
	$cons = 'SELECT  '.
				' (new_mask & '.$mask.') as "NEW", '.
				' (edit_mask & '.$mask.') as "EDIT", '.
				' (del_mask & '.$mask.') as "DEL"  '.
				'FROM Acciones '.
				'WHERE entidad = "'.$entidad.'" ';
	$rs = $oDb->query($cons);
	if ($oDb->num_rows($rs)) {
		$retval = $oDb->fetch_assoc($rs);
	} else $retval = NULL;
	$oDb->libera($rs);

	return $retval;
}

 function get_from_user(&$Sesion,$Params) {
    $usr = identifica_usuarios($Sesion);
    $what = array_shift($Params);
    return $usr[$what];
 }

/** Apoyo a las Busquedas **/
function check_persistent_search(&$Sesion,$Param) {
   if (!is_array($Param)) return 0;
   $what = array_shift($Param);
   $aTmp = $Sesion->get_var('_searchPersistentData');
   $aVal = $aTmp['contents'];
   if (!is_array($aVal)) return 0;
   if (!isset($aVal[$what])) return 0;
   else return 1;
}

function check_order_field_search(&$Sesion,$Param) {
   if (!is_array($Param)) return 0;
   $what = array_shift($Param);
	// debug("what = $what");
   $aOrder = $Sesion->get_var('_searchOrderRequest');
	// print_r($aOrder);
   if (!is_array($aOrder)) return 0;
   if (!strcasecmp($aOrder['field'],$what)) return 1;
   else return 0;
}

function check_order_type_search(&$Sesion,$Param) {
   if (!is_array($Param)) return 0;
   $what = array_shift($Param);
   $aOrder = $Sesion->get_var('_searchOrderRequest');
   if (!is_array($aOrder)) return 0;
   if (!strcasecmp($aOrder['type'],$what)) return 1;
   else return 0;
}

function nodb_hits_page(&$Sesion) {
	static $aHP;

	if (!is_array($aHP)) {
		$aHP = array( 	array( 'value' => '', 'name' => '--'),
							array( 'value' => 10, 'name' => '10'),
							array( 'value' => 20, 'name' => '20'),
							array( 'value' => 30, 'name' => '30'),
							array( 'value' => 50, 'name' => '50'),
							array( 'value' => 100, 'name' => '100'),
							array( 'value' => 175, 'name' => '175'),
							array( 'value' => 250, 'name' => '250'),
							array( 'value' => 500, 'name' => '500'),
							array( 'value' => 700, 'name' => '700'),
							array( 'value' => 1000, 'name' => '1000'),
							array( 'value' => 0, 'name' => 'Todos')
				);
	} elseif (!sizeof($aHP)) {
		$aHP = NULL;
		return NULL;
	} 
	return array_shift($aHP);
}


/**  borrar_fotos(emp_cod) :
  *        Esta funcion borra fisicamente los ficheros de fotos de una empresa.
  */
function borrar_fotos($id){
global $login;
global $passwd;
global $SQL;
global $tablas;
global $dbase;
global $doc_root;
global $rel_img;

        if(!$SQL=mysql_connect("localhost",$login,$passwd)) {
                errores(__FILE__,__LINE__);
                return 0;
        }

        $consulta = "SELECT * FROM ".$tablas["emp"]." WHERE indice = $id";
        $res = mysql_db_query($dbase,$consulta,$SQL);
        if (!mysql_num_rows($res)) return 0;
        $emp = mysql_fetch_array($res);

        if (empty($emp["foto1"]) AND empty($emp["foto2"])) return 1;

        if (!empty($emp["foto1"])) {
           $tmp = $doc_root."/".$rel_img."/".$emp["foto1"];
           unlink($tmp);
        }

        if (!empty($emp["foto2"])) {
            $tmp = $doc_root."/".$rel_img."/".$emp["foto2"];
            unlink($tmp);
        }

        return 1;
} /** fin de borrar_fotos() **/

/**  upload($tmp_file,$dest)
  *           Esta funcion nos copia el fichero contenido en la ubicacion tmp_file
  *        al destino $dest.
  */
function upload($tmp_file,$dest)
{
    if(!empty($tmp_file)) {
        if(copy($tmp_file,$dest)) {
            if(!chmod($dest,0444)) {
                return 1;
            }
        } else {
            return 0;
        }
    } else {
        return 0;
    }// fin de if!empty(foto);

    return 1;
}

function seguridad($entrada){
## Esta funcion se encarga de la seguridad de las entradas de una aplicacion

            return addslashes($entrada);
}

function salida ($contenido) {
	/** soporte email **/
	/** **/
	echo  $contenido;
}

function emailoutput(&$Sesion,$contenido) {
	$all = $Sesion->get_var('__contenido_email');
	$aM = $Sesion->get_var('__coincidencias');
	if (empty($all)) $all = '';
	if (!is_array($aM)) $aM = array();
	
	$aTmp = array();
	preg_match('/<img.*src="(.*?)".*>/',$contenido,$aTmp);
	if (sizeof($aTmp)) {
		if (!in_array($aTmp[1],$aM)) $aM[] = $aTmp[1];
	}
	$aTmp = array();
	preg_match('/<link.*href="(.*?)".*>/',$contenido,$aTmp);
	if (sizeof($aTmp)) {
		if (!in_array($aTmp[1],$aM)) $aM[] = $aTmp[1];
	}

	$contenido = preg_replace('/(<a.*href=")(.*?)(".*>)/',"\${1}#\${3}",$contenido);
	// debug($contenido);
	$all .= $contenido;

	$Sesion->set_var('__contenido_email',$all,'INMED');
	$Sesion->set_var('__coincidencias',$aM,'INMED');
}

function emailsender(&$Sesion) {
	$aImgs = $Sesion->get_var('__coincidencias');
	$msg = $Sesion->get_var('__contenido_email');
	$email = $Sesion->get_var('__output__email');
	$subj = $Sesion->get_var('__output__email__subject');
	if (!is_array($aImgs)) $imagenes=array();
	else {
		$i=0;
		foreach ($aImgs as $img) {
			if ($img[0] == '/') $src = $Sesion->getFromConf('root_dir');
			else $src = getcwd();
			$aTmp = split('/',$img);
			if (sizeof($aTmp)) {
				$im = $aTmp[sizeof($aTmp)-1];
				$aTmp[sizeof($aTmp)-1] = NULL;
				unset($aTmp[sizeof($aTmp)-1]);
				$tmppath = implode('/',$aTmp);
				$tmppath .= '/';
				$src .= '/'.$tmppath.$im;
				$msg = str_replace($tmppath,'',$msg);
			} else {
				$im = $img;
				$src = $img;
			}
			$imagenes[$im] = $src;
		}
	}
	$aCfg = $Sesion->get_var('_aAppConf');
	mail_attach($email,( (!empty($aCfg['email'])) ? $aCfg['email'] : NULL ),( (!empty($subj)) ? $subj : NULL ),$msg,$imagenes);
}

if (!function_exists ("mime_content_type")) {
	function mime_content_type ($file) {
		return exec ("file -bi " . escapeshellcmd($file));
	}
}


/** **
function esta_en($tabla=array(),$elem="") //,&$posicion)
{
        if (empty($elem)) return 0;
  $max=count($tabla);
  $encontrado=0;
  $i=0;
  while (($i<$max)&&(!($encontrado)))
  {
    if($tabla[$i]==$elem)
    {
     $encontrado=1;
     $posicion=$i;
    }
    $i++;
  }
   return $encontrado;
}
/** **/


/* Esta funcion reemplaza \n por <br> \n al
         sacar un texto por pantalla */
function reemplazar_salto($valor,$Sesion){
                                $valor=ereg_replace("\n","<br>\n",$valor);
                                return $valor;
}

/* Funcisn que crea un directorio en la ruta especificada */
function crear_dir($destino,$perm = 0775){
    if(!mkdir($destino,$perm)){
       return 0;
    } else {
       return 1;
    }
}

/**
  * Función que copia un archivo dado el origen y el destino
  * @param $origen
	* @param $destino
	* @return boolean
	*/
function copiar($origen,$destino,$perms = 0664){
		if (copy($origen,$destino) && chmod($destino, $perms)) return 1; else return 0;
		// One line r0x
}

/**
  * Funcion encargada de retornar el nombre de la ultima subseccion (de la que venimos).
  **/
function inm_prev_subsec(&$Sesion) {
	return $Sesion->get_old_subsecc_name();
}

function contador_inm(&$Sesion,$aData) {
		static $i;
		static $ntimes;

		$tmp = (int)$Sesion->get_var("_inm_count_times");
		if (!isset($i)) { // AND $tmp AND $ntimes != $tmp) {
			$ntimes = $tmp;
			$i = 0;
		}

		if ($i++>=$ntimes) {
				$i=0;
				$r = 1;
		} else $r = 0;

		return $r;
}

function solo_una(&$Sesion){
$solo_una =$Sesion->get_var("solo_una");
if($solo_una == 1)
        return 0;
else {
        $Sesion->set_var("solo_una",1,"SUBSECCION");
         return 1;
        }
}

function valor_nulo($var) {
   return ($var != 0);
}

/**
  * Funcion que se encarga de obtener los links que difieren de un escritorio a otro.
  * NOTA: Esta funcion no tiene razon de ser en una aplicacion bien diseñada. En la cual la navegacion
  *	permanece constante a lo largo de la aplicacion y en cada subseccion se comprueba el escritorio activo
  *	para modificar las condiciones de una busqueda, ver o no unos resultados/plantillas, etc... 
  * TODO: Quitar esta funcion (9/4/2003)
  **
function get_desktop_link(&$Sesion,$Params) {
	$aLinks = $Sesion->get_var("aDesktopLinks");
	if (!is_array($aLinks) || !sizeof($aLinks)) {
		$aLinks[0][alta_pedido] = 'bo_pedidos_ventas';
		$aLinks[cliente][alta_pedido] = 'bo_pedidos_cliente';
		$Sesion->set_var("aDesktopLinks",$aLinks,"NOEXPIRE");
	}
	$what = array_shift($Params);
	$aUsr = identifica_usuarios($Sesion);
	if ( isset($aLinks[strtolower($aUsr[desktop_name])][$what]) && !empty($aLinks[strtolower($aUsr[desktop_name])][$what]) )
		$retval = $aLinks[strtolower($aUsr[desktop_name])][$what];
	else $retval = $aLinks[0][$what];
	return $retval;
}
/** **/

function hay_ayuda(&$Sesion) {
	static $ayuda_id;

	if (!isset($ayuda_id) OR (int)$ayuda_id) {
		$idsub = $Sesion->get_id_subsecc();
		$db = $Sesion->get_db('data');
		$cons = "SELECT COUNT(*) FROM Ayuda WHERE id_sub = $idsub";
		$tmprs = $db->query($cons);
	 	if (!$db->num_rows($tmprs)) return 0;
		$N = $db->fetch_row($tmprs);
		$Sesion->set_var("ayuda_id",$idsub,"INMED");
		$ayuda_id = (int)$N[0];
		return (int)$N[0];
	} else return 1;
}

function colocar_fecha($fecha,$aParm = NULL) {
	if (!is_object($fecha)) $retval = colocar_fecha_hora($fecha);
	else {
		$fecha = array_shift($aParm);
		if (!empty($fecha) AND strcasecmp($fecha,'now')) $retval= colocar_fecha_hora($fecha);
		else $retval= colocar_fecha_hora(date('Y-m-d H:m:i'));
	}

	if (!strcasecmp($retval,'NULL')) return NULL;
	else return $retval;
}

function descolocar_fecha($fecha){
	$fecha = trim($fecha);
	if (strchr($fecha," ")) {
		$aTmp = split(" ",$fecha);
		$fecha = $aTmp[0];
	}
		
	$temp = explode("-",$fecha);
	if (!is_array($temp) OR sizeof($temp) < 2 ) 
		$temp = explode("/",$fecha);

	if (!strcasecmp($temp[0],"dd") AND !strcasecmp($temp[1],"mm"))
		return date("Y-m-d");
	$val  = checkdate((int)$temp[1],(int)$temp[0],(int)$temp[2]);
	if($val)
	   return trim($temp[2]) . "-" . trim($temp[1]) . "-" . trim($temp[0]);
	else return date("Y-m-d");
}

function colocar_fecha_hora($fecha = NULL,$sql_type = 0) {
	$bTag = FALSE;
	if (empty($fecha)) return 'NULL';
	elseif (is_numeric($fecha) AND strlen($fecha)>10) {
		if (strlen($fecha)==14) {
			$a = substr($fecha,0,4);
			$m = substr($fecha,4,2);
			$d = substr($fecha,6,2);
			$h = substr($fecha,8,2);
			$mm = substr($fecha,10,2);
			$s = substr($fecha,12,2);
		} else { //presuponemos 12
			$a = substr($fecha,2);
			$m = substr($fecha,2,2);
			$d = substr($fecha,4,2);
			$h = substr($fecha,6,2);
			$mm = substr($fecha,8,2);
			$s = substr($fecha,10,2);
		}
		$fecha = "$a-$m-$d $h:$mm:$s";
	}
	if (!isset($bTag)) $bTag = TRUE;
	if (strstr($fecha,' ')) {
		$aTmp = split(' ',$fecha);
		$first = TRUE;
		for ( $i = 0; isset($aTmp[$i]); $i++) {
			if (!empty($aTmp[$i])) {
				if ($first) {
					$date = $aTmp[$i];
					$first = FALSE;
				} else {
					$hour = $aTmp[$i];
				}
			}
		}
	} elseif (is_numeric($fecha)) {
		$date = substr($fecha,0,4).'-'.substr($fecha,4,2).'-'.substr($fecha,6,2);
		$hour = substr($fecha,8,2).':'.substr($fecha,10,2).':'.substr($fecha,12,2);
	} else $date = $fecha;
	
	if (strstr($date,'/')) $sep = '/';
	elseif (strstr($date,'-')) $sep = '-';
	else $sep = NULL;
	
	if ($sep) {
		$aTmp = split($sep,$date);
		if (sizeof($aTmp) != 3) $retfecha = NULL;
		elseif (is_numeric($aTmp[0]) AND is_numeric($aTmp[1]) AND is_numeric($aTmp[2])) {
			if (strlen($aTmp[2]) == 4) { //Año al final.
				$retfecha = $aTmp[0].'/'.$aTmp[1].'/'.$aTmp[2].( (!empty($hour)) ? ' '.$hour : '');
			} elseif (strlen($aTmp[0]) == 4) {
				$retfecha = $aTmp[2].'/'.$aTmp[1].'/'.$aTmp[0].( (!empty($hour)) ? ' '.$hour : '');
			} else $retfecha = NULL;
		} else $retfecha = NULL;
	} else $retfecha = NULL;
	
	if (!$retfecha AND $this->debug) debug("Formato de fecha($fecha) _no_ valido: $retfecha");
	if (empty($retfecha)) $retval = "NULL";
	elseif($bTag) $retval = "'".$retfecha."'";
	elseif(!$bTag) $retval = $retfecha;
	return $retval;
}

function numero_resultados(&$oSesion) {
	static $bDone = FALSE;
	if (is_object($oSesion->b_activa)) {
		$nr = $oSesion->b_activa->get_numresults(!$bDone);
		$bDone = TRUE;
	}
	return $nr;
}

//Multi-Dimensional Implode.
function implode_r ($glue = '', $pieces){
   $out = '';
   if (!is_array($pieces) OR !sizeof($pieces)) return NULL;
   foreach ($pieces as $piece)
      if (is_array ($piece)) 
	 $out .= implode_r ($glue, $piece); // recurse
      else                   
	 $out .= $glue.$piece;
        
   return $out;
}

function ss_volver($Sesion) {
	$aList = $Sesion->get_var('__back_ss');
	if (!is_array($aList)) {
		$aList = array();
	}
	$ssact = $Sesion->get_subsecc_name();
	$last = array_pop($aList);
	if ($last != $ssact) {
		array_push($aList,$last);
		array_push($aList,$ssact);
		$Sesion->set_var('__back_ss',$aList);
	} else $last = $ssact;

	return $last;
}

  
?>
