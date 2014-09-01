
<form method="post" action="?seccion=bo_facturas_agente" name="buscadorgeneral">

<input type="hidden" name="nom_bus" value="bo_facturas_agente_search" />
Facturas de Abono <input type="checkbox" name="abonos" value="1" @%func:check_flag;st_abonos;%@ />
ID<input type="text" name="id_cli" class="ids" value="@%get:st_id_cli;%@" />

<select name="estado">
<option value="">---------------</option>
<option value="2"
@%if:equals;st_estado;2;%@
selected="selected"
@%end-if:%@
>Emitida</option>
<option value="1"
@%if:equals;st_estado;1;%@
selected="selected"
@%end-if:%@
>Sin Emitir</option>
</select>
 <input type="checkbox" name="solopropios" value="1" @%func:check_flag;st_solopropios;%@ />
 Texto<input type="text" name="nombre" size="20" value="@%get:st_nombre;%@" />
 <input type="text" name="fecha_inicio" size="12" maxlength="10" 
@%if:esta_vacio;st_fecha_inicio;%@
value="dd/mm/aaaa" 
@%else:%@
value="@%get:st_fecha_inicio;%@"
@%end-if:%@
 />
 <input type="text" name="fecha_fin" size="12" maxlength="10" 
@%if:esta_vacio;st_fecha_fin;%@
value="dd/mm/aaaa" 
@%else:%@
value="@%get:st_fecha_fin;%@"
@%end-if:%@
 />
 <a href="#" onclick="return sendForm('buscadorgeneral');" class="submit" accesskey="b" >Buscar</a>
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
