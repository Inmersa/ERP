@%where:nodb|nodb_order_data;nombre|totales;format_name|classDocument;%@
<fieldset id="Pedido_Proveedor_Totales" class="fsficha">
<legend>Totales</legend>

<table class="fullstruct"><tr><td>
<table class="full">
<tr>
<td class="caption">Base imponible</td>
<td class="caption">%</td>
<td class="caption">IVA/IGIC</td>
<td class="caption">R. equiv.</td>
</tr>
 @%where:nodb|nodb_taxes_detail;%@
<tr>
<td>@%db:base_imponible;%@</td>
<td>@%db:porcentaje;%@ / @%db:porcentaje_recargo_equivalente%@ %</td>
<td>@%db:recargo_iva;%@</td>
<td>@%db:recargo_equivalente;%@</td>
</tr>
@%end-where:%@

 </table>
</td><td>
<table class="full">
<tr>
<td class="caption">T. Bruto</td>
<td class="caption">%</td>
<td class="caption">Importe</td>
</tr>
 @%where:nodb|nodb_discounts_detail;%@
<tr>
<td>@%db:base_imponible;%@</td>
<td>@%db:nombre%@ @%db:descuento%@ %</td>
<td>@%db:importe;%@ </td>
</tr>
 @%end-where:%@

</table>
</td></tr>
</table>
<!-- @%set:notas=observaciones;%@ -->
 @%where:nodb|nodb_order_totals;%@
<table class="fullstruct">
<tr><td>
<table class="full">
<tr>
<td class="etiqueta">T. Bruto:</td>
<td>@%db:bruto;%@</td>
</tr>
<tr>
<td class="etiqueta">Total descuento:</td>
<td>
 @%db:descuentos%@</td>
 </tr>
<tr><td class="etiqueta">T.B. Imponible:</td>
<td>
 @%db:base_imponible;%@ </td>
 </tr>
<tr><td class="etiqueta">T. Impuestos:</td>
<td>
 @%db:total_impuestos%@ </td>
 </tr>
<tr><td class="etiqueta">Retenci�n:</td>
<td>
 @%db:retenido%@ </td>
</tr>
</table>
</td><td>
<table class="full">
<tr><td class="caption">Notas:</td></tr>
<tr><td><!-- Notas del pedido --><textarea name="pedido[observaciones]" cols="70" wrap="VIRTUAL" rows="4">@%get:notas;%@</textarea></td></tr>
</table>
</td><td>
<table class="full">
<tr>
<td class="etiqueta">Importe Total</td>
<td>@%db:importe;%@ @%db:leyenda_divisa%@</td>
</tr>
</table>
@%if:esta_vacio;divisa_cliente_importe%@
@%else:%@
<br><br>
<table class="full">
<tr><td class="etiqueta">Importe en @%db:divisa_cliente_nombre%@</td>
</tr>
<tr>
<td> @%db:divisa_cliente_importe;%@ @%db:divisa_cliente_leyenda%@</td>
</tr>
</table>
@%end-if:%@
</td></tr></table>
@%end-where:%@

<div class="AccionesEnvio">
<ul>
@%if:hay_factura%@
 <li><a href="?seccion=bo_facturas_pedido_compra&id_pedido=@%db:id_pedido;%@" class="verfras" ><img src="images/pixel.png" class="icono" /><span>Ver facturas</span></a></li>
@%else:%@
 <li><a href="#" onclick="return sendForm('pedido');" class="guardar" ><img src="images/pixel.png" class="icono" /><span>Guardar Cambios</span></a></li>
@%end-if:%@

@%if:hay_albaran%@
 <li><a href="?seccion=bo_albaranes_pedido&id_pedido=@%db:id_pedido;%@" class="veralbs" ><img src="images/pixel.png" class="icono" /><span>Ver Albaranes</span></a></li>
@%else:%@
@%end-if:%@
</ul>
</div>

</fieldset>

