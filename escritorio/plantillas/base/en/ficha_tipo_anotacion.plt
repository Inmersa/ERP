
@%set:tb=Tipos_anotacion;%@

<!-- div class="tituloseccion">&gt; New Resource Type</div -->

<form name="nuevo" action="?seccion=tipos_anotacion" method="post">
<input type="hidden" name="accion_ejecutar" value="Modificar">
<input type="hidden" name="tb" value="@%get:tb;%@" />

<input type="hidden" name="@%get:tb;%@[id_tipo_anotacion]" value="@%db:Tipos_anotacion.id_tipo_anotacion;%@" />

<fieldset id="FichaTipoAnotacion" class="fsficha" >
<legend>&gt; Annotation Type Card</legend>

<table class="full">
 <tr>
 <td class="etiqueta" >Name:</td>
 <td ><input type="text" name="@%get:tb;%@[nombre]" value="@%db:Tipos_anotacion.nombre;%@" size="55"></td>
 </tr>
</table>

</fieldset>

</form>

<div class="AccionesEnvio">
<ul>
<li><a href="#" onClick="return sendForm('nuevo');" class="guardar" ><img src="images/pixel.png" class="icono" /><span>Save</span></a></li>
</ul>
</div>

