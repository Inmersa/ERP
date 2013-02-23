<div class="barraoscura">
<div class="titsuperior">&gt; NUEVA FORMA DE PAGO</div><div class="alinder">
</div></div> 
<table class="full">
<form name="nuevo_forma_pago" action="?seccion=bo_forma_pago" method="post">
<input type="hidden" name="registro[id_forma_pago]" value="NULL" />
<input type="hidden" name="estado" value="1" />

<tr>
<td class="etiqueta">Nombre:</td>
<td><input type="text" name="registro[nombre]" size="55" /></td>
</tr>
<tr>
<td class="etiqueta">Nº de efectos:</td>
<td><input type="text" name="registro[num_efectos]" size="55" /></td>
</tr>
<tr><td class="etiqueta">Días entre efectos:</td>
<td><input type="text" name="registro[dias_efectos]" size="55" /></td>
</tr>
</form>
</table>
<div class="enviar"><a href="javascript:document.forms['nuevo_forma_pago'].submit();">Guardar</a></div>
