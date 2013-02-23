<?php
/*****************************************************************
** Aplicacion diseñada para Web On Line Studios S.L.            **
**    Todos los derechos reservados.                            **
**    Este programa se podra modificar con el consentimiento    **
**    de Web On Line Studios S.L. Su distribucion queda         **
**    limitada a Web On Line Studios S.L.								 **
**    Las posibles modificaciones sobre esta aplicacion ajenas  **
**    a Web On Line Studios S.L. deberan ser consultadas y		 **
**    enviadas a Web On Line Studios en C/Alcala 18 3º Izda,    **
**    28014 Madrid. Cualquier otra operacion realizada sobre		**
**    esta aplicacion queda limitada a Web On Line Studios S.L. **
**    infringiendo en delito cualquier otra entidad que asi lo	 **
**    hiciese.																	**
**																					 **
** Para mas informacion referente a la licencia de esta			 **
**    aplicacion referirse al fichero LICENCIA. Caso de que Ud. **
**    no tenga una copia de este fichero, contacte con Web On	 **
**    Line Studios S.L. para recibir una copia del mismo			 **
**																					 **
** Informacion de Contacto													 **
**    Josafat Moragrega Fernandez										 **
**    Engineering																 **
**    Director Tecnico														 **
**    tite@wolstudios.com													 **
**    C/Alcala 18 3º Izda, 28014 Madrid, España						 **
**																					 **
**										  (c) Web On Line Studios S.L.	 **
**                                                              **
******************************************************************
*****************************************************************/


include("../escritorio/config.php");									/**	  StartUp Config **/
include("planetsync_conf.php");									/**	  StartUp Config **/
include("../escritorio/kernel_nocifrado.inc");
include("../escritorio/modulos/misc.inc");
include("../escritorio/modulos/document.class.inc");
include("../escritorio/modulos/order.class.inc");
include("../escritorio/modulos/invoice.class.inc");
include("../escritorio/modulos/asiento.class.inc");
$DEBUG='ON';
global $id;
global $lockfile;
$lockfile = '/tmp/planetsync.lock';

/** Configuracion que ira en planetsync_conf.php **/
$bioIDEmpresa = 1;
$bioIDCliente = 2015;
$bioIDDireccion = 577;
$planetIDProveedor = 1;
$planetIDEmpresa = 1;
$planetIDAlmacen = 1;

$dbSyncLogin = 'mysql';
$dbSyncPass = '.lamah.cop';
$dbSyncHost = 'dbserver.devel';
$dbSyncPort = '3306';
/** **/

$Sesion = $$APP_NAME = new wolSesion($APP_NAME,"Sesion"); 
$$APP_NAME->init($seccion);
$db = $$APP_NAME->get_db('data');
$dbcfg = $$APP_NAME->get_db('conf');
$oDb = $$APP_NAME->get_db('planet_gestion');

debug("Comprobando conectores ... $APP_NAME ");
if (strstr($APP_NAME,'planet')) {
	debug("Estamos en planet: ");
	$dbname_biomundo = 'biomundo_gestion';
	$oDbBio = $Sesion->get_db($dbname_biomundo);
	if (!is_a($oDbBio,'wol_db')) {
		echo "No se ha podido obtener el conector a la app de sincronizacion ($dbname_biomundo). <br>\n";
		exit;
	}
	$dbname_planet = 'data';
	$oDbPla = $Sesion->get_db($dbname_planet);
	if (!is_a($oDbBio,'wol_db')) {
		echo "No se ha podido obtener el conector de la app de sincronizada ($dbname_planet). <br>\n";
		exit;
	}
} else {
	debug("Estamos en biomundo: ");
	$dbname_biomundo = 'data';
	$oDbBio = $Sesion->get_db($dbname_biomundo);
	if (!is_a($oDbBio,'wol_db')) {
		echo "No se ha podido obtener el conector a la app de sincronizacion ($dbname_biomundo). <br>\n";
		exit;
	}
	$dbname_planet = 'planet_gestion';
	$oDbPla = $Sesion->get_db($dbname_planet);
	if (!is_a($oDbBio,'wol_db')) {
		echo "No se ha podido obtener el conector de la app de sincronizada ($dbname_planet). <br>\n";
		exit;
	}
}
$dbase_biomundo = $oDbBio->get_dbase_name();
$dbase_planet = $oDbPla->get_dbase_name();

