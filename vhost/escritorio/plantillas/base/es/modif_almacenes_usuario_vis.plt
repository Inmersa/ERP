 @%where:tabla|Almacenes;where|Almacenes.id_almacen = $id_almacen_promocion;%@

 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td width="111" align="right" bgcolor="#EBECED" height="22" class="etiqueta">Login:</td>
 <td width="533"> @%func:nombre_login_real%@<input type="hidden" name=registro[login] value="@%func:nombre_login_real%@" class="insertext" size="20">
 </td>
 </tr>
 <tr bgcolor="#CCD2D7"> <td colspan="2" height="1" align="right"></td>
 </tr>
 <tr> <td width="111" align="right" bgcolor="#EBECED" height="22" class="etiqueta">Contraseña:</td>
 <td width="533"> <input type=password name="registro[passwd]" class="insertext" size="20">
 </td>
 </tr>
 <tr bgcolor="#CCD2D7"> <td colspan="2" height="1" align="right"></td>
 </tr>
 <tr> <td width="111" align="right" bgcolor="#EBECED" height="22" class="etiqueta">Confirmar:</td>
 <td width="533"> <input type=password name=registro[passwd2] class="insertext" size="20">
 </td>
 </tr>
 <tr> <td colspan="2" height="1" bgcolor="#CCD2D7"></td>
 </tr>
 </table>
