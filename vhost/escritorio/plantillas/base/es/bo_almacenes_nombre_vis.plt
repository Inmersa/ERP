 <table width="647" border="0" cellspacing="0" cellpadding="0">

 <tr> 
 <td bgcolor="#FFFFFF" height="30"> 
@%plt:botonera%@
</td>
 </tr>
<form name="bo_almacenes" method="post" action="?seccion=bo_almacenes">
 <tr> <td height="22" bgcolor="#FFFFFF"> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr align="right"> <td colspan="9" bgcolor="#CCD2D7" height="22" class="etiqueta">
 <input type="hidden" name="accion_ejecutar" value="Borrar">
 </td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" class="etiqueta" align="center" colspan="2" height="22">Nombre</td>
 <td width="1" align="center"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center">Teléfono</td>
 <td class="etiqueta" align="center"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center">e-mail</td>
 <td class="etiqueta" align="center"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center">Persona de contacto</td>
 <td width="1" align="center" bgcolor="#DBE0E3"></td>
 </tr>
 <tr> <td colspan="9" height="1"></td>
 </tr>
 @%where:tabla|Almacenes;nombre|busc;no_results|1;order|Almacenes.nombre;%@
 <tr> 
 <td class="etiqueta" height="22" bgcolor="#DBE0E3" width="18"> </td>
 <td class="etiqueta" height="22" width="250">
@%if:AllowedLink;modif_almacenes;%@<a href="?seccion=modif_almacenes&id_almacen=@%db:Almacenes.id_almacen;%@" class="accesos">@%db:Almacenes.nombre;%@</a></td>
 <td bgcolor="#DBE0E3" width="1"></td>
@%end-if:%@
 <td align="center" class="texto" width="100">@%db:Almacenes.telefono;%@</td>
 <td align="center" class="texto" width="1" bgcolor="#DBE0E3"></td>
 <td align="center" class="texto" width="150">@%db:Almacenes.email;%@</td>
 <td align="center" class="texto" width="1" bgcolor="#DBE0E3"></td>
 <td align="center" class="texto" width="150">@%db:Almacenes.persona_contacto;%@
(@%db:Almacenes.cargo_persona_contacto;%@)</td>
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
 @%end-where:%@

 </table>
 </td>
 </tr>
 <tr> <td height="30">
 @%plt:botonera%@
 </td>
 </tr>
 </form>
 </table>



