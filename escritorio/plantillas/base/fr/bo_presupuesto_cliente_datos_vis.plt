@%where:nodb|nodb_order_data;nombre|general;%@

<fieldset id="Presupuesto_Cliente_Datosgenerales" class="fsficha" >
<legend>Budget</legend>

<table class="full">
<tr>
<td class="etiqueta">Référence:</td>
<td>@%db:referencia;%@</td>
<td class="etiqueta">Réf. Ext:</td>
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
<td class="etiqueta">Commandes:</td>
<td>
<!-- @%set:idpre=id_presupuesto;%@ -->
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
<td>@%db:colocar_fecha{fecha};%@</td>
</tr>
<tr>
<td class="etiqueta">Modalité de paiment:</td>
<td>@%db:nombre_forma_pago;%@</td>
<td class="etiqueta">Réalisé par:</td>
<td>@%db:nombre_agente;%@</td>
</tr>

<tr>
<td class="etiqueta">Observationes:</td>
<td colspan="3">@%db:reemplazar_salto{observaciones};%@</td>
</tr>
</table>

</fieldset>

