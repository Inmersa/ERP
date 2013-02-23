
@%set:tb=Tipos_UnidadMedida;%@

<div class="tituloseccion" >Unit of measurement Type</div>

@%plt:botonera%@


<table class="full"><thead><tr>
<td></td>
<td >Name</td>
<td >Type</td>
<td >User</td>
</tr></thead>
<form name="listado" action="?seccion=@%get:_krn_ss_name;%@" method="post">
<input type="hidden" name="accion_ejecutar" value="Borrar" />
<input type="hidden" name="tb" value="@%get:tb;%@" />
@%where:tabla|Tipos_UnidadMedida;nombre|busc;no_results|1;%@
<input type="hidden" class="texto" name="@%get:tb;%@[@%db:Tipos_UnidadMedida.id_tipo_unidadmedida;%@][id_tipo_unidadmedida]" 
value="@%db:Tipos_UnidadMedida.id_tipo_unidadmedida;%@"  />
<tr>
<td class="check"><input type="checkbox" name="lista_@%get:tb;%@[@%db:Tipos_UnidadMedida.id_tipo_unidadmedida;%@]" value="@%db:Tipos_UnidadMedida.id_tipo_unidadmedida;%@" /></td>
<td ><input type="text" class="texto" name="@%get:tb;%@[@%db:Tipos_UnidadMedida.id_tipo_unidadmedida;%@][nombre]" value="@%db:Tipos_UnidadMedida.nombre;%@"  /></td>
<td ><select name="@%get:tb;%@[@%db:Tipos_UnidadMedida.id_tipo_unidadmedida;%@][otro_peso_cubicaje]" >
<option value="0"
@%if:equals;Tipos_UnidadMedida.otro_peso_cubicaje;0;%@
selected="selected"
@%end-if:%@
>Other</option>
<option value="1"
@%if:equals;Tipos_UnidadMedida.otro_peso_cubicaje;1;%@
selected="selected"
@%end-if:%@
>Weight</option>
<option value="2"
@%if:equals;Tipos_UnidadMedida.otro_peso_cubicaje;2;%@
selected="selected"
@%end-if:%@
>Volume (L x H x W)</option>
</select></td>
<td >@%db:si_no_flag{Tipos_UnidadMedida.user_defined};%@</td>
</tr>
@%end-where:%@

</table>
</form>
@%plt:botonera%@

<form name="nuevo" action="?seccion=@%get:_krn_ss_name;%@" method="post" >
<input type="hidden" name="accion_ejecutar" value="Nuevo" />
<input type="hidden" name="tb" value="@%get:tb;%@" />
<div class="AccionesEnvio" ><ul>
@%if:AllowedAction;tb;new;%@
<li class="noicon" ><input type="text" class="texto" name="nuevo[nombre]" value="" /></li>
<li><a href="#" onClick="return sendForm('nuevo');" class="nuevo" ><img src="images/pixel.png" class="icono" /><span>New</span></a></li>
@%end-if:%@
@%if:AllowedAction;tb;edit;%@
<li><a href="#" onClick="return sendForm('listado','accion_ejecutar','ModificarLista');" class="guardar" ><img src="images/pixel.png" class="icono" /><span>Modify</span></a></li>
@%end-if:%@
@%if:AllowedAction;tb;del;%@
<li><a href="#" onClick="return sendForm('listado','accion_ejecutar','Borrar');" class="borrar" ><img src="images/pixel.png" class="icono" /><span>Delete selected</span></a></li>
@%end-if:%@
</ul></div>
</form>

