
@%if:AllowedLink;nuevo_promociones;%@
<div id="AccionesEncabezado"><ul>
<li><a href="?seccion=nuevo_promociones" class="nuevo" ><img src="images/pixel.png" class="icono" /><span>Add</span></a></li>
</ul></div> 
@%end-if:%@

<form name="modif_promociones" action="?seccion=modif_promociones" method="post">
<input type="hidden" name="accion_ejecutar" value="0" />
@%where:tabla|Promociones;where|Promociones.id_articulo = $id_articulo_promocion AND Promociones.id_empresa = $id_empresa;%@
<input type="hidden" name="registro[@%db:Promociones.id_promocion%@][id_promocion]" value="@%db:Promociones.id_promocion;%@" />
<input type="hidden" name="registro[@%db:Promociones.id_promocion%@][id_unidad_medida]" value="@%db:Articulos.id_unidad_medida;%@" />
<fieldset id="Promocion_@%db:Promociones.id_promocion;%@" class="fsficha" >
<legend>Promotion</legend>

<table class="full">
<thead>
<tr>
<td >Delete</td>
<td >Name Promotion</td>
<td >Actual stock</td>
<td >Starting date</td>
<td >Last date</td>
<td >Amount</td>
</tr>
</thead>
<tbody>
<tr>
<td class="check"><input type="checkbox" name="registro_borrar[]" value="@%db:Promociones.id_promocion;%@" /></td>
<td><input type="text" name="registro[@%db:Promociones.id_promocion%@][nombre]" value="@%db:Promociones.nombre;%@" /></td>
<td>@%func:cantidad_total%@</td>
<td><input type="text" name="registro[@%db:Promociones.id_promocion%@][fecha_inicio]" value="@%db:colocar_fecha{Promociones.fecha_inicio};%@" class="fechahora" /></td>
<td><input type="text" name="registro[@%db:Promociones.id_promocion%@][fecha_fin]" value="@%db:colocar_fecha{Promociones.fecha_fin};%@" class="fechahora" /></td>
<td><input type="text" name="registro[@%db:Promociones.id_promocion%@][cantidad]" value="@%db:Promociones.cantidad;%@" class="cantidad" /></td>
</tr>
</tbody>
</table>

<!--@%db:Promociones.id_promocion;%@-->
<!--@%db:Promociones.oferta%@-->
<table class="full">
<tbody>
<tr>
<td><input type="radio" name="registro[@%db:Promociones.id_promocion%@][oferta]" value="1" @%db:check_flag{Promociones.oferta};%@ /></td>
<td class="etiqueta">Offer</td>
<td class="etiqueta">Total amount:</td>
<td><input type="text" name="registro[@%db:Promociones.id_promocion%@][monto]" value="@%db:Promociones.monto;%@" size="6" /></td>
<td class="etiqueta">Discounts:</td>
<td> <input type="text" name="registro[@%db:Promociones.id_promocion%@][descuento]" value="@%db:Promociones.descuento;%@" size="6" /> %</td>
</tr>
<tr>
<td><input type="radio" name="registro[@%db:Promociones.id_promocion%@][oferta]" value="0" 
@%if:esta_vacio;Promociones.oferta;%@
checked="checked"
@%end-if:%@
/></td>
<td class="etiqueta">Promotion</td>
<td colspan="4"></td>
</tr>
</tbody>
</table>

<div class="AccionesFicha"><ul>
<li><a href="?seccion=bo_articulos_promocion&id_promocion=@%db:Promociones.id_promocion%@" class="nuevo" ><img src="images/pixel.png" class="icono" /><span>Add article</span></a></li>
<li><a href="#" onclick="return onHRefClick('modif_promociones','accion_ejecutar','Borrar_articulos');" class="borrar" ><img src="images/pixel.png" class="icono" /><span>Delete selected</span></a></li>
</ul></div>

<table class="full">
<caption class="titulotb">Promotion Products List</caption>
<tr>
<td></td>
<td class="caption">Name</td>
<td class="caption">Amount</td>
</tr>
 @%set:id_promocion=Promociones.id_promocion%@
@%where:tabla|Promociones_articulos;nolink|1;where|Promociones_articulos.id_promocion = $id_promocion;%@
<!-- @%db:Promociones_articulos.id_promocion%@ -->
<input type="hidden" name="registro_promocion[@%db:Promociones.id_promocion;%@][@%db:Promociones_articulos.id_articulo;%@][id_unidad_medida]" 
value="@%db:Articulos.id_unidad_medida;%@" />

<tr>
<td class="check"><input type="checkbox" name="reg[@%db:Promociones.id_promocion%@][]" value="@%db:Promociones_articulos.id_articulo%@" /></td>
<td class="etiqueta" ><a href="?seccion=modif_articulos&id_articulo=@%db:Articulos.id_articulo;%@">@%db:Articulos.nombre%@</a></td>
<td><input type="text" name="registro_promocion[@%db:Promociones.id_promocion%@][@%db:Promociones_articulos.id_articulo;%@][cantidad]" value="@%db:Promociones_articulos.cantidad;%@" size="6" /></td>
</tr>
@%end-where:%@

</table>
</fieldset>
@%end-where:%@

</form>
<div class="AccionesEnvio"><ul>
<li><a href="#" onclick="return onHRefClick('modif_promociones','accion_ejecutar','Modificar');" class="guardar" ><img src="images/pixel.png" class="icono" /><span>Modify</span></a></li>
<li><a href="#" onclick="return onHRefClick('modif_promociones','accion_ejecutar','Borrar');" class="borrar" ><img src="images/pixel.png" class="icono" /><span>Delete</span></a></li>
</ul></div>

