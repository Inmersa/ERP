@%where:tabla|Facturas;where|Facturas.id_factura = $id_factura and Facturas.id_empresa = $id_empresa;not_ruta_path|Agentes_facturas;ruta_path|Pedidos_facturas,Facturas;%@

<table width="647" border="0" cellspacing="0" cellpadding="0">

 <tr> <td colspan="13" height="22" bgcolor="#CCD2D7"> <table width="100%" border="0" cellspacing="0" cellpadding="0">
 <tr> <td width="6"></td>
 <td width="320"></td>
 <td align="center">
</td>
 <td align="center">
 </td>
 <td align="center">
</td>
 </tr>
 </table>
 </td>
 </tr>
 <tr> <td colspan="13" height="1"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" width="20" height="22"></td>
 <td bgcolor="#DBE0E3" height="20" class="etiqueta">Código</td>
 <td width="1" height="20"></td>
 <td bgcolor="#DBE0E3" align="center" height="20" class="etiqueta" width="60">Quantidade</td>
 <td width="1" height="20"></td>
 <td bgcolor="#DBE0E3" align="center" height="20" class="etiqueta" width="60">Preço</td>
 <td width="1" height="20"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center" width="60">IVA</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" height="20" class="etiqueta" align="center" width="60"><span class="texto">%</span>Desconto </td>
 <td width="1" height="20"></td>
 <td bgcolor="#DBE0E3" align="center" height="20" class="etiqueta" width="110">Montante</td>
 <td width="1" bgcolor="#DBE0E3" height="20"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3"></td>
 <td colspan="5"></td>
 <td></td>
 <td></td>
 <td bgcolor="#DBE0E3"></td>
 <td colspan="4"></td>
 </tr>
 @%where:tabla|Lineas_detalle;where|Facturas.id_factura = $id_factura and Facturas.id_empresa = $id_empresa;contador|count;%@ <!--@%db:Lineas_detalle.id_articulo;%@
 @%db:Facturas_detalle.id_detalle;%@
 @%db:LENGTH(Lineas_detalle.observaciones) as 'length_observaciones' %@ @%set:num_detalles=count;%@
 @%set:length_observaciones=length_observaciones%@
 -- El valor que tienes aqui (5) es el numero de caracteres que tiene que tener las observaciones para provocar un --salto de linea.
 @%calc:lineas_observaciones = lineas_observaciones + (length_observaciones / 5) + (length_observaciones / (length_observaciones + 1 ) ) ;output|0;round|-2;%@
