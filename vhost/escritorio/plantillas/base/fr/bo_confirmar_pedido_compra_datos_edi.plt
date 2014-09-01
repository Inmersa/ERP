@%where:nodb|nodb_order_data;nombre|datos;%@
@%set:observaciones_en_totales=observaciones;%@

<fieldset id="Pedido_Cliente_Datos_Generales" class="fsficha">
<legend>Conditions de commande</legend>
<table class="full">
<tr>
<td class="etiqueta">Référence:</td>
<td> @%db:referencia;%@</td>
<td class="etiqueta">Réf. Externe:</td>
<td><input type="text" name="registro[referencia_externa]" size="20" value="@%db:referencia_externa;%@" /></td>
</tr>

<tr>
<td class="etiqueta">Nom document :</td>
<td><input type="text" name="registro[nombre]" size="25" value="@%db:nombre%@" >
</td>

@%if:esta_vacio;es_albaran;%@
<td class="etiqueta">Réalisé par:</td>
<td>
 <!--
 @%db:id_agente%@
 @%set:_selected_value=id_agente%@
 -->
 <select name="agente">
 @%where:tabla|Agentes;order|nombre;where|Agentes.id_empresa = $id_empresa;nolink|1;%@
 <option value="@%db:Agentes.id_agente%@"
 @%db:selected_value{Agentes.id_agente}%@
>@%db:Agentes.nombre;%@ @%db:Agentes.apellidos;%@</option>
 @%end-where:%@

</select></td>
@%else:%@
<td class="etiqueta">Transporteurs:</td>
<td>
 <!--
 @%db:id_transportista;%@
 @%set:_selected_value=id_transportista;value|var;%@
 -->
 <select name="id_transportista">
 @%where:tabla|Transportistas;order|nombre;nolink|1;%@
 <option value="@%db:Transportistas.id_transportista;%@"
 @%db:selected_value{Transportistas.id_transportista;}%@
>@%db:Transportistas.razon_social;;%@ (@%db:Transportistas.nombre;%@)</option>
 @%end-where:%@

</select></td>
@%end-if:%@

</tr>
<tr>
<td class="etiqueta">Date:</td>
<td><input type="text" name="registro[fecha]" maxlength="24" size="18"
 value="@%db:colocar_fecha_hora{fecha};%@" /></td>
<td class="etiqueta">Modalité de paiment:</td>
<td>
@%set:_selected_value=id_forma_pago%@
<select name="forma_pago" >
@%where:tabla|Forma_pago;nolink|1;%@ 
<option value="@%db:Forma_pago.id_forma_pago;%@" @%db:selected_value{Forma_pago.id_forma_pago}%@
>@%db:Forma_pago.nombre;%@</option>
 @%end-where:%@

</select></td>
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
