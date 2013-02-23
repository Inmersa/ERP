
<!-- @%db:Recorridos.id_recorrido;%@ -->
<fieldset class="fsficha" >
<legend>Listage Parcours</legend>

<table class="full">
<thead><tr>
<td >ID client</td>
<td >Citation</td>
<td >Jour début</td>
<td >Jour final système</td>
<td >Visité</td>
<td >Commande</td>
<td >Total revenu imposable</td>
</tr></thead>

<tbody>
@%where:tabla|Citas;order|Citas.h_inicio asc;no_results|1;%@
 <!-- @%db:Citas.id_pedido%@ @%db:Citas.h_fin_sys;%@ -->
 @%if:!esta_vacio;Citas.h_fin_sys;%@
 <tr class="resalte" >
 @%else:%@
 <tr>
 @%end-if:%@
<td>@%db:Clientes.id_cliente;%@</td>
<td><a href="?seccion=modif_cita&id_cita=@%db:Citas.id_cita%@">@%db:Clientes.razon_social;%@</a></td>
<td>@%db:Citas.h_inicio;%@</td>
<td>@%db:Citas.h_fin_sys%@ </td>
<td>@%db:Agentes.nombre;%@</td>
<td>
@%if:esta_vacio;Citas.id_pedido;%@
Aucun 
@%set:total_base_pedido=0%@
@%else:%@
@%where:tabla|Pedidos;group|Pedidos.id_pedido%@
<a href="?seccion=bo_pedido_cliente&id_pedido=@%db:Pedidos.id_pedido%@" >@%db:Pedidos.referencia%@</a>
<!-- @%db:SUM(Lineas_detalle.monto_total) as 'monto_total';%@
@%set:total_base_pedido=monto_total%@ -->
@%end-where:%@

@%end-if:%@
</td>
<td>@%get:total_base_pedido;%@</td>
</tr>
@%end-where:%@

</tbody></table>
</fieldset>


