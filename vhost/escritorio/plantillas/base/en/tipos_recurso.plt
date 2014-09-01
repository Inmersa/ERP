
@%set:tb=Tipos_recurso;%@

<div class="tituloseccion" >Resource Types</div>

@%plt:botonera%@

<div id="AccionesListado" >
<ul>
@%if:AllowedAction;Tipos_recurso;new;%@
<li><a href="?seccion=nuevo_tipo_recurso" class="nuevo" ><img src="images/pixel.png" class="icono" /><span>New</span></a></li>
@%end-if:%@
@%if:AllowedAction;Tipos_recurso;del;%@
<li><a href="#" onClick="return sendForm('listado','accion_ejecutar','Borrar');" class="borrar" ><img src="images/pixel.png" class="icono" /><span>Delete selected</span></a></li>
@%end-if:%@
</ul>
</div>

<table class="full">
<thead>
<tr>
<td></td>
<td >Name</td>
<td >Description</td>
</tr>
</thead>
<form name="listado" action="?seccion=@%get:_krn_ss_name;%@" method="post">
<input type="hidden" name="accion_ejecutar" value="Borrar" />
<input type="hidden" name="tb" value="@%get:tb;%@" />
@%where:tabla|Tipos_recurso;nombre|busc;no_results|1;%@
<tr>
<td class="check"><input type="checkbox" name="lista_@%get:tb;%@[@%db:Tipos_recurso.id_tipo_recurso;%@]" value="@%db:Tipos_recurso.id_tipo_recurso;%@" /></td>
<td class="etiqueta"><a href="?seccion=ficha_tipo_recurso&id=@%db:Tipos_recurso.id_tipo_recurso;%@">@%db:Tipos_recurso.nombre;%@</a></td>
<td>@%db:Tipos_recurso.descripcion;%@ </td>
</tr>
@%end-where:%@

</table>
</form>
@%plt:botonera%@

