
<form method=post action="?seccion=informe_ventas_detallado">
<input type="hidden" name="nom_bus" value="informe_ventas_detallado">
<table class="full">
  <tr> 
  <td class="caption" align="left">Relat�rio Detalhado de Factura��o em vendas</td>
  <td class="caption" align="right">
        <input type="submit" name="Buscar" value="Pesquisar" class="insertext" accesskey="p" >
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
  <td class="etiqueta" colspan="2">Nome:</td>
  <td colspan="2"><input type="text" name="ag_nombre" size="30" class="insertext" value="@%get:st[ag_nombre];%@"></td>
  <td class="etiqueta" colspan="2">Tipo:</td>
  <td colspan="2"><!-- @%set:_selected_value=st[ag_tipo];%@ -->
  <select name="ag_tipo" class="insertext">
  <option value="">N�o Existem Itens Seleccionados</option>
  @%where:tabla|Tipo_agente;nolink|1;nombre|tipos;%@
  <option value="@%db:Tipo_agente.id_tipo_agente;%@"
  @%db:selected_value{Tipo_agente.id_tipo_agente}%@
  >@%db:Tipo_agente.nombre;%@</option>
  @%end-where:%@

  </select>
  </tr>
  <tr><td class="titulotb" colspan="11">Totais</td></tr>

  <tr>
  <td class="etiqueta" >Total do Valor Tributado
  <input type="hidden" name="totales[Agentes.id_agente][Total do Valor Tributado][field]" 
  	value="IF(Facturas.factura_abono,(Facturas.base_imponible*-1),Facturas.base_imponible)" />
  <input type="hidden" name="totales[Agentes.id_agente][Total do Valor Tributado][round]" value="2" />
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Total do Valor Tributado][M�ximo]" value="max"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.base_imponible;max;%@ />
  </td><td>
  Valor M�ximo 
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Total do Valor Tributado][M�nimo]" value="min"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.base_imponible;min;%@ />
  </td><td>
  Valor M�nimo
  </td><td class="check">
  <!-- input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Total do Valor Tributado][M�dia]" value="avg"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.base_imponible;avg;%@ / -->
  </td><td>
  <!-- M�dia -->
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Total do Valor Tributado][N�]" value="count"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.base_imponible;count;%@ />
  </td><td>
  N�
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Total do Valor Tributado][Soma]" value="sum"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.base_imponible;sum;%@ />
  </td><td>
  Soma
  </td>

  <tr>
  <td class="etiqueta" >Totais Impostos
  <input type="hidden" name="totales[Agentes.id_agente][Totais Impostos][field]" 
  	value="IF(Facturas.factura_abono,(Facturas.base_imponible*-1),Facturas.total_impuestos)" />
  <input type="hidden" name="totales[Agentes.id_agente][Totais Impostos][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Totais Impostos][M�ximo]" value="max"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.total_impuestos;max;%@>
  </td><td>
  Valor M�ximo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Totais Impostos][M�nimo]" value="min"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.total_impuestos;min;%@>
  </td><td>
  Valor M�nimo
  </td><td class="check">
  <!-- input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Totais Impostos][M�dia]" value="avg"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.total_impuestos;avg;%@ -->
  </td><td>
  <!-- M�dia -->
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Totais Impostos][N�]" value="count"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.total_impuestos;count;%@>
  </td><td>
  N�
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Totais Impostos][Soma]" value="sum"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.total_impuestos;sum;%@>
  </td><td>
  Soma
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Retido
  <input type="hidden" name="totales[Agentes.id_agente][Retido][field]" 
  	value="IF(Facturas.factura_abono,(Facturas.retenido*-1),Facturas.retenido)" />
  <input type="hidden" name="totales[Agentes.id_agente][Retido][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Retido][M�ximo]" value="max"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.retenido;max;%@>
  </td><td>
  Valor M�ximo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Retido][M�nimo]" value="min"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.retenido;min;%@>
  </td><td>
  Valor M�nimo
  </td><td class="check">
  <!-- input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Retido][M�dia]" value="avg"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.retenido;avg;%@ -->
  </td><td>
  <!-- M�dia -->
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Retido][N�]" value="count"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.retenido;count;%@>
  </td><td>
  N�
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Retido][Soma]" value="sum"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.retenido;sum;%@>
  </td><td>
  Soma
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Total Bruto
  <input type="hidden" name="totales[Agentes.id_agente][Total Bruto][field]" 
  	value="IF(Facturas.factura_abono,(Facturas.total_bruto*-1),Facturas.total_bruto)" />
  <input type="hidden" name="totales[Agentes.id_agente][Total Bruto][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Total Bruto][M�ximo]" value="max"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.total_bruto;max;%@>
  </td><td>
  Valor M�ximo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Total Bruto][M�nimo]" value="min"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.total_bruto;min;%@>
  </td><td>
  Valor M�nimo
  </td><td class="check">
  <!-- input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Total Bruto][M�dia]" value="avg"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.total_bruto;avg;%@ -->
  </td><td>
  <!-- M�dia -->
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Total Bruto][N�]" value="count"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.total_bruto;count;%@>
  </td><td>
  N�
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Total Bruto][Soma]" value="sum"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.total_bruto;sum;%@>
  </td><td>
  Soma
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Montante
  <input type="hidden" name="totales[Agentes.id_agente][Montante][field]" 
  	value="IF(Facturas.factura_abono,(Facturas.monto_total*-1),Facturas.monto_total)" />
  <input type="hidden" name="totales[Agentes.id_agente][Montante][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Montante][M�ximo]" value="max"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.monto_total;max;%@>
  </td><td>
  Valor M�ximo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Montante][M�nimo]" value="min"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.monto_total;min;%@>
  </td><td>
  Valor M�nimo
  </td><td class="check">
  <!-- input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Montante][M�dia]" value="avg"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.monto_total;avg;%@ -->
  </td><td>
  <!-- M�dia -->
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Montante][N�]" value="count"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.monto_total;count;%@>
  </td><td>
  N�
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Montante][Soma]" value="sum"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.monto_total;sum;%@>
  </td><td>
  Soma
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Comiss�es
  <input type="hidden" name="totales[Agentes.id_agente][Montante Comiss�o][field]" value="Agentes_facturas.monto">
  <input type="hidden" name="totales[Agentes.id_agente][Montante Comiss�o][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Montante Comiss�o][M�ximo]" value="max"
  @%func:checkbox_mark;Agentes.id_agente;Agentes_facturas.monto;max;%@>
  </td><td>
  Valor M�ximo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Montante Comiss�o][M�nimo]" value="min"
  @%func:checkbox_mark;Agentes.id_agente;Agentes_facturas.monto;min;%@>
  </td><td>
  Valor M�nimo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Montante Comiss�o][M�dia]" value="avg"
  @%func:checkbox_mark;Agentes.id_agente;Agentes_facturas.monto;avg;%@>
  </td><td>
  M�dia
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Montante Comiss�o][N�]" value="count"
  @%func:checkbox_mark;Agentes.id_agente;Agentes_facturas.monto;count;%@>
  </td><td>
  N�
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Montante Comiss�o][Soma]" value="sum"
  @%func:checkbox_mark;Agentes.id_agente;Agentes_facturas.monto;sum;%@>
  </td><td>
  Soma
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Comiss�es <sup>(por cliente)</sup>
  <input type="hidden" name="totales[Clientes.id_cliente][Montante Comiss�o por cliente][field]" value="Agentes_facturas.monto">
  <input type="hidden" name="totales[Clientes.id_cliente][Montante Comiss�o por cliente][round]" value="2">
  <input type="hidden" name="totales[Clientes.id_cliente][Montante Comiss�o por cliente][erase_without]" value="ag_search">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Montante Comiss�o por cliente][M�ximo]" value="max"
  @%func:checkbox_mark;Clientes.id_cliente;Agentes_facturas.monto;max;%@>
  </td><td>
  Valor M�ximo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Montante Comiss�o por cliente][M�nimo]" value="min"
  @%func:checkbox_mark;Clientes.id_cliente;Agentes_facturas.monto;min;%@>
  </td><td>
  Valor M�nimo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Montante Comiss�o por cliente][M�dia]" value="avg"
  @%func:checkbox_mark;Clientes.id_cliente;Agentes_facturas.monto;avg;%@>
  </td><td>
  M�dia
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Montante Comiss�o por cliente][N�]" value="count"
  @%func:checkbox_mark;Clientes.id_cliente;Agentes_facturas.monto;count;%@>
  </td><td>
  N�
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Montante Comiss�o por cliente][Soma]" value="sum"
  @%func:checkbox_mark;Clientes.id_cliente;Agentes_facturas.monto;sum;%@>
  </td><td>
  Soma
  </td>
  </tr>

