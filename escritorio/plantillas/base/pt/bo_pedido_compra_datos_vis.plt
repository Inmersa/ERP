@%where:nodb|nodb_order_data;nombre|datos;%@

<fieldset id="Pedido_Cliente_Datos_Generales" class="fsficha">
<legend>Dados da Encomenda</legend>
<table class="full">
<tr>
<td class="etiqueta">Refer�ncia Externa:</td>
<td><input type="text" name="pedido[referencia_externa]" size="20" value="@%db:referencia_externa;%@" /></td>
<td class="etiqueta">Incompleto:</td>
<td>
@%if:esta_vacio;id_pedido_incompleto%@
@%else:%@
<a href="?seccion=bo_pedido_cliente&id_pedido=@%db:id_pedido_incompleto;%@"> Ver </a>
@%end-if:%@
</td>
</tr>
<tr>
<td class="etiqueta">Refer�ncia:</td>
<td> @%db:referencia;%@</td>
<td class="etiqueta">Feito por:</td>
<td>@%db:nombre_agente;%@</td>
</tr>
<tr>
<td class="etiqueta">Data:</td>
<td>@%db:colocar_fecha_hora{fecha};%@</td>
<td class="etiqueta">M�todo de Pagamento:</td>
<td>@%db:nombre_forma_pago;%@</td>
</tr>
<tr>
<td class="etiqueta">Divisa:</td>
<td>
 @%where:nodb|nodb_currency_data;%@
@%db:nombre_divisa;%@ 
@%end-where:%@

</td>
<td class="etiqueta">Endere�o de Entrega:</td>
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
<tr><td class="etiqueta">Notas</td>
<td colspan="3"><textarea name="pedido[observaciones]" cols="80" wrap="VIRTUAL" rows="4">@%db:observaciones;%@</textarea></td>
</tr>
</table>

</fieldset>
