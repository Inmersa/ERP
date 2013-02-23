<table width="644" border="0" cellspacing="0" cellpadding="0">
 <form name="generar_albaran" action="../?seccion=bo_albaranes_venta" method="post">
<input type="hidden" name="Generar" value="Generar">
<input type="hidden" name="identificador_pedido" value="@%db:Pedidos.id_pedido%@">
 <tr> <td height="22" colspan="6"></td>
 </tr>
<tr> <td height="22" bgcolor="#CCD2D7" class="etiqueta" colspan="4">Data to Create Delivery Note</td>
 <td height="22" bgcolor="#CCD2D7" class="etiqueta" colspan="2" align="right"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" class="texto" width="91" align="center">Carrier:</td>
 <td width="164"> <select name="id_transportista" class="insertext">

@%where:tabla|Transportistas;nolink|1;%@
 <option value="@%db:Transportistas.id_transportista;%@">@%db:Transportistas.nombre;%@</option>

@%end-where:%@

 </select>
 </td>
 <td bgcolor="#EBECED" align="right" width="91" class="texto">Ext. Ref.:</td>
 <td width="140"> <input type="text" name="ref_externa" class="insertext" size="16">
 </td>
 <td bgcolor="#EBECED" class="texto" width="97" align="right">Confirmation:</td>
 <td bgcolor="#EBECED" class="texto" width="61"> <input type="checkbox" name="confirmacion" value="1">
 </td>
 </tr>
 <tr bgcolor="#CCD2D7"> <td height="1" colspan="6"></td>
 </tr>
<tr > <td height="22" colspan="6"></td>
 </tr>

</form>
 </table>


 <form name="generar_factura" action="?seccion=bo_facturas_venta" method="post">

 <table width="644" border="0" cellspacing="0" cellpadding="0">
<input type="hidden" name="Generar" value="Generar">
<input type="hidden" name="identificador_pedido" value="@%db:Pedidos.id_pedido%@">
<input type="hidden" name="ratio_divisa" value="@%db:Pedidos.id_divisa;%@">
<tr> <td height="22" colspan="4"></td>
 </tr>
<tr> <td height="22" bgcolor="#CCD2D7" class="etiqueta" colspan="3">Data to Create Delivery Note</td>
 <td height="22" bgcolor="#CCD2D7" class="etiqueta" align="right"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" class="texto" width="120" align="right">Billing Serie:</td>
 <td> <select name="id_serie" class="insertext"> 
@%where:tabla|Series_facturacion;nolink|1;%@
 <option value="@%db:Series_facturacion.id_serie;%@">@%db:Series_facturacion.nombre;%@
- @%db:Series_facturacion.contador;%@</option>

@%end-where:%@

 </select>
 </td>
 <td bgcolor="#EBECED" align="right" class="texto">Ext. Ref.:</td>
 <td> <input type="text" name="ref_externa" class="insertext" size="16">
 </td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" colspan="4"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" class="texto" width="120" align="right">Method of payment:</td>
 <td class="insertext" colspan="3">

<select name="id_forma_pago" class="insertext">
@%where:tabla|Forma_pago;nolink|1;%@ <option value="@%db:Forma_pago.id_forma_pago;%@">@%db:Forma_pago.nombre;%@</option> 
 @%end-where:%@ 
 </select> </td>
 </tr>
 <tr> <td bgcolor="#EBECED" class="texto" width="120" align="right">Meter:</td>
 <td class="insertext" colspan="3">
<input type="text" name="contador" class="insertext" size="16">
</td>
 </tr>
 <tr> <td bgcolor="#EBECED" height="22" class="texto" align="right" valign="top">Notes:</td>
 <td colspan="3" height="1"> <textarea name="notas" cols="57" class="insertext"></textarea>
 </td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" colspan="4"></td>
 </tr> <tr> <td height="22" colspan="4"></td>
 </tr>
</form>
 </table>
