
@%set:tb=Estados_servicio;%@

<!-- div class="tituloseccion">&gt; Nou Tipus de Recurs</div -->

<form name="nuevo" action="?seccion=estados_servicio" method="post">
<input type="hidden" name="accion_ejecutar" value="Modificar">
<input type="hidden" name="tb" value="@%get:tb;%@" />

<input type="hidden" name="@%get:tb;%@[id_estado_servicio]" value="@%db:Estados_servicio.id_estado_servicio;%@" />

<fieldset id="FichaEstadoServicio" class="fsficha" >
<legend>&gt; Fitxa Estats de Servei</legend>

<table class="full">
 <tr>
 <td class="etiqueta" >Nom:</td>
 <td ><input type="text" name="@%get:tb;%@[nombre]" value="@%db:Estados_servicio.nombre;%@" size="55"></td>
 </tr>
</table>

</fieldset>

</form>

<div class="AccionesEnvio">
<ul>
<li><a href="#" onClick="return sendForm('nuevo');" class="guardar" ><img src="images/pixel.png" class="icono" /><span>Guardar</span></a></li>
</ul>
</div>

