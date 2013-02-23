@%where:tabla|Recorridos;where|id_recorrido = $id_recorrido;%@
<!-- @%db:Recorridos.id_recorrido%@ @%db:Recorridos.h_inicio%@ @%db:Recorridos.h_fin%@ -->
<table class="full">
<tr><td class="etiqueta">Nom route:</td>
<td>@%db:Rutas.nombre%@ </td>
<td class="etiqueta">État:</td>
<td> 
@%if:esta_vacio;Recorridos.h_inicio;Recorridos.h_fin;%@
Non Initié
@%set:estado_noiniciado=1;%@
@%end-if:%@

@%if:esta_vacio;Recorridos.h_fin;estado_noiniciado;%@
Commencer
@%set:estado_iniciado=1;%@
@%end-if:%@

@%if:esta_vacio;estado_noiniciado;estado_iniciado;%@
Fermes
@%set:estado_cerrado=1;%@
@%end-if:%@</td>
</tr>

<tr>
<td class="etiqueta">Agent:</td>
<td><!-- @%db:Recorridos.id_agente%@ -->
 @%where:tabla|Agentes;nolink|0;%@
@%db:Agentes.nombre%@
 @%end-where:%@

</td>
<td class="etiqueta">Moyen de contact:</td>
<td>
<!-- @%db:Recorridos.id_medio_cto%@ -->
@%where:tabla|Medios_contacto;nolink|0;%@
@%db:Medios_contacto.nombre%@
@%end-where:%@

</td></tr>

<tr><td class="etiqueta">Observationes:</td>
<td colspan="3">@%db:reemplazar_salto{Recorridos.observaciones}%@</td>
</tr>

<tr><td class="etiqueta">Jour début: </td>
<td>@%db:Recorridos.h_inicio%@</td>
<td class="etiqueta">Jour final système:</td>
<td>@%db:Recorridos.h_fin%@</td>
 </tr>

<tr><td class="etiqueta">Date :</td>
<td>@%db:colocar_fecha{Recorridos.fecha}%@</td>
<td class="etiqueta">Date prochaine visite:</td>
<td>@%db:colocar_fecha{Recorridos.prox_fecha}%@</td>
</tr>
</table>

