
@%if:!esta_vacio;_page_breaked;%@
</div>
@%end-if:%@

@%if:esta_vacio;_page_css;%@
@%set:_page_css = pagina;%@
@%end-if:%@

<div class="@%get:_page_css;%@">
<div id="barra1">
@%if:!esta_vacio;_numero_copia;%@
	<div id="tipocopia" >
	@%if:equals;_numero_copia;1;%@
	Original
	@%end-if:%@
	@%if:equals;_numero_copia;2;%@
	Duplicat
	@%end-if:%@
	@%if:equals;_numero_copia;3;%@
	Triplicat
	@%end-if:%@
	@%if:equals;_numero_copia;4;%@
	Quadruplicat
	@%end-if:%@
	@%if:equals;_numero_copia;5;%@
	Quintuplicat
	@%end-if:%@
	</div>
@%end-if:%@
<div id="contadorpaginas">Pàgines @%calc:pagina_actual;round|0;output|1;%@ de @%get:paginas_totales;%@</div></div>
@%set:_page_breaked=1;%@
@%calc:pagina_actual=pagina_actual + 1;%@

