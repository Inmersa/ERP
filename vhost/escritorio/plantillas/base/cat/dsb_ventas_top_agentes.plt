
<!-- @%unset:dsb_graficas_lineal;%@ @%unset:grafica;%@ @%unset:leyenda;%@ @%unset:dsb_rs_limit;%@-->
<fieldset class="fsficha" >
<legend>{{dsb_frame_top_agente}}</legend>

<!-- table class="full" >
<thead class="dashboard" ><tr>
<td>Agents</td>
<td>Vendes</td>
</tr></thead><tbody class="dashboard" >

@%set:dsb_rs_limit=10;%@ 
@%set:dsb_resultados=top_agentes;%@

@%where:nodb|nodb_dsb_resultados_horizontal;%@
<tr><td>@%db:_periodo;%@</td>
<td>@%db:lcdec{top_agentes};%@</td></tr>
@%end-where:%@

</tbody></table -->

@%func:dsb_grfx_horizontal;top_agentes;%@
@%if:!esta_vacio;mostrar_grafica;%@
<!-- 
@%set:grafica[titulo] = Top Agents;%@
@%set:grafica[limit] = dsb_rs_limit;%@
@%set:graph_top_agentes[titulo] = nombre_periodo_actual;%@
-->
@%plt:Grafica;%@
@%end-if:%@

</fieldset>

