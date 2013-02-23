
<div class="tituloseccion">&gt; Nova Persona de Contacte</div>

<form name="nuevo" action="?seccion=modif_clientes" method="post">
<input type="hidden" name="accion_ejecutar" value="NuevoContacto" />

<table class="full">
<tr>
<td class="etiqueta">Nom:</td>
<td><input type="text" name="cliente_contactos[nombre]"  /></td>

<td class="etiqueta">Cognoms:</td>
<td><input type="text" name="cliente_contactos[apellidos]"  /></td>
</tr>

<tr><td class="etiqueta">C�rrec de contacte:</td>
<td><input type="text" name="cliente_contactos[cargo]"  /></td>

<td class="etiqueta">e-mail:</td>
<td><input type="text" name="cliente_contactos[email]"  /></td>
</tr>

<tr><td class="etiqueta">Tel�fon:</td>
<td><input type="text" name="cliente_contactos[telefono1]"  /></td>

<td class="etiqueta">Tel�fon 2:</td>
<td><input type="text" name="cliente_contactos[telefono2]"  /></td>
</tr>

<tr><td class="etiqueta">Fax:</td>
<td><input type="text" name="cliente_contactos[fax]"  /></td>

<td class="etiqueta" valign="top">Observacions:</td>
<td><textarea name="cliente_contactos[observaciones]" rows="7" cols="75"></textarea></td>
</tr>

</table>

<div class="AccionesEnvio">
<ul>
<li><a href="#" onClick="return sendForm('nuevo');" class="guardar" ><img src="images/pixel.png" class="icono" /><span>Afegir</span></a></li>
</ul>
</div>
</form>
