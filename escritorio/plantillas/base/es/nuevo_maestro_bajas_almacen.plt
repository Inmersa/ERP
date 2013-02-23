<div class="barraoscura">
<div class="titsuperior">&gt; NUEVA BAJA DE ALMACEN</div></div> 

<form name="nuevo_maestro_bajas_almacen" action="?seccion=bo_maestro_bajas_almacen" method="post">
<input type="hidden" name="registro[id_baja_almacen]" value="NULL" />
<input type="hidden" name="estado" value="1" />
<table class="full">
<tr>
<td class="etiqueta">Nombre:</td>
<td><input type="text" name="registro[nombre]" size="55" /></td>
</tr>
<tr>
<td class="etiqueta">Descripción:</td>
<td><input type="text" name="registro[descripcion]" size="55" /></td>
</tr>
</table>
</form>
<div class="enviar"><a href="#" onClick="return sendForm('nuevo_maestro_bajas_almacen');">Guardar</a></div>
