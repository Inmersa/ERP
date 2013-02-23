@%if:AllowedLink;hacer_pedido_compra;%@
<div class="menuitem"> <a href="?seccion=hacer_pedido_compra&pedido=1&nuevo=1&_chgsm=1" @%func:querystring_activa;hacer_pedido_compra&pedido=1;activo;;%@ >Emitir Encomenda</a></div>
@%end-if:%@
@%if:AllowedLink;hacer_pedido;%@
<div class="menuitem"> <a href="?seccion=hacer_pedido_compra&factura=1&nuevo=1&_chgsm=1" @%func:querystring_activa;hacer_pedido_compra&factura=1;activo;;%@ >Emitir Factura</a></div>
@%end-if:%@
@%if:AllowedLink;modif_proveedores;%@
<div class="menuitem"> <a href="?seccion=modif_proveedores" @%func:querystring_activa;modif_proveedores;activo;;%@ >Informações Gerais</a></div>
@%end-if:%@
@%if:AllowedLink;bo_compra_articulos_proveedor;%@
<div class="menuitem"> <a href="?seccion=bo_compra_articulos_proveedor" @%func:querystring_activa;bo_compra_articulos_proveedor;activo;;%@ >Tabela de Preços</a></div>
@%end-if:%@
@%if:AllowedLink;bo_informe_proveedor;%@
<div class="menuitem"> <a href="?seccion=bo_informe_proveedor" @%func:querystring_activa;bo_informe_proveedor;activo;;%@ >Relatório de Facturas</a></div>
@%end-if:%@
@%if:AllowedLink;bo_pedidos_tipo_proveedor;%@
<div class="menuitem"> <a href="?seccion=bo_pedidos_tipo_proveedor" @%func:querystring_activa;bo_pedidos_tipo_proveedor;activo;;%@ >Encomendas Padrão</a></div>
@%end-if:%@
@%if:AllowedLink;bo_pedidos_proveedor;%@
<div class="menuitem"> <a href="?seccion=bo_pedidos_proveedor" @%func:querystring_activa;bo_pedidos_proveedor;activo;;%@ >Histórico de Encomendas</a></div>
@%end-if:%@
@%if:AllowedLink;bo_facturas_proveedor;%@
<div class="menuitem"> <a href="?seccion=bo_facturas_proveedor" @%func:querystring_activa;bo_facturas_proveedor;activo;;%@ >Histórico de Facturas</a></div>
@%end-if:%@
@%if:AllowedLink;dashboard_proveedores;%@
<div class="menuitem"><a href="?seccion=dashboard_proveedores" @%func:querystring_activa;dashboard_proveedores;activo;;%@ >Dashboards</a></div>
@%end-if:%@
