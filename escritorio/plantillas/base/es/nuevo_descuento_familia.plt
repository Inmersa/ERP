
<div class="barraoscura">
<div class="titsuperior">&gt; NUEVO DESCUENTO DE FAMILIA</div><div class="alinder">
</div></div> 

 <form name="nuevo_descuento_familia" action="?seccion=bo_descuento_familia" method="post">
<input type="hidden" name="registro[]" value="NULL" />
<input type="hidden" name="estado" value="1" />

<table class="full">
<tr><td class="etiqueta">Familia de art�culos:</td>
<td><select name="registro[id_familia]">
@%where:tabla|Familia_articulos;nolink|1;order|Familia_articulos.nombre asc;%@
<option value="@%db:Familia_articulos.id_familia;%@">
@%db:Familia_articulos.nombre;%@
</option>
@%end-where:%@

</select></td>
</tr>
<tr>
<td class="etiqueta">Descuento:</td>
<td><input type="text" name="registro[descuento]" size="6" /> %</td>
</tr>

</form>
</table>
<div class="enviar"><a href="javascript:document.forms['nuevo_descuento_familia'].submit();">Guardar</a></div>

