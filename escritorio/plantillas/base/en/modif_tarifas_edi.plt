
 @%if:AllowedLink;nuevo_tarifas;%@
 <div id="AccionesEncabezado"><ul>
 <li><a href="?seccion=nuevo_tarifas" class="nuevo" ><img src="images/pixel.png" class="icono" /><span>New</span></a></li>
 </ul></div>
 @%end-if:%@

<form name="modif_tarifas" action="?seccion=bo_tarifas" method="post">
<input type="hidden" name="registro[id_tarifa]" value="@%db:Tarifas.id_tarifa;%@" />
<input type="hidden" name="estado" value="1" />
 <!--@%db:Tarifas.id_tarifa;%@-->
<table class="full">
 <tr><td class="etiqueta" >Name:</td>
 <td colspan="2"><input type="text" name="registro[nombre]" value="@%db:Tarifas.nombre;%@" size="55" /></td>
 </tr>
 <tr><td class="etiqueta" >% First:</td>
 <td colspan="2"><input type="text" name="registro[pto_primero]" value="@%db:Tarifas.pto_primero;%@" size="55" /></td>
 </tr>
 <tr><td class="etiqueta" >% Second:</td>
 <td colspan="2"><input type="text" name="registro[pto_segundo]" value="@%db:Tarifas.pto_segundo;%@" size="55" /></td>
 </tr>
 <tr><td class="etiqueta" >Total amount:</td>
 <td colspan="2"><input type="text" name="registro[monto]" value="@%db:Tarifas.monto;%@" size="55" /></td>
 </tr>
 <tr><td class="etiqueta">Action field:</td>
 <td colspan="2"> 
 <!--@%db:Tarifas.campo_accion;%@ @%set:selected=Tarifas.campo_accion%@-->
 <select name="registro[campo_accion]" >
 <option value="precio_costo"
 @%if:equals;selected;precio_costo;%@
 selected="selected" 
 @%end-if:%@
 >Price 1</option>
 <option value="precio_standard"
 @%if:equals;selected;precio_standard;%@
 selected="selected" 
 @%end-if:%@
 >Price 2</option>
 <option value="precio_venta"
 @%if:equals;selected;precio_venta;%@
 selected="selected" 
 @%end-if:%@
 >Price 3</option>
 <option value="precio_4"
 @%if:equals;selected;precio_4;%@
 selected="selected" 
 @%end-if:%@
 >Price 4</option>
 <option value="precio_5"
 @%if:equals;selected;precio_5;%@
 selected="selected" 
 @%end-if:%@
 >Price 5</option>
 <option value="precio_6"
 @%if:equals;selected;precio_6;%@
 selected="selected" 
 @%end-if:%@
 >Price 6</option>
 </select>
 </td>
 </tr>
 <tr><td class="etiqueta">Recommendation field:</td>
 <td colspan="2"><!--@%db:Tarifas.campo_recomendacion;%@ @%set:selected=Tarifas.campo_recomendacion%@-->
 <select name="registro[campo_recomendacion]" >
 <option value="precio_costo"
 @%if:equals;selected;precio_costo;%@
 selected="selected"  
 @%end-if:%@
 >Price 1</option>
 <option value="precio_standard"
 @%if:equals;selected;precio_standard;%@
 selected="selected" 
 @%end-if:%@
 >Price 2</option>
 <option value="precio_venta"
 @%if:equals;selected;precio_venta;%@
 selected="selected" 
 @%end-if:%@
 >Price 3</option>
 <option value="precio_4"
 @%if:equals;selected;precio_4;%@
 selected="selected" 
 @%end-if:%@
 >Price 4</option>
 <option value="precio_5"
 @%if:equals;selected;precio_5;%@
 selected="selected" 
 @%end-if:%@
 >Price 5</option>
 <option value="precio_6"
 @%if:equals;selected;precio_6;%@
 selected="selected" 
 @%end-if:%@
 >Price 6</option>
 </select>
 </td>
 </tr>
 <tr><td class="etiqueta">Calculate Recommendation:</td>
 <td ><input type="text" name="registro[pto_recomendacion]" maxlength="6" size="6" value="@%db:Tarifas.pto_recomendacion;%@" />%</td>
 <td><input type="checkbox" name="registro[coniva_recomendacion]" value="1" 
@%db:check_flag{Tarifas.coniva_recomendacion};%@ />Add VAT to Recommendation Field </td>
 </tr>
 </table>
 </form>

 <div class="AccionesEnvio"><ul>
 <li><a href="#" onClick="return sendForm('modif_tarifas');"  class="guardar" ><img src="images/pixel.png" class="icono" /><span>Save</span></a></li> 
 <li><a href="#" onClick="return resetForm('modif_tarifas');"  class="deshacer" ><img src="images/pixel.png" class="icono" /><span>Undo changes</span></a></li>
 <li><a href="?seccion=bo_tarifas&estado=2&registro[id_tarifa]=@%db:Tarifas.id_tarifa%@" 
 	onClick="return confirm('Are you sure that do you want to delete the selected registries?');"  class="borrar" ><img src="images/pixel.png" class="icono" /><span>Delete</span></a></li> 
 </ul></div>

