 <br>
 
<table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> 
<td height="22" align="left" bgcolor="#CCD2D7" class="etiqueta"> Current Selections</td>
<td class="etiqueta" bgcolor="#CCD2D7">
 @%where:nodb|nodb_reciever_data;%@
@%db:razon_social%@</td>
<td class="etiqueta" bgcolor="#CCD2D7">@%db:id%@</td>
 @%end-where:%@

 </td></tr>
 <tr> 
<td> </td>
 </tr>
 <tr> 
<td colspan="3"> 
 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <form name="cesta" method="post" action="?seccion=ticket_print">
 <tr> <td width="20" bgcolor="#DBE0E3" height="22"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" colspan="2">Article </td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="left" width="250">Brand</td>
 <td width="1"></td>
 <td align="center" class="etiqueta" bgcolor="#DBE0E3">Amount</td>
 <td width="1"></td>
 <td align="center" class="etiqueta" bgcolor="#DBE0E3">Price</td>
 <td width="1" bgcolor="#DBE0E3"></td>
 </tr>
@%where:nodb|nodb_order_details;%@
 <tr> <td bgcolor="#DBE0E3" height="2"></td>
 <td colspan="9"></td>
 </tr>

 <tr> <input type="hidden" name="array_detalle[@%db:id_articulo%@]" value="@%db:id_detalle%@">
 <td bgcolor="#DBE0E3" valign="top" height="20"> 
<input type="checkbox" name="articulos_confirmados[@%db:idx_detalle;%@]" value="@%db:idx_detalle;%@" checked>
<input type="hidden" name="articulos_cesta[@%db:idx_detalle;%@]" value="@%db:idx_detalle;%@" >
 </td>
 <td width="4"></td>
 <td><a href="?seccion=modif_articulos&id_articulo=@%db:id_articulo;%@" class="accesos">@%db:nombre;%@</a></td>
 <td bgcolor="#DBE0E3"></td>
 <td class="texto">@%db:nombre_marca;%@</td>
 <td bgcolor="#DBE0E3"></td>
 <td align="center" valign="middle" height="22" class="texto"> 
 @%if:modificable%@
 <input type="text" name="array_numero[@%db:idx_detalle;%@]" size="6"
 value="@%db:cantidad;%@" class="insertext" size="15"/>
 @%else:%@
 @%db:cantidad;%@
 @%end-if:%@
 </td>
 <td bgcolor="#DBE0E3"></td>
 <td align="center" valign="middle" class="texto"> <input type="text" name="array_precio[@%db:idx_detalle;%@]" size="6"
 value="@%db:precio;%@" class="insertext" size="15"/>
 </td>
 <td bgcolor="#DBE0E3"></td>
 </tr>
 <tr> <td height="1" bgcolor="#DBE0E3"></td>
 <td colspan="2"></td>
 <td ></td>
 <td></td>
 <td></td>
 <td ></td>
 <td ></td>
 <td ></td>
 <td ></td>
 </tr>
 <tr> <td height="1" colspan="10" bgcolor="#DBE0E3"></td>
 </tr>
 @%end-where:%@
 <tr> <td height="22" colspan="10" bgcolor="#FFFFFF"></td>
 </tr>
 <tr> <td colspan="10" bgcolor="#FFFFFF">
@%where:nodb|nodb_order_totals;%@
<table width="100%" border="0" cellspacing="0" cellpadding="0">
 <tr> <td colspan="5"><img src="imag/p.gif" width="100%" height="1"></td>
 </tr> <tr> <td align="right" width="1"><img src="imag/p.gif" width="1" height="15"></td>
 <td align="right" class="texto" bgcolor="#EBECED" width="30%">Gross Total:</td>
 <td width="1" height="15" class="texto"><img src="imag/p.gif" width="1" height="15"></td>
 <td height="15" class="texto" align="left">@%db:bruto%@</td>
 <td width="1"><img src="imag/p.gif" width="1" height="15"></td>
 </tr>
 <tr> <td align="right" width="1"><img src="imag/p.gif" width="1" height="15"></td>
 <td align="right" class="texto" bgcolor="#EBECED">Total Discounts:</td>
 <td height="15" class="texto"><img src="imag/p.gif" width="1" height="15"></td>
 <td height="15" class="texto" align="left">@%db:descuentos;%@</td>
 <td width="1"><img src="imag/p.gif" width="1" height="15"></td>
 </tr>
 <tr> <td align="right" width="1"><img src="imag/p.gif" width="1" height="15"></td>
 <td align="right" class="texto" bgcolor="#EBECED">Total Taxable Income:</td>
 <td height="15" class="texto"><img src="imag/p.gif" width="1" height="15"></td>
 <td height="15" class="texto" align="left">@%db:base_imponible%@</td>
 <td width="1"><img src="imag/p.gif" width="1" height="15"></td>
 </tr>
 <tr> <td align="right" width="1"><img src="imag/p.gif" width="1" height="15"></td>
 <td align="right" class="texto" bgcolor="#EBECED">Total Taxes:</td>
 <td height="15" class="texto"><img src="imag/p.gif" width="1" height="15"></td>
 <td height="15" class="texto" align="left">@%db:total_impuestos%@</td>
 <td width="1"><img src="imag/p.gif" width="1" height="15"></td>
 </tr>
 <tr> <td align="right" width="1"><img src="imag/p.gif" width="1" height="100%"></td>
 <td align="right" class="texto" bgcolor="#EBECED">Total amount:</td>
 <td height="15" class="texto"><img src="imag/p.gif" width="1" height="15"></td>
 <td height="15" class="texto" align="left">@%db:importe%@@%db:leyenda_divisa;%@</td>
 <td width="1"><img src="imag/p.gif" width="1" height="100%"></td>
 </tr>
 <tr> <td colspan="5"><img src="imag/p.gif" width="100%" height="1"></td>
 </tr> </table>
@%end-where:%@


</td>
 </tr>
 <tr> <td height="3" colspan="10" bgcolor="#FFFFFF"></td>
 </tr>
 <tr> <td height="22" colspan="10" bgcolor="#CCD2D7" align="center"><a href="" onclick="return SendFormToWindow('cesta','ticket_print&printit=1&reloadit=1','imprimirwin',400);"
class="accesos">Finish</a> 
<!--onclick="return SendFormToWindow('ticket_print&printit=1&reloadit=1',400);" class="accesos">Finish</a --> <a href="?@%env:QUERY_STRING%@&vaciar_pedido=1" class="accesos">Clear Order</a> <input type="hidden" name="Finalizar" value="Finalizar"></td>
 </tr>
</form>
 </table>
 </td>
 </tr>
 </table>
<br>
