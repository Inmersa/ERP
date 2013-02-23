
<div class="tituloseccion">&gt; Nova article</div>

<form name="nuevo_articulo" action="?seccion=modif_articulos" method="post">

<fieldset class="fsficha">
<legend>Dades generals</legend>
<table class="full">
<tr><td class="etiqueta">Marca:</td>
<td> <select name="registro[id_marca]">
@%where:tabla|Marcas;nolink|1;order|nombre;%@
<option value="@%db:Marcas.id_marca;%@">@%db:Marcas.nombre;%@</option>
@%end-where:%@

</select></td></tr>
<tr><td class="etiqueta">Fam�lia:</td>
<td><select name="registro[id_familia]">
@%where:tabla|Familia_articulos;nolink|1;order|nombre;%@
 <option value="@%db:Familia_articulos.id_familia;%@">@%db:Familia_articulos.nombre;%@</option>
 @%end-where:%@

 </select></td>
<td class="etiqueta">IVA:</td>
<td><select name="registro[id_iva]">
@%where:tabla|Tipos_IVA;nolink|1;%@
 <option value="@%db:Tipos_IVA.id_iva;%@">@%db:Tipos_IVA.nombre;%@ @%db:Tipos_IVA.porcentaje;%@ %</option>
 @%end-where:%@

</select></td></tr></table>

<table class="full"><tr>
<td class="etiqueta">Nom</td>
<td><input type="text" name="registro[nombre]" size="25" /></td>
<td class="etiqueta">C�di de barres:</td>
<td><input type="text" name="registro[codigo_barras]" size="20" /></td>
</tr>
<tr>
<td class="etiqueta">Descripci�:</td>
<td colspan="3"><textarea name="registro[descripcion]" class="desc" ></textarea></td>
</tr>
<tr>
<td class="etiqueta">Observacions:</td>
<td colspan="3"><input type="text" name="registro[observaciones]" size="60" /></td>
</tr>
<tr>
<td class="etiqueta">Pes: </td>
<td><input type="text" name="registro[cantidad_medida]" size="8" />
 <select name="registro[id_unidad_medida]">
@%where:tabla|Unidades_medida;nolink|1;order|nombre;%@
 <option value="@%db:Unidades_medida.id_unidad_medida;%@">@%db:Unidades_medida.nombre;%@</option>
 @%end-where:%@

 </select></td>
<td class="etiqueta">Garantia:</td>
<td><input type="text" name="registro[garantia]" size="15" /></td>
</tr>
<tr>
<td class="etiqueta">Certificat:</td>
<td><select name="registro[id_certificado]">
@%where:tabla|Certificados;nolink|1;order|nombre;%@
 <option value="@%db:Certificados.id_certificado;%@">@%db:Certificados.nombre;%@</option>
 @%end-where:%@

 </select></td>
<td class="etiqueta">Pes de transport:</td>
<td><input type="text" name="registro[peso_unidad]" size="15" /></td>
</tr>
</table>
</fieldset>

<fieldset class="fsficha">
<legend>Preus</legend>

<table class="full">
<tr><td class="check" ><input type="checkbox" name="registro2[fabricacion_propia]" value="1" /></td>
<td class="etiquetacheck">Fabricaci� pr�pia</td>
<td class="check"><input type="checkbox" name="registro2[stock]" value="1" /></td>
<td class="etiquetacheck">Stock</td>
<td class="check"><input type="checkbox" name="registro2[frecuente]" value="1" /></td>
<td class="etiquetacheck">WEB / TPV</td>
</tr>
</table>

<table class="full">

<tr><td class="etiqueta">Ref.:</td>
<td colspan="3" ><input type="text" name="registro2[referencia]" class="texto" /></td>
</tr>

<tr><td class="etiqueta">Descripci�:</td>
<td colspan="3" ><textarea name="registro2[descripcion]" class="desc" ></textarea></td>
</tr>

<tr>
<td class="etiqueta">Stock M�nim:</td>
<td><input type="text" name="registro2[stock_minimo]" class="num" /></td>
<td class="etiqueta">Stock M�xim:</td>
<td><input type="text" name="registro2[stock_maximo]" class="num" /></td>
</tr>

<tr>
<td class="etiqueta" >Stock Estimat:</td>
<td ><input type="text" name="registro2[stock_ficticio]" class="num" /></td>
<td class="etiqueta">Unitat paquet:</td>
<td><input type="text" name="registro2[unidades_bulto]" class="mininum" /></td>
</tr>

<tr><td class="etiqueta">Preu 1:</td>
<td><input type="text" name="registro2[precio_costo]" class="importe" /></td>
<td class="etiqueta">Preu 2:</td>
<td><input type="text" name="registro2[precio_standard]" class="importe" /></td>
</tr>

<tr><td class="etiqueta">Preu 3:</td>
<td><input type="text" name="registro2[precio_venta]" class="importe" /></td>
<td class="etiqueta">Preu 4:</td>
<td ><input type="text" name="registro2[precio_4]" class="importe" /></td>
</tr>

<tr>
<td class="etiqueta">Preu 5:</td>
<td><input type="text" name="registro2[precio_5]" class="importe" /></td>
<td class="etiqueta">Preu 6:</td>
<td><input type="text" name="registro2[precio_6]" class="importe" /></td>
</tr>

</table>
</fieldset>

@%plt:ModulosActivos;%@

<input type="hidden" name="accion_ejecutar" value="Nuevo" />
</form>

<div class="AccionesEnvio"><ul>
<li><a href="#" onClick="return sendForm('nuevo_articulo');" class="nuevo" ><img src="images/pixel.png" class="icono" /><span>Guardar</span></a></li>
</ul></div>

