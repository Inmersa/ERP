@%where:nodb|nodb_order_data;nombre|general;format_name|classDocument;%@

<fieldset id="Factura_Cliente_Datosgenerales" class="fsficha">
<legend>Factura</legend>

@%if:esta_vacio;factura_abono;%@
@%if:!emitida;%@
	@%where:nodb|nodb_reciever_data;nombre|receptor;%@
		<div class="AccionesFicha" ><ul>
		<li><a href="#" onClick="return sendForm('factura','accion_ejecutar','CargarCuenta');"  class="cargarpendiente" 
			><img src="imag/pixel.png" class="icono" /><span>Encarregar desde a Conta</span></a></li>
		</ul></div>
	@%end-where:%@

@%end-if:%@
@%end-if:%@

<table class="full">
<tr>
<td class="etiqueta">Referência:</td>
<td>@%db:referencia;%@</td>
<td class="etiqueta">Ref. Externa:</td>
<td >
 @%if:emitida;%@
 @%db:referencia_externa;%@
 @%else:%@
 <input type="hidden" name="factura[referencia_externa_old]" value="@%db:referencia_externa;%@" />
 <input type="text" name="factura[referencia_externa]" size="20" value="@%db:referencia_externa;%@" />
 @%end-if:%@
 </td>
</tr>

@%if:esta_vacio;factura_abono;%@
<tr>
@%where:nodb|nodb_order_totals;nombre|tots;%@
<td class="etiqueta" >Total de Conta</td><td colspan="3" >@%db:monto_cuenta;%@</td>
@%end-where:%@

</tr>
@%end-if:%@

<tr>
<td class="etiqueta">Método de Pagamento:</td>
<td>
 @%if:emitida;%@
@%db:nombre_forma_pago;%@
 @%else:%@
@%set:_selected_value=id_forma_pago;%@
<select name="factura[id_forma_pago]">
@%where:tabla|Forma_pago;nolink|1;order|nombre;%@ 
<option value="@%db:Forma_pago.id_forma_pago;%@" 
@%db:selected_value{Forma_pago.id_forma_pago}%@
>@%db:Forma_pago.nombre;%@</option>
 @%end-where:%@

 </select>
 @%end-if:%@
</td>
<td class="etiqueta">Série de Facturação:</td>
<td>
@%if:emitida;%@
<span>@%db:nombre_serie_facturacion;%@
(@%db:si_no_flag{id_serie_contabilizable};%@)</span>
@%else:%@
<!-- @%set:_selected_value=id_serie;%@ 
@%if:esta_vacio;id_proveedor;%@
@%set:esventa=1;%@
@%else:%@
@%set:esventa=0;%@
@%end-if:%@
-->
<select name="factura[id_serie]">
@%where:tabla|Series_facturacion;no_link|1;where|ventas = $esventa;nombre|series;order|nombre;%@
<option value="@%db:Series_facturacion.id_serie%@"
@%db:selected_value{Series_facturacion.id_serie};%@
>@%db:Series_facturacion.nombre;%@ 
(@%db:si_no_flag{Series_facturacion.contabilizable}%@)</option>
@%end-where:%@

</select>
@%end-if:%@
</td></tr>

<tr><td class="etiqueta">Data:</td>
<td>
 @%if:emitida;%@
 <span>@%db:colocar_fecha{fecha};%@</span>
 @%else:%@
 <input type="hidden" name="factura[fecha_old]" value="@%db:colocar_fecha{fecha};%@" />
 <input type="text" name="factura[fecha]" size="13" value="@%db:colocar_fecha{fecha};%@" size="16" maxlength="20" />
 @%end-if:%@
</td>

<td class="etiqueta @%css:agente;label;%@">Feito por:</td>
<td colspan="2" class="@%css:agente;%@" >
@%if:emitida;%@
@%db:nombre_agente;%@
@%else:%@
<!-- @%db:id_agente%@ @%set:_selected_value=id_agente%@ -->
 <select name="factura[id_agente]">
 @%where:tabla|Agentes;order|nombre;where|Agentes.id_empresa = $id_empresa;nolink|1;%@
 <option value="@%db:Agentes.id_agente%@"
 @%db:selected_value{Agentes.id_agente}%@
