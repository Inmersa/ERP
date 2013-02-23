@%where:tabla|Articulos;where|Articulos.id_articulo = $id_articulo and Empresas_articulos.id_empresa = $id_empresa;%@
<fieldset class="fsficha">
<legend>Prixes</legend>

<table class="full"><tbody><tr>
<td class="etiqueta">WEB / Caisse enregistreuse</td>
<td class="check"><input type="checkbox" name="registro2[wwwactivo]" value="1" @%db:check_flag{Empresas_articulos.wwwactivo}%@ /></td>
<td class="etiqueta">Web Home</td>
<td class="check"><input type="checkbox" name="registro2[wwwhome]" value="1" @%db:check_flag{Empresas_articulos.wwwhome}%@ /></td>
<td class="etiqueta">Portail</td>
<td class="check"><input type="checkbox" name="registro2[wwwportada]" value="1" @%db:check_flag{Empresas_articulos.wwwportada}%@ /></td>
<td class="etiqueta">Soulign�</td>
<td class="check"><input type="checkbox" name="registro2[wwwdestacado]" value="1" @%db:check_flag{Empresas_articulos.wwwdestacado}%@ /></td>
</tr></tbody></table>

<table class="full"><tbody><tr>
<td class="etiqueta">{{fld_websinopsis}}</td>
<td ><textarea class="longdesc" name="registro[wwwsinopsis]" >@%db:Articulos.wwwsinopsis;%@</textarea></td>
</tr><tr>
<td class="etiqueta">{{fld_webdescripcion}}</td>
<td ><textarea class="longdesc" name="registro[wwwdescripcion]" >@%db:Articulos.wwwdescripcion;%@</textarea></td>
</tr></tbody></table>

</fieldset>