if (file_exists($lockfile)) {
	$aTmp = stat($lockfile);
	die("Syncronizacion en curso por otra sesion, o muerte subita de una sincronizacion previa en ".$aTmp[10]);
}
$fplock = @fopen($lockfile, "x");
if (!$fplock) {
	die("No se ha podido crear fichero de bloqueo. ");
}

$cons = 'SELECT P.id_pedido FROM Pedidos P LEFT JOIN Pedidos_facturas PF ON (P.id_pedido = PF.id_pedido) '.
			'WHERE (P.id_proveedor IS NULL OR P.id_proveedor = 0) AND '.
			'P.preparado=0 AND PF.id_factura IS NULL AND (P.referencia_externa IS NULL OR P.referencia_externa = "") '.
			'ORDER BY P.fecha desc ';
// debug($cons);
$pprs = $oDbPla->query($cons);
if ($oDbPla->num_rows($pprs)) {
	echo "Comprobando Pedidos Pendientes de Sincronizacion : ".$oDbPla->num_rows($pprs)."<br>\n";

	while ( $aIDP = $oDbPla->fetch_row($pprs)) {

		// Poblando instancia pedido venta
		$oPPlanet = new Order ($$APP_NAME->App_Name,$dbname_planet,inmPed_VENTA);
		if (!$oPPlanet->dbfill($aIDP[0])) {
			echo "Error: No se ha podido poblar el pedido id ".$aIDP[0];
			continue;
		}
		// Creando instancia pedido venta sincronizado
		$oPBio = new Order ($$APP_NAME->App_Name,$dbname_biomundo,inmPed_VENTA);
		if (!is_a($oPBio,'Document')) {
			echo "Error: No se ha podido crear instancia pedido en la aplicacion destino ($dbname_biomundo) ";
			continue;
		}
		// poblando instancia pedido venta sincronizado
		$bDone = $oPBio->set_issuer($bioIDEmpresa);
		if ($bDone) $bDone = $oPBio->set_reciever($bioIDCliente);
		if ($bDone) $bDone = $oPBio->set_reciever_address($bioIDDireccion);
		if (!$bDone) {
			echo "Error: No se ha podido crear instancia pedido para el cliente ($bioIDCliente) en la aplicacion destino ($dbname_biomundo) ";
			continue;
		}
		$direccion = NULL;
		$aRec = $oPPlanet->get_reciever_info();
		$aDir = $oPPlanet->get_reciever_address();
		if (is_array($aDir) AND sizeof($aDir) AND !empty($aDir[0]['id_direccion']) ) {
			$aDir = array_shift($aDir);
			$direccion .= '['.$aDir['id_direccion'].'] '.$aDir['nombre'].' '.$aDir['direccion'].' '.$aDir['poblacion'].' '.$aDir['cp'].' '.$aDir['provincia'];
		}
		$oPBio->set_comments($aRec['razon_social'].' ('.$aRec['id'].') - '.$aRec['nombre'].' '.$aRec['apellidos']." \n".$direccion);
	
		// Sincronizando pedidos 
		for ( $idx=$oPPlanet->first_detail(); isset($idx); $idx=$oPPlanet->next_detail()) {
			$idart = $oPPlanet->get_detail_article_id();
			$cant = $oPPlanet->get_quantity($idx);
			$tmpidx = $oPBio->add_detail($idart,$cant);
		}
		// Cruzando referencias de los pedidos
		$oPBio->set_ext_reference($oPPlanet->get_reference());
		$oPBio->calculate();
		$oPBio->dbDump();
		$bioref = $oPBio->get_reference();
		echo "Sincronizado pedido ".$oPPlanet->get_reference()." en ".$bioref."<br>\n";

		$oPPlanet->set_ext_reference($bioref);
		$oPPlanet->calculate();
		$oPPlanet->dbDump();

		// Creando y poblando instancia de compra
		$oPPlanet = NULL;
		$oPPlanet = new Order ($$APP_NAME->App_Name,$dbname_planet,inmPed_COMPRA);
		$bDone = $oPPlanet->set_issuer($planetIDProveedor);
		if ($bDone) $bDone = $oPPlanet->set_reciever($planetIDEmpresa);
		if ($bDone) $bDone = $oPPlanet->set_reciever_address($planetIDAlmacen);
		if (!$bDone) {
			echo "Error: No se ha podido crear instancia pedido de compra para el proveedor ($planetIDProveedor) en la aplicacion destino ($dbname_planet) ";
			continue;
		}

		// Fusilando condiciones de compra con las de venta del pedido sincronizado
		$oPPlanet->copyFromDocument($oPBio,true,false,true);
		$aDto = $oPBio->get_discounts();
		if (is_array($aDto['detalle']) AND sizeof($aDto['detalle'])) {
			$oPPlanet->clean_discounts();
			foreach ($aDto['detalle'] as $ord => $aD) {
				$oPPlanet->set_discount($ord,$aD['descuento'],$aD['nombre'],(bool)$aD['financiero']);
			}  
		} else $this->clean_discounts();
		// Cruzando referencias con el pedido de venta sincronizado
		$oPPlanet->set_ext_reference($bioref);
		$oPPlanet->calculate();
		$oPPlanet->dbDump();

		echo "Comprado pedido ".$oPPlanet->get_reference()." de ".$bioref."<br>\n";
		$oPPlanet = NULL;
	}

} else echo "No se ha encontrado ningun Pedido pendiente de sincronizacion. ";
$oDbPla->libera($pprs);
echo "<br><br>\n";

