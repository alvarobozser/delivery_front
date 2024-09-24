import 'package:delivery/src/models/address.dart';
import 'package:delivery/src/models/product.dart';
import 'package:delivery/src/models/response_api.dart';
import 'package:delivery/src/providers/address_provider.dart';
import 'package:delivery/src/providers/orders_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../models/order.dart';
import '../../../../models/user.dart';

class ClientListAddressController extends GetxController{
  
  List<Address> address= [];

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

  void createOrder()async{
    Address a = Address.fromJson(GetStorage().read('address')??{});
    List<Product> products=[];
    if(GetStorage().read('shopping_bag')is List<Product>){
     products =GetStorage().read('shopping_bag');
    }else{
     products =Product.fromJsonList(GetStorage().read('shopping_bag'));
    }

    Order order= Order(
      idClient:user.id,
      idAddress: a.id,
      products: products
    );
    ResponseApi responseApi= await ordersProvider.create(order);

    Fluttertoast.showToast(msg: responseApi.message??'',toastLength: Toast.LENGTH_LONG);

    if(responseApi.success==true){
      GetStorage().remove('shopping_bag');
      Get.toNamed('/client/payments/create');
    }

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