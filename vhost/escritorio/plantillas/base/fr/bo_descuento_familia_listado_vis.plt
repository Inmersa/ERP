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
 <td bgcolor="#DBE0E3" class="etiqueta" height="22" width="250">Nom Famille</td>
 <td width="1" align="center"></td>
 <td bgcolor="#DBE0E3" class="etiqueta">Remises</td>
 <td width="1" align="center" bgcolor="#DBE0E3"></td>
 </tr>

 <form name="modif_descuento_familia" action="" method=post>
 <input type=hidden name=estado value=3>

 <tr> <td bgcolor="#DBE0E3" height="1"></td>
 <td colspan="4" height="1"></td>
 </tr>
 @%where:tabla|Descuento_familia;nombre|busc;no_results|1;%@ <tr> <td class="etiqueta" height="22" bgcolor="#DBE0E3" width="18" align="center"> </td>
 <td class="etiqueta" height="22">@%if:AllowedLink;modif_descuento_familia;%@<a href="?seccion=modif_descuento_familia&id_familia=@%db:Descuento_familia.id_familia;%@" class="accesos">@%db:Familia_articulos.nombre;%@</a></td>
 @%end-if:%@
 <td bgcolor="#DBE0E3" width="1"></td>
 <td class="texto"> @%db:Descuento_familia.descuento;%@ %</td>
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
 </table>
 </td>
 </tr>
 <tr> <td height="30">
@%plt:botonera%@
</td>
 </tr>
</table>


