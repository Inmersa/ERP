<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td height="22" align="right" bgcolor="#CCD2D7"> <table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td width="6" align="center" ></td>
 <td class="titocho" width="250" >&gt; CONFIRMAR PEDIDO
</td>
 <td align="center" ></td>
 <td align="center" ></td>
 <td align="center" ></td>
 <td align="center" ></td>
 <td align="center" ></td>
 <td width="46" align="center" ><a href="?seccion=cli_hacer_pedido" class="accesos">Return</a></td>
 </tr>
 </table>
 </td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" height="4"></td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" height="13"></td>
 </tr>
 <tr> <td bgcolor="#FFFFFF"> 
<form name="hacer_pedido" method="post" action="?seccion=cli_pedidos_cliente">
<input type="hidden" name="Confirmar" value="Confirmar">
 <table width="644" border="0" cellspacing="0" cellpadding="0">
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
 @%end-where:%@ 
 </table>
 </td>
 </tr>
 </table>
 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td colspan="4" height="22"></td>
 </tr>
 <tr> <td colspan="4" bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" align="right" class="texto" width="112" height="22">Order Name:</td>

 <td class="texto" width="190"> <input type="text" name="registro[nombre]" class="insertext" size="25">
 </td>
 <td bgcolor="#EBECED" class="texto" width="95" align="right">Delivery Add.::</td>
 <td width="220">
 <select name="registro[id_direccion]" class="insertext">

@%where:tabla|Direcciones_entrega;where|Direcciones_entrega.id_cliente = $id_cliente;%@
<option value="@%db:Direcciones_entrega.id_direccion;%@">@%db:Direcciones_entrega.nombre;%@ @%db:Direcciones_entrega.direccion;%@
</option>

 @%end-where:%@

 </select>
 </td>
 </tr>
 <tr> <td colspan="4" height="1" bgcolor="#CCD2D7"></td>
 </tr>

 <tr> <td bgcolor="#EBECED" align="right" class="texto" height="22" width="112">Method of payment:</td>
 <td width="217">
<select name="forma_pago" class="insertext">

@%where:tabla|Forma_pago;nolink|1;%@
<option value="@%db:Forma_pago.id_forma_pago;%@"
 @%func:chequear_forma_pago%@>@%db:Forma_pago.nombre;%@ </option> @%end-where:%@

 </select>
 </td>
 <td bgcolor="#EBECED" align="right" class="texto" width="95">Currency:</td>
 <td width="220">
<select name="divisa" class="insertext">
@%where:tabla|Divisa;nolink|1;%@ 
<option value="@%db:Divisa.id_divisa;%@"
 @%func:chequear_divisa%@>@%db:Divisa.nombre;%@
</option>

 @%end-where:%@

 </select>
 </td>
 </tr>
 <tr> <td height="1" colspan="4" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td colspan="4" height="1" bgcolor="#CCD2D7"></td>
 </tr>
 </table>
 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td colspan="17" height="30"></td>
 </tr>
 <tr> <td colspan="17" height="22" bgcolor="#CCD2D7"> <table width="100%" border="0" cellspacing="0" cellpadding="0">
 <tr> <td width="6"></td>
 <td width="419"></td>
 <td align="center" width="100">
