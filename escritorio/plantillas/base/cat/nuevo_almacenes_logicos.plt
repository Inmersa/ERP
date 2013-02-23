
<form name="nuevo_almacenes_logicos" action="?seccion=modif_almacenes&id_almacen=@%env:id_almacen_promocion%@" method="post">
<input type="hidden" name="registro_logico[id_almacen_logico]" value="NULL" />

<fieldset id="NuevoAlmacenLogico" class="fsficha" >
<legend>Nova Zona Magatzem</legend>

<table class="full">
@%where:tabla|Almacenes;where|Almacenes.id_almacen = $id_almacen_promocion;%@
<tr>
<td class="titul2" colspan="2">@%db:Almacenes.nombre;%@ - @%db:Almacenes.direccion;%@ - @%db:Almacenes.poblacion;%@
</td>
</tr>
@%end-where:%@


<tr>
<td class="etiqueta">Nom:</td>
<td><input type="text" name="registro_logicos[nombre]" size="55"></td>
</tr>
</table>
<div class="AccionesEnvio"><ul>
<li><a href="#" onClick="return sendForm('nuevo_almacenes_logicos');" class="guardar" ><img src="images/pixel.png" class="icono" /><span>Guardar</span></a></li>
</ul></div>

<input type="hidden" name="accion_ejecutar" value="Nuevo" />
</fieldset>

</form>

