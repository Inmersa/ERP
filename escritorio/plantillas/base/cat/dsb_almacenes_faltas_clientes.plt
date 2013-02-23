
<!-- @%unset:dsb_graficas_lineal;%@ @%unset:grafica;%@ @%unset:leyenda;%@ @%unset:dsb_rs_limit;%@-->
<fieldset class="fsficha" >
<legend>Valors per Client</legend>

<table class="full" >
<thead class="dashboard" ><tr>
<td>Indicador</td>
<td>VValors per Venda</td>
</tr></thead><tbody class="dashboard" >

@%set:dsb_resultados=top_clientes;%@ @%set:dsb_rs_limit=7;%@ @%set:dsb_grfx_field=indicador_venta;%@
@%where:nodb|nodb_dsb_resultados_horizontal;%@
<tr>
<td>@%db:_periodo;%@ [@%db:colocar_fecha{_inicio};%@ - @%db:colocar_fecha{_fin};%@]</td>
<td>@%db:lcdec{indicador_venta};%@</td>
</tr>
@%end-where:%@

</tbody></table>
@%func:dsb_grfx_horizontal;top_clientes;indicador_venta;%@
@%if:!esta_vacio;mostrar_grafica;%@
<!-- 
@%set:grafica[limit] = dsb_rs_limit;%@
@%set:graph_top_clientes[titulo] = nombre_periodo_actual;%@
-->
@%plt:Grafica;%@
@%end-if:%@
</fieldset>

