
@%set:tb=Tipos_recurso;%@

<!-- div class="tituloseccion">&gt; Tipo Novo do Recurso</div -->

<form name="nuevo" action="?seccion=tipos_recurso" method="post">
<input type="hidden" name="accion_ejecutar" value="Modificar">
<input type="hidden" name="tb" value="@%get:tb;%@" />

<input type="hidden" name="@%get:tb;%@[id_tipo_recurso]" value="@%db:Tipos_recurso.id_tipo_recurso;%@" />

<fieldset id="FichaTipoRecurso" class="fsficha" >
<legend>&gt; Tipo Ficha do Recurso</legend>

<table class="full">
 <tr>
 <td class="etiqueta" >Nome:</td>
 <td ><input type="text" name="@%get:tb;%@[nombre]" value="@%db:Tipos_recurso.nombre;%@" size="55"></td>
 </tr>
 <tr><td class="etiqueta" >Descrição:</td>
 <td ><textarea name="@%get:tb;%@[descripcion]" rows="7" cols="80">@%db:Tipos_recurso.descripcion;%@</textarea></td>
 </tr>
</table>

</fieldset>

</form>

<div class="AccionesEnvio">
<ul>
<li><a href="#" onClick="return sendForm('nuevo');" class="guardar" ><img src="imag/pixel.png" class="icono" /><span>Guardar</span></a></li>
</ul>
</div>

