import 'package:delivery/main.dart';
import 'package:delivery/src/models/product.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';


class ClientProductsDetailController extends GetxController {


  List<Product> selectedProducts=[];

  ClientProductsDetailController(){
  }
  void checkProducts(Product product,var price,var counter){
    price.value=product.price??0.0;
    if(GetStorage().read('shopping_bag')!=null){
      if(GetStorage().read('shopping_bag') is List<Product>){
        selectedProducts =  GetStorage().read('shopping_bag');
      }else{
        selectedProducts =  Product.fromJsonList(GetStorage().read('shopping_bag'));
      }

      int index = selectedProducts.indexWhere((p)=>p.id==product.id);
      if(index!=-1){
        counter.value=selectedProducts[index].quantity??0;
        price.value=product.price!*counter.value;
      }
    }
  }

  void addTobBag(Product product,var price,var counter){
    if(counter.value>0){
      int index = selectedProducts.indexWhere((p)=>p.id==product.id);
      if(index==-1){
        if(product.quantity==null){
          if(counter.value>0){
            product.quantity = counter.value;
          }else {
            product.quantity = 1;
          }
        }
        selectedProducts.add(product);
      }else{
        selectedProducts[index].quantity=counter.value;
      }
      GetStorage().write('shopping_bag',selectedProducts);
      Fluttertoast.showToast(msg: 'Añadido a la cesta');
    }else{
      Fluttertoast.showToast(msg: 'Debes seleccionar al menos un producto');
    }

  }

  void addItem(Product product,var price,var counter){
    counter.value= counter.value+1;
    price.value=product.price! * counter.value;
  }

  void removeItem(Product product,var price,var counter){
    if(counter.value >0){
      counter.value= counter.value-1;
      price.value=product.price! * counter.value;
    }
  }


}