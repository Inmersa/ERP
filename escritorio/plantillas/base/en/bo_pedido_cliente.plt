@%where:nodb|nodb_order_data;nombre|base;%@
<form name="__emaildoc__" action="?@%get:_krn_ss_querystring;%@&imprimir=1&__stdout__=email" method="post">

<div class="tituloseccion">&gt; Order :@%db:nombre;%@</div>

<input type="hidden" name="_subject" size="20" value="@%db:referencia;%@">
<div id="AccionesEncabezado" ><ul>
<li class="noicon" ><input type="text" name="_email" size="20" value="@%func:document_emails;%@"></li>
<li class="noicon" ><input type="image" name="submit" src="imag/iconos/enviar_mail.png" 
	onClick="return SendFormToWindow('__emaildoc__',null,'__emailwin__');" /></li>
<li><a href="#" onclick="return !window.open('?@%get:_krn_ss_querystring%@&imprimir=1');" class="imprimir" 
	><img src="images/pixel.png" class="icono" /><span>Print</span></a></li> 
<li><a href="#" onclick="return imprimir_directo('?@%get:_krn_ss_querystring%@&imprimir=1&ticket=1');" class="imprimirticket" 
 	><img src="images/pixel.png" class="icono" /><span>Print Ticket</span></a></li>
</ul></div> 
</form>

<form name="pedido" action="?seccion=bo_pedido_cliente" method="post">
<input type="hidden" name="accion_ejecutar" value="Modificar" />
<input type="hidden" name="identificador_pedido" value="@%db:id_pedido%@" />

@%plt:Datos_Generales;%@ 

@%plt:Datos_Pedido;%@ 

@%plt:Lineas_Detalle%@ 

@%plt:Impuestos_Descuentos;%@ 

@%plt:Totales_Pedido%@ 

</form>

<div class="AccionesEnvio">
<ul>
@%if:nomodificar_detalles;%@
<li><a href="?seccion=bo_facturas_pedido_venta&id_pedido=@%db:id_pedido;%@" class="verfras" ><img src="images/pixel.png" class="icono" /><span>To see</span></a></li>
@%else:%@
<li><a href="#" onclick="return sendForm('pedido');" class="guardar" ><img src="images/pixel.png" class="icono" /><span>Save Changes</span></a></li>
@%end-if:%@
 
@%if:hay_albaran%@
<li><a href="?seccion=bo_albaranes_pedido&id_pedido=@%db:id_pedido;%@" class="veralbs" ><img src="images/pixel.png" class="icono" /><span>To see delivery notes</span></a></li>
@%else:%@
@%end-if:%@ 
</ul>
</div>

@%if:nomodificar_detalles%@
@%else:%@
@%plt:Facturacion%@ 
@%end-if:%@

<!-- @%set:id_documento=id_pedido%@ -->
@%plt:incidencias%@

@%func:post_pedido_cliente%@

