<?php
/*****************************************************************
** Aplicacion dise�ada para Web On Line Studios S.L.            **
**    Todos los derechos reservados.                            **
**    Este programa se podra modificar con el consentimiento    **
**    de Web On Line Studios S.L. Su distribucion queda         **
**    limitada a Web On Line Studios S.L.                                                                                                 **
**    Las posibles modificaciones sobre esta aplicacion ajenas  **
**    a Web On Line Studios S.L. deberan ser consultadas y                  **
**    enviadas a Web On Line Studios en C/Alcala 18 3� Izda,    **
**    28014 Madrid. Cualquier otra operacion realizada sobre          **
**    esta aplicacion queda limitada a Web On Line Studios S.L. **
**    infringiendo en delito cualquier otra entidad que asi lo        **
**    hiciese.                                                                                                                                                                                                         **
**                                                                                                                                                                                                                                                         **
** Para mas informacion referente a la licencia de esta                                  **
**    aplicacion referirse al fichero LICENCIA. Caso de que Ud. **
**    no tenga una copia de este fichero, contacte con Web On          **
**    Line Studios S.L. para recibir una copia del mismo                          **
**                                                                                                                                                                                                                                                         **
** Informacion de Contacto                                                                                                                                            **
**    Josafat Moragrega Fernandez                                                                                                                                 **
**    Engineering                                                                                                                                                **
**    Director Tecnico                                                                                                                              **
**    tite@wolstudios.com                                                                                                                      **
**    C/Alcala 18 3� Izda, 28014 Madrid, Espa�a                                                      **
**                                                                                                                                                                                      **
**                                                                                  (c) Web On Line Studios S.L.                  **
**                                                              **
******************************************************************
*****************************************************************/

/****************************************************************/
/************** Libreria de GESTION DE MENUS ********************/
/****************************************************************/

/*** DESCRIPCION :
  Esta libreria esta preparada para interactuar con la API de dessarrollo
  de Wol Studios recibiendo su Objeto para Soporte de Sesiones.

                 DOCUMENTACION :        <nombre_de_modulo>.doc
  **/

class wolAVauth_form {
                  /********** VARIABLES DE CONFIGURACION GENERAL *******************/
   var $App_Name;                                                                                          /* Nombre de la app a la k pertenece */
         var $tb =
                                array("menus_subsecc"         => "",        /* tabla menus sub secciones */
                                                  "tipos_menu"                         => "",  /* tabla tipos de menu */
                                                        "menus"                                                 => "",        /* tabla de menus */
                                                        "m_subm"                                         => "",        /* relacion menus-submenus */
                                                        "submenus"                                => "",        /* tabla de submenus */
                                                        "sm_sm"                                                => "",        /* relacion submenus - submenus */
                                                        "sm_items"                                => "",        /* relacion submenus - menu items */
                                                        "items"                                                 => ""                /* tabla de elementos de menu  */
                                                 );
         var $id_secc;                                                                                                 /* Id de la sub_secc actual */

                         /********** Variables *************/

         var $plt_menu_actual;                                                                /* Nombre del menu actual (su plt) */
         var $i        = 0;                                                                                                        /* Indice de posicionamiento en los
                                                                                                                                                                         arrays de menu (EL index)*/
         var $aIndices                 = array();                                  /* Array con la referencia entre
                                                                                                                                                                         Nombre de plantilla y su Indice */
         var $aPlantillas        = array();                                        /* Plantillas de menus (indexado)*/
         var $aPltWheres        = array(array());                /* wheres ya vistos */
         var $aImgBase                 = array(array());   /* Imagen base del menu (indexado)*/
         var $aJsFuncs                = array(array());                /* Funciones JavaScript para generar
                                                                                                                                                                         los menus en la plantilla (indx)*/
         var $aTiposMenu        = array();                                        /* Tipo de menu de cada menu cargado
                                                                                                                                                                                (indexado) */
         var $aItems                        = array(array());                /* Todos los elementos de este menu:
                                                                                                                                                                         El primer indice es el index:
                                                                                                                                                                         0 - nombre (texto)
                                                                                                                                                                         1 - accion
                                                                                                                                                                         2 - alt
                                                                                                                                                                         3 - imagen
                                                                                                                                                                         4 - colores
                                                                                                                                                                         5 - tipo_js (caso submenu) */
         var $debug = 1;

                         /***** Metodos de API wol ******/
   function wolAVauth_form($nombre) {
      /* Nota:
                                 */
      if (empty($nombre) OR !isset($nombre) OR !is_string($nombre))
                                  $nombre = "Aplicacion Sin Nombre";
                        $nombre = trim($nombre);
      $this->App_Name = $nombre;
   }

         /** Inicializacion de las tablas de configuracion **/
   function cargar_conf(&$oDb) {

		return 1; /* de momento no hay conf k cargar */

      $consulta = "SELECT valor FROM _main WHERE nombre='tb_menus_subsec'";
      $id = $oDb->query($consulta);
      $aTmp = $oDb->fetch_array($id);
      $oDb->libera($id);
      $this->tb[menus_subsecc] = $aTmp[0];

                        return 1;
   }

