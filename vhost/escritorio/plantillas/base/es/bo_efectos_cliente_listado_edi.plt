

@%plt:botonera%@

<form name="listado_efectos" action="?seccion=bo_efectos_cliente" method="post">
<input type="hidden" name="accion_ejecutar" value="Modificar" />
<input type="hidden" name="venta" value="1" />

<div id="AccionesListado"><ul>
<li class="noicon" ><input type="checkbox" name="usar_vencimiento" value="1" /></li>
<li class="noicon" >Fecha Vencimiento</li>
<li class="noicon" ><select name="registro[id_banco]" size="1">
<option value="0">--- Sin Usar Banco ---</option>
@%where:tabla|Bancos;nolink|1;nombre|bancos;order|Bancos.nombre asc;%@
<option value="@%db:Bancos.id_banco%@">@%db:Bancos.nombre%@</option>
@%end-where:%@

</select></li>
<li><a href="#" onClick="return onHRefClick('listado_efectos','accion_ejecutar','Abonar');" 
	class="abonar" ><img src="images/pixel.png" class="icono" /><span>Abonar</span></a></li>
<li><a href="#" onClick="return onHRefClick('listado_efectos','accion_ejecutar','Devolver');"
	class="devolverabono" ><img src="images/pixel.png" class="icono" /><span>Devolver</span></a></li>
<li><a href="#" onClick="return onHRefClick('listado_efectos','accion_ejecutar','Modificar');"
	class="guardar" ><img src="images/pixel.png" class="icono" /><span>Modificar</span></a></li>
<li><a href="#" onClick="return SendFormToWindow('listado_efectos','modif_efectos_cliente&imprimir=1','Imprimir');"
	class="imprimir" ><img src="images/pixel.png" class="icono" /><span>Imprimir</span></a></li>

</ul>
<!-- a href="#" onClick="return onHRefClick('listado_efectos','accion_ejecutar','Emitir');">Emitir</a -->
</div> 

<!-- @%set:noemitido=rojo%@ @%set:emitido=amarillo%@ @%set:abonado=verde%@ @%set:devuelto=negro%@ -->
@%where:tabla|Efectos;nombre|busc;order|Clientes.razon_social,Efectos.fecha_vencimiento desc;no_results|1;contador|i;%@ 
@%if:nuevo_cliente%@
@%if:!equals;i;1;%@
</tbody>
</table>
@%end-if:%@

<table class="full">
<thead>
<tr>
<td ><a href="?_search_sort=Clientes.id_cliente" class="order" >C�digo<img src="images/pixel.png" class="@%func:class_searchsort;Clientes.id_cliente;%@" /></a></td>
<td class="fieldvalue" ><a href="?seccion=modif_clientes&id_cliente=@%db:Clientes.id_cliente;%@">@%db:Clientes.id_cliente;%@</a></td>
<td ><a href="?_search_sort=Clientes.razon_social" class="order" 
	>Raz�n social<img src="images/pixel.png" class="@%func:class_searchsort;Clientes.razon_social;%@" /></a></td>
<td class="fieldvalue"><a href="?seccion=modif_clientes&id_cliente=@%db:Clientes.id_cliente;%@">@%db:Clientes.razon_social%@</a></td>
</thead>
</tr>
 </table>
<table class="full">
<td class="etiqueta">Riesgo</td>
<td class="etiqueta">Demora</td>
<td class="etiqueta">Mto. Cuenta</td>
<td class="etiqueta">Cuenta Bancaria IBAN</td>
 </tr>
<tr>
<td>@%db:Clientes_empresas.riesgo%@</td>
<td>@%db:Clientes_empresas.plazo_demora%@ D�a(s)</td>
<td>@%db:Clientes_empresas.monto_cuenta%@</td>
<td>@%db:Clientes_empresas.iban%@ @%db:Clientes_empresas.entidad%@ @%db:Clientes_empresas.oficina%@ @%db:Clientes_empresas.cuenta_bancaria%@</td>
 </tr>
</table>

<table class="full"><thead><tr>
<td ><a href="?_search_sort=Facturas.base_imponible" class="order" >Base Imp.<img src="images/pixel.png" class="@%func:class_searchsort;Facturas.base_imponible;%@" 
	/></a></td>
