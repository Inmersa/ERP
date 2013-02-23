<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#FFFFFF" height="30">
@%plt:botonera%@
</td>
 </tr>
 <tr> <td height="22" bgcolor="#FFFFFF"> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td colspan="3" bgcolor="#CCD2D7" height="22" class="etiqueta" align="right">
<a href="javascript:document.forms['modif_grupo_empresas'].submit();" class="accesos">Esborrar seleccionats</a> </td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" class="etiqueta" align="center" height="22" width="24"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" height="22" width="619">Nom</td>
 <td width="1" align="center" bgcolor="#DBE0E3"></td>
 </tr>

 <form name="modif_grupo_empresas" action="" method=post>
 <input type=hidden name=estado value=3>

@%where:tabla|Grupo_empresas;nombre|busc;%@ <tr> <td bgcolor="#DBE0E3" height="1" width="24"></td>
 <td colspan="2" height="1"></td>
 </tr>
 <tr> <td class="etiqueta" height="22" bgcolor="#DBE0E3" width="24" align="center"> <input type="checkbox" name="registro_borrar[@%db:Grupo_empresas.id_grupo_empresa;%@]" value="1">
 </td>
 <td height="22" width="619"> <a href="?seccion=modif_grupo_empresas&id_grupo_empresa=@%db:Grupo_empresas.id_grupo_empresa;%@" class="accesos">@%db:Grupo_empresas.nombre;%@
</a> </td>
 <td bgcolor="#DBE0E3" width="1"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="1" width="24" ></td>
 <td height="1" width="619"></td>
 <td height="1" width="1"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="1" width="24"></td>
 <td height="1" bgcolor="#CCD2D7" width="619"></td>
 <td height="1" width="1" bgcolor="#CCD2D7"></td>
 </tr>

@%end-where:%@

</form>

 <tr> <td height="22" colspan="3" ></td>
 </tr>
 <tr align="center"> <td colspan="3" height="22" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="1" width="24" ></td>
 <td height="1" width="619"></td>
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
