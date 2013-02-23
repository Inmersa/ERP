
<form name="modif_tipos_iva" action="?seccion=bo_tipos_iva" method="post">
<input type="hidden" name="registro[id_iva]" value="@%db:Tipos_IVA.id_iva;%@" />
<input type="hidden" name="estado" value="1" /> 
<input type="hidden" name="cc_old[cc_imp_soportado]" value="@%db:Tipos_IVA.cc_imp_soportado;%@" />
<input type="hidden" name="cc_old[cc_imp_repercutido]" value="@%db:Tipos_IVA.cc_imp_repercutido;%@" />
<input type="hidden" name="cc_old[cc_re_soportado]" value="@%db:Tipos_IVA.cc_re_soportado;%@" />
<input type="hidden" name="cc_old[cc_re_repercutido]" value="@%db:Tipos_IVA.cc_re_repercutido;%@" />
<input type="hidden" name="cc_old[cc_ce_soportado]" value="@%db:Tipos_IVA.cc_ce_soportado;%@" />
<input type="hidden" name="cc_old[cc_ce_repercutido]" value="@%db:Tipos_IVA.cc_ce_repercutido;%@" />
 <!--@%db:Tipos_IVA.id_iva;%@-->
<fieldset class="fsficha" >
<legend>@%db:Tipos_IVA.nombre;%@</legend>
<table class="full">
 <tr><td class="etiqueta" >Nome:</td>
 <td ><input type="text" name="registro[nombre]" value="@%db:Tipos_IVA.nombre;%@" class="minitext" /></td>
 </tr>
 <tr><td class="etiqueta" >Percentagem:</td>
 <td ><input type="text" name="registro[porcentaje]" value="@%db:Tipos_IVA.porcentaje;%@" class="num" /></td>
 </tr>
 <tr><td class="etiqueta" >CC de IVA a Pagar:</td>
 <td ><input type="text" name="registro[cc_imp_repercutido]" value="@%db:Tipos_IVA.cc_imp_repercutido;%@" class="cc" /></td>
 </tr>
 <tr><td class="etiqueta" > CC de IVA Suportado:</td>
 <td ><input type="text" name="registro[cc_imp_soportado]" value="@%db:Tipos_IVA.cc_imp_soportado;%@" class="cc" /></td>
 </tr>
 <tr><td class="etiqueta" >Sobretaxa Equivalente:</td>
 <td ><input type="text" name="registro[recargo_equivalente]" value="@%db:Tipos_IVA.recargo_equivalente;%@" class="num" /></td>
 </tr>
 <tr><td class="etiqueta" >CC Sobretaxa Equivalente a Pagar:</td>
 <td ><input type="text" name="registro[cc_re_repercutido]" value="@%db:Tipos_IVA.cc_re_repercutido;%@" class="cc" /></td>
 </tr>
 <tr><td class="etiqueta" >CC Sobretaxa Equivalente Suportada:</td>
 <td ><input type="text" name="registro[cc_re_soportado]" value="@%db:Tipos_IVA.cc_re_soportado;%@" class="cc" /></td>
 </tr>
 <tr><td class="etiqueta" >Conta Contabilística Imposto Comunitário a Pagar:</td>
 <td ><input type="text" name="registro[cc_ce_repercutido]" value="@%db:Tipos_IVA.cc_ce_repercutido;%@" class="cc" /></td>
 </tr>
 <tr><td class="etiqueta" >Conta Contabilística Imposto Comunitário Suportado:</td>
 <td ><input type="text" name="registro[cc_ce_soportado]" value="@%db:Tipos_IVA.cc_ce_soportado;%@" class="cc" /></td>
 </tr>
 </table>
</fieldset>
</form>

<div class="AccionesEnvio"><ul>
 <li><a href="#" onClick="return sendForm('modif_tipos_iva');"  class="guardar" ><img src="imag/pixel.png" class="icono" /><span>Guardar</span></a></li> 
 <li><a href="#" onClick="return resetForm('modif_tipos_iva');"  class="deshacer" ><img src="imag/pixel.png" class="icono" /><span>Desfazer Alterações</span></a></li>
 <li><a href="?seccion=bo_tipos_iva&estado=2&registro[id_iva]=@%db:Tipos_IVA.id_iva%@" 
 	onClick="return confirm('¿É você certo que você quer suprimir registros selecionados?');"  class="borrar" ><img src="imag/pixel.png" class="icono" /><span>Eliminar</span></a></li>
</ul></div>

