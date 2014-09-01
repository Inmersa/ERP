@%where:tabla|Articulos;where|Articulos.id_articulo = $id_articulo_promocion;escape_html|1;%@
<!-- 
@%db:Articulos.id_marca;%@ @%db:Articulos.id_familia;%@ @%db:Articulos.id_iva;%@ @%db:Articulos.id_imagen;%@ 
@%db:Articulos.id_certificado;%@ @%db:Articulos.id_unidad_medida;%@ 
-->
<fieldset class="fsficha">
<legend> ID (ID: @%db:Articulos.id_articulo;%@)</legend>
<input type="hidden" name="accion_ejecutar" value="0" />
<table class="full">
<tr><td class="etiqueta">Marca:</td>
<td>
@%where:tabla|Marcas;%@
@%db:Marcas.nombre;%@
@%end-where:%@

</td>
<td class="etiqueta">Família:</td>
<td>
@%where:tabla|Familia_articulos;%@
@%db:Familia_articulos.nombre;%@
@%end-where:%@

 </td>
<td class="etiqueta">IVA:</td>
<td>
@%where:tabla|Tipos_IVA;%@
@%db:Tipos_IVA.nombre;%@
@%end-where:%@

 </td>
 </tr>
 </table>
 
<table class="full">
<tr><td class="etiqueta">Nom</td>
<td>@%db:Articulos.nombre;%@</td>
<!-- 
@%set:id_img=Articulos.id_imagen%@
@%set:id_art=Articulos.id_articulo%@
-->
<td rowspan="7" class="tdimgarticulo">
@%if:esta_vacio;Articulos.id_imagen;%@
<br/>
@%else:%@
@%where:db|db_catalogo;tabla|Catalogo_imagenes;where|id_imagen = $id_img;nolink|1;%@
<img src="/catalogo/@%db:Catalogo_imagenes.nombre%@" border="0" class="imgarticulo" />
<input type="hidden" name="registro[id_imagen]" value="@%db:Catalogo_imagenes.id_imagen%@" />
@%end-where:%@

@%end-if:%@

</td>
</tr>
<tr><td class="etiqueta">Descripció:</td>
<td>@%db:Articulos.descripcion;%@</td>
</tr>
<tr>
<td class="etiqueta">Observacions:</td>
<td>@%db:Articulos.observaciones;%@</td>
</tr>
<tr>
<td class="etiqueta">Códi de barres:</td>
<td>@%db:Articulos.codigo_barras;%@</td>
</tr>
<tr>
<td class="etiqueta">Garantia:</td>
<td>@%db:Articulos.garantia;%@</td>
</tr>
<tr>
<td class="etiqueta">Certificats:</td>
<td>
@%where:tabla|Certificados;%@
@%db:Certificados.nombre;%@ 
@%end-where:%@

</td>
</tr>
<tr>
<td class="etiqueta">Unitat de mesura:</td>
<td>
@%where:tabla|Unidades_medida;%@
@%db:Unidades_medida.nombre;%@
@%end-where:%@

</td>
</tr>
</table>
</fieldset>
