

 <form method="post" action="?seccion=bo_efectos_cliente" name="buscadorgeneral">
<input type="hidden" name="nom_bus" value="efectos_clientes" />
<!-- @%set:_selected_value=st_id_ag;%@ -->
Agent 
<select name="id_ag" class="insertext">
<option value="">Non Agent</option>
@%where:tabla|Agentes;nolink|1;nombre|agentes;%@
<option value="@%db:Agentes.id_agente;%@"
@%db:selected_value{Agentes.id_agente};%@
>@%db:Agentes.nombre;%@</option>
@%end-where:%@

</select>
IDs <input type="text" name="id_cli" class="mininum" value="@%get:st_id_cli;%@" />
 Text<input type="text" name="nombre" size="20" value="@%get:st_nombre;%@" />
 Condition
<select name="estado">
<option value="">---------------</option>
<option value="1"
@%if:equals;st_estado;1;%@
selected="selected"
@%end-if:%@
>Not Issued</option>
<option value="5"
@%if:equals;st_estado;5;%@
selected="selected"
@%end-if:%@
>Not payed</option>
<option value="2"
@%if:equals;st_estado;2;%@
selected="selected"
@%end-if:%@
>Partial payment</option>
<option value="3"
@%if:equals;st_estado;3;%@
selected="selected"
@%end-if:%@
>Credited</option>
<option value="4"
@%if:equals;st_estado;4;%@
selected="selected"
@%end-if:%@
>Returned</option>
</select>
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
 Payment way: <select name="medio_pago">
 <option value="">---------------</option>
 <option value="efectivo"
@%if:equals;st_medio_pago;efectivo;%@
selected="selected"
@%end-if:%@
>Cash</option>
 <option value="cheque"
@%if:equals;st_medio_pago;cheque;%@
selected="selected"
@%end-if:%@
>Cheque</option>
 <option value="transferencia"
@%if:equals;st_medio_pago;transferencia;%@
selected="selected"
@%end-if:%@
>Cash transfer</option>
 <option value="pagare"
@%if:equals;st_medio_pago;pagare;%@
selected="selected"
@%end-if:%@
>Promissory note</option>
 <option value="recibo"
@%if:equals;st_medio_pago;recibo;%@
selected="selected"
@%end-if:%@
>Receipt</option>
 </select>
 <a href="#" onclick="return sendForm('buscadorgeneral');" class="submit" accesskey="f" >Search</a>
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

