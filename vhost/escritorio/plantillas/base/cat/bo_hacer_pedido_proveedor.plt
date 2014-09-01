
<div class="tituloseccion">&gt; Selecci� Prove�dors</div>

@%plt:botonera%@

<form name="compra_articulos" method="post" action="?seccion=hacer_pedido_compra"><tr><td class="caption">
<input type="hidden" name="nuevo" value="1" />
<input type="hidden" name="pedido" value="@%get:es_pedido;%@" />
<input type="hidden" name="presupuesto" value="@%get:es_presupuesto;%@" />
<input type="hidden" name="factura" value="@%get:es_factura;%@" />
<input type="hidden" name="proforma" value="@%get:es_proforma;%@" />

<table class="full">
<thead><tr>
<td class="caption"><a href="?_search_sort=Proveedores.id_proveedor" class="order" 
	>Codi<img src="images/pixel.png" class="@%func:class_searchsort;Proveedores.id_proveedor;%@" /></a></td>
<td></td>
<td class="caption"><a href="?_search_sort=Proveedores.razon_social" class="order" 
	>Ra� social<img src="images/pixel.png" class="@%func:class_searchsort;Proveedores.razon_social;%@" /></a></td>
<td class="caption"><a href="?_search_sort=Proveedores.persona_contacto" class="order" 
	>Contacte<img src="images/pixel.png" class="@%func:class_searchsort;Proveedores.persona_contacto;%@" /></a></td>
<td class="caption"><a href="?_search_sort=Proveedores.cif" class="order" 
	>CIF<img src="images/pixel.png" class="@%func:class_searchsort;Proveedores.cif;%@" /></a></td>
</tr></thead>

<tbody>
@%where:tabla|Proveedores;nombre|busc;no_results|1;%@
<tr>
<td>@%db:Proveedores.id_proveedor;%@</td>
<td class="check"><input type="radio" name="id_proveedor" value="@%db:Proveedores.id_proveedor;%@" 
@%db:selected_value{Proveedores_empresas.crm_id_usuario};%@
/></td>
<td><a href="?seccion=modif_proveedores&id_proveedor=@%db:Proveedores.id_proveedor;%@">@%db:Proveedores.nombre;%@</a><br>
 @%db:Proveedores.razon_social;%@<br>
 @%db:Proveedores.domicilio;%@ - @%db:Proveedores.poblacion;%@</td>

<td>@%db:Proveedores.persona_contacto;%@<br>
 <a href="mailto:@%db:Proveedores.email;%@">@%db:Proveedores.email;%@</a><br>
 @%db:Proveedores.telefono1;%</td>
<td>@%db:Proveedores.prefijo_cif;%@ - @%db:Proveedores.cif;%@</td>
</tr>
@%end-where:%@

</tbody></table>
 
<input type="hidden" name="Continuar" value="Continuar" />
</form>

@%plt:botonera%@

<div class="AccionesEnvio"><ul>
<li><a href="#" onclick="return sendForm('compra_articulos');" class="seleccionar" ><img src="images/pixel.png" class="icono" /><span>Seleccionar</span></a></li>
</ul></div>

