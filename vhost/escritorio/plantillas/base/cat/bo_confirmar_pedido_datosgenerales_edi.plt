@%where:nodb|nodb_order_data;nombre|datos;%@
@%set:observaciones_en_totales=observaciones;%@

<fieldset id="Pedido_Cliente_Datos_Generales" class="fsficha">
<legend>Condicions de comanda</legend>
<table class="full">
<tr>
<td class="etiqueta">Referència:</td>
<td> @%db:referencia;%@</td>
<td class="etiqueta">Ref. externa:</td>
<td><input type="text" name="registro[referencia_externa]" size="20" value="@%db:referencia_externa;%@" /></td>
</tr>

<tr>
<td class="etiqueta">Nom document :</td>
<td><input type="text" name="registro[nombre]" size="25" value="@%db:nombre%@" >
</td>

@%if:esta_vacio;es_albaran;%@
<td class="etiqueta">Realitzar per:</td>
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
<td class="etiqueta">Transportistes:</td>
<td>
 <!--
 @%db:id_transportista;%@
 @%set:_selected_value=id_transportista;value|var;%@
 -->
 <select name="id_transportista">
 @%where:tabla|Transportistas;order|nombre;nolink|1;%@
 <option value="@%db:Transportistas.id_transportista;%@"
 @%db:selected_value{Transportistas.id_transportista;}%@
>@%db:Transportistas.nombre;;%@ (@%db:Transportistas.razon_social;%@)</option>
 @%end-where:%@

</select></td>
@%end-if:%@


</tr>
<tr>
<td class="etiqueta">Data:</td>
<td><input type="text" name="registro[fecha]" maxlength="24" size="18"
 value="@%db:colocar_fecha_hora{fecha};%@" /></td>

@%if:esta_vacio;es_albaran;%@
<td class="etiqueta">Mig de paga:</td>
<td>
@%set:_selected_value=id_forma_pago%@
<select name="forma_pago" >
@%where:tabla|Forma_pago;nolink|1;%@ 
<option value="@%db:Forma_pago.id_forma_pago;%@" 
@%db:selected_value{Forma_pago.id_forma_pago}%@
>@%db:Forma_pago.nombre;%@</option>
 @%end-where:%@

</select></td>
</tr>
<tr>
<td class="etiqueta">Divisa:</td>
<td>
@%where:nodb|nodb_currency_data;%@
@%db:nombre_divisa;%@ 
@%end-where:%@

</td>
@%end-if:%@

@%if:esta_vacio;es_pedido;es_albaran;%@
<td colspan="2"></td>
@%else:%@
@%where:nodb|nodb_reciever_data;%@
@%set:id_cli = id;value|var;%@
@%end-where:%@

cliente: @%get:id_cli;%@
<td class="etiqueta">Direcció entrega:</td>
<td>
	 @%set:_selected_value=id_direccion;%@
	<select name="registro[id_direccion]">
	@%where:tabla|Direcciones_entrega;where|Direcciones_entrega.id_cliente = $id_cli;%@
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
