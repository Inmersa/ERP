@%where:tabla|Recorridos;where|id_recorrido = $id_recorrido;%@
<!-- @%db:Recorridos.id_recorrido%@ @%db:Recorridos.h_inicio%@ @%db:Recorridos.h_fin%@ -->
<table class="full">
<tr><td class="etiqueta">Route Name:</td>
<td>@%db:Rutas.nombre%@ </td>
<td class="etiqueta">Condition:</td>
<td> 
@%if:esta_vacio;Recorridos.h_inicio;Recorridos.h_fin;%@
Not Initiated
@%set:estado_noiniciado=1;%@
@%end-if:%@

@%if:esta_vacio;Recorridos.h_fin;estado_noiniciado;%@
Started
@%set:estado_iniciado=1;%@
@%end-if:%@

@%if:esta_vacio;estado_noiniciado;estado_iniciado;%@
Closed
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
<td class="etiqueta">Contact way:</td>
<td>
<!-- @%db:Recorridos.id_medio_cto%@ -->
@%where:tabla|Medios_contacto;nolink|0;%@
@%db:Medios_contacto.nombre%@
@%end-where:%@

</td></tr>

<tr><td class="etiqueta">Remarks:</td>
<td colspan="3">@%db:reemplazar_salto{Recorridos.observaciones}%@</td>
</tr>

<tr><td class="etiqueta">Start time: </td>
<td>@%db:Recorridos.h_inicio%@</td>
<td class="etiqueta">Final system time:</td>
<td>@%db:Recorridos.h_fin%@</td>
 </tr>

<tr><td class="etiqueta">Date :</td>
<td>@%db:colocar_fecha{Recorridos.fecha}%@</td>
<td class="etiqueta">Next visit date:</td>
<td>@%db:colocar_fecha{Recorridos.prox_fecha}%@</td>
</tr>
</table>

