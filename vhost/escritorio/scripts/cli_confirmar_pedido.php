<?php

function pre_confirmar_pedido(&$Sesion){
global $articulos_confirmados;//array de checkboxes con los ke keremos konfirmar
$usuario = identifica_usuarios($Sesion);
$id_cliente = $usuario[id];
$control_imposiciones = $Sesion->get_var("control_imposiciones_cliente");

//depurar_array($articulos_confirmados);
global $pedido_cliente;
$confirmar_pedido = $Sesion->get_var("pedido_cliente");

if(is_array($articulos_confirmados))
        foreach($articulos_confirmados as $key => $value)
                if($value[poner] == 1){
//                       debug("confirmado $key");
                        $confirmados[$key] = $confirmar_pedido[$key];
                        }
                else { $id_pedido = $Sesion->get_var("identificador_pedido");
                       //si estamos modificando un pedido anterior y borran sumar al stock y borrar la linea de detalle

                       $consulta = "select id_detalle , cantidad from  Lineas_detalle where id_pedido = $id_pedido
                                       and id_articulo=$key";
                          $res=$Sesion->query($consulta);
                          //es un pedido viejo  mirar a ver si ese articulo tenia linea de detalle cantidad
                          if($array_art=$Sesion->fetch_array($res)){
//                       debug("sin confirmado $key");
//                       debug($id_pedido);
                       if(isset($id_pedido)){
                                  $consulta = "update Empresas_articulos set stock_ficticio = stock_ficticio + " . $confirmar_pedido[$key][cantidad] .  "  where
                                                       Empresas_articulos.id_articulo = $key and
                                                       Empresas_articulos.id_empresa = $control_imposiciones[id_empresa]";
                                  $Sesion->query($consulta);
                                  $consulta = "delete from Lineas_detalle where id_detalle = $array_art[id_detalle]";
                                  $Sesion->query($consulta);

                                  }

                          }
                     }
$Sesion->set_var("pedido_cliente",$confirmados);
}

