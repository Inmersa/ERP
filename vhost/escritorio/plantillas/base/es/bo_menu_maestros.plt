@%if:AllowedLink;bo_maestro_bajas_almacen;%@
<div class="menuitem"><a href="?seccion=bo_maestro_bajas_almacen" @%func:querystring_activa;bo_maestro_bajas_almacen;activo;;%@ >Bajas de Almacén</a></div>
@%end-if:%@
@%if:AllowedLink;bo_catalogo;%@
<div class="menuitem"><a href="#" onClick="return abrir_ventana('?seccion=bo_catalogo');return false;">Catálogo de imágenes</a></div>
@%end-if:%@

@%if:AllowedLink;bo_grupo_familias;%@
<div class="menuitem"> <a href="?seccion=bo_grupo_familias" @%func:querystring_activa;bo_grupo_familias;activo;;%@ >Grupo familias</a></div>
@%end-if:%@
@%if:AllowedLink;bo_familia_articulos;%@
<div class="menuitem"> <a href="?seccion=bo_familia_articulos" @%func:querystring_activa;bo_familia_articulos;activo;;%@ >Familias</a></div>
@%end-if:%@
@%if:AllowedLink;bo_descuento_familia;%@
<div class="menuitem"> <a href="?seccion=bo_descuento_familia" @%func:querystring_activa;bo_descuento_familia;activo;;%@ >Dto. por familia</a></div>
@%end-if:%@


@%if:AllowedLink;bo_tarifas;%@
<div class="menuitem"><a href="?seccion=bo_tarifas" @%func:querystring_activa;bo_tarifas&;activo;;%@ >Tarifas venta</a></div>
@%end-if:%@
@%if:AllowedLink;bo_forma_pago;%@
<div class="menuitem"> <a href="?seccion=bo_forma_pago" @%func:querystring_activa;bo_forma_pago;activo;;%@ >Formas pago</a></div>
@%end-if:%@
@%if:AllowedLink;bo_series_facturacion;%@
<div class="menuitem"> <a href="?seccion=bo_series_facturacion" @%func:querystring_activa;bo_series_facturacion;activo;;%@ >Series de facturación</a></div>
@%end-if:%@
@%if:AllowedLink;bo_servicios;%@
<div class="menuitem"> <a href="?seccion=bo_servicios" @%func:querystring_activa;bo_servicios;activo;;%@ >Servicios</a></div>
@%end-if:%@

@%if:AllowedLink;bo_tipo_agente;%@
<div class="menuitem"> <a href="?seccion=bo_tipo_agente" @%func:querystring_activa;bo_tipo_agente;activo;;%@ >Tipos agentes</a></div>
@%end-if:%@
@%if:AllowedLink;bo_tipo_cliente;%@
<div class="menuitem"> <a href="?seccion=bo_tipo_cliente" @%func:querystring_activa;bo_tipo_cliente;activo;;%@ >Tipos clientes</a></div>
@%end-if:%@
@%if:AllowedLink;bo_tipos_iva;%@
<div class="menuitem"><a href="?seccion=bo_tipos_iva" @%func:querystring_activa;bo_tipos_iva;activo;;%@ >Tipos de IVA</a></div>
@%end-if:%@

@%if:AllowedLink;bo_transportistas;%@
<div class="menuitem"> <a href="?seccion=bo_transportistas" @%func:querystring_activa;bo_transportistas;activo;;%@ >Transportistas</a></div>
@%end-if:%@
@%if:AllowedLink;bo_tarifas_transporte;%@
<div class="menuitem"> <a href="?seccion=bo_tarifas_transporte" @%func:querystring_activa;bo_tarifas_transporte;activo;;%@ >Tarifas de Transporte</a></div>
@%end-if:%@

@%if:AllowedLink;bo_grupos_rutas;%@
<div class="menuitem"> <a href="?seccion=bo_grupos_rutas" @%func:querystring_activa;bo_grupos_rutas;activo;;%@ >Grupos de Rutas</a></div>
@%end-if:%@
@%if:AllowedLink;bo_gastos;%@
<div class="menuitem"> <a href="?seccion=bo_gastos" @%func:querystring_activa;bo_gastos;activo;;%@ >Gastos</a></div>
@%end-if:%@
@%if:AllowedLink;bo_medios_contacto;%@
<div class="menuitem"> <a href="?seccion=bo_medios_contacto" @%func:querystring_activa;bo_medios_contacto;activo;;%@ >Medios Contacto</a></div>
@%end-if:%@

