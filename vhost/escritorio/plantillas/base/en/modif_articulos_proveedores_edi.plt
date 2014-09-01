<fieldset class="fsficha">
<legend>Suppliers</legend>


<div class="AccionesFicha"><ul>
<li><a href="?seccion=seleccionar_proveedor" class="seleccionar" ><img src="images/pixel.png" class="icono" /><span>Select Supplier</span></a></li> 
<li><a href="#" onClick="return onHRefClick('modif_articulos','accion_ejecutar','Borrar');" class="borrar" ><img src="images/pixel.png" class="icono" /><span>Delete selected</span></a></li>
</ul></div>
</fieldset>

<!-- @%set:_store_id_reset=1;%@ -->

@%where:tabla|Compra_articulos;nolink|1;where|Compra_articulos.id_articulo = $id_articulo_promocion AND Compra_articulos.fecha_baja IS NULL ;%@
<!-- @%db:Compra_articulos.fabricante;%@ @%func:store_id;Proveedores.id_proveedor;%@ -->
<fieldset class="fsficha" >
<legend ><input type="checkbox" name="borrar_proveedor[@%db:Proveedores.id_proveedor;%@]" value="1" 
/><a href="?seccion=modif_proveedores&id_proveedor=@%db:Proveedores.id_proveedor;%@">@%db:Proveedores.nombre;%@</a></legend>


<table class="full"><tbody>

<tr>
<td class="etiqueta" >Reference</td>
<td><input type="text" name="registro4[@%db:Proveedores.id_proveedor;%@][referencia]" value="@%db:Compra_articulos.referencia;%@" class="texto" /></td>
<td class="etiqueta" colspan="3" >Manuf.</td>
<td class="check"><input type="checkbox" name="registro4[@%db:Proveedores.id_proveedor;%@][fabricante]" value="1" @%db:check_flag{Compra_articulos.fabricante}%@ /></td>
</tr>

<tr>
<td class="etiqueta" >Price</td>
<td><input type="text" name="registro4[@%db:Proveedores.id_proveedor;%@][precio]" value="@%db:Compra_articulos.precio;%@" class="importe" /></td>
<td class="etiqueta" >Res. Official Price</td>
<td><input type="text" name="registro4[@%db:Proveedores.id_proveedor;%@][PV_oficial]" value="@%db:Compra_articulos.PV_oficial;%@" class="importe" /></td>
<td class="etiqueta" >Public. Official Price</td>
<td><input type="text" name="registro4[@%db:Proveedores.id_proveedor;%@][PVP_oficial]" value="@%db:Compra_articulos.PVP_oficial;%@" class="importe" /></td>
</tr>

<tr>
<td class="etiqueta" >Discounts</td>
<td><input type="text" name="registro4[@%db:Proveedores.id_proveedor;%@][descuento]" value="@%db:Compra_articulos.descuento;%@" class="descuento" /></td>
<td class="etiqueta" >Volume discount</td>
<td colspan="3" ><input type="text" name="registro4[@%db:Proveedores.id_proveedor;%@][dto_vol]" value="@%db:Compra_articulos.dto_vol;%@" class="descuento" />% 
X<input type="text" name="registro4[@%db:Proveedores.id_proveedor;%@][dto_vol_bultos]" value="@%db:Compra_articulos.dto_vol_bultos;%@" class="descuento" 
/>Pkgs</td>
</tr>
</table>

<table class="full">
<caption>Services</caption>

<tr>
<td class="etiqueta">Service</td>
<!-- @%set:_selected_value=Compra_articulos.id_servicio;%@ @%db:Compra_articulos.id_servicio;%@ -->
<td><select name="registro4[@%db:Proveedores.id_proveedor;%@][id_servicio]" class="insertext">
<option value="null">None</option>
@%where:tabla|Servicios;nolink|1;%@
<option value="@%db:Servicios.id_servicio;%@"
@%db:selected_value{Servicios.id_servicio};%@
>@%db:Servicios.nombre;%@</option>
@%end-where:%@

</select></td>

<td class="etiqueta">Entry amount</td>
<td><input type="text" name="registro4[@%db:Proveedores.id_proveedor;%@][cuota_alta]" class="importe" value="@%db:Compra_articulos.cuota_alta;%@" /></td>

</tr><tr>
<td class="etiqueta">Per unit</td>
<td style="text-align:center;width:60px" nowrap="nowrap"><input type="radio" name="registro4[@%db:Proveedores.id_proveedor;%@][_duracion_precio]" value="0" 
@%if:esta_vacio;Compra_articulos.servicios_duracion_precio;%@
checked="checked"
@%end-if:%@
 />
<input type="radio" name="registro4[@%db:Proveedores.id_proveedor;%@][_duracion_precio]" value="1" 
@%if:esta_vacio;Compra_articulos.servicios_duracion_precio;%@
@%else:%@
checked="checked"
@%end-if:%@
 /></td>
 <td class="etiqueta" colspan="2" style="text-align:left;">Prices for a period of</td>
<td class="etiqueta">Days</td>
<td><input type="text" name="registro4[@%db:Proveedores.id_proveedor;%@][servicios_duracion_precio]" class="minitext"
value="@%db:Compra_articulos.servicios_duracion_precio;%@" /></td>
</tr>
<tr>
<td class="etiqueta">Invoicing service in advance</td>
<td class="check"><input type="checkbox" name="registro4[@%db:Proveedores.id_proveedor;%@][servicios_poradelantado]" class="insertext" value="1"
@%db:check_flag{Compra_articulos.servicios_poradelantado};%@
 /></td></tr>
</tbody></table>

<table class="full">
<caption>{{frame_distribucion}}</caption>
<tbody>
<tr>
<td class="etiqueta" >{{fld_ptovida_compra}}</td>
<td ><input type="text" class="pto" name="registro4[@%db:Proveedores.id_proveedor;%@][pto_vida_compra]" value="@%db:Compra_articulos.pto_vida_compra;%@" /></td>
</tr></tbody></table>

</fieldset>
@%end-where:%@