function nodb_confirmar_pedido(&$Sesion){

global $confirmar_pedido_final;
//
$control_imposiciones = $Sesion->get_var("control_imposiciones_cliente");
$campo_accion = $control_imposiciones[campo_accion];
$usuario = identifica_usuarios($Sesion);
$id_cliente = $usuario[id];
if (empty($campo_accion))
      $campo_accion = "precio_venta";

if(!isset($confirmar_pedido_final)){
        $confirmar_pedido_final2 = $Sesion->get_var("pedido_cliente");
    //lo hago linea a linea pa poder meter la cantidad   :\
//    depurar_array($confirmar_pedido_final);
    if(is_array($confirmar_pedido_final2))
        foreach($confirmar_pedido_final2 as $id_articulo => $cantidad){
                $consulta = "Select Articulos.id_articulo , Articulos.nombre , Tipos_IVA.porcentaje , Tipos_IVA.id_iva , Tipos_IVA.recargo_equivalente , Empresas_articulos.$campo_accion , $cantidad[cantidad] as 'cantidad'
                             from Articulos ,  Empresas_articulos , Tipos_IVA
                             where Articulos.id_articulo = $id_articulo and
                                   Empresas_articulos.id_empresa = $control_imposiciones[id_empresa] and
                                   Articulos.id_articulo = Empresas_articulos.id_articulo and
                                   Tipos_IVA.id_iva = Articulos.id_iva ";
                $resul54 = $Sesion->query($consulta);
                if($row54 = $Sesion->fetch_array($resul54))
                $confirmar_pedido_final[$id_articulo] = $row54;
                }
//    debug("ndespues");
//    depurar_array($confirmar_pedido_final);
        }
if(!is_array($confirmar_pedido_final)){
//      debug("vacio");
        return;
        }
//coger id_articulo
else    {//depurar_array($confirmar_pedido_final);
//      debug("tengo array");
        $par = each($confirmar_pedido_final);
//        depurar_array($par);
        if($par[0]){
        //en par estan lso datos del articulo , control de imposiciones el resto
        //tarifa
        $fila = $par[1];
//        $fila[cantidad] = $par[1][cantidad];
        $fila[id_articulo] = $par[1][id_articulo];
//        $fila[nombre] = $par[1][nombre];


        $fila[precio_tarifa] =  $par[1][$campo_accion] + ( ($par[1][$campo_accion] * $control_imposiciones[pto_primero] ) / 100);
        $fila[precio_tarifa] =  $fila[precio_tarifa] + ( ($fila[precio_tarifa] * $control_imposiciones[pto_segundo] ) / 100);
        $fila[precio_tarifa] =  $fila[precio_tarifa] + $control_imposiciones[monto] ;
        //descuentos de familia , articulo , cliente
            if ($control_imposiciones[mostrar_ofertas] == 1){
                $consulta = "Select descuento , monto  from Cliente_articulos  where id_articulo = $fila[id_articulo]
                                    and id_empresa = $control_imposiciones[id_empresa]
                             and id_cliente = $id_cliente";
                $resul4 = $Sesion->query($consulta);
                $row4 = $Sesion->fetch_array($resul2);
                if($row4[descuento] > 0 ){
                        $fila[descuento] = $row4[descuento];
                        $fila[tipo_descuento] = $row4[descuento] .  " %";
                        $fila[precio_tarifa_descuento] =$fila[precio_tarifa] - ( ($fila[precio_tarifa] *  $fila[descuento] ) / 100);
                        }
                elseif($row4[monto] > 0){
                        $fila[monto] = $row4[monto];
                        $fila[tipo_descuento] = $row4[monto] . " " .  $leyenda_divisa . " ";
                        $fila[precio_tarifa_descuento] = $fila[precio_tarifa] - $fila[monto];
                        }
                $consulta = "Select descuento from Cliente_familia_articulos , Articulos
                        where Articulos.id_articulo = $fila[id_articulo]
                        and Cliente_familia_articulos.id_empresa = $control_imposiciones[id_empresa]
                        and Cliente_familia_articulos.id_cliente = $id_cliente
                        and Cliente_familia_articulos.id_familia = Articulos.id_familia";
                $resul2 = $Sesion->query($consulta);
                $row2 = $Sesion->fetch_array($resul2);
                if(!isset($fila[descuento]) AND !isset($fila[monto]) )
                        if($row2[descuento] > 0){
                                $fila[descuento] = $row2[descuento];
                                $fila[tipo_descuento] = $row2[descuento] . " %";
                                $fila[precio_tarifa_descuento] =$fila[precio_tarifa] - ( ($fila[precio_tarifa] *  $fila[descuento] ) / 100);
                                }
                 }//fin de descuentos especificos de cliente

//---------------------------------------------------------------------------------------------------------------------------------------------------

                $consulta = "Select descuento , monto , oferta , nombre  from Promociones where id_articulo = $fila[id_articulo] and id_empresa = $control_imposiciones[id_empresa]";
                $resul3 = $Sesion->query($consulta);
                $row3 = $Sesion->fetch_array($resul3);
                //ofertas
                if($row3[oferta] == 1)
                        if(!isset($fila[descuento]) AND !isset($fila[monto])){
                                if($row3[descuento] > 0){
                                        $fila[descuento] = $row3[descuento];
                                        $fila[tipo_descuento] = $row3[descuento] . " %";
                                        $fila[precio_tarifa_descuento] =$fila[precio_tarifa] - ( ($fila[precio_tarifa] *  $fila[descuento] ) / 100);
                                        }
                                elseif($row3[monto] > 0){
                                        $fila[monto] = $row3[monto];
                                        $fila[tipo_descuento] = $row3[monto] . " " . $leyenda_divisa . " " ;
                                        $fila[precio_tarifa_descuento] = $fila[precio_tarifa] - $fila[monto];
                                        }
                                }
                //Promociones
                else
                        if(!isset($fila[descuento]) AND !isset($fila[monto])){
                                        $fila[tipo_descuento] = $row3[nombre];
                                        $fila[precio_tarifa_descuento] = $fila[precio_tarifa];
                                        }

                //Descuento global por familia

                $consulta = "Select descuento from Descuento_familia , Articulos , Familia_articulos
                        where Articulos.id_articulo = $fila[id_articulo] and
                              Descuento_familia.id_empresa = $control_imposiciones[id_empresa]  and
                              Descuento_familia.id_familia = Articulos.id_familia";
                $resul8 = $Sesion->query($consulta);
                $row8 = $Sesion->fetch_array($resul8);
                if(!isset($fila[descuento]) AND !isset($fila[monto]) )
                        if($row8[descuento] > 0){
                                $fila[descuento] = $row8[descuento];
                                $fila[tipo_descuento] =  $row8[descuento] . " %";
                                $fila[precio_tarifa_descuento] =$fila[precio_tarifa] - ( ($fila[precio_tarifa] *  $fila[descuento] ) / 100);
                                }

                if(!isset($fila[precio_tarifa_descuento]))
                         $fila[precio_tarifa_descuento] =$fila[precio_tarifa] ;

                 $fila[base_imponible] = $fila[precio_tarifa_descuento];

//precio + tarifa - descuentos de articulos , familias por cliente o propios
//---------------------------------------------------------------------------------------------------------------------------------------------------




         //descuentos de  cliente especificos
         //mekaguen la cantidad
         $detalle_descuento_cliente = $Sesion->get_var("detalle_descuento_cliente");
         $detalle_descuento_cliente += ($fila[precio_tarifa_descuento] * $control_imposiciones[dto_directo] / 100) * $fila[cantidad];
         $Sesion->set_var("detalle_descuento_cliente",$detalle_descuento_cliente);
         $Sesion->set_var("dto_directo", $control_imposiciones[dto_directo]);

         $fila[base_imponible] =  $fila[base_imponible] - ($fila[base_imponible] * $control_imposiciones[dto_directo] / 100);

         //aki ira lo del pago
         $detalle_descuento_cliente_2 = $Sesion->get_var("detalle_descuento_cliente_2");
         $detalle_descuento_cliente_2 += ($fila[precio_tarifa_descuento] * $control_imposiciones[dto_pronto_pago] / 100) * $fila[cantidad];
         $Sesion->set_var("detalle_descuento_cliente_2", $detalle_descuento_cliente_2 );
         $Sesion->set_var("dto_pronto_pago", $control_imposiciones[dto_pronto_pago]);

         $fila[base_imponible] =  $fila[base_imponible] - ($fila[base_imponible] * $control_imposiciones[dto_pronto_pago] / 100);

//         debug($detalle_descuento_cliente);
//         debug($detalle_descuento_cliente_2);
//         debug($fila[base_imponible]);
//         debug($fila[precio_tarifa_descuento]);


        //iva y recargo
        $fila[precio_mas_iva] = $fila[base_imponible];
            if ($control_imposiciones[aplicar_iva] == 1 or $control_imposiciones[aplicar_recargo] == 1){
                 //monto para los ivas
                 $detalle_iva = $Sesion->get_var("detalle_iva");
                 $detalle_iva[$fila[id_iva]][monto]  += ($fila[base_imponible]  * $fila[cantidad]);
//                                debug($detalle_iva[$fila[id_iva]][monto]);
                 $Sesion->set_var("detalle_iva", $detalle_iva );
                 }
            if ($control_imposiciones[aplicar_iva] == 1){
                 $detalle_iva = $Sesion->get_var("detalle_iva");
                 $fila[precio_mas_iva] = $fila[base_imponible] + ($fila[base_imponible] * $fila[porcentaje] / 100);
                 $detalle_iva[$fila[id_iva]][iva]  += ($fila[base_imponible] * $fila[porcentaje] / 100) * $fila[cantidad];
                 $detalle_iva[$fila[id_iva]][porcentaje_iva]   =$fila[porcentaje];
                 $Sesion->set_var("detalle_iva", $detalle_iva );
                 }
            else
                 $fila[precio_mas_iva] = $fila[base_imponible];
            if ($control_imposiciones[aplicar_recargo] == 1){
                 $detalle_iva = $Sesion->get_var("detalle_iva");
                 $fila[precio_mas_iva] = $fila[precio_mas_iva] + ($fila[base_imponible] * $fila[recargo_equivalente] / 100);
                 $detalle_iva[$fila[id_iva]][recargo] += ($fila[base_imponible] * $fila[recargo_equivalente] / 100) * $fila[cantidad];
                 $detalle_iva[$fila[id_iva]][porcentaje_recargo] =$fila[recargo_equivalente];
                 $Sesion->set_var("detalle_iva", $detalle_iva );
                 }
            //por ultimo la cantidad
            $fila[base_imponible] = $fila[precio_tarifa_descuento] * $fila[cantidad];
            }//hay articulo
//        depurar_array($par[1]);
//        depurar_array($control_imposiciones);
//        depurar_array($fila);
        //totales
        $pedido_final = $Sesion->get_var("pedido_final");
        $pedido_final[] = $fila;
        $Sesion->set_var("pedido_final", $pedido_final );
        return $fila;
        }
}


