import 'package:delivery/src/models/order.dart';
import 'package:delivery/src/providers/orders_provider.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../models/user.dart';

class ClientOrdersListController extends GetxController{

  OrdersProvider ordersProvider= OrdersProvider();

  List<String> status=<String>['PAGADO','DESPACHADO','EN CAMINO','ENTREGADO'].obs;

  User user = User.fromJson(GetStorage().read('user')??{});

  Future<List<Order>> getOrders(String status)async{
    return await ordersProvider.findByClientAndStatus(user.id ?? '0',status);
  }


  void goToDetail(Order order){
    Get.toNamed('/client/orders/detail',
        arguments: {
      'order':order.toJson()}
    );
    }
}