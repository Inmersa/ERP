 @%where:tabla|Proveedores;where|Proveedores.id_proveedor = $id_proveedor_promocion;%@

<fieldset class="fsficha">
<legend>Datos para esta Empresa</legend>

<table class="full">
<!-- @%db:Proveedores_empresas.id_proveedor%@ -->
<input type="hidden" name="registro2[id_usr]" value="@%db:Proveedores_empresas.id_usr%@" />

<tr><td class="etiqueta">Forma de pago:</td>
<td colspan="3" ><!--@%db:Proveedores_empresas.id_forma_pago;%@ @%set:_selected_value = Proveedores_empresas.id_forma_pago;%@-->
 <select name="registro2[id_forma_pago]">
@%where:tabla|Forma_pago;nolink|1;%@
 <option value="@%db:Forma_pago.id_forma_pago;order|nombre;%@"
 @%db:selected_value{Forma_pago.id_forma_pago};%@
 >@%db:Forma_pago.nombre;%@</option>
@%end-where:%@

</select></td></tr>

<tr><td class="etiqueta">Divisa:</td>
<td><!--@%db:Proveedores.id_divisa;%@ @%set:_selected_value=Proveedores.id_divisa;%@-->
 <select name="registro[id_divisa]">
@%where:tabla|Divisa;nolink|1;order|nombre;%@
 <option value="@%db:Divisa.id_divisa;%@" 
 @%db:selected_value{Divisa.id_divisa};%@
 >@%db:Divisa.nombre;%@</option>
@%end-where:%@

</select></td>

<td class="etiqueta">Matener Ratio Divisa (D�as):</td>
<td><input type="text" name="registro2[mantener_ratio_divisa]" value="@%db:Proveedores_empresas.mantener_ratio_divisa%@" class="mininum" /></td></tr>

<tr>
<td class="etiqueta">Aplicar Retenci�n:</td>
<td class="check"><input type="checkbox" name="registro2[aplicar_retencion]" value="1" @%db:check_flag{Proveedores_empresas.aplicar_retencion};%@ /></td>
<td class="etiqueta">Retenci�n:</td>
<td> <input type="text" name="registro[retencion]" value="@%db:Proveedores.retencion;%@" size="5" maxlength="5" /></td>
</tr>

<tr>
<td class="etiqueta">Aplicar Iva:</td>
<td class="check"><input type="checkbox" name="registro2[aplicar_iva]" value="1" @%db:check_flag{Proveedores_empresas.aplicar_iva};%@ /></td>
<td class="etiqueta">Intracomunitario:</td>
<td class="check"><input type="checkbox" name="registro2[comunitario]" value="1" @%db:check_flag{Proveedores_empresas.comunitario};%@ /></td>
</tr>
<tr>
<td class="etiqueta">Aplicar Recargo:</td>
<td class="check"><input type="checkbox" name="registro2[aplicar_recargo]" value="1" @%db:check_flag{Proveedores_empresas.aplicar_recargo}%@ /></td>
<td colspan="2"></td>
</tr>

</table>
</fieldset>