function detalles_iva(&$Sesion){
global $iva_aldetalle;
if(!isset($iva_aldetalle)){
    $iva_aldetalle = $Sesion->get_var("detalle_iva");
    }
if(!is_array($iva_aldetalle)){
//      debug("vacio");
        return;
        }
//coger id_articulo
else    {//depurar_array($confirmar_pedido_final);
//      debug("tengo array");
        $par = each($iva_aldetalle);
        if(isset($par[1][monto]) OR isset($par[1][iva]) OR isset($par[1][recargo])){
                $arr[monto] = round($par[1][monto],2);
                $arr[iva] = round($par[1][iva],2);
                $arr[recargo] = round($par[1][recargo],2);
                return $arr;
                }
        else return NULL;
        }

}
function chequear_forma_pago(&$Sesion,&$aDatos){
$control_imposiciones = $Sesion->get_var("control_imposiciones_cliente");
if($control_imposiciones[id_forma_pago] == $aDatos["Forma_pago.id_forma_pago"])
    return selected;
}

function chequear_divisa(&$Sesion,&$aDatos){
$control_imposiciones = $Sesion->get_var("control_imposiciones_cliente");
if($control_imposiciones[id_divisa] ==$aDatos["Divisa.id_divisa"])
return selected;
}

function calcula_totales(&$Sesion){
$detalle_iva = $Sesion->get_var("detalle_iva");
$control_imposiciones = $Sesion->get_var("control_imposiciones_cliente");
//depurar_array($control_imposiciones);
//depurar_array($detalle_iva);
foreach ($detalle_iva as $ivas) {
          $iva += $ivas[iva];
          $iva += $ivas[recargo];
          $parcial_iva += $ivas[iva];
          $parcial_recargo += $ivas[recargo];
          $total += $ivas[monto];
          }
$Sesion->set_var("total", round($total,2));
$Sesion->set_var("total_iva",round($iva,2));
$Sesion->set_var("parcial_iva",round($parcial_iva,2));
$Sesion->set_var("parcial_recargo",round($parcial_recargo,2));
$detalle_descuento_cliente_total = $Sesion->get_var("detalle_descuento_cliente") + $Sesion->get_var("detalle_descuento_cliente_2");
$Sesion->set_var("total_descuentos",round($detalle_descuento_cliente_total,2));
$Sesion->set_var("total_sin_descuento",$total + $detalle_descuento_cliente_total);

$retencion = $Sesion->get_var("total");
if ($control_imposiciones[aplicar_retencion] == 1){
//     depurar_array($control_imposiciones);
     $retencion = $retencion * $control_imposiciones[retencion] /100;
     $Sesion->set_var("retencion",round( $retencion ,2));
     }
$total = $total + $iva + $retencion;
$Sesion->set_var("total_final",round($total,2));
return ;
}

?>
