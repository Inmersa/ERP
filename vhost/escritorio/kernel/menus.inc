<?php 

/*****************************************************************
** Aplicacion diseñada para Web On Line Studios S.L.            **
**    Todos los derechos reservados.                            **
**    Este programa se podra modificar con el consentimiento    **
**    de Web On Line Studios S.L. Su distribucion queda         **
**    limitada a Web On Line Studios S.L.								 				**
**    Las posibles modificaciones sobre esta aplicacion ajenas  **
**    a Web On Line Studios S.L. deberan ser consultadas y		  **
**    enviadas a Web On Line Studios en C/Alcala 18 3º Izda,    **
**    28014 Madrid. Cualquier otra operacion realizada sobre	  **
**    esta aplicacion queda limitada a Web On Line Studios S.L. **
**    infringiendo en delito cualquier otra entidad que asi lo	**
**    hiciese.																	 								**
**																					 										**
** Para mas informacion referente a la licencia de esta				  **
**    aplicacion referirse al fichero LICENCIA. Caso de que Ud. **
**    no tenga una copia de este fichero, contacte con Web On	  **
**    Line Studios S.L. para recibir una copia del mismo			  **
**																					 										**
** Informacion de Contacto													    				**
**    Josafat Moragrega Fernandez										 						**
**    Engineering																                **
**    Director Tecnico														              **
**    tite@wolstudios.com													              **
**    C/Alcala 18 3º Izda, 28014 Madrid, España						      **
**	                    																			  **
**										  (c) Web On Line Studios S.L.	          **
**                                                              **
******************************************************************
*****************************************************************/

/****************************************************************/
/************** Libreria de GESTION DE MENUS ********************/
/****************************************************************/

/*** DESCRIPCION : 
  Esta libreria esta preparada para interactuar con la API de dessarrollo
  de Wol Studios recibiendo su Objeto para Soporte de Sesiones.
  **/

class wol_menu {
		  /********** VARIABLES DE CONFIGURACION GENERAL *******************/
   var $App_Name;										  	/* Nombre de la app a la k pertenece */
	 var $tb = 
				array("menus_subsecc" 	=> "",	/* tabla menus sub secciones */
						  "tipos_menu" 			=> "",  /* tabla tipos de menu */
							"menus"	 					=> "",	/* tabla de menus */
							"m_subm" 					=> "",	/* relacion menus-submenus */
							"submenus"				=> "",	/* tabla de submenus */
							"sm_sm"						=> "",	/* relacion submenus - submenus */
							"sm_items"				=> "",	/* relacion submenus - menu items */
							"items"	 					=> ""		/* tabla de elementos de menu  */
						 );
	 var $id_secc;											 	/* Id de la sub_secc actual */

	 		/********** Variables *************/
	 var $plt_menu_actual;								/* Nombre del menu actual (su plt) */
	 var $i	= 0;													/* Indice de posicionamiento en los
																					 arrays de menu (EL index)*/
	 var $aIndices 		= array();  				/* Array con la referencia entre
																					 Nombre de plantilla y su Indice */
	 var $aPlantillas	= array();					/* Plantillas de menus (indexado)*/
	 var $aPltWheres	= array(array());		/* wheres ya vistos */
	 var $aImgBase 		= array(array());   /* Imagen base del menu (indexado)*/
	 var $aJsFuncs		= array(array());		/* Funciones JavaScript para generar
																					 los menus en la plantilla (indx)*/
	 var $aTiposMenu	= array();					/* Tipo de menu de cada menu cargado
																						(indexado) */
	 var $aItems			= array(array());		/* Todos los elementos de este menu:
																					 El primer indice es el index:
																					 0 - nombre (texto)
																					 1 - accion
																					 2 - alt
																					 3 - imagen
																					 4 - colores
																					 5 - tipo_js (caso submenu) */

   function wol_menu($nombre) {
      /* Nota: El nombre de aplicacion en los distintos modulos podria ser 
			sustituido por un id. Imagino k asi es como se hace un ASP */
      if (empty($nombre) OR !isset($nombre) OR !is_string($nombre))
				  $nombre = "Aplicacion Sin Nombre";
			$nombre = trim($nombre);
      $this->App_Name = $nombre;
//aviso("constructo!!");
   }

