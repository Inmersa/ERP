
@%set:tb=Tipos_anotacion;%@

<div class="tituloseccion" >Tipos de Anotación</div>

@%plt:botonera%@

<div id="AccionesListado" >
<ul>
@%if:AllowedAction;Tipos_anotacion;new;%@
<li><a href="?seccion=nuevo_tipo_anotacion" class="nuevo" ><img src="imag/pixel.png" class="icono" /><span>Nuevo</span></a></li>
@%end-if:%@
@%if:AllowedAction;Tipos_anotacion;del;%@
<li><a href="#" onClick="return sendForm('listado','accion_ejecutar','Borrar');" class="borrar" ><img src="imag/pixel.png" class="icono" /><span>Borrar seleccionados</span></a></li>
@%end-if:%@
</ul>
</div>

<table class="full">
<thead>
<tr>
<td></td>
<td >Nombre</td>
</tr>
</thead>
<form name="listado" action="?seccion=@%get:_krn_ss_name;%@" method="post">
<input type="hidden" name="accion_ejecutar" value="Borrar" />
<input type="hidden" name="tb" value="@%get:tb;%@" />
@%where:tabla|Tipos_anotacion;nombre|busc;no_results|1;%@
<tr>
<td class="check"><input type="checkbox" name="lista_@%get:tb;%@[@%db:Tipos_anotacion.id_tipo_anotacion;%@]" value="@%db:Tipos_anotacion.id_tipo_anotacion;%@" /></td>
<td ><a href="?seccion=ficha_tipo_anotacion&id=@%db:Tipos_anotacion.id_tipo_anotacion;%@">@%db:Tipos_anotacion.nombre;%@</a></td>
</tr>
@%end-where:%@

</table>
</form>
@%plt:botonera%@

