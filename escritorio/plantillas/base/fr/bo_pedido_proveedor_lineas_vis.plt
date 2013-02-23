<table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td colspan="13" height="30"></td>
 </tr>
 <tr> <td colspan="13" height="22" bgcolor="#CCD2D7"> <table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td width="6"></td>
 <td width="320"></td>
 <td align="center">
@%if:hay_factura%@
 </td><td align="right">
@%else:%@
 <a href="?seccion=hacer_pedido" class="accesos">{{bo_pedido_proveedor_lineas_vis.plt0}}</a>
 </td><td align="right"><a href="" onclick="return onHRefClick('pedido','accion_ejecutar','Borrar');" class="accesos">Effacer(s)</a>
@%end-if:%@
 </td>
 </table></td>
 </tr>
 </table>
 <table width="647" border="0" cellspacing="0" cellpadding="0">

 <tr> <td colspan="13" height="1"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" width="20" height="22"></td>
 <td bgcolor="#DBE0E3" height="20" class="etiqueta">Code</td>
 <td width="1" height="20"></td>
 <td bgcolor="#DBE0E3" align="center" height="20" class="etiqueta" width="60">Quantite</td>
 <td width="1" height="20"></td>
 <td bgcolor="#DBE0E3" align="center" height="20" class="etiqueta" width="60">Prix</td>
 <td width="1" height="20"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center" width="60">TVA</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" height="20" class="etiqueta" align="center" width="60"><span class="texto">%</span>Rem. </td>
 <td width="1" height="20"></td>
 <td bgcolor="#DBE0E3" align="center" height="20" class="etiqueta" width="110">Montant</td>
 <td width="1" bgcolor="#DBE0E3" height="20"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3"></td>
 <td colspan="5"></td>
 <td></td>
 <td></td>
 <td bgcolor="#DBE0E3"></td>
 <td colspan="4"></td>
 </tr>

 @%set:caracteres_linea_observaciones=130;%@
 @%where:nodb|nodb_order_details;contador|count;%@ <!--
 @%set:num_detalles=count;%@
 @%db:medir_observaciones{observaciones}%@
 -->
 <!-- aqui empieza el registro -->
 <tr> <td bgcolor="#DBE0E3" width="10"></td>
 <td colspan="5" ></td>
 <td></td>
 <td></td>
 <td bgcolor="#DBE0E3"></td>
 <td colspan="3"></td>
 <td></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="22"> <!-- este checkbox solo va si el pedido no esta consolidado (lo mismo pal enlace de añadir>-->
 <input type="checkbox" name="borrar_articulos[]" value="@%db:idx_detalle%@">
 </td>
 <td > <a href="?seccion=modif_articulos&id_articulo=@%db:id_articulo;%@" class="accesos">@%db:nombre%@</a></td>
 <td bgcolor="#DBE0E3"></td>
 <td class="texto" align="center">@%db:cantidad;%@</td>
 <td bgcolor="#DBE0E3"></td>
 <td class="texto" align="center">@%db:precio;%@</td>
 <td bgcolor="#DBE0E3"></td>
 <td align="center" class="texto">@%db:porcentaje;%@</td>
 <td bgcolor="#DBE0E3"> </td>
 <td class="texto" align="center"> <!-- @%db:monto;%@ -->
 <!-- @%db:descuento;%@ -->
 @%db:tipo_descuento%@</td>
 <td bgcolor="#DBE0E3"></td>
 <td class="texto" align="right">@%db:base_imponible;%@ &gt; Euro</td>
 <td bgcolor="#DBE0E3"></td>
 </tr>
 @%if:hay_comentario%@
 <tr> <td colspan="13" height="1" bgcolor="#DBE0E3"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="22"></td>
 <td colspan="11" bgcolor="#FFFFFF" height="22" class="texto">
 @%db:observaciones%@</td>
 <td bgcolor="#DBE0E3"></td>
 </tr>
 @%else:%@
 @%end-if:%@
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
 @%end-where:%@ 
 </table>