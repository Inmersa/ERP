<?php
function pre_cli_pedidos(&$Sesion){
global $Confirmar;
if(isset($Confirmar)){
   global $registro;
    //aki insertmaos el pedido
   $usuario = identifica_usuarios($Sesion);
   $pedido_final_pda = $Sesion->get_var("pedido_final");
   $control_imposiciones = $Sesion->get_var("control_imposiciones_cliente");
   $detalle_iva = $Sesion->get_var("detalle_iva");
   $detalle_descuento_cliente = $Sesion->get_var("detalle_descuento_cliente");
   $detalle_descuento_cliente_2 = $Sesion->get_var("detalle_descuento_cliente_2");
   $total_sin_descuento = $Sesion->get_var("total_sin_descuento");


   $registro[id_empresa] = $control_imposiciones[id_empresa];
   $registro[fecha]=date("Y-m-d");
   $registro[id_cliente] = $usuario[id];

   //si n oviene de modificar
   $id_pedido = $Sesion->get_var("identificador_pedido");
   if(!isset($id_pedido)){
            //crear la referencia e incrementar el contador
        $consulta = "select prefijo_ped , sufijo_ped , contador_ped , digitos_ped from  Empresas where id_empresa = $control_imposiciones[id_empresa]";
        $resul2=$Sesion->query($consulta);
        $row2=$Sesion->fetch_array($resul2);

        //relleno de digitos para la numeracion del pedido
        $temporal = pow(10,( $row2[digitos_ped] + 1));
        $temporal += $row2[contador_ped];
        $t = substr((string)$temporal,1);

        $registro["referencia"] = $row2[prefijo_ped] . "-"  . $t  . "-" .$row2[sufijo_ped];
        $consulta = "update Empresas set contador_ped = contador_ped + 1 where id_empresa = $control_imposiciones[id_empresa]";
        $Sesion->query($consulta);

        if (!tb_replace("Pedidos",$registro))
                aviso("error al introducir en la base de datos");
        $consulta="select LAST_INSERT_ID()";
        $rs=$Sesion->query($consulta);
        $rorrrrrrrr=$Sesion->fetch_row($rs);
        $id_pedido = $rorrrrrrrr[0];

        }
//id _pedido o es de uno ke se modifica o l o akabamos de crear
        foreach($pedido_final_pda as $linea)
           if($linea[id_articulo] != 0 and $linea[cantidad] != 0){
                $registro2["id_pedido"]=$id_pedido;
                $registro2["id_articulo"]= $linea[id_articulo];
                $registro2["cantidad"]= $linea[cantidad];
                $registro2["precio_articulo"]=$linea[precio_tarifa_descuento ];
                $registro2["monto_total"] = $linea[base_imponible];
                $registro2["descuento"]= $linea[descuento];
                $registro2["monto"]= $linea[monto];

                if(isset($id_pedido)){
                          $consulta = "select id_detalle , cantidad from  Lineas_detalle where id_pedido = $id_pedido
                                       and id_articulo=$registro2[id_articulo]";
                          $res=$Sesion->query($consulta);
                          //es un pedido viejo  mirar a ver si ese articulo tenia linea de detalle cantidad
                          if($array_art=$Sesion->fetch_array($res)){
                                  $consulta = "update Empresas_articulos set stock_ficticio = stock_ficticio + $array_art[1] - $registro2[cantidad] where
                                               Empresas_articulos.id_articulo = $registro2[id_articulo] and
                                               Empresas_articulos.id_empresa = $control_imposiciones[id_empresa]";
                                  $Sesion->query($consulta);

                                  $consulta = "update Lineas_detalle set  id_presupuesto ='$registro2[id_presupuesto]' ,
                                                                             cantidad ='$registro2[cantidad]' ,
                                                                             precio_articulo ='$registro2[precio_articulo]' ,
                                                                             monto_total ='$registro2[monto_total]' ,
                                                                             descuento ='$registro2[descuento]' ,
                                                                             monto ='$registro2[monto]'
                                                 where id_articulo=$registro2[id_articulo] and
                                                       id_pedido = $id_pedido";
                                  $Sesion->query($consulta);
                                  }
                          //es una linea de dettalle para un pedido nuevo
                          else {$registro2["id_pedido"]=$id_pedido;
                          // decrementar la cantidad
                                  $consulta = "update Empresas_articulos set stock_ficticio = stock_ficticio - $registro2[cantidad] where
                                               Empresas_articulos.id_articulo = $registro2[id_articulo] and
                                               Empresas_articulos.id_empresa = $control_imposiciones[id_empresa]";
                                  $Sesion->query($consulta);
                                  tb_replace("Lineas_detalle",$registro2);
                                  }

                  }

                else {//no habia linea -> decrementar
                      $consulta = "update Empresas_articulos set stock_ficticio = stock_ficticio - $registro2[cantidad] where
                                               Empresas_articulos.id_articulo = $registro2[id_articulo] and
                                               Empresas_articulos.id_empresa = $usuario[id]";
                      $Sesion->query($consulta);
                      if (!tb_replace("Lineas_detalle",$registro2))
                        aviso("error al introducir en la base de datos");
                      }

//                 depurar_array($registro2);
//                 depurar_array($linea);
                 }

       $consulta = "delete from IVAs where id_pedido = $id_pedido";
       $Sesion->query($consulta);
       $consulta = "delete from Descuentos where id_pedido = $id_pedido";
       $Sesion->query($consulta);
       foreach($detalle_iva as $id_iva => $iva){
                $registro3["id_pedido"]=$id_pedido;
                $registro3["id_iva"]=$id_iva;
                $registro3["monto"]=$iva[monto];
                $registro3["recargo_iva"]=$iva[iva];
                $registro3["recargo_equivalente"]=$iva[recargo];

//                depurar_array($registro3);
                if (!tb_replace("IVAs",$registro3))
                        aviso("error al introducir en la base de datos");
                }

        //DESCUENTOS cliente directo
        if($detalle_descuento_cliente != 0 ){
                $registro4["id_pedido"]=$id_pedido;
                $registro4["monto_base"]  = $Sesion->get_var("total_sin_descuento");
                $registro4["porcentaje"]  = $control_imposiciones[dto_directo];
                $registro4["monto_final"] = $detalle_descuento_cliente;
                if (!tb_replace("Descuentos",$registro4))
                        aviso("error al introducir en la base de datos");
                }
        //DESCUENTOS cliente pronto pago
        if($detalle_descuento_cliente_2 != 0){
                $registro5["id_pedido"]= $id_pedido;
                $registro5["monto_base"]=$Sesion->get_var("total_sin_descuento");
                $registro5["porcentaje"]=$control_imposiciones[dto_pronto_pago];
                $registro5["monto_final"]=$detalle_descuento_cliente_2;
                if (!tb_replace("Descuentos",$registro5))
                        aviso("error al introducir en la base de datos");
                }

   }
//este lo dejo ke tiene de todo y aser posible molaria tenerlo al principio
//con esto lo ke hacemos es ke el cliente tenga el control de imposiciones en la sesion
// por lo ke si el empresario cambia algo no se veria afectado hasta ke reiniciara la aplicacion
//$Sesion->unset_var("control_imposiciones_cliente");
$Sesion->unset_var("pedido_cliente");
$Sesion->unset_var("pedido_final");
$Sesion->unset_var("dto_directo");
$Sesion->unset_var("dto_pronto_pago");
$Sesion->unset_var("detalle_descuento_cliente");
$Sesion->unset_var("detalle_descuento_cliente_2");
$Sesion->unset_var("detalle_iva");
$Sesion->unset_var("parcial_iva");
$Sesion->unset_var("parcial_recargo");
$Sesion->unset_var("total_descuentos");
$Sesion->unset_var("total_sin_descuento");
$Sesion->unset_var("total_iva");
$Sesion->unset_var("total");
$Sesion->unset_var("retencion");
$Sesion->unset_var("total_final");
$Sesion->unset_var("identificador_pedido");

}

