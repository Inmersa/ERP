@%where:tabla|Articulos;where|Articulos.id_articulo = $id_articulo_promocion;escape_html|1;%@
<input type="hidden" name="registro[mascara_modulo]" value="@%db:Articulos.mascara_modulo;%@" />
<fieldset class="fsficha">
<legend> @%db:Articulos.nombre;%@ (ID: @%db:Articulos.id_articulo;%@)</legend>
<input type="hidden" name="accion_ejecutar" value="0" />
<table class="full">
<tr><td class="etiqueta">Marca:</td>
 <!--@%db:Articulos.id_marca;%@ @%set:_selected_value=Articulos.id_marca%@-->
<td><select name="registro[id_marca]">
@%where:tabla|Marcas;nolink|1;order|nombre;%@
<option value="@%db:Marcas.id_marca;%@" 
@%db:selected_value{Marcas.id_marca}%@
>@%db:Marcas.nombre;s|0,23%@</option>
@%end-where:%@

</select></td>
<td class="etiqueta">Família:</td>
<td><!--@%db:Articulos.id_familia;%@ @%set:_selected_value=Articulos.id_familia%@ -->
 <select name="registro[id_familia]">
@%where:tabla|Familia_articulos;nolink|1;order|nombre;%@
 <option value="@%db:Familia_articulos.id_familia;%@" 
 @%db:selected_value{Familia_articulos.id_familia};%@
>@%db:Familia_articulos.nombre;s|0,23%@</option>
@%end-where:%@

 </select></td>
<td class="etiqueta">IVA:</td>
<td><!--@%db:Articulos.id_iva;%@ @%set:_selected_value=Articulos.id_iva%@-->
 <select name="registro[id_iva]">
@%where:tabla|Tipos_IVA;nolink|1;%@
 <option value="@%db:Tipos_IVA.id_iva;%@" 
 @%db:selected_value{Tipos_IVA.id_iva};%@
>@%db:Tipos_IVA.nombre;%@</option>
@%end-where:%@

 </select></td>
 </tr>
 </table>
 
<table class="full">
<tr><td class="etiqueta">Nom</td>
<td><input type="text" name="registro[nombre]" value="@%db:Articulos.nombre;%@" size="48" /></td>
<!-- 
@%db:Articulos.id_imagen;%@ 
@%set:id_img=Articulos.id_imagen%@
@%set:id_art=Articulos.id_articulo%@
@%set:sitiene_imagen=0;%@
-->
<td rowspan="7" class="tdimgarticulo">
@%where:db|db_catalogo;tabla|Catalogo_imagenes;%@
<a href="#" onClick="return CatalogoImagenesSoloUna('Articulos','id_articulo','@%get:id_art;%@','@%db:Catalogo_imagenes.id_imagen;%@');">
	<img src="/catalogo/@%db:Catalogo_imagenes.nombre%@" border="0" class="imgarticulo" /></a><br />
<input type="checkbox" name="registro[id_imagen]" value="@%db:Catalogo_imagenes.id_imagen%@" checked="checked" />
@%set:sitiene_imagen=1;%@
@%end-where:%@

@%if:esta_vacio;sitiene_imagen;%@
 <a href="#" onClick="return CatalogoImagenesSoloUna('Articulos','id_articulo','@%db:Articulos.id_articulo;%@');"
	>Imatge</a><br/>
@%end-if:%@

</td>
</tr>
<tr><td class="etiqueta">Descripció:</td>
<td><textarea name="registro[descripcion]" class="longdesc" >@%db:Articulos.descripcion;%@</textarea></td>
</tr>
<tr>
<td class="etiqueta">Observacions:</td>
<td><input type="text" name="registro[observaciones]" value="@%db:Articulos.observaciones;%@" size="35" /></td>
</tr>
<tr>
<td class="etiqueta">Códi de barres:</td>
<td><input type="text" name="registro[codigo_barras]" value="@%db:Articulos.codigo_barras;%@" size="20" /></td>
</tr>
<tr>
<td class="etiqueta">Garantia:</td>
<td><input type="text" name="registro[garantia]" value="@%db:Articulos.garantia;%@" size="15" /></td>
</tr>
<tr>
<td class="etiqueta">Certificats:</td>
<td><select name="registro[id_certificado]">
<!--@%db:Articulos.id_certificado;%@ @%set:_selected_value=Articulos.id_certificado;%@-->
@%where:tabla|Certificados;nolink|1;order|nombre;%@
<option value="@%db:Certificados.id_certificado;%@" 
@%db:selected_value{Certificados.id_certificado}%@
> @%db:Certificados.nombre;%@ </option>
@%end-where:%@

</select></td></tr>

<tr>
<td class="etiqueta">Unitat de mesura:</td>
<td><select name="registro[id_unidad_medida]">
 <!--@%db:Articulos.id_unidad_medida;%@ @%set:_selected_value=Articulos.id_unidad_medida;%@-->
@%where:tabla|Unidades_medida;nolink|1;order|nombre;%@
<option value="@%db:Unidades_medida.id_unidad_medida;%@" 
@%db:selected_value{Unidades_medida.id_unidad_medida}%@
> @%db:Unidades_medida.nombre;%@</option>
@%end-where:%@

</select></td></tr>

</table>
</fieldset>
