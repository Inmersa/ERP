 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td colspan="17" height="30"></td>
 </tr>
 <tr> <td colspan="17" height="22" bgcolor="#CCD2D7"> <table width="100%" border="0" cellspacing="0" cellpadding="0">
 <tr> <td width="6"></td>
 <td width="419"></td>
 <td align="center" width="100"></td>
 </tr>
 </table>
 </td>
 </tr>
 <tr> <td colspan="17" height="1"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" width="20" height="22"></td>
 <td bgcolor="#DBE0E3" height="20" class="etiqueta">Name</td>
 <td width="1" height="20" bgcolor="#DBE0E3"></td>
 <td bgcolor="#DBE0E3" align="center" height="20" class="etiqueta" width="75"></td>
 <td width="1" height="20" bgcolor="#DBE0E3"></td>
 <td bgcolor="#DBE0E3" align="center" height="20" class="etiqueta" width="60"></td>
 <td width="1" height="20"></td>
 <td bgcolor="#DBE0E3" align="center" height="20" class="etiqueta" width="60">Amount</td>
 <td width="1" height="20"></td>
 <td bgcolor="#DBE0E3" align="center" height="20" class="etiqueta" width="60">Price</td>
 <td width="1" height="20"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center" width="60">VAT</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" height="20" class="etiqueta" align="center" width="60"> Discounts </td>
 <td width="1" height="20"></td>
 <td bgcolor="#DBE0E3" align="center" height="20" class="etiqueta" width="110">Amount</td>
 <td width="1" bgcolor="#DBE0E3" height="20"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3"></td>
 <td colspan="9"></td>
 <td></td>
 <td></td>
 <td bgcolor="#DBE0E3"></td>
 <td colspan="4"></td>
 </tr>
 @%where:nodb|nodb_order_details;%@ <!-- aqui empieza el registro -->
 <tr> <td bgcolor="#DBE0E3"></td>
 <td colspan="9" ></td>
 <td></td>
 <td></td>
 <td bgcolor="#DBE0E3"></td>
 <td colspan="3"></td>
 <td></td>
 </tr>
 <tr> 
 <td bgcolor="#DBE0E3" height="22"> </td>
 <td class="texto" colspan="5">@%db:nombre;%@</td>
 <td bgcolor="#DBE0E3"></td>
 <td class="texto" align="center">@%db:cantidad_total;%@</td>
 <td bgcolor="#DBE0E3"></td>
 <td class="texto" align="center">@%db:precio_tarifa%@</td>
 <td bgcolor="#DBE0E3"></td>
 <td align="center" class="texto">@%db:porcentaje;%@</td>
 <td bgcolor="#DBE0E3"> </td>
 <td class="texto" align="center"> @%db:tipo_descuento;%@ </td>
 <td bgcolor="#DBE0E3"></td>
 <td class="texto" align="right">@%db:base_imponible;%@ @%db:leyenda_divisa%@</td>
 <td bgcolor="#DBE0E3"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3"></td>
 <td colspan="9" >
@%db:observaciones%@<input type="hidden" name="observaciones[@%db:idx_detalle;%@]" class="insertext" size="80" value="@%db:observaciones%@">
@%set:id_articulo=id_articulo;%@
@%set:_selected_value=id_servicio;%@
@%if:servicio_articulo%@
<select name="servicios[@%db:idx_detalle;%@]">
@%where:tabla|Empresas_servicios;nolink|1;where|id_articulo = $id_articulo AND id_empresa = $id_empresa;%@
<option value="@%db:Servicios.id_servicio;%@"
@%db:selected_value{Servicios.id_servicio}%@
>@%db:Servicios.nombre;%@</option>
 @%end-where:%@

