<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#FFFFFF" height="30">
@%plt:botonera%@ 
</td>
 </tr>
 <tr> <td height="22" bgcolor="#FFFFFF"> <form name="bo_importar_articulos_seleccion" method="post" action="">
<input type="hidden" name="accion_ejecutar" value="Importar">
 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr bgcolor="#CCD2D7"> <td colspan="17" height="22"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" width="190">Article</td>
 <td width="1" align="center"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center" width="50">Lot</td>
 <td width="1" align="center"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center">Plante</td>
 <td width="1" ></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center">Couloi</td>
 <td class="etiqueta" align="center" width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center">Rang</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center">Colonne</td>
 <td width="1" align="center"></td>
 <td class="etiqueta" bgcolor="#DBE0E3" align="center">Quantite</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" height="22" align="center" class="etiqueta" width="100">Date limite </td>
 <td bgcolor="#DBE0E3" width="1"></td>
 </tr>
 <tr> <td colspan="17" height="1"></td>
 </tr>
 @%where:tabla|Empresas_articulos;nombre|busc;%@ <tr> <td bgcolor="#DBE0E3" width="1"></td>
 <td class="texto">@%if:AllowedLink;modif_articulos;%@<a href="?seccion=modif_articulos&id_articulo=@%db:Localizacion_articulos.id_articulo;%@" class="accesos">@%db:Articulos.nombre;%@</a></td>
@%end-if:%@
 <td bgcolor="#DBE0E3"></td>
 <td align="center" class="texto"><input type="text" name="registro_lote[@%db:Empresas_articulos.id_articulo;%@]" class="insertext" size="5"></td>
 <td bgcolor="#DBE0E3"></td>
 <td align="center" class="texto" bgcolor="#DBE0E3"><input type="text" name="registro_planta[@%db:Empresas_articulos.id_articulo;%@]" class="insertext" size="5"></td>
 <td ></td>
 <td align="center" class="texto" bgcolor="#DBE0E3"> <input type="text" name="registro_pasillo[@%db:Empresas_articulos.id_articulo;%@]2" class="insertext" size="5">
 </td>
 <td align="center" class="texto"></td>
 <td align="center" class="texto" bgcolor="#DBE0E3"> <input type="text" name="registro_fila[@%db:Empresas_articulos.id_articulo;%@]2" class="insertext" size="5">
 </td>
 <td ></td>
 <td align="center" class="texto" bgcolor="#DBE0E3"> <input type="text" name="registro_columna[@%db:Empresas_articulos.id_articulo;%@]2" class="insertext" size="5">
 </td>
 <td></td>
 <td align="center" class="texto" bgcolor="#DBE0E3"> <input type="text" name="registro_cantidad[@%db:Empresas_articulos.id_articulo;%@]2" class="insertext" size="8">
 </td>
 <td ></td>
 <td align="center" height="22" class="texto" bgcolor="#DBE0E3"> <input type="text" name="registro_fecha_caducidad[@%db:Empresas_articulos.id_articulo;%@]2" class="insertext" size="12">
 </td>
 <td bgcolor="#DBE0E3" ></td>
 </tr>
 <tr> <td height="1" bgcolor="#CCD2D7"></td>
 <td height="1" bgcolor="#CCD2D7"></td>
 <td height="1" bgcolor="#CCD2D7"></td>
 <td height="1" bgcolor="#CCD2D7"></td>
 <td height="1" bgcolor="#CCD2D7"></td>
 <td height="1" bgcolor="#CCD2D7"></td>
 <td height="1" bgcolor="#CCD2D7"></td>
 <td height="1" bgcolor="#CCD2D7"></td>
 <td height="1" bgcolor="#CCD2D7"></td>
 <td height="1" bgcolor="#CCD2D7"></td>
 <td height="1" bgcolor="#CCD2D7"></td>
 <td height="1" bgcolor="#CCD2D7"></td>
 <td height="1" bgcolor="#CCD2D7"></td>
 <td height="1" bgcolor="#CCD2D7"></td>
 <td height="1" bgcolor="#CCD2D7"></td>
 <td height="1" bgcolor="#CCD2D7"></td>
 <td height="1" bgcolor="#CCD2D7"></td>
 </tr>
 @%end-where:%@ 
 <tr bgcolor="#CCD2D7" align="center"> <td height="19" colspan="17"></td>
 </tr>
 </table>
 </form>
 </td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" height="30">
@%plt:botonera%@
</td>
 </tr>
</table>
