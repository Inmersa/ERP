@%where:nodb|nodb_order_data;nombre|base;%@
<form name="__emaildoc__" action="?@%get:_krn_ss_querystring;%@&imprimir=1&__stdout__=email" method="post">
<input type="hidden" name="_subject" size="20" value="@%db:referencia;%@">

<div class="tituloseccion">&gt; 
@%if:esta_vacio;es_proforma;%@
Pressuposts 
@%else:%@
Factura Proforma 
@%end-if:%@
:@%db:nombre;%@</div>


<!-- @%set:id_rfq=id_rfq;value|var;%@ -->

<div id="AccionesEncabezado" >
<ul>
<li class="noicon" ><input type="text" name="_email" size="20" value="@%func:document_emails;%@" 
	/><img src="imag/iconos/enviar_mail.png" onClick="return SendFormToWindow('__emaildoc__',null,'__emailwin__',null,null,1);" 
	/></li>
</form>

@%if:equals;estado;0;%@
@%if:AllowedAction;RFQ_estado;new;%@
<li><a href="#Revisar Seleccionados" onclick="return onHRefClick('pedido','accion_ejecutar','Revisar');" class="revisar"
><img src="images/pixel.png" class="icono" /><span>Revisar</span></a></li>
@%end-if:%@
@%end-if:%@

@%if:equals;estado;1;%@
@%if:AllowedAction;RFQ_estado;edit;%@
<li><a href="#Aprobar Seleccionados" onclick="return onHRefClick('pedido','accion_ejecutar','Aprobar');" class="aprobar"
><img src="images/pixel.png" class="icono" /><span>Aprovar</span></a></li>

<li><a href="#Rechazar Seleccionados" onclick="return onHRefClick('pedido','accion_ejecutar','Rechazar');" class="rechazar"
><img src="images/pixel.png" class="icono" /><span>Rebutjar</span></a></li>
@%end-if:%@
@%end-if:%@

@%if:equals_any;estado;2;%@
	@%if:AllowedAction;RFQ_estado;del;%@
	<!-- @%set:id_cli=id_cliente;%@ -->
	<li class="noicon" ><form name="pedido" action="?seccion=bo_presupuesto_cliente" method="post">
	<select name="pedido[id_direccion]">
	@%where:tabla|Direcciones_entrega;nolink|1;where|id_cliente = $id_cli;%@
	<option value="@%db:Direcciones_entrega.id_direccion;%@" >@%db:Direcciones_entrega.nombre;%@</option>
	@%end-where:%@

	</select></li>
	<li><a href="#" onclick="return onHRefClick('pedido','accion_ejecutar','Consolidar');" class="consolidar"
	><img src="images/pixel.png" class="icono" /><span>Consolidar</span></a></li>
	@%end-if:%@
@%else:%@
	<li class="noicon" ><form name="pedido" action="?seccion=bo_presupuesto_cliente" method="post"></li>
@%end-if:%@

@%if:esta_vacio;es_proforma;%@
@%if:equals_any;estado;0;1;2;%@
	@%if:AllowedAction;RFQ_estado;del;%@
	<li><a href="#Convertir a Proforma" onclick="return onHRefClick('listado','accion_ejecutar','ConvertirProforma');" class="aproforma"
	><img src="images/pixel.png" class="icono" /><span>Convertir en Proforma</span></a></li>
	@%end-if:%@
@%end-if:%@
@%end-if:%@

@%if:esta_vacio;id_rfq;%@
	<li><a href="?seccion=rfqs&modo_seleccion=1" class="enlazarrfq" ><img src="images/pixel.png" class="icono" /><span>Seleccionar {{label_rfq}}</span></a></li>
@%end-if:%@

<li><a href="#" onclick="window.open('?@%env:QUERY_STRING%@&imprimir=1'); return false;" class="imprimir"><img 
src="images/pixel.png" class="icono" /><span>Imprimir</span></a></li>

</ul>
</div>

<input type="hidden" name="accion_ejecutar" value="Modificar" />
<input type="hidden" name="identificador_presupuesto" value="@%db:id_presupuesto;%@" />

@%plt:Datos_Generales;%@ 

@%plt:Datos_Presupuesto;%@ 

@%if:esta_vacio;LinkCRM;%@
@%else:%@
@%plt:RFQ;%@
@%end-if:%@

@%plt:Lineas_Detalle%@ 

@%plt:Impuestos_Descuentos;%@ 

@%plt:Totales_Pedido%@ 

@%if:nomodificar_detalles;%@
@%else:%@
<div class="AccionesEnvio"><ul>
<li><a href="#" onclick="return sendForm('pedido');" class="guardar" ><img src="images/pixel.png" class="icono" /><span>Guardar Canvis</span></a></li>
</ul></div>
@%end-if:%@ 

</form>

@%if:esta_vacio;LinkCRM;%@
@%else:%@
<!-- @%set:id_presupuesto = id_presupuesto;%@ -->
@%plt:Documentos;%@
@%end-if:%@

@%func:post_pedido_cliente%@

@%end-where:%@
