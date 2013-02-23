
<form name="modif_almacenes" action="?seccion=modif_almacenes&id_almacen=@%get:id_almacen_promocion;%@" method="post">

<div class="tituloseccion">&gt; Warehouse Card</div>

<div class="PIIFichaBase" id="Datos_Generales" >
@%plt:Datos_Generales%@
</div>

<div class="PIIContainer" id="FichaTab_Almacen" 
@%if:AllowedPII;Usuario;%@
><div name="Usuario" >Access</div
@%end-if:%@
@%if:AllowedPII;Almacenes_Logicos;%@
><div name="Zonas" class="activo" >Warehouse Zones</div
@%end-if:%@
></div>

<div class="PIIFicha" id="Usuario" >
@%plt:Usuario%@
</div>

<div class="PIIFicha" id="Zonas" >
@%plt:Almacenes_Logicos%@
</div>

<div class="AccionesEnvio"><ul>
<li><a href="#" onClick="return onHRefClick('modif_almacenes','accion_ejecutar','Modificar');" class="guardar" 
	><img src="images/pixel.png" class="icono" /><span>Modify</span></a></li>
</ul></div>


<script >
<!-- 
TabAlmacen = new TabGroup(document.getElementById('FichaTab_Almacen'));
// -->
</script>


