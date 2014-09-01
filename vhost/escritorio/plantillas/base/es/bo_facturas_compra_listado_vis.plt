<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#FFFFFF" height="30">
@%plt:botonera%@
</td>
 </tr>
 <tr> <td height="30"> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr align="center"> <td colspan="4" height="22" > <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td colspan="15" height="22" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td colspan="15" height="1"></td>
 </tr>
 <tr> <td width="1" height="20" bgcolor="#DBE0E3"></td>
 <td bgcolor="#DBE0E3" align="center" height="20" class="etiqueta" width="100">Ref.</td>
 <td width="1" height="20"></td>
 <td bgcolor="#DBE0E3" height="20" class="etiqueta" width="150">Proveedor</td>
 <td width="1" height="20"></td>
 <td bgcolor="#DBE0E3" align="center" height="20" class="etiqueta" width="80">Fecha</td>
 <td width="1" height="20"></td>
 <td bgcolor="#DBE0E3" align="center" height="20" class="etiqueta" width="80">B. imponible</td>
 <td width="1" height="20"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center" width="65">Impuestos</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" height="20" class="etiqueta" align="center" width="60">Total</td>
 <td width="1" height="20"></td>
 <td bgcolor="#DBE0E3" align="center" height="20" class="etiqueta" width="50">Estado</td>
 <td width="1" bgcolor="#DBE0E3" height="20"></td>
 </tr>

@%where:tabla|Facturas;nombre|busc;no_results|1;order|Facturas.referencia desc;%@ <!--Campo referencia_externa = @%db:Facturas.referencia_externa;%@ Campo notas = @%db:Facturas.notas;%@ Campo monto_cuenta = @%db:Facturas.monto_cuenta;%@ @%db:Facturas.retenido;%@ @%db:Facturas.descuento;%@-->
 <tr> <td height="1" colspan="15"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="24" width="1"></td>
 <td class="texto" align="center" height="24"><a href="?seccion=bo_factura_proveedor&id_factura=@%db:Facturas.id_factura;%@" class="accesos">@%db:Facturas.referencia;%@</a></td>
 <td height="24" bgcolor="#DBE0E3"></td>
 <td height="24" class="texto">@%db:Proveedores.nombre;%@</td>
 <td bgcolor="#DBE0E3" height="24"></td>
 <td class="texto" align="center" height="24">@%db:colocar_fecha{Facturas.fecha};%@</td>
 <td bgcolor="#DBE0E3" height="24"></td>
 <td class="texto" align="center" height="24">@%db:Facturas.base_imponible;%@</td>
 <td bgcolor="#DBE0E3" height="24"></td>
 <td align="center" class="texto" height="24">@%db:Facturas.total_impuestos;%@</td>
 <td bgcolor="#DBE0E3" height="24"> </td>
 <td class="texto" align="center" height="24">@%db:Facturas.monto_total;%@</td>
 <td bgcolor="#DBE0E3" height="24"></td>
 <td class="texto" align="center" height="24">
<!--@%db:Facturas.estado;%@-->
@%func:estado_factura%@
</td>
 <td bgcolor="#DBE0E3" height="24"></td>
 </tr>
 <tr> <td height="1" colspan="15"></td>
 </tr>
 <tr> <td colspan="15" height="1" bgcolor="#DBE0E3"></td>
 </tr>
 @%end-where:%@ </table>
 </td>
 </tr>
 <tr align="center"> <td colspan="4" height="10" ></td>
 </tr>
 </table>
 </td>
 </tr>
 <tr> <td height="30">
@%plt:botonera%@
</td>
 </tr>
</table>



