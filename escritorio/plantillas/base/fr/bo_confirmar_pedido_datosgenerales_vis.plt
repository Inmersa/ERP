@%where:nodb|nodb_order_data;nombre|datos;%@
@%set:observaciones_en_totales=observaciones;%@

<fieldset id="Pedido_Cliente_Datos_Generales" class="fsficha">
<legend>Conditions de commande</legend>
<table class="full">
<tr>
<td class="etiqueta">R�f�rence:</td>
<td> @%db:referencia;%@</td>
<td class="etiqueta">R�f. Externe:</td>
<td><input type="text" name="registro[referencia_externa]" size="20" value="@%db:referencia_externa;%@" /></td>
</tr>

<tr>
<td class="etiqueta">Nom document :</td>
<td><input type="text" name="registro[nombre]" size="25" value="@%db:nombre%@" >
</td>

<td class="etiqueta">R�alis� par:</td>
<td>@%db:nombre_agente;%@</td>
</tr>
<tr>
<td class="etiqueta">Date:</td>
<td>@%db:colocar_fecha_hora{fecha};%@</td>
<td class="etiqueta">Modalit� de paiment:</td>
<td>@%db:nombre_forma_pago;%@</td>
</tr>
<tr>
<td class="etiqueta">Devise:</td>
<td>
@%where:nodb|nodb_currency_data;%@
@%db:nombre_divisa;%@ 
@%end-where:%@

</td>
@%if:esta_vacio;es_pedido%@
<td colspan="2"></td>
@%else:%@
<td class="etiqueta">Direction remise:</td>
<td>
	 @%set:_selected_value=id_direccion;%@
	<select name="registro[id_direccion]">
	@%where:tabla|Direcciones_entrega;where|Direcciones_entrega.id_cliente = $id_cliente_promocion;%@
	<option value="@%db:Direcciones_entrega.id_direccion;%@"
	@%db:selected_value{Direcciones_entrega.id_direccion}%@
	>@%db:Direcciones_entrega.nombre;%@ @%db:Direcciones_entrega.direccion;%@</option>
	 @%end-where:%@

	</select>
</td>
@%end-if:%@

</tr>
<td class="etiqueta">Notes</td>
<td colspan="3"><textarea name="registro[observaciones]" cols="100" wrap="VIRTUAL" rows="4">@%db:observaciones;%@</textarea></td>
</table>

</fieldset>
