import 'package:delivery/src/models/address.dart';
import 'package:delivery/src/models/product.dart';
import 'package:delivery/src/models/response_api.dart';
import 'package:delivery/src/providers/address_provider.dart';
import 'package:delivery/src/providers/orders_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../models/order.dart';
import '../../../../models/user.dart';
import '../../stripe/payments/client_stripe_payment.dart';

class ClientListAddressController extends GetxController{
  
  List<Address> address= [];

  ClientStripePaymentController stripePaymentController= ClientStripePaymentController();

  AddressProvider provider = AddressProvider();
  User user = User.fromJson(GetStorage().read('user')??{});
  OrdersProvider ordersProvider=OrdersProvider();
  var radioValue=0.obs;

  ClientListAddressController(){
    print('Direccion ${GetStorage().read('address')}');
  }

  Future<List<Address>> getAddress() async{
    address = await provider.findByUser(user.id??'');

    Address a = Address.fromJson(GetStorage().read('address')??{});
    int index = address.indexWhere((ad)=>ad.id==a.id);
    if(index!=-1){
      radioValue.value=index;
    }

    return address;
  }

  void createOrder(BuildContext context)async{
      stripePaymentController.makePayment(context);
      //Get.toNamed('/client/payments/create');
  }

  void goToAddressCreate(){
    Get.toNamed('/client/address/create');
  }

  void handleRadioValueChange(int? value) {
    radioValue.value = value!;
    GetStorage().write('address', address[value].toJson());
    update();
  }
}