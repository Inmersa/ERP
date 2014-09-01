@%where:nodb|nodb_order_data;%@

@%if:esta_vacio;id_proveedor;%@
<div class="barraoscurai">Sélections Actuel (@%db:referencia;%@) : &nbsp;&nbsp;
@%where:nodb|nodb_reciever_data;%@
@%db:razon_social%@ (ID: @%db:id%@)
@%end-where:%@

</div>
@%else:%@
<div class="barraoscurai">Sélections Actuel (@%db:referencia;%@) : &nbsp;&nbsp;
@%where:nodb|nodb_issuer_data;%@
@%db:razon_social%@ (ID: @%db:id%@)
@%end-where:%@

</div>
@%end-if:%@

<table class="full">
<tr>
<td></td>
<td class="caption">Article</td>
<td class="caption">Description</td>
@%if:esta_vacio;possible_contracts;%@
@%else:%@
<td class="caption">Service</td>
@%set:contratos_posibles=1;%@
@%end-if:%@
<td class="caption">Quantite</td>
<td class="caption">u/B</td>
<td class="caption">b/C</td>
<td class="caption">CP</td>
</tr>
@%where:nodb|nodb_order_details;%@

<tr><input type="hidden" name="array_detalle[@%db:id_articulo%@]" value="@%db:id_detalle%@" />
<td class="check"> 
<input type="checkbox" name="articulos_confirmados[@%db:idx_detalle;%@]" value="@%db:idx_detalle;%@" />
<input type="hidden" name="articulos_cesta[@%db:idx_detalle;%@]" value="@%db:idx_detalle;%@" checked /></td>
<td><a href="?seccion=modif_articulos&id_articulo=@%db:id_articulo;%@">@%db:nombre;%@</a></td>
<td>@%db:descripcion;%@</td>

@%if:esta_vacio;contratos_posibles;%@
@%else:%@
	<td>
	@%if:esta_vacio;available_contracts;%@
	@%else:%@
	    @%set:id_servicio=id_servicio;%@
	    @%where:nodb|nodb_detail_contracts;%@
		@%if:equals;id;id_servicio;%@
		@%db:nombre;%@ (@%db:duracion;%@ Jours)
		@%end-if:%@
	    @%end-where:%@

		</select>
	@%end-if:%@
	</td>
@%end-if:%@

<td>@%db:cantidad_pack;%@</td>

<td class="check" ><input type="checkbox" name="array_bultos[@%db:idx_detalle;%@][bultos]" value="1" 
@%if:esta_vacio;bultos;%@
@%else:%@
checked="checked"
@%end-if:%@
 />@%calc:unidades_bulto;round|2;output|1;%@</td>

<td class="check" ><input type="checkbox" name="array_bultos[@%db:idx_detalle;%@][capas]" value="1" 
 @%if:esta_vacio;capas;%@
 @%else:%@
 checked="checked"
 @%end-if:%@
/>@%db:bultos_capa_palet;%@</td>

<td class="check" ><input type="checkbox" name="array_bultos[@%db:idx_detalle;%@][palets]" value="1" 
 @%if:esta_vacio;palets;%@
 @%else:%@
 checked="checked"
 @%end-if:%@
/>@%db:capas_palet;%@</td>

</tr>
@%end-where:%@

</table>
