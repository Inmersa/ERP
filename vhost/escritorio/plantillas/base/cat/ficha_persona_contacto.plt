
<div class="tituloseccion">&gt; {{frame_fichapersonacontacto}}</div>

<form name="nuevo" action="?seccion=modif_clientes" method="post">
<input type="hidden" name="accion_ejecutar" value="ModificarContacto" />
<input type="hidden" name="cliente_contactos[id_contacto]" value="@%db:Cliente_contactos.id_contacto;%@" />
<input type="hidden" name="cliente_contactos[id_cliente]" value="@%db:Cliente_contactos.id_cliente;%@" />
<input type="hidden" name="cliente_contactos[id_empresa]" value="@%db:Cliente_contactos.id_empresa;%@" />

<table class="full">
<tr>
<td class="etiqueta">Nom:</td>
<td><input type="text" name="cliente_contactos[nombre]" value="@%db:Cliente_contactos.nombre;%@"  /></td>

<td class="etiqueta">Cognoms:</td>
<td><input type="text" name="cliente_contactos[apellidos]"  value="@%db:Cliente_contactos.apellidos;%@" /></td>
</tr>

<tr><td class="etiqueta">C�rrec de contacte:</td>
<td><input type="text" name="cliente_contactos[cargo]" value="@%db:Cliente_contactos.cargo;%@"  /></td>

<td class="etiqueta">e-mail:</td>
<td><input type="text" name="cliente_contactos[email]" value="@%db:Cliente_contactos.email;%@"  /></td>
</tr>

<tr><td class="etiqueta">Tel�fon:</td>
<td><input type="text" name="cliente_contactos[telefono1]" value="@%db:Cliente_contactos.telefono1;%@"  /></td>

<td class="etiqueta">Tel�fon 2:</td>
<td><input type="text" name="cliente_contactos[telefono2]"  value="@%db:Cliente_contactos.telefono2;%@" /></td>
</tr>

<tr><td class="etiqueta">Fax:</td>
<td><input type="text" name="cliente_contactos[fax]" value="@%db:Cliente_contactos.fax;%@"  /></td>

<td class="etiqueta" valign="top">Observacions:</td>
<td><textarea name="cliente_contactos[observaciones]" rows="7" cols="75">@%db:Cliente_contactos.observaciones;%@</textarea></td>
</tr>

</table>

<div class="AccionesEnvio">
<ul>
<li><a href="#" onClick="return sendForm('nuevo');" class="guardar" ><img src="images/pixel.png" class="icono" /><span>Guardar</span></a></li>
</ul>
</div>
</form>
