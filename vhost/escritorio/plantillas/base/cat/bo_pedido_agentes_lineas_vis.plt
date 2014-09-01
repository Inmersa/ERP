 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td colspan="13" height="30"></td>
 </tr>
 <tr> <td colspan="13" height="22" bgcolor="#CCD2D7"> <table width="100%" border="0" cellspacing="0" cellpadding="0">
 <tr> <td width="6"></td>
 <td width="320"></td>
 <td align="center">
@%if:hay_factura%@

@%else:%@



@%end-if:%@

</td>
 <td align="right">

@%if:hay_factura%@

@%else:%@




@%end-if:%@

 </td>
</table></td>
 </tr>
 </table>
 </td>
 </tr>

<table width="647" border="0" cellspacing="0" cellpadding="0">

<tr> <td bgcolor="#DBE0E3" width="20" height="22"></td>
 <td bgcolor="#DBE0E3" height="20" class="etiqueta">Codi</td>
 <td width="1" height="20"></td>
 <td bgcolor="#DBE0E3" align="center" height="20" class="etiqueta" width="60">Quantitat</td>
 <td width="1" height="20"></td>
 <td bgcolor="#DBE0E3" align="center" height="20" class="etiqueta" width="60">Preu</td>
 <td width="1" height="20"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center" width="60">IVA</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" height="20" class="etiqueta" align="center" width="60"><span class="texto">%</span>Desc. </td>
 <td width="1" height="20"></td>
 <td bgcolor="#DBE0E3" align="center" height="20" class="etiqueta" width="110">Import</td>
 <td width="1" bgcolor="#DBE0E3" height="20"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3"></td>
 <td colspan="5"></td>
 <td></td>
 <td></td>
 <td bgcolor="#DBE0E3"></td>
 <td colspan="4"></td>
 </tr>

<form name="borrar_del_pedido" action="../?seccion=bo_pedido_cliente" method="post">
<input type="hidden" name="Borrar" value="Borrar">
<input type="hidden" name="identificador_pedido" value="@%db:Pedidos.id_pedido%@">

 @%where:tabla|Lineas_detalle;where|Pedidos.id_pedido = $id_pedido and Pedidos.id_empresa = $id_empresa;not_ruta_path|IVAs;%@ <!--chapuza por culpa de ruta @%db:Lineas_detalle.id_articulo;%@-->
 <!-- aqui empieza el registro -->
 <tr> <td bgcolor="#DBE0E3"></td>
 <td colspan="5" ></td>
 <td></td>
 <td></td>
 <td bgcolor="#DBE0E3"></td>
 <td colspan="3"></td>
 <td></td>
 </tr>
 <tr> 
 <td bgcolor="#DBE0E3" height="22"> <!-- este checkbox solo va si el pedido no esta consolidado (lo mismo pal enlace de añadir>-->
 </td>
 <td >@%if:AllowedLink;modif_articulos;%@<a href="?seccion=modif_articulos&id_articulo=@%db:Lineas_detalle.id_articulo;%@" class="accesos">@%db:Articulos.nombre%@</a></td>
 @%end-if:%@
 <td bgcolor="#DBE0E3"></td>
 <td class="texto" align="center">@%db:Lineas_detalle.cantidad;%@</td>
 <td bgcolor="#DBE0E3"></td>
 <td class="texto" align="center">@%db:Lineas_detalle.precio_articulo;%@</td>
 <td bgcolor="#DBE0E3"></td>
 <td align="center" class="texto">@%db:Tipos_IVA.porcentaje;%@</td>
 <td bgcolor="#DBE0E3"> </td>
 <td class="texto" align="center"> <!-- @%db:Lineas_detalle.monto;%@-->
 <!-- @%db:Lineas_detalle.descuento;%@-->
 @%func:descripcion_descuento%@</td>
 <td bgcolor="#DBE0E3"></td>
 <td class="texto" align="right">@%db:Lineas_detalle.monto_total;%@ &gt; Euro</td>
 <td bgcolor="#DBE0E3"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3"></td>
 <td colspan="5"></td>
 <td></td>
 <td></td>
 <td bgcolor="#DBE0E3"></td>
 <td colspan="4"></td>
 </tr>
 <tr> <td colspan="13" height="1" bgcolor="#DBE0E3"></td>
 </tr>
 <!-- aqui termina el registro -->

 @%end-where:%@ </form>

 </table>
