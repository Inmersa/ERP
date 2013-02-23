@%if:AllowedLink;bo_maestro_bajas_almacen;%@
<div class="menuitem"><a href="?seccion=bo_maestro_bajas_almacen" @%func:querystring_activa;bo_maestro_bajas_almacen;activo;;%@ >Baisses de magasin</a></div>
@%end-if:%@
@%if:AllowedLink;bo_catalogo;%@
<div class="menuitem"><a href="#" onClick="return abrir_ventana('?seccion=bo_catalogo');return false;">Catalogue d´images</a></div>
@%end-if:%@

@%if:AllowedLink;bo_grupo_familias;%@
<div class="menuitem"> <a href="?seccion=bo_grupo_familias" @%func:querystring_activa;bo_grupo_familias;activo;;%@ >Groupe familles</a></div>
@%end-if:%@
@%if:AllowedLink;bo_familia_articulos;%@
<div class="menuitem"> <a href="?seccion=bo_familia_articulos" @%func:querystring_activa;bo_familia_articulos;activo;;%@ >Familles</a></div>
@%end-if:%@
@%if:AllowedLink;bo_descuento_familia;%@
<div class="menuitem"> <a href="?seccion=bo_descuento_familia" @%func:querystring_activa;bo_descuento_familia;activo;;%@ >Réductión pour famille</a></div>
@%end-if:%@


@%if:AllowedLink;bo_tarifas;%@
<div class="menuitem"><a href="?seccion=bo_tarifas" @%func:querystring_activa;bo_tarifas&;activo;;%@ >Tarifes vente</a></div>
@%end-if:%@
@%if:AllowedLink;bo_forma_pago;%@
<div class="menuitem"> <a href="?seccion=bo_forma_pago" @%func:querystring_activa;bo_forma_pago;activo;;%@ >Modalité de paiement</a></div>
@%end-if:%@
@%if:AllowedLink;bo_series_facturacion;%@
<div class="menuitem"> <a href="?seccion=bo_series_facturacion" @%func:querystring_activa;bo_series_facturacion;activo;;%@ >Série de facturation</a></div>
@%end-if:%@
@%if:AllowedLink;bo_servicios;%@
<div class="menuitem"> <a href="?seccion=bo_servicios" @%func:querystring_activa;bo_servicios;activo;;%@ >Services</a></div>
@%end-if:%@

@%if:AllowedLink;bo_tipo_agente;%@
<div class="menuitem"> <a href="?seccion=bo_tipo_agente" @%func:querystring_activa;bo_tipo_agente;activo;;%@ >Types d´agents</a></div>
@%end-if:%@
@%if:AllowedLink;bo_tipo_cliente;%@
<div class="menuitem"> <a href="?seccion=bo_tipo_cliente" @%func:querystring_activa;bo_tipo_cliente;activo;;%@ >Types clients</a></div>
@%end-if:%@
@%if:AllowedLink;bo_tipos_iva;%@
<div class="menuitem"><a href="?seccion=bo_tipos_iva" @%func:querystring_activa;bo_tipos_iva;activo;;%@ >Types TVA</a></div>
@%end-if:%@

@%if:AllowedLink;bo_transportistas;%@
<div class="menuitem"> <a href="?seccion=bo_transportistas" @%func:querystring_activa;bo_transportistas;activo;;%@ >Transporteurs</a></div>
@%end-if:%@
@%if:AllowedLink;bo_tarifas_transporte;%@
<div class="menuitem"> <a href="?seccion=bo_tarifas_transporte" @%func:querystring_activa;bo_tarifas_transporte;activo;;%@ >Tarif de transport</a></div>
@%end-if:%@

@%if:AllowedLink;bo_grupos_rutas;%@
<div class="menuitem"> <a href="?seccion=bo_grupos_rutas" @%func:querystring_activa;bo_grupos_rutas;activo;;%@ >Groupe de routes</a></div>
@%end-if:%@
@%if:AllowedLink;bo_gastos;%@
<div class="menuitem"> <a href="?seccion=bo_gastos" @%func:querystring_activa;bo_gastos;activo;;%@ >Dépenses</a></div>
@%end-if:%@
@%if:AllowedLink;bo_medios_contacto;%@
<div class="menuitem"> <a href="?seccion=bo_medios_contacto" @%func:querystring_activa;bo_medios_contacto;activo;;%@ >Moyens contact</a></div>
@%end-if:%@

