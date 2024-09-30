import 'dart:async';

import 'package:delivery/src/models/categories.dart';
import 'package:delivery/src/providers/categorias_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../../models/product.dart';
import '../../../../providers/products_provider.dart';
import '../detail/client_products_detail_page.dart';

class ClienteProductosListController extends GetxController{

  CategoriasProvider categoriasProvider= CategoriasProvider();
  ProductsProvider productsProvider = ProductsProvider();

  List<Categorias> categorias = <Categorias>[].obs;
  List<Product> selectedProducts=[];


  var items = 0.obs;
  var productName = ''.obs;

  Timer? searchOnStoppedTyping;

  ClienteProductosListController(){
    getCategorias();
    if(GetStorage().read('shopping_bag')!=null){
      if(GetStorage().read('shopping_bag') is List<Product>){
        selectedProducts =  GetStorage().read('shopping_bag');
      }else{
        selectedProducts =  Product.fromJsonList(GetStorage().read('shopping_bag'));
      }

      selectedProducts.forEach((p){
        items.value=items.value + (p.quantity!);
      });

    }
  }

  void onChangeText(String text){
    const duration = Duration(milliseconds: 800);
    if(searchOnStoppedTyping!=null){
      searchOnStoppedTyping?.cancel();
    }
    searchOnStoppedTyping=Timer(duration, (){
      productName.value=text;
    });
  }

  void getCategorias()async{
    var result = await categoriasProvider.getAll();
    categorias.clear();
    categorias.addAll(result);
  }

  Future<List<Product>> getProducts(String idCategory,String name) async {
    if(name.isEmpty){
      return await productsProvider.findByCategory(idCategory);
    }else{
      return await productsProvider.findByNameAndCategory(idCategory,name);
    }

  }

  void goToOrderCreate(){
    Get.toNamed('/client/orders/create');
  }

  void openBottomSheet(BuildContext context, Product product) async{
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => ClientProductsDetailPage(product: product),
    );
  }


}