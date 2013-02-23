 @%where:tabla|Clientes;nolink|1;where|id_cliente = $cliente_pda;no_results|1;%@

 @%db:Clientes.nombre;%@
 @%db:Clientes.razon_social;%@

 @%end-where:%@

</br>

<form method="post" action="?seccion=pda_inserta_articulos">
<table>
<tr>
<td>Referencia
</td>
<td>cantidad
</td>
</tr>
<tr>
<td><input type="text" name="referencia1" size="13">
</td>
<td><input type="text" name="cantidad1" size="3">
</td>
</tr>
<tr>
<td><input type="text" name="referencia2" size="13">
</td>
<td><input type="text" name="cantidad2" size="3">
</td>
</tr>
<tr>
<td><input type="text" name="referencia3" size="13">
</td>
<td><input type="text" name="cantidad3" size="3">
</td>
</tr>
<tr>
<td><input type="text" name="referencia4" size="13">
</td>
<td><input type="text" name="cantidad4" size="3">
</td>
</tr>
<tr>
<td><input type="submit" name="Insertar" value="Insertar"/>
</td>
</form>
<form method="post" action="?seccion=pda_pre_confirmar_pedido">
<td><input type="submit" name="Finalizar" value="Finalizar"/>
</td>
</form>
</tr>

</table>


