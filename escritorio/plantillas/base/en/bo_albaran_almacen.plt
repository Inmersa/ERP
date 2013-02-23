@%where:tabla|Albaranes;where|Albaranes.id_albaran = $id_albaran;%@

FIXME: Quitar este where, y poner el Iface de Instancia.<br/>
<!--@%db:Albaranes.id_albaran;%@-->
<!--@%db:Albaranes.preparado;%@-->
<!--@%db:Albaranes.enviado;%@-->
<!--@%db:Albaranes.confirmacion;%@-->
<!--@%db:Albaranes.devolucion;%@-->

<form name="__emaildoc__" action="?seccion=bo_albaran_envio_print&id_albaran=@%db:Albaranes.id_albaran;%@&__stdout__=email" method="post">
<input type="hidden" name="_subject" value="@%db:Albaranes.referencia;%@" />
<div class="tituloseccion">&gt; Delivery Notes:</div>

<div id="AccionesEncabezado" >
<ul>
<li class="noicon" ><input type="text" name="_email" size="20" value="@%func:document_emails;%@"></li>
<li class="noicon" ><input type="image" name="submit" src="imag/iconos/enviar_mail.png" onClick="return SendFormToWindow('__emaildoc__',null,'__emailwin__');" /></li>
@%if:AllowedAction;Albaranes;edit;%@
@%if:!esta_vacio;Albaranes.devolucion;%@
<li><a href="#" onclick="return SendFormToWindow('bo_albaran_almacen','bo_albaran_devolucion_print&id_albaran=@%db:Albaranes.id_albaran%@','__printdevolucion__');" class="devolucionprint"><img src="images/pixel.png" class="icono" /><span>Print Refund</span></a></li>
@%end-if:%@
<li><a href="#" onclick="return !window.open('?seccion=bo_albaran_envio_print&id_albaran=@%db:Albaranes.id_albaran%@');" class="envioprint" ><img src="images/pixel.png" class="icono" /><span>Print Order</span></a></li>
<li><a href="#" onclick="window.open('?@%get:_krn_ss_querystring;%@&imprimir=1');" return false;" class="inicioprint"><img src="images/pixel.png" class="icono" /><span>Print Start</span></a></li>
@%end-if:%@
</ul></div>
<!--@%set:id_documento=Albaranes.id_albaran%@-->
</form>

<form name="bo_albaran_almacen" method="post" action="?seccion=bo_albaran_almacen">
<input type="hidden" name="accion_ejecutar" value="Modificar" />
<input type="hidden" name="registro[id_albaran]" value="@%db:Albaranes.id_albaran;%@" />

@%plt:Datos_Generales%@
@%plt:Datos_Albaran%@
@%plt:Detalle%@
</form>

@%if:AllowedAction;Albaranes;edit;%@
<div class="AccionesEnvio"><ul>
<li><a href="#" onclick="return onHRefClick('bo_albaran_almacen','accion_ejecutar','Modificar');" class="guardar"><img src="images/pixel.png" class="icono" /><span>Modify</span></a></li>
</ul></div>
@%end-if:%@

@%plt:incidencias%@

@%end-where:%@
