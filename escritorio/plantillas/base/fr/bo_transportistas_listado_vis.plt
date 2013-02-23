<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#FFFFFF" height="30">
@%plt:botonera%@
</td>
 </tr>
 <tr> <td height="22" bgcolor="#FFFFFF"> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td colspan="9" bgcolor="#CCD2D7" height="22" class="etiqueta" align="right">
 </td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" class="etiqueta" align="center" height="22"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" height="22" width="170">Nom</td>
 <td width="1" align="center"></td>
 <td bgcolor="#DBE0E3" class="etiqueta">Raison sociale</td>
 <td class="etiqueta" width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta">Téléphone</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta">e-mail</td>
 <td width="1" align="center" bgcolor="#DBE0E3"></td>
 </tr>

 <form name="modif_transportistas" action="" method=post>
 <input type=hidden name=estado value=3>


@%where:tabla|Transportistas;nombre|busc;no_results|1;%@

 <tr> <td bgcolor="#DBE0E3" height="1"></td>
 <td colspan="8" height="1"></td>
 </tr>
 <tr> <td class="etiqueta" height="22" bgcolor="#DBE0E3" width="18" align="center"> </td>
 <td height="22">@%if:AllowedLink;modif_transportistas;%@<a href="?seccion=modif_transportistas&id_transportista=@%db:Transportistas.id_transportista;%@" class="accesos">@%db:Transportistas.nombre;%@
</a></td>
@%end-if:%@
 <td bgcolor="#DBE0E3" width="1"></td>
 <td class="texto">@%db:Transportistas.razon_social;%@</td>
 <td bgcolor="#DBE0E3"></td>
 <td class="texto">@%db:Transportistas.telefono;%@</td>
 <td bgcolor="#DBE0E3" ></td>
 <td><a href="mailto:@%db:Transportistas.email;%@" class="accesos">@%db:Transportistas.email;%@</a></td>
 <td bgcolor="#DBE0E3" width="1"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="1" width="18" ></td>
 <td height="1"></td>
 <td height="1" width="1"></td>
 <td height="1"></td>
 <td height="1"></td>
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
 <td height="1" bgcolor="#CCD2D7"></td>
 <td height="1" bgcolor="#CCD2D7"></td>
 <td height="1" width="1" bgcolor="#CCD2D7"></td>
 </tr>
@%end-where:%@

</form>

 <tr align="center"> <td height="22" colspan="9" ></td>
 </tr>
 <tr align="center"> <td colspan="9" height="22" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="1" width="18" ></td>
 <td height="1"></td>
 <td height="1" width="1"></td>
 <td height="1"></td>
 <td height="1"></td>
 <td height="1"></td>
 <td height="1"></td>
 <td height="1"></td>
 <td height="1" width="1"></td>
 </tr>
 </table>
 </td>
 </tr>
 <tr> <td height="30">@%plt:botonera%@</td>
 </tr>
</table>

