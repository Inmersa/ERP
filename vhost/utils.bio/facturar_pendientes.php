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

function include_inm($file) {
  return	include($file);
}

function file_inm($file) {
	return file($file);
}

include("../escritorio/config.php");				/**	  StartUp Config **/
include("../escritorio/kernel_nocifrado.inc");
include("../escritorio/modulos/ModuleAPI.inc");
include("../escritorio/modulos/misc.inc");
include("../escritorio/modulos/document.class.inc");
include("../escritorio/modulos/order.class.inc");
include("../escritorio/modulos/invoice.class.inc");
include("../escritorio/modulos/asiento.class.inc");

//include("../escritorio/modulos/module_list.inc");

include("../escritorio/modulos/efectos.inc");
include("../escritorio/modulos/notificaciones.inc");
include("../escritorio/modulos/periodificacion.inc");
include("../escritorio/modulos/unidadesmedida.class.inc");
include("../escritorio/modulos/wherehouse.class.inc");
include("../escritorio/modulos/deliverynote.class.inc");

$DEBUG='ON';
global $id;

$$APP_NAME = new wolSesion($APP_NAME,"Sesion"); 
$$APP_NAME->init($seccion);
$oDb = $$APP_NAME->get_db('data');
$dbcfg = $$APP_NAME->get_db('conf');

$aBultos = array();
if (!is_numeric($id)) {
	$cons = 'SELECT P.id_pedido,P.referencia,P.fecha FROM Pedidos P LEFT JOIN Pedidos_facturas PF ON (PF.id_pedido=P.id_pedido) JOIN IVAs I ON (P.id_pedido=I.id_pedido) JOIN Albaranes A ON (P.id_pedido=A.id_pedido) '.
		'WHERE P.preparado = 1 AND (P.id_proveedor = 0 OR P.id_proveedor IS NULL) AND PF.id_factura IS NULL '.
		'AND P.fecha > DATE_SUB(NOW(),INTERVAL 5 DAY) '.
		'GROUP BY P.id_pedido '.
		'ORDER BY P.fecha desc ';
// echo $cons;
	$tmprs = $oDb->query($cons);
	if (!$oDb->num_rows($tmprs)) {
		echo "No he encontrado ninguna referencia de pedido ($id) ";
		exit;
	}
	$where_ped = '';
	debug("Tenemos un total de: ".$oDb->num_rows($tmprs)." Pedidos Pendientes .. ");
	$lista = array();
	while ( $aTmp = $oDb->fetch_row($tmprs) ) {
		array_push($lista,$aTmp[0]);
		$aBultos[$aTmp[0]] = $aTmp[3];
		// debug("id ".$aTmp[0]."/".$aTmp[1]." ".$aTmp[3]." ".$aTmp[2]);
		if (strlen($where_ped)) { $where_ped .= ' OR '; }
		$where_ped .= ' id_pedido = '.$aTmp[0];
	}
	$oDb->libera($tmprs);

	$cons = 'SELECT id_pedido,SUM(bultos) FROM Albaranes WHERE '.$where_ped.' GROUP BY id_pedido ';
	$tmprs = $oDb->query($cons);
	while ( $aTmp = $oDb->fetch_row($tmprs) ) {
		// print_r($aTmp);
		$aBultos[$aTmp[0]] = $aTmp[1];
	}
	$oDb->libera($tmprs);
}

echo "<hr>";

if (is_array($lista) AND sizeof($lista)) {
	foreach ($lista as $id_pedido) {
		$bultos = $aBultos[$id_pedido];
		$oPedido = new Order($$APP_NAME->App_Name,'data',inmPed_VENTA);
		if ($oPedido->dbfill($id_pedido)) {
			$aDir = $oPedido->get_reciever_address();
			$id_dir = $aDir[0]['id_direccion'];
			if (strlen($id_dir)>0) {
				if (!is_array($aPedCli[$id_dir])) $aPedCli[$id_dir] = array();
				debug($oPedido->get_reference()." para ".$oPedido->get_reciever_id()." en ".$oPedido->get_date()." bultos ".$bultos);
				$aTmp = $oPedido->get_deliveries();
				// print_r($aTmp);
				array_push($aPedCli[$id_dir],$oPedido);
			}
		} else {
			debug("Error: No se ha podido rellenar el pedido $id_pedido ");
		}
		$oPedido = NULL;
		unset($oPedido);
	}
	if (!sizeof($aPedCli)) {
		echo "NO hay pedidos que facturar. ";
		exit;
	}
	if (is_array($aPedCli) AND sizeof($aPedCli)) {
		$aCfg = $$APP_NAME->get_var('_aAppConf');
		$bResiduo = (bool)$aCfg['invoice_onnew_residual'];
		$bResiduo = true;
		$ntot = 0;
		foreach ($aPedCli as $idcli => $aPeds) {
			$ntot += sizeof($aPeds);
			// $ts = strtotime('3 day ago');
			// $fecha = strftime('%Y-%m-%d %H:%M:%S',$ts);
			// debug("Cliente $idcli con : ".sizeof($aPeds)." En: ".$fecha);

			$tot_bultos = 0;
			$oFactura = new Invoice($$APP_NAME->App_Name,'data',inmPed_VENTA);
			if (is_array($aPeds) AND sizeof($aPeds)) {
				foreach ($aPeds as $oPed) {
					$oFactura->fillFromOrder($oPed,NULL,$bResiduo);
					$tot_bultos += $aBultos[$oPed->getId()];
				}
			}
			if (is_numeric($id_serie_facturacion)) 
				$oFactura->setSeries($id_serie_facturacion);
			// $oFactura->setDate($fecha);
			$txt_nota = '';
			$oFactura->setHeaderAttribute('observaciones','BULTOS '.$tot_bultos);

			// debug("NO Volcamos la Fra ");
			if ((float)$oFactura->get_totals('base_imponible')==0) {
				$aDir = $oFactura->get_reciever_info();
				$info1 = 'Fra sin importe. no consolidado para '.$aDir['razon_social'];
				echo $info1."<br/>\n";
			} else {
				$oFactura->dbDump();
				$aDir = $oFactura->get_reciever_info();
				$info1 = 'Fra '.$oFactura->get_reference().' con '.$oFactura->num_details().
					' detalles y '.$tot_bultos.' bultos . importe '.
					$oFactura->get_totals('base_imponible').' para '.$aDir['razon_social'];
				echo $info1."<br/>\n";
			}

			$oFactura=NULL;
		}
		debug("En total $ntot pedidos. ");
	}
}

