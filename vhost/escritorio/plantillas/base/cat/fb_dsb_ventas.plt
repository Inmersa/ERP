

<form method="post" action="?seccion=@%get:_krn_ss_name;%@" name="buscadorgeneral">
Limitar períodes anteriors <input type="checkbox" name="limitardia" value="1" @%func:check_flag;dsb_limitedia;%@ />
Data<input type="text" name="fecha" class="fecha" value="@%func:colocar_fecha;dsb_fecha;%@" />
<a href="#" onclick="return sendForm('buscadorgeneral');" accesskey="b" class="submit">Buscar</a>
</form>