function calcular_monto_pedido(&$Sesion,&$aDatos){
$id_pedido = $aDatos["Pedidos.id_pedido"];
//total base imponible
$consulta = "Select sum(monto)  from IVAs where IVAs.id_pedido =  $id_pedido";
$resuliva = $Sesion->query($consulta);
$row = $Sesion->fetch_array($resuliva);
$total = $row[0];

//recargo del iva
$consulta = "Select sum(recargo_iva)  from IVAs where IVAs.id_pedido =  $id_pedido";
$resuliv = $Sesion->query($consulta);
$row2 = $Sesion->fetch_array($resuliv);

$total += $row2[0];

//recargo equivalente
$consulta = "Select sum(recargo_equivalente)  from IVAs where IVAs.id_pedido =  $id_pedido";
$resulre = $Sesion->query($consulta);
$row3 = $Sesion->fetch_array($resulre);

$total += $row3[0];
$usuario = identifica_usuarios($Sesion);
//depurar_array($usuario);
//retencion
$consulta = "select aplicar_retencion , retencion  from  Clientes_empresas , Empresas
                     where  Clientes_empresas.id_cliente = $usuario[id] and
                           Clientes_empresas.id_usr  = $usuario[id_usr] and
                           Empresas.id_empresa = Clientes_empresas.id_empresa";
$resul = $Sesion->query($consulta);
$row = $Sesion->fetch_array($resul);
if($row[aplicar_retencion] == 1)
         $total+=  $row[0] * $row[retencion] / 100 ;
return $total;

}
function dar_preparado($Sess,$aDatos){
if((int)$aDatos["Pedidos.preparado"]) return "CHECKED";
}
function dar_estado($Sess,$aDatos){
if((int)$aDatos["Pedidos.preparado"]) return "Recibido";
else return "Pendiente";
}

