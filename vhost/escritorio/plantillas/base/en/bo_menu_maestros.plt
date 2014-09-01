@%if:AllowedLink;bo_maestro_bajas_almacen;%@
<div class="menuitem"><a href="?seccion=bo_maestro_bajas_almacen" @%func:querystring_activa;bo_maestro_bajas_almacen;activo;;%@ >Stock Down</a></div>
@%end-if:%@
@%if:AllowedLink;bo_catalogo;%@
<div class="menuitem"><a href="#" onClick="return abrir_ventana('?seccion=bo_catalogo');return false;">Image Catalog</a></div>
@%end-if:%@

@%if:AllowedLink;bo_grupo_familias;%@
<div class="menuitem"> <a href="?seccion=bo_grupo_familias" @%func:querystring_activa;bo_grupo_familias;activo;;%@ >Families Group</a></div>
@%end-if:%@
@%if:AllowedLink;bo_familia_articulos;%@
<div class="menuitem"> <a href="?seccion=bo_familia_articulos" @%func:querystring_activa;bo_familia_articulos;activo;;%@ >Families</a></div>
@%end-if:%@
@%if:AllowedLink;bo_descuento_familia;%@
<div class="menuitem"> <a href="?seccion=bo_descuento_familia" @%func:querystring_activa;bo_descuento_familia;activo;;%@ >Discount by family</a></div>
@%end-if:%@


@%if:AllowedLink;bo_tarifas;%@
<div class="menuitem"><a href="?seccion=bo_tarifas" @%func:querystring_activa;bo_tarifas&;activo;;%@ >Sales Tariff</a></div>
@%end-if:%@
@%if:AllowedLink;bo_forma_pago;%@
<div class="menuitem"> <a href="?seccion=bo_forma_pago" @%func:querystring_activa;bo_forma_pago;activo;;%@ >Payment Methods</a></div>
@%end-if:%@
@%if:AllowedLink;bo_series_facturacion;%@
<div class="menuitem"> <a href="?seccion=bo_series_facturacion" @%func:querystring_activa;bo_series_facturacion;activo;;%@ >Invoicing series</a></div>
@%end-if:%@
@%if:AllowedLink;bo_servicios;%@
<div class="menuitem"> <a href="?seccion=bo_servicios" @%func:querystring_activa;bo_servicios;activo;;%@ >Services</a></div>
@%end-if:%@

@%if:AllowedLink;bo_tipo_agente;%@
<div class="menuitem"> <a href="?seccion=bo_tipo_agente" @%func:querystring_activa;bo_tipo_agente;activo;;%@ >Agent Category</a></div>
@%end-if:%@
@%if:AllowedLink;bo_tipo_cliente;%@
<div class="menuitem"> <a href="?seccion=bo_tipo_cliente" @%func:querystring_activa;bo_tipo_cliente;activo;;%@ >Type of clients</a></div>
@%end-if:%@
@%if:AllowedLink;bo_tipos_iva;%@
<div class="menuitem"><a href="?seccion=bo_tipos_iva" @%func:querystring_activa;bo_tipos_iva;activo;;%@ >VAT Type</a></div>
@%end-if:%@

@%if:AllowedLink;bo_transportistas;%@
<div class="menuitem"> <a href="?seccion=bo_transportistas" @%func:querystring_activa;bo_transportistas;activo;;%@ >Carriers</a></div>
@%end-if:%@
@%if:AllowedLink;bo_tarifas_transporte;%@
<div class="menuitem"> <a href="?seccion=bo_tarifas_transporte" @%func:querystring_activa;bo_tarifas_transporte;activo;;%@ >Fares</a></div>
@%end-if:%@

@%if:AllowedLink;bo_grupos_rutas;%@
<div class="menuitem"> <a href="?seccion=bo_grupos_rutas" @%func:querystring_activa;bo_grupos_rutas;activo;;%@ >Routes group</a></div>
@%end-if:%@
@%if:AllowedLink;bo_gastos;%@
<div class="menuitem"> <a href="?seccion=bo_gastos" @%func:querystring_activa;bo_gastos;activo;;%@ >Expenses</a></div>
@%end-if:%@
@%if:AllowedLink;bo_medios_contacto;%@
<div class="menuitem"> <a href="?seccion=bo_medios_contacto" @%func:querystring_activa;bo_medios_contacto;activo;;%@ >Contact type</a></div>
@%end-if:%@

