import 'package:delivery/src/models/response_api.dart';
import 'package:delivery/src/providers/orders_provider.dart';
import 'package:delivery/src/providers/users_providers.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../../models/order.dart';
import '../../../../models/user.dart';

class RestaurantOrdersDetailController extends GetxController {

  Order order= Order.fromJson(Get.arguments['order']);
  var total = 0.0.obs;
  var idDelivery=''.obs;

  UsersProviders provider = UsersProviders();
  OrdersProvider orderProvider = OrdersProvider();
  List<User> users = <User>[].obs;

  RestaurantOrdersDetailController(){
    print('order ${order.toJson()}');
    getDeliverymen();
    getTotal();
  }

  void updateOrden()async{
    if(idDelivery.value!=''){
      order.idDelivery = idDelivery.value;
      ResponseApi responseApi = await orderProvider.updateToDispatched(order);
      Fluttertoast.showToast(msg: responseApi.message??'',toastLength: Toast.LENGTH_LONG);
      if(responseApi.success==true){
        Get.offNamedUntil('/restaurant/home', (route)=>false);
      }else{
        Get.snackbar('Petición Denegada', 'Debes asignar el repartidor');
      }
    }
  }

  void getDeliverymen()async{
    var result = await provider.getDeliveryMen();
    users.clear();
    users.addAll(result);
  }

  void getTotal(){
    total.value= 0.0;
    order.products!.forEach((product){
      total.value= total.value+(product.quantity!*product.price!);
    });
    total.value = double.parse(total.value.toStringAsFixed(1));
  }

}
