<table class="full">
<tr><td class="etiqueta">Nom:</td>
<td>@%db:Empresas.nombre;%@</td>
<td rowspan="7" class="tdimgarticulo">
<!-- @%db:Empresas.id_imagen%@ @%set:id_img=Empresas.id_imagen%@ @%set:id_emp=Empresas.id_empresa%@ -->
@%where:db|db_catalogo;tabla|Catalogo_imagenes;%@
<img src="/catalogo/@%db:Catalogo_imagenes.nombre%@" border="0" width="200" >
@%set:sitiene_imagen=1;%@
@%end-where:%@

</td>
 </tr>
<tr><td class="etiqueta">Groupe de clients:</td>
<td> <!--@%db:Empresas.id_provincia;%@ @%db:Empresas.id_grupo_empresa;%@-->
 @%where:tabla|Grupo_empresas;%@
 @%db:Grupo_empresas.nombre;%@
 @%end-where:%@

 </td></tr>
<tr><td class="etiqueta">Raison sociale:</td>
<td>@%db:Empresas.razon_social;%@</td>
</tr>
<tr><td class="etiqueta">Direction de facturacion:</td>
<td>@%db:Empresas.direccion_facturacion;%@</td>
</tr>
</table>

<table class="full">
<tr><td class="etiqueta">Capital Social:</td>
<td>@%db:Empresas.capital_social;%@</td>
<td class="etiqueta">Registre du commerce:</td>
<td>@%db:Empresas.inscripcion_registro;%@</td>
</tr>
<tr><td class="etiqueta">NSF:</td>
<td>@%db:Empresas.prefijo_cif;%@ @%db:Empresas.cif;%@</td>
<td class="etiqueta">Téléphone 1:</td>
<td>@%db:Empresas.telefono1;%@</td>
</tr>
<tr><td class="etiqueta">Ville:</td>
<td>@%db:Empresas.poblacion;%@</td>
<td class="etiqueta">Téléphone 2:</td>
<td>@%db:Empresas.telefono2;%@</td>
 </tr>
<tr><td class="etiqueta">CP:</td>
<td>@%db:Empresas.cp;%@</td>
<td class="etiqueta">Télécopieur:</td>
<td>@%db:Empresas.fax;%@</td>
 </tr>
<tr><td class="etiqueta">Province / État:</td>
<td colspan="3" >
 @%where:tabla|Provincias;%@
@%db:Provincias.nombre;%@
 @%end-where:%@

</td>
 </tr>
<tr>
<td class="etiqueta">e-mail:</td>
<td colspan="3" >@%db:Empresas.email;%@</td>
<td class="etiqueta">Web:</td>
<td>@%db:Empresas.web;%@</td>
</tr>
</table>
 
<table class="full">
<caption class="caption">Autres renseignements</caption>

<tr><td class="etiqueta">Rétention à appliquer:</td>
<td> @%db:Empresas.retencion;%@</td>
 </tr>
<tr><td class="etiqueta">Stoc négativ:</td>
<td>@%db:si_no_flag{Empresas.stock_negativo};%@</td>
 </tr>
 </table>
 
<table class="full">
<caption class="caption">Remises par volume:</caption>

<tr><td class="etiqueta">% Rem. Bosses:</td>
<td colspan="1">@%db:Empresas.dto_gnrl_vol_bulto;%@</td>
<td class="etiqueta">Unit. Min :</td>
<td colspan="1">@%db:Empresas.dto_gnrl_vol_bulto_uds;%@</td>
 </tr>
<tr><td class="etiqueta">% Rem. Cape:</td>
<td colspan="1">@%db:Empresas.dto_gnrl_vol_capa;%@</td>
<td class="etiqueta">Unit. Min :</td>
<td colspan="1">@%db:Empresas.dto_gnrl_vol_capa_uds;%@</td>
 </tr>
<tr><td class="etiqueta">% Rem. Palet:</td>
<td colspan="1">@%db:Empresas.dto_gnrl_vol_palet;%@</td>
<td class="etiqueta">Unit. Min :</td>
<td colspan="1">@%db:Empresas.dto_gnrl_vol_palet_uds;%@</td></tr>
</table>

