
<div class="barraoscura">
<div class="titsuperior">&gt; New discount family</div><div class="alinder">
</div></div> 

 <form name="nuevo_descuento_familia" action="?seccion=bo_descuento_familia" method="post">
<input type="hidden" name="registro[]" value="NULL" />
<input type="hidden" name="estado" value="1" />

<table class="full">
<tr><td class="etiqueta">Products Family:</td>
<td><select name="registro[id_familia]">
@%where:tabla|Familia_articulos;nolink|1;order|Familia_articulos.nombre asc;%@
<option value="@%db:Familia_articulos.id_familia;%@">
@%db:Familia_articulos.nombre;%@
</option>
@%end-where:%@

</select></td>
</tr>
<tr>
<td class="etiqueta">Discounts:</td>
<td><input type="text" name="registro[descuento]" size="6" /> %</td>
</tr>

</form>
</table>
<div class="enviar"><a href="javascript:document.forms['nuevo_descuento_familia'].submit();">Save</a></div>

