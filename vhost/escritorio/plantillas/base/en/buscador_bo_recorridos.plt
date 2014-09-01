
<form method="post" action="?seccion=bo_recorridos" name="buscadorrecorridos">
<table class="full">
<tr> 
@%if:!equals;_AuthInfo[desktop_name];Agentes;%@
 <td class="etiqueta">Agent </td>
@%end-if:%@
 <td class="etiqueta"> Route Name </td>
 <td class="etiqueta"> Client </td>
</tr>

<input type="hidden" name="nom_bus" value="recorridos_search" />
<tr>
@%if:!equals;_AuthInfo[desktop_name];Agentes;%@
 <td align="right"><input type="text" name="nombre_agente" size="30" value="@%get:st_nombre_agente%@" /></td>
@%end-if:%@
 <td align="right"><input type="text" name="nombre_ruta" size="30" value="@%get:st_nombre_ruta%@"></td>
 <td align="right"><input type="text" name="nombre_cliente" size="30" value="@%get:st_nombre_cliente%@"></td>
</tr>

<tr>
 <td class="etiqueta">From</td>
 <td class="etiqueta">To</td>
 <td class="etiqueta"> </td>
</tr>
<tr> 
 <td align="right"> 
 <input type="text" name="fecha_inicio" size="20" value="@%get:st_fecha_inicio;%@">
 </td>
 <td  align="right"> 
 <input type="text" name="fecha_fin" size="20" value="@%get:st_fecha_fin;%@" />
 </td>
 <td ><a href="#" onclick="return sendForm('buscadorrecorridos');" class="submit" accesskey="f" >Search</a>
 <select name="hp">
@%where:nodb|nodb_hits_page;%@
<option value="@%db:value;%@"
@%if:equals;st_hp;value;%@
selected="selected"
@%end-if:%@
>@%db:name;%@</option>
@%end-where:%@

</select></td></tr></table>
</form>

