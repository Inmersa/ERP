@%where:nodb|nodb_order_data;nombre|general;format_name|classDocument;%@

<fieldset id="Factura_Cliente_Datosgenerales" class="fsficha">
<legend>Factura</legend>

<table class="full">
<tr>
<td class="etiqueta">Referência:</td>
<td>@%db:referencia;%@</td>
<td class="etiqueta">Ref. Externa:</td>
<td >
 @%if:emitida;%@
 @%db:referencia_externa;%@
 @%else:%@
 <input type="hidden" name="factura[referencia_externa_old]" value="@%db:referencia_externa;%@" />
 <input type="text" name="factura[referencia_externa]" size="20" value="@%db:referencia_externa;%@" />
 @%end-if:%@
 </td>
</tr>
<tr>
<td class="etiqueta">Encomendas:</td>
<td> <!-- @%set:idfra=id_factura;%@ -->
 @%where:tabla|Pedidos_facturas;where|Pedidos_facturas.id_factura = $idfra;%@
 @%if:!primera_vez;%@
,
@%end-if:%@ 
<!-- @%db:Pedidos_facturas.id_factura;%@ @%db:Pedidos.id_direccion;%@ @%db:Pedidos.id_proveedor;%@ -->
@%if:esta_vacio;Pedidos.id_proveedor;%@
	@%if:AllowedLink;bo_pedido_cliente;%@
	<a href="?seccion=bo_pedido_cliente&id_pedido=@%db:Pedidos.id_pedido;%@">@%db:Pedidos.referencia;%@</a>
	@%else:%@
	@%db:Pedidos.referencia;%@
	@%end-if:%@
@%else:%@
	@%if:AllowedLink;bo_pedido_proveedor;%@
	<a href="?seccion=bo_pedido_proveedor&id_pedido=@%db:Pedidos.id_pedido;%@">@%db:Pedidos.referencia;%@</a>
	@%else:%@
	@%db:Pedidos.referencia;%@
	@%end-if:%@
@%end-if:@
 @%end-where:%@
 
</td>
<td class="etiqueta">Data:</td>
<td>
 @%db:colocar_fecha{fecha};%@
</td>
</tr>
<tr>
<td class="etiqueta">Método de Pagamento:</td>
<td>@%db:nombre_forma_pago;%@</td>
<td class="etiqueta">Série de Facturação:</td>
<td>@%db:nombre_serie_facturacion;%@</td>
</tr>
</table>
</fieldset>
