
<div class="barraoscurai"><div class="titsuperior">&gt; Confirmar 
@%if:esta_vacio;es_pedido;%@
@%if:esta_vacio;es_factura;%@
     @%set:send_form_to=bo_presupuestos_ventas;%@
     @%if:esta_vacio;es_presupuesto;%@
	Factura Pró-forma 
     @%else:%@
	Orçamento 
     @%end-if:%@
 @%else:%@ 
 {{label_invoice}} 
 @%set:send_form_to=bo_facturas_venta;%@
 @%end-if:%@ 
@%else:%@ 
Encomenda 
@%set:send_form_to=bo_pedidos_ventas;%@
@%end-if:%@ 
</div></div>

<form name="hacer_pedido" method="post" action="?seccion=@%get:send_form_to;%@">
@%if:esta_vacio;es_pedido%@
@%else:%@
 <div class="barraoscurai"> <input type="checkbox" name="pedido_tipo" value="1" /> Converter em Encomenda Padrão </div>
@%end-if:%@ 

@%plt:Datos_Generales;%@

@%plt:Datos_Pedido;%@

@%plt:Detalle_Pedido;%@

@%plt:Impuestos_Descuentos_Pedido;%@

@%plt:Totales_Pedido;%@

 <input type="hidden" name="Confirmar" value="Confirmar" />
 </form>

 <div class="AccionesEnvio">
 <ul>
 <li><a href="#" onclick="return sendForm('hacer_pedido');" class="guardar" ><img src="imag/pixel.png" class="icono" /><span>Confirmar</span></a>
 </ul>
 </div>

