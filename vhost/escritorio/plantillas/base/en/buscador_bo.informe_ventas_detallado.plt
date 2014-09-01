
<form method=post action="?seccion=informe_ventas_detallado">
<input type="hidden" name="nom_bus" value="informe_ventas_detallado">
<table class="full">
  <tr> 
  <td class="caption" align="left">Sales: Detailed Invoicing report</td>
  <td class="caption" align="right">
        <input type="submit" name="Buscar" value="Search" class="insertext" accesskey="f" >
		 <select name="hp">
		@%where:nodb|nodb_hits_page;%@
		<option value="@%db:value;%@"
		@%if:equals;st_hp;value;%@
		selected="selected"
		@%end-if:%@
		>@%db:name;%@</option>
		@%end-where:%@

		</select>
  </td></tr>
</table>
<br>
<table class="full" >
  <td align="right" class="check" >
  <input type="checkbox" name="ag_search" value="1"
  @%if:esta_vacio;st[ag_search];%@
  @%else:@
  checked="checked"
  @%end-if:%@
  ></td>
  <td align="left" class="caption" colspan="10">Agents</td>
  </tr>

  <tr><td class="etiqueta">ID:</td>
  <td colspan="2"><input type="text" name="ag_id" size="20" class="insertext" value="@%get:st[ag_id];%@"></td>
  <td class="etiqueta" colspan="2">Name:</td>
  <td colspan="2"><input type="text" name="ag_nombre" size="30" class="insertext" value="@%get:st[ag_nombre];%@"></td>
  <td class="etiqueta" colspan="2">Type:</td>
  <td colspan="2"><!-- @%set:_selected_value=st[ag_tipo];%@ -->
  <select name="ag_tipo" class="insertext">
  <option value="">No selection</option>
  @%where:tabla|Tipo_agente;nolink|1;nombre|tipos;%@
  <option value="@%db:Tipo_agente.id_tipo_agente;%@"
  @%db:selected_value{Tipo_agente.id_tipo_agente}%@
  >@%db:Tipo_agente.nombre;%@</option>
  @%end-where:%@

  </select>
  </tr>
  <tr><td class="titulotb" colspan="11">Total</td></tr>

  <tr>
  <td class="etiqueta" >Taxable Income
  <input type="hidden" name="totales[Agentes.id_agente][Taxable Income][field]" 
  	value="IF(Facturas.factura_abono,(Facturas.base_imponible*-1),Facturas.base_imponible)" />
  <input type="hidden" name="totales[Agentes.id_agente][Taxable Income][round]" value="2" />
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Taxable Income][Maximum]" value="max"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.base_imponible;max;%@ />
  </td><td>
  Maximum Value 
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Taxable Income][Minimum]" value="min"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.base_imponible;min;%@ />
  </td><td>
  Minimum Value
  </td><td class="check">
  <!-- input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Taxable Income][Average]" value="avg"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.base_imponible;avg;%@ / -->
  </td><td>
  <!-- Average -->
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Taxable Income][Nº]" value="count"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.base_imponible;count;%@ />
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Taxable Income][Summation]" value="sum"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.base_imponible;sum;%@ />
  </td><td>
  Summation
  </td>

  <tr>
  <td class="etiqueta" >Total Taxes
  <input type="hidden" name="totales[Agentes.id_agente][Total Taxes][field]" 
  	value="IF(Facturas.factura_abono,(Facturas.base_imponible*-1),Facturas.total_impuestos)" />
  <input type="hidden" name="totales[Agentes.id_agente][Total Taxes][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Total Taxes][Maximum]" value="max"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.total_impuestos;max;%@>
  </td><td>
  Maximum Value
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Total Taxes][Minimum]" value="min"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.total_impuestos;min;%@>
  </td><td>
  Minimum Value
  </td><td class="check">
  <!-- input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Total Taxes][Average]" value="avg"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.total_impuestos;avg;%@ -->
  </td><td>
  <!-- Average -->
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Total Taxes][Nº]" value="count"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.total_impuestos;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Total Taxes][Summation]" value="sum"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.total_impuestos;sum;%@>
  </td><td>
  Summation
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Retained
  <input type="hidden" name="totales[Agentes.id_agente][Retained][field]" 
  	value="IF(Facturas.factura_abono,(Facturas.retenido*-1),Facturas.retenido)" />
  <input type="hidden" name="totales[Agentes.id_agente][Retained][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Retained][Maximum]" value="max"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.retenido;max;%@>
  </td><td>
  Maximum Value
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Retained][Minimum]" value="min"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.retenido;min;%@>
  </td><td>
  Minimum Value
  </td><td class="check">
  <!-- input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Retained][Average]" value="avg"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.retenido;avg;%@ -->
  </td><td>
  <!-- Average -->
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Retained][Nº]" value="count"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.retenido;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Retained][Summation]" value="sum"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.retenido;sum;%@>
  </td><td>
  Summation
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Gross Total
  <input type="hidden" name="totales[Agentes.id_agente][Gross Total][field]" 
  	value="IF(Facturas.factura_abono,(Facturas.total_bruto*-1),Facturas.total_bruto)" />
  <input type="hidden" name="totales[Agentes.id_agente][Gross Total][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Gross Total][Maximum]" value="max"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.total_bruto;max;%@>
  </td><td>
  Maximum Value
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Gross Total][Minimum]" value="min"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.total_bruto;min;%@>
  </td><td>
  Minimum Value
  </td><td class="check">
  <!-- input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Gross Total][Average]" value="avg"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.total_bruto;avg;%@ -->
  </td><td>
  <!-- Average -->
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Gross Total][Nº]" value="count"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.total_bruto;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Gross Total][Summation]" value="sum"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.total_bruto;sum;%@>
  </td><td>
  Summation
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Amount
  <input type="hidden" name="totales[Agentes.id_agente][Amount][field]" 
  	value="IF(Facturas.factura_abono,(Facturas.monto_total*-1),Facturas.monto_total)" />
  <input type="hidden" name="totales[Agentes.id_agente][Amount][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Amount][Maximum]" value="max"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.monto_total;max;%@>
  </td><td>
  Maximum Value
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Amount][Minimum]" value="min"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.monto_total;min;%@>
  </td><td>
  Minimum Value
  </td><td class="check">
  <!-- input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Amount][Average]" value="avg"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.monto_total;avg;%@ -->
  </td><td>
  <!-- Average -->
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Amount][Nº]" value="count"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.monto_total;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Amount][Summation]" value="sum"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.monto_total;sum;%@>
  </td><td>
  Summation
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Commissions
  <input type="hidden" name="totales[Agentes.id_agente][Commission Amount][field]" value="Agentes_facturas.monto">
  <input type="hidden" name="totales[Agentes.id_agente][Commission Amount][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Commission Amount][Maximum]" value="max"
  @%func:checkbox_mark;Agentes.id_agente;Agentes_facturas.monto;max;%@>
  </td><td>
  Maximum Value
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Commission Amount][Minimum]" value="min"
  @%func:checkbox_mark;Agentes.id_agente;Agentes_facturas.monto;min;%@>
  </td><td>
  Minimum Value
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Commission Amount][Average]" value="avg"
  @%func:checkbox_mark;Agentes.id_agente;Agentes_facturas.monto;avg;%@>
  </td><td>
  Average
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Commission Amount][Nº]" value="count"
  @%func:checkbox_mark;Agentes.id_agente;Agentes_facturas.monto;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Commission Amount][Summation]" value="sum"
  @%func:checkbox_mark;Agentes.id_agente;Agentes_facturas.monto;sum;%@>
  </td><td>
  Summation
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Commissions <sup>(by client)</sup>
  <input type="hidden" name="totales[Clientes.id_cliente][Commission Amount by client][field]" value="Agentes_facturas.monto">
  <input type="hidden" name="totales[Clientes.id_cliente][Commission Amount by client][round]" value="2">
  <input type="hidden" name="totales[Clientes.id_cliente][Commission Amount by client][erase_without]" value="ag_search">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Commission Amount by client][Maximum]" value="max"
  @%func:checkbox_mark;Clientes.id_cliente;Agentes_facturas.monto;max;%@>
  </td><td>
  Maximum Value
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Commission Amount by client][Minimum]" value="min"
  @%func:checkbox_mark;Clientes.id_cliente;Agentes_facturas.monto;min;%@>
  </td><td>
  Minimum Value
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Commission Amount by client][Average]" value="avg"
  @%func:checkbox_mark;Clientes.id_cliente;Agentes_facturas.monto;avg;%@>
  </td><td>
  Average
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Commission Amount by client][Nº]" value="count"
  @%func:checkbox_mark;Clientes.id_cliente;Agentes_facturas.monto;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Commission Amount by client][Summation]" value="sum"
  @%func:checkbox_mark;Clientes.id_cliente;Agentes_facturas.monto;sum;%@>
  </td><td>
  Summation
  </td>
  </tr>

