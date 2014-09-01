<table width="647" border="0" cellspacing="0" cellpadding="0">

 <tr> <td bgcolor="#FFFFFF" height="13"> @%plt:botonera%@
 </td>
 </tr>
 <form name="bo_almacenes_importar" method="post" action="">
 <tr> <td height="22" bgcolor="#FFFFFF"> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr align="right" bgcolor="#CCD2D7"> <td colspan="9" height="22" class="etiqueta"> </td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" class="etiqueta" align="center" colspan="2" height="22">Nom</td>
 <td width="1" align="center"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center">Téléphone</td>
 <td class="etiqueta" align="center"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center">e-mail</td>
 <td class="etiqueta" align="center"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center">Personne de contact</td>
 <td width="1" align="center" bgcolor="#DBE0E3"></td>
 </tr>
 <tr> <td colspan="9" height="1"></td>
 </tr>
 @%where:tabla|Almacenes;nombre|busc;no_results|1;%@
 <tr> <td class="etiqueta" height="22" bgcolor="#DBE0E3" width="18"> </td>
 <td class="etiqueta" height="22" width="250"> @%if:AllowedLink;modif_almacenes;%@<a href="?seccion=modif_almacenes&id_almacen=@%db:Almacenes.id_almacen;%@" class="accesos">@%db:Almacenes.nombre;%@</a></td>
 @%end-if:%@
<td bgcolor="#DBE0E3" width="1"></td>
 <td align="center" class="texto" width="100">@%db:Almacenes.telefono;%@</td>
 <td align="center" class="texto" width="1" bgcolor="#DBE0E3"></td>
 <td align="center" class="texto" width="150">@%db:Almacenes.email;%@</td>
 <td align="center" class="texto" width="1" bgcolor="#DBE0E3"></td>
 <td align="center" class="texto" width="150">@%db:Almacenes.persona_contacto;%@ (@%db:Almacenes.cargo_persona_contacto;%@)</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="1" width="18" ></td>
 <td height="1"></td>
 <td height="1" width="1"></td>
 <td height="1"></td>
 <td height="1" bgcolor="#DBE0E3"></td>
 <td height="1"></td>
 <td height="1" bgcolor="#DBE0E3"></td>
 <td height="1"></td>
 <td height="1" width="1"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="1" width="18"></td>
 <td height="1" bgcolor="#CCD2D7"></td>
 <td height="1" width="1" bgcolor="#CCD2D7"></td>
 <td height="1" bgcolor="#CCD2D7"></td>
 <td height="1" bgcolor="#DBE0E3"></td>
 <td height="1" bgcolor="#CCD2D7"></td>
 <td height="1" bgcolor="#DBE0E3"></td>
 <td height="1" bgcolor="#CCD2D7"></td>
 <td height="1" width="1" bgcolor="#CCD2D7"></td>
 </tr>
 @%end-where:%@ 
 <tr bgcolor="#CCD2D7" align="center"> <td height="22" colspan="9" > <input type="hidden" name="Importar" value="Importar">
 </td>
 </tr>
 </table>
 </td>
 </tr>
 <tr> <td height="30">
 @%plt:botonera%@
 </td>
 </tr>
 </form>
</table>


