
 <form name="modif_series_facturacion" action="?seccion=bo_series_facturacion" method="post">
 <input type="hidden" name="registro[id_serie]" value="@%db:Series_facturacion.id_serie;%@" />
 <input type="hidden" name="registro[ventas]" value="@%db:Series_facturacion.ventas;%@" />
 <input type="hidden" name="registro[contabilizable]" value="@%db:Series_facturacion.contabilizable;%@" />
 <input type="hidden" name="estado" value="1" />
<table class="full">
 <tr><td class="etiqueta" >Nome:</td>
 <td >@%db:Series_facturacion.nombre;%@</td>
 </tr>
 <tr><td class="etiqueta" >Descri��o:</td>
 <td >@%db:reemplazar_salto{Series_facturacion.descripcion};%@</td>
 </tr>
 <tr><td class="etiqueta" >Contador:</td>
 <td ><input type="text" name="registro[contador]" class="num" value="@%db:Series_facturacion.contador;%@" /></td>
 </tr>
 <tr><td class="etiqueta" >De Vendas:</td>
 <td >@%db:si_no_flag{Series_facturacion.ventas};%@</td>
 </tr>
<tr><td class="etiqueta" >T�tulos:</td>
 <td >@%db:si_no_flag{Series_facturacion.contabilizable};%@</td>
 </tr>
 </table>
 </form>

 <div class="AccionesEnvio"><ul>
 <li><a href="#" onClick="return sendForm('modif_series_facturacion');"  class="guardar" ><img src="imag/pixel.png" class="icono" /><span>Guardar</span></a></li> 
 <li><a href="#" onClick="return resetForm('modif_series_facturacion');"  class="deshacer" 
 	><img src="imag/pixel.png" class="icono" /><span>Desfazer Altera��es</span></a></li> 
 </ul></div>

