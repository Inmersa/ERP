<table class="full">
<tr><td class="etiqueta">Nom:</td>
<td><input type="text" name="registro[nombre]" value="@%db:Empresas.nombre;%@" /></td>
<td rowspan="7" class="tdimgarticulo">
<!-- @%db:Empresas.id_imagen%@ @%set:id_img=Empresas.id_imagen%@ @%set:id_emp=Empresas.id_empresa%@ -->
@%where:db|db_catalogo;tabla|Catalogo_imagenes;%@
<a href="#" onClick="return CatalogoImagenesSoloUna('Empresas','id_empresa','@%get:id_emp;%@','@%db:Catalogo_imagenes.id_imagen;%@');"
	>&nbsp;<img src="/catalogo/@%db:Catalogo_imagenes.nombre%@" border="0" width="200" >&nbsp;</a><br />
 <input type="checkbox" name="registro[id_imagen]" value="@%db:Catalogo_imagenes.id_imagen%@" checked />
@%set:sitiene_imagen=1;%@
@%end-where:%@

@%if:esta_vacio;sitiene_imagen;%@
 <a href="#" onClick="return CatalogoImagenesSoloUna('Empresas','id_empresa','@%db:Empresas.id_empresa;%@');"
	>Image</a><br/>
@%end-if:%@
</td>
 </tr>
<tr><td class="etiqueta">Groupe de clients:</td>
<td><select name="registro[id_grupo_empresa]">
 <option value="">Aucune sélection</option>
 <!--@%db:Empresas.id_grupo_empresa;%@ @%set:_selected_value=Empresas.id_grupo_empresas;%@ -->
 @%where:tabla|Grupo_empresas;nolink|1;order|nombre;%@
 <option value="@%db:Grupo_empresas.id_grupo_empresa;%@" 
 @%db:selected_value{Grupo_empresas.id_grupo_empresa};%@
 > @%db:Grupo_empresas.nombre;%@ </option>
 @%end-where:%@

 </select></td>
 </tr>
<tr><td class="etiqueta">Raison sociale:</td>
<td><input type="text" name="registro[razon_social]" value="@%db:Empresas.razon_social;%@" /></td>
</tr>
<tr><td class="etiqueta">Direction de facturacion:</td>
<td><input type="text" name="registro[direccion_facturacion]" value="@%db:Empresas.direccion_facturacion;%@" /></td>
</tr>
</table>

<table class="full">
<tr><td class="etiqueta">Capital Social:</td>
<td><input type="text" name="registro[capital_social]" value="@%db:Empresas.capital_social;%@" class="importe" /></td>
<td class="etiqueta">Registre du commerce:</td>
<td><input type="text" name="registro[inscripcion_registro]" value="@%db:Empresas.inscripcion_registro;%@" class="longtext" /></td>
</tr>
<tr><td class="etiqueta">NSF:</td>
<td><input type="text" name="registro[prefijo_cif]" value="@%db:Empresas.prefijo_cif;%@" size="3" />
 <input type="text" name="registro[cif]" value="@%db:Empresas.cif;%@" /></td>
<td class="etiqueta">Téléphone 1:</td>
<td><input type="text" name="registro[telefono1]" value="@%db:Empresas.telefono1;%@" size="14" /></td>
</tr>
<tr><td class="etiqueta">Ville:</td>
<td><input type="text" name="registro[poblacion]" value="@%db:Empresas.poblacion;%@" size="30" /></td>
<td class="etiqueta">Téléphone 2:</td>
<td><input type="text" name="registro[telefono2]" value="@%db:Empresas.telefono2;%@" size="14" /></td>
 </tr>
<tr><td class="etiqueta">CP:</td>
<td><input type="text" name="registro[cp]" value="@%db:Empresas.cp;%@" /></td>
<td class="etiqueta">Télécopieur:</td>
<td><input type="text" name="registro[fax]" value="@%db:Empresas.fax;%@" size="14" /></td>
 </tr>
<tr><td class="etiqueta">Province / État:</td>
<td colspan="3" ><!--@%db:Empresas.id_provincia;%@ @%set:_selected_value=Empresas.id_provincia;%@-->
<select name="registro[id_provincia]">
 @%where:tabla|Provincias;order|nombre;nolink|1;%@
 <option value="@%db:Provincias.id_provincia;%@" 
@%db:selected_value{Provincias.id_provincia;%@
>@%db:Provincias.nombre;%@</option>
 @%end-where:%@


</select></td>
 </tr>
<tr>
<td class="etiqueta">e-mail:</td>
<td><input type="text" name="registro[email]" value="@%db:Empresas.email;%@" class="email" /></td>
<td class="etiqueta">Web:</td>
<td><input type="text" name="registro[web]" value="@%db:Empresas.web;%@" class="url" /></td>
</tr>
</table>
 
<table class="full">
<caption class="caption">Autres renseignements</caption>

<tr><td class="etiqueta">Rétention à appliquer:</td>
<td> <input type="text" name="registro[retencion]" value="@%db:Empresas.retencion;%@" size="6" /></td>
 </tr>
<tr><td class="etiqueta @%css:Empresas.stock_negativo;label;%@">Stoc négativ:</td>
<td class="@%css:Empresas.stock_negativo;%@" ><input type="checkbox" name="registro[stock_negativo]" value="1" 
@%db:check_flag{Empresas.stock_negativo};%@ />
( @%css:Empresas.stock_negativo;label;%@ )
</td>
 </tr>
 </table>
 
<table class="full">
<caption class="caption">Remises par volume:</caption>

<tr><td class="etiqueta">% Rem. Bosses:</td>
<td colspan="1"><input type="text" name="registro[dto_gnrl_vol_bulto]" value="@%db:Empresas.dto_gnrl_vol_bulto;%@" size="5" maxlength="5" /></td>
<td class="etiqueta">Unit. Min :</td>
<td colspan="1"><input type="text" name="registro[dto_gnrl_vol_bulto_uds]" value="@%db:Empresas.dto_gnrl_vol_bulto_uds;%@" size="5" maxlength="5" /></td>
 </tr>
<tr><td class="etiqueta">% Rem. Cape:</td>
<td colspan="1"><input type="text" name="registro[dto_gnrl_vol_capa]" value="@%db:Empresas.dto_gnrl_vol_capa;%@" size="5" maxlength="5" /></td>
<td class="etiqueta">Unit. Min :</td>
<td colspan="1"><input type="text" name="registro[dto_gnrl_vol_capa_uds]" value="@%db:Empresas.dto_gnrl_vol_capa_uds;%@" size="5" maxlength="5" /></td>
 </tr>
<tr><td class="etiqueta">% Rem. Palet:</td>
<td colspan="1"><input type="text" name="registro[dto_gnrl_vol_palet]" value="@%db:Empresas.dto_gnrl_vol_palet;%@" size="5" maxlength="5" /></td>
<td class="etiqueta">Unit. Min :</td>
<td colspan="1"><input type="text" name="registro[dto_gnrl_vol_palet_uds]" value="@%db:Empresas.dto_gnrl_vol_palet_uds;%@" size="5" maxlength="5" /></td></tr>
</table>

