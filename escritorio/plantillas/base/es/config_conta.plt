
<fieldset class="fsficha">
<legend>Enlace con Contabilidad</legend>
<table class="full"><tbody>
<tr><td class="etiqueta">Ejercicio</td>
<!-- @%set:_selected_value=_aAppConf[iconta_ejercicio];%@ -->
<td colspan="1" >
<select name="_main[iconta_ejercicio]" >
<option value="">-- Ninguna seleccion --</option>
@%where:db|$_aAppConf[iconta_dbname];tabla|Ejercicios;order|fecha_inicio desc;%@
<option value="@%db:Ejercicios.id_ejercicio;%@" 
@%db:selected_value{Ejercicios.id_ejercicio};%@
>@%db:Ejercicios.nombre;%@ (@%db:Empresas.razon_social;%@ - @%db:Empresas.cif;%@)</option>
@%end-where:%@

</select></td>
@%if:!esta_vacio;_aAppConf[iconta_ejercicio];%@
	<td class="etiqueta">Nombre de Empresa en Contabilidad</td>
	<td>
	@%where:db|$_aAppConf[iconta_dbname];tabla|Ejercicios;where|Ejercicios.id_ejercicio = $_aAppConf[iconta_ejercicio];%@
	<input type="hidden" name="_main[iconta_empresa]" value="@%db:Ejercicios.id_empresa;%@" />
	@%db:Empresas.razon_social;%@ (@%db:Empresas.cif;%@)
	@%end-where:%@

	</td></tr>
	<tr><td class="etiqueta">Diario</td>
	<td>
	<!-- @%set:_selected_value=_aAppConf[iconta_diario];%@ -->
	<select name="_main[iconta_diario]" >
	@%where:db|$_aAppConf[iconta_dbname];tabla|Diario;order|Diario.nombre;where|Ejercicios.id_ejercicio = $_aAppConf[iconta_ejercicio];%@
	<option value="@%db:Diario.id_diario;%@" 
	@%db:selected_value{Diario.id_diario};%@
	>@%db:Diario.nombre;%@</option>
	@%end-where:%@

	</select></td>
	<td class="etiqueta">Canal</td>
	<td><input type="text" name="_main[iconta_canal]" value="@%get:_aAppConf[iconta_canal];%@" class="mininum" /></td>
	</tr>
@%end-if:%@
</tbody></table>
</fieldset>

