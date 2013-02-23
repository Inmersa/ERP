@%where:tabla|Clientes_empresas;where|Clientes_empresas.id_empresa = $id_empresa and Clientes_empresas.id_cliente= $id_cliente_promocion;%@

<fieldset class="fsficha">
<legend>Clients entreprise</legend>

<input type="hidden" name="registro2[id_cliente]" value="@%db:Clientes_empresas.id_cliente%@" />
<input type="hidden" name="registro2[id_recomendador]" value="@%db:Clientes_empresas.id_recomendador%@" />

 <table class="full">

 <tr><td class="etiqueta">Tarif:</td>
 <td> <!--@%db:Clientes_empresas.id_tarifa%@ -->
 @%where:tabla|Tarifas;order|nombre;%@
@%db:Tarifas.nombre%@
 @%end-where:%@

 </td>
 <td class="etiqueta">Modalité de paiment:</td>
 <td> 
<!--@%db:Clientes_empresas.id_forma_pago%@ -->
 @%where:tabla|Forma_pago;order|nombre;%@
@%db:Forma_pago.nombre%@
 @%end-where:%@

 </td></tr>

 <tr><td class="etiqueta" >Importance</td>
 <td> <!-- @%db:Clientes_empresas.id_importancia;%@ -->
 @%where:tabla|Importancias;order|nombre;%@
 @%db:Importancias.nombre;%@
 @%end-where:%@

 </td>
 <td class="etiqueta">Type client:</td>
 <td> <!--@%db:Clientes_empresas.id_tipo_cliente%@ -->
 @%where:tabla|Tipo_cliente;order|nombre;%@
@%db:Tipo_cliente.nombre%@
 @%end-where:%@

 </select>
 </td></tr>

 <tr> <td class="etiqueta">Devise:</td>
 <td>
 <!-- @%db:Clientes.id_divisa%@ -->
 @%where:tabla|Divisa;%@
@%db:Divisa.nombre%@
 @%end-where:%@

 </select>
 </td>
 <td class="etiqueta" align="right">Retient:</td>
 <td colspan="3" class="texto"> 
 <input type="hidden" name="registro2[aplicar_retencion]" value="1" size="30" @%db:check_flag{Clientes_empresas.aplicar_retencion};%@ />
 @%db:si_no_flag{Clientes_empresas.aplicar_retencion;%@
 </td></tr>
 </table>
</fieldset>

<fieldset id="ClienteDiasFacturacion" class="fsficha">
<legend>Jours de paiement</legend>
 <table class="full">
 <tr>
 <td class="etiqueta">Premièr</td>
 <td>@%db:Clientes_empresas.dia_facturacion_1%@</td>
 <td class="etiqueta">Seconde</td>
 <td>@%db:Clientes_empresas.dia_facturacion_2%@</td>
 <td class="etiqueta">Troisième</td>
 <td>@%db:Clientes_empresas.dia_facturacion_3%@</td>
 </tr>
</table>
</fieldset>

