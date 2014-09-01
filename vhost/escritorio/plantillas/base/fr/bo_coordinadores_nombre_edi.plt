<!-- @%set:formulario_botonera=ListadoCoordinadores;%@ -->
@%plt:botonera%@

<div id="AccionesListado">
<ul>
@%if:AllowedLink;nuevo_coordinadores;%@
<li><a href="?seccion=nuevo_coordinadores" class="nuevo"><img src="imag/pixel.png" class="icono" /><span>Nouveau Coordinador</span></a></li>
@%end-if:%@
<li><a href="#" onclick="return confirmForm('coordinadores','Êtes-vous sûr que vous voulez supprimer des enregistrements choisis?');" class="borrar" 
	><img src="imag/pixel.png" class="icono" /><span>Elimier</span></a></li>
</ul>
</div>

<form name="coordinadores" method="post" action="?seccion=bo_coordinadores" id="FormListadoClientes" >
<input type="hidden" name="accion_ejecutar" value="Borrar" />

<table class="full" id="TablaListadoCoordinadores" >
<thead>
<tr> 
 <td class="check" >&nbsp;</td>
 <td class="caption" >Nom</td>
 <td class="caption" >Email</td>
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

