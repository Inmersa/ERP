
<div class="tituloseccion" >
Fornecedor 
[@%func:colocar_fecha;_dsb_fecha;%@]
@%if:!esta_vacio;id_proveedor;%@
@%where:tabla|Proveedores;where|Proveedores.id_proveedor = $id_proveedor;nolink|1;%@
@%db:Proveedores.razon_social;%@
@%end-where:%@

@%end-if:%@
</div>

<div id="DSBPeriodos" >
<div class="item" >
@%if:equals;dsb_term;semana;%@
Por Semana (@%get:nombre_periodo_actual;%@)
@%else:%@
<a href="?seccion=@%get:_krn_ss_name;%@&periodo=semana" >Por Semana</a>
@%end-if:%@
</div>

<div class="item" >
@%if:equals;dsb_term;mes;%@
Por Mês (@%get:nombre_periodo_actual;%@)
@%else:%@
<a href="?seccion=@%get:_krn_ss_name;%@&periodo=mes" >Por Mês</a>
@%end-if:%@
</div>

<div class="item" >
@%if:equals;dsb_term;trimestre;%@
Por Trimestre (@%get:nombre_periodo_actual;%@)
@%else:%@
<a href="?seccion=@%get:_krn_ss_name;%@&periodo=trimestre" >Por Trimestre</a>
@%end-if:%@
</div>

<div class="item" >
@%if:equals;dsb_term;anyo;%@
Por Ano (@%get:nombre_periodo_actual;%@)
@%else:%@
<a href="?seccion=@%get:_krn_ss_name;%@&periodo=anyo" >Por Ano</a>
@%end-if:%@
</div></div>

<div class="PIIFichaBase" id="Indicadores_Generales" >
@%plt:IndicadoresGenerales;%@
</div>

<div class="PIIContainer" id="FichaTab_DashboardClientes" 
@%if:!equals;dsb_term;anyo;%@
@%if:AllowedPII;IndicadoresComparados;%@
><div name="IndicadoresComparados" class="activo" >Valores Comparados</div
@%end-if:%@
@%if:AllowedPII;AbonosComparados;%@
><div name="AbonosComparados" >Créditos Comparados</div
@%end-if:%@
@%if:AllowedPII;PedidosComparados;%@
><div name="PedidosComparados" >Encomendas Comparadas</div
@%end-if:%@
@%if:AllowedPII;DevolucionesComparadas;%@
><div name="DevolucionesComparadas" >Reembolsos Comparados</div
@%end-if:%@
@%if:AllowedPII;ServidoComparados;%@
><div name="ServidoComparados" >Servido Comparado</div
@%end-if:%@
@%end-if:%@
></div>

@%if:!equals;dsb_term;anyo;%@
<div class="PIIFicha" id="IndicadoresComparados" >
@%plt:IndicadoresComparados;%@
</div>
<div class="PIIFicha" id="AbonosComparados" >
@%plt:AbonosComparados;%@
</div>
<div class="PIIFicha" id="PedidosComparados" >
@%plt:PedidosComparados;%@
</div>
<div class="PIIFicha" id="DevolucionesComparadas" >
@%plt:DevolucionesComparadas;%@
</div>
<div class="PIIFicha" id="ServidoComparados" >
@%plt:ServidoComparados;%@
</div>
@%end-if:%@

<div class="PIIContainer" id="FichaTab_DashboardClientesTop" 
@%if:AllowedPII;TopArticulos;%@
><div name="TopArticulos" >Top Artigos</div
@%end-if:%@
@%if:AllowedPII;TopMarcas;%@
><div name="TopMarcas" >Top Marcas</div
@%end-if:%@
></div>

<div class="PIIFicha" id="TopArticulos" >
@%plt:TopArticulos;%@
</div>

<div class="PIIFicha" id="TopMarcas" >
@%plt:TopMarcas;%@
</div>

<script >
<!-- 
TabDashboardClientes = new TabGroup(document.getElementById('FichaTab_DashboardClientes'));
TabDashboardClientesTop = new TabGroup(document.getElementById('FichaTab_DashboardClientesTop'));
// -->
</script>

