 @%where:nodb|nodb_order_data;contador|count;%@ 
<fieldset id="Pedido_Cliente_Lineas" class="fsficha">
<legend>Détail</legend>

<div class="AccionesFicha" ><ul>
@%if:esta_vacio;id_proveedor;%@
<li><a href="?seccion=hacer_pedido" class="editar" ><img src="imag/pixel.png" class="icono" /><span>Ajouter article</span></a></li>
@%else:%@
<li><a href="?seccion=hacer_pedido_compra" class="editar" ><img src="imag/pixel.png" class="icono" /><span>Ajouter article</span></a></li>
@%end-if:%@
</ul></div>

<table class="full">
<tr>
<td></td>
<td class="caption">Code</td>
<td class="caption">Quantite</td>
<td class="caption">Prix</td>
<td class="caption">TVA</td>
<td class="caption">% Rem.</td>
<td class="caption">Montant</td>
 </tr>
@%where:nodb|nodb_order_details;contador|count;format_name|classDocumentDetail;%@ 
<!-- aqui empieza el registro -->
<tr><td class="check"><input type="checkbox" name="articulos_confirmados[@%db:idx_detalle;%@]" value="1" checked></td>
<td><a href="?seccion=modif_articulos&id_articulo=@%db:id_articulo;%@">@%db:nombre%@</a></td>
<td>@%db:cantidad;%@</td>
<td><input type="text" value="@%db:precio%@" class="importe" name="articulos[precio][@%db:idx_detalle;%@]" /> 
@%if:!esta_vacio;leyenda_unidad_medida;%@
/ @%db:leyenda_unidad_medida;%@
@%end-if:%@
 <input type="hidden" value="@%db:precio%@" name="articulos_old[precio][@%db:idx_detalle;%@]" />
</td>
<td>@%db:porcentaje;%@</td>
<td>
@%if:!esta_vacio;tipo_descuento_fmt;%@
 @%db:tipo_descuento_fmt%@
@%else:%@
 @%db:tipo_descuento%@
@%end-if:%@
</td>
<td>@%db:base_imponible;%@ </td>
</tr>
<td 
@%if:esta_vacio;available_contracts;%@
colspan="7"
@%else:%@
colspan="4"
@%end-if:%@
><input type="text" name="observaciones[@%db:idx_detalle;%@]" class="insertext" size="85" value="@%db:observaciones%@"></td>
@%if:esta_vacio;available_contracts;%@
@%else:%@
 <td colspan="3">

@%if:esta_vacio;id_servicio;%@
@%else:%@
@%set:_selected_value=id_servicio;%@
@%end-if:%@

@%set:id_articulo=id_articulo;%@
<select name="servicios[@%db:idx_detalle;%@]">
<option value="0">Aucun</option>
	@%where:tabla|Empresas_servicios;nolink|1;where|id_articulo = $id_articulo AND id_empresa = $id_empresa;%@
	<option value="@%db:Servicios.id_servicio;%@"
	@%db:selected_value{Servicios.id_servicio}%@
	>@%db:Servicios.nombre;%@</option>
	 @%end-where:%@

	</select>

 @%end-if:%@
 </td>
 </tr>
@%else:%@
@%end-if:%@

<!-- aqui termina el registro -->
@%end-where:%@

</table>
</fieldset>
