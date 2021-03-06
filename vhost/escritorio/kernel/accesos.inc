<?php

/*****************************************************************
** Aplicacion dise�ada para Web On Line Studios S.L.            **
**    Todos los derechos reservados.                            **
**    Este programa se podra modificar con el consentimiento    **
**    de Web On Line Studios S.L. Su distribucion queda         **
**    limitada a Web On Line Studios S.L.												**
**    Las posibles modificaciones sobre esta aplicacion ajenas  **
**    a Web On Line Studios S.L. deberan ser consultadas y			**
**    enviadas a Web On Line Studios en C/Alcala 18 3� Izda,    **
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
**    C/Alcala 18 3� Izda, 28014 Madrid, Espa�a									**
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
                $this->debug = 0;
	}

	function init(&$oAV) {
//debug("INIIIIIIIIIIIIIIIIIT ");
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

	function set_desktops(&$oDb,$bForce = FALSE) {
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
						if (!empty($db_name)) $db = &$this->sesion->get_db($db_name);
						if (!is_object($db)) $db = &$this->sesion->get_db('data');

						if (empty($aDesk['auth_field']) ) {
							if ($aDesk['auth_scheme'] == 'id') 
								$aDesk['auth_field'] = 'id_usr';
							else $aDesk['auth_field'] = 'mask';
						}

						if (!empty($aDesk['extra_tables'])) {
							$oTmpDb = &$this->sesion->get_db('data');
							$aT = split('[, ]',$aDesk['extra_tables']);
							$aR = $oTmpDb->ruta($aDesk['table'],$aT,NULL,NULL,NULL,true);
							$full_from = $aR['left_join_from'];
						}

						$cons = "SELECT $aDesk[table].$aDesk[field] as 'value' ".
							( (!empty($aDesk['extra_fields'])) 
							  ?  ", $aDesk[extra_fields] "
							  : "" ).
							'FROM '.((!empty($full_from)) ? $full_from : $aDesk['table']).' '.
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
//							$this->get_desktop_ifaces(&$oDb,$aDesk['id_desktop'],$aIface,TRUE);
							$this->get_desktop_ifaces($oDb,$aDesk['id_desktop'],$aIface,TRUE);
//							$this->set_desktop_trigger(&$oDb,$aDesk['id_desktop']);
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
//					$this->get_desktop_ifaces(&$oDb,$aDesk['id_desktop'],$aIface,TRUE);
					$this->get_desktop_ifaces($oDb,$aDesk['id_desktop'],$aIface,TRUE);
					if (0 && $this->debug) print_r($this->_aDesktops[$aDesk['id_desktop']]);
					// debug("trigger before: $id_trigger   and now: ".$this->_aDesktops[$aDesk['id_desktop']]['trigger_subsec']);
					if ($id_trigger != $this->_aDesktops[$aDesk['id_desktop']]['trigger_subsec']) {
						if ($this->debug) debug("comprobando trigger ... ");
//						$this->set_desktop_trigger(&$oDb,$aDesk['id_desktop']);
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
	function get_desktop_ifaces(&$oDb,$id_desk,$aIface = NULL,$bSet) {
		if (!is_object($oDb)) return -1;
		if (!is_numeric($id_desk)) return -1;

		if ($this->debug) debug("get_desktop_ifaces() sobre $id_desk comprobar($bSet) con act: ".is_array($this->_aDesktops[$id_desk]['ifaces']));
		if (!is_array($this->_aDesktops[$id_desk]['ifaces']) ) {
			// OR !sizeof($this->_aDesktops[$id_desk]['ifaces'])
			$cons = 'SELECT nombre, '.
				'id_tipo_iface as "iface", '.
				'id_idioma as "lang", '.
				'id_tema as "tema", '.
				'id_trigger_subsec as "trigger_subsec" '.
				'FROM Ifaces WHERE id_desktop = '.$id_desk;
			$ifrs = $oDb->query($cons);
			if (!is_array($this->_aDesktops[$id_desk]['ifaces'])) $this->_aDesktops[$id_desk]['ifaces'] = array();

			// $this->_aDesktops[$id_desk]['ifaces'] = NULL;
			if (!$oDb->num_rows($ifrs)) return false;
			while ($aTmp = $oDb->fetch_assoc($ifrs)) array_push($this->_aDesktops[$id_desk]['ifaces'],$aTmp);
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

	function set_desktop_trigger(&$oDb,$id_desk) {
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
		$oDb = &$this->sesion->get_db($this->db_name);
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
			if (!$oDb->tb_update('Users',$aUsr)) {
				// A ver si no va a existir el id, dado que no hay rows afectadas ...
				$tmprs = $oDb->query('SELECT id_usr FROM Users WHERE id_usr = '.$aUsr['id_usr']);
				if (!$oDb->num_rows($tmprs)) $oDb->tb_insert('Users',$aUsr);
				$oDb->libera($tmprs);
			}
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

	function __toString() {
		$tmp = (array) $this;
		$tmpid = md5(implode(':',$tmp).'/'.implode(':',array_keys($tmp)));
                return '<'.get_class($this).':'.$this->_aNames['sesion'].'>'.$tmpid;
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
		$this->debug = 1;
		$this->aConf = NULL;
	}

	/** Inicializacion de las tablas de configuracion **/
	function cargar_conf() {
		/* NOTA:
		 */							 
		if (is_array($this->aConf) AND sizeof($this->aConf)) return TRUE;

		$oDb = &$this->db;
		//$sess = $this->sesion;
		//global $$sess;

		$this->aConfSess = $aConfSess = $this->sesion->get_conf_tbs();
		if (!empty($aConfSess['sec_subsecc'])) $aConfTbs['subsec'] = $aConfSess['sec_subsecc'];

		$bIsBO = (bool)wolSesion::fetchVar('BACKOFFICE','GLOBAL');
		/** notificacion por defecto (caso de tener) (por si no se encuentra la indicada) **/
		$consulta = 'SELECT valor,nombre FROM _main WHERE nombre="av_tb_usr" OR '.
						'nombre="av_tb_groups" OR nombre="av_tb_classes" OR '.
						'nombre="av_inc_dir" OR nombre="av_security_lev" OR '.
						'nombre="av_nomodule_subsecc" OR '.
						( ($bIsBO) ? 'nombre="av_bologin_subsec" ' : 'nombre="av_login_subsec" ' ).' OR '.
						'nombre="av_auth_class" ';
		$id = $oDb->query($consulta);
		while ($aTmp = $oDb->fetch_array($id)) {
			switch ($aTmp[1]) {
				case 'av_tb_usr':
					$this->aConf['tb_users'] = (!empty($aTmp[0])) ? $aTmp[0] : NULL;
					if (!$this->aConf['tb_users']) return 0;
					break;

				/** variable clave de activacion (con el tipo de notificacion) **/
				case 'tb_tb_groups':
					$this->aConf['tb_groups'] = (!empty($aTmp[0])) ? $aTmp[0] : NULL;
					if (!$this->aConf['tb_groups']) return 0;
					break;

				/** Tabla con las class de autentificacion **/
				case 'av_tb_classes':
					$this->aConf['tb_auth_classes'] = (!empty($aTmp[0])) ? $aTmp[0] : NULL;
					if (!$this->aConf['tb_auth_classes']) return 0;
					break;

				/** Directorio de inclusion **/
				case 'av_inc_dir':
					$this->aConf['include_path'] = $this->inc_dir = (!empty($aTmp[0])) ? $aTmp[0] : NULL;
					if (!$this->inc_dir) return 0;
					break;

				/** Nivel de Seguridad **/
				case 'av_security_lev':
					$this->aConf['security'] = (!empty($aTmp[0])) ? (int) $aTmp[0] : 0;
					break;

				/** Nivel de Seguridad **/
				case 'av_nomodule_subsecc':
					$this->aConf['nomodule_subsecc'] = (!empty($aTmp[0])) ? $aTmp[0] : NULL;
					break;

				case 'av_bologin_subsec':
					$this->aConf['sub_seccion'] = (!empty($aTmp[0])) ? $aTmp[0] : NULL;
					break;
				case 'av_login_subsec':
					$this->aConf['sub_seccion'] = (!empty($aTmp[0])) ? $aTmp[0] : NULL;
					break;

				case 'av_auth_class':
					$this->aConf['auth_class_id'] = (!empty($aTmp[0])) ? $aTmp[0] : NULL;
					break;
			}
		}
		$oDb->libera($id);

		$this->get_default_class();							

		return 1;
	}

	function get_default_class() {
		$oDb = &$this->db;
		$aConfSess = $this->aConfSess;

		if (empty($this->aConf['auth_class_id'])) {
			$consulta = "SELECT valor FROM _main WHERE nombre='av_auth_class'";
			$id = $oDb->query($consulta);
			$aTmp = $oDb->fetch_array($id);
			$oDb->libera($id);
			$tmp = (int) (!empty($aTmp[0])) ? $aTmp[0] : NULL;
		} else $tmp = $this->aConf['auth_class_id'];
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
		if (!empty($this->aConf['auth_script']) AND !class_exists($this->aConf['auth_class'])) {
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

		$oDb = &$this->db;

		if ($this->login) debug("Llamando al login desde load_auth()");
		if (!$this->login()) return 1;

		$doCheck = FALSE;
		$aTmp = $this->oUsr->get_desktop();
		$id_trigger = $aTmp['trigger_subsec'];
		$aTmp = NULL;
		if ($this->debug) debug("gotit : $id_trigger ");
//		$set_status = $this->oUsr->set_desktops(&$oDb);
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
		if ($doCheck AND is_numeric($id_check) AND $this->aSecConf['id_subsec'] != $id_check ) {
			/* obtener seccion y cargar su auth_conf (a traves de id_seccion) */
			/* nota: aki molaria k ademas por sub_secc se comprobase por seccion */
			$cons = "SELECT t1.id_seccion, t1.id_sub_secc, t2.av_mask, t1.av_group FROM ".
				//aConfSess no se resete  y no pilla bien Sec_Subsec
				//								$this->aConfSess[sec_subsecc]." t1, ".$this->aConfSess[secciones]." t2 ".
				" Sec_Subsecc t1 , Secciones t2 " .
				"			WHERE t1.id_sub_secc=".$id_check.
				" AND t1.id_seccion=t2.id_seccion";
			$aTmp = $oDb->fetch_array($oDb->query($cons));
			$this->aSecConf['id_seccion'] = $aTmp['id_seccion'];
			$this->aSecConf['id_subsec'] = $aTmp['id_sub_secc'];
			$this->aSecConf['subsec_mask'] = $aTmp['av_group'];
			$this->aSecConf['sec_mask'] = $aTmp['av_mask'];
			$this->aSecConf['module_mask'] = $aTmp['module_mask'];

			/* Obtener la clase y script k va a autentificar * (esta seccion)
				$this->aConf[auth_class_id];
				$this->aConf[auth_class];
				$this->aConf[auth_script];
			 */
		}

		return 1; // _todo ok 
	}

	function login() {
		if ($this->oUsr->authed AND !$this->oUsr->isGuest()) return 1;

		/* Llamar a la clase con el objeto wolUsr */
		$oDb = &$this->get_db();
		if (empty($this->aConf['auth_class'])) return 0;
		$auth_class = new $this->aConf['auth_class']($this->App_Name);
//		if (!$auth_class->init($this->oUsr,&$oDb)) return 0;
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
					debug("secure(".$this->aConf['security']."): login ".
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

	function __toString() {
		$tmp = (array) $this;
		$tmpid = md5(implode(':',$tmp).'/'.implode(':',array_keys($tmp)));
                return '<'.get_class($this).':'.$this->_aNames['sesion'].'>'.$tmpid;
	}

} /***** FIN DE LA CLASE *******/


?>
