<fieldset class="fsficha">
<legend>Informa��es Gerais</legend>


@%where:tabla|Almacenes;where|Almacenes.id_almacen = $id_almacen_promocion;%@
<input type="hidden" name="registro[mask]" value="@%db:Almacenes.mask%@" />
<input type="hidden" name="accion_ejecutar" value="prueba" />
<input type="hidden" name="registro[id_almacen]" value="@%db:Almacenes.id_almacen;%@" />
<!--@%db:Almacenes.id_almacen;%@-->
<table class="full">
<tr><td class="etiqueta">Nome:</td>
<td>@%db:Almacenes.nombre;%@</td>
<td class="etiqueta" >Distrito:</td>
<td ><!--@%db:Almacenes.id_provincia;%@ -->
 @%where:tabla|Provincias;%@
@%db:Provincias.nombre;%@
 @%end-where:%@

</td>
</tr>
<tr><td class="etiqueta"> Contacto:</td>
<td>@%db:Almacenes.persona_contacto;%@</td>
<td class="etiqueta" >Cargo do Contacto:</td>
<td >@%db:Almacenes.cargo_persona_contacto;%@</td>
</tr>

<tr>
<td class="etiqueta">Endere�o:</td>
<td>@%db:Almacenes.direccion;%@</td>
<td class="etiqueta">CP:</td>
<td>@%db:Almacenes.cp;%@</td>
</tr>

<tr>
<td class="etiqueta">Telefone:</td>
<td>@%db:Almacenes.telefono;%@</td>
<td class="etiqueta">Localidade:</td>
<td>@%db:Almacenes.poblacion;%@</td>
</tr>

</tr>
<td class="etiqueta">Fax:</td>
<td>@%db:Almacenes.fax;%@</td>
<td class="etiqueta">e-mail:</td>
<td>@%db:Almacenes.email;%@</td>
</tr>

<tr>
<td class="etiqueta" >Nota � parte inferior de G�ner�r</td>
<td colspan="4" >@%db:reemplazar_salto{Almacenes.nota_pie_albaran};%@</td>
</table>
@%end-where:%@

 
</fieldset>