	 /** Inicializacion de las tablas de configuracion **/
   function cargar_conf(&$oDb) {

	 		$this->menu_actual = "";

      $consulta = "SELECT valor FROM _main WHERE nombre='tb_menus_subsec'";
      $id = $oDb->query($consulta);
      $aTmp = $oDb->fetch_array($id);
      $oDb->libera($id);
      $this->tb[menus_subsecc] = $aTmp[0];

      $consulta = "SELECT valor FROM _main WHERE nombre='tb_tipos_menu'";
      $id = $oDb->query($consulta);
      $aTmp = $oDb->fetch_array($id);
      $oDb->libera($id);
      $this->tb[tipos_menu] = $aTmp[0];

      $consulta = "SELECT valor FROM _main WHERE nombre='tb_menus'";
      $id = $oDb->query($consulta);
      $aTmp = $oDb->fetch_array($id);
      $oDb->libera($id);
      $this->tb[menus] = $aTmp[0];

      $consulta = "SELECT valor FROM _main WHERE nombre='tb_menu_items'";
      $id = $oDb->query($consulta);
      $aTmp = $oDb->fetch_array($id);
      $oDb->libera($id);
      $this->tb[items] = $aTmp[0];

      $consulta = "SELECT valor FROM _main WHERE nombre='tb_menus_submen'";
      $id = $oDb->query($consulta);
      $aTmp = $oDb->fetch_array($id);
      $oDb->libera($id);
      $this->tb[m_subm] = $aTmp[0];

      $consulta = "SELECT valor FROM _main WHERE nombre='tb_submenus'";
      $id = $oDb->query($consulta);
      $aTmp = $oDb->fetch_array($id);
      $oDb->libera($id);
      $this->tb[submenus] = $aTmp[0];

      $consulta = "SELECT valor FROM _main WHERE nombre='tb_submenus_items'";
      $id = $oDb->query($consulta);
      $aTmp = $oDb->fetch_array($id);
      $oDb->libera($id);
      $this->tb[sm_items] = $aTmp[0];
			
      $consulta = "SELECT valor FROM _main WHERE nombre='tb_submenus_submenus'";
      $id = $oDb->query($consulta);
      $aTmp = $oDb->fetch_array($id);
      $oDb->libera($id);
      $this->tb[sm_sm] = $aTmp[0];

			return 1;
   }

