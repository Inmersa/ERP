
<fieldset id="FichaServicioCliente" class="fsficha" >
<legend>Fiche de Service de Client</legend>

<form name="nuevo" action="?seccion=cliente_servicios" method="post" >
<input type="hidden" name="accion_ejecutar" value="Modificar" />
<input type="hidden" name="clientes_recursos[id_cliente_recurso]" value="@%db:Clientes_recursos.id_cliente_recurso;%@" />
<input type="hidden" name="clientes_recursos[id_recurso]" value="@%db:Clientes_recursos.id_recurso;%@" />
<input type="hidden" name="clientes_recursos[id_articulo]" value="@%db:Clientes_recursos.id_articulo;%@" />
<input type="hidden" name="clientes_recursos[id_cliente]" value="@%db:Clientes_recursos.id_cliente;%@" />
<input type="hidden" name="clientes_recursos[id_empresa]" value="@%db:Clientes_recursos.id_empresa;%@" />
<input type="hidden" name="clientes_recursos[id_pedido]" value="@%db:Clientes_recursos.id_pedido;%@" />

<table class="full">
<thead>
<tr>
<td >Ressource</td>
<td >Article</td>
<td >Debut de periode</td>
<td >Derniére date</td>
<td >État de Service</td>
</tr>
</thead>

<tbody>
<tr>
<td>@%db:Recursos.nombre;%@ (@%db:Tipos_recurso.nombre;%@)</td>
<td>@%db:Articulos.nombre;%@</td>
<td><input type="text" name="clientes_recursos[fecha_inicio]" value="@%db:colocar_fecha{Clientes_recursos.fecha_inicio};%@" /></td>
<td><input type="text" name="clientes_recursos[fecha_fin]" value="@%db:colocar_fecha{Clientes_recursos.fecha_fin};%@" /></td>

<!-- @%set:_selected_value=Clientes_recursos.id_estado_servicio;%@ @%db:Clientes_recursos.id_estado_servicio;%@ -->
<td><select name="clientes_recursos[id_estado_servicio]" >
@%where:tabla|Estados_servicio;order|nombre;nolink|1;%@
<option value="@%db:Estados_servicio.id_estado_servicio;%@" 
@%db:selected_value{Estados_servicio.id_estado_servicio};%@
>@%db:Estados_servicio.nombre;%@</option>
@%end-where:%@

</select>
</td>
</tr>
<!-- @%set:id_recurso=Clientes_recursos.id_recurso;%@ -->
@%where:tabla|Articulos_recursos;where|Articulos_recursos.id_recurso = $id_recurso;nolink|0;%@
@%if:esta_vacio;Articulos_recursos.descripcion;%@
@%else:%@
<tr><td colspan="5" >@%db:reemplazar_salto{Articulos_recursos.descripcion};%@</td></tr>
@%end-if:%@

@%end-where:%@

<tr><td colspan="5"><textarea name="clientes_recursos[notas]" rows="5" cols="120" wrap="VIRTUAL">@%db:Clientes_recursos.notas;%@</textarea></td></tr>

</tbody>
</table>
</form>
</fieldset>

<div class="AccionesEnvio" >
<ul>
<li ><a href="#" onClick="return sendForm('nuevo');" class="guardar" ><img src="imag/pixel.png" class="icono" /><span>Garder</span></li>
</ul>
</div>
