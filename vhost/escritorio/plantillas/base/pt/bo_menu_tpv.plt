@%func:get_from_user;nombre_tpv;%@
@%if:AllowedLink;nuevo_ticket_venta;%@
<a href="?seccion=nuevo_ticket_venta">Emitir Tal�o</a><br>
@%end-if:%@
@%if:AllowedLink;ticket_list;%@
<a href="?seccion=ticket_list">Listar Tal�es</a><br>
@%end-if:%@
@%if:AllowedLink;bo_facturas_venta;%@
<a href="?seccion=bo_facturas_venta">Facturas</a><br>
@%end-if:%@
<!--@%if:AllowedLink;bo_facturas_venta;%@
<a href="?seccion=bo_compra_venta">Relat�rios</a><br>
@%end-if:%@-->
