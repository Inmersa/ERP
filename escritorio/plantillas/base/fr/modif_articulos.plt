
<div class="tituloseccion">&gt; Fiche d�article</div>

@%if:AllowedLink;nuevo_articulos;%@
<div id="AccionesEncabezado"><ul>
	@%if:AllowedAction;Articulos;new;%@
	<li><a href="?seccion=nuevo_articulos"  class="nuevo" ><img src="imag/pixel.png" class="icono" /><span>Nouveau article</span></a></li>
	@%end-if:%@
</ul></div> 
@%end-if:%@

<form name="modif_articulos" action="?seccion=modif_articulos" method="post">

<div class="PIIFichaBase" id="Datos_Generales" >
@%plt:Datos_Generales%@
</div>

<div class="PIIContainer" id="FichaTab_Articulo" 
@%if:AllowedPII;Precios;%@
><div name="Precios" class="activo" >Prix</div
@%end-if:%@
@%if:AllowedPII;Proveedores_Articulo;%@
><div name="Proveedores" >Fournisseurs</div
@%end-if:%@
@%if:AllowedPII;Servicios;%@
><div name="Servicios" >Services</div
@%end-if:%@
@%if:AllowedPII;Recursos;%@
><div name="Recursos" >Ressources</div
@%end-if:%@
@%if:AllowedPII;Composicion;%@
><div name="Composicion" >Composition</div
@%end-if:%@
@%if:AllowedPII;Distribucion;%@
><div name="Distribucion" >{{ftab_distribucion}}</div
@%end-if:%@
@%if:AllowedPII;Web;%@
><div name="Web" >Web</div
@%end-if:%@
@%if:AllowedPII;VoIP;%@
><div name="VoIP" >VOIP</div
@%end-if:%@
></div>


<div class="PIIFicha" id="Precios" >
@%plt:Precios%@
</div>

<div class="PIIFicha" id="Proveedores" >
@%plt:Proveedores_Articulo%@
</div>

<div class="PIIFicha" id="Servicios" >
@%plt:Servicios;%@
</div>

<div class="PIIFicha" id="Recursos" >
@%plt:Recursos;%@
</div>

<div class="PIIFicha" id="Composicion" >
@%plt:Composicion%@
</div>

<div class="PIIFicha" id="Distribucion" >
@%plt:Distribucion%@
</div>

<div class="PIIFicha" id="Web" >
@%plt:Web%@
</div>

<div class="PIIFicha" id="VoIP" >
@%plt:VoIP%@
</div>

@%if:AllowedAction;Articulos;edit;%@
<div class="AccionesEnvio"><ul>
<li><a href="#" onclick="return onHRefClick('modif_articulos','accion_ejecutar','Modificar');" class="guardar"><img src="imag/pixel.png" class="icono" /><span>Modifier</span></a></li>
</ul></div>
@%end-if:%@

</form>

<script >
<!-- 
TabArticulo = new TabGroup(document.getElementById('FichaTab_Articulo'));
// -->
</script>

