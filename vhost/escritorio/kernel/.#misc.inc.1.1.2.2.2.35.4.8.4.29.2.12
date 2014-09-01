<?php 

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

function lcvoid($dato) {
	return $dato;
}

function lcundec($dato,$Sesion = NULL,$aParams = NULL,$src = NULL,$aPath = NULL) {
	static $lcfmt;
	if (is_array($dato)) {
		debug("Error: lcundec _no_ deberia recibir un array");
		return;
	} 

	if (!is_numeric($dato) AND empty($dato)) return $dato;
	if (!is_a($Sesion,'wolSession') AND !empty($GLOBALS['APP_NAME'])) $Sesion=&$GLOBALS[$GLOBALS['APP_NAME']];
	$aCfg = $Sesion->get_var('_aAppConf');
	if (!is_array($aCfg) OR !sizeof($aCfg)) {
		$lcfmt['frac_digits'] = 3;
		$lcfmt['decimal_point'] = ',';
		$lcfmt['thousands_sep'] = '.';
	} else {
		$lcfmt['frac_digits'] = $aCfg['gnrl_frac_digits'];
		$lcfmt['decimal_point'] = $aCfg['gnrl_decimal_point'];
		$lcfmt['thousands_sep'] = $aCfg['gnrl_thousands_sep'];
	}

	$dato=ereg_replace('[^0-9,'.$lcfmt['decimal_point'].'-]*','',$dato);
	$dato=str_replace($lcfmt['decimal_point'],'.',$dato);
	if (is_numeric($aParams['num_decimales'])) $nfrac = $aParams['num_decimales'];
	else $nfrac = $lcfmt['frac_digits'];

	// debug("lcundec $dato ");
	//Quitar toda cosa que no sea un numero, o el separador decimal en el idioma.
	// Sitituir el separador decimal de idioma por el '.'
	// Probar el number_format.
	// debug(" Formateando $dato en ".$lcfmt['frac_digits']." : ".number_format($dato,$lcfmt['frac_digits'],'.',''));

	return number_format($dato,$nfrac,'.','');
	// debug("<br>lcundec $dato");
	// return $dato;
	// return number_format($dato,$lcfmt['frac_digits'],$lcfmt['decimal_point'],$lcfmt['thousands_sep']);
}

function lcdec($dato,&$Sesion,$aParams = NULL) {
	static $lcfmt;
	if (!is_numeric($dato) AND empty($dato)) return $dato;
	// debug('lcdec('.$dato.') .. '.round($dato)." clase: ".get_class($Sesion));
	if (!is_a($Sesion,'wolSesion') AND !empty($GLOBALS['APP_NAME'])) {
		$Sesion=&$GLOBALS[$GLOBALS['APP_NAME']];
	}
	$aCfg = $Sesion->get_var('_aAppConf');
	if (!is_array($aCfg) OR !sizeof($aCfg)) {
		$lcfmt['frac_digits'] = 3;
		$lcfmt['decimal_point'] = ',';
		$lcfmt['thousands_sep'] = '.';
	} else {
		$lcfmt['frac_digits'] = $aCfg['gnrl_frac_digits'];
		$lcfmt['decimal_point'] = $aCfg['gnrl_decimal_point'];
		$lcfmt['thousands_sep'] = $aCfg['gnrl_thousands_sep'];
	}
	if (is_numeric($aParams['num_decimales'])) $nfrac = $aParams['num_decimales'];
	else $nfrac = $lcfmt['frac_digits'];
	settype($dato,'float');
	$dato += 1;
	$dato -= 1;
	$tmp = (float)0;
	for ($i = 0; $i < $nfrac; $i++) {
		settype($tmp,'null');
		$tmp = round($dato,$i);
		$tmp += 1;
		$tmp -= 1;
		// debug("de $dato A $i ==  ".$tmp." <: ".($dato<$tmp)." >: ".($dato>$tmp));
		if ( !($dato != $tmp) ) {
			// debug("OK! $i ");
			$nfrac = $i;
			break;
		}
		$tmp = 0;
	}

	// print_r($lcfmt);
	// debug("Numberformat de $dato a $nfrac ..".number_format($dato,5,$lcfmt['decimal_point'],$lcfmt['thousands_sep']));
	return number_format($dato,$nfrac,$lcfmt['decimal_point'],$lcfmt['thousands_sep']);
}

