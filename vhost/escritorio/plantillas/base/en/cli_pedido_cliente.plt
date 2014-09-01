@%where:tabla|Pedidos;where|Pedidos.id_pedido = $id_pedido and Pedidos.id_empresa = $id_empresa and Direcciones_entrega.id_cliente = $id_cliente;%@
<!--@%db:Pedidos.id_factura;%@-->
<!--@%db:Direcciones_entrega.id_cliente;%@-->
@%if:hay_factura%@

@%else:%@

<form name="anyadir_al_pedido" action="?seccion=cli_hacer_pedido" method="post">
<input type="hidden" name="Anyadir" value="Anyadir">
<input type="hidden" name="identificador_pedido" value="@%db:Pedidos.id_pedido%@">
 
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
 <td align="right" colspam="4"><a href="#" onclick=window.open('?@%func:querystring%@&imprimir=1'); return false; class="accesos">Print</a></td>
 <td width="46" align="center" ><a href="javascript:history.go(-1);" class="accesos">Return</a></td>
 </tr>
 </table>
 </td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" height="3"></td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" height="13"></td>
 </tr>
 <tr> <td bgcolor="#FFFFFF"> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#EBECED"> <table width="312" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#CCD2D7" height="22" width="6"> </td>
 <td bgcolor="#CCD2D7" height="22" class="etiqueta">Company</td>
 </tr>

 @%where:tabla|Empresas;nolink|1;where|id_empresa = $id_empresa;%@ 
 <tr> <td height="22"></td>
 <td height="22" class="texto">@%db:Empresas.razon_social;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td></td>
 <td class="texto" height="22">@%db:Empresas.direccion_facturacion;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td></td>
 <td class="texto" height="22">@%db:Empresas.cp;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td></td>
 <td class="texto" height="22">@%db:Empresas.poblacion;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td></td>
 <td class="texto" height="22">@%db:Provincias.nombre;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td></td>
 <td class="texto" height="22">Fax: @%db:Empresas.fax;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td></td>
 <td class="texto" height="22">Tel. @%db:Empresas.telefono1;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td></td>
 <td height="22"></td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="22"></td>
 <td bgcolor="#CCD2D7" height="22"></td>
 </tr>

 @%end-where:%@ 
 </table>
 </td>
 <td width="20"></td>
 <td> <table width="312" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#CCD2D7" height="22" align="right" class="etiqueta" width="80">Client</td>
 <td bgcolor="#CCD2D7" height="22" width="90"></td>
 <td bgcolor="#CCD2D7" height="22" width="60"></td>
 <td bgcolor="#CCD2D7" height="22"></td>
 </tr>
 @%where:tabla|Clientes;nolink|1;where|id_cliente = $id_cliente;%@ <!--
nombre @%db:Clientes.nombre;%@
persona contacto @%db:Clientes.persona_contacto;%@
cargo persona contacto @%db:Clientes.cargo_persona_contacto;%@
web @%db:Clientes.web;%@
telefono 2 @%db:Clientes.telefono2;%@
-->
 <tr> <td height="22" align="right" bgcolor="#EBECED" class="etiqueta">Name:</td>
 <td height="22" colspan="3" class="texto">@%db:Clientes.razon_social;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" align="right"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td align="right" bgcolor="#EBECED" class="etiqueta" height="22">Code:</td>
 <td colspan="3" class="texto">@%db:Clientes.id_cliente;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" align="right"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td align="right" bgcolor="#EBECED" class="etiqueta" height="22">Address:</td>
 <td colspan="3" class="texto">@%db:Clientes.direccion_facturacion;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" align="right"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td align="right" bgcolor="#EBECED" class="etiqueta" height="22">City:</td>
 <td class="texto" colspan="3"> @%db:Clientes.poblacion;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" align="right"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td align="right" bgcolor="#EBECED" height="22" class="etiqueta">Area:</td>
 <td class="texto">@%db:Provincias.nombre;%@</td>
 <td bgcolor="#EBECED" class="etiqueta" align="right">Postal Code:</td>
 <td class="texto">@%db:Clientes.cp;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" align="right"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td align="right" bgcolor="#EBECED" height="22" class="etiqueta">EIN:</td>
 <td colspan="3" class="texto">@%db:Clientes.prefijo_cif;%@-@%db:Clientes.cif;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" align="right"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td align="right" bgcolor="#EBECED" height="22" class="etiqueta">Telephone:</td>
 <td class="texto">@%db:Clientes.telefono1;%@</td>
 <td bgcolor="#EBECED" align="right" class="etiqueta">Fax:</td>
 <td class="texto">@%db:Clientes.fax;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" align="right"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td align="right" bgcolor="#EBECED" height="22" class="etiqueta">e-mail:</td>
 <td colspan="3"><a href="mailto:@%db:Clientes.email;%@" class="accesos">@%db:Clientes.email;%@</a></td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="22" align="right" colspan="4"></td>
 </tr>

 @%end-where:%@ </table>
 </td>
 </tr>
 </table>
 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td colspan="7" height="22"></td>
 </tr>
