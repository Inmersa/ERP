<div class="barraoscura">
<div class="titsuperior">&gt; Nova Tarifa de Transporte</div></div> 

<form name="nuevo_tarifas" action="?seccion=bo_tarifas_transporte" method="post">
<input type="hidden" name="accion_ejecutar" value="Modificar">
<table class="full">
<td class="etiqueta">Nome:</td>
<td ><input type="text" name="registro[nombre]" class="insertext" size="55"></td>
</tr><tr>
<td class="etiqueta" >Transportador :</td>
<td width="428"><select name="registro[id_transportista]" class="insertext" >
      @%where:tabla|Transportistas;nolink|1;%@
      <option value="@%db:Transportistas.id_transportista;%@">@%db:Transportistas.nombre;%@</option>
      @%end-where:%@

</select></td>
</tr>

<tr><td class="etiqueta" >Peso Inicial:</td>
<td ><input type="text" name="registro[peso_inicial]" class="insertext" size="11"></td>
</tr><tr> 
<td class="etiqueta" >Peso Final:</td>
<td ><input type="text" name="registro[peso_final]" class="insertext" size="11"></td>
</tr><tr> 
<td class="etiqueta">Montante:</td>
<td ><input type="text" name="registro[costo]" class="insertext" size="11"></td>
</tr><tr> 
<td class="etiqueta">Custo Unidade:</td>
<td ><input type="checkbox" name="registro[costo_unidad]" class="insertext" value="1"></td>
</tr>
</table>
</form>
<div class="enviar"><a href="javascript:document.forms['nuevo_tarifas'].submit();" class="accesos">Guardar</a></div>