$oDbSync = new wol_db('sync',$dbSyncLogin,$dbSyncPass,$dbSyncHost,$dbase_planet,$dbSyncPort);
if (!is_a($oDbSync,'wol_db') OR !$oDbSync->conectado()) {
	echo 'Error: No se ha podido conectar a '.$dbSyncHost.' con el usuario '.$dbSyncLogin.' para comprobar los albaranes. ';
	exit;
}

// Primero extraemos todos los albaranes preparados de pedidos no preparados
$cons = 'SELECT AB.id_albaran,P.id_pedido '.
			'FROM '.$dbase_planet.'.Pedidos P JOIN '.$dbase_biomundo.'.Pedidos PB ON (PB.referencia_externa=P.referencia) '.
			'JOIN '.$dbase_biomundo.'.Albaranes AB ON (PB.id_pedido=AB.id_pedido) '.
			'LEFT JOIN '.$dbase_planet.'.Albaranes A ON (P.id_pedido = A.id_pedido) '.
			'WHERE PB.preparado = 1 AND AB.preparado = 1 '.'AND P.preparado = 0 '.
			'AND (P.id_proveedor = 0 OR P.id_proveedor IS NULL) '.
			'GROUP BY AB.id_albaran ';
debug($cons);
$pedrs = $oDbSync->query($cons);
if ($oDbSync->num_rows($pedrs)) {

	$str_where = NULL;
	while ($aTmp = $oDbSync->fetch_row($pedrs)) {
		$str_where .= ( (!empty($str_where)) ? ' OR ' : '').' AB.id_albaran = '.$aTmp[0];
	}
	$oDbSync->libera($pedrs);

	if (!empty($str_where)) {
		$cons = 'SELECT P.id_pedido as "ped_id_pedido",PC.id_pedido as "ped_id_pedido_compra", AB.* '.
					'FROM '.$dbase_biomundo.'.Albaranes AB '.
					'LEFT JOIN '.$dbase_planet.'.Albaranes A ON (A.referencia_externa = AB.referencia) '.
					'JOIN '.$dbase_biomundo.'.Pedidos PB ON (PB.id_pedido=AB.id_pedido) '.
					'JOIN '.$dbase_planet.'.Pedidos P ON (P.referencia=PB.referencia_externa) '.
					'LEFT JOIN '.$dbase_planet.'.Pedidos PC ON (PC.referencia_externa=PB.referencia) '.
					'WHERE (A.id_albaran IS NULL ) AND ( PC.id_direccion = 0 OR PC.id_direccion IS NULL ) '.
					'AND (P.id_proveedor = 0 OR P.id_proveedor IS NULL) '.
					'AND ( '.$str_where.' ) ';
		debug($cons);
		$albrs = $oDbSync->query($cons);
		echo "Comprobando Albaranes Preparados Pendientes de Sincronizacion : ".$oDbSync->num_rows($albrs).' <br>';
		if ($oDbSync->num_rows($albrs)) {
			$aAlbList = array();
			$aPeds = array();
			$aPedsCompra = array();
			while ($aTmp = $oDbSync->fetch_assoc($albrs)) {
				if (in_array($aTmp['id_albaran'],$aAlbList)) continue;
				array_push($aAlbList,$aTmp['id_albaran']);

				foreach ($aTmp as $campo => $valor) if (strcmp(substr($campo,0,4),'ped_')) $aAlb[$campo] = $valor;
				$id_pedido = $aTmp['ped_id_pedido'];
				$id_pedido_compra = $aTmp['ped_id_pedido_compra'];

				if (!is_a($aPeds[$aAlb['id_pedido']],'Document')) {
					$oPPlanet = $aPeds[$id_pedido] = new Order ($$APP_NAME->App_Name,$dbname_planet,inmPed_VENTA);
					if (!$oPPlanet->dbfill($id_pedido)) {
						echo "Error: No se ha podido poblar el pedido id ".$id_pedido;
						continue;
					}
				}

				if (!empty($id_pedido_compra) AND !is_a($aPedsCompra[$id_pedido_compra],'Document')) {
					$oPPlanetCompra = $aPedsCompra[$id_pedido_compra] = new Order ($$APP_NAME->App_Name,$dbname_planet,inmPed_COMPRA);
					if (!$oPPlanetCompra->dbfill($id_pedido_compra)) {
						echo "Error: No se ha podido poblar el pedido de compra con id ".$id_pedido_compra;
						continue;
					}
				}

				debug("Insertando nuevo albaran para $id_pedido ");
				$aNewAlb = $aAlb;
				$id_albaran_orig = $aAlb['id_albaran'];
				$aNewAlb['id_albaran'] = NULL;
				$aNewAlb['id_pedido'] = $id_pedido;
				$aNewAlb['id_almacen'] = $planetIDAlmacen;

				// crear la referencia e incrementar el contador
				$consulta = "SELECT prefijo_alb_ventas as 'prefijo_alb' , sufijo_alb_ventas as 'sufijo_alb', ".
								"contador_alb_ventas as 'contador_alb' , digitos_alb_ventas as 'digitos_alb' ".
								"FROM  Empresas WHERE id_empresa = ".$planetIDEmpresa;
				$cntrs = $oDbPla->query ($consulta);
				if (!$oDbPla->num_rows($cntrs)) {
					echo "Error: No se ha podido obtener el contador de Albaranes para ".$dbname_planet;
					continue;
				}
				$aCnt = $oDbPla->fetch_array ($cntrs);
				$oDbPla->libera($cntrs);

				// relleno de digitos para la numeracion del pedido
				$temporal = pow (10, ($aCnt['digitos_alb'] + 1));
				$temporal += $aCnt['contador_alb'];
				$t = substr ((string) $temporal, 1);

				$aNewAlb["referencia_externa"] = $aNewAlb['referencia'];
				$aNewAlb["referencia"] = $aCnt['prefijo_alb'].$t.$aCnt['sufijo_alb'];
				$consulta = "UPDATE Empresas SET contador_alb_ventas = contador_alb_ventas + 1 WHERE id_empresa = ".$planetIDEmpresa;
				$oDbPla->query ($consulta);
				if (!$oDbPla->tb_insert('Albaranes',$aNewAlb)) {
					echo "Error: No se ha podido Insertar el albaran en ".$dbase_planet;
					continue;
				}
				$aNewAlb['id_albaran'] = $oDbPla->last_insert_id();
				$id_albaran = $aNewAlb['id_albaran'];

				// Insertando pedido de compra: 
				if (!empty($id_pedido_compra)) {
					$aAlbCompra = $aNewAlb;
					$aAlbCompra['id_albaran'] = NULL;
					$aAlbCompra['referencia'] = NULL;
					$aAlbCompra['id_pedido'] = $id_pedido_compra;

					// crear la referencia e incrementar el contador
					$consulta = "SELECT prefijo_alb_compras as 'prefijo_alb' , sufijo_alb_compras as 'sufijo_alb', ".
									"contador_alb_compras as 'contador_alb' , digitos_alb_compras as 'digitos_alb' ".
									"FROM  Empresas WHERE id_empresa = ".$planetIDEmpresa;
					$cntrs = $oDbPla->query ($consulta);
					if (!$oDbPla->num_rows($cntrs)) {
						echo "Error: No se ha podido obtener el contador de Albaranes para ".$dbname_planet;
						continue;
					}
					$aCnt = $oDbPla->fetch_array ($cntrs);
					$oDbPla->libera($cntrs);

					// relleno de digitos para la numeracion del pedido
					$temporal = pow (10, ($aCnt['digitos_alb'] + 1));
					$temporal += $aCnt['contador_alb'];
					$t = substr ((string) $temporal, 1);

					$aAlbCompra["referencia"] = $aCnt['prefijo_alb'].$t.$aCnt['sufijo_alb'];
					$consulta = "UPDATE Empresas SET contador_alb_compras = contador_alb_compras + 1 WHERE id_empresa = ".$planetIDEmpresa;
					$oDbPla->query ($consulta);
					if (!$oDbPla->tb_insert('Albaranes',$aAlbCompra)) {
						echo "Error: No se ha podido Insertar el albaran en ".$dbase_planet;
						continue;
					}
					$aAlbCompra['id_albaran'] = $oDbPla->last_insert_id();
				}
				// print_r($aNewAlb);

				$oDbBio->query('UPDATE Albaranes SET referencia_externa = "'.$aNewAlb['referencia'].'" WHERE id_albaran = '.$id_albaran_orig);

				$cons = 'SELECT Da.*,Ld.id_articulo '.
							'FROM '.$dbase_biomundo.'.Detalles_albaran Da JOIN '.$dbase_biomundo.'.Lineas_detalle Ld ON (Da.id_detalle = Ld.id_detalle) '.
							'WHERE Da.id_albaran = '.$id_albaran_orig.
							' ORDER BY Da.id_detalle asc ';
				$drs = $oDbSync->query($cons);
				if (!$oDbSync->num_rows($drs)) {
					echo "Error: Albaran ".$aAlb['referencia']." no tiene lineas de detalle. ";
					continue;
				}

				$aPedDets = array();
				$aPedCompraDets = array();
				$lastDbDet = NULL;
				$lastDbDetCompra = NULL;
				$dbDetPla = NULL;
				$dbDetPlaCompra = NULL;
				while ($aDet = $oDbSync->fetch_assoc($drs)) {
					$idart = $aDet['id_articulo'];
					if (!is_array($aPedDets[$idart])) {
						$aPedDets[$idart] = array();
						$aTmp = $oPPlanet->get_idxdetail_art($aDet['id_articulo']);
						if (!is_array($aTmp) OR !sizeof($aTmp)) {
							echo "Error: No se ha encontrado el IDArt($idart) en el pedido de Planet (".$oPPlanet->get_reference().") <br>";
						} else 
										foreach ($aTmp as $i => $idx) {
											$aArt = array();
											$aArt[0] = $idx;
											$aArt[1] = $oPPlanet->get_quantity($idx);
											array_push($aPedDets[$idart],$aArt);
										}
					}
					if (!empty($id_pedido_compra) AND !is_array($aPedCompraDets[$idart])) {
						$aPedCompraDets[$idart] = array();
						$aTmp = $oPPlanetCompra->get_idxdetail_art($aDet['id_articulo']);
						foreach ($aTmp as $i => $idx) {
							$aArt = array();
							$aArt[0] = $idx;
							$aArt[1] = $oPPlanetCompra->get_quantity($idx);
							array_push($aPedCompraDets[$idart],$aArt);
						}
					}

					debug("Lineas Detalles: ");
					if (!is_numeric($lastDbDet) OR $lastDbDet != $aDet['id_detalle']) {
						$lastDbDet = $aDet['id_detalle'];
						$aIdx = array_shift($aPedDets[$idart]);
							
						$bFound = false;
						if ($aIdx[1] != $aDet['cantidad']) {
							array_unshift($aPedDets[$idart],$aIdx);
							foreach ($aPedDets[$idart] as $i => $aArt) {
								if ($aArt[1] == $aDet['cantidad']) {
									$idx = $aArt[0];
									$cant = $aArt[1];
									$aPedDets[$idart][$i] = NULL;
									unset($aPedDets[$idart][$i]);
									$bFound = true;
								}
							}
							if (!$bFound) $aIdx = array_shift($aPedDets[$idart]);
						}
						if (!$bFound) {
							$idx = $aIdx[0];
							$cant = $aIdx[1];
						}

						debug("Averiguando el detalle para art $idart : idx($idx) cant(".$aDet['cantidad'].") de ($cant) ");
						$dbDetPla = $oPPlanet->getDetailAttribute($idx,'id_detalle');
					}
					debug("Insertando Linea de venta id ".$aDet['id_detalle']." art: $idart en idx $idx ");

					$aNewDet = $aDet;
					$aNewDet['id_albaran'] = $aNewAlb['id_albaran'];
					$aNewDet['id_detalle'] = $dbDetPla;
					if ($oDbPla->tb_insert('Detalles_albaran',$aNewDet)) {
						$oDbPla->query('UPDATE Lineas_detalle SET cantidad_recibida = cantidad_recibida + '.$aNewDet['cantidad'].' WHERE id_detalle = '.$dbDetPla);
					}

					if (!empty($id_pedido_compra)) {
						if ((!is_numeric($lastDbDetCompra) OR $lastDbDetCompra != $aDet['id_detalle']) ) {
							$lastDbDetCompra = $aDet['id_detalle'];
							$aIdx = array_shift($aPedCompraDets[$idart]);
								
							$bFound = false;
							if ($aIdx[1] != $aDet['cantidad']) {
								array_unshift($aPedCompraDets[$idart],$aIdx);
								foreach ($aPedCompraDets[$idart] as $i => $aArt) {
									if ($aArt[1] == $aDet['cantidad']) {
										$idx = $aArt[0];
										$cant = $aArt[1];
										$aPedCompraDets[$idart][$i] = NULL;
										unset($aPedCompraDets[$idart][$i]);
										$bFound = true;
									}
								}
								if (!$bFound) $aIdx = array_shift($aPedCompraDets[$idart]);
							}
							if (!$bFound) {
								$idx = $aIdx[0];
								$cant = $aIdx[1];
							}

							debug("Averiguando el detalle para art $idart : idx($idx) cant(".$aDet['cantidad'].") de ($cant) ");
							$dbDetPlaCompra = $oPPlanetCompra->getDetailAttribute($idx,'id_detalle');
						}
						debug("Insertando Linea de compra id ".$aDet['id_detalle']." art: $idart en idx $idx ");

						$aNewDet = $aDet;
						$aNewDet['id_albaran'] = $aAlbCompra['id_albaran'];
						$aNewDet['id_detalle'] = $dbDetPlaCompra;
						if ($oDbPla->tb_insert('Detalles_albaran',$aNewDet)) {
							$oDbPla->query('UPDATE Lineas_detalle SET cantidad_recibida = cantidad_recibida + '.$aNewDet['cantidad'].' WHERE id_detalle = '.$dbDetPlaCompra);
						}
					}

				}
				$oDbSync->libera($drs);
			}

			// Marcando todos los pedidos como preparados.
			if (is_array($aPeds) AND sizeof($aPeds)) {
				$aP = array_keys($aPeds);
				$str_where = NULL;
				foreach ($aP as $idp) $str_where .= ( (!empty($str_where)) ? ' OR ' : '').' id_pedido = '.$idp;
				$oDbPla->query('UPDATE Pedidos SET preparado = 1 WHERE ( '.$str_where.' ) ');
			}

			if (is_array($aPedsCompra) AND sizeof($aPedsCompra)) {
				$aP = array_keys($aPedsCompra);
				$str_where = NULL;
				foreach ($aP as $idp) $str_where .= ( (!empty($str_where)) ? ' OR ' : '').' id_pedido = '.$idp;
				$oDbPla->query('UPDATE Pedidos SET preparado = 1 WHERE ( '.$str_where.' ) ');
			}

		}
		$oDbSync->libera($albrs);
	}
} else $oDbSync->libera($pedrs);

