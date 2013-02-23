<?php
function pre_hacer_pedido(&$Sesion) {
global $pedido_cliente;//por si viene de algun sitio
//sobra pero por si akaso hay errores
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

global $identificador_pedido;//de donde viene
//debug($identificador_pedido);
if(isset($identificador_pedido))
   //lo metemos en la sesion y borramos lo ke hubiera
   $Sesion->set_var("identificador_pedido",$identificador_pedido);

$usuario = identifica_usuarios($Sesion);
$id_cliente = $usuario[id];
$Sesion->set_var("id_cliente",$id_cliente);
$control_imposiciones = $Sesion->get_var("control_imposiciones_cliente");

if(!isset($control_imposiciones)){
       $usuario = identifica_usuarios($Sesion);
       $consulta = "select Empresas.id_empresa ,Clientes_empresas.id_forma_pago , Clientes_empresas.id_divisa ,  pto_primero , pto_segundo , monto , campo_accion , retencion , aplicar_iva , aplicar_recargo , dto_directo , dto_pronto_pago , aplicar_retencion ,mostrar_ofertas
                    from Clientes_empresas , Tipo_cliente ,Empresas  , Tarifas where
                       id_cliente = $id_cliente and
                       Clientes_empresas.id_usr = $usuario[id_usr] and
                       Clientes_empresas.id_empresa = Empresas.id_empresa and
                       Clientes_empresas.id_tipo_cliente = Tipo_cliente.id_tipo_cliente and
                       Clientes_empresas.id_tarifa = Tarifas.id_tarifa";
       $resul5=$Sesion->query($consulta);
       $row5=$Sesion->fetch_array($resul5);
       //aplicar iva , aplikar recargo , desccuento por cliente , descuento pronto pago
       $Sesion->set_var("id_empresa",$row5[id_empresa]);
       $Sesion->set_var("control_imposiciones_cliente",$row5);
//     depurar_array($row5);
       }

global  $Anyadir;

global $array_numero;
global $array_bultos;
global $borrar_articulos;
if(isset($Anyadir)) {
//si estamos borrando eliminar
  if(is_array($borrar_articulos))
     foreach($borrar_articulos as $id_articulo)
              unset($array_numero[$id_articulo]);

//aki se meten los bultos cantidades ¿y paletas ?
        $pedido = $Sesion->get_var("pedido_cliente");
        if(!is_array($pedido)){
            if(is_array($array_numero)){
                $pedido1 = array_filter_it($array_numero,"valor_nulo");
                foreach($pedido1 as $key => $value1)
                        $pedido[$key][cantidad] =  $value1;
                }
            if(is_array($array_bultos)){
                $pedido2 = array_filter_it($array_bultos,"valor_nulo");
                foreach($pedido2 as $key2 => $value2)
                        $pedido[$key2][bultos] =  $value2;
                }
//                foreach($pedido as $key => $value)
//                        debug("$key , $value[cantidad], $value[bultos]");
        }
        else    {//ya habia uno anterior
//                depurar_array($pedido);
//                foreach($pedido as $key => $value)
//                        debug("antes $key , $value[cantidad], $value[bultos]");
            if(is_array($array_numero)){
                $pedido1 = array_filter_it($array_numero,"valor_nulo");
                foreach($pedido1 as $key => $value1)
                        if($pedido[$key][cantidad] >0)
                                $pedido[$key][cantidad] +=  $value1;
                        else    $pedido[$key][cantidad] =  $value1;
                }
            if(is_array($array_bultos)){
                $pedido2 = array_filter_it($array_bultos,"valor_nulo");
                foreach($pedido2 as $key2 => $value2)
                        if($pedido[$key2][bultos] >0)
                                $pedido[$key2][bultos] +=  $value2;
                        else    $pedido[$key2][bultos] =  $value2;
                //el + concatena y resguarda las keys , pero ke pasa si hay una repe
                }
            }
        $Sesion->set_var("pedido_cliente",$pedido);
//        foreach($pedido as $key => $value)
//                debug("despues $key , $value[cantidad], $value[bultos]");

//        depurar_array($pedido);
        }

}//fin del precode



