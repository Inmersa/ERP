<div class="barraoscura">
<div class="titsuperior">&gt; Modificar Tarifa de Transport</div><div class="alinder">
 @%if:AllowedLink;nuevo_tarifas_transporte;%@
 <a href="?seccion=nuevo_tarifas_transporte">Nou</a>
 @%end-if:%@
 </div></div>

<form name="nuevo_tarifas" action="?seccion=bo_tarifas_transporte" method="post">
<input type="hidden" name="accion_ejecutar" value="Modificar">
<input type="hidden" name="registro[id_tarifa_transporte]" value="@%db:Tarifas_transporte.id_tarifa_transporte;%@">
<table class="full">
<tr>
<td class="etiqueta" >Nom:</td>
<td ><input type="text" name="registro[nombre]" class="insertext" size="55" value="@%db:Tarifas_transporte.nombre;%@"></td>
</tr><tr> 
<td class="etiqueta" >Transportistes :</td>
<td ><select name="registro[id_transportista]" class="insertext" >
	      <!-- @%set:_selected_value=Tarifas_transporte.id_transportista;%@ @%db:Tarifas_transporte.id_transportista;%@ -->
	      @%where:tabla|Transportistas;nolink|1;%@
	      <option value="@%db:Transportistas.id_transportista;%@"
	      @%db:selected_value{Transportistas.id_transportista};%@
	      >@%db:Transportistas.nombre;%@</option>
	      @%end-where:%@

</select></td>
</tr><tr> 
<td class="etiqueta" >Pes inicial:</td>
<td ><input type="text" name="registro[peso_inicial]" class="insertext" size="11" value="@%db:Tarifas_transporte.peso_inicial;%@"></td>
</tr><tr> 
<td class="etiqueta" >Pes final:</td>
<td ><input type="text" name="registro[peso_final]" class="insertext" size="11" value="@%db:Tarifas_transporte.peso_final;%@"></td>
</tr><tr> 
<td class="etiqueta">Import:</td>
<td ><input type="text" name="registro[costo]" class="insertext" size="11" value="@%db:Tarifas_transporte.costo;%@"></td>
</tr><tr> 
<td class="etiqueta">Cost unitat:</td>
<td ><input type="checkbox" name="registro[costo_unidad]" class="insertext" value="1" @%db:check_flag{Tarifas_transporte.costo_unidad};%@>
      (@%db:si_no_flag{Tarifas_transporte.costo_unidad};%@)
</td>
</table>
<div class="enviar"><a href="#" onClick="sendForm('nuevo_tarifas');" >Guardar</a>
</form>
