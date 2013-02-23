
<fieldset class="fsficha" >

<legend>Cita
@%if:esta_vacio;Citas.h_inicio;Citas.h_fin_sys;Recorridos.h_fin;%@
No iniciado
@%set:estado_noiniciado=1;%@
@%else:%@
	@%if:esta_vacio;Citas.h_fin_sys;Recorridos.h_fin;%@
	Iniciado
	@%set:estado_iniciado=1;%@
	@%else:%@
	Cerrado
	@%set:estado_cerrado=1;%@
	@%end-if:%@
@%end-if:%@
</legend>

<form name="cita" action="?seccion=modif_cita" method="post">
<input type="hidden" name="accion_ejecutar" value="Guardar">
<input type="hidden" name="registro[id_cita]" value="@%db:Citas.id_cita%@">
<input type="hidden" name="registro[id_recorrido]" value="@%db:Recorridos.id_recorrido%@">
<input type="hidden" name="registro[id_cliente]" value="@%db:Clientes.id_cliente;%@">
<input type="hidden" name="registro[h_inicio]" value="@%db:Citas.h_inicio;%@">
<input type="hidden" name="registro[h_fin_sys]" value="@%db:Citas.h_fin_sys;%@">
<!-- @%db:Recorridos.h_inicio;%@ @%db:Recorridos.h_fin;%@ -->

 <table class="full" >
 <tbody>
 <tr> 
 <td class="etiqueta" >Nombre:</td>
 <td colspan="1" ><a href="?seccion=modif_clientes&id_cliente=@%db:Clientes.id_cliente;%@" >@%db:Clientes.razon_social;%@</a></td>
 <td class="etiqueta" >ID-Cliente: </td>
 <td >@%db:Clientes.id_cliente;%@</td>
 </tr>
 <tr> 
 <td class="etiqueta" >Dirección:</td>
 <td > @%db:Clientes.direccion_facturacion;%@ </td>
 <td class="etiqueta">Visitado:</td>
@%if:esta_vacio;estado_cerrado;%@
 <td class="check"><input type="checkbox" name="registro[visitado]" value="1" @%db:check_flag{Citas.visitado}%@ >@%db:si_no_flag{Citas.visitado};%@</td>
@%else:%@
 <td class="check">@%db:si_no_flag{Citas.visitado};%@</td>
 <input type="hidden" name="registro[visitado]" value="@%db:Citas.visitado%@" >
@%end-if:%@
 </tr>

 <tr> 
 <td class="etiqueta" >ID-Pedido:</td>
 <td ><!-- @%db:Citas.id_pedido%@ -->
@%if:esta_vacio;Citas.id_pedido;%@
-- Ninguno --
@%else:%@
@%where:tabla|Pedidos;group|Pedidos.id_pedido;%@
<a href="?seccion=bo_pedido_cliente&id_pedido=@%db:Pedidos.id_pedido%@">@%db:Pedidos.referencia%@</a>
(@%db:SUM(Lineas_detalle.monto_total) as 'monto_pedido';%@ @%db:Divisa.leyenda%@)
@%end-where:%@

@%end-if:%@
 </td>
<td class="etiqueta">Medio Contacto:</td>
 <td colspan="3" >
@%if:esta_vacio;estado_cerrado;%@
 <!-- @%set:_selected_value=Citas.id_medio_cto%@ @%db:Citas.id_medio_cto%@ -->
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
 </td>
 </tr>
 <tr> 
 <td class="etiqueta" >Observaciones:</td>
 <td colspan="3"><textarea name="registro[observaciones]" cols="70" class="insertext">@%db:Citas.observaciones%@</textarea></td>
 </tr>

 <tr> 
 <td class="etiqueta">Recorrido: </td>
 <td colspan="3" ><a href="?seccion=modif_recorridos&id_recorrido=@%db:Recorridos.id_recorrido;%@" >@%db:Rutas.nombre;%@ (@%db:colocar_fecha{Recorridos.fecha}%@)</a></td>
 </tr>

@%if:!esta_vacio;estado_iniciado;%@
 <tr>
 <td class="etiqueta">Hora Inicio: </td>
 <td >@%db:Citas.h_inicio%@</td>
 <td class="etiqueta">Hora Finalización Agente:</td>
 <td ><input type="text" name="registro[h_fin_ag]" size="8" value="@%db:Citas.h_fin_ag;%@"></td>
 </tr>

 <tr>
 <td class="etiqueta">Medio Próximo Contacto:</td>
 <td > 
 <!-- @%set:_selected_value=Citas.prox_id_medio_cto%@ @%db:Citas.prox_id_medio_cto%@ -->
 <select name="registro[prox_id_medio_cto]">
 @%where:tabla|Medios_contacto;nolink|1;%@
 <option value="@%db:Medios_contacto.id_medio_cto%@"
@%db:selected_value{Medios_contacto.id_medio_cto}%@
>@%db:Medios_contacto.nombre%@</option>
 @%end-where:%@

 </select></td>
 <td class="etiqueta">Fecha Próxima Visita:</td>
 <td ><input type="text" name="registro[prox_fecha]" value="@%db:colocar_fecha{Citas.prox_fecha}%@" class="texto"></td>
 </tr>

 <tr> 
 <td class="etiqueta">Comentario Próximo Contacto:</td>
 <td colspan="3"><textarea name="registro[prox_comentario]" cols="70" class="insertext">@%db:Citas.prox_comentario%@</textarea>
 </td>
 </tr>
@%end-if:%@
@%if:!esta_vacio;estado_cerrado;%@
 <tr>
 <td class="etiqueta">Hora Inicio: </td>
 <td >@%db:Citas.h_inicio%@</td>
 <td class="etiqueta">Hora Finalización Agente:</td>
 <td >@%db:Citas.h_fin_ag;%@</td>
 </tr>

 <tr>
 <td class="etiqueta">Medio Próximo Contacto:</td>
 <td > 
 @%where:tabla|Medios_contacto;nolink|0;%@
 @%db:Medios_contacto.nombre%@
 @%end-where:%@

 </td>
 <td class="etiqueta">Fecha Próxima Visita:</td>
 <td >@%db:colocar_fecha{Citas.prox_fecha}%@</td>
 </tr>

 <tr> 
 <td class="etiqueta">Comentario Próximo Contacto:</td>
 <td colspan="3">@%db:reemplazar_salto{Citas.prox_comentario}%@</td>
 </tr>
@%end-if:%@

 </tbody>
 </table>
 <input type="hidden" name="Guardar" value="Guardar">
</fieldset>
</form>

