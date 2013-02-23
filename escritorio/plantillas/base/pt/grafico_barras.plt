
<div id="chart" style="height: @%get:base_alto;%@px;" >
<div class="chartTitle">@%get:grafica[titulo];%@</div>

@%where:nodb|nodb_graph_list;%@
<div id="EjeY" style="height: @%get:graf_alto;%@px;" >
@%where:nodb|nodb_graph_yaxis;contador|i;%@
<div class="ValorY" style="bottom: @%db:pto;%@%;" >@%db:valor;%@-</div>
@%end-where:%@

</div>

<div class="grafica" style="height: @%get:graf_alto;%@px; width: @%get:graf_ancho;%@px; " >
<div class="headers">@%db:titulo;%@</div>
@%where:nodb|nodb_graph_data;contador|i;%@
<!-- "z-index: @%db:zindex;%@" -->
<div class="barra @%db:color;%@" style="height: @%db:pto;%@%; left: @%db:left;%@px; width: @%db:ancho;%@px; bottom: @%db:pto_inf;%@%; "
onclick="return mostrar_valorbarra(getElementById('gb_@%db:nombre;%@@%db:color;%@'));" 
><div class="valorbarra" id="gb_@%db:nombre;%@@%db:color;%@">
@%if:!esta_vacio;link;%@
<a href="@%db:link;%@" class="gr_linkleyenda" >@%db:valor;%@</a><span class="gbl_cierre" >[X]</span>
@%else:%@
@%if:esta_vacio;etiqueta;%@
@%db:lcdec{valor};%@
@%else:%@
@%db:etiqueta;%@
@%end-if:@
@%end-if:%@
</div>
&nbsp;</div>
@%end-where:%@

</div>
@%end-where:%@ 

<div id="LeyendaGrf">
@%where:nodb|nodb_leyenda_grafico;%@
<div class="keysp" ><div class="keyswatch @%db:color;%@" >&nbsp;</div><div class="keytext">
@%if:!esta_vacio;link;%@
<a href="@%db:link;%@" class="gr_linkleyenda" >@%db:nombre;%@</a>
@%else:%@
@%db:nombre;%@
@%end-if:%@
</div></div>
@%end-where:%@

</div>

<div class="horz">&nbsp;</div>
</div>


