
 @%if:AllowedLink;nuevo_series_facturacion;%@
 <div id="AccionesEncabezado" ><ul>
 <li><a href="?seccion=nuevo_series_facturacion" class="nuevo" ><img src="images/pixel.png" class="icono" /><span>Nou</span></a></li>
 </ul></div>
 @%end-if:%@

 <form name="modif_series_facturacion" action="?seccion=bo_series_facturacion" method="post">
 <input type="hidden" name="registro[id_serie]" value="@%db:Series_facturacion.id_serie;%@">
 <input type="hidden" name="estado" value="1">
<table class="full">
 <tr><td class="etiqueta" >Nom:</td>
 <td ><input type="text" name="registro[nombre]" value="@%db:Series_facturacion.nombre;%@" class="insertext" size="10"></td>
 </tr>
 <tr><td class="etiqueta" >Descripci�:</td>
 <td ><input type="text" name="registro[descripcion]" size="55" class="insertext" value="@%db:Series_facturacion.descripcion;%@"></td>
 </tr>
 <tr><td class="etiqueta" >Comptador:</td>
 <td ><input type="text" name="registro[contador]" size="55" class="insertext" value="@%db:Series_facturacion.contador;%@"></td>
 </tr>
 <tr><td class="etiqueta" >Vendre:</td>
 <td ><input type="checkbox" name="registro[ventas]" value="1" @%db:check_flag{Series_facturacion.ventas};%@></td>
 </tr>
<tr><td class="etiqueta" >Cap�al:</td>
 <td ><input type="checkbox" name="registro[contabilizable]" value="1" @%db:check_flag{Series_facturacion.contabilizable};%@></td>
 </tr>
 </table>
 </form>

 <div class="AccionesEnvio"><ul>
 <li><a href="#" onClick="return sendForm('modif_series_facturacion');"  class="guardar" ><img src="images/pixel.png" class="icono" /><span>Guardar</span></a></li> 
 <li><a href="#" onClick="return resetForm('modif_series_facturacion');"  class="deshacer" 
 	><img src="images/pixel.png" class="icono" /><span>Desfer canvis</span></a></li> 
 <li><a href="?seccion=bo_series_facturacion&estado=2&registro[id_serie]=@%db:Series_facturacion.id_serie%@" 
 	onClick="return confirm('�Est� segur que desitja esborrar els registres seleccionats?');"  class="borrar" ><img src="images/pixel.png" class="icono" /><span>Esborrar</span></a></li>
 </ul></div>