<td ><a href="?_search_sort=Facturas.fecha" class="order" >Fecha<img src="images/pixel.png" class="@%func:class_searchsort;Facturas.fecha;%@" /></a></td>
<td ><a href="?_search_sort=Facturas.referencia" class="order" >Ref. Factura<img src="images/pixel.png" class="@%func:class_searchsort;Facturas.referencia;%@" /></a></td>
<td class="estado" ><img src="images/pixel.png" class="marcartodos" onclick="return formCheckAll('registro[efectos]');"  /></td>
<td ><a href="?_search_sort=Efectos.concepto" class="order" >Concepto<img src="images/pixel.png" class="@%func:class_searchsort;Efectos.concepto;%@" /></a></td>
<td ><a href="?_search_sort=Efectos.medio_pago" class="order" >Medio Pago<img src="images/pixel.png" class="@%func:class_searchsort;Efectos.medio_pago;%@" /></a></td>
<td ><a href="?_search_sort=Efectos.fecha_vencimiento" class="order" 
	>Vencimiento<img src="images/pixel.png" class="@%func:class_searchsort;Efectos.fecha_vencimiento;%@" /></a></td>
<td ><a href="?_search_sort=Efectos.monto" class="order" >Total<img src="images/pixel.png" class="@%func:class_searchsort;Efectos.monto;%@" /></a></td>
<td ><a href="?_search_sort=Efectos.monto_pagado" class="order" 
	>T. Pagado<img src="images/pixel.png" class="@%func:class_searchsort;Efectos.monto_pagado;%@" /></a> </td>
<td >E</td>
</tr></thead>
<tbody>
 @%else:%@
@%end-if:%@

<tr 
@%if:esta_vacio;Efectos.pago_cobro;%@
class="impropio"
@%end-if:%@
>

<td class="importe" >@%db:Facturas.base_imponible%@</td>
<td >@%db:colocar_fecha{Facturas.fecha}%@</td>
<td class="etiqueta"><a href="?seccion=bo_factura_cliente&id_factura=@%db:Facturas.id_factura;%@">@%db:Facturas.referencia%@</a></td>
<td class="check"><input type="checkbox" name="registro[efectos][@%db:Efectos.id_efecto%@]" value="1" />
 <input type="hidden" name="efectos[@%db:Efectos.id_efecto%@][id_cliente]" value="@%db:Clientes.id_cliente;%@" />
 <input type="hidden" name="efectos[@%db:Efectos.id_efecto%@][cc_efectos]" value="@%db:Clientes_empresas.cc_efectos;%@" />
 <input type="hidden" name="efectos[@%db:Efectos.id_efecto%@][ref_factura]" value="@%db:Facturas.referencia;%@" />
 <input type="hidden" name="efectos[@%db:Efectos.id_efecto%@][monto]" value="@%db:Efectos.monto;%@" />
 <input type="hidden" name="efectos[@%db:Efectos.id_efecto%@][old_fecha]" value="@%db:colocar_fecha{Efectos.fecha_vencimiento};%@" />
 <input type="hidden" name="efectos[@%db:Efectos.id_efecto%@][importe]" value="@%calc:Efectos.monto - Efectos.monto_pagado;output|1;%@" /></td>
<td><a href="?seccion=modif_efectos_cliente&id_efecto=@%db:Efectos.id_efecto;%@"><img src="imag/hojablanco.jpg" border="0">@%db:Efectos.concepto;%@</a></td>
<td>@%db:Efectos.medio_pago%@</td>
<td>
@%if:esta_vacio;Efectos.pagado;%@
<input type="text" name="efectos[@%db:Efectos.id_efecto%@][fecha_vencimiento]" class="fecha" value="@%db:colocar_fecha{Efectos.fecha_vencimiento};%@" />
@%else:%@
@%db:colocar_fecha{Efectos.fecha_vencimiento};%@
@%end-if:%@
</td>
<td>@%db:Efectos.monto%@</td>
<td>@%db:Efectos.monto_pagado%@</td>
<td class="estado" ><img src="images/pixel.png" class="@%func:estado_efecto;Efectos.emitido;Efectos.devuelto;Efectos.pagado;noemitido;emitido;abonado;devuelto;%@" /></td>
</tr>
@%end-where:%@

</tbody></table>
</form>

 @%plt:botonera%@

<table class="full">
<caption class="titulotb" >Leyenda</caption>
<tr>
<td class="etiqueta">Estado</td>
<td class="estado" ><img src="images/pixel.png" class="rojo" /></td>
<td class="etiquetacheck" >Sin Emitir</td>
<td class="estado" ><img src="images/pixel.png" class="amarillo" /></td>
<td class="etiquetacheck" >Emitido</td>
<td class="estado" ><img src="images/pixel.png" class="verde" /></td>
<td class="etiquetacheck" >Abonado</td>
<td class="estado" ><img src="images/pixel.png" class="negro" /></td>
<td class="etiquetacheck" >Devuelto</td>
</tr>

 </table>



