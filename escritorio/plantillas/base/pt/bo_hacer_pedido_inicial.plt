@%where:nodb|nodb_order_data;nombre|base;%@

<div class="tituloseccion">&gt; Selecção de Produtos
@%if:!esta_vacio;es_proforma;%@
	De Factura Pró-forma 
@%end-if:%@
@%if:!esta_vacio;es_presupuesto;%@
	De Orçamento 
@%end-if:%@
@%if:!esta_vacio;es_factura;%@
   @%if:!esta_vacio;factura_abono;%@
   	@%set:no_input = 1;%@
   @%end-if:%@
   De Factura
@%end-if:%@
@%if:!esta_vacio;es_pedido;%@
	De Encomenda
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