<!--<a href="?seccion=hacer_pedido" class="accesos">Add article </a>-->
 </td>
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
 <td bgcolor="#DBE0E3" height="20" class="etiqueta" align="center" width="60"><span class="texto">%</span>Implicated </td>
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

 @%where:nodb|nodb_confirmar_pedido;%@ <!-- aqui empieza el registro -->
 <tr> <td bgcolor="#DBE0E3"></td>
 <td colspan="9" ></td>
 <td></td>
 <td></td>
 <td bgcolor="#DBE0E3"></td>
 <td colspan="3"></td>
 <td></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="22"> <input type="checkbox" name="articulos_confirmados[@%db:id_articulo;%@]" value="1" checked>
 </td>
 <td class="texto" colspan="5">@%db:nombre;%@</td>
 <td bgcolor="#DBE0E3"></td>
 <td class="texto" align="center">@%db:cantidad;%@</td>
 <td bgcolor="#DBE0E3"></td>
 <td class="texto" align="center">@%db:precio_tarifa ;%@</td>
 <td bgcolor="#DBE0E3"></td>
 <td align="center" class="texto">@%db:porcentaje;%@</td>
 <td bgcolor="#DBE0E3"> </td>
 <td class="texto" align="center"> @%db:tipo_descuento;%@ </td>
 <td bgcolor="#DBE0E3"></td>
 <td class="texto" align="right">@%db:base_imponible;%@ %@</td>
 <td bgcolor="#DBE0E3"></td>
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

 @%end-where:%@ @%func:calcula_totales%@ <!--NO KITAR dejar despues del where -->

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
 <td bgcolor="#DBE0E3" align="center" height="20" class="etiqueta">VAT / %</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" align="center" height="20" class="etiqueta" width="120">Surch. / %</td>
 <td width="1" height="20" bgcolor="#DBE0E3"></td>
 </tr>
 @%where:nodb|detalles_iva;%@ <tr> <td colspan="7" height="1"></td>
 </tr>
 <tr> <td height="24" bgcolor="#DBE0E3" ></td>
 <td height="24" align="center" class="texto">@%db:monto;%@</td>
 <td bgcolor="#DBE0E3" height="24"></td>
 <td class="texto" align="center" height="24">@%db:iva;%@ / @%db:porcentaje_iva;%@ %</td>
 <td class="texto" align="center" height="24" bgcolor="#DBE0E3"></td>
 <td class="texto" align="center" height="24">@%db:recargo;%@ / @%db:porcentaje_recargo;%@ %</td>
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
 <tr> <td colspan="7" height="1"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="24"></td>
 <td align="center" class="texto" height="24">@%get:total_sin_descuento%@</td>
 <td bgcolor="#DBE0E3" height="24"> </td>
 <td class="texto" align="center" height="24">@%get:dto_directo%@</td>
 <td bgcolor="#DBE0E3" height="24"></td>
 <td class="texto" align="right" height="24">@%get:detalle_descuento_cliente%@ &gt; Euro</td>
 <td bgcolor="#DBE0E3" height="24"></td>
 </tr>
 <tr> <td colspan="7" height="1"></td>
 </tr>
 <tr> <td height="1" bgcolor="#DBE0E3" colspan="7"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="24"></td>
 <td align="center" class="texto" height="24">@%get:total_sin_descuento%@</td>
 <td bgcolor="#DBE0E3" height="24"> </td>
 <td class="texto" align="center" height="24">@%get:dto_pronto_pago%@</td>
 <td bgcolor="#DBE0E3" height="24"></td>
 <td class="texto" align="right" height="24">@%get:detalle_descuento_cliente_2%@ &gt; Euro</td>
 <td bgcolor="#DBE0E3" height="24"></td>
 </tr>
 <tr> <td colspan="7" height="1"></td>
 </tr>
 <tr> <td height="1" bgcolor="#DBE0E3" colspan="7"></td>
 </tr>
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
 <td width="81" height="22" class="texto"> @%get:total%@</td>
 </tr>
 <tr> <td colspan="2" bgcolor="#DBE0E3" height="1" align="right"></td>
 </tr>
 <tr> <td align="right" class="texto" bgcolor="#EBECED" width="112">Total Taxes:</td>
 <td width="81" height="22" class="texto"> @%get:parcial_iva%@</td>
 </tr>
 <tr> <td colspan="2" bgcolor="#DBE0E3" height="1" align="right"></td>
 </tr>
 <tr> <td align="right" class="texto" bgcolor="#EBECED" width="112">Deduction:</td>
 <td width="81" height="22" class="texto"> @%get:retencion%@ </td>
 </tr>
 <tr> <td colspan="2" bgcolor="#DBE0E3" height="1" align="right"></td>
 </tr>
 <tr> <td align="right" class="texto" bgcolor="#EBECED" width="112">Surcharge:</td>
 <td width="81" height="22" class="texto"> @%get:parcial_recargo%@</td>
 </tr>
 <tr> <td colspan="2" bgcolor="#DBE0E3" height="1" align="right"></td>
 </tr>
 <tr> <td align="right" class="texto" bgcolor="#EBECED" width="112">Total Discount:</td>
 <td width="81" height="22" class="texto"> @%get:total_descuentos%@
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
 <td height="22" align="right" width="99%" class="texto"> <!-- importe total del pedido (aplicados descuentos, ivas y retenciones)-->
 @%get:total_final%@ &gt; Euro</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 </tr>
 <tr bgcolor="#DBE0E3"> <td colspan="3" height="1"></td>
 </tr>
 </table>
 <table width="100%" border="0" cellspacing="0" cellpadding="0">
 <tr align="center"> <td colspan="3" class="etiqueta" height="10"></td>
 </tr>
 <tr align="center"> <td colspan="3" bgcolor="#CCD2D7" class="etiqueta" height="22">Total amount</td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" width="1"></td>
 <td height="22" align="right" width="99%" class="texto">@%calc:total_final * 166.38%@ </td>
 <td bgcolor="#DBE0E3" width="1"></td>
 </tr>
 <tr> <td colspan="3" height="1" bgcolor="#DBE0E3"></td>
 </tr>
 </table>
 </td>
 </tr>
 <tr> <td width="125" bgcolor="#EBECED" valign="top"> <!-- Notas del pedido -->
 <textarea name="registro[observaciones]" cols="30" wrap="VIRTUAL" rows="4"></textarea>
 </td>
 </tr>
 </table>

 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td height="22"></td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="22" align="center">
 <input type="hidden" name="Confirmar" value="Confirmar">
 <a href="" onclick="document.forms['hacer_pedido'].submit();return false;" class="accesos">Confirm</a></td>
 </tr>

 </table>
 </form>
</td>
 </tr>
 <tr> <td height="20"></td>
 </tr>
</table>
