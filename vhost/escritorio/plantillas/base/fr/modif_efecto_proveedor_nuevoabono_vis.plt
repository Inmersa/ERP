@%where:tabla|Efectos;where|Efectos.id_efecto= $id_efecto%@

 <table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> 
 <td height="22" bgcolor="#CCD2D7" class="titocho">>Nouveau</td>
<td width="1" bgcolor="#CCD2D7"></td>
</tr>
<tr><td>
 <table width="100%" border="0" cellspacing="0" cellpadding="0">
 <tr> 
 <td bgcolor="#EBECED" width="139" class="etiqueta" align="center" height="22"> Date liquidation</td>
 <td bgcolor="#EBECED" width="134" class="etiqueta" align="center" height="22"> Moyen de payant </td>
 <td bgcolor="#EBECED" width="145" class="etiqueta" align="center" height="22"> Montant </td>
<td bgcolor="#DBE0E3" width="1"></td>
 </tr>
 <tr bgcolor="#FFFFFF"> <td width="139" height="25" class="texto" align="center"> @%db:colocar_fecha{}%@<input type="hidden" name="efecto[fecha]" value="@%db:colocar_fecha{}%@" class="insertext">
 </td>
 <td width="134" class="texto" align="center"> <select name="select" class="insertext" size="1">
 <option value="efectivo">Liquidit�s</option>
 <option value="cheque">Ch�que</option>
 <option value="transferencia">Transfert</option>
 <option value="pagar&eacute;">Billet</option>
 <option value="recibo">R�ception</option>
 <option selected>----------------------------------</option>
 </select>
 </td>
 <td width="145" class="texto" align="center"> <input type="text" name="efecto[monto_pagado]" class="insertext">
 </td>
<td width="1" bgcolor="#CCD2D7"></td>
 </tr>
 </table>
 </td>
 </tr>
</table>
<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#EBECED" width="134" class="etiqueta" align="center" height="30"> Banqe </td>
<td>
 <select name="select" class="insertext">
 </select>
 </tr>
 </table>
 <table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#EBECED" width="571" class="etiqueta" align="right" height="22">
 <div align="left"> Notes</div>
 </td>
 <td width="1" bgcolor="#CCD2D7"></td>
 </tr>
 <tr bgcolor="#FFFFFF"> <td width="571" class="texto" align="center"> <textarea name="efecto[notas]" cols="120" rows="4" class="insertext"> </textarea>
 </td>
 <td width="1" bgcolor="#CCD2D7"></td>
 </tr>
</table>