<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#FFFFFF" height="30">


 @%plt:botonera%@ </td>
 </tr>
 <tr> <td height="22" bgcolor="#FFFFFF"> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td colspan="7" bgcolor="#CCD2D7" height="22" class="etiqueta" align="right">
 </td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" class="etiqueta" align="center" height="22"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" height="22">Nombre</td>
 <td width="1" align="center"></td>
 <td bgcolor="#DBE0E3" class="etiqueta">Porcentaje</td>
 <td class="etiqueta" width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta">Recargo de equivalencia</td>
 <td width="1" align="center" bgcolor="#DBE0E3"></td>
 </tr>

 <form name="modif_tipos_iva" action="" method=post>
 <input type=hidden name=estado value=3>


 @%where:tabla|Tipos_IVA;nombre|busc;%@
 <tr> <td bgcolor="#DBE0E3" height="1"></td>
 <td colspan="6" height="1"></td>
 </tr>
 <tr> <td class="etiqueta" height="22" bgcolor="#DBE0E3" width="18" align="center"> </td>
 <td class="etiqueta" height="22">@%if:AllowedLink;modif_tipos_iva;%@<a href="?seccion=modif_tipos_iva&id_iva=@%db:Tipos_IVA.id_iva;%@" class="accesos">@%db:Tipos_IVA.nombre;%@ </a></td>
 @%end-if:%@
 <td bgcolor="#DBE0E3" width="1"></td>
 <td class="texto">@%db:Tipos_IVA.porcentaje;%@</td>
 <td class="texto" bgcolor="#DBE0E3"></td>
 <td class="texto">@%db:Tipos_IVA.recargo_equivalente;%@ </td>
 <td bgcolor="#DBE0E3" width="1"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="1" width="18" ></td>
 <td height="1"></td>
 <td height="1" width="1"></td>
 <td height="1"></td>
 <td height="1"></td>
 <td height="1"></td>
 <td height="1" width="1"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="1" width="18"></td>
 <td height="1" bgcolor="#CCD2D7"></td>
 <td height="1" width="1" bgcolor="#CCD2D7"></td>
 <td height="1" bgcolor="#CCD2D7"></td>
 <td height="1" bgcolor="#CCD2D7"></td>
 <td height="1" bgcolor="#CCD2D7"></td>
 <td height="1" width="1" bgcolor="#CCD2D7"></td>
 </tr>
@%end-where:%@

</form>

 <tr> <td height="22" colspan="7" ></td>
 </tr>
 <tr align="center"> <td colspan="7" height="22" bgcolor="#CCD2D7"></td>
 </tr>
 </table>
 </td>
 </tr>
 <tr> <td height="30">

@%plt:botonera%@

</td>
 </tr>
</table>

