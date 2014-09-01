

<div class="tituloseccion">Comptador</div>

<form name="contadores_empresa" method="post" action="?seccion=bo_contadores">
<fieldset >
<legend>Comptadors de venda</legend>
@%plt:Contadores_Venta%@
</fieldset>

<fieldset>
<legend>Comptadors de compra</legend>
@%plt:Contadores_Compra%@
</fieldset>
</form>

<div class="AccionesEnvio"><ul>
<li><a href="#" OnClick="return sendForm('contadores_empresa');" class="guardar" ><img src="images/pixel.png" class="icono" /><span>Guardar Canvis</span></a></li>
</ul></div>




