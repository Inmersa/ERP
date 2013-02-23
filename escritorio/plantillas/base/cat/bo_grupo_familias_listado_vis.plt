<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#FFFFFF" height="30">
@%plt:botonera%@
</td>
 </tr>
 <tr> <td height="22" bgcolor="#FFFFFF"> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td colspan="5" bgcolor="#CCD2D7" height="22" class="etiqueta" align="right"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" class="etiqueta" align="center" height="22" width="24"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" height="22" width="205">Nom</td>
 <td class="etiqueta" height="1" width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" height="22" width="413">Descripció</td>
 <td width="1" align="center" bgcolor="#DBE0E3"></td>
 </tr>

 <form name="modif_grupo_familias" action="" method=post>
 <input type=hidden name=estado value=3>



 @%where:tabla|Grupo_familias;nombre|busc;%@ <tr> <td bgcolor="#DBE0E3" height="1" width="24"></td>
 <td colspan="4" height="1"></td>
 </tr>
 <tr> <td class="etiqueta" height="22" bgcolor="#DBE0E3" width="24" align="center"> </td>
 <td height="22" width="205">@%if:AllowedLink;modif_grupo_familias;%@<a href="?seccion=modif_grupo_familias&id_grupo_familia=@%db:Grupo_familias.id_grupo_familia;%@" class="accesos">@%db:Grupo_familias.nombre;%@</a></td>
 @%end-if:%@
 <td height="1" bgcolor="#CCD2D7" width="1"></td>
 <td height="22" width="413" class="texto">@%db:Grupo_familias.descripcion;%@</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="1" width="24" ></td>
 <td height="1" colspan="3"></td>
 <td height="1" width="1"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="1" width="24"></td>
 <td height="1" bgcolor="#CCD2D7" colspan="3"></td>
 <td height="1" width="1" bgcolor="#CCD2D7"></td>
 </tr>
 
@%end-where:%@ 

</form>

 <tr> <td height="22" colspan="5" ></td>
 </tr>
 <tr align="center"> <td colspan="5" height="22" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="1" width="24" ></td>
 <td height="1" colspan="3"></td>
 <td height="1" width="1"></td>
 </tr>
 </table>
 </td>
 </tr>
 <tr> <td height="30">
@%plt:botonera%@
</td>
 </tr>
</table>

