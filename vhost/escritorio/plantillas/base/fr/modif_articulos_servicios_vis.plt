<fieldset class="fsficha">
<legend>Services</legend>

@%where:tabla|Empresas_articulos;where|Empresas_articulos.id_empresa = $id_empresa AND Empresas_articulos.id_articulo = $id_articulo;%@
<table class="full">
<tr>

@%if:esta_vacio;Empresas_articulos.servicios_duracion_precio;%@
<td class="etiqueta">Pour unit�</td>
@%else:%@
<td class="etiqueta">Jours</td>
<td>@%db:Empresas_articulos.servicios_duracion_precio;%@</td>
@%end-if:%@
</tr>
</table>

<table class="full">
<thead>
<tr> 
<td >Nom</td>
<td >Ch�que de cr�ation</td>
<td >Dur�</td>
<td >D�lai de facture</td>
<td >Facturant le service � l'avance</td>
</tr>
</thead>
<tbody>
@%where:tabla|Servicios;where|Servicios.id_servicio != 0 AND Empresas_servicios.id_empresa = $id_empresa AND Empresas_servicios.id_articulo = $id_articulo_promocion;nolink|1;%@
<!-- @%db:Empresas_servicios.id_servicio%@ -->
<tr> 
<td>
@%if:AllowedLink;modif_servicios;%@
<a href="?seccion=modif_servicios&id_servicio=@%db:Servicios.id_servicio;%@">@%db:Servicios.nombre;%@</a>
@%else:%@
@%db:Servicios.nombre;%@
@%end-if:%@
</td>
<td>@%db:Empresas_servicios.cuota_alta;%@</td>
<td>@%db:Servicios.duracion;%@ Jours</td>
<td>@%db:Servicios.plazo_factura;%@ Jours</td>
<td class="check">@%db:si_no_flag{Empresas_servicios.servicios_poradelantado};%@</td>
</tr>
 @%end-where:%@

</tbody>
</table>
@%end-where:%@

</fieldset>

