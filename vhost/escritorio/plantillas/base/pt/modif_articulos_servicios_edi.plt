<fieldset class="fsficha">
<legend>Serviços</legend>

<div class="AccionesFicha"><ul>
@%if:AllowedLink;seleccionar_servicio;%@
	@%if:AllowedAction;Empresas_servicios;new;%@
	<li><a href="?seccion=seleccionar_servicio" class="nuevo" ><img src="imag/pixel.png" class="icono" /><span>Adicionar</span></a></li> 
	@%end-if:%@
@%end-if:%@
@%if:AllowedAction;Empresas_servicios;del;%@
<li><a href="#" onClick="return onHRefClick('modif_articulos','accion_ejecutar','Borrar_servicios');" class="borrar" ><img src="imag/pixel.png" class="icono" /><span>Eliminar</span></a></li>
@%set:permitir_selecciones=1;%@
@%end-if:%@
</ul></div>

@%where:tabla|Empresas_articulos;where|Empresas_articulos.id_empresa = $id_empresa AND Empresas_articulos.id_articulo = $id_articulo;%@
<table class="full">
<tr>
<td class="etiqueta">Preço por Unidade</td>
<td style="text-align:center;width:60px;">
<input type="radio" name="registro2[_duracion_precio]" 
value="0" 
@%if:esta_vacio;Empresas_articulos.servicios_duracion_precio;%@
checked="checked"
@%end-if:%@
 /><input type="radio" name="registro2[_duracion_precio]" 
value="1" 
@%if:esta_vacio;Empresas_articulos.servicios_duracion_precio;%@
@%else:%@
checked="checked"
@%end-if:%@
 /></td><td class="etiqueta" style="text-align:left;">Preço por Tempo de Execução</td>
<td class="etiqueta">Dias</td>
<td><input type="text" name="registro2[servicios_duracion_precio]" size="3" maxlength="3" value="@%db:Empresas_articulos.servicios_duracion_precio;%@" /></td>
</tr>
</table>

<table class="full">
<thead>
<tr> 
<td class="estado" ><img src="imag/pixel.png" class="marcartodos" onclick="return formCheckAll('registro_servicios');"  /></td>
<td >Nome</td>
<td >Taxa de Subscrição</td>
<td >Duração</td>
<td >Prazo da Factura</td>
<td >Pré-facturação</td>
</tr>
</thead>
<tbody>
@%where:tabla|Servicios;where|Servicios.id_servicio != 0 AND Empresas_servicios.id_empresa = $id_empresa AND Empresas_servicios.id_articulo = $id_articulo_promocion;nolink|1;%@
<!-- @%db:Empresas_servicios.id_servicio%@ -->
<tr> 
@%if:esta_vacio;permitir_selecciones;%@
<td ></td>
@%else:%@
<td class="check"><input type="checkbox" name="registro_servicios[@%db:Servicios.id_servicio;%@][id]" value="@%db:Servicios.id_servicio;%@" /></td>
@%end-if:%@
<td>
@%if:AllowedLink;modif_servicios;%@
<a href="?seccion=modif_servicios&id_servicio=@%db:Servicios.id_servicio;%@">@%db:Servicios.nombre;%@</a>
@%else:%@
@%db:Servicios.nombre;%@
@%end-if:%@
</td>
<td><input type="text" name="registro_servicios[@%db:Servicios.id_servicio;%@][cuota]" value="@%db:Empresas_servicios.cuota_alta;%@" size="12" /></td>
<td>@%db:Servicios.duracion;%@ Dias</td>
<td>@%db:Servicios.plazo_factura;%@ Dias</td>
<td class="check">
<input type="checkbox" name="registro_servicios[@%db:Servicios.id_servicio;%@][servicios_poradelantado]" value="1" 
@%db:check_flag{Empresas_servicios.servicios_poradelantado};%@ /></td>
</tr>
 @%end-where:%@

</tbody>
</table>
@%end-where:%@

</fieldset>

