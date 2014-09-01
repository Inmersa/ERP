

<div class="tituloseccion">CONTADORES</div>

<form name="contadores_empresa" method="post" action="?seccion=bo_contadores">
<fieldset >
<legend>CONTADORES DE VENTA</legend>
@%plt:Contadores_Venta%@
</fieldset>

<fieldset>
<legend>CONTADORES DE COMPRA</legend>
@%plt:Contadores_Compra%@
</fieldset>
</form>

<div class="AccionesEnvio"><ul>
<li><a href="#" OnClick="return sendForm('contadores_empresa');" class="guardar" ><img src="images/pixel.png" class="icono" /><span>Guardar Cambios</span></a></li>
</ul></div>




