<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#FFFFFF" height="30"> 
@%plt:botonera%@ 
</td>
 </tr>
 <tr> <td height="22" bgcolor="#FFFFFF">
 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td class="etiqueta" bgcolor="#CCD2D7" height="22">Relatório de Clientes</td>
 </tr>
 <tr> <td height="10"></td>
 </tr>
 </table> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td height="22" width="1"></td>
 <td bgcolor="#CCD2D7" class="etiqueta" width="80">Ref.</td>
 <td height="22" width="1"></td>
 <td bgcolor="#CCD2D7" class="etiqueta">Nome</td>
 <td height="22" width="1"></td>
 <td bgcolor="#CCD2D7" class="etiqueta" width="70" align="center">Data</td>
 <td height="22" width="1"></td>
 <td bgcolor="#CCD2D7" width="50" class="etiqueta" align="center">Desconto</td>
 <td height="22" width="1"></td>
 <td bgcolor="#CCD2D7" align="center" width="85" class="etiqueta">Valor Tributável</td>
 <td height="22" width="1"></td>
 <td bgcolor="#CCD2D7" width="80" class="etiqueta" align="center">Total de Imposto</td>
 <td height="22" width="1"></td>
 <td bgcolor="#CCD2D7" width="90" align="center" class="etiqueta">Total</td>
 <td height="22" width="1"></td>
 </tr>
 <tr> <td colspan="15" height="1" bgcolor="#CCD2D7"></td>
 </tr>
 </table>
 @%where:tabla|Facturas;nombre|busc;order|id_proveedor,id_cliente;no_results|1;%@
 @%if:cambia_a_proveedor%@
 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td height="22"></td>
 <td bgcolor="#CCD2D7" width="1"></td>
 <td align="right" class="etiqueta" width="80">Total:</td>
 <td bgcolor="#CCD2D7" width="1"></td>
 <td width="90" align="center" class="texto">@%func:cmonto_total%@</td>
 <td bgcolor="#CCD2D7" width="1"></td>
 </tr>
 <tr> <td height="1"></td>
 <td bgcolor="#CCD2D7" colspan="5"></td>
 </tr>
 </table>
 <br>
 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td class="etiqueta" bgcolor="#CCD2D7" height="22">Relatório de Fornecedores</td>
 </tr>
 <tr> <td height="10"></td>
 </tr>
 </table>
 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td height="22" width="1"></td>
 <td bgcolor="#CCD2D7" class="etiqueta" width="80">Ref.</td>
 <td height="22" width="1"></td>
 <td bgcolor="#CCD2D7" class="etiqueta">Nome</td>
 <td height="22" width="1"></td>
 <td bgcolor="#CCD2D7" class="etiqueta" width="70" align="center">Data</td>
 <td height="22" width="1"></td>
 <td bgcolor="#CCD2D7" width="50" class="etiqueta" align="center">Desconto</td>
 <td height="22" width="1"></td>
 <td bgcolor="#CCD2D7" align="center" width="85" class="etiqueta">Valor Tributável</td>
 <td height="22" width="1"></td>
 <td bgcolor="#CCD2D7" width="80" class="etiqueta" align="center">Total de Imposto</td>
 <td height="22" width="1"></td>
 <td bgcolor="#CCD2D7" width="90" align="center" class="etiqueta">Total</td>
 <td height="22" width="1"></td>
 </tr>
 <tr> <td colspan="15" height="1" bgcolor="#CCD2D7"></td>
 </tr>
 </table>
 @%else:%@

 @%end-if:%@
 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td height="22" width="1" bgcolor="#CCD2D7"></td>
 <td class="texto" width="80">@%if:allowed-link;bo_factura_cliente;%@<a href="?seccion=bo_factura_cliente&id_factura=@%db:Facturas.id_factura;%@" class="accesos">@%db:Facturas.referencia;%@</a></td>
 @%end-if:%@
 <td height="22" width="1" bgcolor="#CCD2D7"></td>
 <td class="texto"><!--@%db:Facturas.id_cliente;%@@%db:Facturas.id_proveedor;%@-->@%func:nombre_proveedor_o_cliente%@</td>
 <td height="22" width="1" bgcolor="#CCD2D7"></td>
 <td class="texto" width="70" align="center">@%db:colocar_fecha{Facturas.fecha};%@</td>
 <td height="22" width="1" bgcolor="#CCD2D7"></td>
 <td width="50" class="texto" align="center">@%db:Facturas.descuento;%@</td>
 <td height="22" width="1" bgcolor="#CCD2D7"></td>
 <td align="center" width="85" class="texto">@%db:Facturas.base_imponible;%@</td>
 <td height="22" width="1" bgcolor="#CCD2D7"></td>
 <td width="80" class="texto" align="center">@%db:Facturas.total_impuestos;%@</td>
 <td height="22" width="1" bgcolor="#CCD2D7"></td>
 <td width="90" align="center" class="texto">@%db:Facturas.monto_total;%@</td>
 <td height="22" width="1" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td colspan="15" height="1" bgcolor="#CCD2D7"></td>
 </tr>
</table>
<!--@%func:acumula%@-->

 @%end-where:%@
 
 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td height="22"></td>
 <td bgcolor="#CCD2D7" width="1"></td>
 <td align="right" class="etiqueta" width="80">Total:</td>
 <td bgcolor="#CCD2D7" width="1"></td>
 <td width="90" align="center" class="texto">@%func:pmonto_total%@</td>
 <td bgcolor="#CCD2D7" width="1"></td>
 </tr>
 <tr> <td height="1"></td>
 <td bgcolor="#CCD2D7" colspan="5"></td>
 </tr>
 </table>
 <br>
 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td height="1"> </td>
 <td bgcolor="#CCD2D7" height="1" colspan="5"></td>
 </tr>
 <tr> <td></td>
 <td bgcolor="#CCD2D7" width="1"></td>
 <td align="right" class="etiqueta" width="240" height="22" bgcolor="#CCD2D7">Total Clientes Fornecedores:</td>
 <td bgcolor="#CCD2D7" width="1"></td>
 <td width="90" align="center" class="texto">@%func:monto_total%@</td>
 <td bgcolor="#CCD2D7" width="1"></td>
 </tr>
 <tr> <td></td>
 <td bgcolor="#CCD2D7" colspan="5"></td>
 </tr>
 </table>
 </td>
 </tr>
 <tr> <td height="30">
@%plt:botonera%@
 </td>
 </tr>
</table>
 