function nodb_confirmar_pedido(&$Sesion){

global $confirmar_pedido;
//debug("paso");
//coger el array si no estaba
if(!isset($confirmar_pedido)){
        $confirmar_pedido = $Sesion->get_var("pedido_cliente");
//        debug("no habia");
        }
if(!is_array($confirmar_pedido)){
//      debug("vacio");
        return NULL;
        }
//coger id_articulo
else    {//depurar_array($confirmar_pedido);
//      debug("tengo array");
        $par = each($confirmar_pedido);
/*        debug($par[0]);
        debug($par[1][cantidad]);
        debug($par[1][bultos]);
*/
        if($par[0]){
                $consulta = "Select * from Articulos  where id_articulo = $par[0]";
                $resul = $Sesion->query($consulta);
                $row = $Sesion->fetch_array($resul);
                $row[cantidad] = $par[1][cantidad];
                $row[bultos] = $par[1][bultos];
                //descuento por cliente y articulo

//                depurar_array($row);
                unset($confirmar_pedido[$par[0]]);
                return $row;
                }
        }
}



function descripcion_descuento(&$Sesion,&$aDatos){

$id_art = $aDatos["Articulos.id_articulo"];
$usuario = identifica_usuarios($Sesion);
$control_imposiciones = $Sesion->get_var("control_imposiciones_cliente");
//DIVISA
//SI A ESTE CLIENTE SE LE APLIKAN LOS DESCUENTOS
//descuento por cliente y articulo
if($control_imposiciones[mostrar_ofertas] == 1){
            $consulta = "Select descuento , monto  from Cliente_articulos  where
                                id_articulo = $id_art and
                                id_empresa  = $control_imposiciones[id_empresa]  and
                                id_cliente =  $usuario[id]";
            $resul4 = $Sesion->query($consulta);
            $row4 = $Sesion->fetch_array($resul2);
            if($row4[descuento] > 0 )
                    return               $row4[descuento] .  "% Cliente/Articulo";
            elseif($row4[monto] > 0)
                    return $row4[monto] ." " .  $rowd[leyenda] .  " Cliente/Articulo";


            //descuento por familia de articulos y cliente
            $consulta = "Select descuento from Cliente_familia_articulos , Articulos
                         where Articulos.id_articulo = $id_art and Cliente_familia_articulos.id_empresa = $control_imposiciones[id_empresa]
                         and Cliente_familia_articulos.id_cliente = $usuario[id]
                         and Cliente_familia_articulos.id_familia = Articulos.id_familia";
            $resul2 = $Sesion->query($consulta);
            $row2 = $Sesion->fetch_array($resul2);
            if($row2[descuento] > 0){
                return $row2[descuento] . "% Cliente/Familia";
                }
            //FIN DE DEESCUENTOS ESPECIFICOS DE CLIENTE

            //Promociones u ofertas
            $consulta = "Select descuento , monto , oferta , nombre from Promociones where id_articulo = $id_art and id_empresa = $control_imposiciones[id_empresa]";
            $resul3 = $Sesion->query($consulta);
            $row3 = $Sesion->fetch_array($resul3);
            if($row3[oferta] == 1){
                     //ofertas
                    if($row3[descuento] > 0)
                            return  $row3[descuento] . "% Articulo";
                    elseif($row3[monto] > 0)
                            return  $row3[monto] . " " .  $rowd[leyenda] .  " Articulo";
                    }
            else    //Promociones
                    return  $row3[nombre];

            //descuento por familia
            $consulta = "Select descuento from Descuento_familia , Articulos , Familia_articulos
                        where Articulos.id_articulo = $id_art and
                        Descuento_familia.id_empresa = $control_imposiciones[id_empresa]  and
                        Descuento_familia.id_familia = Articulos.id_familia";
            $resul8 = $Sesion->query($consulta);
            $row8 = $Sesion->fetch_array($resul8);
            if($row8[descuento] > 0){
                return $row8[descuento] . "% Familia";
                }
            }
}

function precio_visible(&$Sesion,&$aDatos){
$id_art = $aDatos["Articulos.id_articulo"];
$control_imposiciones = $Sesion->get_var("control_imposiciones_cliente");
$consulta = "Select  $control_imposiciones[campo_accion]
                  + ($control_imposiciones[campo_accion] * $control_imposiciones[pto_primero]/100)
                  +(($control_imposiciones[campo_accion] + ($control_imposiciones[campo_accion] * $control_imposiciones[pto_primero]/100)) * $control_imposiciones[pto_segundo]/100)
                  +  $control_imposiciones[monto]
            from Empresas_articulos
            where Empresas_articulos.id_articulo = $id_art and
            Empresas_articulos.id_empresa = $control_imposiciones[id_empresa]";
$resul8 = $Sesion->query($consulta);
$row8 = $Sesion->fetch_array($resul8);
return   round($row8[0],3);
}

?>
