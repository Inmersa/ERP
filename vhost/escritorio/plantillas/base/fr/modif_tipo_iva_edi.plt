
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
 <tr><td class="etiqueta" >Nom:</td>
 <td ><input type="text" name="registro[nombre]" value="@%db:Tipos_IVA.nombre;%@" class="minitext" /></td>
 </tr>
 <tr><td class="etiqueta" >Pourcentage:</td>
 <td ><input type="text" name="registro[porcentaje]" value="@%db:Tipos_IVA.porcentaje;%@" class="num" /></td>
 </tr>
 <tr><td class="etiqueta" >CC TVA Pay�e:</td>
 <td ><input type="text" name="registro[cc_imp_repercutido]" value="@%db:Tipos_IVA.cc_imp_repercutido;%@" class="cc" /></td>
 </tr>
 <tr><td class="etiqueta" > CC TVA Exigible:</td>
 <td ><input type="text" name="registro[cc_imp_soportado]" value="@%db:Tipos_IVA.cc_imp_soportado;%@" class="cc" /></td>
 </tr>
 <tr><td class="etiqueta" >Reteneu �quivalent:</td>
 <td ><input type="text" name="registro[recargo_equivalente]" value="@%db:Tipos_IVA.recargo_equivalente;%@" class="num" /></td>
 </tr>
 <tr><td class="etiqueta" >CC Reteneu �quivalent Pay�e:</td>
 <td ><input type="text" name="registro[cc_re_repercutido]" value="@%db:Tipos_IVA.cc_re_repercutido;%@" class="cc" /></td>
 </tr>
 <tr><td class="etiqueta" >CC Reteneu �quivalent Exigible:</td>
 <td ><input type="text" name="registro[cc_re_soportado]" value="@%db:Tipos_IVA.cc_re_soportado;%@" class="cc" /></td>
 </tr>
 <tr><td class="etiqueta" >Compte Comptable Imp�t Communautaire R�percut�:</td>
 <td ><input type="text" name="registro[cc_ce_repercutido]" value="@%db:Tipos_IVA.cc_ce_repercutido;%@" class="cc" /></td>
 </tr>
 <tr><td class="etiqueta" >Compte Comptable Imp�t Communautaire Support�:</td>
 <td ><input type="text" name="registro[cc_ce_soportado]" value="@%db:Tipos_IVA.cc_ce_soportado;%@" class="cc" /></td>
 </tr>
 </table>
</fieldset>
</form>

<div class="AccionesEnvio"><ul>
 <li><a href="#" onClick="return sendForm('modif_tipos_iva');"  class="guardar" ><img src="imag/pixel.png" class="icono" /><span>Garder</span></a></li> 
 <li><a href="#" onClick="return resetForm('modif_tipos_iva');"  class="deshacer" ><img src="imag/pixel.png" class="icono" /><span>D�faire changement</span></a></li>
 <li><a href="?seccion=bo_tipos_iva&estado=2&registro[id_iva]=@%db:Tipos_IVA.id_iva%@" 
 	onClick="return confirm('�tes-vous s�r que vous voulez supprimer des enregistrements choisis?');"  class="borrar" ><img src="imag/pixel.png" class="icono" /><span>Effacer</span></a></li>
</ul></div>

