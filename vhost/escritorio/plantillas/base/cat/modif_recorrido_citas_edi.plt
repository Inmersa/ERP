
<!-- @%db:Recorridos.id_recorrido;%@ -->
<form name="citas" action="?seccion=modif_recorridos" method="post">
<input type="hidden" name="accion_ejecutar" value="Guardar_clientes" />
<input type="hidden" name="clientes_array" value="" />

<fieldset class="fsficha" >
<legend>Llistat de Recorreguts</legend>

@%if:esta_vacio;estado_cerrado;%@
<div class="AccionesFicha"><ul>
@%if:AllowedAction;Citas;new;%@
<li><a href="#" onClick="return onHRefClick('citas', 'clientes_array', 'clientes','seleccionar_clientes');" class="asociar" 
	><img src="images/pixel.png" class="icono" /><span>Afegir</span></a></li>
@%end-if:%@
@%if:AllowedAction;Citas;del;%@
<li><a href="#" onClick="return onHRefClick('citas', 'accion_ejecutar', 'Borrar_clientes');" class="borrar" 
	><img src="images/pixel.png" class="icono" /><span>Esborrar seleccionats</span></a></li>
@%end-if:%@
</ul></div>
@%end-if:%@

<table class="full">
<thead>
<tr>
@%if:AllowedAction;Citas;del;%@
<td></td>
@%end-if:%@
<td >ID Client</td>
<td >Cita</td>
<td >Hora d�inici</td>
<td >Hora finalitzaci� agent</td>
<td >Visitat</td>
<td >Comanda</td>
<td >Total base imposable</td>
</tr>
</thead>
<tbody>
 @%where:tabla|Citas;no_results|1;order|Citas.h_fin_sys asc, Citas.h_inicio asc;%@
 <!-- @%db:Citas.id_pedido%@ @%db:Citas.h_fin_sys;%@ -->
 @%if:!esta_vacio;Citas.h_fin_sys;%@
 <tr class="resalte" ><td></td>
 @%else:%@
 	@%if:!esta_vacio;estado_cerrado;%@
 	<tr class="impropio"><td></td>
	@%else:%@
	 <tr>
	 <input type="hidden" name="clientes[@%db:Clientes.id_cliente;%@]" value="@%db:Clientes.id_cliente%@" />
	  @%if:AllowedAction;Citas;del;%@
	  <td class="check"><input type="checkbox" name="borrar_clientes[@%db:Clientes.id_cliente;%@]" value="1" /></td>
	  @%end-if:%@
	@%end-if:%@
 @%end-if:%@

<td>@%db:Clientes.id_cliente;%@</td>
<td><a href="?seccion=modif_cita&id_cita=@%db:Citas.id_cita%@">@%db:Clientes.razon_social;%@</a></td>
<td>@%db:Citas.h_inicio;%@</td>
<td>@%db:Citas.h_fin_ag%@ </td>
<td>@%db:si_no_flag{Citas.visitado};%@</td>
<td>
 @%if:esta_vacio;Citas.id_pedido;%@
Cap 
@%set:total_base_pedido=0%@
 @%else:%@
@%where:tabla|Pedidos;group|Pedidos.id_pedido%@
<a href="?seccion=bo_pedido_cliente&id_pedido=@%db:Pedidos.id_pedido%@" >@%db:Pedidos.referencia%@</a>
<!-- @%db:SUM(IVAs.monto) as 'monto_total';%@
@%set:total_base_pedido=monto_total%@ -->
@%end-where:%@

@%end-if:%@
</td>
<td>@%func:fmt_lcmon;total_base_pedido;%@</td>
</tr>
@%end-where:%@

</tbody>
</table>
</fieldset>
</form>

