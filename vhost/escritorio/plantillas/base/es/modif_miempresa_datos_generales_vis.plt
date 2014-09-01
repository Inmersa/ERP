<table class="full">
<tr><td class="etiqueta">Nombre:</td>
<td>@%db:Empresas.nombre;%@</td>
<td rowspan="7" class="tdimgarticulo">
<!-- @%db:Empresas.id_imagen%@ @%set:id_img=Empresas.id_imagen%@ @%set:id_emp=Empresas.id_empresa%@ -->
@%where:db|db_catalogo;tabla|Catalogo_imagenes;%@
<img src="/catalogo/@%db:Catalogo_imagenes.nombre%@" border="0" width="200" >
@%set:sitiene_imagen=1;%@
@%end-where:%@

</td>
 </tr>
<tr><td class="etiqueta">Grupo al que pertenece:</td>
<td> <!--@%db:Empresas.id_provincia;%@ @%db:Empresas.id_grupo_empresa;%@-->
 @%where:tabla|Grupo_empresas;%@
 @%db:Grupo_empresas.nombre;%@
 @%end-where:%@

 </td></tr>
<tr><td class="etiqueta">Razón social:</td>
<td>@%db:Empresas.razon_social;%@</td>
</tr>
<tr><td class="etiqueta">Dirección de facturación:</td>
<td>@%db:Empresas.direccion_facturacion;%@</td>
</tr>
</table>

<table class="full">
<tr><td class="etiqueta">Capital Social:</td>
<td>@%db:Empresas.capital_social;%@</td>
<td class="etiqueta">Registro Mercantil:</td>
<td>@%db:Empresas.inscripcion_registro;%@</td>
</tr>
<tr><td class="etiqueta">CIF:</td>
<td>@%db:Empresas.prefijo_cif;%@ @%db:Empresas.cif;%@</td>
<td class="etiqueta">Teléfono 1:</td>
<td>@%db:Empresas.telefono1;%@</td>
</tr>
<tr><td class="etiqueta">Población:</td>
<td>@%db:Empresas.poblacion;%@</td>
<td class="etiqueta">Teléfono 2:</td>
<td>@%db:Empresas.telefono2;%@</td>
 </tr>
<tr><td class="etiqueta">CP:</td>
<td>@%db:Empresas.cp;%@</td>
<td class="etiqueta">Fax:</td>
<td>@%db:Empresas.fax;%@</td>
 </tr>
<tr><td class="etiqueta">Provincia:</td>
<td colspan="3" >
 @%where:tabla|Provincias;%@
@%db:Provincias.nombre;%@
 @%end-where:%@

</td>
 </tr>
<tr>
<td class="etiqueta">e-mail:</td>
<td colspan="3" >@%db:Empresas.email;%@</td>
<td class="etiqueta">web:</td>
<td>@%db:Empresas.web;%@</td>
</tr>
</table>
 
<table class="full">
<caption class="caption">Otros datos</caption>

<tr><td class="etiqueta">Retención a aplicar:</td>
<td> @%db:Empresas.retencion;%@</td>
 </tr>
<tr><td class="etiqueta">Stock negativo:</td>
<td>@%db:si_no_flag{Empresas.stock_negativo};%@</td>
 </tr>
 </table>
 
<table class="full">
<caption class="caption">Descuentos por Volumen:</caption>

<tr><td class="etiqueta">% Dto Bulto:</td>
<td colspan="1">@%db:Empresas.dto_gnrl_vol_bulto;%@</td>
<td class="etiqueta">Uds Min :</td>
<td colspan="1">@%db:Empresas.dto_gnrl_vol_bulto_uds;%@</td>
 </tr>
<tr><td class="etiqueta">% Dto Capa:</td>
<td colspan="1">@%db:Empresas.dto_gnrl_vol_capa;%@</td>
<td class="etiqueta">Uds Min :</td>
<td colspan="1">@%db:Empresas.dto_gnrl_vol_capa_uds;%@</td>
 </tr>
<tr><td class="etiqueta">% Dto Palet:</td>
<td colspan="1">@%db:Empresas.dto_gnrl_vol_palet;%@</td>
<td class="etiqueta">Uds Min :</td>
<td colspan="1">@%db:Empresas.dto_gnrl_vol_palet_uds;%@</td></tr>
</table>