function lcpto($dato,$Sesion = NULL) {
	static $lcfmt;
	if (!is_a($Sesion,'wolSesion') AND !empty($GLOBALS['APP_NAME'])) {
		$Sesion=&$GLOBALS[$GLOBALS['APP_NAME']];
	}
	$aCfg = $Sesion->get_var('_aAppConf');
	if (!is_array($aCfg) OR !sizeof($aCfg)) {
		$lcfmt['frac_digits'] = 3;
		$lcfmt['decimal_point'] = ',';
		$lcfmt['thousands_sep'] = '.';
	} else {
		$lcfmt['frac_digits'] = $aCfg['gnrl_frac_digits'];
		$lcfmt['decimal_point'] = $aCfg['gnrl_decimal_point'];
		$lcfmt['thousands_sep'] = $aCfg['gnrl_thousands_sep'];
	}

	if (!is_numeric($dato) AND empty($dato)) return $dato;
	return number_format($dato,2,$lcfmt['decimal_point'],$lcfmt['thousands_sep']);
}

function lcunpto($dato,$Sesion = NULL) {
	static $lcfmt;
	if (!is_a($Sesion,'wolSession') AND !empty($GLOBALS['APP_NAME'])) $Sesion=&$GLOBALS[$GLOBALS['APP_NAME']];
	if (is_array($dato)) {
		if (sizeof($dato)) $retval = array_map('lcundec',$dato);
		return $retval;
	}
	if (!is_numeric($dato) AND empty($dato)) return $dato;
	$aCfg = $Sesion->get_var('_aAppConf');
	if (!is_array($aCfg) OR !sizeof($aCfg)) {
		$lcfmt['frac_digits'] = 3;
		$lcfmt['decimal_point'] = ',';
		$lcfmt['thousands_sep'] = '.';
	} else {
		$lcfmt['frac_digits'] = $aCfg['gnrl_frac_digits'];
		$lcfmt['decimal_point'] = $aCfg['gnrl_decimal_point'];
		$lcfmt['thousands_sep'] = $aCfg['gnrl_thousands_sep'];
	}

	$dato=ereg_replace('[^0-9,'.$lcfmt['decimal_point'].']','',$dato);
	$dato=str_replace($lcfmt['decimal_point'],'.',$dato);

	// debug("lcundec $dato ");
	//Quitar toda cosa que no sea un numero, o el separador decimal en el idioma.
	// Sitituir el separador decimal de idioma por el '.'
	// Probar el number_format.
	// debug("Formateando $dato en ".$lcfmt['frac_digits']." : ".number_format($dato,$lcfmt['frac_digits'],'.',''));

	return number_format($dato,$lcfmt['frac_digits'],'.','');
	// debug("<br>lcundec $dato");
	// return $dato;
	// return number_format($dato,$lcfmt['frac_digits'],$lcfmt['decimal_point'],$lcfmt['thousands_sep']);
}

function lcmon($dato,$Sesion = NULL) {
	if (!is_a($Sesion,'wolSesion') AND !empty($GLOBALS['APP_NAME'])) {
		$Sesion=&$GLOBALS[$GLOBALS['APP_NAME']];
	}
	return lcdec($dato,$Sesion);

	$aCfg = $Sesion->get_var('_aAppConf');
	if (!is_array($aCfg) OR !sizeof($aCfg)) {
		$lcfmt['frac_digits'] = 3;
		$lcfmt['decimal_point'] = ',';
		$lcfmt['thousands_sep'] = '.';
		$money_fmt = '%=*#4.2n¤';
	} else {
		$lcfmt['frac_digits'] = $aCfg['gnrl_frac_digits'];
		$lcfmt['decimal_point'] = $aCfg['gnrl_decimal_point'];
		$lcfmt['thousands_sep'] = $aCfg['gnrl_thousands_sep'];
		$money_fmt = $aCfg['gnrl_money_format'];
	}
	if (!is_numeric($dato) AND empty($dato)) return $dato;
	$rval = money_format($money_fmt,$dato);
	$rval = str_replace('.',$lcfmt['decimal_point'],$rval);
	return $rval;
}

