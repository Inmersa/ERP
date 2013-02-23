<fieldset class="fsficha">
<legend>Personnes de Contact</legend>

<div class="AccionesFicha">
<ul>
@%if:AllowedAction;Cliente_contactos;new;%@
<li><a href="?seccion=nueva_persona_contacto" class="nuevo" ><img src="imag/pixel.png" class="icono" /><span>Nouveau</span></a></li>
@%end-if:%@
@%if:AllowedAction;Cliente_contactos;del;%@
<li><a href="#" onClick="return onHRefClick('modif_clientes','accion_ejecutar','BorrarContactos');" class="borrar"><img src="imag/pixel.png" class="icono" /><span>Effacer</span></a></li>
@%end-if:%@
</ul>
</div>

<table class="full">
<thead>
<tr>
<td></td>
<td>Nom</td>
<td>Surnom</td>
<td>Charge de contact</td>
<td>Téléphone</td>
<td>e-mail</td>
</tr>
</thead>
<tbody>
@%where:tabla|Cliente_contactos;where|Cliente_contactos.id_cliente = $id_cliente;order|Cliente_contactos.nombre,Cliente_contactos.apellidos;%@
<tr><td class="check">
@%if:AllowedAction;Cliente_contactos;del;%@
<input type="checkbox" name="cliente_contactos[@%db:Cliente_contactos.id_contacto%@][id_contacto]" value="@%db:Cliente_contactos.id_contacto;%@">
@%end-if:%@
</td><td>
@%if:AllowedAction;Cliente_contactos;edit;%@
<a href="?seccion=ficha_persona_contacto&amp;id=@%db:Cliente_contactos.id_contacto%@" 
	>@%db:Cliente_contactos.nombre%@</a>
@%else:%@
@%db:Cliente_contactos.nombre%@ 
@%end-if:%@
</td>
<td>@%db:Cliente_contactos.apellidos%@</td>
<td>@%db:Cliente_contactos.cargo;%@</td>
<td>@%db:Cliente_contactos.telefono1;%@</td>
<td>
@%if:esta_vacio;Cliente_contactos.email;%@
@%else:%@
<a href="mailto:@%db:Cliente_contactos.email;%@" >@%db:Cliente_contactos.email;%@</a>
@%end-if:%@
</td>
</tr>
@%end-where:%@

</tbody>
</table>
</fieldset>

