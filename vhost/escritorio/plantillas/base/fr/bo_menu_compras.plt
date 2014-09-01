@%if:AllowedLink;bo_pedidos_compras;%@
<div class="menuitem"> <a href="?seccion=bo_pedidos_compras" @%func:querystring_activa;bo_pedidos_compras;activo;;%@ >Commandes</a></div>
@%end-if:%@
@%if:AllowedLink;bo_albaranes_compra;%@
<div class="menuitem"> <a href="?seccion=bo_albaranes_compra" @%func:querystring_activa;bo_albaranes_compra;activo;;%@ >Livraisons</a></div>
@%end-if:%@
@%if:AllowedLink;bo_facturas_compra;%@
<div class="menuitem"> <a href="?seccion=bo_facturas_compra" @%func:querystring_activa;bo_facturas_compra;activo;;%@ >Factures</a></div>
@%end-if:%@
@%if:AllowedLink;dashboard_compras;%@
<div class="menuitem"> <a href="?seccion=dashboard_compras" @%func:querystring_activa;dashboard_compras;activo;;%@ >Dashboards</a></div>
@%end-if:%@
@%if:AllowedLink;nuevo_pedido_compra;%@
<div class="menuitem"><a href="?seccion=nuevo_pedido_compra&pedido=1&nuevo=1&_chgsm=1" @%func:querystring_activa;nuevo_pedido_compra&pedido=1;activo;;%@ 
>Passer une commande</a></div>
@%end-if:%@