</select>
@%else:%@
@%end-if:%@

 </td>
 <td></td>
 <td></td>
 <td bgcolor="#DBE0E3"></td>
 <td colspan="3"></td>
 <td></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3"></td>
 <td colspan="9"></td>
 <td></td>
 <td></td>
 <td bgcolor="#DBE0E3"></td>
 <td colspan="4"></td>
 </tr>
 <tr> <td colspan="17" height="1" bgcolor="#DBE0E3"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3"></td>
 <td colspan="9" ></td>
 <td></td>
 <td></td>
 <td bgcolor="#DBE0E3"></td>
 <td colspan="3"></td>
 <td></td>
 </tr>
 <!-- aqui termina el registro -->
 @%end-where:%@ </table>
 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td></td>
 <td></td>
 <td></td>
 </tr>
 <tr> <td valign="top"> <table width="100%" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#DBE0E3" height="20" class="etiqueta" align="center" width="1"></td>
 <td bgcolor="#DBE0E3" height="20" class="etiqueta" align="center">Taxable Income</td>
 <td width="1" height="20"></td>
 <td bgcolor="#DBE0E3" align="center" height="20" class="etiqueta">VAT %</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" align="center" height="20" class="etiqueta" width="120">Surcharge %</td>
 <td width="1" height="20" bgcolor="#DBE0E3"></td>
 </tr>
 @%where:nodb|nodb_taxes_detail;%@ <!-- @%db:base_imponible;%@ -->
 <tr> <td colspan="7" height="1"></td>
 </tr>
 <tr> <td height="24" bgcolor="#DBE0E3" ></td>
 <td height="24" align="center" class="texto">@%db:base_imponible;%@</td>
 <td bgcolor="#DBE0E3" height="24"></td>
 <td class="texto" align="center" height="24">@%db:recargo_iva;%@ / @%db:porcentaje;%@ %</td>
 <td class="texto" align="center" height="24" bgcolor="#DBE0E3"></td>
 <td class="texto" align="center" height="24">@%db:recargo_equivalente;%@ / @%db:porcentaje_recargo_equivalente;%@ %</td>
 <td bgcolor="#DBE0E3" height="24"></td>
 </tr>
 <tr> <td colspan="7" height="1"></td>
 </tr>
 <tr> <td height="1" bgcolor="#DBE0E3" colspan="7"></td>
 </tr>
 @%end-where:%@ </table>
 </td>
 <td width="40"></td>
 <td valign="top"> <table width="100%" border="0" cellspacing="0" cellpadding="0">
 <tr> <td width="1" height="20" bgcolor="#DBE0E3"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center">Taxable Income</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" height="20" class="etiqueta" align="center">Discounts</td>
 <td width="1" height="20"></td>
 <td bgcolor="#DBE0E3" align="center" height="20" class="etiqueta" width="80">Amount</td>
 <td width="1" bgcolor="#DBE0E3" height="20"></td>
 </tr>
 @%where:nodb|nodb_discounts_detail;%@
 <tr> <td colspan="7" height="1"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="24"></td>
 <td align="center" class="texto" height="24">@%db:base_imponible;%@</td>
 <td bgcolor="#DBE0E3" height="24"> </td>
 <td class="texto" align="center" height="24">@%db:descuento;%@ %</td>
 <td bgcolor="#DBE0E3" height="24"></td>
 <td class="texto" align="right" height="24">@%db:importe;%@ &gt; Euro</td>
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
 <tr> <td align="right" class="texto" width="112" bgcolor="#EBECED">Total Taxable Income:</td>
 <td width="81" height="22" class="texto"> @%db:base_imponible;%@</td>
 </tr>
 <tr> <td colspan="2" bgcolor="#DBE0E3" height="1" align="right"></td>
 </tr>
 <tr> <td align="right" class="texto" bgcolor="#EBECED" width="112">Total Taxes:</td>
 <td width="81" height="22" class="texto"> @%db:impuestos;%@</td>
 </tr>
 <tr> <td colspan="2" bgcolor="#DBE0E3" height="1" align="right"></td>
 </tr>
 <tr> <td align="right" class="texto" bgcolor="#EBECED" width="112">Deduction:</td>
 <td width="81" height="22" class="texto"> @%db:retenido;%@ </td>
 </tr>
 <tr> <td colspan="2" bgcolor="#DBE0E3" height="1" align="right"></td>
 </tr>
 <tr> <td align="right" class="texto" bgcolor="#EBECED" width="112">Surcharge:</td>
 <td width="81" height="22" class="texto"> @%db:recargos;%@</td>
 </tr>
 <tr> <td colspan="2" bgcolor="#DBE0E3" height="1" align="right"></td>
 </tr>
 <tr> <td align="right" class="texto" bgcolor="#EBECED" width="112">Total Discount:</td>
 <td width="81" height="22" class="texto"> @%db:descuentos;%@ <!--@%db:sin_retencion;%@-->
 </td>
 </tr>
 <tr> <td colspan="2" bgcolor="#DBE0E3" height="1"></td>
 </tr>
 </table>
 </td>
 <td width="11" bgcolor="#FFFFFF" valign="top" rowspan="2"> </td>
 <td width="6" bgcolor="#EBECED" valign="top" rowspan="2"></td>
 <td width="125" bgcolor="#EBECED" valign="middle" class="texto" height="22">Notes:</td>
 <td width="6" bgcolor="#EBECED" valign="top" rowspan="2"></td>
 <td width="11" rowspan="2"></td>
 <td width="162" valign="top" rowspan="2"> <table width="100%" border="0" cellspacing="0" cellpadding="0">
 <tr align="center"> <td colspan="3" bgcolor="#CCD2D7" class="etiqueta" height="22">Total amount </td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" width="1"></td>
 <td height="22" align="right" width="99%" class="texto"> @%db:importe;%@ @%db:leyenda_divisa%@</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 </tr>
 <tr bgcolor="#DBE0E3"> <td colspan="3" height="1"></td>
 </tr>
 </table>
 </td>
 </tr>
 <tr> <td width="125" bgcolor="#EBECED" valign="top"> <!-- Notas del pedido -->
 @%get:observaciones_en_totales%@
 </td>
 </tr>
 </table>
 @%end-where:%@ 

