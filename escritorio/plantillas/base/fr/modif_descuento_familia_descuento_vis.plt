
<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#FFFFFF" height="13"></td>
 </tr>
 <tr> <td bgcolor="#FFFFFF"> <table width="645" border="0" cellspacing="0" cellpadding="0">
<form name="modif_descuento_familia" action="" method=post>
<input type=hidden name=registro[id_familia] value="@%db:Descuento_familia.id_familia;%@">
<input type=hidden name=estado value=1>
 <tr> <td colspan="3" height="22" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="216" class="etiqueta" align="right" height="22">Famille � articles:</td>
 <td width="427" class="texto">@%db:Familia_articulos.nombre;%@
 </td>
 <td width="2" bgcolor="#CCCCCC"></td>
 </tr>
 <tr> <td height="1" width="216" bgcolor="#CCD2D7"></td>
 <td height="1" width="427" bgcolor="#CCD2D7"></td>
 <td width="2" bgcolor="#CCCCCC"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="216" class="etiqueta" align="right" height="22">Remises:</td>
 <td width="427" class="texto"> @%db:Descuento_familia.descuento;%@<input type="hidden" name="registro[descuento]" value="@%db:Descuento_familia.descuento;%@" class="insertext" size="6">
 % </td>
 <td width="2" bgcolor="#CCCCCC"></td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" width="216"></td>
 <td bgcolor="#CCD2D7" height="1" width="427"></td>
 <td width="2" bgcolor="#CCCCCC"></td>
 </tr>
 <tr> <td height="22" colspan="3"></td>
 </tr>
 <tr align="center"> <td height="22" bgcolor="#CCD2D7" colspan="3"></td>
 </tr>
 </form>
 </table>
 </td>
 </tr>
 <tr> <td height="30"> </td>
 </tr>
</table>

