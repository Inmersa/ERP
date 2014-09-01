
<div class="tituloseccion">&gt; Operadors</div>
<!-- @%set:formulario_botonera=ListadoCoordinadores;%@ -->

@%plt:botonera%@

<div id="AccionesListado">
<ul>
@%if:AllowedAction;Operadores;new;%@
<li><a href="?seccion=nuevo_operador" class="nuevo"><img src="images/pixel.png" class="icono" /><span>Nou Operador</span></a></li>
@%end-if:%@
@%if:AllowedAction;Operadores;del;%@
<li><a href="#" onclick="return confirmForm('operadores','�Est� segur que desitja esborrar els registres seleccionats?');" class="borrar" 
	><img src="images/pixel.png" class="icono" /><span>Esborrar seleccionats</span></a></li>
@%end-if:%@
</ul>
</div>

<form name="operadores" method="post" action="?seccion=operadores" id="FormListadoClientes" >
<input type="hidden" name="accion_ejecutar" value="Borrar" />

<table class="full" id="TablaListadoCoordinadores" >
<thead>
<tr> 
 <td class="check" >&nbsp;</td>
 <td class="caption" >Nom</td>
 <td class="caption" >e-mail</td>
</tr>
</thead>
<tbody>
@%where:tabla|Operadores;nombre|busc;no_results|1;%@
<tr> 
<td class="check"><input type="checkbox" class="inserttext" name="registro_borrar[@%db:Operadores.id_operador;%@]" value="@%db:Operadores.id_usr;%@"></td>
<td ><a href="?seccion=ficha_operador&id=@%db:Operadores.id_operador;%@" 
	>@%db:Operadores.nombre;%@ @%db:Operadores.apellidos;%@</a></td>
<td ><a href="mailto:@%db:Operadores.email;%@" >@%db:Operadores.email;%@</a></td>
</tr>
@%end-where:%@ 
		  
</table>
</form>
	  
@%plt:botonera%@

