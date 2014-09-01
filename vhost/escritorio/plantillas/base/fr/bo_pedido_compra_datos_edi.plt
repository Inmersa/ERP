@%where:nodb|nodb_order_data;nombre|datos;%@

<fieldset id="Pedido_Datos_Generales" class="fsficha">
<legend>Conditions de commande</legend>
<table class="full">
<tr>
<td class="etiqueta">Réf. Externe:</td>
<td>
 <input type="text" name="pedido[referencia_externa]" size="20" value="@%db:referencia_externa;%@" /></td>
<td class="etiqueta">Incomplet:</td>
<td>
@%if:esta_vacio;id_pedido_incompleto%@
@%else:%@
<a href="?seccion=bo_pedido_proveedor&id_pedido=@%db:id_pedido_incompleto;%@"> Voir </a>
@%end-if:%@
</td>
</tr>
<tr>
<td class="etiqueta">Référence:</td>
<td> @%db:referencia;%@</td>
<td class="etiqueta">Réalisé par:</td>
<td>
 <!--
 @%db:id_agente%@
 @%set:_selected_value=id_agente%@
 -->
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
<td><input type="text" name="pedido[fecha]" maxlength="24" size="15" value="@%db:colocar_fecha{fecha};%@" /></td>
<td class="etiqueta">Modalité de paiment:</td>
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
<td class="etiqueta">Devise:</td>
<td>
 @%where:nodb|nodb_currency_data;%@
@%db:nombre_divisa;%@ 
@%end-where:%@

</td>
<td class="etiqueta">Direction remise:</td>
<td>
 @%set:_selected_value=id_almacen;%@
<select name="pedido[id_direccion]">
@%where:tabla|Almacenes;where|Almacenes.id_empresa = $id_empresa;%@
<option value="@%db:Almacenes.id_almacen;%@"
@%db:selected_value{Almacenes.id_almacen}%@
>@%db:Almacenes.nombre;%@ @%db:Almacenes.direccion;%@</option>
 @%end-where:%@

</select></td>
</tr>
<tr><td class="etiqueta">Notes</td>
<td colspan="3"><textarea name="pedido[observaciones]" cols="80" wrap="VIRTUAL" rows="4">@%db:observaciones;%@</textarea></td>
</tr>
</table>

</fieldset>
