
@%set:tb=Estados_servicio;%@

<!-- div class="tituloseccion">&gt; Nuevo Tipo de Recurso</div -->

<form name="nuevo" action="?seccion=estados_servicio" method="post">
<input type="hidden" name="accion_ejecutar" value="Modificar">
<input type="hidden" name="tb" value="@%get:tb;%@" />

<input type="hidden" name="@%get:tb;%@[id_estado_servicio]" value="@%db:Estados_servicio.id_estado_servicio;%@" />

<fieldset id="FichaEstadoServicio" class="fsficha" >
<legend>&gt; Ficha de Estado de Servicio</legend>

<table class="full">
 <tr>
 <td class="etiqueta" >Nombre:</td>
 <td ><input type="text" name="@%get:tb;%@[nombre]" value="@%db:Estados_servicio.nombre;%@" size="55"></td>
 </tr>
</table>

</fieldset>

</form>

<div class="AccionesEnvio">
<ul>
<li><a href="#" onClick="return sendForm('nuevo');" class="guardar" ><img src="imag/pixel.png" class="icono" /><span>Guardar</span></a></li>
</ul>
</div>

