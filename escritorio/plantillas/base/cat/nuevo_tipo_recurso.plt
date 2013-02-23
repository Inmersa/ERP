
@%set:tb=Tipos_recurso;%@

<!-- div class="tituloseccion">&gt; Nou Tipus de Recurs</div -->

<form name="nuevo" action="?seccion=tipos_recurso" method="post">
<input type="hidden" name="accion_ejecutar" value="Modificar">
<input type="hidden" name="tb" value="@%get:tb;%@" />

<fieldset id="NuevoTipoRecurso" class="fsficha" >
<legend>&gt; Nou Tipus de Recurs</legend>

<table class="full">
 <tr>
 <td class="etiqueta" >Nom:</td>
 <td ><input type="text" name="@%get:tb;%@[nombre]" size="55"></td>
 </tr>
 <tr><td class="etiqueta" >Descripci�:</td>
 <td ><textarea name="@%get:tb;%@[descripcion]" rows="7" cols="80"></textarea></td>
 </tr>
</table>

</fieldset>

</form>

<div class="AccionesEnvio">
<ul>
<li><a href="#" onClick="return sendForm('nuevo');" class="guardar" ><img src="images/pixel.png" class="icono" /><span>Guardar</span></a></li>
</ul>
</div>

