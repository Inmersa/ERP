
<div class="tituloseccion">&gt; Novo Link de Cliente</div>

<form name="nuevo" action="?seccion=modif_clientes" method="post">
<input type="hidden" name="accion_ejecutar" value="NuevoEnlace" />

<table class="full">
<tr>
<td class="etiqueta">Nome:</td>
<td><input type="text" name="cliente_enlaces[nombre]"  /></td>

<td class="etiqueta">URL:</td>
<td>http://<input type="text" name="cliente_enlaces[url]"  /></td>
</tr>

<tr>
<td class="etiqueta" >Observações:</td>
<td colspan="3" ><textarea name="cliente_enlaces[descripcion]" rows="7" cols="75"></textarea></td>
</tr>

</table>

<div class="AccionesEnvio">
<ul>
<li><a href="#" onClick="return sendForm('nuevo');" class="guardar" ><img src="imag/pixel.png" class="icono" /><span>Adicionar</span></a></li>
</ul>
</div>
</form>
