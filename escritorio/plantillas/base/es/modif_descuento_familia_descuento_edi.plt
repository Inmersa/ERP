
<form name="modif_descuento_familia" action="?seccion=bo_descuento_familia" method="post" >
<input type="hidden" name="registro[id_familia]" value="@%db:Descuento_familia.id_familia;%@" />
<input type="hidden" name="estado" value="1" />

<table class="full">
 <tr><td class="etiqueta" >Familia de artículos:</td>
 <td >@%db:Familia_articulos.nombre;%@</td>
 </tr>
 <tr><td class="etiqueta" >Descuento:</td>
 <td ><input type="text" name="registro[descuento]" value="@%db:Descuento_familia.descuento;%@" class="dto" size="6" /> %</td>
 </tr>
</table>
</form>

<div class="AccionesEnvio"><ul>
 <li><a href="#" onClick="return sendForm('modif_descuento_familia');"  class="guardar" ><img src="imag/pixel.png" class="icono" /><span>Guardar</span></a></li> 
 <li><a href="#" onClick="return resetForm('modif_descuento_familia');"  class="deshacer" ><img src="imag/pixel.png" class="icono" /><span>Deshacer Cambios</span></a></li>
 <li><a href="?seccion=bo_descuento_familia&estado=2&registro[id_familia]=@%db:Descuento_familia.id_familia%@" 
 	onclick="return confirm('¿Está ud. seguro de que desea borrar los registros seleccionados?');"  class="borrar" ><img src="imag/pixel.png" class="icono" /><span>Borrar</span></a></li>
</ul></div>

