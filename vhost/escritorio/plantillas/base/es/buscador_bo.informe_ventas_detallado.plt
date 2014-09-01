
<form method=post action="?seccion=informe_ventas_detallado">
<input type="hidden" name="nom_bus" value="informe_ventas_detallado">
<table class="full">
  <tr> 
  <td class="caption" align="left">Informe Detallado de Facturación en ventas</td>
  <td class="caption" align="right">
        <input type="submit" name="Buscar" value="Buscar" class="insertext" accesskey="b" >
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
  <td align="left" class="caption" colspan="10">Agentes</td>
  </tr>

  <tr><td class="etiqueta">ID:</td>
  <td colspan="2"><input type="text" name="ag_id" size="20" class="insertext" value="@%get:st[ag_id];%@"></td>
  <td class="etiqueta" colspan="2">Nombre:</td>
  <td colspan="2"><input type="text" name="ag_nombre" size="30" class="insertext" value="@%get:st[ag_nombre];%@"></td>
  <td class="etiqueta" colspan="2">Tipo:</td>
  <td colspan="2"><!-- @%set:_selected_value=st[ag_tipo];%@ -->
  <select name="ag_tipo" class="insertext">
  <option value="">-- Ninguna seleccion --</option>
  @%where:tabla|Tipo_agente;nolink|1;nombre|tipos;%@
  <option value="@%db:Tipo_agente.id_tipo_agente;%@"
  @%db:selected_value{Tipo_agente.id_tipo_agente}%@
  >@%db:Tipo_agente.nombre;%@</option>
  @%end-where:%@

  </select>
  </tr>
  <tr><td class="titulotb" colspan="11">Totales</td></tr>

  <tr>
  <td class="etiqueta" >Base Imponible
  <input type="hidden" name="totales[Agentes.id_agente][Base Imponible][field]" 
  	value="IF(Facturas.factura_abono,(Facturas.base_imponible*-1),Facturas.base_imponible)" />
  <input type="hidden" name="totales[Agentes.id_agente][Base Imponible][round]" value="2" />
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Base Imponible][Máximo]" value="max"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.base_imponible;max;%@ />
  </td><td>
  Valor Máximo 
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Base Imponible][Mínimo]" value="min"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.base_imponible;min;%@ />
  </td><td>
  Valor Mínimo
  </td><td class="check">
  <!-- input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Base Imponible][Media]" value="avg"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.base_imponible;avg;%@ / -->
  </td><td>
  <!-- Media -->
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Base Imponible][Nº]" value="count"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.base_imponible;count;%@ />
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Base Imponible][Sumatorio]" value="sum"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.base_imponible;sum;%@ />
  </td><td>
  Suma
  </td>

  <tr>
  <td class="etiqueta" >Total Impuestos
  <input type="hidden" name="totales[Agentes.id_agente][Total Impuestos][field]" 
  	value="IF(Facturas.factura_abono,(Facturas.base_imponible*-1),Facturas.total_impuestos)" />
  <input type="hidden" name="totales[Agentes.id_agente][Total Impuestos][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Total Impuestos][Máximo]" value="max"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.total_impuestos;max;%@>
  </td><td>
  Valor Máximo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Total Impuestos][Mínimo]" value="min"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.total_impuestos;min;%@>
  </td><td>
  Valor Mínimo
  </td><td class="check">
  <!-- input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Total Impuestos][Media]" value="avg"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.total_impuestos;avg;%@ -->
  </td><td>
  <!-- Media -->
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Total Impuestos][Nº]" value="count"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.total_impuestos;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Total Impuestos][Sumatorio]" value="sum"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.total_impuestos;sum;%@>
  </td><td>
  Suma
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Retenido
  <input type="hidden" name="totales[Agentes.id_agente][Retenido][field]" 
  	value="IF(Facturas.factura_abono,(Facturas.retenido*-1),Facturas.retenido)" />
  <input type="hidden" name="totales[Agentes.id_agente][Retenido][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Retenido][Máximo]" value="max"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.retenido;max;%@>
  </td><td>
  Valor Máximo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Retenido][Mínimo]" value="min"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.retenido;min;%@>
  </td><td>
  Valor Mínimo
  </td><td class="check">
  <!-- input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Retenido][Media]" value="avg"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.retenido;avg;%@ -->
  </td><td>
  <!-- Media -->
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Retenido][Nº]" value="count"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.retenido;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Retenido][Sumatorio]" value="sum"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.retenido;sum;%@>
  </td><td>
  Suma
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Total Bruto
  <input type="hidden" name="totales[Agentes.id_agente][Total Bruto][field]" 
  	value="IF(Facturas.factura_abono,(Facturas.total_bruto*-1),Facturas.total_bruto)" />
  <input type="hidden" name="totales[Agentes.id_agente][Total Bruto][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Total Bruto][Máximo]" value="max"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.total_bruto;max;%@>
  </td><td>
  Valor Máximo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Total Bruto][Mínimo]" value="min"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.total_bruto;min;%@>
  </td><td>
  Valor Mínimo
  </td><td class="check">
  <!-- input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Total Bruto][Media]" value="avg"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.total_bruto;avg;%@ -->
  </td><td>
  <!-- Media -->
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Total Bruto][Nº]" value="count"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.total_bruto;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Total Bruto][Sumatorio]" value="sum"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.total_bruto;sum;%@>
  </td><td>
  Suma
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Importe
  <input type="hidden" name="totales[Agentes.id_agente][Importe][field]" 
  	value="IF(Facturas.factura_abono,(Facturas.monto_total*-1),Facturas.monto_total)" />
  <input type="hidden" name="totales[Agentes.id_agente][Importe][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Importe][Máximo]" value="max"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.monto_total;max;%@>
  </td><td>
  Valor Máximo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Importe][Mínimo]" value="min"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.monto_total;min;%@>
  </td><td>
  Valor Mínimo
  </td><td class="check">
  <!-- input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Importe][Media]" value="avg"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.monto_total;avg;%@ -->
  </td><td>
  <!-- Media -->
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Importe][Nº]" value="count"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.monto_total;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Importe][Sumatorio]" value="sum"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.monto_total;sum;%@>
  </td><td>
  Suma
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Comisiones
  <input type="hidden" name="totales[Agentes.id_agente][Importe Comisión][field]" value="Agentes_facturas.monto">
  <input type="hidden" name="totales[Agentes.id_agente][Importe Comisión][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Importe Comisión][Máximo]" value="max"
  @%func:checkbox_mark;Agentes.id_agente;Agentes_facturas.monto;max;%@>
  </td><td>
  Valor Máximo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Importe Comisión][Mínimo]" value="min"
  @%func:checkbox_mark;Agentes.id_agente;Agentes_facturas.monto;min;%@>
  </td><td>
  Valor Mínimo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Importe Comisión][Media]" value="avg"
  @%func:checkbox_mark;Agentes.id_agente;Agentes_facturas.monto;avg;%@>
  </td><td>
  Media
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Importe Comisión][Nº]" value="count"
  @%func:checkbox_mark;Agentes.id_agente;Agentes_facturas.monto;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Importe Comisión][Sumatorio]" value="sum"
  @%func:checkbox_mark;Agentes.id_agente;Agentes_facturas.monto;sum;%@>
  </td><td>
  Suma
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Comisiones <sup>(por cliente)</sup>
  <input type="hidden" name="totales[Clientes.id_cliente][Importe Comisión por Cliente][field]" value="Agentes_facturas.monto">
  <input type="hidden" name="totales[Clientes.id_cliente][Importe Comisión por Cliente][round]" value="2">
  <input type="hidden" name="totales[Clientes.id_cliente][Importe Comisión por Cliente][erase_without]" value="ag_search">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Importe Comisión por Cliente][Máximo]" value="max"
  @%func:checkbox_mark;Clientes.id_cliente;Agentes_facturas.monto;max;%@>
  </td><td>
  Valor Máximo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Importe Comisión por Cliente][Mínimo]" value="min"
  @%func:checkbox_mark;Clientes.id_cliente;Agentes_facturas.monto;min;%@>
  </td><td>
  Valor Mínimo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Importe Comisión por Cliente][Media]" value="avg"
  @%func:checkbox_mark;Clientes.id_cliente;Agentes_facturas.monto;avg;%@>
  </td><td>
  Media
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Importe Comisión por Cliente][Nº]" value="count"
  @%func:checkbox_mark;Clientes.id_cliente;Agentes_facturas.monto;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Importe Comisión por Cliente][Sumatorio]" value="sum"
  @%func:checkbox_mark;Clientes.id_cliente;Agentes_facturas.monto;sum;%@>
  </td><td>
  Suma
  </td>
  </tr>

