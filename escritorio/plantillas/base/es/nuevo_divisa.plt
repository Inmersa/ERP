<div class="barraoscura">
<div class="titsuperior">&gt; NUEVA DIVISA</div></div>

<table class="full">
<form name="nuevo_divisa" action="?seccion=bo_divisa" method="post">
<input type="hidden" name="registro[id_divisa]" value="NULL" />
<input type="hidden" name="estado" value="1" />

<tr>
<td class="etiqueta"> Nombre:</td>
<td><input type="text" name="registro[nombre]" size="55" /></td>
</tr>

<tr>
<td class="etiqueta">Leyenda :</td>
<td><input type="text" name="registro[leyenda]" size="55" /></td>
</tr>

<tr>
<td class="etiqueta">Ratio :</td>
<td><input type="text" name="registro[ratio]" size="55" /></td>
</tr>
</form>
</table>

<div class="enviar"><a href="javascript:document.forms['nuevo_divisa'].submit();">Guardar</a></div>