>@%db:Agentes.nombre;%@ @%db:Agentes.apellidos;%@</option>
 @%end-where:%@

</select>
@%end-if:%@
</td></tr>

<tr><td class="etiqueta">Notas:</td>
<td colspan="3" ><textarea name="factura[observaciones]" class="longdesc" >@%db:observaciones;%@</textarea></td></tr>

</table>

@%if:!esta_vacio;factura_abono;%@
<input type="hidden" name="factura[_old_factura_abono]" value="@%db:factura_abono;%@" />
<table class="full" ><tbody><tr>
<td class="etiqueta" >Forma de Creditar</td>

<td class="check" >
@%if:emitida;%@
	@%if:equals;factura_abono;1;%@
	Sim
	@%else:%@
	Não
	@%end-if:%@
@%else:%@
	<input type="radio" name="factura[factura_abono]" value="1" 
	@%if:equals;factura_abono;1;%@
	checked="checked" 
	@%end-if:%@
	/>
@%end-if:%@
</td>
<td class="etiquetacheck" >Subtrair dos Ordens de Pagamento e acrescentar à Conta</td>

<td class="check" >
@%if:emitida;%@
	@%if:equals;factura_abono;2;%@
	Sim
	@%else:%@
	Não
	@%end-if:%@
@%else:%@
	<input type="radio" name="factura[factura_abono]" value="2" 
	@%if:equals;factura_abono;2;%@
	checked="checked" 
	@%end-if:%@
	/>
@%end-if:%@
</td>
<td class="etiquetacheck" >Subtrair dos Ordens de Pagamento e acrescentar um Reembolso</td>

<td class="check" >
@%if:emitida;%@
	@%if:equals;factura_abono;3;%@
	Sim
	@%else:%@
	Não
	@%end-if:%@
@%else:%@
	<input type="radio" name="factura[factura_abono]" value="3" 
	@%if:equals;factura_abono;3;%@
	checked="checked" 
	@%end-if:%@
	/>
@%end-if:%@
</td>
<td class="etiquetacheck" >Crédito em Reembolso</td>

<td class="check" >
@%if:emitida;%@
	@%if:equals;factura_abono;4;%@
	Sim
	@%else:%@
	Não
	@%end-if:%@
@%else:%@
	<input type="radio" name="factura[factura_abono]" value="4" 
	@%if:equals;factura_abono;4;%@
	checked="checked" 
	@%end-if:%@
	/>
@%end-if:%@
</td>
<td class="etiquetacheck" >Crédito em Conta</td>

</tr></tbody></table>
@%end-if:%@

<!-- @%set:idfra=id_factura;%@ -->
@%where:tabla|Pedidos_facturas;where|Pedidos_facturas.id_factura = $idfra;group|Pedidos.id_pedido;%@
   @%if:primera_vez;%@
	<table class="full" >
	<caption class="titulotb" >Encomendas:<caption><tbody>
   @%else:%@
	</tr><tr>
   @%end-if:%@ 

	<!-- @%db:Pedidos_facturas.id_factura;%@ @%db:Pedidos.id_direccion;%@ @%db:Pedidos.id_proveedor;%@ -->
   @%if:esta_vacio;Pedidos.id_proveedor;%@
	<td >
	@%if:AllowedLink;bo_pedido_cliente;%@
	<a href="?seccion=bo_pedido_cliente&id_pedido=@%db:Pedidos.id_pedido;%@">@%db:Pedidos.referencia;%@</a>
	@%else:%@
	@%db:Pedidos.referencia;%@
	@%end-if:%@
	</td>
   @%else:%@
   	<td>
	@%if:AllowedLink;bo_pedido_proveedor;%@
	<a href="?seccion=bo_pedido_proveedor&id_pedido=@%db:Pedidos.id_pedido;%@">@%db:Pedidos.referencia;%@</a>
	@%else:%@
	@%db:Pedidos.referencia;%@
	@%end-if:%@
	</td>
   @%end-if:@
   <td >@%db:colocar_fecha{Pedidos.fecha}%@</td>
   <td >
   @%if:AllowedLink;bo_pedidos_agentes;%@
   	<a href="?seccion=bo_pedidos_agentes&id_agente=@%db:Agentes.id_agente;%@" >@%db:Agentes.nombre%@ @%db:Agentes.apellidos;%@</a>
   @%else:%@
   	@%db:Agentes.nombre%@ @%db:Agentes.apellidos;%@
   @%end-if:%@
   </td><td>@%db:sum(IVAs.monto) as 'Facturas.base_imponible';%@</td>
