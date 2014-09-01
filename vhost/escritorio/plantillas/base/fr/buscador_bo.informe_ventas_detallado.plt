
<form method=post action="?seccion=informe_ventas_detallado">
<input type="hidden" name="nom_bus" value="informe_ventas_detallado">
<table class="full">
  <tr> 
  <td class="caption" align="left">Rapport Détaillé de Facturation dans des ventes</td>
  <td class="caption" align="right">
        <input type="submit" name="Buscar" value="Chercher" class="insertext" accesskey="r" >
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
  <td class="etiqueta" colspan="2">Type:</td>
  <td colspan="2"><!-- @%set:_selected_value=st[ag_tipo];%@ -->
  <select name="ag_tipo" class="insertext">
  <option value="">Aucune sélection</option>
  @%where:tabla|Tipo_agente;nolink|1;nombre|tipos;%@
  <option value="@%db:Tipo_agente.id_tipo_agente;%@"
  @%db:selected_value{Tipo_agente.id_tipo_agente}%@
  >@%db:Tipo_agente.nombre;%@</option>
  @%end-where:%@

  </select>
  </tr>
  <tr><td class="titulotb" colspan="11">Totals</td></tr>

  <tr>
  <td class="etiqueta" >Revenu imposable
  <input type="hidden" name="totales[Agentes.id_agente][Revenu imposable][field]" 
  	value="IF(Facturas.factura_abono,(Facturas.base_imponible*-1),Facturas.base_imponible)" />
  <input type="hidden" name="totales[Agentes.id_agente][Revenu imposable][round]" value="2" />
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Revenu imposable][Maximum]" value="max"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.base_imponible;max;%@ />
  </td><td>
  Valeur Maximale 
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Revenu imposable][Minimum]" value="min"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.base_imponible;min;%@ />
  </td><td>
  Valeur Minimale
  </td><td class="check">
  <!-- input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Revenu imposable][Moyenne]" value="avg"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.base_imponible;avg;%@ / -->
  </td><td>
  <!-- Moyenne -->
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Revenu imposable][Nº]" value="count"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.base_imponible;count;%@ />
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Revenu imposable][Sommation]" value="sum"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.base_imponible;sum;%@ />
  </td><td>
  Sommation
  </td>

  <tr>
  <td class="etiqueta" >Totals Impôt
  <input type="hidden" name="totales[Agentes.id_agente][Totals Impôt][field]" 
  	value="IF(Facturas.factura_abono,(Facturas.base_imponible*-1),Facturas.total_impuestos)" />
  <input type="hidden" name="totales[Agentes.id_agente][Totals Impôt][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Totals Impôt][Maximum]" value="max"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.total_impuestos;max;%@>
  </td><td>
  Valeur Maximale
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Totals Impôt][Minimum]" value="min"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.total_impuestos;min;%@>
  </td><td>
  Valeur Minimale
  </td><td class="check">
  <!-- input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Totals Impôt][Moyenne]" value="avg"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.total_impuestos;avg;%@ -->
  </td><td>
  <!-- Moyenne -->
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Totals Impôt][Nº]" value="count"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.total_impuestos;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Totals Impôt][Sommation]" value="sum"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.total_impuestos;sum;%@>
  </td><td>
  Sommation
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Maintenu
  <input type="hidden" name="totales[Agentes.id_agente][Maintenu][field]" 
  	value="IF(Facturas.factura_abono,(Facturas.retenido*-1),Facturas.retenido)" />
  <input type="hidden" name="totales[Agentes.id_agente][Maintenu][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Maintenu][Maximum]" value="max"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.retenido;max;%@>
  </td><td>
  Valeur Maximale
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Maintenu][Minimum]" value="min"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.retenido;min;%@>
  </td><td>
  Valeur Minimale
  </td><td class="check">
  <!-- input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Maintenu][Moyenne]" value="avg"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.retenido;avg;%@ -->
  </td><td>
  <!-- Moyenne -->
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Maintenu][Nº]" value="count"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.retenido;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Maintenu][Sommation]" value="sum"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.retenido;sum;%@>
  </td><td>
  Sommation
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Total Brut
  <input type="hidden" name="totales[Agentes.id_agente][Total Brut][field]" 
  	value="IF(Facturas.factura_abono,(Facturas.total_bruto*-1),Facturas.total_bruto)" />
  <input type="hidden" name="totales[Agentes.id_agente][Total Brut][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Total Brut][Maximum]" value="max"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.total_bruto;max;%@>
  </td><td>
  Valeur Maximale
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Total Brut][Minimum]" value="min"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.total_bruto;min;%@>
  </td><td>
  Valeur Minimale
  </td><td class="check">
  <!-- input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Total Brut][Moyenne]" value="avg"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.total_bruto;avg;%@ -->
  </td><td>
  <!-- Moyenne -->
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Total Brut][Nº]" value="count"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.total_bruto;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Total Brut][Sommation]" value="sum"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.total_bruto;sum;%@>
  </td><td>
  Sommation
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Montant
  <input type="hidden" name="totales[Agentes.id_agente][Montant][field]" 
  	value="IF(Facturas.factura_abono,(Facturas.monto_total*-1),Facturas.monto_total)" />
  <input type="hidden" name="totales[Agentes.id_agente][Montant][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Montant][Maximum]" value="max"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.monto_total;max;%@>
  </td><td>
  Valeur Maximale
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Montant][Minimum]" value="min"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.monto_total;min;%@>
  </td><td>
  Valeur Minimale
  </td><td class="check">
  <!-- input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Montant][Moyenne]" value="avg"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.monto_total;avg;%@ -->
  </td><td>
  <!-- Moyenne -->
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Montant][Nº]" value="count"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.monto_total;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Montant][Sommation]" value="sum"
  @%func:checkbox_mark;Agentes.id_agente;Facturas.monto_total;sum;%@>
  </td><td>
  Sommation
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Commisions
  <input type="hidden" name="totales[Agentes.id_agente][Montant Commision][field]" value="Agentes_facturas.monto">
  <input type="hidden" name="totales[Agentes.id_agente][Montant Commision][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Montant Commision][Maximum]" value="max"
  @%func:checkbox_mark;Agentes.id_agente;Agentes_facturas.monto;max;%@>
  </td><td>
  Valeur Maximale
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Montant Commision][Minimum]" value="min"
  @%func:checkbox_mark;Agentes.id_agente;Agentes_facturas.monto;min;%@>
  </td><td>
  Valeur Minimale
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Montant Commision][Moyenne]" value="avg"
  @%func:checkbox_mark;Agentes.id_agente;Agentes_facturas.monto;avg;%@>
  </td><td>
  Moyenne
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Montant Commision][Nº]" value="count"
  @%func:checkbox_mark;Agentes.id_agente;Agentes_facturas.monto;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Montant Commision][Sommation]" value="sum"
  @%func:checkbox_mark;Agentes.id_agente;Agentes_facturas.monto;sum;%@>
  </td><td>
  Sommation
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Commissions <sup>(par le client)</sup>
  <input type="hidden" name="totales[Clientes.id_cliente][Montant Commision par le client][field]" value="Agentes_facturas.monto">
  <input type="hidden" name="totales[Clientes.id_cliente][Montant Commision par le client][round]" value="2">
  <input type="hidden" name="totales[Clientes.id_cliente][Montant Commision par le client][erase_without]" value="ag_search">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Montant Commision par le client][Maximum]" value="max"
  @%func:checkbox_mark;Clientes.id_cliente;Agentes_facturas.monto;max;%@>
  </td><td>
  Valeur Maximale
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Montant Commision par le client][Minimum]" value="min"
  @%func:checkbox_mark;Clientes.id_cliente;Agentes_facturas.monto;min;%@>
  </td><td>
  Valeur Minimale
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Montant Commision par le client][Moyenne]" value="avg"
  @%func:checkbox_mark;Clientes.id_cliente;Agentes_facturas.monto;avg;%@>
  </td><td>
  Moyenne
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Montant Commision par le client][Nº]" value="count"
  @%func:checkbox_mark;Clientes.id_cliente;Agentes_facturas.monto;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Montant Commision par le client][Sommation]" value="sum"
  @%func:checkbox_mark;Clientes.id_cliente;Agentes_facturas.monto;sum;%@>
  </td><td>
  Sommation
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
  <td class="etiqueta" colspan="2">Type:</td>
  <td colspan="2"><!-- @%set:_selected_value=st[cl_tipo];%@ -->
  <select name="cl_tipo" class="insertext">
  <option value="">Aucune sélection</option>
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
  <td class="etiqueta" colspan="2">Réf. Ext:</td>
  <td colspan="2"><input type="text" name="fr_ref_ext" size="30" class="insertext" value="@%get:st[fr_ref_ext];%@"></td>
  <td class="etiqueta" colspan="2">Série:</td>
  <td colspan="2"><!-- @%set:_selected_value=st[fr_serie];%@ -->
  <select name="fr_serie" class="insertext">
  <option value="">Aucune sélection</option>
  @%where:tabla|Series_facturacion;nolink|1;nombre|seriesfra;where|ventas=1;%@
  <option value="@%db:Series_facturacion.id_serie;%@"
  @%db:selected_value{Series_facturacion.id_serie}%@
  >@%db:Series_facturacion.nombre;%@ 
  (@%db:si_no_flag{Series_facturacion.contabilizable}%@)</option>
  @%end-where:%@

  </select>
  </tr>

  <tr><td class="etiqueta">Depuis:</td>
  <td colspan="2"><input type=text name="fr_fecha_inicio" size="20" class="insertext" value="@%get:st[fr_fecha_inicio];%@"></td>
  <td class="etiqueta" colspan="2">Jusqu-à:</td>
  <td colspan="2"><input type=text name="fr_fecha_fin" size="20" class="insertext" value="@%get:st[fr_fecha_fin];%@"></td>
  <td class="etiqueta" colspan="2">Revenu imposable > :</td>
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
  <td class="caption" colspan="10">Effets</td>
  </tr>

  <tr>
  <td class="check" >
  <input type="checkbox" name="ic_search" value="1"
  @%if:esta_vacio;st[ic_search];%@
  @%else:@
  checked="checked"
  @%end-if:%@
  ></td>
  <td class="caption" colspan="10">Incidences</td>
  </tr>

  <tr><td class="titulotb" colspan="11">Totals</td></tr><tr>

  <td class="etiqueta" >Revenu imposable
  <input type="hidden" name="totales[Clientes.id_cliente][Revenu imposable][field]" 
  	value="IF(Facturas.factura_abono,(Facturas.base_imponible*-1),Facturas.base_imponible)" />
  <input type="hidden" name="totales[Clientes.id_cliente][Revenu imposable][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Revenu imposable][Maximum]" value="max"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.base_imponible;max;%@>
  </td><td>
  Valeur Maximale
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Revenu imposable][Minimum]" value="min"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.base_imponible;min;%@>
  </td><td>
  Valeur Minimale
  </td><td class="check">
  <!-- input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Revenu imposable][Moyenne]" value="avg"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.base_imponible;avg;%@ -->
  </td><td>
  <!-- Moyenne -->
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Revenu imposable][Nº]" value="count"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.base_imponible;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Revenu imposable][Sommation]" value="sum"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.base_imponible;sum;%@>
  </td><td>
  Sommation
  </td></tr>

  <tr>
  <td class="etiqueta" >Totals Impôt
  <input type="hidden" name="totales[Clientes.id_cliente][Totals Impôt][field]" 
  	value="IF(Facturas.factura_abono,(Facturas.total_impuestos*-1),Facturas.total_impuestos)" />
  <input type="hidden" name="totales[Clientes.id_cliente][Totals Impôt][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Totals Impôt][Maximum]" value="max"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.total_impuestos;max;%@>
  </td><td>
  Valeur Maximale
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Totals Impôt][Minimum]" value="min"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.total_impuestos;min;%@>
  </td><td>
  Valeur Minimale
  </td><td class="check">
  <!-- input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Totals Impôt][Moyenne]" value="avg"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.total_impuestos;avg;%@ -->
  </td><td>
  <!-- Moyenne -->
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Totals Impôt][Nº]" value="count"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.total_impuestos;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Totals Impôt][Sommation]" value="sum"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.total_impuestos;sum;%@>
  </td><td>
  Sommation
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Maintenu
  <input type="hidden" name="totales[Clientes.id_cliente][Maintenu][field]" 
  	value="IF(Facturas.factura_abono,(Facturas.retenido*-1),Facturas.retenido)" />
  <input type="hidden" name="totales[Clientes.id_cliente][Maintenu][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Maintenu][Maximum]" value="max"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.retenido;max;%@>
  </td><td>
  Valeur Maximale
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Maintenu][Minimum]" value="min"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.retenido;min;%@>
  </td><td>
  Valeur Minimale
  </td><td class="check">
  <!-- input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Maintenu][Moyenne]" value="avg"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.retenido;avg;%@ -->
  </td><td>
  <!-- Moyenne -->
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Maintenu][Nº]" value="count"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.retenido;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Maintenu][Sommation]" value="sum"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.retenido;sum;%@>
  </td><td>
  Sommation
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Total Brut
  <input type="hidden" name="totales[Clientes.id_cliente][Total Brut][field]" 
  	value="IF(Facturas.factura_abono,(Facturas.total_bruto*-1),Facturas.total_bruto)" />
  <input type="hidden" name="totales[Clientes.id_cliente][Total Brut][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Total Brut][Maximum]" value="max"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.total_bruto;max;%@>
  </td><td>
  Valeur Maximale
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Total Brut][Minimum]" value="min"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.total_bruto;min;%@>
  </td><td>
  Valeur Minimale
  </td><td class="check">
  <!-- input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Total Brut][Moyenne]" value="avg"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.total_bruto;avg;%@ -->
  </td><td>
  <!-- Moyenne -->
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Total Brut][Nº]" value="count"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.total_bruto;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Total Brut][Sommation]" value="sum"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.total_bruto;sum;%@>
  </td><td>
  Sommation
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Montant
  <input type="hidden" name="totales[Clientes.id_cliente][Montant][field]" 
  	value="IF(Facturas.factura_abono,(Facturas.monto_total*-1),Facturas.monto_total)" />
  <input type="hidden" name="totales[Clientes.id_cliente][Montant][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Montant][Maximum]" value="max"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.monto_total;max;%@>
  </td><td>
  Valeur Maximale
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Montant][Minimum]" value="min"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.monto_total;min;%@>
  </td><td>
  Valeur Minimale
  </td><td class="check">
  <!-- input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Montant][Moyenne]" value="avg"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.monto_total;avg;%@ -->
  </td><td>
  <!-- Moyenne -->
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Montant][Nº]" value="count"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.monto_total;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Montant][Sommation]" value="sum"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas.monto_total;sum;%@>
  </td><td>
  Sommation
  </td>
  </tr>

</table>
<br>

<br>
  </form>

