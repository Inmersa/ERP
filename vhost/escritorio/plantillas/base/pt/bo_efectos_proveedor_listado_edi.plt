

@%plt:botonera%@

<form name="listado_efectos" action="?seccion=bo_efectos_proveedor" method="post">
<input type="hidden" name="accion_ejecutar" value="Modificar" />
<input type="hidden" name="venta" value="0" />

<!-- @%set:noemitido=rojo%@ @%set:emitido=amarillo%@ @%set:abonado=verde%@ @%set:devuelto=negro%@ -->

<div id="AccionesListado"><ul>
<li class="noicon" ><input type="checkbox" name="usar_vencimiento" value="1" /></li>
<li class="noicon" >Data de Vencimento</li>
<li class="noicon" ><select name="registro[id_banco]" size="1">
<option value="0">Sem Banco</option>
@%where:tabla|Bancos;nolink|1;nombre|bancos;order|Bancos.nombre asc;%@
<option value="@%db:Bancos.id_banco%@">@%db:Bancos.nombre%@</option>
@%end-where:%@

</select></li>
<li><a href="#" onClick="return onHRefClick('listado_efectos','accion_ejecutar','Abonar');" class="abonar" 
	><img src="imag/pixel.png" class="icono" /><span>Pagar</span></a></li>
<li><a href="#" onClick="return onHRefClick('listado_efectos','accion_ejecutar','Devolver');" class="devolverabono" 
	><img src="imag/pixel.png" class="icono" /><span>Devolver</span></a></li>
<!-- a href="#" onClick="return onHRefClick('listado_efectos','accion_ejecutar','Emitir');">Emitir</a -->
<li><a href="#" onClick="return onHRefClick('listado_efectos','accion_ejecutar','Modificar');" class="guardar" 
	><img src="imag/pixel.png" class="icono" /><span>Alterar</span></a></li>
</li></div>

@%where:tabla|Efectos;nombre|busc;order|Proveedores.razon_social,Efectos.fecha_vencimiento desc,Facturas.id_factura desc;no_results|1;contador|i;%@ 
@%if:nuevo_proveedor%@
@%if:!equals;i;1;%@
</tbody>
</table>
@%end-if:%@

<table class="full"><thead><tr>
<td ><a href="?_search_sort=Proveedores.id_proveedor" class="order" 
	>C�digo<img src="imag/pixel.png" class="@%func:class_searchsort;Proveedores.id_proveedor;%@" /></a></td>
<td class="fieldvalue" ><a href="?seccion=modif_proveedores&id_proveedor=@%db:Proveedores.id_proveedor;%@">@%db:Proveedores.id_proveedor;%@</a></td>
<td ><a href="?_search_sort=Proveedores.razon_social" class="order" 
	>Denomina��o Comercial<img src="imag/pixel.png" class="@%func:class_searchsort;Proveedores.razon_social;%@" /></a></td>
<td class="fieldvalue" ><a href="?seccion=modif_proveedores&id_proveedor=@%db:Proveedores.id_proveedor;%@"
	>@%db:Proveedores.razon_social%@</a></td>
</tr></thead>
</table>

<table class="full">
<thead class="secundario" ><tr>
<td >Risco</td>
<td >Atraso</td>
<td >Total de Conta</td>
<td >IBAN</td>
</tr></thead>

<tbody><tr>
<td>@%db:Proveedores_empresas.riesgo%@</td>
<td>@%db:Proveedores_empresas.plazo_demora%@ Dia(s)</td>
<td>@%db:Proveedores_empresas.monto_cuenta_efectos%@</td>
<td>@%db:Proveedores_empresas.iban%@ @%db:Proveedores_empresas.entidad%@ @%db:Proveedores_empresas.oficina%@ @%db:Proveedores_empresas.cuenta_bancaria%@</td>
</tr></tbody>
</table>

<table class="full"><thead><tr>
<td ><a href="?_search_sort=Facturas.base_imponible" class="order" >Valor Tribut�vel<img src="imag/pixel.png" class="@%func:class_searchsort;Facturas.base_imponible;%@" 
	/></a></td>
<td ><a href="?_search_sort=Facturas.fecha" class="order" >Data<img src="imag/pixel.png" class="@%func:class_searchsort;Facturas.fecha;%@" /></a></td>
<td ><a href="?_search_sort=Facturas.referencia_externa" class="order" 
	>Ref. Externa<img src="imag/pixel.png" class="@%func:class_searchsort;Facturas.referencia_externa;%@" /></a></td>