@%end-where:%@
 
</tbody></table>

@%if:esta_vacio;factura_abono;%@
	@%where:nombre|Fras;where|Facturas_abonos.id_factura = $idfra;nolink|1;contador|cnt;%@
		<!-- @%db:Facturas_abonos.id_factura_abono;%@ @%set:id_fra_abono = Facturas_abonos.id_factura_abono;%@ @%set:cnt=cnt;%@ -->
		@%where:nombre|FrasAbono;where|Facturas.id_factura = $id_fra_abono;%@
		<!-- @%db:Facturas.id_cliente;%@ @%db:Facturas.id_proveedor;%@ -->
		@%if:equals;cnt;1;%@
		<table class="full" >
		<caption class="titulotb" >Notas de Crédito relacionadas</caption><tbody>
		@%end-if:%@

		<tr><td>
		@%if:esta_vacio;Facturas.id_cliente;%@
			<a href="?seccion=bo_factura_proveedor&id_factura=@%db:Facturas.id_factura;%@" >@%db:Facturas.referencia;%@</a>
		@%else:%@
			<a href="?seccion=bo_factura_cliente&id_factura=@%db:Facturas.id_factura;%@" >@%db:Facturas.referencia;%@</a>
		@%end-if:%@
		</td>
		<td>@%db:colocar_fecha{Facturas.fecha}%@</td>
		<td ><!-- @%db:Facturas.id_agente;%@ @%set:idfra_ag = Facturas.id_agente;%@ -->
		   @%where:nombre|AgenteFra;where|Agentes.id_agente = $idfra_ag;%@
		   @%if:AllowedLink;bo_facturas_agente;%@
			<a href="?seccion=bo_facturas_agente&id_agente=@%db:Agentes.id_agente;%@" >@%db:Agentes.nombre%@ @%db:Agentes.apellidos;%@</a>
		   @%else:%@
			@%db:Agentes.nombre%@ @%db:Agentes.apellidos;%@
		   @%end-if:%@
		   @%end-where:%@

		</td><td>@%db:Facturas.base_imponible;%@</td>
		</tr>
		@%end-where:%@

	@%end-where:%@

	@%if:!esta_vacio;cabecera_puesta;%@
	</tbody></table>
	@%set:cabecera_puesta=0;%@
	@%set:reset_listados=1;%@
	@%end-if:%@
@%end-if:%@

@%if:!esta_vacio;factura_abono;%@
	<table class="full" >
	<caption class="titulotb" >Facturas que credita</caption><tbody>
	@%where:nombre|Fras;where|Facturas_abonos.id_factura_abono = $idfra;nolink|1;contador|cnt;%@
		<!-- @%db:Facturas_abonos.id_factura;%@ @%set:id_fra = Facturas_abonos.id_factura;%@ -->
		<!-- @%db:Facturas.id_cliente;%@ @%db:Facturas.id_proveedor;%@ -->
		<tr><td>
		@%if:esta_vacio;Facturas.id_cliente;%@
			<a href="?seccion=bo_factura_proveedor&id_factura=@%db:Facturas.id_factura;%@" >@%db:Facturas.referencia;%@</a>
		@%else:%@
			<a href="?seccion=bo_factura_cliente&id_factura=@%db:Facturas.id_factura;%@" >@%db:Facturas.referencia;%@</a>
		@%end-if:%@
		</td><td>@%db:colocar_fecha{Facturas.fecha}%@</td>
		<td ><!-- @%db:Facturas.id_agente;%@ @%set:idfra_ag = Facturas.id_agente;%@ -->
		   @%where:nombre|AgenteFra;where|Agentes.id_agente = $idfra_ag;%@
		   @%if:AllowedLink;bo_facturas_agente;%@
			<a href="?seccion=bo_facturas_agente&id_agente=@%db:Agentes.id_agente;%@" >@%db:Agentes.nombre%@ @%db:Agentes.apellidos;%@</a>
		   @%else:%@
			@%db:Agentes.nombre%@ @%db:Agentes.apellidos;%@
		   @%end-if:%@
		   @%end-where:%@

		</td><td>@%db:Facturas.base_imponible;%@</td>
		</tr>
	@%end-where:%@

	</tbody></table>
