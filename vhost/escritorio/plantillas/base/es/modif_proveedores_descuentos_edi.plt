@%where:tabla|Proveedores;where|Proveedores.id_proveedor = $id_proveedor_promocion;%@

<fieldset class="fsficha">
<legend>Descuentos</legend>
<table class="full">
<tr><td class="etiqueta">% Dto Comercial:</td>
<td><input type="text" name="registro2[descuento]" value="@%db:Proveedores_empresas.descuento;%@" size="4" /></td>
<td class="etiqueta">% Dto Financiero:</td>
<td><input type="text" name="registro2[descuento_financiero]" size="4"   value="@%db:Proveedores_empresas.descuento_financiero;%@" /></td></tr>
</table>
</fieldset>

<fieldset class="fsficha">
<legend>Descuentos por Volumen</legend>

<table class="full">
<tr><td class="etiqueta">% Dto Bulto:</td>
<td colspan="1"><input type="text" name="registro[dto_gnrl_vol_bulto]" value="@%db:Proveedores.dto_gnrl_vol_bulto;%@" size="5" maxlength="5" /></td>
<td class="etiqueta">Uds Min :</td>
<td colspan="1"><input type="text" name="registro[dto_gnrl_vol_bulto_uds]" value="@%db:Proveedores.dto_gnrl_vol_bulto_uds;%@" size="5" maxlength="5" /></td>
 </tr>

<tr><td class="etiqueta">% Dto Capa:</td>
<td colspan="1"><input type="text" name="registro[dto_gnrl_vol_capa]" value="@%db:Proveedores.dto_gnrl_vol_capa;%@" size="5" maxlength="5" /></td>
<td class="etiqueta">Uds Min :</td>
<td colspan="1"><input type="text" name="registro[dto_gnrl_vol_capa_uds]" value="@%db:Proveedores.dto_gnrl_vol_capa_uds;%@" size="5" maxlength="5" /></td>
 </tr>

<tr><td class="etiqueta">% Dto Palet:</td>
<td colspan="1"><input type="text" name="registro[dto_gnrl_vol_palet]" value="@%db:Proveedores.dto_gnrl_vol_palet;%@" size="5" maxlength="5" /></td>
<td class="etiqueta">Uds Min :</td>
<td colspan="1"><input type="text" name="registro[dto_gnrl_vol_palet_uds]" value="@%db:Proveedores.dto_gnrl_vol_palet_uds;%@" size="5" maxlength="5" /></td>
</tr>
</table>
</fieldset>

