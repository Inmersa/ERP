@%where:tabla|Empresarios;%@
<form name="ficha" action="?seccion=ficha_empresario" method="post">
<input type="hidden" name="Empresarios[id_usr]" value="@%db:Empresarios.id_usr%@" />
<input type="hidden" name="Empresarios[id_empresario]" value="@%db:Empresarios.id_empresario;%@" />

<div class="tituloseccion">&gt; {{frame_fichaempresario}}</div>

@%plt:Datos;%@

@%plt:Accesos%@ 

<input type="hidden" name="accion_ejecutar" value="Modificar" />
</form>

<div class="AccionesEnvio"><ul>
<li><a href="#" onclick="return sendForm('ficha');" class="guardar" ><img src="imag/pixel.png" class="icono" /><span>Modifier</span></a></li>
</ul></div>
@%end-where:%@
