@%where:name|Pedido;format_name|classDocument;%@
<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td height="22" align="right" bgcolor="#CCD2D7"> <table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td width="6" align="center" ></td>
 <td class="titocho" width="250" >&gt; Confirmar 
@%if:esta_vacio;es_pedido;%@
@%if:esta_vacio;es_factura;%@
 Pressuposts @%set:send_form_to=bo_presupuestos_compras;%@
 @%else:%@ 
 Factures @%set:send_form_to=bo_facturas_compra;%@
 @%end-if:%@ 
@%else:%@ 
Comanda @%set:send_form_to=bo_pedidos_compras;%@
@%end-if:%@ 
</td>
 <td width="46" align="center" ><a href="?seccion=hacer_pedido_compra" class="accesos">Tornar</a></td>
 </tr>
 </table>
 </td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" height="3"></td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" height="13"></td>
 </tr>
 <tr> <td bgcolor="#FFFFFF"> 
<form name="hacer_pedido" method="post" action="?seccion=@%get:send_form_to;%@">
@%if:esta_vacio;es_pedido%@
@%else:%@
<table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td height="5"></td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" class="titul1">Consolidar Comanda tipus <input type="checkbox" name="pedido_tipo" value="1">
 </td>
 </tr>
 <tr>
 <td height="10"></td>
 </tr>
</table>
@%end-if:%@ 
<table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#EBECED"> <table width="312" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#CCD2D7" height="22" width="6"> </td>
 <td bgcolor="#CCD2D7" height="22" class="titul1">Proveïdor</td>
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
 <tr> <td bgcolor="#CCD2D7" height="22" align="right" class="titul1" width="80">Empresa</td>
 <td bgcolor="#CCD2D7" height="22" width="90"></td>
 <td bgcolor="#CCD2D7" height="22" width="60"></td>
 <td bgcolor="#CCD2D7" height="22"></td>
 </tr>
 @%where:nodb|nodb_reciever_data;%@ 
 <tr> <td height="22" align="right" bgcolor="#EBECED" class="titul1">Nom:</td>
 <td height="22" colspan="3" class="texto">@%db:razon_social;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" align="right"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td align="right" bgcolor="#EBECED" class="titul1" height="22">Codi:</td>
 <td colspan="3" class="texto">@%db:id_cliente;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" align="right"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td align="right" bgcolor="#EBECED" class="titul1" height="22">Domicili:</td>
 <td colspan="3" class="texto">@%db:direccion_facturacion;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" align="right"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td align="right" bgcolor="#EBECED" class="titul1" height="22">Població:</td>
 <td class="texto" colspan="3"> @%db:poblacion;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" align="right"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td align="right" bgcolor="#EBECED" height="22" class="titul1">Província:</td>
 <td class="texto">@%db:provincia;%@</td>
 <td bgcolor="#EBECED" class="titul1" align="right">CP:</td>
 <td class="texto">@%db:cp;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" align="right"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td align="right" bgcolor="#EBECED" height="22" class="titul1">CIF:</td>
 <td colspan="3" class="texto">@%db:prefijo_cif;%@-@%db:cif;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" align="right"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td align="right" bgcolor="#EBECED" height="22" class="titul1">Telèfon:</td>
 <td class="texto">@%db:telefono1;%@</td>
 <td bgcolor="#EBECED" align="right" class="titul1">Fax:</td>
 <td class="texto">@%db:fax;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" align="right"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td align="right" bgcolor="#EBECED" height="22" class="titul1">e-mail:</td>
 <td colspan="3"><a href="mailto:@%db:email;%@" class="accesos">@%db:email;%@</a></td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="22" align="right" colspan="4"></td>
 </tr>
 @%end-where:%@ 

 </table>
 </td>
 </tr>
 </table>
@%where:nodb|nodb_order_details;format_name|classDocumentDetail;%@ 
@%set:observaciones_en_totales=observaciones;%@
 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td colspan="4" height="22"></td>
 </tr>
 <tr> <td colspan="4" bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" align="right" class="texto" width="112" height="22">Nom document :</td>
 <td class="texto" width="190"> <input type="text" name="registro[nombre]" class="insertext" size="25" value="@%db:nombre%@" >
 </td>
 </tr>
 <tr> <td colspan="4" height="1" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" align="right" class="texto" height="22" width="112">Forma de paga:</td>
 <td width="217">
