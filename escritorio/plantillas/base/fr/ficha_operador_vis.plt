
<div class="tituloseccion">&gt; Fiche d'Opérateur (@%db:Operadores.nombre;%@ @%db:Operadores.apellidos;%@)</div>

@%if:AllowedAction;Operadores;new;%@
<div id="AccionesEncabezado">
<ul>
<li><a href="?seccion=nuevo_operador" class="nuevo"><img src="imag/pixel.png" class="icono" /><span>Nouveau Opérateur</span></a></li>
</ul>
</div>
@%end-if:%@

<form name="ficha" action="?seccion=ficha_operador" method="post">
<input type="hidden" name="operadores[id_usr]" value="@%db:Operadores.id_usr;%@" />
<input type="hidden" name="operadores[id_empresa]" value="@%db:Operadores.id_empresa;%@" />
<input type="hidden" name="operadores[id_operador]" value="@%db:Operadores.id_operador;%@" />
<input type="hidden" name="accion_ejecutar" value="Modificar" />
<!-- @%set:id_usr = Operadores.id_usr;value|var;%@ -->

<fieldset id="FichaOperador" class="fsficha">
<legend>Contact</legend>
<table class="full">
 <tr>
 <td class="etiqueta" >Entreprise:</td>
 <td colspan="4">
 @%where:tabla|Empresas;%@
 @%db:Empresas.nombre;%@ 
 @%end-where:%@
 
</td>
 </tr>

 <tr> 
 <td class="etiqueta">Nom:</td>
 <td ><input type="text" name="operadores[nombre]" value="@%db:Operadores.nombre;%@" class="insertext" size="30"></td>
 <td class="etiqueta">Surnom:</td>
 <td colspan="2"><input type="text" name="operadores[apellidos]" value="@%db:Operadores.apellidos;%@" class="insertext" size="20"></td>
 </tr>

 <tr>
 <td class="etiqueta" >Id.number:</td>
 <td ><input type="text" name="operadores[dni]" value="@%db:Operadores.dni;%@" class="insertext" size="20"></td>
 <td class="etiqueta">Login:</td>
 <td colspan="2"><input type="hidden" name="operadores[login]" class="insertext" size="15"
 @%if:esta_vacio;id_usr;%@
 @%else:%@
 @%where:db|conf;tabla|Users;nolink|1;where|id_usr = $id_usr;%@
 value="@%db:Users.login;%@" 
 @%set:opr_login=Users.login;%@
 @%end-where:%@

 @%end-if:%@
 >@%get:opr_login;%@</td>
 </tr>

 <tr>
 <td class="etiqueta" >Direction:</td>
 <td ><input type="text" name="operadores[direccion]" value="@%db:Operadores.direccion;%@" class="insertext" size="30"></td>
 <td class="etiqueta" >Mot de pas.:</td>
 <td colspan="2"><input type="password" name="operadores[passwd]" class="insertext" size="20"></td>
 </tr>

 <tr>
 <td class="etiqueta" >e-mail:</td>
 <td ><input type="text" name="operadores[email]" value="@%db:Operadores.email;%@" class="insertext" size="30"></td>
 <td class="etiqueta" >Répéter mot de passe:</td>
 <td colspan="2"><input type="password" name="operadores[passwd2]" class="insertext" size="20"></td>
 </tr>

 @%if:esta_vacio;LinkCRM;%@
 @%else:%@
 <tr>
 <td class="etiqueta">Utilisateur CRM:</td>
 <td colspan="3" >
 <!--@%db:Operadores.crm_id_empleado%@ @%set:id_crm=Operadores.crm_id_empleado;%@ @%set:usuario_actual=0;%@ -->
 @%if:esta_vacio;Operadores.crm_id_empleado;%@
 @%else:%@
 @%where:tabla|Empleados;db|crm;nolink|1;where|id_empleado = $id_crm ;%@
 @%db:Empleados.nombre;%@ @%db:Empleados.apellidos;%@ (@%db:Empleados.email;%@)
 <!-- @%db:Empleados.id_empleado;%@ @%set:usuario_actual=Empleados.id_empleado;%@ -->
 @%end-where:%@
 
 @%end-if:%@
</td>

 </table>
 </fieldset>
<div class="AccionesEnvio">
<ul>
 <li><a href="#" onClick="return sendForm('ficha');" class="guardar" ><img src="imag/pixel.png" class="icono" /><span>Garder</span></a></li>
<li><a href="#" onClick="return resetForm('ficha');" class="deshacer" ><img src="imag/pixel.png" class="icono" /><span>Défaire changement</span></a></li>
</ul>
</div>

</form>