// Buscando Nuevos albaranes sin preparar, de pedidos sincronizados, para desmarcarlos como preparados.
$cons = 'SELECT P.id_pedido '.
			'FROM '.$dbase_planet.'.Pedidos P JOIN '.$dbase_biomundo.'.Pedidos PB ON (PB.referencia_externa=P.referencia) '.
			'JOIN '.$dbase_biomundo.'.Albaranes AB ON (PB.id_pedido=AB.id_pedido) '.
			'LEFT JOIN '.$dbase_planet.'.Albaranes A ON (P.id_pedido = A.id_pedido) '.
			'WHERE AB.preparado = 0 AND P.preparado = 1 GROUP BY PB.id_pedido';
$albrs = $oDbSync->query($cons);
if ($oDbSync->num_rows($albrs)) {
	echo "Desmarcando como preparados, los pedidos con nuevos albaranes no preparados <br>\n";
	$str_where = NULL;
	while ($aTmp = $oDbSync->fetch_row($albrs)) {
		$str_where .= ( (!empty($str_where)) ? ' OR ' : '').' id_pedido = '.$aTmp[0];
	}
	if (!empty($str_where)) {
		$oDbPla->query('UPDATE Pedidos SET preparado = 0 WHERE '.$str_where);
	}
}
$oDbSync->libera($albrs);