</table>

<br>
<table class="full" >
  <tr><td align="left" class="caption" colspan="11">Clientes</td></tr>

  <tr><td class="etiqueta">ID:</td>
  <td colspan="2"><input type="text" name="cl_id" size="20" class="insertext" value="@%get:st[cl_id];%@"></td>
  <td class="etiqueta" colspan="2">Nome:</td>
  <td colspan="2"><input type="text" name="cl_nombre" size="30" class="insertext" value="@%get:st[cl_nombre];%@"></td>
  <td class="etiqueta" colspan="2">Tipo:</td>
  <td colspan="2"><!-- @%set:_selected_value=st[cl_tipo];%@ -->
  <select name="cl_tipo" class="insertext">
  <option value="">N�o Existem Itens Seleccionados</option>
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
  <td class="etiqueta" colspan="2">Ref. Externa:</td>
  <td colspan="2"><input type="text" name="fr_ref_ext" size="30" class="insertext" value="@%get:st[fr_ref_ext];%@"></td>
  <td class="etiqueta" colspan="2">S�rie de Factura��o:</td>
  <td colspan="2"><!-- @%set:_selected_value=st[fr_serie];%@ -->
  <select name="fr_serie" class="insertext">
  <option value="">N�o Existem Itens Seleccionados</option>
  @%where:tabla|Series_facturacion;nolink|1;nombre|seriesfra;where|ventas=1;%@
  <option value="@%db:Series_facturacion.id_serie;%@"
  @%db:selected_value{Series_facturacion.id_serie}%@
  >@%db:Series_facturacion.nombre;%@ 
  (@%db:si_no_flag{Series_facturacion.contabilizable}%@)</option>
  @%end-where:%@

  </select>
  </tr>

  <tr><td class="etiqueta">De:</td>
  <td colspan="2"><input type=text name="fr_fecha_inicio" size="20" class="insertext" value="@%get:st[fr_fecha_inicio];%@"></td>
  <td class="etiqueta" colspan="2">A:</td>
  <td colspan="2"><input type=text name="fr_fecha_fin" size="20" class="insertext" value="@%get:st[fr_fecha_fin];%@"></td>
  <td class="etiqueta" colspan="2">Valor Tribut�vel > :</td>
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
  <td class="caption" colspan="10">Ordens de Pagamento</td>
  </tr>

  <tr>
  <td class="check" >
  <input type="checkbox" name="ic_search" value="1"
  @%if:esta_vacio;st[ic_search];%@
  @%else:@
  checked="checked"
  @%end-if:%@
  ></td>
  <td class="caption" colspan="10">Incid�ncia</td>
  </tr>

  <tr><td class="titulotb" colspan="11">Totais</td></tr><tr>

  <td class="etiqueta" >Total do Valor Tributado
  <input type="hidden" name="totales[Clientes.id_cliente][Total do Valor Tributado][field]" 
  	value="IF(Facturas.factura_abono,(Facturas.base_imponible*-1),Facturas.base_imponible)" />
  <input type="hidden" name="totales[Clientes.id_cliente][Total do Valor Tributado][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Total do Valor Tributado][M�ximo]" value="max"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.base_imponible;max;%@>
  </td><td>
  Valor M�ximo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Total do Valor Tributado][M�nimo]" value="min"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.base_imponible;min;%@>
  </td><td>
  Valor M�nimo
  </td><td class="check">
  <!-- input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Total do Valor Tributado][M�dia]" value="avg"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.base_imponible;avg;%@ -->
  </td><td>
  <!-- M�dia -->
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Total do Valor Tributado][N�]" value="count"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.base_imponible;count;%@>
  </td><td>
  N�
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Total do Valor Tributado][Soma]" value="sum"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.base_imponible;sum;%@>
  </td><td>
  Soma
  </td></tr>

  <tr>
  <td class="etiqueta" >Totais Impostos
  <input type="hidden" name="totales[Clientes.id_cliente][Totais Impostos][field]" 
  	value="IF(Facturas.factura_abono,(Facturas.total_impuestos*-1),Facturas.total_impuestos)" />
  <input type="hidden" name="totales[Clientes.id_cliente][Totais Impostos][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Totais Impostos][M�ximo]" value="max"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.total_impuestos;max;%@>
  </td><td>
  Valor M�ximo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Totais Impostos][M�nimo]" value="min"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.total_impuestos;min;%@>
  </td><td>
  Valor M�nimo
  </td><td class="check">
  <!-- input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Totais Impostos][M�dia]" value="avg"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.total_impuestos;avg;%@ -->
  </td><td>
  <!-- M�dia -->
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Totais Impostos][N�]" value="count"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.total_impuestos;count;%@>
  </td><td>
  N�
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Totais Impostos][Soma]" value="sum"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.total_impuestos;sum;%@>
  </td><td>
  Soma
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Retido
  <input type="hidden" name="totales[Clientes.id_cliente][Retido][field]" 
  	value="IF(Facturas.factura_abono,(Facturas.retenido*-1),Facturas.retenido)" />
  <input type="hidden" name="totales[Clientes.id_cliente][Retido][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Retido][M�ximo]" value="max"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.retenido;max;%@>
  </td><td>
  Valor M�ximo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Retido][M�nimo]" value="min"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.retenido;min;%@>
  </td><td>
  Valor M�nimo
  </td><td class="check">
  <!-- input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Retido][M�dia]" value="avg"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.retenido;avg;%@ -->
  </td><td>
  <!-- M�dia -->
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Retido][N�]" value="count"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.retenido;count;%@>
  </td><td>
  N�
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Retido][Soma]" value="sum"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.retenido;sum;%@>
  </td><td>
  Soma
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Total Bruto
  <input type="hidden" name="totales[Clientes.id_cliente][Total Bruto][field]" 
  	value="IF(Facturas.factura_abono,(Facturas.total_bruto*-1),Facturas.total_bruto)" />
  <input type="hidden" name="totales[Clientes.id_cliente][Total Bruto][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Total Bruto][M�ximo]" value="max"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.total_bruto;max;%@>
  </td><td>
  Valor M�ximo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Total Bruto][M�nimo]" value="min"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.total_bruto;min;%@>
  </td><td>
  Valor M�nimo
  </td><td class="check">
  <!-- input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Total Bruto][M�dia]" value="avg"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.total_bruto;avg;%@ -->
  </td><td>
  <!-- M�dia -->
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Total Bruto][N�]" value="count"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.total_bruto;count;%@>
  </td><td>
  N�
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Total Bruto][Soma]" value="sum"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.total_bruto;sum;%@>
  </td><td>
  Soma
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Montante
  <input type="hidden" name="totales[Clientes.id_cliente][Montante][field]" 
  	value="IF(Facturas.factura_abono,(Facturas.monto_total*-1),Facturas.monto_total)" />
  <input type="hidden" name="totales[Clientes.id_cliente][Montante][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Montante][M�ximo]" value="max"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.monto_total;max;%@>
  </td><td>
  Valor M�ximo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Montante][M�nimo]" value="min"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.monto_total;min;%@>
  </td><td>
  Valor M�nimo
  </td><td class="check">
  <!-- input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Montante][M�dia]" value="avg"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.monto_total;avg;%@ -->
  </td><td>
  <!-- M�dia -->
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Montante][N�]" value="count"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.monto_total;count;%@>
  </td><td>
  N�
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Montante][Soma]" value="sum"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.monto_total;sum;%@>
  </td><td>
  Soma
  </td>
  </tr>

</table>
<br>

<br>
  </form>

