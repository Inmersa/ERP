@%where:tabla|Efectos;where|Efectos.id_efecto= $id_efecto%@

<fieldset id="Efecto_NuevoAbono" class="fsficha">
<legend >Nou liquidació</legend>

<input type="hidden" name="efecto_parcial[id_efecto]" value="@%db:Efectos.id_efecto%@" />
<table class="full">
 <tr>
 <td class="caption" > Data liquidació </td>
 <td class="caption" > Mig de pagament </td>
 <td class="caption" > Suma </td>
 <td class="caption" > Banc </td>
 </tr>
 <tr ><td class="texto" ><input type="text" name="efecto_parcial[fecha]" value="@%func:colocar_fecha;%@" class="fecha" size="19"></td>
 <td class="texto" >
 <select name="efecto_parcial[medio_pago]" class="insertext" size="1">
	 <option value="efectivo">Efectiu</option>
	 <option value="cheque">Xec</option>
	 <option value="transferencia">Transferència</option>
	 <option value="pagar&eacute;">Pagaré</option>
	 <option value="recibo">Rebut</option>
 </select>
 </td>
 <td ><input type="text" name="efecto_parcial[monto_satisfecho]" class="num" size="10"></td>
 <td ><select name="efecto_parcial[id_banco]" class="insertext" size="1">
	<option value="0">Sense Banc</option>
	@%where:tabla|Bancos;nolink|1;nombre|bancos;order|Bancos.nombre asc;%@
	<option value="@%db:Bancos.id_banco%@">@%db:Bancos.nombre%@</option>
	@%end-where:%@

      </select>
 </td>
 </tr>
 <tr>
 <td class="caption" colspan="4">Notes</td>
 </tr>
 <td colspan="4" align="center" ><textarea name="efecto_parcial[notas]" cols="120" rows="4" class="insertext"></textarea></td>
 </tr>
 </table>
 </fieldset>
