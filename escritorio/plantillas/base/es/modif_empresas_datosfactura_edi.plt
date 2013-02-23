 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td colspan="6" align="right" class="titul1" height="22"></td>
 </tr>
 <tr> <td colspan="6" bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr bgcolor="#EBECED"> 
 <td width="124" height="22" class="titul1" align="right">Prefijo factura:</td>
 <td width="57"> <input type="text" name="registro[prefijo_fact_ventas]" value="@%db:Empresas.prefijo_fact_ventas;%@" class="insertextnumeros" size="6">
 </td>
 <td class="titul1" width="124" align="right">Sufijo factura:</td>
 <td class="texto" width="67"> <input type="text" name="registro[sufijo_fact_ventas]" value="@%db:Empresas.sufijo_fact_ventas;%@" class="insertextnumeros" size="6">
 </td>
 <td width="148" class="titul1" bgcolor="#EBECED" align="right"></td>
 <td width="124" class="texto"></td>
 </tr>
 <tr bgcolor="#EBECED"> 
 <td width="124" height="22" class="titul1" align="right">Prefijo pedido:</td>
 <td width="57"> <input type="text" name="registro[prefijo_ped_ventas]" value="@%db:Empresas.prefijo_ped_ventas;%@" class="insertextnumeros" size="6">
 </td>
 <td class="titul1" width="124" align="right">Sufijo pedido:</td>
 <td class="texto" width="67"> <input type="text" name="registro[sufijo_ped_ventas]" value="@%db:Empresas.sufijo_ped_ventas;%@" class="insertextnumeros" size="6">
 </td>
 <td width="148" class="titul1" bgcolor="#EBECED" align="right">Contador pedido:</td>
 <td width="124" class="texto"> <input type="text" name="registro[contador_ped_ventas]" value="@%db:Empresas.contador_ped_ventas;%@" class="insertextnumeros" size="6">
 </td>
 </tr>
 <tr bgcolor="#EBECED"> 
 <td width="124" height="22" class="titul1" align="right">Prefijo albarán:</td>
 <td width="57"> <input type="text" name="registro[prefijo_alb_ventas]" value="@%db:Empresas.prefijo_alb_ventas;%@" class="insertextnumeros" size="6">
 </td>
 <td class="titul1" width="124" align="right">Sufijo albarán:</td>
 <td class="texto" width="67"> <input type="text" name="registro[sufijo_alb_ventas]" value="@%db:Empresas.sufijo_alb_ventas;%@" class="insertextnumeros" size="6">
 </td>
 <td width="148" class="titul1" bgcolor="#EBECED" align="right">Contador albarán:</td>
 <td width="124" class="texto"> <input type="text" name="registro[contador_alb_ventas]" value="@%db:Empresas.contador_alb_ventas;%@" class="insertextnumeros" size="6">
 </td>
 </tr>
 <tr bgcolor="#EBECED"> 
 <td width="124" height="22" class="titul1" align="right">Prefijo presupuesto:</td>
 <td width="57"> <input type="text" name="registro[prefijo_pre_ventas]" value="@%db:Empresas.prefijo_pre_ventas;%@" class="insertextnumeros" size="6">
 </td>
 <td class="titul1" width="124" align="right">Sufijo presupuesto:</td>
 <td class="texto" width="67"> <input type="text" name="registro[sufijo_pre_ventas]" value="@%db:Empresas.sufijo_pre_ventas;%@" class="insertextnumeros" size="6">
 </td>
 <td width="148" class="titul1" bgcolor="#EBECED" align="right">Contador presupuesto:</td>
 <td width="124" class="texto"> <input type="text" name="registro[contador_pre_ventas]" value="@%db:Empresas.contador_pre_ventas;%@" class="insertextnumeros" size="6">
 </td>
 </tr>
 <tr> <td colspan="6" bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td colspan="6" height="10">
 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td height="22" colspan="2"></td>
 </tr>
 <tr bgcolor="#CCD2D7"> <td height="22" colspan="2" class="titul1">Otros datos</td>
 </tr>
 <tr> <td height="22" bgcolor="#EBECED" width="125" class="titul1"> Retenci&oacute;n a aplicar:
 </td>
 <td height="22" bgcolor="#EBECED" width="519"> <input type=text name=registro[retencion] value="@%db:Empresas.retencion;%@" size="6" class="insertext">
 </td>
 </tr>
 <tr bgcolor="#CCD2D7"> <td height="1" colspan="2" ></td>
 </tr>
 <tr bgcolor="#EBECED"> <td height="22" class="titul1">Stock negativo:</td>
 <td height="22" > <!--@%db:Empresas.stock_negativo;%@-->
 <input type="checkbox" name="registro[stock_negativo]" value="1" @%func:checked_stock_negativo%@>
 </td>
 </tr>
 <tr bgcolor="#CCD2D7"> <td height="1" class="titul1" colspan="2"></td>
 <tr> <td height="10" colspan="2" ></td>
 </tr>
 </table>
</table>
