<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td height="22" align="right" bgcolor="#CCD2D7"> <table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td width="6" align="center" ></td>
 <td class="titocho" width="250" >&gt; CONFIRMAR 

@%if:es_pedido%@
 PEDIDO 
@%else:%@ 
@%end-if:%@ 

@%if:es_presupuesto%@
 PRESUPUESTO @%else:%@ @%end-if:%@ 
</td>
 <td width="46" align="center" ><a href="?seccion=hacer_ticket" class="accesos">Voltar</a></td>
 </tr>
 </table>
 </td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" height="3"></td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" height="13"></td>
 </tr>
 <tr> <td bgcolor="#FFFFFF"> 
<form name="hacer_ticket" method="post" action="?seccion=ticket_list">
 
<table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td height="5"></td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" class="etiqueta">Converter em Encomenda Padrão <input type="checkbox" name="pedido_tipo" value="1">
 </td>
 </tr>
 <tr>
 <td height="10"></td>
 </tr>
</table>
 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#EBECED"> <table width="312" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#CCD2D7" height="22" width="6"> </td>
 <td bgcolor="#CCD2D7" height="22" class="etiqueta">Empresa</td>
 </tr>
 @%where:nodb|nodb_issuer_data;%@ 
 <tr> <td height="22"></td>
 <td height="22" class="texto">@%db:razon_social;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td></td>
 <td class="texto" height="22">@%db:direccion_facturacion;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td></td>
 <td class="texto" height="22">@%db:cp;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td></td>
 <td class="texto" height="22">@%db:poblacion;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td></td>
 <td class="texto" height="22">@%db:provincia;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td></td>
 <td class="texto" height="22">Fax: @%db:fax;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td></td>
 <td class="texto" height="22">Tel. @%db:telefono1;%@</td>
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
 <tr> <td bgcolor="#CCD2D7" height="22" align="right" class="etiqueta" width="80">Cliente</td>
 <td bgcolor="#CCD2D7" height="22" width="90"></td>
 <td bgcolor="#CCD2D7" height="22" width="60"></td>
 <td bgcolor="#CCD2D7" height="22"></td>
 </tr>
 @%where:nodb|nodb_reciever_data;%@ <tr> <td height="22" align="right" bgcolor="#EBECED" class="etiqueta">Nome:</td>
 <td height="22" colspan="3" class="texto">@%db:razon_social;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" align="right"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td align="right" bgcolor="#EBECED" class="etiqueta" height="22">Código:</td>
 <td colspan="3" class="texto">@%db:id_cliente;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" align="right"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td align="right" bgcolor="#EBECED" class="etiqueta" height="22">Endereço:</td>
 <td colspan="3" class="texto">@%db:direccion_facturacion;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" align="right"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td align="right" bgcolor="#EBECED" class="etiqueta" height="22">Localidade:</td>
 <td class="texto" colspan="3"> @%db:poblacion;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" align="right"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td align="right" bgcolor="#EBECED" height="22" class="etiqueta">Distrito:</td>
 <td class="texto">@%db:provincia;%@</td>
 <td bgcolor="#EBECED" class="etiqueta" align="right">CP:</td>
 <td class="texto">@%db:cp;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" align="right"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td align="right" bgcolor="#EBECED" height="22" class="etiqueta">CIF:</td>
 <td colspan="3" class="texto">@%db:prefijo_cif;%@-@%db:cif;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" align="right"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td align="right" bgcolor="#EBECED" height="22" class="etiqueta">Telefone:</td>
 <td class="texto">@%db:telefono1;%@</td>
 <td bgcolor="#EBECED" align="right" class="etiqueta">Fax:</td>
 <td class="texto">@%db:fax;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" align="right"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td align="right" bgcolor="#EBECED" height="22" class="etiqueta">e-mail:</td>
 <td colspan="3"><a href="mailto:@%db:email;%@" class="accesos">@%db:email;%@</a></td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="22" align="right" colspan="4"></td>
 </tr>
 @%end-where:%@ 
 </table>
 </td>
 </tr>
 </table>
@%where:nodb|nodb_order_data;%@
@%set:observaciones_en_totales=observaciones;%@
 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td colspan="4" height="22"></td>
 </tr>
 <tr> <td colspan="4" bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" align="right" class="texto" width="112" height="22">Nombre 
