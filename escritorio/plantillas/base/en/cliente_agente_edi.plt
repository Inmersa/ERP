
<fieldset class="fsficha">
<legend>Agents</legend>

@%where:tabla|Clientes;nombre|ElsClients;where|id_cliente= $id_cliente_promocion;%@
<!-- @%db:Clientes.id_cliente;%@ -->

@%if:primera_vez;%@
<div class="AccionesFicha"><ul>
@%if:AllowedLink;bo_cliente_agentes;%@
	@%if:AllowedAction;Agentes_clientes;new;%@
	<li><a href="?seccion=bo_cliente_agentes&amp;id_cliente=@%db:Clientes.id_cliente%@"  class="seleccionar" 
		><img src="images/pixel.png" class="icono" /><span>Add agent</span></a></li>
	@%end-if:%@
@%end-if:%@
@%if:AllowedAction;Agentes_clientes;del;%@
<li><a href="#" onClick="return onHRefClick('modif_clientes','accion_ejecutar','Borrar');"  class="borrar" 
	><img src="images/pixel.png" class="icono" /><span>Delete agent</span></a></li>
@%end-if:%@
</ul></div>
@%end-if:%@


<table class="full">
<tr>
<td class="caption">Agent</td>
<td class="caption">Recruitment date</td>
<td class="caption">Commission</td>
<td class="caption">Shared Commission</td>
</tr>
@%where:tabla|Agentes;nombre|LosAgentes;order|Agentes.nombre;%@
<tr><td> <input type="checkbox" name="borrar_agentes[@%db:Agentes.id_agente%@]" value="1">
@%if:AllowedLink;modif_agentes;%@
	@%if:AllowedAction;Agentes_clientes;edit;%@
	<a href="?seccion=modif_agentes&amp;id_agente=@%db:Agentes.id_agente%@" class="accesos">@%db:Agentes.nombre%@ @%db:Agentes.apellidos%@</a>
	@%else:%@ 
	@%db:Agentes.nombre%@ @%db:Agentes.apellidos%@ 
	@%end-if:%@
@%else:%@ 
@%db:Agentes.nombre%@ @%db:Agentes.apellidos%@ 
@%end-if:%@
</td>
<td>@%db:colocar_fecha{Agentes_clientes.fecha_captacion};%@</td>
<td><input type="text" value="@%db:Agentes_clientes.comision%@" name="Agentes[@%db:Agentes_clientes.id_agente;%@][comision]" class="insertext" size="6" /> %</td>
<td><input type="text" value="@%db:Agentes_clientes.comision_repartida%@" name="Agentes[@%db:Agentes_clientes.id_agente;%@][comision_repartida]" class="insertext" size="6"/> %</td>
</tr>
@%end-where:%@
 
</table>
@%end-where:%@

</fieldset>

 
