
<fieldset id="Pedido_Cliente_Lineas" class="fsficha">
<legend>Détail</legend>

@%if:nomodificar_detalles;%@
@%else:%@
<div class="AccionesFicha">
	<ul>
	@%if:AllowedLink;hacer_pedido;%@
		@%if:AllowedAction;Presupuestos;edit;%@
		<li><a href="?seccion=hacer_pedido" class="editar" ><img src="imag/pixel.png" class="icono" /><span>Modifier</span></a> 
		@%end-if:%@
	@%end-if:%@
	@%if:AllowedAction;Lineas_detalle_presupuesto;del;%@
	<li><a href="#" onclick="return onHRefClick('pedido','accion_ejecutar','Borrar');" class="borrar" ><img src="imag/pixel.png" 
		class="icono" /><span>Effacer(s)</span></a>
	@%set:permitir_selecciones=1;%@
	@%end-if:%@
	</ul>
</div>
@%end-if:%@

@%where:nodb|nodb_order_data;nombre|detalles;format_name|classDocumentDetail;%@
<table class="full">
<thead>
<tr>
<td></td>
<td >Code</td>
<td >Quantite</td>
<td >Prix</td>
<td >TVA</td>
<td >% Rem.</td>
<td >Montant</td>
</tr>
</thead>

<tbody>
@%set:caracteres_linea_observaciones=130;%@
@%where:nodb|nodb_order_details;contador|count;%@ 

<!-- @%set:num_detalles=count;%@ -->
<!-- @%db:medir_observaciones{observaciones}%@ -->

<!-- aqui empieza el registro -->

<tr>
<td class="check">
@%if:esta_vacio;permitir_selecciones;%@
@%else:%@
<!-- este checkbox solo va si el pedido no esta consolidado (lo mismo pal enlace de añadir>-->
 <input type="checkbox" name="borrar_articulos[]" value="@%db:idx_detalle%@" />
@%end-if:%@
</td>
<td>
@%if:AllowedLink;modif_articulos;%@
<a href="?seccion=modif_articulos&id_articulo=@%db:id_articulo;%@">@%db:nombre%@</a>
@%else:%@
@%db:nombre%@
@%end-if:%@
</td>
<td>@%db:cantidad;%@</td>
<td>@%db:precio;%@
@%if:!esta_vacio;leyenda_unidad_medida;%@
/ @%db:leyenda_unidad_medida;%@
@%end-if:%@
</td>
<td>@%db:porcentaje;%@</td>
<td>@%db:tipo_descuento%@</td>
<td>@%db:base_imponible;%@ </td>
</tr>
@%if:esta_vacio;observaciones;id_servicio;%@
@%else:%@

<td colspan="3">@%db:observaciones%@</td>
 <td colspan="4">
 @%if:esta_vacio;id_servicio;%@
 @%else:%@
    <!-- @%set:ids=id_servicio;%@ -->
    @%where:nodb|nodb_detail_contracts;%@
    	@%if:equals;ids;id;%@
	@%db:nombre;%@
	@%end-if:%@
    @%end-where:%@

 @%end-if:%@
 </td>
 </tr>
@%else:%@
@%end-if:%@

<!-- aqui termina el registro -->
@%end-where:%@

</tbody>
</table>

</fieldset>

@%end-where:%@

