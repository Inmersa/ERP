
@%set:tb=Estados_servicio;%@

<div class="tituloseccion" >Service Status</div>

@%plt:botonera%@

<div id="AccionesListado" >
<ul>
@%if:AllowedAction;Estados_servicio;new;%@
<li><a href="?seccion=nuevo_estado_servicio" class="nuevo" ><img src="images/pixel.png" class="icono" /><span>New</span></a></li>
@%end-if:%@
@%if:AllowedAction;Estados_servicio;del;%@
<li><a href="#" onClick="return sendForm('listado','accion_ejecutar','Borrar');" class="borrar" ><img src="images/pixel.png" class="icono" /><span>Delete selected</span></a></li>
@%end-if:%@
</ul>
</div>

<table class="full">
<thead>
<tr>
<td></td>
<td >Name</td>
</tr>
</thead>
<form name="listado" action="?seccion=@%get:_krn_ss_name;%@" method="post">
<input type="hidden" name="accion_ejecutar" value="Borrar" />
<input type="hidden" name="tb" value="@%get:tb;%@" />
@%where:tabla|Estados_servicio;nombre|busc;no_results|1;%@
<tr>
<td class="check"><input type="checkbox" name="lista_@%get:tb;%@[@%db:Estados_servicio.id_estado_servicio;%@]" value="@%db:Estados_servicio.id_estado_servicio;%@" /></td>
<td ><a href="?seccion=ficha_estado_servicio&id=@%db:Estados_servicio.id_estado_servicio;%@">@%db:Estados_servicio.nombre;%@</a></td>
</tr>
@%end-where:%@

</table>
</form>
@%plt:botonera%@

