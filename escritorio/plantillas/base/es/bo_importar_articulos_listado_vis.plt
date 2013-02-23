<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#FFFFFF" height="30">
 @%plt:botonera%@ </td>
 </tr>
 <tr> <td height="22" bgcolor="#FFFFFF"> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <form name="bo_importar_articulos" method="post" action=""> 
<input type="hidden" name="accion_ejecutar" value="0">
<tr align="right" bgcolor="#CCD2D7"> <td colspan="14" height="22" class="texto" align="right"><a href="" onclick="return onHRefClick('bo_articulos','accion_ejecutar','Borrar');" class="accesos"> </a></td>
 </tr>
 <tr > <td colspan="14" height="22" class="etiqueta" align="right"> 

@%where:tabla|Articulos;nombre|busc;no_results|1;grupo|Articulos.id_articulo;%@ @%if:articulo_empresa%@ 
 <table width="644" border="0" cellspacing="0" cellpadding="0" class="etiqueta">
 <tr> 
<td bgcolor="#DBE0E3" width="24" height="22"></td>
<td bgcolor="#DBE0E3" colspan="3">Nombre</td>
<td width="1"></td>
<td bgcolor="#DBE0E3" align="center" width="100">Uds Bulto</td>
<td width="1"></td>
<td bgcolor="#DBE0E3" width="65" align="center">Stock mínimo</td>
<td width="1"></td>
<td bgcolor="#DBE0E3" align="center" width="65">Stock máximo</td>
<td width="1"></td>
<td bgcolor="#DBE0E3" width="65" align="center">Stk Est.</td>
<td bgcolor="#DBE0E3" width="1"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="22"> </td>
<td colspan="3">@%if:AllowedLink;modif_articulos;%@<a href="?seccion=modif_articulos&id_articulo=@%db:Articulos.id_articulo;%@" class="accesos">@%db:Articulos.nombre;%@</a></td>
@%end-if:%@
<td bgcolor="#DBE0E3"></td>
<td align="center">
 <input type="text" name="registro[@%db:Articulos.id_articulo;%@][unidades_bulto]" size="8" class="insertext">
</td>
<td bgcolor="#DBE0E3"></td>
<td align="center">
 <input type="text" name="registro[@%db:Articulos.id_articulo;%@][stock_minimo]" size="8" class="insertext">
</td>
<td bgcolor="#DBE0E3"></td>
<td align="center">
 <input type="text" name="registro[@%db:Articulos.id_articulo;%@][stock_maximo]" size="8" class="insertext">
</td>
<td bgcolor="#DBE0E3"></td>
<td align="center">
 <input type="text" name="registro[@%db:Articulos.id_articulo;%@][stock_ficticio]" size="8" class="insertext">
</td>
<td bgcolor="#DBE0E3"></td>
 </tr>
 <tr> 
<td bgcolor="#DBE0E3" height="22"></td>
<td bgcolor="#DBE0E3">Descripción</td>
<td width="1"></td>
<td bgcolor="#DBE0E3" align="center" width="110">{label_tpvfabstock}}</td>
<td></td>
<td bgcolor="#DBE0E3" align="center">Referencia</td>
<td></td>
<td bgcolor="#DBE0E3" align="center">Precio 1</td>
<td></td>
<td bgcolor="#DBE0E3" align="center">Precio 2</td>
<td></td>
<td bgcolor="#DBE0E3" align="center">Precio 3</td>
<td bgcolor="#DBE0E3"></td>
 </tr>
 <tr> 
<td bgcolor="#DBE0E3" height="22"></td>
<td>
 <input type="text" name="registro[@%db:Articulos.id_articulo;%@][descripcion]" size="35" class="insertext">
</td>
<td bgcolor="#DBE0E3"></td>
<td align="center">
 <input type="checkbox" name="registro[@%db:Articulos.id_articulo;%@][frecuente]" value="1">
 <input type="checkbox" name="registro[@%db:Articulos.id_articulo;%@][fabricacion]" value="1">
 <input type="checkbox" name="registro[@%db:Articulos.id_articulo;%@][stock]" value="1">

</td>
<td bgcolor="#DBE0E3"></td>
<td align="center">
<input type="text" name="registro[@%db:Articulos.id_articulo;%@][referencia]" size="15" class="insertext">
</td>
<td bgcolor="#DBE0E3"></td>
<td align="center"><input type="text" name="registro[@%db:Articulos.id_articulo;%@][precio_costo]" size="8" class="insertext"></td>
<td bgcolor="#DBE0E3"></td>
<td align="center"><input type="text" name="registro[@%db:Articulos.id_articulo;%@][precio_standard]" size="8" class="insertext"></td>
<td bgcolor="#DBE0E3"></td>
<td align="center"><input type="text" name="registro[@%db:Articulos.id_articulo;%@][precio_venta]" size="8" class="insertext"></td>
<td bgcolor="#DBE0E3"></td>
 </tr>
 <tr> 
<td bgcolor="#DBE0E3" colspan="13" height="1"></td>
 </tr>
 <tr>
<td colspan="13" height="5"></td>
 </tr>
</table>

 @%else:%@
 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td colspan="3" height="5"></td>
 </tr>
 <tr> <td colspan="3" height="1" bgcolor="#DBE0E3"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" width="24"></td>
 <td class="etiqueta" height="22">@%if:AllowedLink;modif_articulos;%@<a href="?seccion=modif_articulos&id_articulo=@%db:Articulos.id_articulo;%@" class="accesos">@%db:Articulos.nombre;%@</a></td>
 @%end-if:%@
 <td bgcolor="#DBE0E3" width="1"></td>
 </tr>
 <tr> <td colspan="3" height="1" bgcolor="#DBE0E3"></td>
 </tr>
 <tr> <td colspan="3" height="5"></td>
 </tr>
 </table>

 @%end-if:%@ 
 @%end-where:%@ </td>
 </tr>
 <tr align="right" bgcolor="#CCD2D7"> <td colspan="14" height="22" class="etiqueta" align="center"></td>
 </tr>
</form>
 </table>
 </td>
 </tr>
 <tr> <td height="30">
@%plt:botonera%@ 
</td>
 </tr>
</table>


