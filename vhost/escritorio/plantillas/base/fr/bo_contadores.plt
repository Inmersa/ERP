

<div class="tituloseccion">Compteurs</div>

<form name="contadores_empresa" method="post" action="?seccion=bo_contadores">
<fieldset >
<legend>Compteurs de vente</legend>
@%plt:Contadores_Venta%@
</fieldset>

<fieldset>
<legend>Compteurs de acheter</legend>
@%plt:Contadores_Compra%@
</fieldset>
</form>

<div class="AccionesEnvio"><ul>
<li><a href="#" OnClick="return sendForm('contadores_empresa');" class="guardar" ><img src="imag/pixel.png" class="icono" /><span>Garder</span></a></li>
</ul></div>




