@%where:nodb|nodb_order_data;nombre|detalles;format_name|classDocumentDetail;%@
<fieldset id="Pedido_Proveedor_Lineas" class="fsficha">
<legend>Détail</legend>

@%if:hay_factura%@

@%else:%@
<div class="AccionesFicha">
<ul>
<li><a href="?seccion=hacer_pedido_compra" class="editar"><img src="imag/pixel.png" class="icono" /><span>Modifier</span></a></li>
<li><a href="" onclick="return onHRefClick('pedido','accion_ejecutar','Borrar');" class="borrar" ><img src="imag/pixel.png" class="icono" /><span>Effacer(s)</span></a></li>
</ul>
</div>
@%end-if:%@

<table class="full">
<tr>
<td></td>
<td class="etiqueta">Code</td>
<td class="etiqueta">Quantite</td>
<td class="etiqueta">Prix</td>
<td class="etiqueta">TVA</td>
<td class="etiqueta">% Rem.</td>
<td class="etiqueta">Montant</td>
</tr>


@%set:caracteres_linea_observaciones=130;%@
@%where:nodb|nodb_order_details;contador|count;%@
 <!--
 @%set:num_detalles=count;%@
 @%db:medir_observaciones{observaciones}%@
 -->
 <!-- aqui empieza el registro -->

<tr>
<td class="check"><!-- este checkbox solo va si el pedido no esta consolidado (lo mismo pal enlace de añadir>-->
 <input type="checkbox" name="borrar_articulos[]" value="@%db:idx_detalle%@" /></td>
<td><a href="?seccion=modif_articulos&id_articulo=@%db:id_articulo;%@">@%db:nombre%@</a></td>

<td>@%db:cantidad;%@</td>

<td>@%db:precio;%@</td>

<td>@%db:porcentaje;%@</td>

<td>
@%if:!esta_vacio;tipo_descuento_fmt;%@
 @%db:tipo_descuento_fmt%@
@%else:%@
 @%db:tipo_descuento%@
@%end-if:%@
 </td>
<td>@%db:base_imponible;%@</td>
</tr>
@%if:esta_vacio;observaciones;id_servicio;%@
@%else:%@
<td colspan="6">@%db:observaciones%@</td>
<td>
 @%if:esta_vacio;id_servicio;%@
 @%else:%@
 <!-- @%set:ids=id_servicio;%@ -->
  @%where:nodb|nodb_detail_contracts;%@
   @%if:equals;ids;id;%@
	@%db:nombre;%@
   @%end-if:%@
  @%end-where:%@

 @%end-if:%@

</td></tr>
@%else:%@
@%end-if:%@
@%end-where:%@

 </table>
</fieldset>


