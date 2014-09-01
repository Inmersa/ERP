@%where:tabla|Efectos;where|Efectos.id_efecto= $id_efecto%@

<fieldset id="Efecto_NuevoAbono" class="fsficha">
<legend >Nouveau</legend>

<input type="hidden" name="efecto_parcial[id_efecto]" value="@%db:Efectos.id_efecto%@" />
<table class="full">
 <tr>
 <td class="caption" > Date liquidation </td>
 <td class="caption" > Moyen de payant </td>
 <td class="caption" > Montant </td>
 <td class="caption" > Banqe </td>
 </tr>
 <tr ><td class="texto" ><input type="text" name="efecto_parcial[fecha]" value="@%func:colocar_fecha;%@" class="fecha" size="19"></td>
 <td class="texto" >
 <select name="efecto_parcial[medio_pago]" class="insertext" size="1">
	 <option value="efectivo">Liquidités</option>
	 <option value="cheque">Chéque</option>
	 <option value="transferencia">Transfert</option>
	 <option value="pagar&eacute;">Billet</option>
	 <option value="recibo">Réception</option>
 </select>
 </td>
 <td ><input type="text" name="efecto_parcial[monto_satisfecho]" class="num" size="10"></td>
 <td ><select name="efecto_parcial[id_banco]" class="insertext" size="1">
	<option value="0">Sans Banque</option>
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