@%set:_selected_value=id_forma_pago%@
<select name="forma_pago" class="insertext">
@%where:tabla|Forma_pago;nolink|1;%@
<option value="@%db:Forma_pago.id_forma_pago;%@"
@%db:selected_value{Forma_pago.id_forma_pago}%@
>@%db:Forma_pago.nombre;%@</option> 
@%end-where:%@

 </select>
 </td>
 <td bgcolor="#EBECED" align="right" class="texto" width="95">Divisa:</td>
 <td width="220" class="texto">@%db:nombre_divisa;%@</td>
 </tr>
 <tr> <td height="1" colspan="4" bgcolor="#CCD2D7"></td>
 </tr>

@%if:esta_vacio;es_pedido%@
@%else:%@
 <tr> <td bgcolor="#EBECED" width="112" class="texto">Direcció entrega:</td>
 <td height="22" > @%set:_selected_value=id_direccion%@
 <select name="registro[id_direccion]" class="insertext">
@%where:tabla|Almacenes;where|Almacenes.id_empresa = $id_cliente_pedido;%@
<option value="@%db:Almacenes.id_almacen;%@"
@%db:selected_value{Almacenes.id_almacen}%@
>@%db:Almacenes.nombre;%@ @%db:Almacenes.direccion;%@</option>
 @%end-where:%@

 </select>
 </td>
 <td bgcolor="#EBECED" class="texto" width="95" align="right">Realitzar per:</td>
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
@%end-if:%@

 </table>
@%end-where:%@

 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td colspan="17" height="30"></td>
 </tr>
 <tr> <td colspan="17" height="22" bgcolor="#CCD2D7"> <table width="100%" border="0" cellspacing="0" cellpadding="0">
 <tr> <td width="6"></td>
 <td width="419"></td>
 <td align="center" width="100"><a href="?seccion=hacer_pedido_compra" class="accesos">Afegir article </a></td>
 </tr>
 </table>
 </td>
 </tr>
 <tr> <td colspan="17" height="1"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" width="20" height="22"></td>
 <td bgcolor="#DBE0E3" height="20" class="titul1">Nom</td>
 <td width="1" height="20" bgcolor="#DBE0E3"></td>
 <td bgcolor="#DBE0E3" align="center" height="20" class="titul1" width="75"></td>
 <td width="1" height="20" bgcolor="#DBE0E3"></td>
 <td bgcolor="#DBE0E3" align="center" height="20" class="titul1" width="60"></td>
 <td width="1" height="20"></td>
 <td bgcolor="#DBE0E3" align="center" height="20" class="titul1" width="60">Quantitat</td>
 <td width="1" height="20"></td>
 <td bgcolor="#DBE0E3" align="center" height="20" class="titul1" width="60">Preu</td>
 <td width="1" height="20"></td>
 <td bgcolor="#DBE0E3" class="titul1" align="center" width="60">IVA</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" height="20" class="titul1" align="center" width="60"> Desc. </td>
 <td width="1" height="20"></td>
 <td bgcolor="#DBE0E3" align="center" height="20" class="titul1" width="110">Import</td>
 <td width="1" bgcolor="#DBE0E3" height="20"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3"></td>
 <td colspan="9"></td>
 <td></td>
 <td></td>
 <td bgcolor="#DBE0E3"></td>
 <td colspan="4"></td>
 </tr>
 @%where:nodb|nodb_order_details;%@ 
 <!-- aqui empieza el registro -->
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
 <td class="texto" align="center">@%db:precio%@</td>
 <td bgcolor="#DBE0E3"></td>
 <td align="center" class="texto">@%db:porcentaje;%@</td>
 <td bgcolor="#DBE0E3"> </td>
 <td class="texto" align="center"> @%db:tipo_descuento;%@ </td>
 <td bgcolor="#DBE0E3"></td>
 <td class="texto" align="right">@%db:base_imponible;%@ @%db:leyenda_divisa%@</td>
 <td bgcolor="#DBE0E3"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3"></td>
 <td 
 @%if:esta_vacio;es_factura;%@
 	@%if:esta_vacio;id_servicio;available_contracts%@
		colspan="15"
	@%else:%@
		colspan="7"
	@%end-if:%@
 @%else:%@
 	colspan="15"
 @%end-if:%@
		>
