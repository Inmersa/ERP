
<div class="tituloseccion">&gt; Client Link Card</div>

<form name="nuevo" action="?seccion=modif_clientes" method="post">
<input type="hidden" name="accion_ejecutar" value="ModificarEnlace" />
<input type="hidden" name="cliente_enlaces[id_enlace]" value="@%db:Cliente_enlaces.id_enlace;%@" />
<input type="hidden" name="cliente_enlaces[id_cliente]" value="@%db:Cliente_enlaces.id_cliente;%@" />
<input type="hidden" name="cliente_enlaces[id_empresa]" value="@%db:Cliente_enlaces.id_empresa;%@" />


<table class="full">
<tr>
<td class="etiqueta">Name:</td>
<td><input type="text" name="cliente_enlaces[nombre]" value="@%db:Cliente_enlaces.nombre;%@" /></td>

<td class="etiqueta">URL:</td>
<td>http://<input type="text" name="cliente_enlaces[url]" value="@%db:Cliente_enlaces.url;%@" /></td>
</tr>

<tr>
<td class="etiqueta" >Remarks:</td>
<td colspan="3" ><textarea name="cliente_enlaces[descripcion]" rows="7" cols="75">@%db:Cliente_enlaces.descripcion;%@</textarea></td>
</tr>

</table>

<div class="AccionesEnvio">
<ul>
<li><a href="#" onClick="return sendForm('nuevo');" class="guardar" ><img src="images/pixel.png" class="icono" /><span>Add</span></a></li>
</ul>
</div>
</form>
