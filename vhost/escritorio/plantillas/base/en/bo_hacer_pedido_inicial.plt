@%where:nodb|nodb_order_data;nombre|base;%@

<div class="tituloseccion">&gt; Products Selection
@%if:!esta_vacio;es_proforma;%@
	From Proforma Invoice 
@%end-if:%@
@%if:!esta_vacio;es_presupuesto;%@
	From Budget 
@%end-if:%@
@%if:!esta_vacio;es_factura;%@
   @%if:!esta_vacio;factura_abono;%@
   	@%set:no_input = 1;%@
   @%end-if:%@
   From Invoice
@%end-if:%@
@%if:!esta_vacio;es_pedido;%@
	From Order
@%end-if:%@
@%if:!esta_vacio;es_albaran;%@
	{{label_dealbaran}}
@%end-if:%@

</div>

@%if:esta_vacio;no_input;%@
<div class="buscadorinterior">
@%plt:buscador_descolocao%@
</div>

@%plt:hacer_pedido_inicial%@
@%end-if:%@

@%plt:cesta%@ 

