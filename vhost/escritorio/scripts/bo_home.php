<?php
/** Devuelve la cabecera oportuna en funcion de el grupo de usuarios al ke pertenezca el login
Actualmente 1  -> cliente
            2  -> agente
            4  -> empresa
            8  -> proveedor
            16 -> almacen
            32 -> administrativos
            64 -> grupo de empresas
*/
function pre_acceso(&$Sesion){
$paso = $Sesion->get_var("login");
if($paso) return;
//debug("Ejectuando precode");
//depurar_array($Sesion->get_plt_array_all());
$mascara_grupo = $Sesion->Access->oUsr->group_mask;
if(($mascara_grupo & 1) != 0){
//clientes
     $Sesion->change_plt("cabecera","bo_cabecera_cliente.plt");
     $Sesion->set_var("login","paso");
     //return "bo_principal2.plt";

      //ya ke sabemos ke es un cliente y ke no cambian sus datos aprovecho pa meter en la sesion
      //el control de imposiciones de un cliente , dto , tarifa  ......
      $control_imposiciones = $Sesion->get_var("control_imposiciones_cliente");

      if(!isset($control_imposiciones)){
             $usuario = identifica_usuarios($Sesion);
             $consulta = "select Empresas.id_empresa ,Clientes_empresas.id_forma_pago , Clientes_empresas.id_divisa ,  pto_primero , pto_segundo , monto , campo_accion , retencion , aplicar_iva , aplicar_recargo , dto_directo , dto_pronto_pago , aplicar_retencion ,mostrar_ofertas
                          from Clientes_empresas , Tipo_cliente ,Empresas  , Tarifas where
                             id_cliente = $usuario[id] and
                             Clientes_empresas.id_usr = $usuario[id_usr] and
                             Clientes_empresas.id_empresa = Empresas.id_empresa and
                             Clientes_empresas.id_tipo_cliente = Tipo_cliente.id_tipo_cliente and
                             Clientes_empresas.id_tarifa = Tarifas.id_tarifa";
             $resul5=$Sesion->query($consulta);
             $row5=$Sesion->fetch_array($resul5);
             $Sesion->set_var("id_empresa",$row5[id_empresa]);
             $Sesion->set_var("id_cliente",$usuario[id]);
             $Sesion->set_var("control_imposiciones_cliente",$row5);
//           depurar_array($row5);
             }

     return "bo_cabecera_cliente.plt";

     }
if(($mascara_grupo & 2) != 0){
//agentes
     $Sesion->change_plt("cabecera","bo_cabecera_agente.plt");
     $Sesion->set_var("login","paso");
     return "bo_cabecera_agente.plt";
     }
if(($mascara_grupo & 4) != 0){
//empresarios
     $Sesion->change_plt("cabecera","bo_cabecera.plt");
     $Sesion->set_var("login","paso");
     return "bo_cabecera.plt";
     }
if(($mascara_grupo & 8) != 0){
//proveedores
     $Sesion->change_plt("cabecera","bo_cabecera_proveedor.plt");
     $Sesion->set_var("login","paso");
     return "bo_cabecera_proveedor.plt";
     }
if(($mascara_grupo & 16) != 0){
//almaceneros
     $Sesion->change_plt("cabecera","bo_cabecera_almacen.plt");
     $Sesion->set_var("login","paso");
     return "bo_cabecera_almacen.plt";
     }
if(($mascara_grupo & 32) != 0){
//administrativos
     $Sesion->change_plt("cabecera","bo_cabecera.plt");
     $Sesion->set_var("login","paso");
     return "bo_cabecera.plt";
     }
if(($mascara_grupo & 64) != 0){
//administrativos
     $Sesion->change_plt("cabecera","bo_cabecera_grupo_empresas.plt");
     $Sesion->set_var("login","paso");
     return "bo_cabecera_grupo_empresas.plt";
     }
}

?>
