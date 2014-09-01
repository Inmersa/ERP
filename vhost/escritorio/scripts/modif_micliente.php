<?php
/** Modificacion de datos de un cliente por un cliente
*
*/
function pre_micliente(&$Sesion) {
global $accion_ejecutar;
global $registro;
global $registro2;
global $registro_dir;
global $borrar_direcciones;

$usuario = identifica_usuarios($Sesion);
//depurar_array($usuario);
$Sesion->set_var("id_cliente_promocion",$usuario[id]);
//debug($accion_ejecutar);

switch($accion_ejecutar){
        case "Modificar" :
         if(isset($registro_dir)){
                $registro_dir["id_cliente"] = $usuario[id];
                tb_replace("Direcciones_entrega",$registro_dir);
                return;
                }
        if(isset($registro)){
              $db_conf = $Sesion->get_db('conf');
              if(!(is_object($db_conf))) return "error";

             $consulta2="select login  from Users where login ='$registro[login]' and id_usr !=". $registro["id_usr"];
             $rs2 = $db_conf->query($consulta2);
             $row2=$db_conf->fetch_array($rs2);
             if($row2){//el login ya estaba pillao
    //                        depurar_array($row);
                    aviso("Login ya seleccionado");
                    return ;
                    }
             $consulta="select  passwd from Users where id_usr =" .$registro["id_usr"];
             $r44s = $db_conf->query($consulta);
             $row22=$db_conf->fetch_array($r44s);
    //                depurar_array($row2);
             $user["passwd"] = $row22[0];
             $user["id_usr"] =  $registro["id_usr"];
             $user["nombre"] = $registro["login"];
             $user["login"] =  $registro["login"];
             $user["av_group"] =  1;
             $user["activo"] =  1;
    //                  depurar_array($user);
             tb_replace_act($db_conf,"Users",$user);

             if($registro["passwd"] != "" AND $registro["passwd2"] != "" AND( $registro["passwd2"] == $registro["passwd"]) ){
                 $consulta="update Users set passwd=PASSWORD('$registro[passwd]') where id_usr =$registro[id_usr]";
                 $db_conf->query($consulta);
                 }
             $registro["fecha_alta"]=descolocar_fecha($registro["fecha_alta"]);
             tb_replace("Clientes",$registro);
             }
        break;
        case "Nuevo" :
        //Nueva direccion
        if(isset($registro_dir)){
                $registro_dir["id_cliente"] = $usuario[id];
                  tb_replace("Direcciones_entrega",$registro_dir);
                return;
                }
        break;
        case "Borrar" :
        if(isset($borrar_direcciones)){
                foreach($borrar_direcciones as $clave => $valor)
                        if($valor == 1 ){
                                $consulta="delete from Direcciones_entrega
                                          where Direcciones_entrega.id_direccion = $clave";
                                $Sesion->query($consulta);
                                }
                }
        break;

        }//fin del case

}//fin del precode
function obtener_Direcciones_entrega(&$Sesion,&$aDatos){
                       $Sesion->set_var("Direcciones_entrega",$aDatos["Clientes.id_direccion"],"EXPIRE");
                       }
function chequear_Direcciones_entrega(&$Sesion,&$aDatos){
                      global $registro;
                      if($Sesion->get_var("Direcciones_entrega")==$aDatos["Direcciones_entrega.id_direccion"]) return selected;
                      }
function obtener_provincia(&$Sesion,&$aDatos){
                       $Sesion->set_var("Provincias",$aDatos["Clientes.id_provincia"],"EXPIRE");
                       }
function obtener_provincia2(&$Sesion,&$aDatos){
                       $Sesion->set_var("Provincias",$aDatos["Direcciones_entrega.id_provincia"],"EXPIRE");
                       }
function chequear_provincia(&$Sesion,&$aDatos){
                      global $registro;
                      if($Sesion->get_var("Provincias")==$aDatos["Provincias.id_provincia"]) return selected;
                      }
function dar_ofertas_promociones($Sess,$aDatos){
if((int)$aDatos["Clientes.ofertas_promociones"]) return "CHECKED";
}

function recomendador(&$Sesion,&$aDatos){
  if($aDatos["Clientes_empresas.id_recomendador"]){
    $consulta="select nombre, apellidos from Clientes where id_cliente=".$aDatos["Clientes_empresas.id_recomendador"];
          $rs=$Sesion->query($consulta);
          $row=$Sesion->fetch_row($rs);
          return $row[0]." ".$row[1];
  }
}



function nombre_login_real(&$Sesion,&$aDatos) {
$usuario = identifica_usuarios($Sesion);
$db_conf = $Sesion->get_db('conf');
if(is_object($db_conf)){
      $consulta = "select login from Users where id_usr =$usuario[id_usr]";
      $rs = $db_conf->query($consulta);
      $row = $db_conf->fetch_row($rs);
//      depurar_array($row);
      return $row[0];
      }

}


?>
