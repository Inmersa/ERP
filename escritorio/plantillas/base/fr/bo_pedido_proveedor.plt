@%where:nodb|nodb_order_data;nombre|base;%@

<form name="__emaildoc__" action="?@%get:_krn_ss_querystring;%@&imprimir=1&__stdout__=email" method="post">
<div class="barraoscura">
<div class="titsuperior">&gt; Commande :@%db:nombre;%@</div><div class="alinder"
><input type="text" name="_email" size="20" value="@%func:document_emails;%@">
<input type="hidden" name="_subject" size="20" value="@%db:referencia;%@">
<input type="image" name="submit" src="imag/iconos/enviar_mail.png" onClick="return SendFormToWindow('__emaildoc__',null,'__emailwin__',null,null,1);" />
<a href="#" onclick=window.open('?@%env:QUERY_STRING%@&imprimir=1'); return false; class="accesos">Imprimer</a>

</div></div> 
</form>


<form name="pedido" action="?seccion=bo_pedido_proveedor" method="post">
<input type="hidden" name="accion_ejecutar" value="Modificar">
<input type="hidden" name="identificador_pedido" value="@%db:id_pedido%@">
<!-- @%set:id_documento=id_pedido%@ -->

@%plt:Datos_Proveedor;%@ 

@%plt:Datos_Pedido;%@ 

@%plt:Lineas_Detalle%@ 

@%plt:Impuestos_Descuentos%@ 

@%plt:Totales_Pedido%@ 

 </form>

<div class="AccionesEnvio">
<ul>
@%if:nomodificar_detalles;%@
<li><a href="?seccion=bo_facturas_pedido_compra&id_pedido=@%db:id_pedido;%@" class="verfras" ><img src="imag/pixel.png" class="icono" /><span>Voir</span></a></li>
@%else:%@
<li><a href="#" onclick="return sendForm('pedido');" class="guardar" ><img src="imag/pixel.png" class="icono" /><span>Garder</span></a></li>
@%end-if:%@
 
@%if:hay_albaran%@
<li><a href="?seccion=bo_albaranes_pedido&id_pedido=@%db:id_pedido;%@" class="veralbs" ><img src="imag/pixel.png" class="icono" /><span>Voir livraisons</span></a></li>
@%else:%@
@%end-if:%@ 
</ul>
</div>

@%if:hay_factura%@
@%else:%@
@%plt:Facturar_Proveedor%@ 
@%end-if:%@

 @%plt:incidencias%@


@%end-if:%@
@%func:post_pedido_proveedor%@
@%end-where:%@
