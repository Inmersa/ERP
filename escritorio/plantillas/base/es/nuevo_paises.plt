<div class="barraoscura">
<div class="titsuperior">&gt; NUEVO PAIS</div></div>


<table class="full">
 <form name="nuevo_paises" action="?seccion=bo_paises" method="post">
<input type="hidden" name="registro[id_pais]" value="NULL" />
<input type="hidden" name="estado" value="1" />

<tr>
<td class="etiqueta">Nombre:</td>
<td><input type="text" name="registro[nombre]" size="55" /></td>
</tr>

<tr>
<td class="etiqueta">Código:</td>
<td><input type="text" name="registro[codigo]" size="5" /></td>
</tr>

<tr>
<td class="etiqueta">Continente:</td>
<td><input type="text" name="registro[continente]" size="55" /></td>
</tr>

<tr>
<td class="etiqueta">Prefijo telefónico:</td>
<td><input type="text" name="registro[prefijo_tlf]" size="5" /></td>
</tr>

<tr>
<td class="etiqueta">Prefijo CIF: </td>
<td><input type="text" name="registro[prefijo_cif]" size="5" /></td>
</tr>
</table>

<div class="enviar"><a href="javascript:document.forms['nuevo_paises'].submit();">Guardar</a></div>
</form>
