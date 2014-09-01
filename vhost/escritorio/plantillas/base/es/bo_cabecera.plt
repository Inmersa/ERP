
<div id="encabezadohtml">
<div id="logoempresa"><img src="images/pixel.png" class="null"/></div>
<div id="logoinmersa" class="nacional"><a href="?seccion=@%func:get_from_user;desktop_subsec%@"><img src="images/pixel.png" class="null"/></a><span class="fecha" >@%func:colocar_fecha;now;%@</span></div>
</div>

<div id="BarraGeneral">
<div id="accesosdir">
Accesos directos: 
@%if:AllowedLink;nuevo_pedido_compra;%@
<a href="?seccion=nuevo_pedido_compra&pedido=1">Comprar</a>
@%end-if:%@
@%if:AllowedLink;nuevo_pedidos_ventas;%@
<a href="?seccion=nuevo_pedidos_ventas&pedido=1">Vender</a>
@%end-if:%@
@%if:AllowedLink;bo_facturas_compra;%@
<a href="?seccion=bo_facturas_compra">Facturas de compra</a>
@%end-if:%@
@%if:AllowedLink;bo_facturas_venta;%@
<a href="?seccion=bo_facturas_venta">Facturas de venta</a>
@%end-if:%@

@%if:esta_vacio;oPedido_en_curso;%@
@%else:%@
 @%if:esta_vacio;link_pedido_en_curso;%@
 @%else:%@
 <a href="?seccion=@%get:link_pedido_en_curso;%@">Pedido</a>
 @%end-if:%@
@%end-if:%@
</div>

 <div id="AccionesGenerales"><ul>
 <!-- li><a href="?seccion=@%func:ss_volver;%@" class="volver" ><img src="images/pixel.png" class="null" /></a></li -->
 <li><a href="#" onclick="window.print();" class="imprimir" ><img src="images/pixel.png" class="null" alt="Imprimir"/></a></li>
 @%if:hay_ayuda;%@
 <li><a href="Ayuda" onClick="return abrir_ayuda('?seccion=ayuda&id_sub=@%get:ayuda_id%@');" class="ayuda"><img src="images/pixel.png" alt="Consultar la Ayuda" class="null"></a></li>
 @%end-if:%@
 <li><a href="?logout=1" class="logout" ><img src="images/pixel.png" alt="LogOut" class="null" /></a></li>
 </ul></div>

 <div id="usuario">Usuario: @%func:get_from_user;user_name;%@</div>

</div>

<div id="tabs">
<ul>
@%if:esta_vacio;usr_ss_ficha;%@
@%else:%@
<li 
@%if:nombre_seccion;usr_desktop_name;%@
id="current"
@%end-if:%@
><a href="?seccion=@%get:usr_ss_ficha;%@">Home</a></li>
@%end-if:%@


@%if:equals;clientes;usr_desktop_name;%@
@%else:%@
	@%if:AllowedLink;bo_clientes%@
	<li 
	@%if:nombre_seccion;clientes%@
	id="current"
	@%end-if:%@
	><a href="?seccion=bo_clientes">Clientes</a></li>
	@%end-if:%@
@%end-if:%@

@%if:equals;empresas;usr_desktop_name;%@
@%else:%@
	@%if:AllowedLink;modif_miempresa;%@
	<li 
	@%if:nombre_seccion;empresas%@
	id="current"
	@%end-if:%@
	><a href="?seccion=modif_miempresa">Empresas</a></li>
	@%end-if:%@
@%end-if:%@

@%if:equals;proveedores;usr_desktop_name;%@
@%else:%@
	@%if:AllowedLink;bo_proveedores;%@
	<li 
	@%if:nombre_seccion;proveedores%@
	id="current"
	@%end-if:%@
	><a href="?seccion=bo_proveedores">Proveedores</a></li>
	@%end-if:%@
@%end-if:%@

@%if:equals;articulos;usr_desktop_name;%@
@%else:%@
	@%if:AllowedLink;bo_articulos;%@
	<li 
	@%if:nombre_seccion;articulos%@
	id="current"
	@%end-if:%@
	><a href="?seccion=bo_articulos">Art�culos</a></li>
	@%end-if:%@
@%end-if:%@

@%if:equals;almacenes;usr_desktop_name;%@
@%else:%@
	@%if:AllowedLink;bo_almacenes;%@
	<li 
	@%if:nombre_seccion;almacenes%@
	id="current"
	@%end-if:%@
	><a href="?seccion=bo_almacenes">Almacenes</a></li>
	@%end-if:%@
@%end-if:%@

@%if:equals;compras;usr_desktop_name;%@
@%else:%@
	@%if:AllowedLink;bo_pedidos_compras;%@
	<li 
	@%if:nombre_seccion;compras%@
	id="current"
	@%end-if:%@
	><a href="?seccion=bo_pedidos_compras">Compras</a></li>
	@%end-if:%@
@%end-if:%@

@%if:equals;ventas;usr_desktop_name;%@
@%else:%@
	@%if:AllowedLink;bo_pedidos_ventas;%@
	<li 
	@%if:nombre_seccion;ventas%@
	id="current"
	@%end-if:%@
	><a href="?seccion=bo_pedidos_ventas">Ventas</a></li>
	@%end-if:%@
@%end-if:%@

@%if:equals;agentes;usr_desktop_name;%@
@%else:%@
	@%if:AllowedLink;bo_agentes;%@
	<li 
	@%if:nombre_seccion;agentes%@
	id="current"
	@%end-if:%@
	><a href="?seccion=bo_agentes">Agentes</a></li>
	@%end-if:%@
@%end-if:%@

@%if:equals;configuracion;usr_desktop_name;%@
@%else:%@
	@%if:AllowedLink;bo_maestros;%@
	<li 
	@%if:nombre_seccion;configuracion%@
	id="current"
	@%end-if:%@
	><a href="?seccion=bo_maestros">Configuraci�n</a></li>
	@%end-if:%@
@%end-if:%@
</ul>
</div>

 
