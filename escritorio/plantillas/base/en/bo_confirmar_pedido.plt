@%where:nodb|nodb_order_data;nombre|basedocumento;%@

<div class="tituloseccion">&gt; Confirm 

@%if:esta_vacio;es_pedido;%@

 @%if:esta_vacio;es_factura;%@

     @%if:esta_vacio;es_presupuesto;%@
	@%if:esta_vacio;es_albaran;%@
		Proforma Invoice 
	@%else:%@
		Delivery note 
	@%end-if:%@
     @%else:%@
	Budget 
     @%end-if:%@

 @%else:%@ 

     @%if:esta_vacio;factura_abono;%@
 	Invoices 
     @%else:%@
     	Installment Invoice
     @%end-if:%@

 @%end-if:%@ 

@%else:%@ 
Order 
@%end-if:%@ 
</div>

<b>Se enviara a</b>: @%get:send_form_to;%@
<form name="hacer_pedido" method="post" action="?seccion=@%get:send_form_to;%@">
<input type="hidden" name="accion_ejecutar" value="ConfirmarDocumentoValorado" />
@%if:!esta_vacio;es_pedido%@
 @%if:AllowedAction;Pedidos_tipo_cliente;new;%@
 <div class="barraoscurai"><input type="checkbox" name="pedido_tipo" value="1"> Standard order </div>
 @%end-if:%@
@%end-if:%@ 

@%plt:Datos_Generales;%@

@%plt:Datos_Pedido;%@

@%plt:Detalle_Pedido;%@

@%plt:Impuestos_Descuentos_Pedido;%@

@%plt:Totales_Pedido;%@

<input type="hidden" name="Confirmar" value="Confirmar">
</form>

<div class="AccionesEnvio"><ul>
<li><a href="#" onclick="return sendForm('hacer_pedido');" class="guardar" ><img src="images/pixel.png" class="icono" /><span>Confirm</span></a></li>
</ul></div>

