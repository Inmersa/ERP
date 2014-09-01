@%where:tabla|Recorridos;where|id_recorrido = $id_recorrido;%@
<!-- @%db:Recorridos.id_recorrido%@ @%db:Recorridos.h_inicio%@ @%db:Recorridos.h_fin%@ -->

<table class="full">
<tr><td class="etiqueta">Nome da Rota:</td>
<td>@%db:Rutas.nombre%@ </td>
<td class="etiqueta">Estado:</td>
<td> 
@%if:esta_vacio;Recorridos.h_inicio;Recorridos.h_fin;%@
Não Iniciado
@%set:estado_noiniciado=1;%@
@%end-if:%@

@%if:esta_vacio;Recorridos.h_fin;estado_noiniciado;%@
Iniciado
@%set:estado_iniciado=1;%@
@%end-if:%@

@%if:esta_vacio;estado_noiniciado;estado_iniciado;%@
Fechado
@%set:estado_cerrado=1;%@
@%end-if:%@</td>
</tr>

<tr>
<td class="etiqueta">Agente:</td>
<td>
@%if:esta_vacio;estado_cerrado;%@
<!-- @%set:_selected_value=Recorridos.id_agente%@ @%db:Recorridos.id_agente%@ -->
 <select name="registro[id_agente]">
 @%where:tabla|Agentes;nolink|1;%@
 <option value="@%db:Agentes.id_agente%@"
@%db:selected_value{Agentes.id_agente}%@
>@%db:Agentes.nombre%@</option>
 @%end-where:%@

 </select>
@%else:%@
 @%where:tabla|Agentes;nolink|0;%@
@%db:Agentes.nombre%@
 @%end-where:%@

@%end-if:%@
</td>
<td class="etiqueta">Meio de Contacto:</td>
<td>
@%if:esta_vacio;estado_cerrado;%@
<!-- @%db:Recorridos.id_medio_cto%@ @%set:_selected_value=Recorridos.id_medio_cto%@ -->
<select name="registro[id_medio_cto]">
@%where:tabla|Medios_contacto;nolink|1;%@
<option value="@%db:Medios_contacto.id_medio_cto%@"
@%db:selected_value{Medios_contacto.id_medio_cto}%@
>@%db:Medios_contacto.nombre%@</option>
@%end-where:%@

</select>
@%else:%@
@%where:tabla|Medios_contacto;nolink|0;%@
@%db:Medios_contacto.nombre%@
@%end-where:%@

@%end-if:%@
</td></tr>

<tr><td class="etiqueta">Observações:</td>
<td colspan="3">
@%if:esta_vacio;estado_cerrado;%@
<textarea name="registro[observaciones]" cols="70">@%db:Recorridos.observaciones%@</textarea>
@%else:%@
@%db:reemplazar_salto{Recorridos.observaciones}%@
@%end-if:%@
</td></tr>

<tr><td class="etiqueta">Data : </td>
<td >@%db:colocar_fecha{Recorridos.fecha}%@</td>

@%if:esta_vacio;estado_noiniciado;%@
<td class="etiqueta">Hora de Início: </td>
<td>@%db:Recorridos.h_inicio%@</td>
</tr>

<tr><td class="etiqueta">Data da Próxima Visita:</td>
<td >
@%if:!esta_vacio;estado_cerrado;%@
@%db:colocar_fecha{Recorridos.prox_fecha}%@
@%else:%@
<input type="text" name="registro[prox_fecha]" value="@%db:colocar_fecha{Recorridos.prox_fecha}%@" />
@%end-if:%@
</td>
<td class="etiqueta">Hora de Conclusão:</td>
<td>@%db:Recorridos.h_fin%@</td></tr>

@%else:%@
<td colspan="2"></td></tr>
@%end-if:%@
</table>

