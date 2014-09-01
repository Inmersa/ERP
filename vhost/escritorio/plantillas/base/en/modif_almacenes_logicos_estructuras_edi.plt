@%where:tabla|Almacenes_logicos;where|Almacenes_logicos.id_almacen_logico = $id_almacen_logico_promocion;%@

<table class="full">

<form name="modif_almacenes_logicos" action="?seccion=modif_almacenes_logicos&id_almacen_logico=@%db:Almacenes_logicos.id_almacen_logico;%@" method="post">
<input type="hidden" name="registro[id_almacen_logico]" value="@%db:Almacenes_logicos.id_almacen_logico;%@" />

<tr>
<td class="etiqueta">Name:</td>
<td colspan="9"><input type="text" name="registro[nombre]" value="@%db:Almacenes_logicos.nombre;%@" size="80" /></td>
<tr>
<td class="etiqueta">Floors:</td>
<td><input type="text" name="registro[n_planta]" value="@%db:Almacenes_logicos.n_planta;%@" size="3" /></td>
<td class="etiqueta">Corridors:</td>
<td><input type="text" name="registro[n_pasillo]" value="@%db:Almacenes_logicos.n_pasillo;%@" size="3" /></td>
<td class="etiqueta">Rows:</td>
<td><input type="text" name="registro[n_fila]" value="@%db:Almacenes_logicos.n_fila;%@" size="3" /></td>
<td class="etiqueta">Columns:</td>
<td><input type="text" name="registro[n_columna]" value="@%db:Almacenes_logicos.n_columna;%@" size="3" /></td>
</tr>
</table>

<input type="hidden" name="Modificar" value="Modificar" />
</form>

<div class="AccionesEnvio"><ul>
<li><a href="#" onClick="return sendForm('modif_almacenes_logicos');" class="guardar" ><img src="images/pixel.png" class="icono" /><span>Modify</span></a></li>
</ul></div>

<table class="full">
<tr>
<td class="caption">Warehouses</td>
</tr>
<tr>
<td class="etiqueta">Name:</td>
<td colspan="3">@%db:Almacenes.nombre;%@</td>
</tr>
<tr><td class="etiqueta">Address:</td>
<td colspan="3">@%db:Almacenes.direccion;%@ - @%db:Almacenes.cp;%@ (@%db:Almacenes.poblacion;%@)</td>
</tr>
<tr>
<td class="etiqueta">Contact person:</td>
<td>@%db:Almacenes.persona_contacto;%@ (@%db:Almacenes.cargo_persona_contacto;%@)</td>
<td class="etiqueta">Telephone:</td>
<td>@%db:Almacenes.telefono;%@</td>
</tr>
<tr>
<td colspan="2"></td>
<td class="etiqueta">Fax:</td>
<td>@%db:Almacenes.fax;%@</td>
</tr>
<tr>
<td colspan="2"></td>
<td class="etiqueta">e-mail:</td>
<td>@%db:Almacenes.email;%@</td>
</tr>
</table>
 
