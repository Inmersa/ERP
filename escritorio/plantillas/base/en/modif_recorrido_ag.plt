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
@%end-if:%@
</td></tr>

<tr>
<td class="etiqueta">Agent:</td>
<td><!-- @%db:Recorridos.id_agente%@ -->
 @%where:tabla|Agentes;nolink|0;%@
@%db:Agentes.nombre%@
 @%end-where:%@

 </td>
<td class="etiqueta">Contact way:</td>
<td>
<!-- @%db:Recorridos.id_medio_cto%@ @%set:_selected_value=Recorridos.id_medio_cto%@ -->
@%if:AllowedAction;Recorridos;edit;%@
	@%if:!esta_vacio;estado_cerrado;%@
	@%where:tabla|Medios_contacto;nolink|0;%@
	@%db:Medios_contacto.nombre%@
	@%end-where:%@

	@%else:%@
	<select name="registro[id_medio_cto]">
	@%where:tabla|Medios_contacto;nolink|1;%@
	<option value="@%db:Medios_contacto.id_medio_cto%@"
	@%db:selected_value{Medios_contacto.id_medio_cto}%@
	>@%db:Medios_contacto.nombre%@</option>
	@%end-where:%@

	</select>
	@%end-if:%@
@%else:%@
@%where:tabla|Medios_contacto;nolink|0;%@
@%db:Medios_contacto.nombre%@
@%end-where:%@

@%end-if:%@
</td></tr>

@%if:!esta_vacio;estado_noiniciado;%@
<tr><td class="etiqueta">Date :</td>
<td colspan="3" ><input type="text" name="registro[fecha]" value="@%db:colocar_fecha{Recorridos.fecha}%@" /></td>
</tr>
@%end-if:%@

<tr><td class="etiqueta">Remarks:</td>
<td colspan="3">
@%if:!esta_vacio;estado_cerrado;%@
@%db:reemplazar_salto{Recorridos.observaciones}%@
@%else:%@
<textarea name="registro[observaciones]" cols="70">@%db:Recorridos.observaciones%@</textarea>
@%end-if:%@
</td></tr>

<tr><td class="etiqueta">Date : </td>
<td >@%db:colocar_fecha{Recorridos.fecha}%@</td>

@%if:esta_vacio;estado_noiniciado;%@
<td class="etiqueta">Start time: </td>
<td>@%db:Recorridos.h_inicio%@</td>
</tr>

<tr><td class="etiqueta">Next visit date:</td>
<td >
@%if:!esta_vacio;estado_cerrado;%@
@%db:colocar_fecha{Recorridos.prox_fecha}%@
@%else:%@
<input type="text" name="registro[prox_fecha]" value="@%db:colocar_fecha{Recorridos.prox_fecha}%@" />
@%end-if:%@
</td>
<td class="etiqueta">Final system time:</td>
<td>@%db:Recorridos.h_fin%@</td>
</tr>
@%else:%@
<td colspan="2"></td></tr>
@%end-if:%@

</table>