@%if:es_pedido%@
Pedido 
@%end-if:%@
@%if:es_presupuesto%@
Presupuesto
@%end-if:%@
:</td>

 <td class="texto" width="190"> <input type="text" name="registro[nombre]" class="insertext" size="25" value="@%db:nombre%@" >
 </td>
 <td bgcolor="#EBECED" class="texto" width="95" align="right">Feito por:</td>
 <td width="220">
@%set:_selected_value=id_agente;%@
 <select name="agente" class="insertext">
@%where:tabla|Agentes;where|Agentes.id_empresa = $id_empresa;%@
<option value="@%db:Agentes.id_agente;%@"
 @%db:selected_value{Agentes.id_agente}%@ >@%db:Agentes.nombre;%@ @%db:Agentes.apellidos;%@</option>
 @%end-where:%@

 </select>
 </td>
 </tr>
 <tr> <td colspan="4" height="1" bgcolor="#CCD2D7"></td>
 </tr>

@%if:es_pedido%@

 <tr> <td bgcolor="#EBECED" align="right" class="texto" height="22" width="112">Modo de Pagamento:</td>
 <td width="217">
@%set:_selected_value=id_forma_pago%@
<select name="forma_pago" class="insertext">
@%where:tabla|Forma_pago;nolink|1;%@
<option value="@%db:Forma_pago.id_forma_pago;%@"
@%db:selected_value{Forma_pago.id_forma_pago}%@
>@%db:Forma_pago.nombre;%@</option> @%end-where:%@

 </select>
 </td>
 <td bgcolor="#EBECED" align="right" class="texto" width="95">Divisa:</td>
 <td width="220">@%set:_selected_value=id_divisa;%@
<select name="divisa" class="insertext">
@%where:tabla|Divisa;nolink|1;%@ 
<option value="@%db:Divisa.id_divisa;%@"
@%db:selected_value{Divisa.id_divisa}%@
>@%db:Divisa.nombre;%@</option>
 @%end-where:%@

 </select>
 </td>
 </tr>
 <tr> <td height="1" colspan="4" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="112" class="texto">Endereço de Entrega:</td>
 <td height="22" colspan="3"> @%set:_selected_value=id_direccion;%@
 <select name="registro[id_direccion]" class="insertext">
@%where:tabla|Direcciones_entrega;where|Direcciones_entrega.id_cliente = $id_cliente_pedido;%@
<option value="@%db:Direcciones_entrega.id_direccion;%@"
@%db:selected_value{Direcciones_entrega.id_direccion}%@
>@%db:Direcciones_entrega.nombre;%@ @%db:Direcciones_entrega.direccion;%@</option>
 @%end-where:%@

 </select>
 </td>
 </tr>
 <tr> <td colspan="4" height="1" bgcolor="#CCD2D7"></td>
 </tr>

@%else:%@

@%end-if:%@

 </table>
@%end-where:%@

 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td colspan="17" height="30"></td>
 </tr>
 <tr> <td colspan="17" height="22" bgcolor="#CCD2D7"> <table width="100%" border="0" cellspacing="0" cellpadding="0">
 <tr> <td width="6"></td>
 <td width="419"></td>
 <td align="center" width="100"><a href="?seccion=hacer_pedido" class="accesos">Adicionar Produto </a></td>
 </tr>
 </table>
 </td>
 </tr>
 <tr> <td colspan="17" height="1"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" width="20" height="22"></td>
 <td bgcolor="#DBE0E3" height="20" class="etiqueta">Nome</td>
 <td width="1" height="20" bgcolor="#DBE0E3"></td>
 <td bgcolor="#DBE0E3" align="center" height="20" class="etiqueta" width="75"></td>
 <td width="1" height="20" bgcolor="#DBE0E3"></td>
 <td bgcolor="#DBE0E3" align="center" height="20" class="etiqueta" width="60"></td>
 <td width="1" height="20"></td>
 <td bgcolor="#DBE0E3" align="center" height="20" class="etiqueta" width="60">Quantidade</td>
 <td width="1" height="20"></td>
 <td bgcolor="#DBE0E3" align="center" height="20" class="etiqueta" width="60">Preço</td>
 <td width="1" height="20"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center" width="60">IVA</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" height="20" class="etiqueta" align="center" width="60"> Descontos </td>
 <td width="1" height="20"></td>
 <td bgcolor="#DBE0E3" align="center" height="20" class="etiqueta" width="110">Montante</td>
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
 <tr> <td bgcolor="#DBE0E3" height="22"> <input type="checkbox" name="articulos_confirmados[@%db:idx_detalle;%@]" value="1" checked>
 </td>
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
 <td colspan="7" >
