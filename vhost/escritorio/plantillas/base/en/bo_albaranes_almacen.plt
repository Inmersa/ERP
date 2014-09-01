<div class="barraoscura">
<div class="titsuperior">&gt; All time Delivery Notes Record 
         <!-- {@%get:_krncfg_ss_name;%@} -->
	 @%if:equals;ss_nm;bo_albaranes_almacen_compra;%@
	 Of Purchases
	 @%else:%@
	 Of Sales
	 @%end-if:%@
(
       @%where:tabla|Almacenes;nolink|1;where|id_almacen = $id_almacen_promocion;%@
       @%db:Almacenes.nombre;%@
       @%end-where:%@

       )</div></div>
@%plt:Listado_Albaranes%@
