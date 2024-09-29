import 'package:delivery/src/models/response_api.dart';
import 'package:delivery/src/providers/orders_provider.dart';
import 'package:delivery/src/providers/users_providers.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../../models/order.dart';
import '../../../../models/user.dart';

class DeliveryOrdersDetailController extends GetxController {

  Order order= Order.fromJson(Get.arguments['order']);
  var total = 0.0.obs;
  var idDelivery=''.obs;

  UsersProviders provider = UsersProviders();
  OrdersProvider orderProvider = OrdersProvider();
  List<User> users = <User>[].obs;

  DeliveryOrdersDetailController(){
    print('order ${order.toJson()}');
    getTotal();
  }

  void updateOrden()async{
      ResponseApi responseApi = await orderProvider.updateToOnTheWay(order);
      Fluttertoast.showToast(msg: responseApi.message??'',toastLength: Toast.LENGTH_LONG);
      if(responseApi.success==true){
        goToOrderMap();
      }else{
        Get.snackbar('Error en la Petición', responseApi.message??'');
    }
  }

  void goToOrderMap(){
    Get.toNamed('/delivery/orders/map',
        arguments: {'order': order.toJson()});
  }

  void getTotal(){
    total.value= 0.0;
    order.products!.forEach((product){
      total.value= total.value+(product.quantity!*product.price!);
    });
    total.value = double.parse(total.value.toStringAsFixed(1));
  }

}
