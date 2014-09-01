
<div class="barraoscurai"><div class="titsuperior">&gt; Confirmer 
@%if:esta_vacio;es_pedido;%@
@%if:esta_vacio;es_factura;%@
     @%set:send_form_to=bo_presupuestos_ventas;%@
     @%if:esta_vacio;es_presupuesto;%@
	Facture Proforma 
     @%else:%@
	Devis 
     @%end-if:%@
 @%else:%@ 
 {{label_invoice}} 
 @%set:send_form_to=bo_facturas_venta;%@
 @%end-if:%@ 
@%else:%@ 
Commande 
@%set:send_form_to=bo_pedidos_ventas;%@
@%end-if:%@ 
</div></div>

<form name="hacer_pedido" method="post" action="?seccion=@%get:send_form_to;%@">
@%if:esta_vacio;es_pedido%@
@%else:%@
 <div class="barraoscurai"> <input type="checkbox" name="pedido_tipo" value="1" /> Consolider Commande type </div>
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
 <li><a href="#" onclick="return sendForm('hacer_pedido');" class="guardar" ><img src="imag/pixel.png" class="icono" /><span>Accepter</span></a>
 </ul>
 </div>

