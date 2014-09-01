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
include("../escritorio/kernel_nocifrado.inc");
include("../escritorio/modulos/misc.inc");
include("../escritorio/modulos/document.class.inc");
include("../escritorio/modulos/order.class.inc");
include("../escritorio/modulos/invoice.class.inc");
include("../escritorio/modulos/asiento.class.inc");
global $id;

$$APP_NAME = new wolSesion($APP_NAME,"Sesion"); 
$$APP_NAME->init($seccion);
$db = $$APP_NAME->get_db('data');
$dbcfg = $$APP_NAME->get_db('conf');
$oDb = $$APP_NAME->get_db('planet_gestion');

if (!isset($id)) {
	echo "Illlooooooo, dame un id_pedido o referencia en la aplicacion de PlanetOrganic. usa el paramentro id, con el formato pedidocompraplanet.php?id=xxx";
	exit();
}

if (!is_numeric($id)) {
	$cons = 'SELECT id_pedido FROM Pedidos where referencia="'.$id.'" ';
echo $cons;
	$tmprs = $oDb->query($cons);
	if (!$oDb->num_rows($tmprs)) {
		echo "No he encontrado la referencia de pedido $id ";
		exit;
	}
	$aTmp = $oDb->fetch_row($tmprs);
	$id = $aTmp[0];
	$oDb->libera($tmprs);
}

$oPedidoPlanet = new Order ($$APP_NAME->App_Name,'planet_gestion',inmPed_COMPRA);
// debug("Poblando instancia .. (".$oPedidoPlanet->dbfill($id).") ");
if ($oPedidoPlanet->dbfill($id)) {

	$oPed = new Order ($$APP_NAME->App_Name,'data',inmPed_VENTA);
	$oPed->set_issuer(1);
	$oPed->set_reciever(1571);
	$oPed->set_reciever_address(577);
	salida("Pedido de venta creado .. <br>");

	for ( $idx=$oPedidoPlanet->first_detail(); isset($idx); $idx=$oPedidoPlanet->next_detail()) {
		$aDet = $oPedidoPlanet->get_detail($idx);
		$idart = $oPedidoPlanet->get_detail_article_id();
		$cant = $oPedidoPlanet->get_quantity($idx);
		$price = $oPedidoPlanet->get_price($idx);
		salida("Detalle $idx art $idart cant $cant precio $price: <br>");

		$tmpidx = $oPed->add_detail($idart,$cant);
		$oPed->set_price($tmpidx,$price);
	}
	$oPed->calculate();
	$oPed->dbDump();
} else {
	echo "No he encontrado el pedido $id ";
	exit();
}



?>
