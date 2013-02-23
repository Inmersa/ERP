<!-- @%set:formulario_botonera=ListadoCoordinadores;%@ -->
@%plt:botonera%@

<div id="AccionesListado">
<ul>
@%if:AllowedLink;nuevo_coordinadores;%@
<li><a href="?seccion=nuevo_coordinadores" class="nuevo"><img src="images/pixel.png" class="icono" /><span>New Coordinator</span></a></li>
@%end-if:%@
<li><a href="#" onclick="return confirmForm('coordinadores','Are you sure that do you want to delete the selected registries?');" class="borrar" 
	><img src="images/pixel.png" class="icono" /><span>Delete selected</span></a></li>
</ul>
</div>

<form name="coordinadores" method="post" action="?seccion=bo_coordinadores" id="FormListadoClientes" >
<input type="hidden" name="accion_ejecutar" value="Borrar" />

<table class="full" id="TablaListadoCoordinadores" >
<thead>
<tr> 
 <td class="check" >&nbsp;</td>
 <td class="caption" >Name</td>
 <td class="caption" >E-mail</td>
</tr>
</thead>
<tbody>
@%where:tabla|Coordinadores;nombre|busc;no_results|1;%@
<tr> 
<td class="check"><input type="checkbox" class="inserttext" name="registro_borrar[@%db:Coordinadores.id_coordinador;%@]" value="@%db:Coordinadores.id_usr;%@"></td>
<td ><a href="?seccion=modif_coordinadores&id_coordinador=@%db:Coordinadores.id_coordinador;%@" 
	>@%db:Coordinadores.nombre;%@ @%db:Coordinadores.apellidos;%@</a></td>
<td ><a href="mailto:@%db:Coordinadores.email;%@" >@%db:Coordinadores.email;%@</a></td>
</tr>
@%end-where:%@ 
		  
</table>
</form>
	  
@%plt:botonera%@

