

 <form method="post" action="?seccion=@%get:_krn_ss_name;%@" name="buscadorgeneral">

  @%if:equals;_krn_ss_name;bo_proformas_cliente;%@
 <input type="hidden" name="nom_bus" value="proformas_cliente" />
  @%else:%@
 <input type="hidden" name="nom_bus" value="bo_presupuestos_cliente_search" />
  @%end-if:%@

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
 <a href="#" onclick="return sendForm('buscadorgeneral');" class="submit" accesskey="p" >Pesquisar</a>
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