-->

 <tr> <td bgcolor="#DBE0E3"></td>
 <td colspan="5" ></td>
 <td></td>
 <td></td>
 <td bgcolor="#DBE0E3"></td>
 <td colspan="3"></td>
 <td></td>
 </tr>
 <tr> 
 <td bgcolor="#DBE0E3" height="22"> <!-- este checkbox solo va si el pedido no esta consolidado (lo mismo pal enlace de añadir>-->
 </td>
 <td > <a href="?seccion=modif_articulos&id_articulo=@%db:Lineas_detalle.id_articulo;%@" class="accesos">@%db:Articulos.nombre%@</a></td>
 <td bgcolor="#DBE0E3"></td>
 <td class="texto" align="center">@%db:Lineas_detalle.cantidad;%@</td>
 <td bgcolor="#DBE0E3"></td>
 <td class="texto" align="center">@%db:Lineas_detalle.precio_articulo;%@</td>
 <td bgcolor="#DBE0E3"></td>
 <td align="center" class="texto">@%func:porcentaje_iva;%@</td>
 <td bgcolor="#DBE0E3"> </td>
 <td class="texto" align="center"> <!-- @%db:Lineas_detalle.monto;%@-->
 <!-- @%db:Lineas_detalle.descuento;%@-->
 @%func:descripcion_descuento%@</td>
 <td bgcolor="#DBE0E3"></td>
 <td class="texto" align="right">@%db:Lineas_detalle.monto_total;%@ &gt; Euro</td>
 <td bgcolor="#DBE0E3"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3"></td>
 <td colspan="5"></td>
 <td></td>
 <td></td>
 <td bgcolor="#DBE0E3"></td>
 <td colspan="4"></td>
 </tr>
 <tr> <td colspan="13" height="1" bgcolor="#DBE0E3"></td>
 </tr>
 
@%if:observaciones_detalle;%@

 <tr> <td colspan="13" height="1" bgcolor="#DBE0E3"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="22"></td>
 <td colspan="5" rowspan="2" class="texto">@%db:Lineas_detalle.observaciones%@</td>
 <td bgcolor="#DBE0E3" rowspan="2" class="texto"></td>
 <td colspan="5" rowspan="2" class="texto">@%wdb:Servicios.nombre;%@</td>
 <td rowspan="2" class="texto" bgcolor="#DBE0E3"></td>
 </tr>
@%else:%@

@%end-if:%@ <tr> <td colspan="13" height="1" bgcolor="#DBE0E3"></td>
 </tr>

 @%end-where:%@ </table>
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
 <td bgcolor="#DBE0E3" align="center" height="20" class="etiqueta">IVA</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" align="center" height="20" class="etiqueta" width="60">Sobretaxa Equivalente</td>
 <td width="1" height="20" bgcolor="#DBE0E3"></td>
 </tr>
 @%where:tabla|IVAs;%@ <!-- @%db:IVAs.id_iva;%@ -->
 <tr> <td colspan="9" height="1"></td>
 </tr>
 <tr> <td height="24" bgcolor="#DBE0E3" ></td>
 <td height="24" align="center" class="texto">@%db:IVAs.monto;%@</td>
 <td bgcolor="#DBE0E3" height="24"></td>
 <td class="texto" align="center" height="24">@%func:porcentaje_iva2%@ %</td>
 <td bgcolor="#DBE0E3" height="24"></td>
 <td class="texto" align="center" height="24">@%db:IVAs.recargo_iva;%@</td>
 <td class="texto" align="center" height="24" bgcolor="#DBE0E3"></td>
 <td class="texto" align="center" height="24">@%db:IVAs.recargo_equivalente;%@</td>
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
 <td bgcolor="#DBE0E3" align="center" height="20" class="etiqueta" width="70">Total Bruto</td>
 <td width="1" bgcolor="#DBE0E3" height="20"></td>
 </tr>
 @%where:tabla|Descuentos;order|Descuentos.orden asc;%@
 <tr> <td colspan="7" height="1"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="24"></td>
 <td align="center" class="texto" height="24">@%db:Descuentos.monto_base;%@</td>
<!--@%set:total_bruto=Descuentos.monto_base;%@-->
 <td bgcolor="#DBE0E3" height="24"> </td>
 <td class="texto" align="center" height="24">@%db:Descuentos.nombre%@ @%db:Descuentos.porcentaje%@ %</td>
 <td bgcolor="#DBE0E3" height="24"></td>
 <td class="texto" align="right" height="24">@%db:Descuentos.monto_final;%@ </td>
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
 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td colspan="7" height="22"></td>
 </tr>
 <tr> <td width="195" rowspan="2" valign="top"> <table width="194" border="0" cellspacing="0" cellpadding="0">
 <tr bgcolor="#DBE0E3"> <td colspan="2" height="1"></td>
 <td rowspan="11" width="1"></td>
 </tr>
 <tr>
 <td align="right" class="texto" width="100" bgcolor="#EBECED">Total Bruto:</td>
 <td height="24" class="texto"> @%get:total_bruto;%@</td>
 </tr>
 <tr>
 <td colspan="2" bgcolor="#DBE0E3" height="1" align="right"></td>
 </tr>
 <tr>
 <td align="right" class="texto" width="100" bgcolor="#EBECED">Desconto Total:</td>
 <td height="24" class="texto"> <!-- sumatorio de las cantidades de los decuentos aplicados -->
 @%db:Facturas.descuento%@</td>
 </tr>
 <tr>
 <td colspan="2" bgcolor="#DBE0E3" height="1" align="right"></td>
 </tr>
 <tr> <td align="right" class="texto" bgcolor="#EBECED" width="100">Total do Valor Tributável:</td>
 <td height="23" class="texto"> <!-- Total Base Imponible del pedido -->
 @%db:Facturas.base_imponible;%@</td>
 </tr>
 <tr> <td colspan="2" bgcolor="#DBE0E3" height="1" align="right"></td>
 </tr>
 <tr> <td align="right" class="texto" bgcolor="#EBECED" width="100">Total de Impostos:</td>
 <td height="23" class="texto"> <!-- sumatorio de cantidades de impuestos -->
 @%db:Facturas.total_impuestos;%@</td>
 </tr>
 <tr> <td colspan="2" bgcolor="#DBE0E3" height="1" align="right"></td>
 </tr>
 <tr> <td align="right" class="texto" bgcolor="#EBECED" width="100">Retenção:</td>
 <td height="23" class="texto"> <!-- resultado de aplicar la retencion a la base imponible-->
 @%db:Facturas.retenido%@</td>
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
 <td height="22" align="right" width="99%" class="texto">
<!-- importe total del pedido (aplicados descuentos, ivas y retenciones)-->
@%db:Facturas.monto_total%@ &gt; Euro</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 </tr>
 <tr bgcolor="#DBE0E3"> <td colspan="3" height="1"></td>
 </tr>
 </table>
 </td>
 </tr>
 <tr> <td width="125" bgcolor="#EBECED" valign="top" height="70"> <!-- Notas del pedido -->
 @%db:Facturas.notas;%@ </td>
 </tr>
 </table>
 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td height="22"></td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="22" align="center">

 

</td>
 </tr>
 </table>
 
