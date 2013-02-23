
<fieldset class="fsficha">
<legend>Agentes</legend>

@%where:tabla|Clientes;where|id_cliente= $id_cliente_promocion;%@
<!-- @%db:Clientes.id_cliente;%@ -->

@%if:primera_vez;%@
	<div class="barraoscura"><div class="alinder">
	@%if:AllowedLink;bo_cliente_agentes;%@
	<a href="?seccion=bo_cliente_agentes&amp;id_cliente=@%db:Clientes.id_cliente%@"
	>Añadir agente</a>
	<a href="#" onClick="return onHRefClick('modif_clientes','accion_ejecutar','Borrar');"
	>Borrar agente</a>
	@%end-if:%@
	</div></div>
@%end-if:%@

<table class="full">
<tr>
<td class="caption">Agente</td>
<td class="caption">Email</td>
<td class="caption">Teléfono 2</td>
</tr>
@%where:tabla|Agentes;order|Agentes.nombre;%@
<tr><td> 
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
<td><a href="mailto:@%db:Agentes.email;%@" >@%db:Agentes.email%@</a></td>
<td>@%db:Agentes.telefono2;%@</td>
</tr>
@%end-where:%@
 
</table>
@%end-where:%@

</fieldset>

 
