@%where:nodb|nodb_order_data;nombre|base;%@
<form name="__emaildoc__" action="?@%get:_krn_ss_querystring;%@&imprimir=1&__stdout__=email" method="post">

<div class="tituloseccion">&gt; &gt; 
@%if:esta_vacio;factura_abono;%@
FACTURA 
@%else:%@
Factura de Abono 
@%end-if:%@

 @%if:emitida;%@
 Emitida 
 @%else:%@
 No Emitida 
 @%end-if:%@
 </div>

<input type="hidden" name="_subject" size="20" value="@%db:referencia;%@" />
<div id="AccionesEncabezado" ><ul>
<li class="noicon" ><input type="text" name="_email" size="20" value="@%func:document_emails;%@" /></li>
<li class="noicon" ><input type="image" name="submit" src="imag/iconos/enviar_mail.png" 
	onClick="return SendFormToWindow('__emaildoc__',null,'__emailwin__');" /></li>
@%if:emitida;%@
<li><a href="#" onClick="return onHRefClick('factura','accion_ejecutar','DesEmitir');" class="desemitir" 
	><img src="images/pixel.png" class="icono" /><span>Desemitir</span></a></li> 
@%else:%@
<li><a href="#" onClick="return SendFormToWindow('factura','@%get:_krn_ss_name%@&imprimir=1','IssueWin','accion_ejecutar','Emitir');" class="emitir" 
	><img src="images/pixel.png" class="icono" /><span>Emitir</span></a></li>
@%end-if:%@
<li><a href="#" onclick="return !window.open('?@%get:_krn_ss_querystring%@&imprimir=1');" class="imprimir" 
	><img src="images/pixel.png" class="icono" /><span>Imprimir</span></a></li> 
<li><a href="#" onclick="return imprimir_directo('?@%get:_krn_ss_querystring%@&imprimir=1');" class="imprimirdirecto" 
	><img src="images/pixel.png" class="icono" /><span>Impresion Directa</span></a></li> 
<li><a href="#" onclick="return imprimir_directo('?@%get:_krn_ss_querystring%@&imprimir=1&ticket=1');" class="imprimirticket" 
 	><img src="images/pixel.png" class="icono" /><span>Impresion Ticket</span></a></li>
</ul></div>

</form>

<form name="factura" action="?seccion=bo_factura_cliente" method="post">
<input type="hidden" name="accion_ejecutar" value="Modificar" />
<input type="hidden" name="identificador_factura" value="@%db:id_factura%@" />
<!-- @%set:id_documento=id_factura%@ -->
@%plt:Datos_Generales%@ 

@%plt:Datos_Factura%@ 

@%plt:Detalle_Factura%@ 

@%plt:Impuestos_Descuentos;%@ 

@%plt:Totales_Factura%@ 
</form>

<div class="AccionesEnvio"><ul>
<li><a href="#" onclick="return sendForm('factura');" class="guardar" ><img src="images/pixel.png" class="icono" /><span>Guardar Cambios</span></a></li>
</ul></div>

 <!-- a href="?seccion=bo_albaranes_pedido&id_pedido=@%db:id_pedido;%@" class="accesos">Ver Albaranes</a> -->

 @%plt:incidencias%@


@%func:post_factura_cliente%@