<tr> <td colspan="7" bgcolor="#CCD2D7" height="1"></td>
 </tr>
<tr> <td bgcolor="#EBECED" align="right" class="texto" width="80" height="22">External Ref.:</td>
 <td colspan="2" class="texto"> @%db:Pedidos.referencia_externa;%@
 </td>
 <td bgcolor="#EBECED" class="texto" align="right"></td>
 <td colspan="3"></td>
 </tr>
 <tr> <td colspan="7" bgcolor="#CCD2D7" height="1"></td>
 </tr>
<tr> <td bgcolor="#EBECED" align="right" class="texto" width="80" height="22">Reference:</td>
 <td colspan="2" class="texto"> @%db:Pedidos.referencia;%@
 </td>
 <td bgcolor="#EBECED" class="texto" align="right">Currency</td>
 <td colspan="3"> @%db:Divisa.nombre;%@
<!--@%wdb:Pedidos.id_agente%@--> </td>
 </tr>
 <tr> <td colspan="7" height="1" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" align="right" class="texto" height="22" colspan="2">Date:</td>
 <td width="100"> <input type="text" name="textfield25" class="insertextnumeros" size="13" value="@%db:colocar_fecha{Pedidos.fecha};%@" maxlength="10">
 </td>
 <td bgcolor="#EBECED" align="right" class="texto">Method of payment:</td>
 <td colspan="2">
<!--@%db:Pedidos.id_forma_pago;%@-->
@%func:obtener_forma_pago%@
<select name="forma_pago" class="insertext">
@%where:tabla|Forma_pago;nolink|1;%@ 
<option value="@%db:Forma_pago.id_forma_pago;%@" @%func:chequear_forma_pago%@>@%db:Forma_pago.nombre;%@ 
</option>

 @%end-where:%@

 </select>
 </td>
 <td></td>
 <td></td>
 </tr>
 <tr> <td colspan="7" height="1" bgcolor="#CCD2D7"></td>
 </tr>
 </table>
 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td colspan="13" height="30"></td>
 </tr>
 <tr> <td colspan="13" height="22" bgcolor="#CCD2D7"> <table width="100%" border="0" cellspacing="0" cellpadding="0">
 <tr> <td width="6"></td>
 <td width="320"></td>
 <td align="center">
@%if:hay_factura_o_albaran%@

@%else:%@

<a href="" onclick="document.forms['anyadir_al_pedido'].submit();return false;" class="accesos">Add article </a>

@%end-if:%@

</td>
 <td align="right">



 </td>
</td>
 </tr>
 </table>
 </td>
 </tr>
 <tr> <td colspan="13" height="1"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" width="20" height="22"></td>
 <td bgcolor="#DBE0E3" height="20" class="etiqueta">Code</td>
 <td width="1" height="20"></td>
 <td bgcolor="#DBE0E3" align="center" height="20" class="etiqueta" width="60">Amount</td>
 <td width="1" height="20"></td>
 <td bgcolor="#DBE0E3" align="center" height="20" class="etiqueta" width="60">Price</td>
 <td width="1" height="20"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center" width="60">VAT</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" height="20" class="etiqueta" align="center" width="60"><span class="texto">%</span>Implicated </td>
 <td width="1" height="20"></td>
 <td bgcolor="#DBE0E3" align="center" height="20" class="etiqueta" width="110">Amount</td>
 <td width="1" bgcolor="#DBE0E3" height="20"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3"></td>
 <td colspan="5"></td>
 <td></td>
 <td></td>
 <td bgcolor="#DBE0E3"></td>
 <td colspan="4"></td>
 </tr>

