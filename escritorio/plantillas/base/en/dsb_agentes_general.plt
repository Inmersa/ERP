
<fieldset class="fsficha" >
<legend>General Indicators</legend>

<table class="full" >
<thead class="dashboard" ><tr>
<td>Indicator</td>
<td>Value in Sales</td>
<td>Installments</td>
<td>Ordered in Sales</td>
<td>Returns in Sales</td>
</tr></thead><tbody class="dashboard" >

@%set:dsb_resultados=general;%@
@%set:dsb_rs_limit=7;%@
@%where:nodb|nodb_dsb_resultados_horizontal;%@
<tr>
<td>@%db:_periodo;%@ [@%db:colocar_fecha{_inicio};%@ - @%db:colocar_fecha{_fin};%@]</td>
<td>@%db:lcdec{indicador_base};%@</td>
<td>@%db:lcdec{abonos};%@</td>
<td>@%db:lcdec{pedidos};%@</td>
<td>@%db:lcdec{devoluciones};%@</td>
</tr>
@%end-where:%@

</tbody></table>
</fieldset>

