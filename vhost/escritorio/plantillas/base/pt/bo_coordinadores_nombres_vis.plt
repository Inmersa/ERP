<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#FFFFFF" height="30">
@%plt:botonera%@
</td>
 </tr>
 <tr> <td height="22" bgcolor="#FFFFFF">

 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#CCD2D7" height="22" class="etiqueta" colspan="5" > </td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="22"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" >Nome</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" height="22" align="center" width="200">e-mail</td>
 <td bgcolor="#DBE0E3"></td>
 </tr>

@%where:tabla|Coordinadores;nombre|busc;no_results|1;%@

 <tr> <td height="1" colspan="5"></td>
 </tr>
 <tr> <td class="etiqueta" height="22" bgcolor="#DBE0E3" width="1"></td>
 <td class="etiqueta" height="22">@%if:AllowedLink;modif_coordinadores;%@<a href="?seccion=modif_coordinadores&id_coordinador=@%db:Coordinadores.id_usr;%@" class="accesos">@%db:Coordinadores.nombre;%@ @%db:Coordinadores.apellidos;%@</a></td>
@%end-if:%@
 <td class="etiqueta" height="22" bgcolor="#DBE0E3" width="1"></td>
 <td class="etiqueta" height="22" width="200" align="center">@%if:AllowedLink;@%db:Coordinadores.email;%@<a href="mailto:@%db:Coordinadores.email;%@" class="accesos">@%db:Coordinadores.email;%@</a></td>
 <td class="etiqueta" height="22" bgcolor="#DBE0E3" width="1"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="1" colspan="5" ></td>
 </tr>
 @%end-where:%@ 
 </table>
 
 </td>
 </tr>
 <tr> <td height="30">
@%plt:botonera%@
</td>
 </tr>
</table>