function pre_cli_pedido(&$Sesion){
global $id_pedido;
if(isset($id_pedido))
   $Sesion->set_var("id_pedido",$id_pedido,"SUBSECCION");
}
function pre_imprimir($Sesion){
global $imprimir;
global $id_pedido;
if($imprimir==1){
        return "cli_pedido_cliente2.plt";
     }
}
function hay_albaran(&$Sesion,&$aDatos){
$consulta = "select * from  Albaranes where id_pedido =" . $aDatos["Pedidos.id_pedido"];
$resul = $Sesion->query($consulta);
if($row = $Sesion->fetch_array($resul))
    return 1;
}
function hay_factura(&$Sesion,&$aDatos){
if($aDatos["Pedidos.id_factura"] != 0)
   return 1;
}
function hay_factura_o_albaran(&$Sesion,&$aDatos){
if(isset($aDatos["Pedidos.id_pedido"]))
   $consulta = "select * from  Albaranes where id_pedido =" . $aDatos["Pedidos.id_pedido"];
elseif(isset($aDatos["Lineas_detalle.id_pedido"]))
   $consulta = "select * from  Albaranes where id_pedido =" . $aDatos["Lineas_detalle.id_pedido"];
$resul = $Sesion->query($consulta);
if($aDatos["Pedidos.id_factura"] != 0 OR $Sesion->fetch_array($resul))
   return 1;
}
function obtener_forma_pago(&$Sesion,&$aDatos){
$Sesion->set_var("Forma_pago",$aDatos["Pedidos.id_forma_pago"],"EXPIRE");
}
function chequear_forma_pago(&$Sesion,&$aDatos){
if($Sesion->get_var("Forma_pago")==$aDatos["Forma_pago.id_forma_pago"])
return selected;
}
function descripcion_descuento(&$Sesion,&$aDatos){
if($aDatos["Lineas_detalle.descuento"])
    return $aDatos["Lineas_detalle.descuento"] . " %";
if($aDatos["Lineas_detalle.monto"])
    return $aDatos["Lineas_detalle.monto"] . " &euro;";;
}
function nombre_articulo(&$Sesion,&$aDatos){
$id_articulo = $aDatos["Lineas_detalle.id_articulo"];
$consulta = "select Articulos.nombre  from Articulos where Articulos.id_articulo = $id_articulo";
$resul = $Sesion->query($consulta);
$row = $Sesion->fetch_array($resul);
return $row[0];
}
function porcentaje_iva2(&$Sesion,&$aDatos){
//depurar_array($aDatos);
$id_iv = $aDatos["IVAs.id_iva"];
$consulta = "Select porcentaje from   Tipos_IVA where Tipos_IVA.id_iva =  $id_iv";
$resul = $Sesion->query($consulta);
$row = $Sesion->fetch_array($resul);
return $row[0];
}
function calcular_base_imponible(&$Sesion,&$aDatos){
$id_pedido=$Sesion->get_var("id_pedido");
$consulta = "Select sum(monto)  from IVAs where IVAs.id_pedido =  $id_pedido";
$resul = $Sesion->query($consulta);
$row = $Sesion->fetch_array($resul);
return $row[0];
}
function calcular_total_ivas(&$Sesion,&$aDatos){
$id_pedido=$Sesion->get_var("id_pedido");
$consulta = "Select sum(recargo_iva)  from IVAs where IVAs.id_pedido =  $id_pedido";
$resul = $Sesion->query($consulta);
$row = $Sesion->fetch_array($resul);
return $row[0];
}
function calcular_total_retencion(&$Sesion,&$aDatos){
$id_pedido=$Sesion->get_var("id_pedido");
$consulta = "Select sum(monto)  from IVAs where IVAs.id_pedido =  $id_pedido";
$resul2 = $Sesion->query($consulta);
$total = $Sesion->fetch_array($resul2);
$usuario = identifica_usuarios($Sesion);
$control_imposiciones = $Sesion->get_var("control_imposiciones_cliente");
if($control_imposiciones[aplicar_retencion] == 1)
        return $total[0] * $control_imposiciones[retencion] / 100 ;
}

