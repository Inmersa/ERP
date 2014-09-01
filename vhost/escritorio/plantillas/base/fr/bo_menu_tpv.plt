@%func:get_from_user;nombre_tpv;%@
@%if:AllowedLink;nuevo_ticket_venta;%@
<a href="?seccion=nuevo_ticket_venta">Passer une commande</a><br>
@%end-if:%@
@%if:AllowedLink;ticket_list;%@
<a href="?seccion=ticket_list">Liste Tickets</a><br>
@%end-if:%@
@%if:AllowedLink;bo_facturas_venta;%@
<a href="?seccion=bo_facturas_venta">Factures</a><br>
@%end-if:%@
<!--@%if:AllowedLink;bo_facturas_venta;%@
<a href="?seccion=bo_compra_venta">Renseignements</a><br>
@%end-if:%@-->
