@%where:nodb|nodb_order_data;nombre|basedocumento;format_name|classDocument%@

<div class="tituloseccion">&gt; CONFIRMAR 
@%if:esta_vacio;es_pedido;%@
 @%if:esta_vacio;es_factura;%@
     @%if:esta_vacio;es_presupuesto;%@
	Factura Proforma 
     @%else:%@
	PRESUPUESTO 
     @%end-if:%@
 @%else:%@ 
     @%if:esta_vacio;factura_abono;%@
 	Factura 
     @%else:%@
     	Factura de Abono
     @%end-if:%@
 @%end-if:%@ 
@%else:%@ 
Pedido 
@%end-if:%@ 
</div>

<form name="hacer_pedido" method="post" action="?seccion=@%get:send_form_to;%@">
@%if:!esta_vacio;es_pedido%@
 @%if:AllowedAction;Pedidos_tipo_proveedor;new;%@
 <div class="barraoscurai"> <input type="checkbox" name="pedido_tipo" value="1" /> Convertir en pedido tipo </div>
 @%end-if:%@
@%end-if:%@ 

@%plt:Datos_Generales;%@

@%plt:Datos_Pedido;%@

@%plt:Detalle_Pedido;%@

@%plt:Impuestos_Descuentos_Pedido;%@

@%plt:Totales_Pedido;%@

 <input type="hidden" name="Confirmar" value="Confirmar" />
 </form>

 <div class="AccionesEnvio"><ul>
 <li><a href="#" onclick="return sendForm('hacer_pedido');" class="guardar" ><img src="images/pixel.png" class="icono" /><span>Confirmar</span></a>
 </ul></div>

