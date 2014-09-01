@%where:nodb|nodb_order_data;nombre|consolidar;%@

<form name="generar_albaran" action="?seccion=bo_albaranes_venta" method="post">
<input type="hidden" name="Generar" value="Generar" />
<input type="hidden" name="identificador_pedido" value="@%db:id_pedido%@" />

<fieldset id="Pedido_Cliente_Generar_Albaranes" class="fsficha">
<legend>Albar�ns</legend>

<div class="AccionesFicha" ><ul>
<li><a href="#" onclick="return sendForm('generar_albaran');" class="generaralbaranes" ><img src="images/pixel.png" class="icono" /><span>Generar Albar�</span></a></li>
</ul></div>

<table class="full">
<tr>
<td class="etiqueta">Transportistes:</td>
<td><select name="id_transportista">
 <option value="">{{cfg_transportista_defecto}}</option>
 @%where:tabla|Transportistas;nolink|1;%@
 <option value="@%db:Transportistas.id_transportista;%@">@%db:Transportistas.nombre;%@</option>
 @%end-where:%@

 </select></td>
<td class="etiqueta">Ref. Ext:</td>
<td><input type="text" name="ref_externa" size="16" /></td>

@%if:!esta_vacio;id_empresa;%@
<td class="etiqueta">Magatzem:</td>
<td><select name="id_almacen" >
<option value="">Qualsevol</option>
@%where:tabla|Almacenes;where|id_empresa = $id_empresa;%@
<option value="@%db:Almacenes.id_almacen;%@" 
>@%db:Almacenes.nombre;%@</option>
@%end-where:%@

</select>
</td>
@%end-if:%@

</tr>

<tr>
<td class="etiqueta">Preparat:</td>
<td><input type="checkbox" name="preparado" value="1" /></td>
<td class="etiqueta">Enviat:</td>
<td><input type="checkbox" name="enviado" value="1" /></td>
<td class="etiqueta">Confirmaci�:</td>
<td><input type="checkbox" name="confirmacion" value="1" /></td>
</tr>
</table>
</fieldset>

</form>


<form name="generar_factura" action="?seccion=bo_facturas_venta" method="post">
<fieldset id="Pedido_Cliente_Consolidar" class="fsficha">
<legend>Formularis de consolidaci�</legend>
<table class="full">
 <input type="hidden" name="Generar" value="Generar" />
 <input type="hidden" name="identificador_pedido" value="@%db:Pedidos.id_pedido%@" />
 <input type="hidden" name="ratio_divisa" value="@%db:Pedidos.id_divisa;%@" />

<tr>
<td colspan="3" class="etiqueta">Generar Albar�</td>
<td><a href="#" onclick="return sendForm('generar_factura');">Consolidar</a></td>
 </tr>
<tr>
<td class="etiqueta">Ser. Facturat:</td>
<td><select name="id_serie"> 
@%where:tabla|Series_facturacion;nolink|1;where|ventas = 1;order|contador desc;%@
 <option value="@%db:Series_facturacion.id_serie;%@"
 >@%db:Series_facturacion.nombre;%@
 (@%db:si_no_flag{Series_facturacion.contabilizable};%@)
 - @%db:Series_facturacion.contador;%@</option>
 @%end-where:%@


 </select></td>
<td class="etiqueta">Ref. Ext:</td>
<td><input type="text" name="ref_externa" size="16" /></td>
</tr>
<tr><td class="etiqueta">Forma de paga:</td>
<td colspan="3">

<!-- @%set:_selected_value=id_forma_pago;%@ -->
<select name="id_forma_pago">
 @%where:tabla|Forma_pago;nolink|1;order|nombre;%@ 
 <option value="@%db:Forma_pago.id_forma_pago;%@"
 @%db:selected_value{Forma_pago.id_forma_pago}%@
>@%db:Forma_pago.nombre;%@</option> 
 @%end-where:%@

</select></td>
</tr>
<tr>
<td class="etiqueta">Refer�ncia:</td>
<td><input type="text" name="contador" size="16" /></td>
<td class="etiqueta">Crear Comande Residual</td>
<td><input type="checkbox" name="residuo" value="1" /></td>
</tr>
<tr>
<td class="etiqueta">Notes:</td>
<td colspan="3"><textarea name="notas" cols="57"></textarea></td>
</tr>
</table>
</fieldset>
</form>

