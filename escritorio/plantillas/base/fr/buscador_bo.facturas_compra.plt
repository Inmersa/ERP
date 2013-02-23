
 <form method="post" action="?seccion=bo_facturas_compra" name="buscadorgeneral">

 <input type="hidden" name="nom_bus" value="bo_facturas_compra_search" />
Factures d'Engrais <input type="checkbox" name="abonos" value="1" @%func:check_flag;st_abonos;%@ />

Série Facturation 
 <!-- @%set:_selected_value=st_id_serie;%@ -->
<select name="id_serie" class="insertext">
<option value="">Aucune sélection</option>
@%where:tabla|Series_facturacion;nolink|1;where|ventas=0;order|nombre;%@
<option value="@%db:Series_facturacion.id_serie;%@"
@%db:selected_value{Series_facturacion.id_serie};%@
>@%db:Series_facturacion.nombre;%@
(@%db:si_no_flag{Series_facturacion.contabilizable};%@)</option>
@%end-where:%@

</select>
État
<select name="estado">
 <option value="">---------------</option>
 <option value="2"
 @%if:equals;st_estado;2;%@
 selected="selected"
 @%end-if:%@
>Émis</option>
 <option value="1"
 @%if:equals;st_estado;1;%@
 selected="selected"
 @%end-if:%@
>Sans émettre</option>
 <option value="3"
 @%if:equals;st_estado;3;%@
 selected="selected"
 @%end-if:%@
>Contrats</option>
 </select>
 Text<input type="text" name="nombre" size="20" value="@%get:st_nombre;%@" />
 <input type="text" name="fecha_inicio" size="12"
@%if:esta_vacio;st_fecha_inicio;%@
value="dd/mm/aaaa" 
@%else:%@
value="@%get:st_fecha_inicio;%@"
@%end-if:%@
 />
 <input type="text" name="fecha_fin" size="12"
@%if:esta_vacio;st_fecha_fin;%@
value="dd/mm/aaaa" 
@%else:%@
value="@%get:st_fecha_fin;%@"
@%end-if:%@
 />
<a href="#" onclick="return sendForm('buscadorgeneral');" class="submit" accesskey="r" >Chercher</a>
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

