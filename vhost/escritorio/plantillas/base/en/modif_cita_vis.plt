
<!-- @%db:Citas.id_cita;%@ -->
<fieldset class="fsficha" >
<legend>Appointment</legend>

 <table class="full" >
 <tr> 
 <td class="etiqueta" >Name:</td>
 <td colspan="1" ><a href="?seccion=modif_clientes&id_cliente=@%db:Clientes.id_cliente;%@" >@%db:Clientes.razon_social;%@</a></td>
 <td class="etiqueta" >ID-Client: </td>
 <td >@%db:Clientes.id_cliente;%@</td>
 </tr>
 <tr> 
 <td class="etiqueta" >Address:</td>
 <td > @%db:Clientes.direccion_facturacion;%@ </td>
 <td class="etiqueta">Visit done:</td>
 <td class="check">@%db:si_no_flag{Citas.visitado};%@</td>
 </tr>

 <tr> 
 <td class="etiqueta" >ID-Order:</td>
 <td ><!-- @%db:Citas.id_pedido%@ -->
@%if:esta_vacio;Citas.id_pedido;%@
None
@%else:%@
@%where:tabla|Pedidos;group|Pedidos.id_pedido;%@
<a href="?seccion=bo_pedido_cliente&id_pedido=@%db:Pedidos.id_pedido%@">@%db:Pedidos.referencia%@</a>
(@%db:SUM(Lineas_detalle.monto_total) as 'monto_pedido';%@ @%db:Divisa.leyenda%@)
@%end-where:%@

@%end-if:%@
 </td>
<td class="etiqueta">Contact way:</td>
 <td colspan="3" ><!-- @%db:Citas.id_medio_cto%@ -->
 @%where:tabla|Medios_contacto;nolink|0;%@
@%db:Medios_contacto.nombre%@
 @%end-where:%@

 </td>
 </tr>
 <tr> 
 <td class="etiqueta" >Remarks:</td>
 <td colspan="3">@%db:reemplazar_salto{Citas.observaciones}%@</td>
 </tr>

 <tr> 
 <td class="etiqueta">Day Work: </td>
 <td ><a href="?seccion=modif_recorridos&id_recorrido=@%db:Recorridos.id_recorrido;%@" >@%db:Rutas.nombre;%@ (@%db:colocar_fecha{Recorridos.fecha}%@)</a></td>
 <td class="etiqueta" >Final system time:</td>
 <td >@%db:Citas.h_fin_sys%@</td>
 </tr>
 <tr>
 <td class="etiqueta">Start time: </td>
 <td >@%db:Citas.h_inicio%@</td>
 <td class="etiqueta">End time agent:</td>
 <td >@%db:Citas.h_fin_ag%@</td>
 </tr>

 <tr>
 <td class="etiqueta">Next contact media:</td>
 <td > 
 <!-- @%db:Citas.prox_id_medio_cto%@ -->
 @%where:tabla|Medios_contacto;nolink|0;%@
@%db:Medios_contacto.nombre%@
 @%end-where:%@

 </td>
 <td class="etiqueta">Next visit date:</td>
 <td >@%db:colocar_fecha{Citas.prox_fecha}%@</td>
 </tr>

 <tr> 
 <td class="etiqueta">Remark next contact:</td>
 <td colspan="3">@%db:reemplazar_salto{Citas.prox_comentario}%@</td>
 </tr>
 </table>
 <input type="hidden" name="Guardar" value="Guardar">
</fieldset>
</form>

