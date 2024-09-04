import 'package:delivery/src/pages/restaurante/orders/list/restaurant_orders_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RestaurantOrderListPage extends StatelessWidget {

  RestaurantOrderListController restaurantOrderListController = Get.put(RestaurantOrderListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('RestaurantOrders'),
      ),
    );
  }
}
