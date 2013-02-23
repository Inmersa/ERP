
<fieldset id="NuevoServicioCliente" class="fsficha" >
<legend>Novo Serviço de Cliente</legend>

<form name="nuevo" action="?seccion=cliente_servicios" method="post" >
<input type="hidden" name="accion_ejecutar" value="NuevoServicio" />
<table class="full">
<thead>
<tr>
<td ></td>
<td >Nome</td>
<td >Recurso</td>
<td >Data de Finalização</td>
<td >Estado de Serviço</td>
</tr>
</thead>

<tbody>
@%where:tabla|Articulos_recursos;where|$wr_lista_articulos;order|Articulos.nombre asc;contador|i;%@
<input type="hidden" name="clientes_recursos[@%db:i;%@][id_recurso]" value="@%db:Articulos_recursos.id_recurso;%@" />
<input type="hidden" name="clientes_recursos[@%db:i;%@][id_articulo]" value="@%db:Articulos_recursos.id_articulo;%@" />
<tr>
<td class="check" ><input type="checkbox" name="clientes_recursos[@%db:i;%@][insert]" value="1" checked="checked" /></td>
<td>@%db:Articulos.nombre;%@</td>
<td>@%db:Recursos.nombre;%@ (@%db:Tipos_recurso.nombre;%@)</td>
<td><input type="text" name="clientes_recursos[@%db:i;%@][fecha_fin]" value="" /></td>

<td><select name="clientes_recursos[@%db:i;%@][id_estado_servicio]" >
@%where:tabla|Estados_servicio;order|nombre;nolink|1;%@
<option value="@%db:Estados_servicio.id_estado_servicio;%@" 
>@%db:Estados_servicio.nombre;%@</option>
@%end-where:%@

</select>
</td>

</tr>
@%if:esta_vacio;Articulos_recursos.descripcion;%@
@%else:%@
<tr><td colspan="5" >@%db:reemplazar_salto{Articulos_recursos.descripcion};%@</td></tr>
@%end-if:%@

<tr><td colspan="5"><textarea name="clientes_recursos[@%db:i;%@][notas]" rows="5" cols="120" wrap="VIRTUAL"></textarea></td></tr>
@%end-where:%@

</tbody>
</table>
</form>
</fieldset>

<div class="AccionesEnvio" >
<ul>
<li ><a href="#" onClick="return sendForm('nuevo');" class="guardar" ><img src="imag/pixel.png" class="icono" /><span>Guardar</span></li>
</ul>
</div>