$cons = 'SELECT P.id_pedido '.
			'FROM '.$dbase_planet.'.Pedidos P JOIN '.$dbase_biomundo.'.Pedidos PB ON (PB.referencia_externa=P.referencia) '.
			'JOIN '.$dbase_biomundo.'.Albaranes AB ON (PB.id_pedido=AB.id_pedido) '.
			'LEFT JOIN '.$dbase_planet.'.Albaranes A ON (P.id_pedido = A.id_pedido) '.
			'WHERE P.preparado = 1 GROUP BY P.id_pedido HAVING COUNT(A.id_albaran) != COUNT(AB.id_albaran) ';
$albrs = $oDbSync->query($cons);
debug($cons);
if ($oDbSync->num_rows($albrs)) {
	echo "Desmarcando como preparados, los pedidos con nuevos albaranes no sincronizados <br>\n";
	$str_where = NULL;
	while ($aTmp = $oDbSync->fetch_row($albrs)) {
		$str_where .= ( (!empty($str_where)) ? ' OR ' : '').' id_pedido = '.$aTmp[0];
	}
	if (!empty($str_where)) {
		$oDbPla->query('UPDATE Pedidos SET preparado = 0 WHERE '.$str_where);
	}
}
$oDbSync->libera($albrs);

unlink($lockfile);

?>
