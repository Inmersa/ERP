
<table class="full">
 <form method="post" action="?seccion=@%get:_krn_ss_name;%@" name="buscadorgeneral">
<tr> 
<td class="caption">Agent</td>
<td class="caption">Nom route</td>
<td class="caption">Client</td>
<td class="caption"></td>
</tr>
<tr><td>
 <input type="hidden" name="nom_bus" value="rutas_search" />
 <input type="text" name="nombre_agente" size="30" value="@%get:st_nombre_agente%@" /></td>
<td> <input type="text" name="nombre_ruta" size="30" value="@%get:st_nombre_ruta%@" /></td>
<td> 
<input type="text" name="nombre_cliente" size="30" value="@%get:st_nombre_cliente%@" /></td>
<td><a href="#" onclick="return sendForm('buscadorgeneral');" 
	class="submit" accesskey="r" >Chercher</a><select name="hp">
@%where:nodb|nodb_hits_page;%@
<option value="@%db:value;%@"
@%if:equals;st_hp;value;%@
selected="selected"
@%end-if:%@
>@%db:name;%@</option>
@%end-where:%@

</select>
</td></tr>
</form>
</table>

