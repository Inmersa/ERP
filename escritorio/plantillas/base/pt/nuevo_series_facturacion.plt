
<div class="tituloseccion">&gt; Nova S�rie de Factura��o</div>

<table class="full">
 <form name="nuevo_series_facturacion" action="?seccion=bo_series_facturacion" method="post">
 <input type="hidden" name="registro[id_serie]" value="NULL" />
 <input type="hidden" name="estado" value="1" />

<tr><td class="etiqueta">Nome:</td>
<td><input type="text" name="registro[nombre]" size="55" /></td>

 </tr>

<tr><td class="etiqueta">Descri��o:</td>
<td>
 <input type="text" name="registro[descripcion]" size="55" /></td>

 </tr>

<tr><td class="etiqueta">Contador:</td>
<td>
 <input type="text" name="registro[contador]" size="55" /></td>

 </tr>

<tr><td class="etiqueta">De Vendas:</td>
<td><input type="checkbox" name="registro[ventas]" value="1" /></td>
</tr>

</table>
</form>

<div class="enviar"><ul>
<li><a href="#" onclick="return sendForm('nuevo_series_facturacion');" class="guardar" ><img src="imag/pixel.png" class="icono" /><span>Guardar</span></a></li>
</ul></div>

