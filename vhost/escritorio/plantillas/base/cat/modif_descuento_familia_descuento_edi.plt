
<form name="modif_descuento_familia" action="?seccion=bo_descuento_familia" method="post" >
<input type="hidden" name="registro[id_familia]" value="@%db:Descuento_familia.id_familia;%@" />
<input type="hidden" name="estado" value="1" />

<table class="full">
 <tr><td class="etiqueta" >Fam�lia de articles:</td>
 <td >@%db:Familia_articulos.nombre;%@</td>
 </tr>
 <tr><td class="etiqueta" >Descomptes:</td>
 <td ><input type="text" name="registro[descuento]" value="@%db:Descuento_familia.descuento;%@" class="dto" size="6" /> %</td>
 </tr>
</table>
</form>

<div class="AccionesEnvio"><ul>
 <li><a href="#" onClick="return sendForm('modif_descuento_familia');"  class="guardar" ><img src="images/pixel.png" class="icono" /><span>Guardar</span></a></li> 
 <li><a href="#" onClick="return resetForm('modif_descuento_familia');"  class="deshacer" ><img src="images/pixel.png" class="icono" /><span>Desfer canvis</span></a></li>
 <li><a href="?seccion=bo_descuento_familia&estado=2&registro[id_familia]=@%db:Descuento_familia.id_familia%@" 
 	onclick="return confirm('�Est� segur que desitja esborrar els registres seleccionats?');"  class="borrar" ><img src="images/pixel.png" class="icono" /><span>Esborrar</span></a></li>
</ul></div>

