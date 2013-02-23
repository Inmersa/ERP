<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#FFFFFF" height="30">
@%plt:botonera%@
</td>
 </tr>
 <tr> <td height="22" bgcolor="#FFFFFF"> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td colspan="13" bgcolor="#CCD2D7" height="22"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" width="180">Referência</td>
 <td width="1" align="center"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center">Data</td>
 <td width="1" align="center"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center">Ref. Externa</td>
 <td width="1" align="center"></td>
 <td class="etiqueta" bgcolor="#DBE0E3" align="center" width="110">Modo de Pagamento</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" width="80" height="22" align="center" class="etiqueta">Quantidade</td>
 <td width="1" height="22"></td>
 <td bgcolor="#DBE0E3" width="80" height="22" class="etiqueta" align="center">Tarifa</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 </tr>
@%where:tabla|Facturas;nombre|busc;no_results|1;%@

 <tr> <td colspan="13" height="1"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" width="1"></td>
 <td class="texto"><a href="?seccion=bo_factura_proveedor&id_factura=@%db:Facturas.id_factura;%@" class="accesos">@%db:Facturas.referencia;%@</a></td>
 <td bgcolor="#DBE0E3"></td>
 <td align="center" class="texto">@%db:colocar_fecha{Facturas.fecha};%@ </td>
 <td bgcolor="#DBE0E3"></td>
 <td align="center" class="texto">@%db:Facturas.referencia_externa;%@</td>
 <td bgcolor="#DBE0E3"></td>
 <td align="center" class="texto">@%db:Forma_pago.nombre;%@</td>
 <td bgcolor="#DBE0E3"></td>
 <td align="center" height="22" class="texto">@%db:Facturas.monto_total;%@</td>
 <td align="center" height="22" bgcolor="#DBE0E3"></td>
 <td align="center" height="22" class="texto">@%db:Tarifas.nombre;%@</td>
 <td bgcolor="#DBE0E3"></td>
 </tr>
 <tr> <td colspan="13" height="1"></td>
 </tr>
 <tr> <td colspan="13" bgcolor="#DBE0E3" height="1"></td>
 </tr>
@%end-where:%@

 </table>
 </td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" height="30">
@%plt:botonera%@ 
</td>
 </tr>
</table>
<!-- faltan como puedes ver la forma de pago y la tarifa -->

