
<form name="modif_descuento_familia" action="?seccion=bo_descuento_familia" method="post" >
<input type="hidden" name="registro[id_familia]" value="@%db:Descuento_familia.id_familia;%@" />
<input type="hidden" name="estado" value="1" />

<table class="full">
 <tr><td class="etiqueta" >Products Family:</td>
 <td >@%db:Familia_articulos.nombre;%@</td>
 </tr>
 <tr><td class="etiqueta" >Discounts:</td>
 <td ><input type="text" name="registro[descuento]" value="@%db:Descuento_familia.descuento;%@" class="dto" size="6" /> %</td>
 </tr>
</table>
</form>

<div class="AccionesEnvio"><ul>
 <li><a href="#" onClick="return sendForm('modif_descuento_familia');"  class="guardar" ><img src="images/pixel.png" class="icono" /><span>Save</span></a></li> 
 <li><a href="#" onClick="return resetForm('modif_descuento_familia');"  class="deshacer" ><img src="images/pixel.png" class="icono" /><span>Undo changes</span></a></li>
 <li><a href="?seccion=bo_descuento_familia&estado=2&registro[id_familia]=@%db:Descuento_familia.id_familia%@" 
 	onclick="return confirm('Are you sure that do you want to delete the selected registries?');"  class="borrar" ><img src="images/pixel.png" class="icono" /><span>Delete</span></a></li>
</ul></div>

