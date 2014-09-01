
<fieldset class="fsficha" >
<legend>General Indicators</legend>

<table class="full" >
<thead class="dashboard" ><tr>
<td>Indicator</td>
<td>Served in Sales</td>
<td>Returns in Sales</td>
<td>Stock Downs</td>
</tr></thead><tbody class="dashboard" >

@%set:dsb_resultados=general;%@
@%set:dsb_rs_limit=7;%@
@%where:nodb|nodb_dsb_resultados_horizontal;%@
<tr>
<td>@%db:_periodo;%@ [@%db:colocar_fecha{_inicio};%@ - @%db:colocar_fecha{_fin};%@]</td>
<td>@%db:lcdec{servido};%@</td>
<td>@%db:lcdec{devoluciones};%@</td>
<td>@%db:lcdec{bajas};%@</td>
</tr>
@%end-where:%@

</tbody></table>
</fieldset>

