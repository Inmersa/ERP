<table width="647" border="0" cellspacing="0" cellpadding="0">
 <td bgcolor="#FFFFFF" height="30">

 @%plt:botonera%@
 </td>
 </tr>
 <tr> <td height="22" bgcolor="#FFFFFF"> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td colspan="9" bgcolor="#CCD2D7" height="22" class="etiqueta">Almac�n </td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta">Nombre art�culo </td>
 <td width="1" align="center"></td>
 <td class="etiqueta" width="120" align="center" bgcolor="#DBE0E3">Referencia</td>
 <td width="1" align="center"></td>
 <td class="etiqueta" bgcolor="#DBE0E3" align="center" width="60">Stock</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" width="100" height="22" align="center" class="etiqueta">Fecha caducidad menor</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 </tr>

 @%where:tabla|Localizacion_articulos;nombre|busc;no_results|1;group|Localizacion_articulos.id_articulo;%@ <tr> <td colspan="9" height="1"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="22"></td>
 <td class="texto">@%if:AllowedLink;modif_articulos;%@<a href="?seccion=modif_articulos&id_articulo=@%db:Localizacion_articulos.id_articulo;%@" class="accesos">@%db:Articulos.nombre;%@</a></td>
 @%end-if:%@
 <td bgcolor="#DBE0E3"></td>
 <td align="center" class="texto" width="120">@%db:Empresas_articulos.referencia;%@</td>
 <td bgcolor="#DBE0E3"></td>
 <td align="center" class="texto" width="60">@%db:cantidad;%@</td>
 <td bgcolor="#DBE0E3"></td>
 <td align="center" class="texto">@%db:colocar_fecha{caducidad};%@</td>
 <td bgcolor="#DBE0E3"></td>
 </tr>
 <tr> <td colspan="9" height="1"></td>
 </tr>
 <tr> <td colspan="9" bgcolor="#DBE0E3" height="1"></td>
 </tr>

 @%end-where:%@ </table>
 </td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" height="30">

@%plt:botonera%@

 </td>
 </tr>
</table>
