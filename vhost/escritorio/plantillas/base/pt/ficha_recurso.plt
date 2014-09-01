
@%set:tb=Recursos;%@

<form name="nuevo" action="?seccion=recursos" method="post">
<input type="hidden" name="accion_ejecutar" value="Modificar">
<input type="hidden" name="tb" value="@%get:tb;%@" />

<input type="hidden" name="@%get:tb;%@[id_recurso]" value="@%db:Recursos.id_recurso;%@" />

<fieldset id="NuevoRecurso" class="fsficha" >
<legend>&gt; Ficha Do Recurso</legend>

<table class="full">
 <tr>
 <td class="etiqueta" >Nome:</td>
 <td ><input type="text" name="@%get:tb;%@[nombre]" size="55" value="@%db:Recursos.nombre;%@" ></td>
 </tr>
 <tr><td class="etiqueta" >Descrição:</td>
 <td ><textarea name="@%get:tb;%@[descripcion]" rows="7" cols="80">@%db:Recursos.descripcion;%@</textarea></td>
 </tr>
 <tr><td class="etiqueta" >Extra:</td>
 <td ><textarea name="@%get:tb;%@[extra]" rows="7" cols="80">@%db:Recursos.extra;%@</textarea></td>
 </tr>
 <tr><td class="etiqueta" >Tipo:</td>
 <td >
 <!-- @%set:_selected_value=Recursos.id_tipo_recurso;%@ @%db:Recursos.id_tipo_recurso;%@ -->
 <select name="@%get:tb;%@[id_tipo_recurso]" >
 @%where:tabla|Tipos_recurso;order|nombre;nolink|1;%@
 <option value="@%db:Tipos_recurso.id_tipo_recurso;%@" 
 @%db:selected_value{Tipos_recurso.id_tipo_recurso};%@
 >@%db:Tipos_recurso.nombre;%@</option>
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

