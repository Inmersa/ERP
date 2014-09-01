<?

function pre_presupuestos_ventas(&$Sesion){
global $Confirmar;
global $Borrar;
if(isset($Borrar)){
        global $registro_borrar; //pedido en si
        if(isset($registro_borrar)){
                foreach($registro_borrar as $clave => $valor)
                        if($valor == 1 ){
                                $consulta="delete from Presupuestos where id_presupuesto = $clave";
                                $Sesion->query($consulta);
                                }
                }
   }
if(isset($Confirmar)){

        //del formulario
        global $registro; //pedido en si
        global $direccion_entrega;
        global $agente;
        global $forma_pago;
        global $divisa;

        $Sesion->set_var("pedido_cliente",""); //borramos el ke nos dice el articulo y la cantidad

        //variables arrastradas de sesion
        $array_lineas_detalle = $Sesion->get_var("array_lineas_detalle");
        $detalle_iva = $Sesion->get_var("detalle_iva");
        $detalle_descuento = $Sesion->get_var("detalle_descuento");
        $detalle_totales = $Sesion->get_var("detalle_totales");

        $es_pedido = $Sesion->get_var("es_pedido");
        $es_presupuesto = $Sesion->get_var("es_presupuesto");

        $id_cliente = $Sesion->get_var("id_cliente_pedido");
        $id_tarifa= $Sesion->get_var("id_tarifa_pedido");

        $id_pedido = $Sesion->get_var("identificador_pedido");
        $id_presupuesto = $Sesion->get_var("identificador_presupuesto");



        //el login
        $usuario = identifica_usuarios($Sesion);


        //depurar_array($detalle_iva);
        //depurar_array($detalle_descuento);
        //depurar_array($detalle_totales);
        //debug("pedido $es_pedido");
        //debug("presupuesto $es_presupuesto");
        //depurar_array($array_lineas_detalle);


        if(!isset($array_lineas_detalle) ){
                debug("Pedido Vacio");
                return;
                }


        $registro["fecha"]=date("Y-m-d");
//        $registro["id_direccion"] = $direccion_entrega;
        $registro["id_agente"] = $agente;
        $registro["id_empresa"] = $usuario[id];

        if($es_presupuesto  == 1){
        //debug("Presupuesto");
        //PRESUPUESTOS

        $registro["id_cliente"] = $id_cliente;


        //crear la referencia e incrementar el contador
        $consulta = "select prefijo_pre_ventas as 'prefijo_pre', ".
		  					"prefijo_pre_ventas as 'sufijo_pre', ".
							"prefijo_pre_ventas as 'contador_pre', ".
							"prefijo_pre_ventas as 'digitos_pre' from  Empresas where id_empresa = $usuario[id]";
        $resul22=$Sesion->query($consulta);
        $row22=$Sesion->fetch_array($resul22);

        //relleno de digitos para la numeracion del presupuesto
        $temporal = pow(10,( $row22[digitos_pre] + 1));
        $temporal += $row22[contador_pre];
        $t = substr((string)$temporal,1);

        $registro["referencia"] = $row22[prefijo_pre] . "-"  . $t  . "-" .$row22[sufijo_pre];
        $consulta = "update Empresas set contador_pre_ventas = contador_pre_ventas + 1 where id_empresa = $usuario[id]";
        $Sesion->query($consulta);
        //depurar_array($registro);
        if (!tb_replace("Presupuestos",$registro))
                aviso("error al introducir en la base de datos");
        $consulta="select LAST_INSERT_ID()";
        $rs3=$Sesion->query($consulta);
        $row33=$Sesion->fetch_row($rs3);
        }//FIN DE Presupuestos

        if(isset($id_presupuesto)){
                $row33[0] = $id_presupuesto;
                $consulta = "update Lineas_detalle set id_presupuesto=0 where id_presupuesto = $id_presupuesto";
                $Sesion->query($consulta);
                }

        foreach($array_lineas_detalle as $linea_detalle){
        //        depurar_array($linea_detalle);
                $registro2["id_presupuesto"]=$row33[0];

                $registro2["id_articulo"]= $linea_detalle[id_articulo];
                $registro2["cantidad"]= $linea_detalle[cantidad_total];
                $registro2["precio_articulo"]=$linea_detalle[precio_tarifa];
                $registro2["monto_total"] = $linea_detalle[base_imponible];
                $registro2["descuento"]= $linea_detalle[descuento];
                $registro2["monto"]= $linea_detalle[monto];

                if (!tb_replace("Lineas_detalle",$registro2))
                        aviso("error al introducir en la base de datos");

        }

        //depurar_array($detalle_iva);
        //depurar_array($detalle_descuento);
        //depurar_array($detalle_totales);
        //IVAS

        //depurar_array($Sesion->aData);

        $Sesion->unset_var("pedido_cliente"); //borramos las variables del pedido
        $Sesion->unset_var("id_cliente_pedido");
        $Sesion->unset_var("id_tarifa_pedido");
        $Sesion->unset_var("array_lineas_detalle");
        $Sesion->unset_var("aplicar_descuentos_cliente");
        $Sesion->unset_var("id_empresa");
        $Sesion->unset_var("campo_accion_pedido");
        $Sesion->unset_var("tarifazo");
        $Sesion->unset_var("divisazo");
        $Sesion->unset_var("ratio_divisa");
        $Sesion->unset_var("control_imposiciones");
        $Sesion->unset_var("array_lineas_detalle");
        $Sesion->unset_var("es_pedido");
        $Sesion->unset_var("es_presupuesto");
        $Sesion->unset_var("es_cliente");
        $Sesion->unset_var("detalle_iva");
        $Sesion->unset_var("total_impuestos");
        $Sesion->unset_var("total_bases_imponibles");
        $Sesion->unset_var("total_recargo_equivalente");
        $Sesion->unset_var("total_retenciones");
        $Sesion->unset_var("detalle_descuento");
        $Sesion->unset_var("total_descuentos");
        $Sesion->unset_var("detalle_totales");
        $Sesion->unset_var("identificador_presupuesto");
        $Sesion->unset_var("identificador_pedido");
        $consulta = "delete from  Lineas_detalle where id_presupuesto=0 and id_pedido=0 and id_albaran=0";
        $Sesion->query($consulta);
        }

}

function calcular_monto_presupuesto(&$Sesion,&$aDatos){
$id_presupuesto = $aDatos["Presupuestos.id_presupuesto"];
$consulta = "select sum(monto_total + (monto_total * porcentaje / 100)) from
Lineas_detalle , Articulos , Tipos_IVA
             where Lineas_detalle.id_presupuesto = $id_presupuesto and
             Lineas_detalle.id_articulo = Articulos.id_articulo and
             Articulos.id_iva = Tipos_IVA.id_iva";
$resul = $Sesion->query($consulta);
$row = $Sesion->fetch_array($resul);
return round($row[0],3);
}

?>
