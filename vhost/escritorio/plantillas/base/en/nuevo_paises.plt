<div class="barraoscura">
<div class="titsuperior">&gt; New Country</div></div>


<table class="full">
 <form name="nuevo_paises" action="?seccion=bo_paises" method="post">
<input type="hidden" name="registro[id_pais]" value="NULL" />
<input type="hidden" name="estado" value="1" />

<tr>
<td class="etiqueta">Name:</td>
<td><input type="text" name="registro[nombre]" size="55" /></td>
</tr>

<tr>
<td class="etiqueta">Code:</td>
<td><input type="text" name="registro[codigo]" size="5" /></td>
</tr>

<tr>
<td class="etiqueta">Continent:</td>
<td><input type="text" name="registro[continente]" size="55" /></td>
</tr>

<tr>
<td class="etiqueta">Prefix Tf.:</td>
<td><input type="text" name="registro[prefijo_tlf]" size="5" /></td>
</tr>

<tr>
<td class="etiqueta">Prefix EIN: </td>
<td><input type="text" name="registro[prefijo_cif]" size="5" /></td>
</tr>
</table>

<div class="enviar"><a href="javascript:document.forms['nuevo_paises'].submit();">Save</a></div>
</form>
