<form method="post" action="?seccion=pda_confirmar_pedido">

@%where:nodb|pedido_gocho;%@
<input type="checkbox" name="confirmar[@%db:id_articulo;%@][insertar]" value="1" checked>  @%db:nombre;%@  @%db:cantidad%@ <br>
<input type="hidden" name="confirmar[@%db:id_articulo;%@][cantidad]" value="@%db:cantidad%@"> 
  @%end-where:%@

<br>
<input type="submit" name="Finalizar" value="Finalizar"/>
</form>

<form method="post" action="?seccion=pda_escoge_cliente">

<input type="submit" name="Deshacer" value="Deshacer"/>
</form>
