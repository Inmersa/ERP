<form method="post" action="?seccion=dashboard_compras" name="buscadorgeneral">
Limitar periodos anteriores <input type="checkbox" name="limitardia" value="1" @%func:check_flag;dsb_limitedia;%@ />
Fecha<input type="text" name="fecha" class="fecha" value="@%func:colocar_fecha;dsb_fecha;%@" />
<a href="#" onclick="return sendForm('buscadorgeneral');" accesskey="b" class="submit">Buscar</a>
</form>
