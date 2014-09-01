<table width="647" border="0" cellspacing="0" cellpadding="0">
..bo_localizacion_articulos_listado_vis.plt1}}tr> <td bgcolor="#FFFFFF" height="30"> 

@%plt:botonera%@

 </td>
 </tr>
 <tr> <td height="22" bgcolor="#FFFFFF"> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr align="right"> <td colspan="5" bgcolor="#CCD2D7" height="22" class="etiqueta"></td>
 </tr>
 <tr> <td class="etiqueta" height="22" bgcolor="#DBE0E3" width="100" align="right">Nome:<font color="#DBE0E3">..</font></td>
 <td class="texto" height="22" width="350">
      @%where:tabla|Articulos;nolink|1;where|id_articulo = $id_articulo_promocion;%@
      @%db:Articulos.nombre;%@ 
      @%end-where:%@

 </td>
 <td class="etiqueta" height="22" bgcolor="#DBE0E3" align="right" width="100">Stock Total:<font color="#DBE0E3">..</font> </td>
 <td class="texto" height="22" align="center">@%func:cantidad_total%@</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 </tr>
 <tr> <td height="1" bgcolor="#CCD2D7"></td>
 <td height="1" bgcolor="#CCD2D7"></td>
 <td height="1" bgcolor="#CCD2D7"></td>
 <td height="1" bgcolor="#CCD2D7"></td>
 <td height="1" width="1" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td colspan="5" height="1"></td>
 </tr>
 </table>
 <p></p>
 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr align="right"> <td colspan="17" bgcolor="#CCD2D7" height="22" class="etiqueta"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" class="etiqueta" align="center" height="22" width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center" height="22">Zona Armazém </td>
 <td bgcolor="#FFFFFF" class="etiqueta" align="center" height="22" width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center" height="22">Quantidade</td>
 <td bgcolor="#FFFFFF" class="etiqueta" align="center" height="22" width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center" height="22">Data de Validade</td>
 <td bgcolor="#FFFFFF" class="etiqueta" align="center" height="22" width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center" height="22">Data de Registo</td>
 <td bgcolor="#FFFFFF" width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center" height="22">Piso</td>
 <td bgcolor="#FFFFFF" width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center" height="22">Fila</td>
 <td bgcolor="#FFFFFF" width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center" height="22">Coluna</td>
 <td bgcolor="#FFFFFF" width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center" height="22">Corredor</td>
 <td width="1" align="center" bgcolor="#DBE0E3"></td>
 </tr>

 @%where:tabla|Localizacion_articulos;nombre|busc;no_results|1;%@ 
 <tr> <td colspan="17" height="1"></td>
 </tr>
 <tr> <td class="etiqueta" height="22" bgcolor="#DBE0E3"></td>
 <td height="22">@%if:AllowedLink;modif_almacenes_logicos;%@<a href="?seccion=modif_almacenes_logicos&id_almacen_logico=@%db:Almacenes_logicos.id_almacen_logico;%@" class="accesos">@%db:Almacenes_logicos.nombre;%@</a></td>
 @%end-if:%@
 <td height="22" bgcolor="#DBE0E3"></td>
 <td height="22" class="texto" align="center">@%db:Localizacion_articulos.cantidad;%@</td>
 <td height="22" bgcolor="#DBE0E3"></td>
 <td height="22" align="center" class="texto">@%db:colocar_fecha{Localizacion_articulos.fecha_caducidad};%@</td>
 <td height="22" bgcolor="#DBE0E3"></td>
 <td height="22" class="texto" align="center">@%db:colocar_fecha{Localizacion_articulos.fecha_alta};%@ </td>
 <td height="22" bgcolor="#DBE0E3"></td>
 <td height="22" class="texto" align="center">@%db:Localizacion_articulos.planta;%@ </td>
 <td height="22" bgcolor="#DBE0E3"></td>
 <td height="22" class="texto" align="center">@%db:Localizacion_articulos.fila;%@</td>
 <td height="22" bgcolor="#DBE0E3"></td>
 <td height="22" class="texto" align="center">@%db:Localizacion_articulos.columna;%@</td>
 <td height="22" bgcolor="#DBE0E3"></td>
 <td height="22" align="center" class="texto">@%db:Localizacion_articulos.pasillo;%@</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 </tr>
 <tr> <td height="1"></td>
 <td height="1"></td>
 <td height="1"></td>
 <td height="1"></td>
 <td height="1"></td>
 <td height="1"></td>
 <td height="1"></td>
 <td height="1"></td>
 <td height="1"></td>
 <td height="1"></td>
 <td height="1"></td>
 <td height="1"></td>
 <td height="1"></td>
 <td height="1"></td>
 <td height="1"></td>
 <td height="1"></td>
 <td height="1" width="1"></td>
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
 <td height="1" width="1" bgcolor="#CCD2D7"></td>
 </tr>

 @%end-where:%@ </table>
 </td>
 </tr>
 <tr> <td height="30">
@%plt:botonera%@
</td>
 </tr>
</table>

