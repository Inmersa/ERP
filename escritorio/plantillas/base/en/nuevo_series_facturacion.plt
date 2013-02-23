
<div class="tituloseccion">&gt; New Invoicing series</div>

<table class="full">
 <form name="nuevo_series_facturacion" action="?seccion=bo_series_facturacion" method="post">
 <input type="hidden" name="registro[id_serie]" value="NULL" />
 <input type="hidden" name="estado" value="1" />

<tr><td class="etiqueta">Name:</td>
<td><input type="text" name="registro[nombre]" size="55" /></td>

 </tr>

<tr><td class="etiqueta">Description:</td>
<td>
 <input type="text" name="registro[descripcion]" size="55" /></td>

 </tr>

<tr><td class="etiqueta">Meter:</td>
<td>
 <input type="text" name="registro[contador]" size="55" /></td>

 </tr>

<tr><td class="etiqueta">Of Sales:</td>
<td><input type="checkbox" name="registro[ventas]" value="1" /></td>
</tr>

</table>
</form>

<div class="enviar"><ul>
<li><a href="#" onclick="return sendForm('nuevo_series_facturacion');" class="guardar" ><img src="images/pixel.png" class="icono" /><span>Save</span></a></li>
</ul></div>

