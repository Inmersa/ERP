
<form method=post action="?seccion=informe_ventas_detallado">
<input type="hidden" name="nom_bus" value="informe_ventas_detallado">
<table class="full">
  <tr> 
  <td class="caption" align="left">Informe Detallat de Facturaci� en Vendes</td>
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
  <td align="left" class="caption" colspan="10">Agents</td>
  </tr>

  <tr><td class="etiqueta">ID:</td>
  <td colspan="2"><input type="text" name="ag_id" size="20" class="insertext" value="@%get:st[ag_id];%@"></td>
  <td class="etiqueta" colspan="2">Nom:</td>
  <td colspan="2"><input type="text" name="ag_nombre" size="30" class="insertext" value="@%get:st[ag_nombre];%@"></td>
  <td class="etiqueta" colspan="2">Tipus:</td>
  <td colspan="2"><!-- @%set:_selected_value=st[ag_tipo];%@ -->
  <select name="ag_tipo" class="insertext">
  <option value="">Cap selecci�</option>
  @%where:tabla|Tipo_agente;nolink|1;nombre|tipos;%@
  <option value="@%db:Tipo_agente.id_tipo_agente;%@"
  @%db:selected_value{Tipo_agente.id_tipo_agente}%@
  >@%db:Tipo_agente.nombre;%@</option>
  @%end-where:%@

  </select>
  </tr>
  <tr><td class="titulotb" colspan="11">Totals</td></tr>

  <tr>
  <td class="etiqueta" >Base imposable
  <input type="hidden" name="totales[Agentes.id_agente][Base imposable][field]" 
  	value="IF(Facturas.factura_abono,(Facturas.base_imponible*-1),Facturas.base_imponible)" />
  <input type="hidden" name="totales[Agentes.id_agente][Base imposable][round]" value="2" />
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Base imposable][M�xim]" value="max"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.base_imponible;max;%@ />
  </td><td>
  Valor M�xim 
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Base imposable][M�nim]" value="min"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.base_imponible;min;%@ />
  </td><td>
  Valor M�nim
  </td><td class="check">
  <!-- input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Base imposable][Mig]" value="avg"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.base_imponible;avg;%@ / -->
  </td><td>
  <!-- Terme Mitj� -->
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Base imposable][N�]" value="count"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.base_imponible;count;%@ />
  </td><td>
  N�
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Base imposable][Sumatori]" value="sum"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.base_imponible;sum;%@ />
  </td><td>
  Sumatori
  </td>

  <tr>
  <td class="etiqueta" >Totals Imposts
  <input type="hidden" name="totales[Agentes.id_agente][Totals Imposts][field]" 
  	value="IF(Facturas.factura_abono,(Facturas.base_imponible*-1),Facturas.total_impuestos)" />
  <input type="hidden" name="totales[Agentes.id_agente][Totals Imposts][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Totals Imposts][M�xim]" value="max"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.total_impuestos;max;%@>
  </td><td>
  Valor M�xim
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Totals Imposts][M�nim]" value="min"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.total_impuestos;min;%@>
  </td><td>
  Valor M�nim
  </td><td class="check">
  <!-- input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Totals Imposts][Mig]" value="avg"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.total_impuestos;avg;%@ -->
  </td><td>
  <!-- Terme Mitj� -->
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Totals Imposts][N�]" value="count"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.total_impuestos;count;%@>
  </td><td>
  N�
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Totals Imposts][Sumatori]" value="sum"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.total_impuestos;sum;%@>
  </td><td>
  Sumatori
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Retingut
  <input type="hidden" name="totales[Agentes.id_agente][Retingut][field]" 
  	value="IF(Facturas.factura_abono,(Facturas.retenido*-1),Facturas.retenido)" />
  <input type="hidden" name="totales[Agentes.id_agente][Retingut][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Retingut][M�xim]" value="max"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.retenido;max;%@>
  </td><td>
  Valor M�xim
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Retingut][M�nim]" value="min"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.retenido;min;%@>
  </td><td>
  Valor M�nim
  </td><td class="check">
  <!-- input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Retingut][Mig]" value="avg"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.retenido;avg;%@ -->
  </td><td>
  <!-- Terme Mitj� -->
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Retingut][N�]" value="count"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.retenido;count;%@>
  </td><td>
  N�
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Retingut][Sumatori]" value="sum"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.retenido;sum;%@>
  </td><td>
  Sumatori
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Import gros
  <input type="hidden" name="totales[Agentes.id_agente][Import gros][field]" 
  	value="IF(Facturas.factura_abono,(Facturas.total_bruto*-1),Facturas.total_bruto)" />
  <input type="hidden" name="totales[Agentes.id_agente][Import gros][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Import gros][M�xim]" value="max"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.total_bruto;max;%@>
  </td><td>
  Valor M�xim
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Import gros][M�nim]" value="min"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.total_bruto;min;%@>
  </td><td>
  Valor M�nim
  </td><td class="check">
  <!-- input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Import gros][Mig]" value="avg"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.total_bruto;avg;%@ -->
  </td><td>
  <!-- Terme Mitj� -->
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Import gros][N�]" value="count"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.total_bruto;count;%@>
  </td><td>
  N�
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Import gros][Sumatori]" value="sum"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.total_bruto;sum;%@>
  </td><td>
  Sumatori
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Quantia
  <input type="hidden" name="totales[Agentes.id_agente][Quantia][field]" 
  	value="IF(Facturas.factura_abono,(Facturas.monto_total*-1),Facturas.monto_total)" />
  <input type="hidden" name="totales[Agentes.id_agente][Quantia][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Quantia][M�xim]" value="max"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.monto_total;max;%@>
  </td><td>
  Valor M�xim
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Quantia][M�nim]" value="min"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.monto_total;min;%@>
  </td><td>
  Valor M�nim
  </td><td class="check">
  <!-- input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Quantia][Mig]" value="avg"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.monto_total;avg;%@ -->
  </td><td>
  <!-- Terme Mitj� -->
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Quantia][N�]" value="count"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.monto_total;count;%@>
  </td><td>
  N�
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Quantia][Sumatori]" value="sum"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.monto_total;sum;%@>
  </td><td>
  Sumatori
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Comissions
  <input type="hidden" name="totales[Agentes.id_agente][Import Comissi�][field]" value="Agentes_facturas.monto">
  <input type="hidden" name="totales[Agentes.id_agente][Import Comissi�][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Import Comissi�][M�xim]" value="max"
  @%func:checkbox_mark;Agentes.id_agente;Agentes_facturas.monto;max;%@>
  </td><td>
  Valor M�xim
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Import Comissi�][M�nim]" value="min"
  @%func:checkbox_mark;Agentes.id_agente;Agentes_facturas.monto;min;%@>
  </td><td>
  Valor M�nim
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Import Comissi�][Mig]" value="avg"
  @%func:checkbox_mark;Agentes.id_agente;Agentes_facturas.monto;avg;%@>
  </td><td>
  Terme Mitj�
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Import Comissi�][N�]" value="count"
  @%func:checkbox_mark;Agentes.id_agente;Agentes_facturas.monto;count;%@>
  </td><td>
  N�
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Import Comissi�][Sumatori]" value="sum"
  @%func:checkbox_mark;Agentes.id_agente;Agentes_facturas.monto;sum;%@>
  </td><td>
  Sumatori
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Commissions <sup>(per client)</sup>
  <input type="hidden" name="totales[Clientes.id_cliente][Import Comissi� per client][field]" value="Agentes_facturas.monto">
  <input type="hidden" name="totales[Clientes.id_cliente][Import Comissi� per client][round]" value="2">
  <input type="hidden" name="totales[Clientes.id_cliente][Import Comissi� per client][erase_without]" value="ag_search">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Import Comissi� per client][M�xim]" value="max"
  @%func:checkbox_mark;Clientes.id_cliente;Agentes_facturas.monto;max;%@>
  </td><td>
  Valor M�xim
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Import Comissi� per client][M�nim]" value="min"
  @%func:checkbox_mark;Clientes.id_cliente;Agentes_facturas.monto;min;%@>
  </td><td>
  Valor M�nim
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Import Comissi� per client][Mig]" value="avg"
  @%func:checkbox_mark;Clientes.id_cliente;Agentes_facturas.monto;avg;%@>
  </td><td>
  Terme Mitj�
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Import Comissi� per client][N�]" value="count"
  @%func:checkbox_mark;Clientes.id_cliente;Agentes_facturas.monto;count;%@>
  </td><td>
  N�
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Import Comissi� per client][Sumatori]" value="sum"
  @%func:checkbox_mark;Clientes.id_cliente;Agentes_facturas.monto;sum;%@>
  </td><td>
  Sumatori
  </td>
  </tr>