<form name="borrar_del_pedido" action="?seccion=bo_pedido_cliente" method="post">
<input type="hidden" name="Borrar" value="Borrar">
<input type="hidden" name="identificador_pedido" value="@%db:Pedidos.id_pedido%@">

 @%where:tabla|Lineas_detalle;where|Pedidos.id_pedido = $id_pedido and Pedidos.id_empresa = $id_empresa;not_ruta_path|IVAs;%@ <!--chapuza por culpa de ruta @%db:Lineas_detalle.id_articulo;%@-->
 <!-- aqui empieza el registro -->
 <tr> <td bgcolor="#DBE0E3"></td>
 <td colspan="5" ></td>
 <td></td>
 <td></td>
 <td bgcolor="#DBE0E3"></td>
 <td colspan="3"></td>
 <td></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="22"> <!-- este checkbox solo va si el pedido no esta consolidado (lo mismo pal enlace de añadir>-->
 <input type="checkbox" name="checkbox" value="checkbox">
 </td>
 <td > <a href="?seccion=modif_articulos&id_articulo=@%db:Lineas_detalle.id_articulo;%@" class="accesos">@%func:nombre_articulo%@ <!--si se pone db asegurarse ke funciona :P --></a></td>
<td bgcolor="#DBE0E3"></td>
 <td class="texto" align="center">@%db:Lineas_detalle.cantidad;%@</td>
 <td bgcolor="#DBE0E3"></td>
 <td class="texto" align="center">@%db:Lineas_detalle.precio_articulo;%@</td>
 <td bgcolor="#DBE0E3"></td>
 <td align="center" class="texto">@%db:Tipos_IVA.porcentaje;%@</td>
 <td bgcolor="#DBE0E3"> </td>
 <td class="texto" align="center"> <!-- @%db:Lineas_detalle.monto;%@-->
 <!-- @%db:Lineas_detalle.descuento;%@-->
 @%func:descripcion_descuento%@</td>
 <td bgcolor="#DBE0E3"></td>
 <td class="texto" align="right">@%db:Lineas_detalle.monto_total;%@ &gt; Euro </td>
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
 <!-- aqui termina el registro -->

 @%end-where:%@ 

</form>

 </table>
 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td></td>
 <td></td>
 <td></td>
 </tr>
 <tr> <td valign="top"> <table width="100%" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#DBE0E3" height="20" class="etiqueta" align="center" width="1"></td>
 <td bgcolor="#DBE0E3" height="20" class="etiqueta" align="center">Taxable Income</td>
 <td width="1" height="20"></td>
 <td bgcolor="#DBE0E3" align="center" height="20" class="etiqueta">%</td>
 <td width="1" height="20"></td>
 <td bgcolor="#DBE0E3" align="center" height="20" class="etiqueta">VAT</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" align="center" height="20" class="etiqueta" width="60">Surcharge</td>
 <td width="1" height="20" bgcolor="#DBE0E3"></td>
 </tr>
 @%where:tabla|IVAs;%@ <!-- @%db:IVAs.id_iva;%@ -->
 <tr> <td colspan="9" height="1"></td>
 </tr>
 <tr> <td height="24" bgcolor="#DBE0E3" ></td>
 <td height="24" align="center" class="texto">@%db:IVAs.monto;%@</td>
 <td bgcolor="#DBE0E3" height="24"></td>
 <td class="texto" align="center" height="24">@%db:Tipos_IVA.porcentaje;%@ %</td>
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
 <td bgcolor="#DBE0E3" class="etiqueta" align="center" width="110">Discounts</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" height="20" class="etiqueta" align="center" width="80">%</td>
 <td width="1" height="20"></td>
 <td bgcolor="#DBE0E3" align="center" height="20" class="etiqueta" width="110">Amount</td>
 <td width="1" bgcolor="#DBE0E3" height="20"></td>
 </tr>
 @%where:tabla|Descuentos;%@ 
 <tr> <td colspan="7" height="1"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="24"></td>
 <td align="center" class="texto" height="24">@%db:Descuentos.monto_final;%@</td>
 <td bgcolor="#DBE0E3" height="24"> </td>
 <td class="texto" align="center" height="24"> @%db:Descuentos.porcentaje%@ %</td>
 <td bgcolor="#DBE0E3" height="24"></td>
 <td class="texto" align="right" height="24">@%db:Descuentos.monto_base;%@</td>
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
 <tr> <td width="195" rowspan="2"> <table width="194" border="0" cellspacing="0" cellpadding="0">
 <tr bgcolor="#DBE0E3"> <td colspan="2" height="1"></td>
 <td rowspan="11" width="1"></td>
 </tr>
 <tr> <td align="right" class="texto" width="112" bgcolor="#EBECED">Total Taxable Income:</td>
 <td width="81" height="22" class="texto"><!-- Total Base Imponible del pedido -->
@%func:calcular_base_imponible%@
</td>
 </tr>
 <tr> <td colspan="2" bgcolor="#DBE0E3" height="1" align="right"></td>
 </tr>
 <tr> <td align="right" class="texto" bgcolor="#EBECED" width="112">Total Taxes:</td>
 <td width="81" height="22" class="texto"><!-- sumatorio de cantidades de impuestos -->
@%func:calcular_total_ivas%@
</td>
 </tr>
 <tr> <td colspan="2" bgcolor="#DBE0E3" height="1" align="right"></td>
 </tr>
 <tr> <td align="right" class="texto" bgcolor="#EBECED" width="112">Deduction:</td>
 <td width="81" height="22" class="texto"><!-- resultado de aplicar la retencion a la base imponible-->
@%func:calcular_total_retencion%@
</td>
 </tr>
 <tr> <td colspan="2" bgcolor="#DBE0E3" height="1" align="right"></td>
 </tr>
 <tr> <td align="right" class="texto" bgcolor="#EBECED" width="112">Surcharge:</td>
 <td width="81" height="22" class="texto"><!-- Sumatorio de recargos de equivalencia por tipo de iva -->
@%func:calcular_total_recargo_equivalencia%@
</td>
 </tr>
 <tr> <td colspan="2" bgcolor="#DBE0E3" height="1" align="right"></td>
 </tr>
 <tr> <td align="right" class="texto" bgcolor="#EBECED" width="112">Total Discount:</td>
 <td width="81" height="22" class="texto"><!-- sumatorio de las cantidades de los decuentos aplicados -->
@%func:calcular_total_descuentos%@
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
 <td height="22" align="right" width="99%" class="texto">
<!-- importe total del pedido (aplicados descuentos, ivas y retenciones)-->
@%func:calcular_total_del_todo;%@
 &gt; Euro</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 </tr>
 <tr bgcolor="#DBE0E3"> <td colspan="3" height="1"></td>
 </tr>
 </table>
 <table width="100%" border="0" cellspacing="0" cellpadding="0">
 <tr align="center">
 <td colspan="3" class="etiqueta" height="10"></td>
 </tr>
 <tr align="center"> <td colspan="3" bgcolor="#CCD2D7" class="etiqueta" height="22">Total amount</td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" width="1"></td>
 <td height="22" align="right" width="99%" class="texto">@%func:calcular_total_en_pesetas;%@
 </td>
 <td bgcolor="#DBE0E3" width="1"></td>
 </tr>
 <tr> <td colspan="3" height="1" bgcolor="#DBE0E3"></td>
 </tr>
 </table>
 </td>
 </tr>
 <tr> <td width="125" bgcolor="#EBECED" valign="top"> <!-- Notas del pedido -->
 <textarea name="textfield" cols="30" wrap="VIRTUAL" rows="4">@%db:Pedidos.observaciones;%@</textarea>
 </td>
 </tr>
 </table>
 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td height="22"></td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="22" align="right">

</td> 
</tr> 
</table> @%end-where:%@

