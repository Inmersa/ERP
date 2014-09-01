<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#FFFFFF" height="30">
@%plt:botonera%@
</td>
 </tr>
 <tr> <td height="22" bgcolor="#FFFFFF"> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td colspan="5" bgcolor="#CCD2D7" height="22" class="etiqueta" align="right">
 </td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" class="etiqueta" align="center" height="22"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" height="22">Name</td>
 <td width="1" align="center"></td>
 <td bgcolor="#DBE0E3" class="etiqueta">Remarks</td>
 <td width="1" align="center" bgcolor="#DBE0E3"></td>
 </tr>
 <form name="modif_marcas" action="" method=post>
 <input type=hidden name=estado value=3>

@%where:tabla|Marcas;nombre|busc;%@

 <tr> <td bgcolor="#DBE0E3" height="1"></td>
 <td colspan="4" height="1"></td>
 </tr>
 <tr> <td class="etiqueta" height="22" bgcolor="#DBE0E3" width="18" align="center"> </td>
 <td height="22">@%if:allowed-link;modif_marcas;%@<a href="?seccion=modif_marcas&id_marca=@%db:Marcas.id_marca;%@" class="accesos">@%db:Marcas.nombre;%@</a></td>
 @%end-if:%@
 <td bgcolor="#DBE0E3" width="1"></td>
 <td class="texto"> @%db:Marcas.observaciones;%@ </td>
 <td bgcolor="#DBE0E3" width="1"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="1" width="18" ></td>
 <td height="1"></td>
 <td height="1" width="1"></td>
 <td height="1"></td>
 <td height="1" width="1"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="1" width="18"></td>
 <td height="1" bgcolor="#CCD2D7"></td>
 <td height="1" width="1" bgcolor="#CCD2D7"></td>
 <td height="1" bgcolor="#CCD2D7"></td>
 <td height="1" width="1" bgcolor="#CCD2D7"></td>
 </tr>

@%end-where:%@

</form>

 <tr> <td height="22" colspan="5" ></td>
 </tr>
 <tr align="center"> <td colspan="5" height="22" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="1" width="18" ></td>
 <td height="1"></td>
 <td height="1" width="1"></td>
 <td height="1"></td>
 <td height="1" width="1"></td>
 </tr>
 </table>
 </td>
 </tr>
 <tr> <td height="30">
 @%plt:botonera%@ </td>
 </tr>
</table>

