
<div class="tituloseccion" >Tresoreria [@%func:colocar_fecha;dsb_fecha;%@]</div>

<div id="DSBPeriodos" >
<div class="item" >
@%if:equals;dsb_term;semana;%@
Per Setmana (@%get:nombre_periodo_actual;%@)
@%else:%@
<a href="?seccion=@%get:_krn_ss_name;%@&periodo=semana" >Per Setmana</a>
@%end-if:%@
</div>

<div class="item" >
@%if:equals;dsb_term;mes;%@
Per Mes (@%get:nombre_periodo_actual;%@)
@%else:%@
<a href="?seccion=@%get:_krn_ss_name;%@&periodo=mes" >Per Mes</a>
@%end-if:%@
</div>

<div class="item" >
@%if:equals;dsb_term;trimestre;%@
Per Trimestre (@%get:nombre_periodo_actual;%@)
@%else:%@
<a href="?seccion=@%get:_krn_ss_name;%@&periodo=trimestre" >Per Trimestre</a>
@%end-if:%@
</div>

<div class="item" >
@%if:equals;dsb_term;anyo;%@
Per Any (@%get:nombre_periodo_actual;%@)
@%else:%@
<a href="?seccion=@%get:_krn_ss_name;%@&periodo=anyo" >Per Any</a>
@%end-if:%@
</div></div>


<div class="PIIFichaBase" id="Indicadores_Generales" >
@%plt:IndicadoresGenerales;%@
</div>

<div class="PIIContainer" id="FichaTab_DashboardTesoreria" 
@%if:!equals;dsb_term;anyo;%@
@%if:AllowedPII;VencimientosComparados;%@
><div name="VencimientosComparados" class="activo" >Venciments</div
@%end-if:%@
@%if:AllowedPII;AbonosComparados;%@
><div name="AbonosComparados" >Abonaments</div
@%end-if:%@
@%if:AllowedPII;PendienteComparados;%@
><div name="PendienteComparados" >Pendents</div
@%end-if:%@
@%if:AllowedPII;DevolucionesComparadas;%@
><div name="DevolucionesComparadas" >Devolucions</div
@%end-if:%@
@%end-if:%@
></div>

@%if:!equals;dsb_term;anyo;%@
<div class="PIIFicha" id="VencimientosComparados" >
@%plt:VencimientosComparados;%@
</div>
<div class="PIIFicha" id="AbonosComparados" >
@%plt:AbonosComparados;%@
</div>
<div class="PIIFicha" id="PendienteComparados" >
@%plt:PendienteComparados;%@
</div>
<div class="PIIFicha" id="DevolucionesComparadas" >
@%plt:DevolucionesComparadas;%@
</div>
@%end-if:%@

<script >
<!-- 
TabDashboardTesoreria = new TabGroup(document.getElementById('FichaTab_DashboardTesoreria'));
// -->
</script>