	 /** Inicializamos nuestros Menus **/
   function init(&$oSesion) {
      /* Nota :
			   El menu_actual no se establece hasta que somos llamados por la sesion
			a causa de una carga de plantilla. */

      $oDb = $oSesion->get_db_conn();
/** Esto se activara cuando la libreria este en produccion **
			if (!empty($this->id_secc) AND 
					!strcmp($this->id_secc,$oSesion->id_secc)) return 0;

			if (empty($this->tb[menus_subsecc]) OR !isset($this->tb))
					if (!$this->cargar_conf($oDb))
							aviso("Error : No se han podido cargar los menus");
*/
			if (!$this->cargar_conf($oDb))
					aviso("Error : No se han podido cargar los menus");

			$this->id_secc = $oSesion->id_secc;
			if (!$this->set_conf($oSesion)) return 0;

		  return 1; /* ahora mismo 0 pk no keremos activar los menus todavia */
   }

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
	 }

	 /** Metodo para indicar si hay o no rows para este menu 
		 (si es nuestra plantilla, siempre devolvemos si. ya se encargara
		 get_plt_data de parar el bucle) **/
	 function hay_rows() {
			if ($this->activaos) return 1;
			else return -1;
	 }
	 
	 /** Metodo que nos devuelve el array con los datos a presentar en el 
		 bucle indicado por $nom_bcl */
	 function get_plt_data($nom_bcl = "") {
			if (!isset($nom_bcl) OR empty($nom_bcl)) { 
aviso("no hago nah con esto ($nom_bcl)");
					return array();
			}
			if (!$this->activaos) return array();

			if (!strcmp($nom_bcl,"imagen")) {
//salida("bucle imagen, jate tu<BR>\n");
					if (!esta_en($this->aPltWheres[$this->i],$nom_bcl)) {		
//salida("uis... y NO esta en pltwheres<BR>\n");
							$aRetVal[img_name] = $this->aImgBase[$this->i][0];
							$aRetVal[img_src] = $this->aImgBase[$this->i][1];
							$aRetVal[img_width] = $this->aImgBase[$this->i][2];
							$aRetVal[img_height] = $this->aImgBase[$this->i][3];
					} else $aRetVal = array();
			} elseif (!strcmp($nom_bcl,"js")) {
//salida("bucle js, jate tu<BR>\n");
					if (!esta_en($this->aPltWheres[$this->i],$nom_bcl)) {
//salida("uis... y NO esta en pltwheres<BR>\n");
							$aRetVal[javascript_string] = $this->get_menu_js($this->i);
					} else $aRetVal = array();
			} else $aRetVal = array();

			$last = sizeof($this->aPltWheres[$this->i]);
			$this->aPltWheres[$this->i][$last] = $nom_bcl;
//salida("devorvemos ".sizeof($aRetVal)."<BR>\n");
			return $aRetVal;
	 }
	 

	 /** Metemos en la sesion las plantillas que vamos a necesitar.
		A pesar de poder tener la seccion las plantillas que necesitamos, si 
	 existen, les asignamos nuestro valor. sino, añadimos la plantilla */	
	 function set_conf(&$Sesion) {
			$oDb = $Sesion->get_db_conn();
			$consulta  = "SELECT * FROM ".$this->tb[menus_subsecc];
			$consulta .= " WHERE id_sub=".$this->id_secc;
			$id = $oDb->query($consulta);
			if (!$oDb->num_rows($id)) return 0;
			$this->aItems = array(); /* Inicializamos los elementos */

			/* Esto carga la conf de todos los menus */
			for ($i=1;$row=$oDb->fetch_array($id);$i++) {
					/* Añadimos un indice */
					$this->aIndices[$row[nom_plt_sub]] = $i;
					
					/* Metemos la plantilla en la sesion */
					/* CAPULLO... te falta meterlas en tu objeto */
					$consulta  = "SELECT * FROM ".$Sesion->tb_plantillas;
				  $consulta .= " WHERE id_plantilla=";
					$consulta .= $row["id_plantilla"];
					$id2=$oDb->query($consulta);
					if ($oDb->num_rows($id2)) {
							$aTmp=$oDb->fetch_array($id2);
							if (!$Sesion->change_plt($row[nom_plt_sub],$aTmp[nombre]))
									if ($Sesion->add_plt($row[nom_plt_sub],$aTmp[nombre])) {
											/* Error */
											aviso("No se ha podido insertar/cambiar plantilla"); 
											return 0;
									}
							$this->aPlantillas[$i][0] = $row[nom_plt_sub];
							$this->aPlantillas[$i][1] = $aTmp[nombre];
					}
					$oDb->libera($id2);

					/* Cargamos la imagen base de este menu */
					if (empty($row[img_name]) OR empty($row[img_src]) OR
							empty($row[img_width]) OR empty($row[img_heigth])) return 0;
					$this->aImgBase[$i][0] = $row[img_name];
					$this->aImgBase[$i][1] = $row[img_src];
					$this->aImgBase[$i][2] = $row[img_width];
					$this->aImgBase[$i][3] = $row[img_heigth];
									
					/* Miramos a ver cuales son las funciones JavaScript k usaremos */
					if (empty($row[id_tipo_menu])) return 0;
					$consulta  = "SELECT * FROM ".$this->tb[tipos_menu];
					$consulta	.= " WHERE id_tipo_menu=".$row[id_tipo_menu];
					$id2 = $oDb->query($consulta);
					if ($oDb->num_rows($id2)) {
						  $aTmp = $oDb->fetch_array($id2);
							$this->aTiposMenu[$i][0] = $aTmp[id_tipo_menu];
						 	$this->aTiposMenu[$i][1] = $aTmp[nombre];
							//$tipo_menu = (int) $aTmp[id_tipo_menu];
							$this->aJsFuncs[$i][addmenu] = $aTmp[func_addmenu];
							$this->aJsFuncs[$i][addsubmenu] = $aTmp[func_addsubmenu];
							$this->aJsFuncs[$i][additem] = $aTmp[func_additem];
							if (empty($this->aImgBase[$i]) OR !isset($this->aImgBase[$i])) {
									$this->aImgBase[$i][0] = $aTmp[img_name];
									$this->aImgBase[$i][1] = $aTmp[img_src];
									$this->aImgBase[$i][2] = $aTmp[img_width];
									$this->aImgBase[$i][3] = $aTmp[img_heigth];
							}
					}
					$oDb->libera($id2);

					/* Configuracion de los Elementos de Menu */
					$consulta = $this->get_query($row[id_menu],"menu");
					$row = array();			/* row los resultados de la nueva query */
					$id2 = $oDb->query($consulta);
					if (!$oDb->num_rows($id)) { 
							aviso("Este menu no tiene asignado un grupo de elementos"); 
							return 0;
					}

					for ($lev = 0;$row = $oDb->fetch_array($id2);$lev++) {
							$j = sizeof($this->aItems[$i]);
							/* si el submenu no tiene ni nombre ni accion (sikiera los
								 k son por defecto)... a la p calle */
							if ( 	(empty($row[nombre]) AND empty($row[def_nombre])) OR
										(empty($row[accion]) AND empty($row[def_acccion]))  ) 
										continue;

							if ($this->asignar_item($this->aItems[$i][$j],$row)) {
									$this->aItems[$i][$j][6] = "$lev";
							}
							$this->add_submenu($oDb,$this->aItems[$i],
																	$row[id_submenu],"$lev");

					} // fin del for fetch array de submenus
					$oDb->libera();
			} // fin del for fetch array de menus-subsecc

/** vamos a echar la pota... ;P **
salida("INDICES :<BR>\n");
for (;list($clave,$valor) = each($this->aIndices);)
		salida(" $clave    --->   $valor <BR>\n");
reset($this->aIndices);
salida("Tipos de Menu :<BR>\n");
for (;list($clave,$valor) = each($this->aTiposMenu[1]);)
		salida(" $clave    --->   $valor <BR>\n");
reset($this->aTiposMenu[1]);
salida("PLANTILLAS :<BR>\n");
for (;list($clave,$valor) = each($this->aPlantillas[1]);)
		salida(" $clave    --->   $valor <BR>\n");
reset($this->aPlantillas[1]);
salida("IMG - BASE :<BR>\n");
for (;list($clave,$valor) = each($this->aImgBase[1]);)
		salida(" $clave    --->   $valor <BR>\n");
reset($this->aImgBase[1]);
salida("JavaScript Functions :<BR>\n");
for (;list($clave,$valor) = each($this->aJsFuncs[1]);)
		salida(" $clave    --->   $valor <BR>\n");
reset($this->aJsFuncs[1]);
salida("<BR>\n");
$fin = sizeof($this->aItems[1]);
for ($a=0;$a<$fin;$a++) {
   salida("name 	: ".$this->aItems[1][$a][0]."<BR>\n");
   salida("action : ".$this->aItems[1][$a][1]."<BR>\n");
   salida("alt		: ".$this->aItems[1][$a][2]."<BR>\n");
   salida("src		: ".$this->aItems[1][$a][3][src]."<BR>\n");
   salida("width	: ".$this->aItems[1][$a][3][width]."<BR>\n");
   salida("heigth : ".$this->aItems[1][$a][3][heigth]."<BR>\n");
   salida("fg			: ".$this->aItems[1][$a][4][fg]."<BR>\n");
   salida("bg			: ".$this->aItems[1][$a][4][bg]."<BR>\n");
   salida("tipo_js: ".$this->aItems[1][$a][5]."<BR>\n");
   salida("depth	: ".$this->aItems[1][$a][6]."<BR>\n");
	 salida("<BR>\n");
}
  fin de la pota. xD ***********/
		  return 1;
	 } // fin del metodo init()
   
	 /** Este metodo nos empieza por submenus-items y nos rellena el
		 array k reciba con los datos del submenu (items y otros submenus) */
	 function add_submenu(&$oDb,&$aDatos,$id_subm,$nivel) {
			$row = array();			/* row los resultados de la nueva query */
//aviso("add_submenu con id $id_subm");
			$consulta = $this->get_query($id_subm,"item");
//salida("$consulta<BR>\n");
			if (!$consulta) return 0;
			$id = $oDb->query($consulta);
			$items = $submenus = 0;
			if ($oDb->num_rows($id)) { 
					for ($items=0, 	$lev = 0;$row = $oDb->fetch_array($id);
													$lev++,$items++) {
							$j = sizeof($aDatos);
//aviso("k vamos... con ".sizeof($row));
							if ($this->asignar_item($aDatos[$j],$row)) {
							/* Metemos el nivel k le toca */
									$aDatos[$j][6] = "$nivel.$lev";
							}
					} // fin del for fetch array de submenus
			}  
			$oDb->libera($id);
			$row = array();
			$consulta = $this->get_query($id_subm,"submenu");
//salida($consulta."<BR>\n");
			if (!$consulta) return 0;
			$id = $oDb->query($consulta);
			if ($oDb->num_rows($id)) {
					for ($submenus=0,	$lev = 0;$row = $oDb->fetch_array($id);
													$lev++,$submenus++) {
							$j = sizeof($aDatos);
//aviso("k vamos... con ".sizeof($row));
							if ($this->asignar_item($aDatos[$j],$row)) {
									$aDatos[$j][6] = "$nivel.".$items+$lev;
									$this->add_submenu(	$oDb, $aDatos,
																	$row[id_hijo], "$nivel.".$items+$lev );
							}
					} // fin del for fetch array de submenus
			}
			$oDb->libera($id);
	 }

	 function get_query($id,$tipo) {
 			if (empty($tipo) OR !isset($tipo)) $tipo = "item";
			if (strcmp($tipo,"item") AND 
					strcmp($tipo,"submenu") AND strcmp($tipo,"menu") ) return NULL;

			return "SELECT t2.id_submenu as 'id_submenu', ".
						 ( (!strcmp($tipo,"menu")) ? "" : "t2.id_hijo as 'id_hijo', "). 
			       "t2.nombre as 'nombre', ".
			  		 "t2.accion as 'accion', ".
			       "t2.alt as 'alt', ".
			       "t2.img_src as 'img_src', ".
			       "t2.img_width as 'img_width', ".
			       "t2.img_heigth as 'heigth', ".
			       "t2.fg_color as 'fg_color', ".
			       "t2.bg_color as 'bg_color'".
					   ((strcmp($tipo,"item")) 	? ", t2.tipo_js as 'tipo_js', " :
						 														", ").
			       "t3.nombre as 'def_nombre', ".
			       "t3.accion as 'def_accion', ".
			       "t3.alt as 'def_alt', ".
			       "t3.img_src as 'def_img_src', ".
			       "t3.img_width as 'def_img_width', ".
			       "t3.img_heigth as 'def_heigth', ".
			       "t3.fg_color as 'def_fg_color', ".
			       "t3.bg_color as 'def_bg_color'".
					   ( (strcmp($tipo,"item")) 	? ", t3.tipo_js as 'def_tipo_js' " :
																			 	" ").
						 "FROM ".
						 ( (!strcmp($tipo,"menu")) 	? 	$this->tb[menus]." as t1, ".
																				 		$this->tb[m_subm]." as t2, ".
																				 		$this->tb[submenus]." as t3 " :
						 		((!strcmp($tipo,"submenu"))	?   $this->tb[sm_sm]." as t2, ".
																								$this->tb[submenus]." as t3 " :
																								$this->tb[sm_items]." as t2, ".
																								$this->tb[items]." as t3 ") ). 
						"WHERE ".
						( (!strcmp($tipo,"menu")) 	?		"t1.id_menu=".$id.
																						" AND t1.id_menu = t2.id_menu ".
																						"AND t2.id_submenu=t3.id_submenu " :
						 ((!strcmp($tipo,"submenu"))? 	"t2.id_submenu = ".$id.
																						" AND t2.id_hijo=t3.id_submenu " :
																						"t2.id_submenu=".$id." AND ".
																						"t2.id_hijo = t3.id_menuitem ") );
	 }


	 function asignar_item(&$aDatos,$row) {
					/* si el submenu no tiene ni nombre ni accion (sikiera los
						 k son por defecto)... a la p calle */
					if ( 	(empty($row[nombre]) AND empty($row[def_nombre])) OR
								(empty($row[accion]) AND empty($row[def_accion]))  ) 
								return 0;

					/* Metemos el nombre del submenu y su accion (si tiene) */
					$aDatos[0] = 
									(empty($row[nombre])) ? $row[def_nombre] : $row[nombre];
					$aDatos[1] = 
									(empty($row[accion])) ? $row[def_accion] : $row[accion];

					/* Metemos los datos de la imagen (caso de tener) */
					if (!empty($row[img_src]) OR !empty($row[def_img_src])) {
							$aDatos[2] = 
								(empty($row[alt])) ? $row[def_alt] : $row[alt];
							$aDatos[3][src] = 
								(empty($row[img_src])) 		? $row[def_img_src] : 
																						$row[img_src];
							$aDatos[3][width] = 
								(empty($row[img_width])) 	?	$row[def_img_width] : 
																						$row[img_width];
							$aDatos[3][heigth] = 
								(empty($row[img_heigth])) ? $row[def_img_heigth] :
																						$row[img_heigth];
					} else $aDatos[3] = array();

					/** Colores de fondo y de frente */
					if (!empty($row[fg_color]) OR !empty($row[def_fg_color])) 
							$aDatos[4][fg] = 
								(empty($row[fg_color])) 	? $row[def_fg_color] :
																						$row[fg_color];
					else $aDatos[4][fg] = "#000000";
					if (!empty($row[bg_color]) OR !empty($row[def_bg_color]))
							$aDatos[4][bg] = 
								( (empty($row[bg_color]))	? $row[def_bg_color] :
																						$row[bg_color]);
					else $aDatos[4][bg] = "#ffffff";

					/** Tipo de submenu **/
					$aDatos[5] = 
							(empty($row[tipo_js]))	? $row[def_tipo_js] :
							 													$row[tipo_js];
					return 1;
	 }

   function get_menu_js($idx) {
			if (!isset($idx) OR !is_int($idx) OR !$idx) $idx = $this->i;
			
			$menu_name 	= $this->aItems[$idx][0][5];
			$asub				=	$this->aJsFuncs[$idx][addsubmenu];
			$aitm				= $this->aJsFuncs[$idx][additem];

			$retval = "$menu_name = new  ".$this->aTiposMenu[$idx][1].
																	"('".$menu_name."');\n";
			for ($i=0,$lng=sizeof($this->aItems[$idx]);$i<$lng;$i++) {
				$tipo_js = $this->aItems[$idx][$i][5];
				if (!empty($tipo_js)) {
						$f = $asub;
						$papa = $this->aItems[$idx][$i][0];
				} else {
						$f = $aitm;
				}
				$retval.= "$menu_name.$f('".$this->aItems[$idx][$i][0]."','".
									$this->aItems[$idx][$i][1]."'".
									(empty($tipo_js) ? ",'$papa');\n" : ");\n");
			}
								
			return $retval;
/*
menu1 = new wolMenu("menu1")
menu1.additem("wolstudios","http://www.wolstudios.com")
menu1.submenu("Enlaces")
menu1.additem("Enlaces 1","http://www.grupotiasa.com","Enlaces")
menu1.additem("Enlaces 2","http://diana.wolstudios.com/~nacho","Enlaces")
menu1.submenu("Piraguas")
menu1.additem("Piraguas 1","http://www.grupotiasa.com","Piraguas")
menu1.additem("Piraguas 2","http://diana.wolstudios.com/~nacho","Piraguas")
*/
	 }

   function cerrar() {
			$this->i = 0;
			$this->aPltWheres = array();
   }
}

?>
