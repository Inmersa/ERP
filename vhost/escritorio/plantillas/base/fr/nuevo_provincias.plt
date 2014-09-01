
<div class="tituloseccion">&gt; Nouvelle province</div>


 <form name="nuevo_provincias" action="?seccion=bo_provincias" method="post">
<input type="hidden" name="registro[id_provincia]" value="NULL" />
<input type="hidden" name="estado" value="1" />

<table class="full">

<tr>
<td class="etiqueta"> Nom:</td>
<td><input type="text" name="registro[nombre]" size="55" /></td>
</tr>

<tr>
<td class="etiqueta">Pays:</td>
<td><select name="registro[id_pais]">
@%where:tabla|Paises;nolink|1;%@
<option value="@%db:Paises.id_pais;%@"
>@%db:Paises.nombre;%@</option>
@%end-where:%@

 </select></td>
</tr>

<tr>
<td class="etiqueta">Code:</td>
<td><input type="text" name="registro[codigo]" size="5" /></td>
</tr>

<tr>
<td class="etiqueta">Prefixe Tf.:</td>
<td><input type="text" name="registro[prefijo_tlf]" size="5" /></td>
</tr>

</table>
</form>

<div class="AccionesEnvio"><ul>
<li><a href="#" onclick="return sendForm('nuevo_provincias');" class="guardar" ><img src="imag/pixel.png" class="icono" /><span>Garder</span></a></li>
</ul></div>

