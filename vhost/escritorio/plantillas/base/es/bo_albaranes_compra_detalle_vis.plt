<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#FFFFFF" height="30">
@%plt:botonera%@
</td>
 </tr>
 <tr> <td height="30"> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr align="center"> <td colspan="4" height="22" > 
 @%where:tabla|Albaranes;nombre|busc;no_results|1;order|Albaranes.referencia desc;%@
 <!-- aqui empieza el registro nombre del pedido @%db:Pedidos.nombre;%@
Campo fecha = @%db:colocar_fecha{Albaranes.fecha_recepcion};%@
Campo referencia externa = @%db:Albaranes.referencia_externa};%@
-->
 <table width="644" border="0" cellspacing="0" cellpadding="0">

 <tr> <td bgcolor="#DBE0E3" height="22" width="1"></td>
 <td bgcolor="#DBE0E3" height="22" class="etiqueta">Almac�n</td>
 <td bgcolor="#FFFFFF" height="22" width="1"></td>
 <td bgcolor="#DBE0E3" height="22" class="etiqueta" align="center">Transportista</td>
 <td bgcolor="#FFFFFF" height="22" width="1"></td>
 <td bgcolor="#DBE0E3" height="22" class="etiqueta" align="center" width="125">Ref. Pedido </td>
 <td bgcolor="#FFFFFF" height="22" width="1"></td>
 <td bgcolor="#DBE0E3" height="22" class="etiqueta" align="center" width="125">Ref Albar�n </td>
 <td bgcolor="#DBE0E3" height="22" width="1"></td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" height="1" width="1"></td>
 <td bgcolor="#FFFFFF" height="1"></td>
 <td bgcolor="#FFFFFF" height="1" width="1"></td>
 <td bgcolor="#FFFFFF" height="1"></td>
 <td bgcolor="#FFFFFF" height="1" width="1"></td>
 <td bgcolor="#FFFFFF" height="1"></td>
 <td bgcolor="#FFFFFF" height="1" width="1"></td>
 <td bgcolor="#FFFFFF" height="1"></td>
 <td bgcolor="#FFFFFF" height="1" width="1"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="22" width="1"></td>
 <td bgcolor="#FFFFFF" height="22" class="texto">@%db:Almacenes.nombre;%@</td>
 <td bgcolor="#DBE0E3" height="22" width="1"></td>
 <td bgcolor="#FFFFFF" height="22" align="center" class="texto">@%db:Transportistas.nombre;%@</td>
 <td bgcolor="#DBE0E3" height="22" width="1"></td>
 <td bgcolor="#FFFFFF" height="22" align="center"><a class="accesos" href="?seccion=bo_pedido_proveedor&id_pedido=@%db:Pedidos.id_pedido;%@">@%db:Pedidos.referencia%@</a></td>
 <td bgcolor="#DBE0E3" height="22" width="1"></td>
 <td bgcolor="#FFFFFF" height="22" align="center"><a class="accesos" href="?seccion=bo_albaran_almacen&id_albaran=@%db:Albaranes.id_albaran;%@">@%db:Albaranes.referencia;%@</a></td>
 <td bgcolor="#DBE0E3" height="22" width="1"></td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" height="1" width="1"></td>
 <td bgcolor="#FFFFFF" height="1"></td>
 <td bgcolor="#FFFFFF" height="1" width="1"></td>
 <td bgcolor="#FFFFFF" height="1"></td>
 <td bgcolor="#FFFFFF" height="1" width="1"></td>
 <td bgcolor="#FFFFFF" height="1"></td>
 <td bgcolor="#FFFFFF" height="1" width="1"></td>
 <td bgcolor="#FFFFFF" height="1"></td>
 <td bgcolor="#FFFFFF" height="1" width="1"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="22" width="1"></td>
 <td bgcolor="#DBE0E3" height="22" class="etiqueta" colspan="3">Proveedor</td>
 <td bgcolor="#FFFFFF" height="22" width="1"></td>
 <td bgcolor="#DBE0E3" height="22" class="etiqueta" align="center">Fecha </td>
 <td bgcolor="#FFFFFF" height="22" width="1"></td>
 <td bgcolor="#DBE0E3" height="22" class="etiqueta" align="center">Estado</td>
 <td bgcolor="#DBE0E3" height="22" width="1"></td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" height="1" width="1"></td>
 <td bgcolor="#FFFFFF" height="1"></td>
 <td bgcolor="#FFFFFF" height="1" width="1"></td>
 <td bgcolor="#FFFFFF" height="1"></td>
 <td bgcolor="#FFFFFF" height="1" width="1"></td>
 <td bgcolor="#FFFFFF" height="1"></td>
 <td bgcolor="#FFFFFF" height="1" width="1"></td>
 <td bgcolor="#FFFFFF" height="1"></td>
 <td bgcolor="#FFFFFF" height="1" width="1"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="22" width="1"></td>
 <td bgcolor="#FFFFFF" height="22" colspan="3" class="texto">@%db:Proveedores.nombre;%@</td>
 <td bgcolor="#DBE0E3" height="22" width="1"></td>
 <td bgcolor="#FFFFFF" height="22" align="center" class="texto">@%db:colocar_fecha{Albaranes.fecha};%@</td>
 <td bgcolor="#DBE0E3" height="22" width="1"></td>
 <td bgcolor="#FFFFFF" height="22" align="center" class="texto">@%func:estado_albaran_compra%@</td>
 <td bgcolor="#DBE0E3" height="22" width="1"></td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" height="1" width="1"></td>
 <td bgcolor="#FFFFFF" height="1" width="200"></td>
 <td bgcolor="#FFFFFF" height="1" width="1"></td>
 <td bgcolor="#FFFFFF" height="1"></td>
 <td bgcolor="#FFFFFF" height="1" width="1"></td>
 <td bgcolor="#FFFFFF" height="1"></td>
 <td bgcolor="#FFFFFF" height="1" width="1"></td>
 <td bgcolor="#FFFFFF" height="1"></td>
 <td bgcolor="#FFFFFF" height="1" width="1"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="1" width="1"></td>
 <td bgcolor="#DBE0E3" height="1" width="200"></td>
 <td bgcolor="#DBE0E3" height="1" width="1"></td>
 <td bgcolor="#DBE0E3" height="1" width=""></td>
 <td bgcolor="#DBE0E3" height="1" width="1"></td>
 <td bgcolor="#DBE0E3" height="1" width="132"></td>
 <td bgcolor="#DBE0E3" height="1" width="1"></td>
 <td bgcolor="#DBE0E3" height="1" width="83"></td>
 <td bgcolor="#DBE0E3" height="1" width="1"></td>
 </tr>
 <tr align="right"> <td colspan="9" height="10" class="etiqueta" bgcolor="#FFFFFF"></td>
 </tr>
 </table>
@%end-where:%@
 </td>
 </tr>

 <tr bgcolor="#CCD2D7" align="center"> <td colspan="4" height="22" bgcolor="#CCD2D7"></td>
 </tr>
 </table>
 </td>
 </tr>
 <tr> <td height="30">
@%plt:botonera%@
</td>
 </tr>
</table>



