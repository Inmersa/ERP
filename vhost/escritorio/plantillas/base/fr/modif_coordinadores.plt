@%where:tabla|Coordinadores;where|id_coordinador = $id_coordinador;%@
<div class="tituloseccion">&gt; FICHE DE COORDINADOR (@%db:Coordinadores.nombre;%@ @%db:Coordinadores.apellidos;%@)</div>

@%if:AllowedLink;nuevo_coordinadores;%@
<div id="AccionesEncabezado">
<ul>
<li><a href="?seccion=nuevo_coordinadores" class="nuevo"><img src="imag/pixel.png" class="icono" /><span>Nouveau Coordinador</span></a></li>
</ul>
</div>
@%end-if:%@

    @%plt:FichaDeCoordinador;%@