         /** Inicializamos  **/
   function init(&$oUsr,&$oDb) {
      /* Nota :
							*/
				if (empty($user)) $user = $GLOBALS['user'];
				if (empty($user)) $user = $_POST['user'];
				if (empty($user)) $user = $_GET['user'];
				if (empty($pass)) $pass = $GLOBALS['pass'];
				if (empty($pass)) $pass = $_POST['pass'];
				if (empty($pass)) $pass = $_GET['pass'];
				if (empty($id_usr)) $id_usr = $GLOBALS['id_usr'];
				if (empty($id_usr)) $id_usr = $_POST['id_usr'];
				if (empty($id_usr)) $id_usr = $_GET['id_usr'];
//				global $pass;
//				global $id_usr;
                                if ($this->debug) debug("wolAVauth_form->init() A ver en globales que hay: ".$GLOBALS['user']);

                                if ($this->debug) debug("wolAVauth_form->init() init de form_auth ($user-$pass)");
				$oUsr->realm = $this->App_Name; /* hay k poner aki una comprobacion */
				$oUsr->authed = 0;
				$oUsr->group_mask = 0;
                                if ($this->deubg) debug("antiguo: ".$oUsr->login." - ".$oUsr->passwd);

				if (empty($user) && empty($pass)){
					  $user = $oUsr->login;
					  $pass = $oUsr->passwd;
					  $id_usr= $oUsr->id_usr;
				} else {

					  $consulta="select id_usr,av_group,nombre,id_tipo_iface,id_idioma,id_tema from Users where activo=1 AND ".
										"login='$user' and passwd=".
										(($oUsr->crypt) ? "PASSWORD('$pass')" : "'$pass'");
                                          if ($this->debug) debug($consulta);
					  $rs=$oDb->query($consulta);
					  $row=$oDb->fetch_row($rs);
					  $id_usr=$row[0];
					  if($id_usr){
							$oUsr->id_usr=$id_usr;
							$oUsr->login = $user;
							$oUsr->usr_name = $row[2];
							$oUsr->passwd = $pass;
							$mascara=(int) $row[1];
//debug("mascara encontrada = ($mascara)");
							$oUsr->group_mask=$mascara;
							$oUsr->id_usr= (int) $id_usr;
							$oUsr->_aIface['iface'] = $row[3];
							$oUsr->_aIface['lang'] = $row[4];
							$oUsr->_aIface['tema'] = $row[5];
//debug("realm = ".$oUsr->realm);
//debug("id_usr = ".$oUsr->id_usr);
					  }
				}

				$oUsr->authed=1;
//debug("oUsr->authed = (".$oUsr->authed.")");

				//global $id;
				//$id = $id_usr;

//				unset($user);
//				unset($pass);
				return 1; /* 0 - pedir login de nuevo																		 1 - pasar a validacion de grupo */
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
         existen, les asignamos nuestro valor. sino, a�adimos la plantilla */
         function set_conf(&$Sesion) {
                        $oDb = $Sesion->get_db_conn();
                        $consulta  = "SELECT * FROM ".$this->tb[menus_subsecc];
                        $consulta .= " WHERE id_sub=".$this->id_secc;
                        $id = $oDb->query($consulta);
                        if (!$oDb->num_rows($id)) return 0;
                        $this->aItems = array(); /* Inicializamos los elementos */

                        /* Esto carga la conf de todos los menus */
                        for ($i=1;$row=$oDb->fetch_array($id);$i++) {
                                        /* A�adimos un indice */
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
                                        $consulta        .= " WHERE id_tipo_menu=".$row[id_tipo_menu];
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
                                        $row = array();                        /* row los resultados de la nueva query */
                                        $id2 = $oDb->query($consulta);
                                        if (!$oDb->num_rows($id)) {
                                                        aviso("Este menu no tiene asignado un grupo de elementos");
                                                        return 0;
                                        }

                                        for ($lev = 0;$row = $oDb->fetch_array($id2);$lev++) {
                                                        $j = sizeof($this->aItems[$i]);
                                                        /* si el submenu no tiene ni nombre ni accion (sikiera los
                                                                 k son por defecto)... a la p calle */
                                                        if (         (empty($row[nombre]) AND empty($row[def_nombre])) OR
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
   salida("name         : ".$this->aItems[1][$a][0]."<BR>\n");
   salida("action : ".$this->aItems[1][$a][1]."<BR>\n");
   salida("alt                : ".$this->aItems[1][$a][2]."<BR>\n");
   salida("src                : ".$this->aItems[1][$a][3][src]."<BR>\n");
   salida("width        : ".$this->aItems[1][$a][3][width]."<BR>\n");
   salida("heigth : ".$this->aItems[1][$a][3][heigth]."<BR>\n");
   salida("fg                        : ".$this->aItems[1][$a][4][fg]."<BR>\n");
   salida("bg                        : ".$this->aItems[1][$a][4][bg]."<BR>\n");
   salida("tipo_js: ".$this->aItems[1][$a][5]."<BR>\n");
   salida("depth        : ".$this->aItems[1][$a][6]."<BR>\n");
         salida("<BR>\n");
}
  fin de la pota. xD ***********/
                  return 1;
         } // fin del metodo init()


   function cerrar() {
                        $this->i = 0;
                        $this->aPltWheres = array();
   }


        /******* Metodos especificos del Modulo **********/

}
//salida("wol_notifica_email ha cargao.....<br>\n");

?>
