
<form method="post" action="?seccion=bo_informe_agentes_clientes" name="buscadorgeneral">

 <input type="hidden" name="nom_bus" value="bo_informe_agentes_clientes_search" />
 <input type="checkbox" name="solopropios" value="1"
 	@%func:check_flag;st_solopropios;%@ />
 Client Text<input type="text" name="nombre" value="" size="30" value="@%get:st_nombre;%@" /> Depuis 
 <input type="text" name="fecha_inicio" class="fecha"
 @%if:esta_vacio;st_fecha_inicio;%@
 value="dd/mm/aaaa" 
 @%else:%@
 value="@%get:st_fecha_inicio;%@"
 @%end-if:%@
 /> Jusqu-à <input type="text" name="fecha_fin" size="12" maxlength="10" 
 @%if:esta_vacio;st_fecha_fin;%@
 value="dd/mm/aaaa" 
 @%else:%@
 value="@%get:st_fecha_fin;%@"
 @%end-if:%@
 />
 <a href="#" onclick="return sendForm('buscadorgeneral');" accesskey="r" >Chercher</a>
 <select name="hp">
@%where:nodb|nodb_hits_page;%@
<option value="@%db:value;%@"
@%if:equals;st_hp;value;%@
selected="selected"
@%end-if:%@
>@%db:name;%@</option>
@%end-where:%@

</select>
</form>