</table>

<br>
<table class="full" >
  <tr><td align="left" class="caption" colspan="11">Clientes</td></tr>

  <tr><td class="etiqueta">ID:</td>
  <td colspan="2"><input type="text" name="cl_id" size="20" class="insertext" value="@%get:st[cl_id];%@"></td>
  <td class="etiqueta" colspan="2">Nombre:</td>
  <td colspan="2"><input type="text" name="cl_nombre" size="30" class="insertext" value="@%get:st[cl_nombre];%@"></td>
  <td class="etiqueta" colspan="2">Tipo:</td>
  <td colspan="2"><!-- @%set:_selected_value=st[cl_tipo];%@ -->
  <select name="cl_tipo" class="insertext">
  <option value="">-- Ninguna seleccion --</option>
  @%where:tabla|Tipo_cliente;nolink|1;nombre|tiposcl;%@
  <option value="@%db:Tipo_cliente.id_tipo_cliente;%@"
  @%db:selected_value{Tipo_cliente.id_tipo_cliente}%@
  >@%db:Tipo_cliente.nombre;%@</option>
  @%end-where:%@

  </select>
  </td>
  </tr>

  <tr><td class="caption" colspan="12">Facturas</td></tr>

  <tr><td class="etiqueta">Ref.:</td>
  <td colspan="2"><input type="text" name="fr_ref" size="20" class="insertext" value="@%get:st[fr_ref];%@"></td>
  <td class="etiqueta" colspan="2">Ref. externa:</td>
  <td colspan="2"><input type="text" name="fr_ref_ext" size="30" class="insertext" value="@%get:st[fr_ref_ext];%@"></td>
  <td class="etiqueta" colspan="2">Serie:</td>
  <td colspan="2"><!-- @%set:_selected_value=st[fr_serie];%@ -->
  <select name="fr_serie" class="insertext">
  <option value="">-- Ninguna seleccion --</option>
  @%where:tabla|Series_facturacion;nolink|1;nombre|seriesfra;where|ventas=1;%@
  <option value="@%db:Series_facturacion.id_serie;%@"
  @%db:selected_value{Series_facturacion.id_serie}%@
  >@%db:Series_facturacion.nombre;%@ 
  (@%db:si_no_flag{Series_facturacion.contabilizable}%@)</option>
  @%end-where:%@

  </select>
  </tr>

  <tr><td class="etiqueta">Desde:</td>
  <td colspan="2"><input type=text name="fr_fecha_inicio" size="20" class="insertext" value="@%get:st[fr_fecha_inicio];%@"></td>
  <td class="etiqueta" colspan="2">Hasta:</td>
  <td colspan="2"><input type=text name="fr_fecha_fin" size="20" class="insertext" value="@%get:st[fr_fecha_fin];%@"></td>
  <td class="etiqueta" colspan="2">Base Imp. > :</td>
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
  <td class="caption" colspan="10">Efectos</td>
  </tr>

  <tr>
  <td class="check" >
  <input type="checkbox" name="ic_search" value="1"
  @%if:esta_vacio;st[ic_search];%@
  @%else:@
  checked="checked"
  @%end-if:%@
  ></td>
  <td class="caption" colspan="10">Incidencias</td>
  </tr>

  <tr><td class="titulotb" colspan="11">Totales</td></tr><tr>

  <td class="etiqueta" >Base Imponible
  <input type="hidden" name="totales[Clientes.id_cliente][Base Imponible][field]" 
  	value="IF(Facturas.factura_abono,(Facturas.base_imponible*-1),Facturas.base_imponible)" />
  <input type="hidden" name="totales[Clientes.id_cliente][Base Imponible][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Base Imponible][Máximo]" value="max"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.base_imponible;max;%@>
  </td><td>
  Valor Máximo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Base Imponible][Mínimo]" value="min"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.base_imponible;min;%@>
  </td><td>
  Valor Mínimo
  </td><td class="check">
  <!-- input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Base Imponible][Media]" value="avg"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.base_imponible;avg;%@ -->
  </td><td>
  <!-- Media -->
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Base Imponible][Nº]" value="count"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.base_imponible;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Base Imponible][Sumatorio]" value="sum"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.base_imponible;sum;%@>
  </td><td>
  Suma
  </td></tr>

  <tr>
  <td class="etiqueta" >Total Impuestos
  <input type="hidden" name="totales[Clientes.id_cliente][Total Impuestos][field]" 
  	value="IF(Facturas.factura_abono,(Facturas.total_impuestos*-1),Facturas.total_impuestos)" />
  <input type="hidden" name="totales[Clientes.id_cliente][Total Impuestos][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Total Impuestos][Máximo]" value="max"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.total_impuestos;max;%@>
  </td><td>
  Valor Máximo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Total Impuestos][Mínimo]" value="min"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.total_impuestos;min;%@>
  </td><td>
  Valor Mínimo
  </td><td class="check">
  <!-- input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Total Impuestos][Media]" value="avg"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.total_impuestos;avg;%@ -->
  </td><td>
  <!-- Media -->
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Total Impuestos][Nº]" value="count"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.total_impuestos;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Total Impuestos][Sumatorio]" value="sum"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.total_impuestos;sum;%@>
  </td><td>
  Suma
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Retenido
  <input type="hidden" name="totales[Clientes.id_cliente][Retenido][field]" 
  	value="IF(Facturas.factura_abono,(Facturas.retenido*-1),Facturas.retenido)" />
  <input type="hidden" name="totales[Clientes.id_cliente][Retenido][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Retenido][Máximo]" value="max"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.retenido;max;%@>
  </td><td>
  Valor Máximo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Retenido][Mínimo]" value="min"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.retenido;min;%@>
  </td><td>
  Valor Mínimo
  </td><td class="check">
  <!-- input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Retenido][Media]" value="avg"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.retenido;avg;%@ -->
  </td><td>
  <!-- Media -->
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Retenido][Nº]" value="count"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.retenido;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Retenido][Sumatorio]" value="sum"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.retenido;sum;%@>
  </td><td>
  Suma
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Total Bruto
  <input type="hidden" name="totales[Clientes.id_cliente][Total Bruto][field]" 
  	value="IF(Facturas.factura_abono,(Facturas.total_bruto*-1),Facturas.total_bruto)" />
  <input type="hidden" name="totales[Clientes.id_cliente][Total Bruto][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Total Bruto][Máximo]" value="max"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.total_bruto;max;%@>
  </td><td>
  Valor Máximo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Total Bruto][Mínimo]" value="min"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.total_bruto;min;%@>
  </td><td>
  Valor Mínimo
  </td><td class="check">
  <!-- input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Total Bruto][Media]" value="avg"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.total_bruto;avg;%@ -->
  </td><td>
  <!-- Media -->
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Total Bruto][Nº]" value="count"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.total_bruto;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Total Bruto][Sumatorio]" value="sum"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.total_bruto;sum;%@>
  </td><td>
  Suma
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Importe
  <input type="hidden" name="totales[Clientes.id_cliente][Importe][field]" 
  	value="IF(Facturas.factura_abono,(Facturas.monto_total*-1),Facturas.monto_total)" />
  <input type="hidden" name="totales[Clientes.id_cliente][Importe][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Importe][Máximo]" value="max"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.monto_total;max;%@>
  </td><td>
  Valor Máximo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Importe][Mínimo]" value="min"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.monto_total;min;%@>
  </td><td>
  Valor Mínimo
  </td><td class="check">
  <!-- input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Importe][Media]" value="avg"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.monto_total;avg;%@ -->
  </td><td>
  <!-- Media -->
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Importe][Nº]" value="count"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.monto_total;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Importe][Sumatorio]" value="sum"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.monto_total;sum;%@>
  </td><td>
  Suma
  </td>
  </tr>

</table>
<br>

<br>
  </form>