function calcular_total_recargo_equivalencia(&$Sesion,&$aDatos){
$id_pedido=$Sesion->get_var("id_pedido");
$consulta = "Select sum(recargo_equivalente)  from IVAs where IVAs.id_pedido =  $id_pedido";
$resul = $Sesion->query($consulta);
$row = $Sesion->fetch_array($resul);
return $row[0];
}
function calcular_total_descuentos(&$Sesion,&$aDatos){
$id_pedido=$Sesion->get_var("id_pedido");
$consulta = "Select sum(monto_final)  from Descuentos where Descuentos.id_pedido =  $id_pedido";
$resul = $Sesion->query($consulta);
$row = $Sesion->fetch_array($resul);
return $row[0];
}


function calcular_total_del_todo(&$Sesion,&$aDatos){
$id_pedido=$Sesion->get_var("id_pedido");

//total base imponible
$consulta = "Select sum(monto)  from IVAs where IVAs.id_pedido =  $id_pedido";
$resuliva = $Sesion->query($consulta);
$row = $Sesion->fetch_array($resuliva);
$total = $row[0];

//recargo del iva
$consulta = "Select sum(recargo_iva)  from IVAs where IVAs.id_pedido =  $id_pedido";
$resuliv = $Sesion->query($consulta);
$row2 = $Sesion->fetch_array($resuliv);

$total += $row2[0];

//recargo equivalente
$consulta = "Select sum(recargo_equivalente)  from IVAs where IVAs.id_pedido =  $id_pedido";
$resulre = $Sesion->query($consulta);
$row3 = $Sesion->fetch_array($resulre);

$total += $row3[0];

$usuario = identifica_usuarios($Sesion);
//retencion
$control_imposiciones = $Sesion->get_var("control_imposiciones_cliente");
if($control_imposiciones[aplicar_retencion] == 1){
         $total+=  $row[0] * $control_imposiciones[retencion] / 100 ;
         }
return $total;

}
function calcular_total_en_pesetas(&$Sesion,&$aDatos){
$id_pedido=$Sesion->get_var("id_pedido");

//total base imponible
$consulta = "Select sum(monto)  from IVAs where IVAs.id_pedido =  $id_pedido";
$resuliva = $Sesion->query($consulta);
$row = $Sesion->fetch_array($resuliva);
$total = $row[0];

//recargo del iva
$consulta = "Select sum(recargo_iva)  from IVAs where IVAs.id_pedido =  $id_pedido";
$resuliv = $Sesion->query($consulta);
$row2 = $Sesion->fetch_array($resuliv);

$total += $row2[0];

//recargo equivalente
$consulta = "Select sum(recargo_equivalente)  from IVAs where IVAs.id_pedido =  $id_pedido";
$resulre = $Sesion->query($consulta);
$row3 = $Sesion->fetch_array($resulre);

$total += $row3[0];

$usuario = identifica_usuarios($Sesion);
//retencion
$control_imposiciones = $Sesion->get_var("control_imposiciones_cliente");
if($control_imposiciones[aplicar_retencion] == 1){
         $total+=  $row[0] * $control_imposiciones[retencion] / 100 ;
         }
return round($total * 166.38,0);
}

?>
