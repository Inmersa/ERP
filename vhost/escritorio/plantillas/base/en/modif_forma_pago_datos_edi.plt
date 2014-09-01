@%where:tabla|Forma_pago;%@

 <form name="modif_forma_pago" action="?seccion=bo_forma_pago" method="post">
<input type="hidden" name="registro[id_forma_pago]" value="@%db:Forma_pago.id_forma_pago;%@">
<input type="hidden" name="estado" value="1">
<table class="full">
 <tr> <td class="etiqueta" >Name:</td>
 <td ><input type="text" name="registro[nombre]" value="@%db:Forma_pago.nombre;%@" class="insertext" size="55"></td>
 </tr>
 <tr> <td class="etiqueta" >Nº Bank drafts:</td>
 <td ><input type="text" name="registro[num_efectos]" value="@%db:Forma_pago.num_efectos;%@" class="insertext" size="55"></td>
 </tr>
 <tr> <td class="etiqueta" >Days between Bank drafts:</td>
 <td ><input type="text" name="registro[dias_efectos]" value="@%db:Forma_pago.dias_efectos;%@" class="insertext" size="55"></td>
 </tr>
 <tr><td class="etiqueta" >Method of payment:</td>
 <td > 
 <!-- @%db:Forma_pago.medio_pago;%@ @%set:medio_pago=Forma_pago.medio_pago;%@ -->
 <select name="registro[medio_pago]" class="insertext">
 <option value="efectivo"
@%if:equals;medio_pago;efectivo;%@
SELECTED
@%end-if:%@
 >Cash</option>
 <option value="cheque"
@%if:equals;medio_pago;cheque;%@
SELECTED
@%end-if:%@
 >Cheque</option>
 <option value="transferencia"
@%if:equals;medio_pago;transferencia;%@
SELECTED
@%end-if:%@
 >Cash transfer</option>
 <option value="pagare"
@%if:equals;medio_pago;pagare;%@
SELECTED
@%end-if:%@
 >Promissory note</option>
 <option value="recibo"
@%if:equals;medio_pago;recibo;%@
SELECTED
@%end-if:%@
 >Receipt</option>
 </select>
 </td>
 </table>
 </form>
 <div class="enviar">
 <a href="#" onClick="return sendForm('modif_forma_pago');" >Save</a> 
 <a href="#" onClick="return resetForm('modif_forma_pago');" >Undo changes</a>
 <a href="?seccion=bo_forma_pago&estado=2&registro[id_forma_pago]=@%db:Forma_pago.id_forma_pago%@" 
 	onClick="return confirm('Are you sure that do you want to delete the selected registries?');" >Delete</a> </div>
@%end-where:%@ 