<input type="text" name="observaciones[@%db:idx_detalle;%@]" class="insertext" size="70" value="@%db:observaciones%@">
@%set:id_articulo=id_articulo;%@
@%if:esta_vacio;es_factura;%@
	@%if:esta_vacio;id_servicio;available_contracts;%@
	@%else:%@
	</td><td colspan="8" align="right">
		@%set:_selected_value=id_servicio;%@
		<select name="servicios[@%db:idx_detalle;%@]">
		<option value="">Cap</option>
		@%where:nodb|nodb_detail_contracts;%@
		<option value="@%db:id;%@" 
		  @%db:selected_value{id};%@
		  >@%db:nombre;%@ @%db:id;%@</option>
		@%end-where:%@

		</select>
 	</td>
	@%end-if:%@
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
 @%end-where:%@ 
 
 </table>
 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td></td>
 <td></td>
 <td></td>
 </tr>
 <tr> <td valign="top"> <table width="100%" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#DBE0E3" height="20" class="titul1" align="center" width="1"></td>
 <td bgcolor="#DBE0E3" height="20" class="titul1" align="center">Base imposable</td>
 <td width="1" height="20"></td>
 <td bgcolor="#DBE0E3" align="center" height="20" class="titul1">IVA %</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" align="center" height="20" class="titul1" width="120">Recàrrec equivalent %</td>
 <td width="1" height="20" bgcolor="#DBE0E3"></td>
 </tr>
 @%where:nodb|nodb_taxes_detail;%@ 
 <!-- @%db:base_imponible;%@ -->
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
 @%end-where:%@ 
 
 </table>
 </td>
 <td width="40"></td>
 <td valign="top"> <table width="100%" border="0" cellspacing="0" cellpadding="0">
 <tr> <td width="1" height="20" bgcolor="#DBE0E3"></td>
 <td bgcolor="#DBE0E3" class="titul1" align="center">Base imposable</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" height="20" class="titul1" align="center">Descomptes</td>
 <td width="1" height="20"></td>
 <td bgcolor="#DBE0E3" align="center" height="20" class="titul1" width="80">Import</td>
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
 p
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
 <tr> <td align="right" class="texto" width="112" bgcolor="#EBECED">Total base imposable:</td>
 <td width="81" height="22" class="texto"> @%db:base_imponible;%@</td>
 </tr>
 <tr> <td colspan="2" bgcolor="#DBE0E3" height="1" align="right"></td>
 </tr>
 <tr> <td align="right" class="texto" bgcolor="#EBECED" width="112">Totals Imposts:</td>
 <td width="81" height="22" class="texto"> @%db:impuestos;%@</td>
 </tr>
 <tr> <td colspan="2" bgcolor="#DBE0E3" height="1" align="right"></td>
 </tr>
 <tr> <td align="right" class="texto" bgcolor="#EBECED" width="112">Retenció:</td>
 <td width="81" height="22" class="texto"> @%db:retenido;%@ </td>
 </tr>
 <tr> <td colspan="2" bgcolor="#DBE0E3" height="1" align="right"></td>
 </tr>
 <tr> <td align="right" class="texto" bgcolor="#EBECED" width="112">Recàrrec equivalent:</td>
 <td width="81" height="22" class="texto"> @%db:recargos;%@</td>
 </tr>
 <tr> <td colspan="2" bgcolor="#DBE0E3" height="1" align="right"></td>
 </tr>
 <tr> <td align="right" class="texto" bgcolor="#EBECED" width="112">Total Descompte:</td>
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
 <tr align="center"> <td colspan="3" bgcolor="#CCD2D7" class="titul1" height="22">Import Total </td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" width="1"></td>
 <td height="22" align="right" width="99%" class="texto"> @%db:importe;%@ @%db:leyenda_divisa%@</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 </tr>
 <tr bgcolor="#DBE0E3"> <td colspan="3" height="1"></td>
 </tr>
 </table>
@%if:esta_vacio;divisa_cliente_importe%@
@%else:%@
<br><br>
 <table width="100%" border="0" cellspacing="0" cellpadding="0">
 <tr align="center"> <td colspan="3" bgcolor="#CCD2D7" class="titul1" height="22">Import en @%db:divisa_cliente_nombre%@</td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" width="1"></td>
 <td height="22" align="right" width="99%" class="texto"> @%db:divisa_cliente_importe;%@ @%db:divisa_cliente_leyenda%@</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 </tr>
 <tr bgcolor="#DBE0E3"> <td colspan="3" height="1"></td>
 </tr>
 </table>
@%end-if:%@
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
 <a href="" onclick="document.forms['hacer_pedido'].submit();return false;" class="accesos">Confirmar</a></td>
 </tr>

 </table>
 </form>
</td>
 </tr>
 <tr> <td height="20"></td>
 </tr>
</table>
