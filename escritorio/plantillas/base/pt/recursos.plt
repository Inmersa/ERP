
@%set:tb=Recursos;%@

<div class="tituloseccion" >Recursos</div>

@%plt:botonera%@

<div id="AccionesListado" >
<ul>
@%if:esta_vacio;modo_seleccion;%@
	@%if:AllowedAction;Recursos;new;%@
	<li><a href="?seccion=nuevo_recurso" class="nuevo" ><img src="imag/pixel.png" class="icono" /><span>Novo</span></a></li>
	@%end-if:%@
	@%if:AllowedAction;Recursos;del;%@
	<li><a href="#" onClick="return sendForm('listado','accion_ejecutar','Borrar');" class="borrar" 
		><img src="imag/pixel.png" class="icono" /><span>Eliminar Itens Seleccionados</span></a></li>
	@%end-if:%@
@%else:%@
	<li><a href="#" onClick="return sendForm('listado');" class="seleccionar" ><img src="imag/pixel.png" class="icono" /><span>Associar Itens Seleccionados</span></a></li>
@%end-if:%@
</ul>
</div>

<table class="full">
<thead>
<tr>
<td></td>
<td >Nome</td>
<td >Tipo</td>
<td >Descrição</td>
</tr>
</thead>
@%if:esta_vacio;modo_seleccion;%@
<form name="listado" action="?seccion=@%get:_krn_ss_name;%@" method="post">
<input type="hidden" name="accion_ejecutar" value="Borrar" />
@%else:%@
<form name="listado" action="?seccion=@%get:_krn_old_ss_name;%@" method="post">
<input type="hidden" name="accion_ejecutar" value="SeleccionarRecursos" />
@%end-if:%@

<input type="hidden" name="tb" value="@%get:tb;%@" />
@%where:tabla|Recursos;nombre|busc;no_results|1;%@
<tr>
<td class="check">
@%if:esta_vacio;modo_seleccion;%@
<input type="checkbox" name="lista_@%get:tb;%@[@%db:Recursos.id_recurso;%@]" value="@%db:Recursos.id_recurso;%@" />
@%else:%@
@%if:esta_vacio;modo_seleccion_varios;%@
<input type="radio" name="selecciones" value="@%db:Recursos.id_recurso;%@" />
@%else:%@
<input type="checkbox" name="selecciones[@%db:Recursos.id_recurso;%@]" value="@%db:Recursos.id_recurso;%@" />
@%end-if:%@
@%end-if:%@
</td>
<td class="etiqueta"><a href="?seccion=ficha_recurso&id=@%db:Recursos.id_recurso;%@">@%db:Recursos.nombre;%@</a></td>
<td>@%db:Tipos_recurso.nombre;%@ </td>
<td>@%db:Recursos.descripcion;%@ </td>
</tr>
@%end-where:%@

</table>
</form>
@%plt:botonera%@

