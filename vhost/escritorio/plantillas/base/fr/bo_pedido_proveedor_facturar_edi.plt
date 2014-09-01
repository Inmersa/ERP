@%where:nodb|nodb_order_data;nombre|consolidar;%@

<fieldset id="Pedido_Proveedor_Generar_Albaranes" class="fsficha">
<legend>Livraison</legend>
 <form name="generar_albaran" action="?seccion=bo_albaranes_compra" method="post">
 <input type="hidden" name="Generar" value="Generar" />
 <input type="hidden" name="identificador_pedido" value="@%db:id_pedido%@" />
<div class="barraoscura"><a href="" onclick="return sendForm('generar_albaran');">G�ner�r</a></div>
<table class="full">
<tr>
<td class="etiqueta">Transporteurs:</td>
<td colspan="2"><select name="id_transportista">
 @%where:tabla|Transportistas;nolink|1;%@
 <option value="@%db:Transportistas.id_transportista;%@">@%db:Transportistas.nombre;%@</option>
 @%end-where:%@

 </select></td>
<td class="etiqueta">R�f. Ext:</td>
<td colspan="2"><input type="text" name="ref_externa" size="16" /></td>
</tr>
<tr>
<td class="etiqueta">Pr�t:</td>
<td><input type="checkbox" name="preparado" value="1" /></td>
<td class="etiqueta">Envoy�:</td>
<td><input type="checkbox" name="enviado" value="1" /></td>
<td class="etiqueta">Confirmation:</td>
<td><input type="checkbox" name="confirmacion" value="1" /></td>
</tr>
</table>
</form>
</fieldset>


<fieldset id="Pedido_Proveedor_Facturar" class="fsficha">
<legend>Formulaires de consolidation</legend>
<form name="generar_factura" action="?seccion=bo_facturas_compra" method="post">
<input type="hidden" name="Generar" value="Generar" />
<input type="hidden" name="identificador_pedido" value="@%db:Pedidos.id_pedido%@" />
<input type="hidden" name="ratio_divisa" value="@%db:Pedidos.id_divisa;%@" />
<div class="barraoscura"><a href="#" onclick="return sendForm('generar_factura');">Consolider</a></div>
<table class="full">
<tr>
<td class="etiqueta">S�rie Facturation:</td>
<td><select name="id_serie"> 
@%where:tabla|Series_facturacion;nolink|1;where|ventas = 0;order|contador desc%@
 <option value="@%db:Series_facturacion.id_serie;%@"
 >@%db:Series_facturacion.nombre;%@
 (@%db:si_no_flag{Series_facturacion.contabilizable};%@)
 - @%db:Series_facturacion.contador;%@</option>
 @%end-where:%@

 </select></td>
<td class="etiqueta">R�f. Ext:</td>
<td><input type="text" name="ref_externa" size="16" /></td>
</tr>

<tr>
<td class="etiqueta">Modes de paiement:</td>
<td colspan="3">

<!-- @%set:_selected_value=id_forma_pago%@ -->
<select name="id_forma_pago">
@%where:tabla|Forma_pago;nolink|1;%@ 
 <option value="@%db:Forma_pago.id_forma_pago;%@"
 @%db:selected_value{Forma_pago.id_forma_pago}%@
>@%db:Forma_pago.nombre;%@</option>
@%end-where:%@

</select></td>
</tr>
<tr>
<td class="etiqueta">R�f�rence:</td>
<td><input type="text" name="contador" size="16" /></td>
<td class="etiqueta">Cr�er Commande R�sidue</td>
<td><input type="checkbox" name="residuo" value="1" /></td>
</tr>
<tr>
<td class="etiqueta">Notes:</td>
<td colspan="3"><textarea name="notas" cols="57"></textarea></td>
</tr>

</form>
</table>
</fieldset>

