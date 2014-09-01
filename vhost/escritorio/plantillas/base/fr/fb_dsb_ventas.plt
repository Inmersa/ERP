

<form method="post" action="?seccion=@%get:_krn_ss_name;%@" name="buscadorgeneral">
Limiter des périodes précédentes <input type="checkbox" name="limitardia" value="1" @%func:check_flag;dsb_limitedia;%@ />
Date<input type="text" name="fecha" class="fecha" value="@%func:colocar_fecha;dsb_fecha;%@" />
<a href="#" onclick="return sendForm('buscadorgeneral');" accesskey="r" class="submit">Chercher</a>
</form>