function lcunmon($dato,$Sesion = NULL) {
	if (!is_a($Sesion,'wolSession') AND !empty($GLOBALS['APP_NAME'])) $Sesion=&$GLOBALS[$GLOBALS['APP_NAME']];
	return lcundec($dato,$Sesion);

/** **
	static $lcfmt;
	if (!is_a($Sesion,'wolSession') AND !empty($GLOBALS['APP_NAME'])) $Sesion=&$GLOBALS[$GLOBALS['APP_NAME']];
	if (!is_array($lcfmt)) $lcfmt = localeconv();
	if (!is_numeric($dato) AND empty($dato)) return $dato;
	// debug("<br>lcunmon $dato");
	return $dato;
	// return number_format($dato,$lcfmt['frac_digits'],$lcfmt['decimal_point'],$lcfmt['thousands_sep']);
/** **/
}

function fmt_lcmon(&$Sesion,$aP) {
	if (!is_array($aP) OR !sizeof($aP)) return NULL;
	$dato = array_shift($aP);
	if (!is_numeric($dato)) return NULL;
	if (!is_a($Sesion,'wolSession') AND !empty($GLOBALS['APP_NAME'])) $Sesion=&$GLOBALS[$GLOBALS['APP_NAME']];
	$rv = lcmon($dato,$Sesion);
	return $rv;
}

function is_db(&$Sesion,$Param) {
	if (!is_array($Param) OR !sizeof($Param)) return false;
	$retval = true;

	foreach ($Param as $dato) {
		$oDb = $Sesion->get_db($dato);
		if (!is_a($oDb,'wol_db')) {
			$retval = false;
			break;
		}
	}

	return $retval;
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
	if (is_object($dato)) {
		if (is_array($Sesion)) $datof = array_shift($Sesion);
	} else $datof = $dato;
	return ( ((int)$datof) ? 'checked="checked"' : NULL);
}

function si_no_flag($dato,$Sesion) {
	if (is_object($dato) AND is_array($Sesion)) {
		$datof = array_shift($Sesion);
	} else $datof = $dato;

	if (method_exists($Sesion,'getMsgs')) $oMsg = $Sesion->getMsgs();
	if ((int)$datof) {
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

function a_mayor_b(&$Sesion,$aParams) {
	$cant_i = array_shift($aParams);
	if (empty($cant_i)) $cant_i = 0;

	$cant_f = array_shift($aParams);
	if (empty($cant_f)) $cant_f = 0;

	if ($cant_i > $cant_f) return 1;
	else return 0;
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

function es_par (&$Sesion,$Param) {
	$dato = array_shift($Param);
	if (is_numeric($dato)) return $dato % 2;
	return false;
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
	$reset = (int)$sesion->get_var("_var_x_reset");
	// debug("nos llega ($tmp); tenemos ($valor)");
	if ($tmp != $valor OR $reset) {
		$valor = $tmp;
		if ($reset) $sesion->unset_var('_var_x_reset');
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
		$aHP = array(	 array( 'value' => '', 'name' => '--'),
			array( 'value' => 10, 'name' => '10'),
			array( 'value' => 20, 'name' => '20'),
			array( 'value' => 30, 'name' => '30'),
			array( 'value' => 50, 'name' => '50'),
			array( 'value' => 100, 'name' => '100'),
			array( 'value' => 175, 'name' => '175'),
			array( 'value' => 250, 'name' => '250'),
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
	if (is_object($valor) AND is_array($Sesion)) $valor = array_shift($Sesion);
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
 *		 permanece constante a lo largo de la aplicacion y en cada subseccion se comprueba el escritorio activo
 *		 para modificar las condiciones de una busqueda, ver o no unos resultados/plantillas, etc... 
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
		$nfecha = array_shift($aParm);
		if (!empty($nfecha) AND strcasecmp($nfecha,'now')) $retval= colocar_fecha_hora($nfecha);
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

function _nodb_session_list(&$Sesion) {
	static $rs;
	static $bQuit = false;

	if ($bQuit) {
		$bQuit = false;
		return NULL;
	}
	$oUsr = $Sesion->get_authed_user();

	$oDbCfg = &$Sesion->get_db('conf');
	if (empty($rs) OR !isset($rs)) {
		$cons = 'SELECT sessid,modificacion,alta FROM Users_sessions WHERE id_usr = '.$oUsr->id_usr.' ORDER BY modificacion desc ';
		$rs = $oDbCfg->query($cons);
	}

	if (!$oDbCfg->num_rows($rs)) {
		$bQuit = true;
		return array('sessid' => NULL);
	}

	$aData = $oDbCfg->fetch_assoc($rs);
	if ($aData['sessid'] == session_id()) {
		$aData['ignore_link'] = true;
	}
	// debug("Obteniendo registro: ");
	// print_r($aData);

	return $aData;
}

?>
