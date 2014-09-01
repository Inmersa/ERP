

<div class="tituloseccion">Contador</div>

<form name="contadores_empresa" method="post" action="?seccion=bo_contadores">
<fieldset >
<legend>Contador de Vendas</legend>
@%plt:Contadores_Venta%@
</fieldset>

<fieldset>
<legend>Contador de Compras</legend>
@%plt:Contadores_Compra%@
</fieldset>
</form>

<div class="AccionesEnvio"><ul>
<li><a href="#" OnClick="return sendForm('contadores_empresa');" class="guardar" ><img src="imag/pixel.png" class="icono" /><span>Guardar Alterações</span></a></li>
</ul></div>




