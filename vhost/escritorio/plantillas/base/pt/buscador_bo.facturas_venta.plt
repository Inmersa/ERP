
 <form method="post" action="?seccion=bo_facturas_venta" name="buscadorgeneral">

 <input type="hidden" name="nom_bus" value="bo_facturas_venta_search" />
Notas de Crédito <input type="checkbox" name="abonos" value="1" @%func:check_flag;st_abonos;%@ />

Série de Facturação 
<!-- @%set:_selected_value=st_id_serie;%@ -->
<select name="id_serie" class="insertext">
<option value="">-----</option>
@%where:tabla|Series_facturacion;nolink|1;where|ventas=1;order|nombre;%@
<option value="@%db:Series_facturacion.id_serie;%@"
@%db:selected_value{Series_facturacion.id_serie};%@
>@%db:Series_facturacion.nombre;%@
(@%db:si_no_flag{Series_facturacion.contabilizable};%@)</option>
@%end-where:%@

</select>
Estado
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
>Por Emitir</option>
 <option value="3"
 @%if:equals;st_estado;3;%@
 selected="selected"
 @%end-if:%@
>Contratos</option>
 </select>
 Texto<input type="text" name="nombre" size="20" value="@%get:st_nombre;%@" />
 <input type="text" name="fecha_inicio" class="fecha"
@%if:esta_vacio;st_fecha_inicio;%@
value="dd/mm/aaaa" 
@%else:%@
value="@%get:st_fecha_inicio;%@"
@%end-if:%@
 />
 <input type="text" name="fecha_fin" class="fecha"
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