@%if:AllowedLink;tipos_recurso;%@
<div class="menuitem"><a href="?seccion=tipos_recurso" @%func:querystring_activa;tipos_recurso;activo;;%@ >Tipos de Recurso</a></div>
@%end-if:%@
@%if:AllowedLink;recursos;%@
<div class="menuitem"><a href="?seccion=recursos" @%func:querystring_activa;recursos;activo;;%@ >Recursos</a></div>
@%end-if:%@
@%if:AllowedLink;tipos_anotacion;%@
<div class="menuitem"><a href="?seccion=tipos_anotacion" @%func:querystring_activa;tipos_anotacion;activo;;%@ >Tipos de Anotación</a></div>
@%end-if:%@
@%if:AllowedLink;estados_servicio;%@
<div class="menuitem"><a href="?seccion=estados_servicio" @%func:querystring_activa;estados_servicio;activo;;%@ >Estados de Servicio</a></div>
@%end-if:%@
@%if:AllowedLink;importancias;%@
<div class="menuitem"><a href="?seccion=importancias" @%func:querystring_activa;importancias;activo;;%@ >Importancia</a></div>
@%end-if:%@

@%if:AllowedLink;bo_certificados;%@
<div class="menuitem"> <a href="?seccion=bo_certificados" @%func:querystring_activa;bo_certificados;activo;;%@ >Certificados</a></div>
@%end-if:%@
@%if:AllowedLink;bo_divisa;%@
<div class="menuitem"> <a href="?seccion=bo_divisa" @%func:querystring_activa;bo_divisa;activo;;%@ >Divisas</a></div>
@%end-if:%@
@%if:AllowedLink;bo_paises;%@
<div class="menuitem"> <a href="?seccion=bo_paises" @%func:querystring_activa;bo_paises;activo;;%@ >Países</a></div>
@%end-if:%@
@%if:AllowedLink;bo_provincias;%@
<div class="menuitem"> <a href="?seccion=bo_provincias" @%func:querystring_activa;bo_provincias;activo;;%@ >Provincias</a></div>
@%end-if:%@
@%if:AllowedLink;tipos_unidadmedida;%@
<div class="menuitem"> <a href="?seccion=tipos_unidadmedida" @%func:querystring_activa;tipos_unidadmedida;activo;;%@ >Tipos de Unidad de medida</a></div>
@%end-if:%@
@%if:AllowedLink;bo_unidades_medida;%@
<div class="menuitem"> <a href="?seccion=bo_unidades_medida" @%func:querystring_activa;bo_unidades_medida;activo;;%@ >Uds. de medida</a></div>
@%end-if:%@

@%if:AllowedLink;cfg_anyos;%@
<div class="menuitem"><a href="?seccion=cfg_anyos" @%func:querystring_activa;cfg_anyos;activo;;%@ >Años</a></div>
@%end-if:%@
<!-- 
@%if:AllowedLink;cfg_trimestres;%@
<div class="menuitem"><a href="?seccion=cfg_trimestres" @%func:querystring_activa;cfg_trimestres;activo;;%@ >Trimestres</a></div>
@%end-if:%@
@%if:AllowedLink;cfg_meses;%@
<div class="menuitem"><a href="?seccion=cfg_meses" @%func:querystring_activa;cfg_meses;activo;;%@ >Meses</a></div>
@%end-if:%@
@%if:AllowedLink;cfg_semanas;%@
<div class="menuitem"><a href="?seccion=cfg_semanas" @%func:querystring_activa;cfg_semanas;activo;;%@ >Semanas</a></div>
@%end-if:%@
@%if:AllowedLink;cfg_dias;%@
<div class="menuitem"><a href="?seccion=cfg_dias" @%func:querystring_activa;cfg_dias;activo;;%@ >Días</a></div>
@%end-if:%@
-->

@%if:AllowedLink;bo_ayuda;%@
<div class="menuitem"> <a href="?seccion=bo_ayuda" @%func:querystring_activa;bo_ayuda;activo;;%@ >Ayuda</a></div>
@%end-if:%@
