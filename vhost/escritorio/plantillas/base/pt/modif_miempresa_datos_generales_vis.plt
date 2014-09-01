<table class="full">
<tr><td class="etiqueta">Nome:</td>
<td>@%db:Empresas.nombre;%@</td>
<td rowspan="7" class="tdimgarticulo">
<!-- @%db:Empresas.id_imagen%@ @%set:id_img=Empresas.id_imagen%@ @%set:id_emp=Empresas.id_empresa%@ -->
@%where:db|db_catalogo;tabla|Catalogo_imagenes;%@
<img src="/catalogo/@%db:Catalogo_imagenes.nombre%@" border="0" width="200" >
@%set:sitiene_imagen=1;%@
@%end-where:%@

</td>
 </tr>
<tr><td class="etiqueta">Grupo a que Pertence:</td>
<td> <!--@%db:Empresas.id_provincia;%@ @%db:Empresas.id_grupo_empresa;%@-->
 @%where:tabla|Grupo_empresas;%@
 @%db:Grupo_empresas.nombre;%@
 @%end-where:%@

 </td></tr>
<tr><td class="etiqueta">Denominação Comercial:</td>
<td>@%db:Empresas.razon_social;%@</td>
</tr>
<tr><td class="etiqueta">Endereço de Facturação:</td>
<td>@%db:Empresas.direccion_facturacion;%@</td>
</tr>
</table>

<table class="full">
<tr><td class="etiqueta">Capital Social:</td>
<td>@%db:Empresas.capital_social;%@</td>
<td class="etiqueta">Conservatória:</td>
<td>@%db:Empresas.inscripcion_registro;%@</td>
</tr>
<tr><td class="etiqueta">CIF:</td>
<td>@%db:Empresas.prefijo_cif;%@ @%db:Empresas.cif;%@</td>
<td class="etiqueta">Telefone 1:</td>
<td>@%db:Empresas.telefono1;%@</td>
</tr>
<tr><td class="etiqueta">Localidade:</td>
<td>@%db:Empresas.poblacion;%@</td>
<td class="etiqueta">Telefone 2:</td>
<td>@%db:Empresas.telefono2;%@</td>
 </tr>
<tr><td class="etiqueta">CP:</td>
<td>@%db:Empresas.cp;%@</td>
<td class="etiqueta">Fax:</td>
<td>@%db:Empresas.fax;%@</td>
 </tr>
<tr><td class="etiqueta">Distrito:</td>
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
<caption class="caption">Dados Adicionais</caption>

<tr><td class="etiqueta">Retenção a Aplicar:</td>
<td> @%db:Empresas.retencion;%@</td>
 </tr>
<tr><td class="etiqueta">Stock Negativo:</td>
<td>@%db:si_no_flag{Empresas.stock_negativo};%@</td>
 </tr>
 </table>
 
<table class="full">
<caption class="caption">Desconto por Quantidade:</caption>

<tr><td class="etiqueta">% Desconto por Embalagem:</td>
<td colspan="1">@%db:Empresas.dto_gnrl_vol_bulto;%@</td>
<td class="etiqueta">Unidades Mínimas :</td>
<td colspan="1">@%db:Empresas.dto_gnrl_vol_bulto_uds;%@</td>
 </tr>
<tr><td class="etiqueta">% Desconto por Camada de Palete:</td>
<td colspan="1">@%db:Empresas.dto_gnrl_vol_capa;%@</td>
<td class="etiqueta">Unidades Mínimas :</td>
<td colspan="1">@%db:Empresas.dto_gnrl_vol_capa_uds;%@</td>
 </tr>
<tr><td class="etiqueta">% Desconto por Palete:</td>
<td colspan="1">@%db:Empresas.dto_gnrl_vol_palet;%@</td>
<td class="etiqueta">Unidades Mínimas :</td>
<td colspan="1">@%db:Empresas.dto_gnrl_vol_palet_uds;%@</td></tr>
</table>

