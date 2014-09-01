@%where:nodb|nodb_order_data;nombre|datos;%@

<fieldset id="Pedido_Cliente_Datos_Generales" class="fsficha">
<legend>Order Conditions</legend>
<table class="full">
<tr>
<td class="etiqueta">External Ref.:</td>
<td><input type="text" name="pedido[referencia_externa]" size="20" value="@%db:referencia_externa;%@" /></td>
<td class="etiqueta">Incomplete:</td>
<td>
@%if:esta_vacio;id_pedido_incompleto%@
@%else:%@
<a href="?seccion=bo_pedido_cliente&id_pedido=@%db:id_pedido_incompleto;%@"> To see </a>
@%end-if:%@
</td>
</tr>
<tr>
<td class="etiqueta">Reference:</td>
<td> @%db:referencia;%@</td>
<td class="etiqueta">Done by:</td>
<td>@%db:nombre_agente;%@</td>
</tr>
<tr>
<td class="etiqueta">Date:</td>
<td>@%db:colocar_fecha_hora{fecha};%@</td>
<td class="etiqueta">Payment Rules:</td>
<td>@%db:nombre_forma_pago;%@</td>
</tr>
<tr>
<td class="etiqueta">Currency:</td>
<td>
 @%where:nodb|nodb_currency_data;%@
@%db:nombre_divisa;%@ 
@%end-where:%@

</td>
<td class="etiqueta">Delivery Add.:</td>
<td>
 @%set:_selected_value=id_direccion;%@
<select name="pedido[id_direccion]">
@%where:tabla|Direcciones_entrega;where|Direcciones_entrega.id_cliente = $id_cliente_promocion;%@
<option value="@%db:Direcciones_entrega.id_direccion;%@"
@%db:selected_value{Direcciones_entrega.id_direccion}%@
>@%db:Direcciones_entrega.nombre;%@ @%db:Direcciones_entrega.direccion;%@</option>
 @%end-where:%@

</select></td>
</tr>
<tr><td class="etiqueta">Notes</td>
<td colspan="3"><textarea name="pedido[observaciones]" cols="80" wrap="VIRTUAL" rows="4">@%db:observaciones;%@</textarea></td>
</tr>
</table>

</fieldset>
