@%where:tabla|Pedidos;where|Pedidos.id_agente = $id_agente_promocion and Pedidos.id_empresa = $id_empresa;%@
<!--@%db:Pedidos.id_factura;%@-->
@%if:hay_factura%@

@%else:%@

<form name="anyadir_al_pedido" action="../?seccion=hacer_pedido" method="post">
<input type="hidden" name="Anyadir" value="Anyadir">
<input type="hidden" name="identificador_pedido" value="@%db:Pedidos.id_pedido%@">
 <!--@%set:_id_documento=Pedidos.id_pedido%@--> 
@%where:tabla|Lineas_detalle;where|Lineas_detalle.id_pedido = $id_pedido;%@ 

<input type="hidden" name="array_numero[@%db:Lineas_detalle.id_articulo;%@]" value="@%db:Lineas_detalle.cantidad;%@">

 @%end-where:%@

</form>

@%end-if:%@
<table width="647" border="0" cellspacing="0" cellpadding="0">

 <tr> <td height="22" align="right" bgcolor="#CCD2D7"> <table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td width="6" align="center" ></td>
 <td class="titocho" width="250" >&gt; PEDIDO :@%db:Pedidos.nombre;%@
 </td>
 <td align="right" colspam="4"><a href="#" onclick=window.open('?@%func:querystring%@&imprimir=1'); return false; class="accesos">Imprimer</a></td>
 <td width="46" align="center" ><a href="javascript:history.go(-1);" class="accesos">Tourner</a></td>
 </tr>
 </table>
 </td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" height="3"></td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" height="13"></td>
 </tr>
 <tr> <td> @%plt:Datos_Generales%@ </td>
<tr>
<td> @%plt:Lineas_Detalle%@ </td>
</tr>
<tr>
<td> @%plt:Totales_Pedido%@ </td>
</tr>
<tr>
<td> @%plt:Facturacion%@ </td>
</tr>
 </table>

 
 <table width="644">
 <tr>
 <td>
 @%plt:incidencias%@
 </td>
 </tr>
</table>





@%end-if:%@


 @%end-where:%@

