
<form name="modif_almacenes" action="?seccion=modif_almacenes&id_almacen=@%get:id_almacen_promocion;%@" method="post">

<div class="tituloseccion">&gt; Ficha de Armazém</div>

<div class="PIIFichaBase" id="Datos_Generales" >
@%plt:Datos_Generales%@
</div>

<div class="PIIContainer" id="FichaTab_Almacen" 
@%if:AllowedPII;Usuario;%@
><div name="Usuario" >Acesso</div
@%end-if:%@
@%if:AllowedPII;Almacenes_Logicos;%@
><div name="Zonas" class="activo" >Zonas Armazéns</div
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
	><img src="imag/pixel.png" class="icono" /><span>Alterar</span></a></li>
</ul></div>


<script >
<!-- 
TabAlmacen = new TabGroup(document.getElementById('FichaTab_Almacen'));
// -->
</script>