</table>

<br>
<table class="full" >
  <tr><td align="left" class="caption" colspan="11">Clients</td></tr>

  <tr><td class="etiqueta">ID:</td>
  <td colspan="2"><input type="text" name="cl_id" size="20" class="insertext" value="@%get:st[cl_id];%@"></td>
  <td class="etiqueta" colspan="2">Name:</td>
  <td colspan="2"><input type="text" name="cl_nombre" size="30" class="insertext" value="@%get:st[cl_nombre];%@"></td>
  <td class="etiqueta" colspan="2">Type:</td>
  <td colspan="2"><!-- @%set:_selected_value=st[cl_tipo];%@ -->
  <select name="cl_tipo" class="insertext">
  <option value="">No selection</option>
  @%where:tabla|Tipo_cliente;nolink|1;nombre|tiposcl;%@
  <option value="@%db:Tipo_cliente.id_tipo_cliente;%@"
  @%db:selected_value{Tipo_cliente.id_tipo_cliente}%@
  >@%db:Tipo_cliente.nombre;%@</option>
  @%end-where:%@

  </select>
  </td>
  </tr>

  <tr><td class="caption" colspan="12">Invoices</td></tr>

  <tr><td class="etiqueta">Ref.:</td>
  <td colspan="2"><input type="text" name="fr_ref" size="20" class="insertext" value="@%get:st[fr_ref];%@"></td>
  <td class="etiqueta" colspan="2">Ext. Ref.:</td>
  <td colspan="2"><input type="text" name="fr_ref_ext" size="30" class="insertext" value="@%get:st[fr_ref_ext];%@"></td>
  <td class="etiqueta" colspan="2">Serial:</td>
  <td colspan="2"><!-- @%set:_selected_value=st[fr_serie];%@ -->
  <select name="fr_serie" class="insertext">
  <option value="">No selection</option>
  @%where:tabla|Series_facturacion;nolink|1;nombre|seriesfra;where|ventas=1;%@
  <option value="@%db:Series_facturacion.id_serie;%@"
  @%db:selected_value{Series_facturacion.id_serie}%@
  >@%db:Series_facturacion.nombre;%@ 
  (@%db:si_no_flag{Series_facturacion.contabilizable}%@)</option>
  @%end-where:%@

  </select>
  </tr>

  <tr><td class="etiqueta">From:</td>
  <td colspan="2"><input type=text name="fr_fecha_inicio" size="20" class="insertext" value="@%get:st[fr_fecha_inicio];%@"></td>
  <td class="etiqueta" colspan="2">To:</td>
  <td colspan="2"><input type=text name="fr_fecha_fin" size="20" class="insertext" value="@%get:st[fr_fecha_fin];%@"></td>
  <td class="etiqueta" colspan="2">Taxable Income > :</td>
  <td colspan="2"><input type=text name="fr_basei" size="20" class="insertext" value="@%get:st[fr_basei];%@"></td>
  </tr>

  <tr>
  <td class="check" >
  <input type="checkbox" name="ef_search" value="1"
  @%if:esta_vacio;st[ef_search];%@
  @%else:@
  checked="checked"
  @%end-if:%@
  ></td>
  <td class="caption" colspan="10">Drafts</td>
  </tr>

  <tr>
  <td class="check" >
  <input type="checkbox" name="ic_search" value="1"
  @%if:esta_vacio;st[ic_search];%@
  @%else:@
  checked="checked"
  @%end-if:%@
  ></td>
  <td class="caption" colspan="10">Events</td>
  </tr>

  <tr><td class="titulotb" colspan="11">Total</td></tr><tr>

  <td class="etiqueta" >Taxable Income
  <input type="hidden" name="totales[Clientes.id_cliente][Taxable Income][field]" 
  	value="IF(Facturas.factura_abono,(Facturas.base_imponible*-1),Facturas.base_imponible)" />
  <input type="hidden" name="totales[Clientes.id_cliente][Taxable Income][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Taxable Income][Maximum]" value="max"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.base_imponible;max;%@>
  </td><td>
  Maximum Value
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Taxable Income][Minimum]" value="min"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.base_imponible;min;%@>
  </td><td>
  Minimum Value
  </td><td class="check">
  <!-- input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Taxable Income][Average]" value="avg"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.base_imponible;avg;%@ -->
  </td><td>
  <!-- Average -->
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Taxable Income][Nº]" value="count"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.base_imponible;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Taxable Income][Summation]" value="sum"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.base_imponible;sum;%@>
  </td><td>
  Summation
  </td></tr>

  <tr>
  <td class="etiqueta" >Total Taxes
  <input type="hidden" name="totales[Clientes.id_cliente][Total Taxes][field]" 
  	value="IF(Facturas.factura_abono,(Facturas.total_impuestos*-1),Facturas.total_impuestos)" />
  <input type="hidden" name="totales[Clientes.id_cliente][Total Taxes][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Total Taxes][Maximum]" value="max"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.total_impuestos;max;%@>
  </td><td>
  Maximum Value
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Total Taxes][Minimum]" value="min"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.total_impuestos;min;%@>
  </td><td>
  Minimum Value
  </td><td class="check">
  <!-- input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Total Taxes][Average]" value="avg"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.total_impuestos;avg;%@ -->
  </td><td>
  <!-- Average -->
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Total Taxes][Nº]" value="count"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.total_impuestos;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Total Taxes][Summation]" value="sum"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.total_impuestos;sum;%@>
  </td><td>
  Summation
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Retained
  <input type="hidden" name="totales[Clientes.id_cliente][Retained][field]" 
  	value="IF(Facturas.factura_abono,(Facturas.retenido*-1),Facturas.retenido)" />
  <input type="hidden" name="totales[Clientes.id_cliente][Retained][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Retained][Maximum]" value="max"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.retenido;max;%@>
  </td><td>
  Maximum Value
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Retained][Minimum]" value="min"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.retenido;min;%@>
  </td><td>
  Minimum Value
  </td><td class="check">
  <!-- input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Retained][Average]" value="avg"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.retenido;avg;%@ -->
  </td><td>
  <!-- Average -->
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Retained][Nº]" value="count"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.retenido;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Retained][Summation]" value="sum"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.retenido;sum;%@>
  </td><td>
  Summation
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Gross Total
  <input type="hidden" name="totales[Clientes.id_cliente][Gross Total][field]" 
  	value="IF(Facturas.factura_abono,(Facturas.total_bruto*-1),Facturas.total_bruto)" />
  <input type="hidden" name="totales[Clientes.id_cliente][Gross Total][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Gross Total][Maximum]" value="max"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.total_bruto;max;%@>
  </td><td>
  Maximum Value
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Gross Total][Minimum]" value="min"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.total_bruto;min;%@>
  </td><td>
  Minimum Value
  </td><td class="check">
  <!-- input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Gross Total][Average]" value="avg"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.total_bruto;avg;%@ -->
  </td><td>
  <!-- Average -->
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Gross Total][Nº]" value="count"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.total_bruto;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Gross Total][Summation]" value="sum"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.total_bruto;sum;%@>
  </td><td>
  Summation
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Amount
  <input type="hidden" name="totales[Clientes.id_cliente][Amount][field]" 
  	value="IF(Facturas.factura_abono,(Facturas.monto_total*-1),Facturas.monto_total)" />
  <input type="hidden" name="totales[Clientes.id_cliente][Amount][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Amount][Maximum]" value="max"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.monto_total;max;%@>
  </td><td>
  Maximum Value
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Amount][Minimum]" value="min"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.monto_total;min;%@>
  </td><td>
  Minimum Value
  </td><td class="check">
  <!-- input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Amount][Average]" value="avg"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.monto_total;avg;%@ -->
  </td><td>
  <!-- Average -->
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Amount][Nº]" value="count"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.monto_total;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Amount][Summation]" value="sum"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.monto_total;sum;%@>
  </td><td>
  Summation
  </td>
  </tr>

</table>
<br>

<br>
  </form>

