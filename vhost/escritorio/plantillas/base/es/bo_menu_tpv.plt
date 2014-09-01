@%func:get_from_user;nombre_tpv;%@
@%if:AllowedLink;nuevo_ticket_venta;%@
<a href="?seccion=nuevo_ticket_venta">Hacer Ticket</a><br>
@%end-if:%@
@%if:AllowedLink;ticket_list;%@
<a href="?seccion=ticket_list">Listar Tickets</a><br>
@%end-if:%@
@%if:AllowedLink;bo_facturas_venta;%@
<a href="?seccion=bo_facturas_venta">Facturas</a><br>
@%end-if:%@
<!--@%if:AllowedLink;bo_facturas_venta;%@
<a href="?seccion=bo_compra_venta">Informes</a><br>
@%end-if:%@-->
