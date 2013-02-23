
<div class="tituloseccion">&gt; Inventário de Armazém (
      @%where:tabla|Almacenes;nolink|1;where|id_almacen = $id_almacen_promocion;%@
      @%db:Almacenes.nombre;%@ 
      @%end-where:%@

       )</div>

<div class="barraoscura" ><div class="alinder">
   @%where:nodb|nodb_totalizar;%@
	 @%db:nombre_campo;%@ : @%db:lcmon{valor_campo};%@&nbsp;&nbsp;
   @%end-where:%@

</div></div> 


@%plt:Inventario%@

