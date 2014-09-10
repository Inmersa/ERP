<?php 

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

	function numMsgs() {
		return sizeof($this->_aMsg);
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
	   echo "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Error N� ".mysql_errno()." : ".mysql_error()." En $fichero Linea $linea <BR>\n";
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

function debug($texto,$param=NULL) {
#Recibe como parametro el texto que hay que visualizar.
global $DEBUG;
global $DEBUG_FD;
$strMsg = ("debug: ".ereg_replace("\n","<br>",$texto)."<br>\n");
if (false and empty($DEBUG_FD)) {
	$DEBUG_FD = fopen('/tmp/ierp_app_debug.log','w');
	fwrite($DEBUG_FD,$strMsg);
}

if($DEBUG =="ON")
	salida($strMsg);
	// echo "alert('".ereg_replace(" ","\"+\" ",$texto)."');\n";
        if (!empty($param)) {
            echo "<pre>";
            print_r($param);
            echo "</pre>";
        }
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
    //return ereg_replace("�","[&ntilde;]",$cadena);
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

?>
