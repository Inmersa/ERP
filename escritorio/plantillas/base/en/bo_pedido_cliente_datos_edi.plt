@%where:nodb|nodb_order_data;nombre|datos;format_name|classDocument;%@

<fieldset id="Pedido_Cliente_Datos_Generales" class="fsficha">
<legend>Order Conditions</legend>
<table class="full">
<tr>
<td class="etiqueta">External Ref.:</td>
<td>
 <input type="text" name="pedido[referencia_externa]" size="20" value="@%db:referencia_externa;%@" /></td>

@%if:!esta_vacio;id_pedido_incompleto%@
<td class="etiqueta">Residual Order:</td><td>
@%set:id_ped_in=id_pedido_incompleto;%@
@%where:tabla|Pedidos;where|id_pedido = $id_ped_in;%@
<a href="?seccion=bo_pedido_cliente&id_pedido=@%db:Pedidos.id_pedido;%@">@%db:Pedidos.referencia;%@</a>
@%end-where:%@

@%else:%@
@%set:id_ped=id_pedido;%@
<td class="etiqueta">Incomplete:</td><td>
@%where:tabla|Pedidos;where|id_pedido_incompleto = $id_ped;%@
<a href="?seccion=bo_pedido_cliente&id_pedido=@%db:Pedidos.id_pedido;%@">@%db:Pedidos.referencia;%@</a>
@%end-where:%@

@%end-if:%@
</td>
</tr>

<tr>
<td class="etiqueta">Reference:</td>
<td> @%db:referencia;%@</td>
<td class="etiqueta @%css:agente;label;%@">Done by:</td>
<td class="@%css:agente;%@" >
 <!-- @%db:id_agente%@ @%set:_selected_value=id_agente%@ -->
 <select name="pedido[id_agente]">
 @%where:tabla|Agentes;order|nombre;where|Agentes.id_empresa = $id_empresa;nolink|1;%@
 <option value="@%db:Agentes.id_agente%@"
 @%db:selected_value{Agentes.id_agente}%@
>@%db:Agentes.nombre;%@ @%db:Agentes.apellidos;%@</option>
 @%end-where:%@

</select></td>
</tr>
<tr>
<td class="etiqueta">Date:</td>
<td><input type="text" name="pedido[fecha]" maxlength="24" size="15"
 value="@%db:colocar_fecha_hora{fecha};%@" /></td>
<td class="etiqueta">Payment Rules:</td>
<td>
@%set:_selected_value=id_forma_pago%@
<select name="pedido[id_forma_pago]">
@%where:tabla|Forma_pago;nolink|1;%@ 
<option value="@%db:Forma_pago.id_forma_pago;%@" @%db:selected_value{Forma_pago.id_forma_pago}%@
>@%db:Forma_pago.nombre;%@</option>
 @%end-where:%@

</select></td>
</tr>
<tr>
<td class="etiqueta">Currency:</td>
 @%where:nodb|nodb_currency_data;%@
<td>@%db:nombre_divisa;%@ 
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

