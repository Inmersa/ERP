<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#FFFFFF" height="30">
@%plt:botonera%@
</td>
 </tr>
 <tr> <td height="22" bgcolor="#FFFFFF"> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td colspan="3" bgcolor="#CCD2D7" height="22" class="etiqueta" align="right"> </td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" class="etiqueta" align="center" height="22" width="24"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" height="22" width="619">Nom Fam�lia</td>
 <td width="1" align="center" bgcolor="#DBE0E3"></td>
 </tr>

<form name="modif_familia_articulos" action="" method=post>
 <input type=hidden name=estado value=3>

@%where:tabla|Familia_articulos;nombre|busc;%@

 <tr> <td bgcolor="#DBE0E3" height="1" width="24"></td>
 <td colspan="2" height="1"></td>
 </tr>
 <tr> <td class="etiqueta" height="22" bgcolor="#DBE0E3" width="24" align="center"> </td>
 <td height="22" width="619">@%if:AllowedLink;modif_familia_articulos;%@<a href="?seccion=modif_familia_articulos&id_familia=@%db:Familia_articulos.id_familia;%@" class="accesos">@%db:Familia_articulos.nombre;%@ </a> </td>
@%end-if:%@
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

