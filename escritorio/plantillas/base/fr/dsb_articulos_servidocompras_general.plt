
<fieldset class="fsficha" >
<legend>Indicateurs Généraux</legend>

<table class="full" >
<thead class="dashboard" ><tr>
<td>Indicateur</td>
<td>Servi dans des Achats</td>
<td>Commande dans des Achats</td>
<td>Remboursements dans des Achats</td>
</tr></thead><tbody class="dashboard" >

@%set:dsb_resultados=general;%@
@%set:dsb_rs_limit=7;%@
@%where:nodb|nodb_dsb_resultados_horizontal;%@
<tr>
<td>@%db:_periodo;%@ [@%db:colocar_fecha{_inicio};%@ - @%db:colocar_fecha{_fin};%@]</td>
<td>@%db:lcdec{servido};%@</td>
<td>@%db:lcdec{pedidos};%@</td>
<td>@%db:lcdec{devoluciones};%@</td>
</tr>
@%end-where:%@

</tbody></table>
</fieldset>

