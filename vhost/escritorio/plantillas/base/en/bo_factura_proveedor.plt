@%where:nodb|nodb_order_data;nombre|base;%@
<form name="__emaildoc__" action="?@%get:_krn_ss_querystring;%@&imprimir=1&__stdout__=email" method="post">

<div class="tituloseccion">&gt; &gt; Invoice 
 @%if:emitida;%@
Issued
 @%else:%@
Not Issued
 @%end-if:%@
 </div>

<input type="hidden" name="_subject" size="20" value="@%db:referencia;%@">
<div id="AccionesEncabezado" ><ul >
<li class="noicon" ><input type="text" name="_email" size="20" value="@%func:document_emails;%@"></li>
<li class="noicon" ><input type="image" name="submit" src="imag/iconos/enviar_mail.png" 
	onClick="return SendFormToWindow('__emaildoc__',null,'__emailwin__',null,null,1);" /></li>
@%if:emitida;%@
<li><a href="#" onClick="return onHRefClick('factura','accion_ejecutar','DesEmitir');" class="desemitir" 
	><img src="images/pixel.png" class="icono" /><span>Unissue</span></a></li> 
@%else:%@
<li><a href="#" onClick="return SendFormToWindow('factura','@%get:_krn_ss_name%@&imprimir=1','IssueWin','accion_ejecutar','Emitir');" class="emitir" 
	><img src="images/pixel.png" class="icono" /><span>Issue</span></a></li>
@%end-if:%@
<li><a href="#" onclick="window.open('?@%get:_krn_ss_querystring%@&imprimir=1');" class="imprimir" 
	><img src="images/pixel.png" class="icono" /><span>Print</span></a></li> 
<li><a href="#" onclick="return imprimir_directo('?@%get:_krn_ss_querystring%@&imprimir=1');" class="imprimirdirecto" 
	><img src="images/pixel.png" class="icono" /><span>Direct Print</span></a></li> 
</ul></div>
</form>

<form name="factura" action="?seccion=bo_factura_proveedor" method="post">
<input type="hidden" name="accion_ejecutar" value="Modificar" />
<input type="hidden" name="identificador_factura" value="@%db:id_factura%@" />
<!-- @%set:id_documento=id_factura%@ -->
@%plt:Datos_Generales%@ 

@%plt:Datos_Factura%@ 

@%plt:Detalle_Factura%@ 

@%plt:Impuestos_Descuentos;%@ 

@%plt:Totales_Factura;%@ 
</form>

@%if:emitida%@
@%else:%@
<div class="AccionesEnvio"><ul>
<li><a href="#" onclick="return sendForm('factura');" class="guardar" ><img src="images/pixel.png" class="icono" /><span>Save Changes</span></a></li>
</ul></div>
@%end-if:%@

@%plt:incidencias%@

@%func:post_factura_proveedor%@
