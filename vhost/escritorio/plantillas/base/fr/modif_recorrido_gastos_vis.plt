@%where:tabla|Recorridos;where|id_recorrido = $id_recorrido;%@
<!-- @%db:Recorridos.id_recorrido;%@ -->

<fieldset class="fsficha" >
<legend>Dépenses</legend>
<table class="full"><thead><tr>
<td >Nom</td>
<td >Comentaire</td>
<td >Montant</td>
</tr></thead><tbody>
@%where:tabla|Recorridos_gastos;%@
<tr>
<td>@%db:Gastos.nombre%@</td>
<td>@%db:reemplazar_salto{Recorridos_gastos.comentario}%@</td>
<td>@%db:Recorridos_gastos.importe%@</td>
</tr>
@%end-where:%@

</tbody></table>
</fieldset>

