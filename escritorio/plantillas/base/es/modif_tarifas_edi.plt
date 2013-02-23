
 @%if:AllowedLink;nuevo_tarifas;%@
 <div id="AccionesEncabezado"><ul>
 <li><a href="?seccion=nuevo_tarifas" class="nuevo" ><img src="imag/pixel.png" class="icono" /><span>Nuevo</span></a></li>
 </ul></div>
 @%end-if:%@

<form name="modif_tarifas" action="?seccion=bo_tarifas" method="post">
<input type="hidden" name="registro[id_tarifa]" value="@%db:Tarifas.id_tarifa;%@" />
<input type="hidden" name="estado" value="1" />
 <!--@%db:Tarifas.id_tarifa;%@-->
<table class="full">
 <tr><td class="etiqueta" >Nombre:</td>
 <td colspan="2"><input type="text" name="registro[nombre]" value="@%db:Tarifas.nombre;%@" size="55" /></td>
 </tr>
 <tr><td class="etiqueta" >% Primero:</td>
 <td colspan="2"><input type="text" name="registro[pto_primero]" value="@%db:Tarifas.pto_primero;%@" size="55" /></td>
 </tr>
 <tr><td class="etiqueta" >% Segundo:</td>
 <td colspan="2"><input type="text" name="registro[pto_segundo]" value="@%db:Tarifas.pto_segundo;%@" size="55" /></td>
 </tr>
 <tr><td class="etiqueta" >Monto:</td>
 <td colspan="2"><input type="text" name="registro[monto]" value="@%db:Tarifas.monto;%@" size="55" /></td>
 </tr>
 <tr><td class="etiqueta">Campo de acción:</td>
 <td colspan="2"> 
 <!--@%db:Tarifas.campo_accion;%@ @%set:selected=Tarifas.campo_accion%@-->
 <select name="registro[campo_accion]" >
 <option value="precio_costo"
 @%if:equals;selected;precio_costo;%@
 selected="selected" 
 @%end-if:%@
 >Precio 1</option>
 <option value="precio_standard"
 @%if:equals;selected;precio_standard;%@
 selected="selected" 
 @%end-if:%@
 >Precio 2</option>
 <option value="precio_venta"
 @%if:equals;selected;precio_venta;%@
 selected="selected" 
 @%end-if:%@
 >Precio 3</option>
 <option value="precio_4"
 @%if:equals;selected;precio_4;%@
 selected="selected" 
 @%end-if:%@
 >Precio 4</option>
 <option value="precio_5"
 @%if:equals;selected;precio_5;%@
 selected="selected" 
 @%end-if:%@
 >Precio 5</option>
 <option value="precio_6"
 @%if:equals;selected;precio_6;%@
 selected="selected" 
 @%end-if:%@
 >Precio 6</option>
 </select>
 </td>
 </tr>
 <tr><td class="etiqueta">Campo Recomendación:</td>
 <td colspan="2"><!--@%db:Tarifas.campo_recomendacion;%@ @%set:selected=Tarifas.campo_recomendacion%@-->
 <select name="registro[campo_recomendacion]" >
 <option value="precio_costo"
 @%if:equals;selected;precio_costo;%@
 selected="selected"  
 @%end-if:%@
 >Precio 1</option>
 <option value="precio_standard"
 @%if:equals;selected;precio_standard;%@
 selected="selected" 
 @%end-if:%@
 >Precio 2</option>
 <option value="precio_venta"
 @%if:equals;selected;precio_venta;%@
 selected="selected" 
 @%end-if:%@
 >Precio 3</option>
 <option value="precio_4"
 @%if:equals;selected;precio_4;%@
 selected="selected" 
 @%end-if:%@
 >Precio 4</option>
 <option value="precio_5"
 @%if:equals;selected;precio_5;%@
 selected="selected" 
 @%end-if:%@
 >Precio 5</option>
 <option value="precio_6"
 @%if:equals;selected;precio_6;%@
 selected="selected" 
 @%end-if:%@
 >Precio 6</option>
 </select>
 </td>
 </tr>
 <tr><td class="etiqueta">Cálculo Recomendación:</td>
 <td ><input type="text" name="registro[pto_recomendacion]" maxlength="6" size="6" value="@%db:Tarifas.pto_recomendacion;%@" />%</td>
 <td><input type="checkbox" name="registro[coniva_recomendacion]" value="1" 
@%db:check_flag{Tarifas.coniva_recomendacion};%@ />Sumar IVA al campo recomendación </td>
 </tr>
 </table>
 </form>

 <div class="AccionesEnvio"><ul>
 <li><a href="#" onClick="return sendForm('modif_tarifas');"  class="guardar" ><img src="imag/pixel.png" class="icono" /><span>Guardar</span></a></li> 
 <li><a href="#" onClick="return resetForm('modif_tarifas');"  class="deshacer" ><img src="imag/pixel.png" class="icono" /><span>Deshacer Cambios</span></a></li>
 <li><a href="?seccion=bo_tarifas&estado=2&registro[id_tarifa]=@%db:Tarifas.id_tarifa%@" 
 	onClick="return confirm('¿Está ud. seguro de que desea borrar los registros seleccionados?');"  class="borrar" ><img src="imag/pixel.png" class="icono" /><span>Borrar</span></a></li> 
 </ul></div>

