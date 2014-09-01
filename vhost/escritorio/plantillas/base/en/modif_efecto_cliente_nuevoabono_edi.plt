@%where:tabla|Efectos;where|Efectos.id_efecto= $id_efecto%@

<fieldset id="Efecto_NuevoAbono" class="fsficha">
<legend>New payment</legend>

<input type="hidden" name="efecto_parcial[id_efecto]" value="@%db:Efectos.id_efecto%@" />
<table class="full">
<tr>
<td class="caption">Payment date</td>
<td class="caption">Payment way</td>
<td class="caption">Total amount</td>
<td class="caption">Bank</td>
</tr>
<tr>
<td><input type="text" name="efecto_parcial[fecha]" value="@%db:descolocar_fecha{}%@" size="19" class="fecha" /></td>
<td><select name="efecto_parcial[medio_pago]" size="1">
 <option value="efectivo">Cash</option>
 <option value="cheque">Check</option>
 <option value="transferencia">Cash transfer</option>
 <option value="pagar&eacute;">Promissory note</option>
 <option value="recibo">Receipt</option>
 </select></td>
<td><input type="text" name="efecto_parcial[monto_satisfecho]" size="10" class="num" /></td>
<td><select name="efecto_parcial[id_banco]" size="1">
<option value="0">Without Bank</option>
@%where:tabla|Bancos;nolink|1;nombre|bancos;order|Bancos.nombre asc;%@
<option value="@%db:Bancos.id_banco%@">@%db:Bancos.nombre%@</option>
@%end-where:%@

 </select></td>
 </tr>
<tr>
<td class="caption" colspan="4">Notes</td>
</tr>
<tr>
<td align="center" colspan="4"><textarea name="efecto_parcial[notas]" cols="120" rows="4"></textarea></td>
</tr>
</table>
</fieldset>

