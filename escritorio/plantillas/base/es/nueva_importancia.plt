
@%set:tb=Importancias;%@

<!-- div class="tituloseccion">&gt; {{frame_nuevoestado_servicio}}</div -->

<form name="nuevo" action="?seccion=importancias" method="post">
<input type="hidden" name="accion_ejecutar" value="Modificar">
<input type="hidden" name="tb" value="@%get:tb;%@" />

<fieldset id="NuevaImportancia" class="fsficha" >
<legend>&gt; Nueva Importancia</legend>

<table class="full">
 <tr>
 <td class="etiqueta" >Nombre:</td>
 <td ><input type="text" name="@%get:tb;%@[nombre]" size="55"></td>
 </tr>
 <tr><td class="etiqueta" >Descripcción:</td>
 <td ><textarea name="@%get:tb;%@[descripcion]" rows="7" cols="80"></textarea></td>
 </tr>
 <td class="etiqueta" >Nivel:</td>
 <td ><input type="text" name="@%get:tb;%@[nivel]" size="5"></td>
 </tr>
</table>

</fieldset>

</form>

<div class="AccionesEnvio">
<ul>
<li><a href="#" onClick="return sendForm('nuevo');" class="guardar" ><img src="imag/pixel.png" class="icono" /><span>Guardar</span></a></li>
</ul>
</div>

