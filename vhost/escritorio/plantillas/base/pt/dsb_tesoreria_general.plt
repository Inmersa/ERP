
<fieldset class="fsficha" >
<legend>Indicadores Gerais</legend>

<table class="full" >
<thead class="dashboard" ><tr>
<td>Indicador</td>
<td>Prazos de Cobro</td>
<td>Prazos de Pagamento</td>
<td>Cobrado</td>
<td>Pagado</td>
<td>Em suspenso de Cobro</td>
<td>Em suspenso de Pagamento</td>
<td>Reembolsos de Cobro</td>
<td>Reembolsos de Pagamento</td>
</tr></thead><tbody class="dashboard" >

@%set:dsb_resultados=general;%@
@%set:dsb_rs_limit=7;%@
@%where:nodb|nodb_dsb_resultados_horizontal;%@
<tr>
<td>@%db:_periodo;%@ [@%db:colocar_fecha{_inicio};%@ - @%db:colocar_fecha{_fin};%@]</td>
<td>@%db:lcdec{vencimiento_cobros};%@</td>
<td>@%db:lcdec{vencimiento_pagos};%@</td>
<td>@%db:lcdec{abonos_cobrados};%@</td>
<td>@%db:lcdec{abonos_pagados};%@</td>
<td>@%db:lcdec{pendiente_cobros};%@</td>
<td>@%db:lcdec{pendiente_pagos};%@</td>
<td>@%db:lcdec{devoluciones_cobros};%@</td>
<td>@%db:lcdec{devoluciones_pagos};%@</td>
</tr>
@%end-where:%@

</tbody></table>
</fieldset>