@%if:AllowedLink;tipos_recurso;%@
<div class="menuitem"><a href="?seccion=tipos_recurso" @%func:querystring_activa;tipos_recurso;activo;;%@ >Resource Types</a></div>
@%end-if:%@
@%if:AllowedLink;recursos;%@
<div class="menuitem"><a href="?seccion=recursos" @%func:querystring_activa;recursos;activo;;%@ >Resources</a></div>
@%end-if:%@
@%if:AllowedLink;tipos_anotacion;%@
<div class="menuitem"><a href="?seccion=tipos_anotacion" @%func:querystring_activa;tipos_anotacion;activo;;%@ >Annotation Types</a></div>
@%end-if:%@
@%if:AllowedLink;estados_servicio;%@
<div class="menuitem"><a href="?seccion=estados_servicio" @%func:querystring_activa;estados_servicio;activo;;%@ >Service Status</a></div>
@%end-if:%@
@%if:AllowedLink;importancias;%@
<div class="menuitem"><a href="?seccion=importancias" @%func:querystring_activa;importancias;activo;;%@ >Importance</a></div>
@%end-if:%@

@%if:AllowedLink;bo_certificados;%@
<div class="menuitem"> <a href="?seccion=bo_certificados" @%func:querystring_activa;bo_certificados;activo;;%@ >Certificate</a></div>
@%end-if:%@
@%if:AllowedLink;bo_divisa;%@
<div class="menuitem"> <a href="?seccion=bo_divisa" @%func:querystring_activa;bo_divisa;activo;;%@ >Currency</a></div>
@%end-if:%@
@%if:AllowedLink;bo_paises;%@
<div class="menuitem"> <a href="?seccion=bo_paises" @%func:querystring_activa;bo_paises;activo;;%@ >Countries</a></div>
@%end-if:%@
@%if:AllowedLink;bo_provincias;%@
<div class="menuitem"> <a href="?seccion=bo_provincias" @%func:querystring_activa;bo_provincias;activo;;%@ >Provinces-States</a></div>
@%end-if:%@
@%if:AllowedLink;tipos_unidadmedida;%@
<div class="menuitem"> <a href="?seccion=tipos_unidadmedida" @%func:querystring_activa;tipos_unidadmedida;activo;;%@ >Unit of measurement Types</a></div>
@%end-if:%@
@%if:AllowedLink;bo_unidades_medida;%@
<div class="menuitem"> <a href="?seccion=bo_unidades_medida" @%func:querystring_activa;bo_unidades_medida;activo;;%@ >Measures</a></div>
@%end-if:%@

@%if:AllowedLink;cfg_anyos;%@
<div class="menuitem"><a href="?seccion=cfg_anyos" @%func:querystring_activa;cfg_anyos;activo;;%@ >Years</a></div>
@%end-if:%@
<!-- 
@%if:AllowedLink;cfg_trimestres;%@
<div class="menuitem"><a href="?seccion=cfg_trimestres" @%func:querystring_activa;cfg_trimestres;activo;;%@ >Trimesters</a></div>
@%end-if:%@
@%if:AllowedLink;cfg_meses;%@
<div class="menuitem"><a href="?seccion=cfg_meses" @%func:querystring_activa;cfg_meses;activo;;%@ >Months</a></div>
@%end-if:%@
@%if:AllowedLink;cfg_semanas;%@
<div class="menuitem"><a href="?seccion=cfg_semanas" @%func:querystring_activa;cfg_semanas;activo;;%@ >Weeks</a></div>
@%end-if:%@
@%if:AllowedLink;cfg_dias;%@
<div class="menuitem"><a href="?seccion=cfg_dias" @%func:querystring_activa;cfg_dias;activo;;%@ >Days</a></div>
@%end-if:%@
-->

@%if:AllowedLink;bo_ayuda;%@
<div class="menuitem"> <a href="?seccion=bo_ayuda" @%func:querystring_activa;bo_ayuda;activo;;%@ >Help</a></div>
@%end-if:%@
