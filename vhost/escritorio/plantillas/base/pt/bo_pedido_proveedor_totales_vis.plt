<table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td></td>
 <td></td>
 <td></td>
 </tr>
 <tr> <td valign="top"> <table width="100%" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#DBE0E3" height="20" class="etiqueta" align="center" width="1"></td>
 <td bgcolor="#DBE0E3" height="20" class="etiqueta" align="center">Valor Tributável</td>
 <td width="1" height="20"></td>
 <td bgcolor="#DBE0E3" align="center" height="20" class="etiqueta">%</td>
 <td width="1" height="20"></td>
 <td bgcolor="#DBE0E3" align="center" height="20" class="etiqueta"></td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" align="center" height="20" class="etiqueta" width="60">Sobretaxa Equivalente</td>
 <td width="1" height="20" bgcolor="#DBE0E3"></td>
 </tr>
 @%where:nodb|nodb_taxes_detail;%@ <tr> <td colspan="9" height="1"></td>
 </tr>
 <tr> <td height="24" bgcolor="#DBE0E3" ></td>
 <td height="24" align="center" class="texto">@%db:base_imponible;%@</td>
 <td bgcolor="#DBE0E3" height="24"></td>
 <td class="texto" align="center" height="24">@%db:porcentaje;%@ / @%db:porcentaje_recargo_equivalente%@
 %</td>
 <td bgcolor="#DBE0E3" height="24"></td>
 <td class="texto" align="center" height="24">@%db:recargo_iva;%@</td>
 <td class="texto" align="center" height="24" bgcolor="#DBE0E3"></td>
 <td class="texto" align="center" height="24">@%db:recargo_equivalente;%@</td>
 <td bgcolor="#DBE0E3" height="24"></td>
 </tr>
 <tr> <td colspan="9" height="1"></td>
 </tr>
 <tr> <td height="1" bgcolor="#DBE0E3" colspan="9"></td>
 </tr>
 @%end-where:%@ 
 </table>
 </td>
 <td width="40"></td>
 <td valign="top"> <table width="100%" border="0" cellspacing="0" cellpadding="0">
 <tr> <td width="1" height="20" bgcolor="#DBE0E3"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center" width="80">Total Bruto</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" height="20" class="etiqueta" align="center">%</td>
 <td width="1" height="20"></td>
 <td bgcolor="#DBE0E3" align="center" height="20" class="etiqueta" width="70">Montante</td>
 <td width="1" bgcolor="#DBE0E3" height="20"></td>
 </tr>
 @%where:nodb|nodb_discounts_detail;%@
 <tr> <td colspan="7" height="1"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="24"></td>
 <td align="center" class="texto" height="24">@%db:base_imponible;%@</td>
 <td bgcolor="#DBE0E3" height="24"> </td>
 <td class="texto" align="center" height="24">@%db:nombre%@ @%db:descuento%@ %</td>
 <td bgcolor="#DBE0E3" height="24"></td>
 <td class="texto" align="right" height="24">@%db:importe;%@ </td>
 <td bgcolor="#DBE0E3" height="24"></td>
 </tr>
 <tr> <td colspan="7" height="1"></td>
 </tr>
 <tr> <td height="1" bgcolor="#DBE0E3" colspan="7"></td>
 </tr>
 @%end-where:%@ 
 </table>
 </td>
 </tr>
 </table>
 @%where:nodb|nodb_order_totals;%@
 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td colspan="7" height="22"></td>
 </tr>
 <tr> <td width="195" rowspan="2"> <table width="194" border="0" cellspacing="0" cellpadding="0">
 <tr bgcolor="#DBE0E3"> <td colspan="2" height="1"></td>
 <td rowspan="11" width="1"></td>
 </tr>
 <tr>
 <td align="right" class="texto" width="100" bgcolor="#EBECED">Total Bruto:</td>
 <td height="24" class="texto"> @%db:bruto;%@</td>
 </tr>
 <tr>
 <td colspan="2" bgcolor="#DBE0E3" height="1" align="right"></td>
 </tr>
 <tr>
 <td align="right" class="texto" width="100" bgcolor="#EBECED">Desconto Total:</td>
 <td height="24" class="texto">
 @%db:descuentos%@</td>
 </tr>
 <tr>
 <td colspan="2" bgcolor="#DBE0E3" height="1" align="right"></td>
 </tr>
 <tr> <td align="right" class="texto" bgcolor="#EBECED" width="100">Total do Valor Tributável:</td>
 <td height="23" class="texto">
 @%db:base_imponible;%@ </td>
 </tr>
 <tr> <td colspan="2" bgcolor="#DBE0E3" height="1" align="right"></td>
 </tr>
 <tr> <td align="right" class="texto" bgcolor="#EBECED" width="100">Total de Impostos:</td>
 <td height="23" class="texto">
 @%db:total_impuestos%@ </td>
 </tr>
 <tr> <td colspan="2" bgcolor="#DBE0E3" height="1" align="right"></td>
 </tr>
 <tr> <td align="right" class="texto" bgcolor="#EBECED" width="100">Retenção:</td>
 <td height="23" class="texto">
 @%db:retenido%@ </td>
 </tr>
 <tr> <td colspan="2" bgcolor="#DBE0E3" height="1"></td>
 </tr>
</table>
 </td>
 <td width="11" bgcolor="#FFFFFF" valign="top" rowspan="2"> </td>
 <td width="6" bgcolor="#EBECED" valign="top" rowspan="2"></td>
 <td width="125" bgcolor="#EBECED" valign="middle" class="texto" height="22">Notas:</td>
 <td width="6" bgcolor="#EBECED" valign="top" rowspan="2"></td>
 <td width="11" rowspan="2"></td>
 <td width="162" valign="top" rowspan="2"> <table width="100%" border="0" cellspacing="0" cellpadding="0">
 <tr align="center"> <td colspan="3" bgcolor="#CCD2D7" class="etiqueta" height="22">Montante Total </td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" width="1"></td>
 <td height="22" align="right" width="99%" class="texto">@%db:importe;%@
 @%db:leyenda_divisa%@ </td>
 <td bgcolor="#DBE0E3" width="1"></td>
 </tr>
 <tr bgcolor="#DBE0E3"> <td colspan="3" height="1"></td>
 </tr>
 </table>
 </td>
 </tr>
 @%end-where:%@

 <tr> <td width="125" bgcolor="#EBECED" valign="top"> <!-- Notas del pedido -->
 <textarea name="pedido[observaciones]" cols="30" wrap="VIRTUAL" rows="4">@%db:observaciones;%@</textarea>
 </td>
 </tr>
 </table>


 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td height="22"></td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="22" align="right">

@%if:hay_factura%@
 <a href="?seccion=bo_facturas_pedido_venta&id_pedido=@%db:id_pedido;%@" class="accesos">Ver Facturas</a>
@%else:%@
 <a href="" onclick="document.forms['pedido'].submit();return false;" class="accesos">Guardar Alterações</a>
@%end-if:%@
 
@%if:hay_albaran%@
 <a href="?seccion=bo_albaranes_pedido&id_pedido=@%db:id_pedido;%@" class="accesos">Ver Guias de Remessa</a>
@%else:%@
@%end-if:%@
</td> 
</tr> 
</table>