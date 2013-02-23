<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#FFFFFF" height="30">
@%plt:botonera%@
</td>
 </tr>
 <tr> <td height="22" bgcolor="#FFFFFF"> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <form name="compra_articulos_proveedor" method="post" action="">
 <input type="hidden" name="accion_ejecutar" value="j">
 <tr> <td height="22" align="right" bgcolor="#CCD2D7"> <table width="180" border="0" cellspacing="0" cellpadding="0">
 <tr> <td align="right"> </td>
 <td width="6"></td>
 </tr>
 </table>
 </td>
 </tr>
 <tr> <td height="3"> </td>
 </tr>
 <tr> <td> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#DBE0E3" width="1" class="etiqueta" align="center"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center" width="70">Ref. Propia</td>
 <td class="etiqueta" align="center" width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center" width="80">Ref Proveedor </td>
 <td width="1"></td>
 <td width="20" bgcolor="#DBE0E3"></td>
 <td bgcolor="#DBE0E3" class="etiqueta">Nombre artículo </td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center"></td>
 <td class="etiqueta" align="center" width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center">Precio</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" width="65" align="center">Dto %</td>
 <td class="etiqueta" align="center" width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center" width="50">Fab.</td>
 <td width="1"></td>
 </tr>
 @%where:tabla|Compra_articulos;nombre|busc;no_results|1;%@ <tr> <td></td>
 <td height="2" colspan="3"></td>
 <td></td>
 <td bgcolor="#DBE0E3" height="2"></td>
 <td colspan="10"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" width="1"></td>
 <td align="center" class="texto">@%db:Empresas_articulos.referencia;%@</td>
 <td align="center" bgcolor="#DBE0E3" ></td>
 <td align="center" > @%db:Compra_articulos.referencia;%@<input type="hidden" name="articulos_proveedor_referencia[@%db:Compra_articulos.id_articulo;%@]" value="@%db:Compra_articulos.referencia;%@" size="10" class="insertextnumeros"/>
 </td>
 <td></td>
 <td bgcolor="#DBE0E3" valign="top" height="22"> </td>
 <td class="texto"> <table width="100%" border="0" cellspacing="0" cellpadding="0">
 <tr> <td width="6"></td>
 <td>@%if:AllowedLink;modif_articulos;%@<a href="?seccion=modif_articulos&id_articulo=@%db:Compra_articulos.id_articulo%@" class="accesos">@%db:Articulos.nombre;%@</a></td>
@%end-if:%@
 </tr>
 </table>
 </td>
 <td bgcolor="#DBE0E3"></td>
 <td class="texto" align="center"></td>
 <td class="texto" align="center" bgcolor="#DBE0E3"></td>
 <td class="texto" align="center"> @%db:Compra_articulos.precio;%@<input type="hidden" name="articulos_proveedor_precio[@%db:Compra_articulos.id_articulo;%@]" size="5" class="insertextnumeros" value="@%db:Compra_articulos.precio;%@"/>
 </td>
 <td bgcolor="#DBE0E3"></td>
 <td class="texto" align="center"> @%db:Compra_articulos.descuento;%@<input type="hidden" name="articulos_proveedor_descuento[@%db:Compra_articulos.id_articulo;%@]" value="@%db:Compra_articulos.descuento;%@" size="5" class="insertextnumeros"/>
 </td>
 <td class="texto" align="center" bgcolor="#DBE0E3"></td>
 <td class="texto" align="right"> <!--@%db:Compra_articulos.fabricante;%@-->
 @%db:Empresas_articulos.refencia;%@ <!-- como podemos ver nos sobran dos campos que son la referencia del articulo y un checkbox con la etiqueta de arriba, tambien nos falta la descripcion y el costo anual tambien falta el link al articulo parece ser-->
 </td>
 <td bgcolor="#DBE0E3"></td>
 </tr>
 <tr> <td height="3"></td>
 <td height="3" colspan="3"></td>
 <td height="3"></td>
 <td height="3" bgcolor="#DBE0E3"></td>
 <td height="3"></td>
 <td height="3"></td>
 <td height="3"></td>
 <td height="3"></td>
 <td height="3"></td>
 <td height="3"></td>
 <td height="3"></td>
 <td height="3"></td>
 <td height="3"></td>
 <td height="3"></td>
 </tr>
 <tr> <td height="1" colspan="16" bgcolor="#DBE0E3"></td>
 </tr>
 @%end-where:%@ <tr align="center"> <td height="22" colspan="16" bgcolor="#DBE0E3"></td>
 </tr>
 </table>
 </td>
 </tr>
 </form>
 </table>
 </td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" height="30">

 @%plt:botonera%@
 </td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" height="3"></td>
 </tr>
</table>

