
<div class="tituloseccion">&gt; Ficha de Operador (@%db:Operadores.nombre;%@ @%db:Operadores.apellidos;%@)</div>

@%if:AllowedAction;Operadores;new;%@
<div id="AccionesEncabezado">
<ul>
<li><a href="?seccion=nuevo_operador" class="nuevo"><img src="imag/pixel.png" class="icono" /><span>Novo Operador</span></a></li>
</ul>
</div>
@%end-if:%@

<form name="ficha" action="?seccion=operadores" method="post">
<input type="hidden" name="operadores[id_usr]" value="@%db:Operadores.id_usr;%@" />
<input type="hidden" name="operadores[id_empresa]" value="@%db:Operadores.id_empresa;%@" />
<input type="hidden" name="operadores[id_operador]" value="@%db:Operadores.id_operador;%@" />
<input type="hidden" name="accion_ejecutar" value="Modificar" />
<!-- @%set:id_usr = Operadores.id_usr;value|var;%@ -->

<fieldset id="FichaOperador" class="fsficha">
<legend>Dados do Contacto</legend>
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
 <td class="etiqueta">Nome:</td>
 <td ><input type="text" name="operadores[nombre]" value="@%db:Operadores.nombre;%@" class="insertext" size="30"></td>
 <td class="etiqueta">Apelidos:</td>
 <td colspan="2"><input type="text" name="operadores[apellidos]" value="@%db:Operadores.apellidos;%@" class="insertext" size="20"></td>
 </tr>

 <tr>
 <td class="etiqueta" >Dni:</td>
 <td ><input type="text" name="operadores[dni]" value="@%db:Operadores.dni;%@" class="insertext" size="20"></td>
 <td class="etiqueta">Iniciar Sessão:</td>
 <td colspan="2"><input type="text" name="operadores[login]" class="insertext" size="15"
 @%if:esta_vacio;id_usr;%@
 @%else:%@
 @%where:db|conf;tabla|Users;nolink|1;where|id_usr = $id_usr;%@
 value="@%db:Users.login;%@" 
 @%end-where:%@

 @%end-if:%@
 ></td>
 </tr>

 <tr>
 <td class="etiqueta" >Endereço:</td>
 <td ><input type="text" name="operadores[direccion]" value="@%db:Operadores.direccion;%@" class="insertext" size="30"></td>
 <td class="etiqueta" >Palavra-Passe:</td>
 <td colspan="2"><input type="password" name="operadores[passwd]" class="insertext" size="20"></td>
 </tr>

 <tr>
 <td class="etiqueta" >e-mail:</td>
 <td ><input type="text" name="operadores[email]" value="@%db:Operadores.email;%@" class="insertext" size="30"></td>
 <td class="etiqueta" >Repetir a Palavra-Passe:</td>
 <td colspan="2"><input type="password" name="operadores[passwd2]" class="insertext" size="20"></td>
 </tr>

 @%if:esta_vacio;LinkCRM;%@
 @%else:%@
 <tr>
 <td class="etiqueta">Utilizador CRM:</td>
 <td>
 <!--@%db:Operadores.crm_id_empleado%@ @%set:id_crm=Operadores.crm_id_empleado;%@ @%set:usuario_actual=0;%@ -->
 @%if:esta_vacio;Operadores.crm_id_empleado;%@
 @%else:%@
 @%where:tabla|Empleados;db|crm;nolink|1;where|id_empleado = $id_crm ;%@
 @%db:Empleados.nombre;%@ @%db:Empleados.apellidos;%@ (@%db:Empleados.email;%@)
 <!-- @%db:Empleados.id_empleado;%@ @%set:usuario_actual=Empleados.id_empleado;%@ -->
 @%end-where:%@
 
 @%end-if:%@
</td>
 <td class="etiqueta" >
 @%if:AllowedLink;crm_seleccionar_empleado;%@
 <a href="?seccion=crm_seleccionar_empleado&id=@%get:usuario_actual;%@" >Atribuir</a>
 @%end-if:%@
 
 </td>
 <td class="etiqueta">Anular</td>
 <td class="check"><input type="checkbox" name="acciones[descartar_usuario_crm]" value="1" ></td>
 </tr>
 @%end-if:%@

 <tr>

 </table>
 </fieldset>
<div class="AccionesEnvio">
<ul>
 <li><a href="#" onClick="return sendForm('ficha');" class="guardar" ><img src="imag/pixel.png" class="icono" /><span>Guardar</span></a></li>
<li><a href="#" onClick="return resetForm('ficha');" class="deshacer" ><img src="imag/pixel.png" class="icono" /><span>Desfazer Alterações</span></a></li>
</ul>
</div>

</form>