@%end-if:%@
@%end-if:%@

@%if:emitida;%@
@%where:tabla|Efectos;where|Efectos.id_factura = $idfra;nombre|Efectos;contador|cnt;%@
<!-- @%db:Efectos.id_efecto;%@ @%db:Facturas.id_cliente;%@ @%db:Facturas.id_proveedor;%@ -->
@%if:equals;cnt;1;%@
<table class="full" ><caption class="titulotb" >Ordens de Pagamento</caption>
<thead ><tr><td>Data de Vencimento</td><td>Total</td><td>Total Pago</td></tr>
<tbody>
@%set:cabecera_puesta=1;%@
@%end-if:%@
<tr><td>
@%if:esta_vacio;Facturas.id_cliente;%@
	@%if:AllowedLink;modif_efectos_proveedor;%@
	<a href="?seccion=modif_efectos_proveedor&id_efecto=@%db:Efectos.id_efecto;%@" >@%db:colocar_fecha{Efectos.fecha_vencimiento};%@</a>
	@%else:%@
	@%db:colocar_fecha{Efectos.fecha_vencimiento};%@
	@%end-if:%@
@%else:%@
	@%if:AllowedLink;modif_efectos_cliente;%@
	<a href="?seccion=modif_efectos_cliente&id_efecto=@%db:Efectos.id_efecto;%@" >@%db:colocar_fecha{Efectos.fecha_vencimiento};%@</a>
	@%else:%@
	@%db:colocar_fecha{Efectos.fecha_vencimiento};%@
	@%end-if:%@
@%end-if:%@
</td>
<td>@%db:Efectos.monto;%@</td>
<td>@%db:Efectos.monto_pagado;%@</td>
</tr>
@%end-where:%@

@%if:!esta_vacio;cabecera_puesta;%@
</tbody></table>
@%set:cabecera_puesta=0;%@
@%set:reset_listados=1;%@
@%end-if:%@

@%where:tabla|Efectos;where|Efectos_parciales.id_factura_abono = $idfra;nombre|EfectosParciales;contador|cnt;%@
@%if:equals;cnt;1;%@
<table class="full" >
<caption class="titulotb" >Ordens de Pagamento que credita</caption><tbody>
@%set:cabecera_puesta=1;%@
@%end-if:%@
<!-- @%db:Efectos_parciales.id_efecto_parcial;%@ @%db:Efectos.id_efecto;%@ @%db:Facturas.id_cliente;%@ @%db:Facturas.id_proveedor;%@ -->
<tr><td>@%db:Efectos.concepto;%@</td>
<td>
@%if:esta_vacio;Facturas.id_cliente;%@
	@%if:AllowedLink;modif_efectos_proveedor;%@
	<a href="?seccion=modif_efectos_proveedor&id_efecto=@%db:Efectos.id_efecto;%@" >@%db:colocar_fecha{Efectos.fecha_vencimiento};%@</a>
	@%else:%@
	@%db:colocar_fecha{Efectos.fecha_vencimiento};%@
	@%end-if:%@
@%else:%@
	@%if:AllowedLink;modif_efectos_cliente;%@
	<a href="?seccion=modif_efectos_cliente&id_efecto=@%db:Efectos.id_efecto;%@" >@%db:colocar_fecha{Efectos.fecha_vencimiento};%@</a>
	@%else:%@
	@%db:colocar_fecha{Efectos.fecha_vencimiento};%@
	@%end-if:%@
@%end-if:%@
</td>
<td >@%db:Efectos.monto;%@</td>
<td >@%db:colocar_fecha{Efectos_parciales.fecha};%@</td>
<td >@%db:Efectos_parciales.monto_satisfecho;%@</td>
</tr>
@%end-where:%@

@%if:!esta_vacio;cabecera_puesta;%@
</tbody></table>
@%set:cabecera_puesta=0;%@
@%end-if:%@

@%end-if:%@


</fieldset>
