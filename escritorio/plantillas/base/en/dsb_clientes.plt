
<div class="tituloseccion" >
Client 
[@%func:colocar_fecha;_dsb_fecha;%@]
@%if:!esta_vacio;id_cliente;%@
@%where:tabla|Clientes;where|Clientes.id_cliente = $id_cliente;nolink|1;%@
@%db:Clientes.razon_social;%@
@%end-where:%@

@%end-if:%@
</div>

<div id="DSBPeriodos" >
<div class="item" >
@%if:equals;dsb_term;semana;%@
Per Week (@%get:nombre_periodo_actual;%@)
@%else:%@
<a href="?seccion=@%get:_krn_ss_name;%@&periodo=semana" >Per Week</a>
@%end-if:%@
</div>

<div class="item" >
@%if:equals;dsb_term;mes;%@
Per Month (@%get:nombre_periodo_actual;%@)
@%else:%@
<a href="?seccion=@%get:_krn_ss_name;%@&periodo=mes" >Per Month</a>
@%end-if:%@
</div>

<div class="item" >
@%if:equals;dsb_term;trimestre;%@
Per Trimester (@%get:nombre_periodo_actual;%@)
@%else:%@
<a href="?seccion=@%get:_krn_ss_name;%@&periodo=trimestre" >Per Trimester</a>
@%end-if:%@
</div>

<div class="item" >
@%if:equals;dsb_term;anyo;%@
Per Year (@%get:nombre_periodo_actual;%@)
@%else:%@
<a href="?seccion=@%get:_krn_ss_name;%@&periodo=anyo" >Per Year</a>
@%end-if:%@
</div></div>

<div class="PIIFichaBase" id="Indicadores_Generales" >
@%plt:IndicadoresGenerales;%@
</div>

<div class="PIIContainer" id="FichaTab_DashboardClientes" 
@%if:!equals;dsb_term;anyo;%@
@%if:AllowedPII;IndicadoresComparados;%@
><div name="IndicadoresComparados" class="activo" >Compared Values</div
@%end-if:%@
@%if:AllowedPII;AbonosComparados;%@
><div name="AbonosComparados" >Compared Installments</div
@%end-if:%@
@%if:AllowedPII;PedidosComparados;%@
><div name="PedidosComparados" >Compared Orders</div
@%end-if:%@
@%if:AllowedPII;DevolucionesComparadas;%@
><div name="DevolucionesComparadas" >Compared Returns</div
@%end-if:%@
@%if:AllowedPII;ServidoComparados;%@
><div name="ServidoComparados" >Compared Served</div
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
><div name="TopArticulos" >Top Products by Sales</div
@%end-if:%@
@%if:AllowedPII;TopMarcas;%@
><div name="TopMarcas" >Top Brands</div
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