<td ><a href="?_search_sort=Facturas.referencia" class="order" >Ref. Factura<img src="imag/pixel.png" class="@%func:class_searchsort;Facturas.referencia;%@" /></a></td>
<td class="estado" ><img src="imag/pixel.png" class="marcartodos" onclick="return formCheckAll('registro[efectos]');"  /></td>
<td ><a href="?_search_sort=Efectos.concepto" class="order" >Conceito<img src="imag/pixel.png" class="@%func:class_searchsort;Efectos.concepto;%@" /></a></td>
<td ><a href="?_search_sort=Efectos.medio_pago" class="order" >Meio de Pagamento<img src="imag/pixel.png" class="@%func:class_searchsort;Efectos.medio_pago;%@" /></a></td>
<td ><a href="?_search_sort=Efectos.fecha_vencimiento" class="order" 
	>Vencimento<img src="imag/pixel.png" class="@%func:class_searchsort;Efectos.fecha_vencimiento;%@" /></a></td>
<td ><a href="?_search_sort=Efectos.monto" class="order" >Total<img src="imag/pixel.png" class="@%func:class_searchsort;Efectos.monto;%@" /></a></td>
<td ><a href="?_search_sort=Efectos.monto_pagado" class="order" 
	>Total Pago<img src="imag/pixel.png" class="@%func:class_searchsort;Efectos.monto_pagado;%@" /></a> </td>
<td class="etiqueta">E</td>
</tr></thead>
<tbody>
@%end-if:%@

<tr
@%if:!esta_vacio;Efectos.pago_cobro;%@
class="impropio"
@%end-if:%@
>
<td class="importe" >@%db:Facturas.base_imponible%@</td>
<td >@%db:colocar_fecha{Facturas.fecha}%@</td>
<td ><a href="?seccion=bo_factura_proveedor&id_factura=@%db:Facturas.id_factura;%@">@%db:Facturas.referencia_externa%@</a></td>
<td class="etiqueta"><a href="?seccion=bo_factura_proveedor&id_factura=@%db:Facturas.id_factura;%@">@%db:Facturas.referencia%@</a></td>
<td class="check"><input type="checkbox" name="registro[efectos][@%db:Efectos.id_efecto%@]" value="1" />
 <input type="hidden" name="efectos[@%db:Efectos.id_efecto%@][id_proveedor]" value="@%db:Proveedores.id_proveedor;%@" />
 <input type="hidden" name="efectos[@%db:Efectos.id_efecto%@][ref_factura]" value="@%db:Facturas.referencia;%@" />
 <input type="hidden" name="efectos[@%db:Efectos.id_efecto;%@][cc_efectos]" value="@%db:Proveedores_empresas.cc_efectos;%@" />
 <input type="hidden" name="efectos[@%db:Efectos.id_efecto%@][monto]" value="@%db:Efectos.monto;%@" />
 <input type="hidden" name="efectos[@%db:Efectos.id_efecto%@][old_fecha]" value="@%db:colocar_fecha{Efectos.fecha_vencimiento};%@" />
 <input type="hidden" name="efectos[@%db:Efectos.id_efecto%@][importe]" value="@%calc:Efectos.monto - Efectos.monto_pagado;output|1;%@" /></td>

<td><a href="?seccion=modif_efectos_proveedor&id_efecto=@%db:Efectos.id_efecto;%@"><img src="imag/hojablanco.jpg" border="0" />@%db:Efectos.concepto;%@</a></td>

<td>@%db:Efectos.medio_pago%@</td>

<td>
 <input type="text" name="efectos[@%db:Efectos.id_efecto%@][fecha_vencimiento]" size="10" maxsize="10"
value="@%db:colocar_fecha{Efectos.fecha_vencimiento};%@" /></td>

<td>@%db:Efectos.monto%@</td>

<td>@%db:Efectos.monto_pagado%@</td>

<td class="estado" ><img src="imag/pixel.png" class="@%func:estado_efecto;Efectos.emitido;Efectos.devuelto;Efectos.pagado;noemitido;emitido;abonado;devuelto;%@" /></td>

 </tr>
@%end-where:%@

</tbody></table>
</form>

 @%plt:botonera%@

<table class="full">
<caption class="titulotb" >Legenda</caption>
<tr>
<td class="etiqueta">Estado</td>
<td class="estado" ><img src="imag/pixel.png" class="rojo" /></td>
<td class="etiquetacheck" >Por Emitir</td>
<td class="estado" ><img src="imag/pixel.png" class="amarillo" /></td>
<td class="etiquetacheck" >Emitido</td>
<td class="estado" ><img src="imag/pixel.png" class="verde" /></td>
<td class="etiquetacheck" >Pago</td>
<td class="estado" ><img src="imag/pixel.png" class="negro" /></td>
<td class="etiquetacheck" >Devolvido</td>
</tr>
</table>



