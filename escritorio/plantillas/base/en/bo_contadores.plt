

<div class="tituloseccion">Meter</div>

<form name="contadores_empresa" method="post" action="?seccion=bo_contadores">
<fieldset >
<legend>Sales meter</legend>
@%plt:Contadores_Venta%@
</fieldset>

<fieldset>
<legend>Buy meter</legend>
@%plt:Contadores_Compra%@
</fieldset>
</form>

<div class="AccionesEnvio"><ul>
<li><a href="#" OnClick="return sendForm('contadores_empresa');" class="guardar" ><img src="images/pixel.png" class="icono" /><span>Save Changes</span></a></li>
</ul></div>




