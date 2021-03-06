@%where:nodb|nodb_order_data;nombre|general;%@

<fieldset id="Presupuesto_Cliente_Datosgenerales" class="fsficha" >
<legend>Budget</legend>

<table class="full">
<tr>
<td class="etiqueta">Reference:</td>
<td>@%db:referencia;%@</td>
<td class="etiqueta">Ext. Ref.:</td>
<td >
 @%if:nomodificar_detalles;%@
 @%db:referencia_externa;%@
 @%else:%@
 <input type="hidden" name="pedido[referencia_externa_old]" value="@%db:referencia_externa;%@" />
 <input type="text" name="pedido[referencia_externa]" size="20" value="@%db:referencia_externa;%@" />
 @%end-if:%@
 </td>
</tr>
<tr>
<td class="etiqueta">Orders:</td>
<td> <!-- @%set:idpre=id_presupuesto;%@ -->
 @%where:tabla|Pedidos;where|Pedidos.id_presupuesto = $idpre;%@
 @%if:primera_vez;%@
@%else:%@
,
@%end-if:%@ 
@%if:AllowedLink;bo_pedido_cliente;%@
<a href="?seccion=bo_pedido_cliente&id_pedido=@%db:Pedidos.id_pedido;%@">@%db:Pedidos.referencia;%@</a>
@%else:%@
@%db:Pedidos.referencia;%@
@%end-if:%@
 @%end-where:%@
 
</td>
<td class="etiqueta">Date:</td>
<td>
 @%if:nomodificar_detalles;%@
 @%db:colocar_fecha{fecha};%@
 @%else:%@
 <input type="hidden" name="pedido[fecha_old]" value="@%db:colocar_fecha{fecha};%@" />
 <input type="text" name="pedido[fecha]" size="13" value="@%db:colocar_fecha{fecha};%@" maxlength="10" />
 @%end-if:%@
</td>
</tr>
<tr>
<td class="etiqueta">Payment Rules:</td>
<td>
 @%if:nomodificar_detalles;%@
@%db:nombre_forma_pago;%@
 @%else:%@
@%set:_selected_value=id_forma_pago;%@
<select name="pedido[id_forma_pago]">
@%where:tabla|Forma_pago;nolink|1;%@ 
<option value="@%db:Forma_pago.id_forma_pago;%@" 
@%db:selected_value{Forma_pago.id_forma_pago}%@
>@%db:Forma_pago.nombre;%@</option>
 @%end-where:%@

 </select>
 @%end-if:%@
</td>
 <!-- @%set:_selected_value=id_agente%@ -->
<td class="etiqueta">Done by:</td>
<td>
@%if:nomodificar_detalles;%@
@%db:nombre_agente;%@
@%else:%@
 <select name="pedido[id_agente]">
 @%where:tabla|Agentes;order|nombre;where|Agentes.id_empresa = $id_empresa;nolink|1;%@
 <option value="@%db:Agentes.id_agente%@"
 @%db:selected_value{Agentes.id_agente}%@
>@%db:Agentes.nombre;%@ @%db:Agentes.apellidos;%@</option>
 @%end-where:%@

</select>
@%end-if:%@
</td>
</tr>

<tr>
<td class="etiqueta">Remarks:</td>
<td colspan="3">
@%if:nomodificar_detalles;%@
@%db:reemplazar_salto{observaciones};%@
@%else:%@
<textarea name="pedido[observaciones]" rows="5" cols="80" >@%db:observaciones;%@</textarea>
@%end-if:%@
</td>
</tr>
</table>

</fieldset>

