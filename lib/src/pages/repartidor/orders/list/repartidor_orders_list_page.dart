import 'package:delivery/src/pages/repartidor/orders/list/repartidor_order_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RepartidorOrdersListPage extends StatelessWidget {

  RepartidorOrderListController repartidorOrderListController = Get.put(RepartidorOrderListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('DeliveryOrder'),
      ),
    );
  }
}
