

@%if:AllowedLink;bo_facturas_venta;%@
<div class="menuitem"> <a href="?seccion=bo_facturas_venta" @%func:querystring_activa;bo_facturas_venta;activo;;%@ >Invoices</a></div>
@%end-if:%@
@%if:AllowedLink;bo_pedidos_ventas;%@
<div class="menuitem"> <a href="?seccion=bo_pedidos_ventas" @%func:querystring_activa;bo_pedidos_ventas;activo;;%@ >Orders</a></div>
@%end-if:%@
@%if:AllowedLink;bo_proformas_venta;%@
<div class="menuitem"><a href="?seccion=bo_proformas_venta" @%func:querystring_activa;bo_proformas_venta;activo;;%@ >Proforma Invoices</a></div>
@%end-if:%@
@%if:AllowedLink;bo_presupuestos_ventas;%@
<div class="menuitem"> <a href="?seccion=bo_presupuestos_ventas&_chgsm=1" @%func:querystring_activa;bo_presupuestos_ventas&_chgsm=1;activo;;%@ >Budgets</a></div>
@%end-if:%@
@%if:AllowedLink;bo_albaranes_venta;%@
<div class="menuitem"> <a href="?seccion=bo_albaranes_venta" @%func:querystring_activa;bo_albaranes_venta;activo;;%@ >Delivery notes</a></div>
@%end-if:%@
@%if:AllowedLink;dashboard_ventas;%@
<div class="menuitem"> <a href="?seccion=dashboard_ventas" @%func:querystring_activa;dashboard_ventas;activo;;%@ >Dashboards</a></div>
@%end-if:%@
<!--
@%if:AllowedLink;bo_facturas_venta;%@
<div class="menuitem"> <a href="?seccion=bo_compra_venta" @%func:querystring_activa;nuevo_pedidos_ventas&presupuesto=1;activo;;%@ >Reports</a></div>
@%end-if:%@
-->

@%if:AllowedLink;nuevo_pedidos_ventas;%@
   <div class="menuitem"> <a href="?seccion=nuevo_pedidos_ventas&proforma=1&nuevo=1&_chgsm=1" 
   @%func:querystring_activa;nuevo_pedidos_ventas&proforma=1;activo;;%@ >New Proforma Invoice</a></div>
   <div class="menuitem"> <a href="?seccion=nuevo_pedidos_ventas&presupuesto=1&nuevo=1&_chgsm=1" 
   @%func:querystring_activa;nuevo_pedidos_ventas&presupuesto=1;activo;;%@ >New Budget</a></div>
   <div class="menuitem"> <a href="?seccion=nuevo_pedidos_ventas&pedido=1&nuevo=1&_chgsm=1" 
   @%func:querystring_activa;nuevo_pedidos_ventas&pedido=1;activo;;%@  >Make order</a></div>
   <div class="menuitem"> <a href="?seccion=nuevo_pedidos_ventas&factura=1&nuevo=1&_chgsm=1" 
   @%func:querystring_activa;nuevo_pedidos_ventas&factura=1;activo;;%@  >Make invoice</a></div>
   <div class="menuitem"> <a href="?seccion=nuevo_pedidos_ventas&albaran=1&nuevo=1&_chgsm=1" 
   @%func:querystring_activa;nuevo_pedidos_ventas&albaran=1;activo;;%@  >{{acc_haceralbaran}}</a></div>
   @%if:AllowedAction;Albaranes;new;%@
	<div class="menuitem"><a href="#" onClick="return sendForm('notarecogida');" >{{acc_recoger_o_abonar}}</a></div>
	@%end-if:%@
@%end-if:%@
<form name="notarecogida" action="?seccion=bo_clientes" method="post" />
<input type="hidden" name="seleccion_multiple[0][entidad]" value="Clientes" />
<input type="hidden" name="seleccion_multiple[1][entidad]" value="Articulos" />
<input type="hidden" name="seleccion_multiple[1][varios]" value="1" />
<input type="hidden" name="target" value="cliente_notarecogida" />
<input type="hidden" name="modo_seleccion" value="1" />
</form>

