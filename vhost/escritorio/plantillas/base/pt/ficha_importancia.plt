
@%set:tb=Importancias;%@

<form name="nuevo" action="?seccion=importancias" method="post">
<input type="hidden" name="accion_ejecutar" value="Modificar">
<input type="hidden" name="tb" value="@%get:tb;%@" />

<input type="hidden" name="@%get:tb;%@[id_importancia]" value="@%db:Importancias.id_importancia;%@" />

<fieldset id="FichaImportancia" class="fsficha" >
<legend>&gt; Ficha d'Importance</legend>

<table class="full">
 <tr>
 <td class="etiqueta" >Nome:</td>
 <td ><input type="text" name="@%get:tb;%@[nombre]" size="55" value="@%db:Importancias.nombre;%@" ></td>
 </tr>
 <tr><td class="etiqueta" >Descri��o:</td>
 <td ><textarea name="@%get:tb;%@[descripcion]" rows="7" cols="80">@%db:Importancias.descripcion;%@</textarea></td>
 </tr>
 <tr><td class="etiqueta" >N�vel:</td>
 <td ><input type="text" name="@%get:tb;%@[nivel]" size="5" value="@%db:Importancias.nivel;%@" ></td>
 </tr>
</table>

</fieldset>

</form>

<div class="AccionesEnvio">
<ul>
<li><a href="#" onClick="return sendForm('nuevo');" class="guardar" ><img src="imag/pixel.png" class="icono" /><span>Guardar</span></a></li>
</ul>
</div>

