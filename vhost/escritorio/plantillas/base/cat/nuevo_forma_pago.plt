<div class="barraoscura">
<div class="titsuperior">&gt; Nova forma de paga</div><div class="alinder">
</div></div> 
<table class="full">
<form name="nuevo_forma_pago" action="?seccion=bo_forma_pago" method="post">
<input type="hidden" name="registro[id_forma_pago]" value="NULL" />
<input type="hidden" name="estado" value="1" />

<tr>
<td class="etiqueta">Nom:</td>
<td><input type="text" name="registro[nombre]" size="55" /></td>
</tr>
<tr>
<td class="etiqueta">N� Efectes:</td>
<td><input type="text" name="registro[num_efectos]" size="55" /></td>
</tr>
<tr><td class="etiqueta">Dies entre Efectes:</td>
<td><input type="text" name="registro[dias_efectos]" size="55" /></td>
</tr>
</form>
</table>
<div class="enviar"><a href="javascript:document.forms['nuevo_forma_pago'].submit();">Guardar</a></div>
