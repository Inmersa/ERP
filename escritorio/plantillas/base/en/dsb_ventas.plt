
<div class="tituloseccion" >Sales [@%func:colocar_fecha;dsb_fecha;%@]</div>

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

<div class="PIIContainer" id="FichaTab_DashboardVentas" 
@%if:!equals;dsb_term;anyo;%@
@%if:AllowedPII;IndicadoresComparados;%@
><div name="IndicadoresComparados" class="activo" >Compared Sales</div
@%end-if:%@
@%end-if:%@
@%if:AllowedPII;TopClientes;%@
><div name="TopClientes" 
@%if:equals;dsb_term;anyo;%@
class="activo"
@%end-if:%@
>Top Clients</div
@%end-if:%@
@%if:AllowedPII;TopAgentes;%@
><div name="TopAgentes" >Top Agents</div
@%end-if:%@
@%if:AllowedPII;TopMarcas;%@
><div name="TopMarcas" >Top Brands</div
@%end-if:%@
@%if:AllowedPII;TopArticulos;%@
><div name="TopArticulos" >Top Products by Sales</div
@%end-if:%@
></div>

@%if:!equals;dsb_term;anyo;%@
<div class="PIIFicha" id="IndicadoresComparados" >
@%plt:IndicadoresComparados;%@
</div>
@%end-if:%@

<div class="PIIFicha" id="TopClientes" >
@%plt:TopClientes;%@
</div>
<div class="PIIFicha" id="TopAgentes" >
@%plt:TopAgentes;%@
</div>
<div class="PIIFicha" id="TopMarcas" >
@%plt:TopMarcas;%@
</div>
<div class="PIIFicha" id="TopArticulos" >
@%plt:TopArticulos;%@
</div>
<div class="PIIFicha" id="PMAArticulos" >
@%plt:PMPArticulos;%@
</div>

<script >
<!-- 
TabDashboardVentas = new TabGroup(document.getElementById('FichaTab_DashboardVentas'));
// -->
</script>

