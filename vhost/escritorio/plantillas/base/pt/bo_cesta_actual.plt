@%where:nodb|nodb_order_data;format_name|classDocument;%@

<div class="barraoscurai">Itens Seleccionados : &nbsp;&nbsp;
@%where:nodb|nodb_reciever_data;%@
@%db:razon_social%@ (ID: @%db:id%@)
@%end-where:%@

</div>

 <form name="cesta" method="post" action="@%get:_cesta_sendto;%@">

<table class="full">
<thead>
<tr>
<td class="estado" ><img src="imag/pixel.png" class="marcartodos" onclick="return formCheckAll('articulos_confirmados');"  /></td>
<td >ID</td>
<td >Produto</td>
<td >Marca</td>
<td >Pre�o</td>
<td >Stock E</td>
<td >Stock Total</td>
@%if:!esta_vacio;possible_contracts;%@
<td >Servi�o</td>
@%set:contratos_posibles=1;%@
@%end-if:%@
<td >Quantidade</td>
<td >u/E</td>
<td >e/C</td>
<td >c/P</td>
</tr>
</thead>
<tbody>
@%where:nodb|nodb_order_details;format_name|classDocumentDetail;%@

<input type="hidden" name="cesta[id_unidad_medida][@%db:idx_detalle;%@]" value="@%db:id_unidad_medida;%@" />
<tr><input type="hidden" name="array_detalle[@%db:id_articulo%@]" value="@%db:id_detalle%@" />
<td class="check"><input type="checkbox" name="articulos_confirmados[@%db:idx_detalle;%@]" value="@%db:idx_detalle;%@" 
@%if:esta_vacio;es_reposicion;%@
checked="checked" 
@%else:%@
@%if:!esta_vacio;cantidad;%@
checked="checked" 
@%end-if:%@
@%end-if:%@
/>
<input type="hidden" name="articulos_cesta[@%db:idx_detalle;%@]" value="@%db:idx_detalle;%@" checked /></td>
<td>@%db:id_articulo;%@</td>
<td><a href="?seccion=modif_articulos&id_articulo=@%db:id_articulo;%@">@%db:nombre;%@</a></td>
<td>@%db:nombre_marca;%@</td>
<td>@%db:precio_tarifa;%@@%db:leyenda_divisa%@</td>
<td>@%db:stock_estimado;%@</td>
<td>@%db:stock_real;%@</td>

@%if:!esta_vacio;contratos_posibles;%@
	<td>
	@%if:esta_vacio;available_contracts;%@
	@%else:%@
	@%set:_selected_value=id_servicio;%@
	<select name="servicios[@%db:idx_detalle;%@]">
	<option value="0">Nenhum</option>
	    @%where:nodb|nodb_detail_contracts;%@
		<option value="@%db:id;%@" @%db:selected_value{id}%@ 
		>@%db:nombre;%@</option>
	    @%end-where:%@

		</select>
	@%end-if:%@
	</td>
@%end-if:%@

<td>
@%if:modificable%@
<input type="text" name="cesta[cantidad][@%db:idx_detalle;%@]" value="@%db:cantidad_pack;%@" class="num" />
@%else:%@
@%db:cantidad_pack;%@
@%end-if:%@
<input type="hidden" name="array_ids[@%db:count;%@]" value="@%db:id_articulo;%@" size="5" />
 </td>

</td>
<td class="check" ><input type="checkbox" name="cesta[bultos][@%db:idx_detalle;%@][bultos]" value="1" 
@%if:esta_vacio;bultos;%@
@%else:%@
checked="checked"
@%end-if:%@
 />@%calc:unidades_bulto;round|2;output|1;%@</td>

<td class="check" ><input type="checkbox" name="cesta[bultos][@%db:idx_detalle;%@][capas]" value="1" 
 @%if:esta_vacio;capas;%@
 @%else:%@
 checked="checked"
 @%end-if:%@
/>@%db:bultos_capa_palet;%@</td>

<td class="check" ><input type="checkbox" name="cesta[bultos][@%db:idx_detalle;%@][palets]" value="1" 
 @%if:esta_vacio;palets;%@
 @%else:%@
 checked="checked"
 @%end-if:%@
/>@%db:capas_palet;%@</td>

</tr>
@%end-where:%@

</body>
</table>
<input type="hidden" name="Finalizar" value="Finalizar" />
</form>

<div class="AccionesEnvio">
<ul>
<li><a href="#" onclick="return sendForm('cesta');" class="finalizar" ><img src="imag/pixel.png" class="icono" /><span>Concluir</span></a></li>
<li><a href="?@%env:QUERY_STRING%@&vaciar_pedido=1" class="vaciar" ><img src="imag/pixel.png" class="icono" /><span>Eliminar Itens da Encomenda</span></a></li>
</ul>
</div>
 
@%if:esta_vacio;es_presupuesto;%@
<form name="habituales" method="post" action="?seccion=@%get:ss_nm%@">
<div class="AccionesFicha">
<ul>
<li class="noicon" >Ref. Habituais Desde:</li>
<li class="noicon" ><input type="text" size="14" maxlength="14" name="repo[fecha]" value="dd/mm/aaaa" /></li>
<li><a href="#" onClick="return sendForm('habituales');" class="enviar"><img src="imag/pixel.png" class="icono" />Aceitar</a></li>
</ul>
</div>
</form>
@%end-if:%@

