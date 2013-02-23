<?php
/*****************************************************************
** Aplicacion diseñada para Web On Line Studios S.L.            **
**    Todos los derechos reservados.                            **
**    Este programa se podra modificar con el consentimiento    **
**    de Web On Line Studios S.L. Su distribucion queda         **
**    limitada a Web On Line Studios S.L.		        				 **
**    Las posibles modificaciones sobre esta aplicacion ajenas  **
**    a Web On Line Studios S.L. deberan ser consultadas y 		 **
**    enviadas a Web On Line Studios en C/Alcala 18 3º Izda,    **
**    28014 Madrid. Cualquier otra operacion realizada sobre 	 **
**    esta aplicacion queda limitada a Web On Line Studios S.L. **
**    infringiendo en delito cualquier otra entidad que asi lo  **
**    hiciese.       														 **
**																					 **
** Para mas informacion referente a la licencia de esta 			 **
**    aplicacion referirse al fichero LICENCIA. Caso de que Ud. **
**    no tenga una copia de este fichero, contacte con Web On 	 **
**    Line Studios S.L. para recibir una copia del mismo			 **
**							        												 **
** Informacion de Contacto				        							 **
**    Josafat Moragrega Fernandez			        					 **
**    Engineering					        									 **
**    Director Tecnico 					        							 **
**    tite@wolstudios.com													 **
**    C/Alcala 18 3º Izda, 28014 Madrid, España		        		 **
**																					 **
** 				(c) Web On Line Studios S.L. 							 **
**                                                              **
******************************************************************
*****************************************************************/

include("config.php");
include("kernel/db.inc");
include("kernel/errores.inc");
include("kernel/misc.inc");
include("kernel/sesiones.inc");
include("kernel/accesos.inc");

include("modulos/document.class.inc");
include("modulos/invoice.class.inc");
include("modulos/order.class.inc");

$Sesion = new wolSesion($APP_NAME,"Sesion"); 
$Sesion->init("BackOffice");

$oPedido = new Order(NULL,'data',inmPed_VENTA);

/** **
$oPedido->set_issuer(1);
$oPedido->set_reciever(405); //Alambique: Tiene descuentos
$idx = $oPedido->add_detail(2135,1);
/** **/
$oPedido->dbfill(2086);
/** **/

?><hr/>dbfill() -- reciente
<?php tabla_detalles($oPedido); ?>
<hr/><?php
$oPedido->debug = 1;
print_r($oPedido->getArticleContracts(2135));
// $oPedido->set_detail_contract(1,0);
// echo "Cambiamos cantidades de la promo<br/>\n";
// $oPedido->set_quantity($id_det,12);

// $oPedido->eval_conditions(TRUE);
$oPedido->debug = 0;

?><hr/>eval_conditions() ........ 
<?php tabla_detalles($oPedido); ?>
<hr/><?php
// echo "Cambiamos cantidades de la promo<br/>\n";
// $oPedido->set_quantity($id_det,24);

// $oPedido->set_quantity($id_det,3);
// $oPedido->set_discount($id_det,5,NULL,"Mi dto",TRUE);
// $oPedido->set_price($id_det,16,TRUE);

/** **
echo "<hr/>Borrando TODOS los detalles";
echo " Estos son: ".sizeof($oPedido->_aDetalles)."<br/>\n";
$oPedido->debug = 1;
for($idx = $oPedido->last_detail(); isset($idx); $idx = $oPedido->prev_detail()) {
	debug("Borrando $idx ...");
	$oPedido->del_detail($idx);
}
$oPedido->debug = 0;
/** **/

// $oPedido->set_detail_comment(1,"Comentario X-Y-Z");
//$oPedido->del_detail(1,NULL,TRUE);
// $oPedido->calculate();

//$oPedido->debug = 1;
//$oPedido->debug = 0;

$oPedido->calculate();
$oFra = new Invoice(NULL,'data',inmPed_VENTA);
$oFra->fillFromOrder($oPedido);

// $oFra->dbdump();
?>
<hr/>Post dbdump() ......
<?php tabla_detalles($oFra); ?>
<hr/>
<?php

// $oPedido->set_agent(8);
// debug("Agente:");
// print_r($oPedido->get_agent());

// echo "<hr/>Nuestras promos...";
// print_r($oPedido->_aOff_Promo);

echo "<hr/>";
tabla_totales($oPedido);
// debug("Borramos el pedido...");
// $oPedido->delete();

// debug("Volcando DB...");
// $oPedido->dbdump();
// $oPedido->dbdump_invoice();

$ref = $oPedido->get_reference();
debug("Referencia = $ref");

debug("Id-Pedido : (".$oPedido->get_id().")");

// $oPedido->dbdump_invoice();

echo "<br/>FIn del testeo. <br/>\n";

?>

<?php function tabla_detalles($oPedido) { ?>
<table>
<tr><td>IdX</td><td>Id.</td><td>Nombre</td><td>Cant.</td><td>Precio</td><td>Iva</td><td>Dto</td><td>Importe</td>
<td>Comentarios</td><td>Servicio</td></tr>
<?php
for ($idx = $oPedido->first_detail(); isset($idx); $idx = $oPedido->next_detail()) {
	$aDet = $oPedido->get_detail($idx);
?><tr>
<td><?php echo $idx ?></td>
<td><?php echo $aDet[id_articulo]; ?></td>
<td><?php echo $aDet[nombre]; ?></td>
<td><?php echo $aDet[cantidad_pedida]; ?></td>
<td><?php echo $oPedido->get_price($idx,FALSE); ?></td>
<td><?php echo $aDet[porcentaje]; ?> %</td>
<td><?php echo $aDet[tipo_descuento]; ?></td>
<td><?php echo $aDet[base_imponible]; ?></td>
<td><?php echo $aDet[observaciones]; ?></td>
<td><?php echo $aDet[id_servicio]; ?></td>
</tr><?php
}
?>
</table>
<?php } ?>

<?php function tabla_totales($oPedido) { ?>
<?php
/** **/
debug("Dtos :");
$aDtos = $oPedido->get_discounts();
print_r($aDtos);

debug("----- Ivas -------- :");
$aDtos = $oPedido->get_taxes();
print_r($aDtos);
/** **/

?>
<?php } ?>
