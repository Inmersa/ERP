<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#FFFFFF" height="30">

@%plt:botonera%@
</td>
 </tr>
 <tr> <td height="22" bgcolor="#FFFFFF">
<form name="bo_inventario_articulos" method="post" action="">
 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr bgcolor="#CCD2D7"> 
 <td colspan="17" height="22"></td>
 </tr>
 <tr> 
 <td bgcolor="#DBE0E3" width="22"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" width="190">Article</td>
 <td width="1" align="center"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center" width="50">Lot</td>
 <td width="1" align="center"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center">Floor</td>
 <td width="1" ></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center">Corridor</td>
 <td class="etiqueta" align="center" width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center">Row</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center">Column</td>
 <td width="1" align="center"></td>
 <td class="etiqueta" bgcolor="#DBE0E3" align="center">Amount</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" height="22" align="center" class="etiqueta" width="100">Use-by date </td>
 <td bgcolor="#DBE0E3" width="1"></td>
 </tr>
 <tr> <td colspan="17" height="1"></td>
 </tr>
 @%where:tabla|Localizacion_articulos;nombre|busc;no_results|1;order|Localizacion_articulos.planta , Localizacion_articulos.pasillo , Localizacion_articulos.fila , Localizacion_articulos.columna;%@
 <tr> 
 <td bgcolor="#DBE0E3" width="22"> </td>
 <td class="texto">@%if:allowed-link;modif_articulos;%@<a href="?seccion=modif_articulos&id_articulo=@%db:Localizacion_articulos.id_articulo;%@" class="accesos">@%db:Articulos.nombre;%@</a></td>
@%end-if:%@
 <td bgcolor="#DBE0E3"></td>
 <td align="center" class="texto">@%db:Localizacion_articulos.lote;%@</td>
 <td bgcolor="#DBE0E3"></td>
 <td align="center" class="texto" bgcolor="#DBE0E3"> <input type="text" name="registro_planta[]" value="@%db:Localizacion_articulos.planta;%@" class="insertext" size="5">
 </td>
 <td ></td>
 <td align="center" class="texto" bgcolor="#DBE0E3"> <input type="text" name="registro_pasillo[]" value="@%db:Localizacion_articulos.pasillo;%@" class="insertext" size="5">
 </td>
 <td align="center" class="texto"></td>
 <td align="center" class="texto" bgcolor="#DBE0E3"> <input type="text" name="registro_fila[]" value="@%db:Localizacion_articulos.fila;%@" class="insertext" size="5">
 </td>
 <td ></td>
 <td align="center" class="texto" bgcolor="#DBE0E3"> <input type="text" name="registro_columna[]" value="@%db:Localizacion_articulos.columna;%@" class="insertext" size="5">
 </td>
 <td></td>
 <td align="center" class="texto" bgcolor="#DBE0E3"> <input type="text" name="registro_cantidad[]" value="@%db:Localizacion_articulos.cantidad;%@" class="insertext" size="8">
 </td>
 <td ></td>
 <td align="center" height="22" class="texto" bgcolor="#DBE0E3"> 
 <input type="text" name="registro_fecha_caducidad[]" value="@%db:colocar_fecha{Localizacion_articulos.fecha_caducidad};%@" class="insertextnumeros" size="12" maxlength="10" >
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
<input type="hidden" name="registro_fecha_alta[]" value="@%db:colocar_fecha{Localizacion_articulos.fecha_alta};%@">
<input type="hidden" name="registro_fecha_baja[]" value="@%db:colocar_fecha{Localizacion_articulos.fecha_baja};%@">
<input type="hidden" name="registro_lote[]" value="@%db:Localizacion_articulos.lote;%@">
<input type="hidden" name="registro_id[]" value="@%db:Localizacion_articulos.id_articulo;%@">
<input type="hidden" name="registro_articulo[]" value="@%db:Localizacion_articulos.id_articulo;%@">

 @%end-where:%@


<input type="hidden" name="accion_ejecutar" value="j">

 <tr bgcolor="#CCD2D7" align="center"> 
 <td height="22" colspan="17" class="texto"></td>
 </tr>
 </table>
 </form></td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" height="30">
 @%plt:botonera%@
 </td>
 </tr>
 </table>




