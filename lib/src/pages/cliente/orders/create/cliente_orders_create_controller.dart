import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../models/product.dart';

class ClienteOrdersCreateController extends GetxController{

  List<Product> selectedProducts=<Product>[].obs;

  var counter = 0.obs;
  var total = 0.0.obs;

  ClienteOrdersCreateController(){
    if(GetStorage().read('shopping_bag')!=null){
      if(GetStorage().read('shopping_bag') is List<Product>){
        var result = GetStorage().read('shopping_bag');
        selectedProducts.clear();
        selectedProducts.addAll(result);
      }else{
        var result =  Product.fromJsonList(GetStorage().read('shopping_bag'));
        selectedProducts.clear();
        selectedProducts.addAll(result);
      }
    }
    getTotal();
  }


  void getTotal(){
    total.value= 0.0;
    selectedProducts.forEach((product){
      total.value= total.value+(product.quantity!*product.price!);
    });
    total.value = double.parse(total.value.toStringAsFixed(1));
  }


  void addItem(Product product){
    int index= selectedProducts.indexWhere((p)=> p.id == product.id);
    selectedProducts.remove(product);
    product.quantity = product.quantity!+1;
    selectedProducts.insert(index,product);
    GetStorage().write('shopping_bag', selectedProducts);
    getTotal();
  }

  void removeItem(Product product){
    if(product.quantity!>1){
      int index= selectedProducts.indexWhere((p)=> p.id == product.id);
      selectedProducts.remove(product);
      product.quantity = product.quantity!-1;
      selectedProducts.insert(index,product);
      GetStorage().write('shopping_bag', selectedProducts);
      getTotal();
    }
  }

  void deleteItem(Product product) {
    selectedProducts.remove(product);
    GetStorage().write('shopping_bag', selectedProducts);
    getTotal();
  }

  void goToAddressList(){
    Get.toNamed('/client/address/list');
  }
}