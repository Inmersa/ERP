
<fieldset class="fsficha">
<legend>Adreces de entrega</legend>
<div class="AccionesFicha">
<ul>
@%if:AllowedLink;nuevo_direcciones_entrega;%@
	@%if:AllowedAction;Direcciones_entrega;new;%@
	<li><a href="?seccion=nuevo_direcciones_entrega&amp;id_cliente=@%get:id_cliente_promocion%@" class="nuevo" 
		><img src="images/pixel.png" class="icono" /><span>Afegir direcci�</span></a></li>
	@%end-if:%@
@%end-if:%@
@%if:AllowedAction;Direcciones_entrega;del;%@
<li><a href="#" onClick="return onHRefClick('modif_clientes','accion_ejecutar','Borrar');" class="borrar" 
	><img src="images/pixel.png" class="icono" /><span>Esborrar</span></a></li>
@%end-if:%@
</ul>
</div>

<table class="full">
@%where:tabla|Direcciones_entrega;where|Direcciones_entrega.id_cliente= $id_cliente_promocion;order|Direcciones_entrega.nombre,Direcciones_entrega.direccion;%@
<tr>
@%if:AllowedAction;Direcciones_entrega;del;%@
<td class="check"><input type="checkbox" name="borrar_direcciones[@%db:Direcciones_entrega.id_direccion%@]" value="1"></td>
@%end-if:%@
<td>
@%if:AllowedLink;modif_direcciones_entrega;%@ 
	@%if:AllowedAction;Direcciones_entrega;edit;%@
	<a href="?seccion=modif_direcciones_entrega&amp;id_direccion=@%db:Direcciones_entrega.id_direccion%@" 
		>@%db:Direcciones_entrega.nombre%@ @%db:Direcciones_entrega.direccion%@ - @%db:Direcciones_entrega.poblacion;%@</a>
	@%else:%@
	@%db:Direcciones_entrega.nombre%@ @%db:Direcciones_entrega.direccion%@ - @%db:Direcciones_entrega.poblacion;%@
	@%end-if:%@
@%else:%@
@%db:Direcciones_entrega.nombre%@ @%db:Direcciones_entrega.direccion%@ - @%db:Direcciones_entrega.poblacion;%@
@%end-if:%@
</td></tr>
@%end-where:%@

</table>
</fieldset>

