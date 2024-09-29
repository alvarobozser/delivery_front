import 'package:delivery/src/models/response_api.dart';
import 'package:delivery/src/providers/orders_provider.dart';
import 'package:delivery/src/providers/users_providers.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../../models/order.dart';
import '../../../../models/user.dart';

class ClientOrdersDetailController extends GetxController {

  Order order= Order.fromJson(Get.arguments['order']);
  var total = 0.0.obs;
  var idDelivery=''.obs;

  UsersProviders provider = UsersProviders();
  OrdersProvider orderProvider = OrdersProvider();
  List<User> users = <User>[].obs;

  ClientOrdersDetailController(){
    print('order ${order.toJson()}');
    getTotal();
  }

  void goToOrderMap(){
    Get.toNamed('/client/orders/map',
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
