
<!-- @%unset:dsb_graficas_lineal;%@ @%unset:grafica;%@ @%unset:leyenda;%@ @%unset:dsb_rs_limit;%@-->
<fieldset class="fsficha" >
<legend>Indicateurs Généraux</legend>

<table class="full" >
<thead class="dashboard" ><tr>
<td>Indicateur</td>
<td>Valeurs en Vente</td>
</tr></thead><tbody class="dashboard" >

@%set:dsb_resultados=general;%@ @%set:dsb_rs_limit=7;%@ @%set:dsb_grfx_field=indicador_venta;%@
@%where:nodb|nodb_dsb_resultados_horizontal;%@
<tr>
<td>@%db:_periodo;%@</td>
<td>@%db:lcdec{indicador_venta};%@</td>
</tr>
@%end-where:%@

</tbody></table>

@%func:dsb_grfx_horizontal;general;indicador_venta;%@
@%if:!esta_vacio;mostrar_grafica;%@
<!-- 
@%set:grafica[limit] = dsb_rs_limit;%@
@%set:graph_general[titulo] = nombre_periodo_actual;%@
-->
@%plt:Grafica;%@
@%end-if:%@

</fieldset>