</table>

<br>
<table class="full" >
  <tr><td align="left" class="caption" colspan="11">Clients</td></tr>

  <tr><td class="etiqueta">ID:</td>
  <td colspan="2"><input type="text" name="cl_id" size="20" class="insertext" value="@%get:st[cl_id];%@"></td>
  <td class="etiqueta" colspan="2">Nom:</td>
  <td colspan="2"><input type="text" name="cl_nombre" size="30" class="insertext" value="@%get:st[cl_nombre];%@"></td>
  <td class="etiqueta" colspan="2">Tipus:</td>
  <td colspan="2"><!-- @%set:_selected_value=st[cl_tipo];%@ -->
  <select name="cl_tipo" class="insertext">
  <option value="">Cap selecci�</option>
  @%where:tabla|Tipo_cliente;nolink|1;nombre|tiposcl;%@
  <option value="@%db:Tipo_cliente.id_tipo_cliente;%@"
  @%db:selected_value{Tipo_cliente.id_tipo_cliente}%@
  >@%db:Tipo_cliente.nombre;%@</option>
  @%end-where:%@

  </select>
  </td>
  </tr>

  <tr><td class="caption" colspan="12">Factures</td></tr>

  <tr><td class="etiqueta">Ref.:</td>
  <td colspan="2"><input type="text" name="fr_ref" size="20" class="insertext" value="@%get:st[fr_ref];%@"></td>
  <td class="etiqueta" colspan="2">Ref. Ext:</td>
  <td colspan="2"><input type="text" name="fr_ref_ext" size="30" class="insertext" value="@%get:st[fr_ref_ext];%@"></td>
  <td class="etiqueta" colspan="2">Seri�:</td>
  <td colspan="2"><!-- @%set:_selected_value=st[fr_serie];%@ -->
  <select name="fr_serie" class="insertext">
  <option value="">Cap selecci�</option>
  @%where:tabla|Series_facturacion;nolink|1;nombre|seriesfra;where|ventas=1;%@
  <option value="@%db:Series_facturacion.id_serie;%@"
  @%db:selected_value{Series_facturacion.id_serie}%@
  >@%db:Series_facturacion.nombre;%@ 
  (@%db:si_no_flag{Series_facturacion.contabilizable}%@)</option>
  @%end-where:%@

  </select>
  </tr>

  <tr><td class="etiqueta">Des de:</td>
  <td colspan="2"><input type=text name="fr_fecha_inicio" size="20" class="insertext" value="@%get:st[fr_fecha_inicio];%@"></td>
  <td class="etiqueta" colspan="2">Fins:</td>
  <td colspan="2"><input type=text name="fr_fecha_fin" size="20" class="insertext" value="@%get:st[fr_fecha_fin];%@"></td>
  <td class="etiqueta" colspan="2">Base imposable > :</td>
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
  <td class="caption" colspan="10">Efectes</td>
  </tr>

  <tr>
  <td class="check" >
  <input type="checkbox" name="ic_search" value="1"
  @%if:esta_vacio;st[ic_search];%@
  @%else:@
  checked="checked"
  @%end-if:%@
  ></td>
  <td class="caption" colspan="10">Incid�ncies</td>
  </tr>

  <tr><td class="titulotb" colspan="11">Totals</td></tr><tr>

  <td class="etiqueta" >Base imposable
  <input type="hidden" name="totales[Clientes.id_cliente][Base imposable][field]" 
  	value="IF(Facturas.factura_abono,(Facturas.base_imponible*-1),Facturas.base_imponible)" />
  <input type="hidden" name="totales[Clientes.id_cliente][Base imposable][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Base imposable][M�xim]" value="max"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.base_imponible;max;%@>
  </td><td>
  Valor M�xim
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Base imposable][M�nim]" value="min"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.base_imponible;min;%@>
  </td><td>
  Valor M�nim
  </td><td class="check">
  <!-- input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Base imposable][Mig]" value="avg"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.base_imponible;avg;%@ -->
  </td><td>
  <!-- Terme Mitj� -->
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Base imposable][N�]" value="count"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.base_imponible;count;%@>
  </td><td>
  N�
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Base imposable][Sumatori]" value="sum"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.base_imponible;sum;%@>
  </td><td>
  Sumatori
  </td></tr>

  <tr>
  <td class="etiqueta" >Totals Imposts
  <input type="hidden" name="totales[Clientes.id_cliente][Totals Imposts][field]" 
  	value="IF(Facturas.factura_abono,(Facturas.total_impuestos*-1),Facturas.total_impuestos)" />
  <input type="hidden" name="totales[Clientes.id_cliente][Totals Imposts][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Totals Imposts][M�xim]" value="max"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.total_impuestos;max;%@>
  </td><td>
  Valor M�xim
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Totals Imposts][M�nim]" value="min"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.total_impuestos;min;%@>
  </td><td>
  Valor M�nim
  </td><td class="check">
  <!-- input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Totals Imposts][Mig]" value="avg"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.total_impuestos;avg;%@ -->
  </td><td>
  <!-- Terme Mitj� -->
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Totals Imposts][N�]" value="count"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.total_impuestos;count;%@>
  </td><td>
  N�
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Totals Imposts][Sumatori]" value="sum"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.total_impuestos;sum;%@>
  </td><td>
  Sumatori
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Retingut
  <input type="hidden" name="totales[Clientes.id_cliente][Retingut][field]" 
  	value="IF(Facturas.factura_abono,(Facturas.retenido*-1),Facturas.retenido)" />
  <input type="hidden" name="totales[Clientes.id_cliente][Retingut][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Retingut][M�xim]" value="max"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.retenido;max;%@>
  </td><td>
  Valor M�xim
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Retingut][M�nim]" value="min"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.retenido;min;%@>
  </td><td>
  Valor M�nim
  </td><td class="check">
  <!-- input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Retingut][Mig]" value="avg"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.retenido;avg;%@ -->
  </td><td>
  <!-- Terme Mitj� -->
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Retingut][N�]" value="count"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.retenido;count;%@>
  </td><td>
  N�
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Retingut][Sumatori]" value="sum"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.retenido;sum;%@>
  </td><td>
  Sumatori
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Import gros
  <input type="hidden" name="totales[Clientes.id_cliente][Import gros][field]" 
  	value="IF(Facturas.factura_abono,(Facturas.total_bruto*-1),Facturas.total_bruto)" />
  <input type="hidden" name="totales[Clientes.id_cliente][Import gros][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Import gros][M�xim]" value="max"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.total_bruto;max;%@>
  </td><td>
  Valor M�xim
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Import gros][M�nim]" value="min"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.total_bruto;min;%@>
  </td><td>
  Valor M�nim
  </td><td class="check">
  <!-- input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Import gros][Mig]" value="avg"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.total_bruto;avg;%@ -->
  </td><td>
  <!-- Terme Mitj� -->
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Import gros][N�]" value="count"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.total_bruto;count;%@>
  </td><td>
  N�
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Import gros][Sumatori]" value="sum"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.total_bruto;sum;%@>
  </td><td>
  Sumatori
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Quantia
  <input type="hidden" name="totales[Clientes.id_cliente][Quantia][field]" 
  	value="IF(Facturas.factura_abono,(Facturas.monto_total*-1),Facturas.monto_total)" />
  <input type="hidden" name="totales[Clientes.id_cliente][Quantia][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Quantia][M�xim]" value="max"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.monto_total;max;%@>
  </td><td>
  Valor M�xim
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Quantia][M�nim]" value="min"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.monto_total;min;%@>
  </td><td>
  Valor M�nim
  </td><td class="check">
  <!-- input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Quantia][Mig]" value="avg"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.monto_total;avg;%@ -->
  </td><td>
  <!-- Terme Mitj� -->
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Quantia][N�]" value="count"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.monto_total;count;%@>
  </td><td>
  N�
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Quantia][Sumatori]" value="sum"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.monto_total;sum;%@>
  </td><td>
  Sumatori
  </td>
  </tr>

</table>
<br>

<br>
  </form>

