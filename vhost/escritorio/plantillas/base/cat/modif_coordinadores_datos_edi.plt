

<form name="modif_coordinadores" action="?seccion=bo_coordinadores" method="post">
<input type="hidden" name="registro[id_usr]" value="@%db:Coordinadores.id_usr;%@" />
<input type="hidden" name="registro[id_empresa]" value="@%db:Coordinadores.id_empresa;%@" />
<input type="hidden" name="registro[id_coordinador]" value="@%db:Coordinadores.id_coordinador;%@" />
<input type="hidden" name="accion_ejecutar" value="Modificar" />
<!-- @%set:id_usr = Coordinadores.id_usr;value|var;%@ -->

<fieldset id="Ficha_Coordinador" class="fsficha">
<legend>Contacte</legend>
<table class="full">
 <tr>
 <td class="etiqueta" >Empresa:</td>
 <td colspan="4">
 @%where:tabla|Empresas;%@
 @%db:Empresas.nombre;%@ 
 @%end-where:%@
 
</td>
 </tr>

 <tr> 
 <td class="etiqueta">Nom:</td>
 <td ><input type="text" name="registro[nombre]" value="@%db:Coordinadores.nombre;%@" class="insertext" size="30"></td>
 <td class="etiqueta">Cognoms:</td>
 <td colspan="2"><input type="text" name="registro[apellidos]" value="@%db:Coordinadores.apellidos;%@" class="insertext" size="20"></td>
 </tr>

 <tr>
 <td class="etiqueta" >Dni:</td>
 <td ><input type="text" name="registro[dni]" value="@%db:Coordinadores.dni;%@" class="insertext" size="20"></td>
 <td class="etiqueta">Login:</td>
 <td colspan="2"><input type="text" name="registro[login]" class="insertext" size="15"
 @%if:esta_vacio;id_usr;%@
 @%else:%@
 @%where:db|conf;tabla|Users;nolink|1;where|id_usr = $id_usr;%@
 value="@%db:Users.login;%@" 
 @%end-where:%@

 @%end-if:%@
 ></td>
 </tr>

 <tr>
 <td class="etiqueta" >Adre�a:</td>
 <td ><input type="text" name="registro[direccion]" value="@%db:Coordinadores.direccion;%@" class="insertext" size="30"></td>
 <td class="etiqueta" >Contr.:</td>
 <td colspan="2"><input type="password" name="registro[passwd]" class="insertext" size="20"></td>
 </tr>

 <tr>
 <td class="etiqueta" >e-mail:</td>
 <td ><input type="text" name="registro[email]" value="@%db:Coordinadores.email;%@" class="insertext" size="30"></td>
 <td class="etiqueta" >Repetir contrasenya:</td>
 <td colspan="2"><input type="password" name="registro[passwd2]" class="insertext" size="20"></td>
 </tr>

 @%if:esta_vacio;LinkCRM;%@
 @%else:%@
 <tr>
 <td class="etiqueta">Usuari CRM:</td>
 <td>
 <!--@%db:Coordinadores.crm_id_empleado%@ @%set:id_crm=Coordinadores.crm_id_empleado;%@ @%set:usuario_actual=0;%@ -->
 @%if:esta_vacio;Coordinadores.crm_id_empleado;%@
 @%else:%@
 @%where:tabla|Empleados;db|crm;nolink|1;where|id_empleado = $id_crm ;%@
 @%db:Empleados.nombre;%@ @%db:Empleados.apellidos;%@ (@%db:Empleados.email;%@)
 <!-- @%db:Empleados.id_empleado;%@ @%set:usuario_actual=Empleados.id_empleado;%@ -->
 @%end-where:%@
 
 @%end-if:%@
</td>
 <td class="etiqueta" >
 @%if:AllowedLink;crm_seleccionar_empleado;%@
 <a href="?seccion=crm_seleccionar_empleado&id=@%get:usuario_actual;%@" >Assignar</a>
 @%end-if:%@
 
 </td>
 <td class="etiqueta">Desmarcar</td>
 <td class="check"><input type="checkbox" name="acciones[descartar_usuario_crm]" value="1" ></td>
 </tr>
 @%end-if:%@

 <tr>

 </table>
 </fieldset>
<div class="AccionesEnvio">
<ul>
 <li><a href="#" onClick="return sendForm('modif_coordinadores');" class="guardar" ><img src="images/pixel.png" class="icono" /><span>Guardar</span></a></li>
<li><a href="#" onClick="return resetForm('modif_coordinadores');" class="deshacer" ><img src="images/pixel.png" class="icono" /><span>Desfer canvis</span></a></li>
</ul>
</div>

</form>
