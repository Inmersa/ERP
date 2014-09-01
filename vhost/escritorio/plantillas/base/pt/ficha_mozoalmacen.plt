@%where:tabla|Mozos_almacen;%@
<form name="ficha" action="?seccion=ficha_mozo" method="post">
<input type="hidden" name="Mozos_almacen[id_usr]" value="@%db:Mozos_almacen.id_usr%@" />
<input type="hidden" name="Mozos_almacen[id_mozo]" value="@%db:Mozos_almacen.id_mozo;%@" />

<div class="tituloseccion">&gt; {{frame_fichamozoalmacen}}</div>

@%plt:Datos;%@

@%plt:Accesos%@ 

<input type="hidden" name="accion_ejecutar" value="Modificar" />
</form>

<div class="AccionesEnvio"><ul>
<li><a href="#" onclick="return sendForm('ficha');" class="guardar" ><img src="imag/pixel.png" class="icono" /><span>Alterar</span></a></li>
</ul></div>
@%end-where:%@