<input type="text" name="observaciones[@%db:idx_detalle;%@]" class="insertext" size="70" value="@%db:observaciones%@">
@%set:id_articulo=id_articulo;%@
@%set:_selected_value=id_servicio;%@
@%if:servicio_articulo%@
</td><td colspan="8" align="right">
<select name="servicios[@%db:idx_detalle;%@]">
<option value="">Nenhum</option>
@%where:tabla|Empresas_servicios;nolink|1;where|id_articulo = $id_articulo AND id_empresa = $id_empresa;%@
<option value="@%db:Servicios.id_servicio;%@"
@%db:selected_value{Servicios.id_servicio}%@
>@%db:Servicios.nombre;%@</option>
 @%end-where:%@

</select>
 </td>
@%else:%@
 </td>
 <td></td>
 <td></td>
 <td bgcolor="#DBE0E3"></td>
 <td colspan="1"></td>
 <td bgcolor="#DBE0E3"></td>
 <td colspan="1"></td>
 <td bgcolor="#DBE0E3"></td>
 <td colspan="1"></td>
@%end-if:%@

 <td bgcolor="#DBI0I3"></td>
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
 <td bgcolor="#DBE0E3" height="20" class="etiqueta" align="center">Valor Tributável</td>
 <td width="1" height="20"></td>
 <td bgcolor="#DBE0E3" align="center" height="20" class="etiqueta">IVA %</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" align="center" height="20" class="etiqueta" width="120">Sobretaxa Equivalente %</td>
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
 <td bgcolor="#DBE0E3" class="etiqueta" align="center">Valor Tributável</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" height="20" class="etiqueta" align="center">Desconto</td>
 <td width="1" height="20"></td>
 <td bgcolor="#DBE0E3" align="center" height="20" class="etiqueta" width="80">Montante</td>
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
 <tr> <td align="right" class="texto" width="112" bgcolor="#EBECED">Total do Valor Tributável:</td>
 <td width="81" height="22" class="texto"> @%db:base_imponible;%@</td>
 </tr>
 <tr> <td colspan="2" bgcolor="#DBE0E3" height="1" align="right"></td>
 </tr>
 <tr> <td align="right" class="texto" bgcolor="#EBECED" width="112">Total de Impostos:</td>
 <td width="81" height="22" class="texto"> @%db:impuestos;%@</td>
 </tr>
 <tr> <td colspan="2" bgcolor="#DBE0E3" height="1" align="right"></td>
 </tr>
 <tr> <td align="right" class="texto" bgcolor="#EBECED" width="112">Retenção:</td>
 <td width="81" height="22" class="texto"> @%db:retenido;%@ </td>
 </tr>
 <tr> <td colspan="2" bgcolor="#DBE0E3" height="1" align="right"></td>
 </tr>
 <tr> <td align="right" class="texto" bgcolor="#EBECED" width="112">Sobretaxa Equivalente:</td>
 <td width="81" height="22" class="texto"> @%db:recargos;%@</td>
 </tr>
 <tr> <td colspan="2" bgcolor="#DBE0E3" height="1" align="right"></td>
 </tr>
 <tr> <td align="right" class="texto" bgcolor="#EBECED" width="112">Desconto Total:</td>
 <td width="81" height="22" class="texto"> @%db:descuentos;%@ <!--@%db:sin_retencion;%@-->
 </td>
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
 <td height="22" align="right" width="99%" class="texto"> @%db:importe;%@ @%db:leyenda_divisa%@</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 </tr>
 <tr bgcolor="#DBE0E3"> <td colspan="3" height="1"></td>
 </tr>
 </table>
 </td>
 </tr>
 <tr> <td width="125" bgcolor="#EBECED" valign="top"> <!-- Notas del pedido -->
 <textarea name="registro[observaciones]" cols="30" wrap="VIRTUAL" rows="4">@%get:observaciones_en_totales%@</textarea>
 </td>
 </tr>
 </table>
 @%end-where:%@ 
 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td height="22"></td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="22" align="center">
 <input type="hidden" name="Confirmar" value="Confirmar">
 <a href="" onclick="document.forms['hacer_ticket'].submit();return false;" class="accesos">Confirmar</a></td>
 </tr>

 </table>
 </form>
</td>
 </tr>
 <tr> <td height="20"></td>
 </tr>
</table>
