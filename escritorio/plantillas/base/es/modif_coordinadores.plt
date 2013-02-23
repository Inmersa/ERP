@%where:tabla|Coordinadores;where|id_coordinador = $id_coordinador;%@
<div class="tituloseccion">&gt; FICHA DE COORDINADOR (@%db:Coordinadores.nombre;%@ @%db:Coordinadores.apellidos;%@)</div>

@%if:AllowedLink;nuevo_coordinadores;%@
<div id="AccionesEncabezado">
<ul>
<li><a href="?seccion=nuevo_coordinadores" class="nuevo"><img src="imag/pixel.png" class="icono" /><span>Nuevo Coordinador</span></a></li>
</ul>
</div>
@%end-if:%@

    @%plt:FichaDeCoordinador;%@

