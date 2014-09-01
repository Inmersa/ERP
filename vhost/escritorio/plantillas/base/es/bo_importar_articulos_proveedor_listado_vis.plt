<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td height="30">
@%plt:botonera%@
</td>
 </tr>
 <tr> <td height="22" > 
<form name="importar_articulos_proveedor" method="post" action="">
 
@%where:tabla|Articulos;nombre|busc;no_results|1;%@

<!-- @%db:Articulos.observaciones;%@ -->
 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#91C800" height="22" width="1"></td>
 <td bgcolor="#91C800" height="22" class="etiqueta" width="238">Nombre</td>
 <td height="22" width="1"></td>
 <td bgcolor="#DBE0E3" height="22" class="etiqueta" align="center" width="150">Cod. barras</td>
 <td height="22" width="1"></td>
 <td bgcolor="#DBE0E3" height="22" class="etiqueta" align="center" width="125" colspan="3">Fecha alta </td>
 <td height="22" width="1"></td>
 <td bgcolor="#DBE0E3" height="22" class="etiqueta" align="center" width="125" colspan="3">Fecha baja </td>
 <td bgcolor="#DBE0E3" height="22" width="1"></td>
 </tr>
 <tr> <td height="1" colspan="13"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="22" width="1"></td>
 <td height="22">@%if:AllowedLink;modif_articulos;%@<a href="?seccion=modif_articulos&id_articulo=@%db:Articulos.id_articulo;%@" class="accesos">@%db:Articulos.nombre;%@</a></td>
 @%end-if:%@
<td bgcolor="#DBE0E3" height="22" width="1"></td>
 <td height="22" align="center" class="texto">@%db:Articulos.codigo_barras;%@</td>
 <td bgcolor="#DBE0E3" height="22" width="1"></td>
 <td height="22" colspan="3" align="center" class="texto">@%db:colocar_fecha{Articulos.fecha_alta};%@</td>
 <td bgcolor="#DBE0E3" height="22" width="1"></td>
 <td height="22" colspan="3" align="center" class="texto">@%db:colocar_fecha{Articulos.fecha_baja};%@</td>
 <td bgcolor="#DBE0E3" height="22" width="1"></td>
 </tr>

 @%if:articulo_proveedor%@ 
 <tr> <td height="1" colspan="13"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="22" width="1"></td>
 <td bgcolor="#DBE0E3" height="22" class="etiqueta" colspan="3">Descripción</td>
 <td height="22" width="1"></td>
 <td bgcolor="#DBE0E3" height="22" class="etiqueta" align="center" width="62">Precio</td>
 <td height="22" width="1"></td>
 <td bgcolor="#DBE0E3" height="22" class="etiqueta" align="center" width="62">Ref.</td>
 <td height="22" width="1"></td>
 <td bgcolor="#DBE0E3" height="22" class="etiqueta" align="center" width="62">Dto</td>
 <td height="22" width="1"></td>
 <td bgcolor="#DBE0E3" height="22" class="etiqueta" align="center" width="62">Fabric.</td>
 <td bgcolor="#DBE0E3" height="22" width="1"></td>
 </tr>
 <tr> <td height="1" colspan="13"></td>
 </tr>
 <tr> <td height="22" width="1" bgcolor="#DBE0E3"></td>
 <td height="22" colspan="3" class="texto"> @%db:Articulos.descripcion;%@</td>
 <td bgcolor="#DBE0E3" height="22" width="1"></td>
 <td height="22" align="center"> @%func:precio_costo%@<input type="hidden" name="articulos_proveedor_precio[@%db:Articulos.id_articulo;%@]" size="9" maxlength="9" class="insertext" value="@%func:precio_costo%@">
 </td>
 <td bgcolor="#DBE0E3" height="22"></td>
 <td height="22" align="center"> <input type="text" name="articulos_proveedor_referencia[@%db:Articulos.id_articulo;%@]" size="9" maxlength="9" class="insertext">
 </td>
 <td bgcolor="#DBE0E3" height="22" width="1"></td>
 <td height="22" align="center" class="texto"> <input type="text" name="articulos_proveedor_descuento[@%db:Articulos.id_articulo;%@]" size="4" maxlength="4" class="insertext">
 % </td>
 <td bgcolor="#DBE0E3" height="22" width="1"></td>
 <td height="22" align="center"> <input type="checkbox" name="articulos_proveedor_fabricante[@%db:Articulos.id_articulo;%@]" value="1">
 </td>
 <td bgcolor="#DBE0E3" height="22" width="1"></td>
 </tr>
 <tr> <td height="1" colspan="13"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="1" colspan="13"></td>
 </tr>
 @%else:%@ 

 <tr> <td height="1" colspan="13"></td>
 </tr>
 <tr> <td height="1" colspan="13"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="1" colspan="13"></td>
 </tr>
 @%end-if:%@ 
 </table>
 @%end-where:%@ 
 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr>
 <td height="22"></td>
 </tr>
 <tr>
 <td height="22" align="center" bgcolor="#CCD2D7"> <input type="hidden" name="accion_ejecutar" value="Importar">
 </td>
 </tr>
</table>
</form>
</td>
 </tr>
 <tr> <td height="30">
@%plt:botonera%@
</td>
 </tr>
 <tr> <td height="3"></td>
 </tr>
</table>

