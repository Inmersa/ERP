
<div class="tituloseccion" >Trésor [@%func:colocar_fecha;dsb_fecha;%@]</div>

<div id="DSBPeriodos" >
<div class="item" >
@%if:equals;dsb_term;semana;%@
Par Semaine (@%get:nombre_periodo_actual;%@)
@%else:%@
<a href="?seccion=@%get:_krn_ss_name;%@&periodo=semana" >Par Semaine</a>
@%end-if:%@
</div>

<div class="item" >
@%if:equals;dsb_term;mes;%@
Par Mois (@%get:nombre_periodo_actual;%@)
@%else:%@
<a href="?seccion=@%get:_krn_ss_name;%@&periodo=mes" >Par Mois</a>
@%end-if:%@
</div>

<div class="item" >
@%if:equals;dsb_term;trimestre;%@
Par Trimestriel (@%get:nombre_periodo_actual;%@)
@%else:%@
<a href="?seccion=@%get:_krn_ss_name;%@&periodo=trimestre" >Par Trimestriel</a>
@%end-if:%@
</div>

<div class="item" >
@%if:equals;dsb_term;anyo;%@
Par Année (@%get:nombre_periodo_actual;%@)
@%else:%@
<a href="?seccion=@%get:_krn_ss_name;%@&periodo=anyo" >Par Année</a>
@%end-if:%@
</div></div>


<div class="PIIFichaBase" id="Indicadores_Generales" >
@%plt:IndicadoresGenerales;%@
</div>

<div class="PIIContainer" id="FichaTab_DashboardTesoreria" 
@%if:!equals;dsb_term;anyo;%@
@%if:AllowedPII;VencimientosComparados;%@
><div name="VencimientosComparados" class="activo" >Échéances</div
@%end-if:%@
@%if:AllowedPII;AbonosComparados;%@
><div name="AbonosComparados" >Engrais</div
@%end-if:%@
@%if:AllowedPII;PendienteComparados;%@
><div name="PendienteComparados" >En suspens</div
@%end-if:%@
@%if:AllowedPII;DevolucionesComparadas;%@
><div name="DevolucionesComparadas" >Remboursements</div
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

