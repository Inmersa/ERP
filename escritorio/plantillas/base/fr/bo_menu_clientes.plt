
@%if:AllowedLink;modif_clientes;%@
<div class="menuitem"> <a href="?seccion=modif_clientes" @%func:querystring_activa;modif_clientes;activo;;%@ >Donnée général</a></div>
@%end-if:%@
@%if:AllowedLink;cliente_notas;%@
<div class="menuitem"><a href="?seccion=cliente_notas" @%func:querystring_activa;cliente_notas;activo;;%@ >Notes de Client</a></div>
@%end-if:%@
@%if:AllowedLink;cliente_servicios;%@
<div class="menuitem"><a href="?seccion=cliente_servicios" @%func:querystring_activa;cliente_servicios;activo;;%@ >Services de Client</a></div>
@%end-if:%@
@%if:AllowedLink;bo_pedidos_tipo_cliente;%@
<div class="menuitem"> <a href="?seccion=bo_pedidos_tipo_cliente" @%func:querystring_activa;bo_pedidos_tipo_cliente;activo;;%@ >Commande type</a></div>
@%end-if:%@

@%if:esta_vacio;LinkCRM;%@
@%else:%@
	@%if:AllowedLink;incidencias;%@
	<div class="menuitem"><a href="?seccion=incidencias" @%func:querystring_activa;incidencias;activo;;%@ >Incidences</a></div>
	@%end-if:%@
	@%if:AllowedLink;rfqs;%@
	<div class="menuitem"><a href="?seccion=rfqs" @%func:querystring_activa;rfqs;activo;;%@ >RFQ´s</a></div>
	@%end-if:%@
@%end-if:%@

@%if:AllowedLink;bo_facturas_cliente;%@
<div class="menuitem"> <a href="?seccion=bo_facturas_cliente" @%func:querystring_activa;bo_facturas_cliente;activo;;%@ >Historique de factures</a></div>
@%end-if:%@
@%if:AllowedLink;bo_pedidos_cliente;%@
<div class="menuitem"> <a href="?seccion=bo_pedidos_cliente" @%func:querystring_activa;bo_pedidos_cliente;activo;;%@ >Historique de commandes</a></div>
@%end-if:%@
@%if:AllowedLink;bo_proformas_cliente;%@
<div class="menuitem"><a href="?seccion=bo_proformas_cliente" @%func:querystring_activa;bo_proformas_cliente;activo;;%@ >Historique de Factures Proforma</a></div>
@%end-if:%@
@%if:AllowedLink;bo_presupuestos_cliente;%@
<div class="menuitem"><a href="?seccion=bo_presupuestos_cliente" @%func:querystring_activa;bo_presupuestos_cliente;activo;;%@ >Histor. Devis</a></div>
@%end-if:%@

@%if:AllowedLink;bo_rappel_cliente;%@
<div class="menuitem"> <a href="?seccion=bo_rappel_cliente" @%func:querystring_activa;bo_rappel_cliente;activo;;%@ >Rappel annuel</a></div>
@%end-if:%@
@%if:AllowedLink;bo_descuento_familia_articulos;%@
<div class="menuitem"> <a href="?seccion=bo_descuento_familia_articulos" @%func:querystring_activa;bo_descuento_familia_articulos;activo;;%@ >Réductión pour famille</a></div>
@%end-if:%@
@%if:AllowedLink;bo_descuento_articulos;%@
<div class="menuitem"><a href="?seccion=bo_descuento_articulos" @%func:querystring_activa;bo_descuento_articulos;activo;;%@ >Articles de Client</a></div>
@%end-if:%@
@%if:AllowedLink;dashboard_clientes;%@
<div class="menuitem"><a href="?seccion=dashboard_clientes" @%func:querystring_activa;dashboard_clientes;activo;;%@ >Dashboards</a></div>
@%end-if:%@

@%if:esta_vacio;LinkCRM;%@
@%else:%@
	@%if:AllowedAction;RFQ;new;%@
	<div class="menuitem"><a href="?seccion=rfq&nuevo=1" @%func:querystring_activa;rfq&nuevo=1;activo;;%@ >Nouveau RFQ</a></div>
	@%end-if:%@
@%end-if:%@

@%if:AllowedLink;hacer_pedido;%@
	@%if:AllowedAction;Presupuestos;new;%@
	<div class="menuitem"><a href="?seccion=hacer_pedido&presupuesto=1&nuevo=1&_chgsm=1" @%func:querystring_activa;hacer_pedido&presupuesto=1;activo;;%@ 
		>Passer une commande</a></div>
	@%end-if:%@
	@%if:AllowedAction;Pedidos;new;%@
	<div class="menuitem"> <a href="?seccion=hacer_pedido&pedido=1&nuevo=1&_chgsm=1" @%func:querystring_activa;hacer_pedido&pedido=1;activo;;%@ 
		>Passer une commande</a></div>
	@%end-if:%@
	@%if:AllowedAction;Facturas;new;%@
	<div class="menuitem"> <a href="?seccion=hacer_pedido&factura=1&nuevo=1&_chgsm=1" @%func:querystring_activa;hacer_pedido&factura=1;activo;;%@ 
		>Passer une commande</a></div>
	@%end-if:%@
	@%if:AllowedAction;Albaranes;new;%@
	<div class="menuitem"><a href="?seccion=cliente_notarecogida&_chgsm=1" @%func:querystring_activa;cliente_notarecogida;activo;;%@ 
		>{{acc_recoger_o_abonar}}</a></div>
	@%end-if:%@
@%end-if:%@