@%if:AllowedLink;tipos_recurso;%@
<div class="menuitem"><a href="?seccion=tipos_recurso" @%func:querystring_activa;tipos_recurso;activo;;%@ >Types de Ressource</a></div>
@%end-if:%@
@%if:AllowedLink;recursos;%@
<div class="menuitem"><a href="?seccion=recursos" @%func:querystring_activa;recursos;activo;;%@ >Ressources</a></div>
@%end-if:%@
@%if:AllowedLink;tipos_anotacion;%@
<div class="menuitem"><a href="?seccion=tipos_anotacion" @%func:querystring_activa;tipos_anotacion;activo;;%@ >Types d'Annotation</a></div>
@%end-if:%@
@%if:AllowedLink;estados_servicio;%@
<div class="menuitem"><a href="?seccion=estados_servicio" @%func:querystring_activa;estados_servicio;activo;;%@ >États de Service</a></div>
@%end-if:%@
@%if:AllowedLink;importancias;%@
<div class="menuitem"><a href="?seccion=importancias" @%func:querystring_activa;importancias;activo;;%@ >Importance</a></div>
@%end-if:%@

@%if:AllowedLink;bo_certificados;%@
<div class="menuitem"> <a href="?seccion=bo_certificados" @%func:querystring_activa;bo_certificados;activo;;%@ >Recommandes</a></div>
@%end-if:%@
@%if:AllowedLink;bo_divisa;%@
<div class="menuitem"> <a href="?seccion=bo_divisa" @%func:querystring_activa;bo_divisa;activo;;%@ >Devise</a></div>
@%end-if:%@
@%if:AllowedLink;bo_paises;%@
<div class="menuitem"> <a href="?seccion=bo_paises" @%func:querystring_activa;bo_paises;activo;;%@ >Pays</a></div>
@%end-if:%@
@%if:AllowedLink;bo_provincias;%@
<div class="menuitem"> <a href="?seccion=bo_provincias" @%func:querystring_activa;bo_provincias;activo;;%@ >Province / État</a></div>
@%end-if:%@
@%if:AllowedLink;tipos_unidadmedida;%@
<div class="menuitem"> <a href="?seccion=tipos_unidadmedida" @%func:querystring_activa;tipos_unidadmedida;activo;;%@ >Types d'Unité de mesure</a></div>
@%end-if:%@
@%if:AllowedLink;bo_unidades_medida;%@
<div class="menuitem"> <a href="?seccion=bo_unidades_medida" @%func:querystring_activa;bo_unidades_medida;activo;;%@ >Unités de mesure</a></div>
@%end-if:%@

@%if:AllowedLink;cfg_anyos;%@
<div class="menuitem"><a href="?seccion=cfg_anyos" @%func:querystring_activa;cfg_anyos;activo;;%@ >Années</a></div>
@%end-if:%@
<!-- 
@%if:AllowedLink;cfg_trimestres;%@
<div class="menuitem"><a href="?seccion=cfg_trimestres" @%func:querystring_activa;cfg_trimestres;activo;;%@ >Trimestriel</a></div>
@%end-if:%@
@%if:AllowedLink;cfg_meses;%@
<div class="menuitem"><a href="?seccion=cfg_meses" @%func:querystring_activa;cfg_meses;activo;;%@ >Mois</a></div>
@%end-if:%@
@%if:AllowedLink;cfg_semanas;%@
<div class="menuitem"><a href="?seccion=cfg_semanas" @%func:querystring_activa;cfg_semanas;activo;;%@ >Semaines</a></div>
@%end-if:%@
@%if:AllowedLink;cfg_dias;%@
<div class="menuitem"><a href="?seccion=cfg_dias" @%func:querystring_activa;cfg_dias;activo;;%@ >Jours</a></div>
@%end-if:%@
-->

@%if:AllowedLink;bo_ayuda;%@
<div class="menuitem"> <a href="?seccion=bo_ayuda" @%func:querystring_activa;bo_ayuda;activo;;%@ >Aide</a></div>
@%end-if:%@
