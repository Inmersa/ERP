
<fieldset class="fsficha" >
<legend>Indicateurs Généraux</legend>

<table class="full" >
<thead class="dashboard" ><tr>
<td>Indicateur</td>
<td>Échéances d'Encaissement</td>
<td>Échéances de Paiement</td>
<td>Perçu</td>
<td>Payé</td>
<td>En suspens de d'Encaissement</td>
<td>En suspens Paiement</td>
<td>Remboursements d'Encaissement</td>
<td>Remboursements de Paiement</td>
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

