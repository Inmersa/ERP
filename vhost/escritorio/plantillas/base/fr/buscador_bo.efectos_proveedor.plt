
 <form method="post" action="?seccion=bo_efectos_proveedor" name="buscadorgeneral">
<input type="hidden" name="nom_bus" value="efectos_proveedor" />
Text<input type="text" name="nombre" size="20" value="@%get:st_nombre;%@" />
 État 
<select name="estado">
<option value="">---------------</option>
<option value="1"
@%if:equals;st_estado;1;%@
selected="selected"
@%end-if:%@
>Sans émettre</option>
<option value="5"
@%if:equals;st_estado;5;%@
selected="selected"
@%end-if:%@
>Non Payé</option>
<option value="2"
@%if:equals;st_estado;2;%@
selected="selected"
@%end-if:%@
>Paiemnet Partiel</option>
<option value="3"
@%if:equals;st_estado;3;%@
selected="selected"
@%end-if:%@
>Abonné</option>
<option value="4"
@%if:equals;st_estado;4;%@
selected="selected"
@%end-if:%@
>Envoi en retour</option>
</select>

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
 />Moyen de payant: <select name="medio_pago">
 <option value="">---------------</option>
 <option value="efectivo"
@%if:equals;st_medio_pago;efectivo;%@
selected="selected"
@%end-if:%@
>Liquidités</option>
 <option value="cheque"
@%if:equals;st_medio_pago;cheque;%@
selected="selected"
@%end-if:%@
>Chèque</option>
 <option value="transferencia"
@%if:equals;st_medio_pago;transferencia;%@
selected="selected"
@%end-if:%@
>Transfert</option>
 <option value="pagare"
@%if:equals;st_medio_pago;pagare;%@
selected="selected"
@%end-if:%@
>Billet</option>
 <option value="recibo"
@%if:equals;st_medio_pago;recibo;%@
selected="selected"
@%end-if:%@
>Réception</option>
 </select>
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

