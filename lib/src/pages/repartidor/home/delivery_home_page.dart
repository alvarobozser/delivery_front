import 'package:delivery/src/pages/cliente/profile/info/cliente_profile_info_page.dart';
import 'package:delivery/src/pages/repartidor/orders/list/delivery_orders_list_page.dart';
import 'package:delivery/src/pages/restaurante/categorias/create/categorias_create_page.dart';
import 'package:delivery/src/pages/restaurante/orders/list/restaurant_orders_list_page.dart';
import 'package:delivery/src/pages/restaurante/products/create/products_create_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/custom_animated_bottom_bar.dart';
import 'delivery_home_controller.dart';

class DeliveryHomePage extends StatelessWidget {

  DeliveryHomeController clienteProductosListController= Get.put(DeliveryHomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomBar(),
      body: Obx(()=>IndexedStack(
      index:clienteProductosListController.indexTab.value,
      children: [
        DeliveryOrdersListPage(),
        ClienteProfileInfoPage()
      ],
      )
      ),
    );
  }

  Widget _bottomBar() {
    return Obx(() => CustomAnimatedBottomBar(
      containerHeight: 70,
      backgroundColor: Colors.amber,
      showElevation: true,
      itemCornerRadius: 24,
      curve: Curves.easeIn,
      selectedIndex: clienteProductosListController.indexTab.value,
      onItemSelected: (index) => clienteProductosListController.changeTab(index),
      items: [
        BottomNavyBarItem(
            icon: Icon(Icons.list),
            title: Text('Pedidos'),
            activeColor: Colors.black,
            inactiveColor: Colors.black
        ),
        BottomNavyBarItem(
            icon: Icon(Icons.person),
            title: Text('Perfil'),
            activeColor: Colors.black,
            inactiveColor: Colors.black
        ),
      ],
    ));
  }
}
