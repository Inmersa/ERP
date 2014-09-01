@%where:Albaranes;where|id_albaran = $id_albaran;%@
<!-- @%db:Albaranes.id_albaran;%@ @%db:Pedidos.id_direccion;%@ -->
<fieldset id="DatosAlbaran" class="fsficha">
<legend>Delivery Conditions</legend>
<table class="full">
<tr>
<td class="etiqueta" colspan="2">Reference:</td>
<td colspan="2">@%db:Albaranes.referencia;%@</td>
<td class="etiqueta" colspan="2">Warehouse:</td>
<td colspan="2">@%db:Almacenes.nombre;%@</td>
</tr>
<tr>
<td class="etiqueta" colspan="2">Order Ref.:</td>
<td colspan="2">
@%if:esta_vacio;Pedidos.id_direccion;%@
<a href="?seccion=bo_pedido_proveedor&id_pedido=@%db:Pedidos.id_pedido;%@">@%db:Pedidos.referencia;%@</a>
@%else:%@
<a href="?seccion=bo_pedido_cliente&id_pedido=@%db:Pedidos.id_pedido;%@">@%db:Pedidos.referencia;%@</a>
@%end-if:%@
</td>
<td class="etiqueta" colspan="2">Packages:</td>
<td  colspan="2">@%db:Albaranes.bultos;%@</td>
</tr>
<tr><td class="etiqueta" colspan="2">Remarks:</td>
<td colspan="6" >@%db:reemplazar_salto{Albaranes.observaciones};%@</td> 
</tr>
<tr><td class="etiqueta" colspan="2">Date:</td>
<td>@%db:colocar_fecha{Albaranes.fecha};%@</td>
<td class="etiqueta" colspan="2">Carrier:</td>
<td colspan="3"><!-- @%db:Albaranes.id_transportista;%@ -->
@%where:tabla|Transportistas;nombre|transporte;%@
@%db:Transportistas.nombre;%@
@%end-where:%@

</td></tr>

<tr>
<td class="titulotb" colspan="8">Condition </td>
</tr>
<tr>
<td class="etiqueta">Rd</td>
<td class="check">@%db:si_no_flag{Albaranes.preparado}%@</td>
<td class="etiqueta">S</td>
<td class="check">@%db:si_no_flag{Albaranes.enviado}%@</td>
<td class="etiqueta">C</td>
<td class="check">@%db:si_no_flag{Albaranes.confirmacion}%@</td>
<td class="etiqueta">R</td>
<td class="check">@%db:si_no_flag{Albaranes.devolucion}%@</td>
</tr>
</table>
</fieldset>

