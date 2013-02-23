@%where:nodb|nodb_order_data;nombre|datos;%@
@%set:observaciones_en_totales=observaciones;%@

<fieldset id="Pedido_Cliente_Datos_Generales" class="fsficha">
<legend>Order Conditions</legend>
<table class="full">
<tr>
<td class="etiqueta">Reference:</td>
<td> @%db:referencia;%@</td>
<td class="etiqueta">External Ref.:</td>
<td><input type="text" name="registro[referencia_externa]" size="20" value="@%db:referencia_externa;%@" /></td>
</tr>

<tr>
<td class="etiqueta">Document name :</td>
<td><input type="text" name="registro[nombre]" size="25" value="@%db:nombre%@" >
</td>

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
@%if:esta_vacio;es_pedido%@
<td colspan="2"></td>
@%else:%@
<td class="etiqueta">Delivery Add.:</td>
<td>
	 @%set:_selected_value=id_almacen;%@
	<select name="registro[id_direccion]">
	@%where:tabla|Almacenes;where|Almacenes.id_empresa = $id_empresa;order|nombre asc;%@
	<option value="@%db:Almacenes.id_almacen;%@"
	@%db:selected_value{Almacenes.id_almacen}%@
	>@%db:Almacenes.nombre;%@ @%db:Almacenes.direccion;%@</option>
	 @%end-where:%@

	</select>
</td>
@%end-if:%@

</tr>
<td class="etiqueta">Notes</td>
<td colspan="3"><textarea name="registro[observaciones]" cols="100" wrap="VIRTUAL" rows="4">@%db:observaciones;%@</textarea></td>
</table>

</fieldset>
