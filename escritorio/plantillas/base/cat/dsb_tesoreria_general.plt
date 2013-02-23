
<fieldset class="fsficha" >
<legend>Indicadors Generals</legend>

<table class="full" >
<thead class="dashboard" ><tr>
<td>Indicador</td>
<td>Venciments de Cobrament</td>
<td>Venciments de Pagament</td>
<td>Cobrat</td>
<td>Pagat</td>
<td>Per Pagar</td>
<td>Per Cobrar</td>
<td>Devolucions de Cobrament</td>
<td>Devolucions de Pagament</td>
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

