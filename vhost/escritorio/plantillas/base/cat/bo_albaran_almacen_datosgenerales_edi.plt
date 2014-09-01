@%where:nodb|class_dbItemMultiEntity_iface;nombre|FichaAlbaran;%@

 <fieldset id="Albaran_Almacen_DatosGenerales" class="fsficha">
 <legend>Informació de emissor i receptor</legend>

<table class="fullstruct">
<tr><td>
<table class="full">
<caption class="titulotb">{{fld_remite}}</caption>

<tr>
<td class="etiqueta">Nom</td>
<td>@%db:Origen.nombre;%@</td>
</tr>
<tr>
<td class="etiqueta">Domicili</td>
<td>@%db:Origen.direccion;%@</td>
</tr>
<tr>
<td class="etiqueta">Codi</td>
<td>@%db:Origen.cp;%@</td>
</tr>
<tr>
<td class="etiqueta">Població</td>
<td>@%db:Origen.poblacion;%@</td>
</tr>
<tr>
<td class="etiqueta">Província</td>
<td>@%db:Origen.provincia_nombre;%@ (FixMe: Falta obtener este dato)</td>
</tr>
<tr>
<td class="etiqueta">Fax</td>
<td>@%db:Origen.fax;%@</td>
</tr>
<tr>
<td class="etiqueta">Telèfon</td>
<td>@%db:Origen.telefono;%@</td>
</tr>
</table>

</td><td>

<table class="full">
<caption class="titulotb">{{frame_destino}}</caption>
<tr><td class="etiqueta">Nom:</td>
<td colspan="3">@%db:Destino.nombre;%@</td>
</tr>
<tr><td class="etiqueta">Codi:</td>
<td colspan="3">@%db:Destino.id;%@</td>
</tr>
<tr><td class="etiqueta">Domicili:</td>
<td colspan="3">@%db:Destino.direccion;%@</td>
 </tr>
<tr><td class="etiqueta">Població:</td>
<td colspan="3"> @%db:Destino.poblacion;%@</td>
 </tr>
<tr><td class="etiqueta">Província:</td>
<td>@%db:Destino.provincia_nombre;%@ (FixMe: Falta Obtener este dato)</td>
<td class="etiqueta">CP:</td>
<td>@%db:Destino.cp;%@</td>
 </tr>
<tr><td class="etiqueta">CIF:</td>
<td colspan="3">
@%if:!esta_vacio;Destino.prefijo_cif;%@
@%db:Destino.prefijo_cif;%@ -
@%end-if:%@
@%db:Destino.cif;%@</td>
 </tr>
<tr><td class="etiqueta">Telèfon:</td>
<td>@%db:Destino.telefono;%@</td>
<td class="etiqueta">Fax:</td>
<td>@%db:Destino.fax;%@</td>
 </tr>
<tr><td class="etiqueta">e-mail:</td>
<td colspan="3"><a href="mailto:@%db:Destino.email;%@">@%db:Destino.email;%@</a></td>
 </tr>
</table>


</td></tr></table>
</fieldset>

