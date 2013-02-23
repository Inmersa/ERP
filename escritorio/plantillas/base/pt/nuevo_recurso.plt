
@%set:tb=Recursos;%@

<!-- div class="tituloseccion">&gt; Tipo Novo do Recurso</div -->

<form name="nuevo" action="?seccion=recursos" method="post">
<input type="hidden" name="accion_ejecutar" value="Modificar">
<input type="hidden" name="tb" value="@%get:tb;%@" />

<fieldset id="NuevoRecurso" class="fsficha" >
<legend>&gt; Recurso Novo</legend>

<table class="full">
 <tr>
 <td class="etiqueta" >Nome:</td>
 <td ><input type="text" name="@%get:tb;%@[nombre]" size="55"></td>
 </tr>
 <tr><td class="etiqueta" >Descri��o:</td>
 <td ><textarea name="@%get:tb;%@[descripcion]" rows="7" cols="80"></textarea></td>
 </tr>
 <tr><td class="etiqueta" >Extra:</td>
 <td ><textarea name="@%get:tb;%@[extra]" rows="7" cols="80"></textarea></td>
 </tr>
 <tr><td class="etiqueta" >Tipo:</td>
 <td >
 <select name="@%get:tb;%@[id_tipo_recurso]" >
 @%where:tabla|Tipos_recurso;order|nombre;nolink|1;%@
 <option value="@%db:Tipos_recurso.id_tipo_recurso;%@" >@%db:Tipos_recurso.nombre;%@</option>
 @%end-where:%@

 </select>
 </td>
 </tr>
</table>

</fieldset>

</form>

<div class="AccionesEnvio">
<ul>
<li><a href="#" onClick="return sendForm('nuevo');" class="guardar" ><img src="imag/pixel.png" class="icono" /><span>Guardar</span></a></li>
</ul>
</div>

