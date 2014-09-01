@%where:tabla|Empresas;where|Empresas.id_empresa = $id_empresa;%@
<form name="modif_empresas" action="?seccion=modif_miempresa" method="post"> 

<input type="hidden" name="registro[id_empresa]" value="@%db:Empresas.id_empresa;%@" />
<input type="hidden" name="registro[mask]" value="@%db:Empresas.mask;%@" />
<input type="hidden" name="estado" value="1" />
<div class="tituloseccion">&gt; Fitxa d�empresa</div>

@%plt:Datos_Generales%@ 

@%plt:Login%@

</form>

@%if:AllowedAction;Empresas;edit;%@
<div class="AccionesEnvio"><ul>
<li><a href="#" onClick="return sendForm('modif_empresas');" class="guardar" ><img src="images/pixel.png" class="icono" /><span>Modificar</span></a></li>
</ul></div>
@%end-if:%@

 @%end-where:%@
