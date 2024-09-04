import 'package:delivery/src/models/categories.dart';
import 'package:delivery/src/providers/categorias_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../../models/product.dart';
import '../../../../providers/products_provider.dart';
import '../detail/client_products_detail_page.dart';

class ClienteProductosListController extends GetxController{

  CategoriasProvider categoriasProvider= CategoriasProvider();
  ProductsProvider productsProvider = ProductsProvider();

  List<Categorias> categorias = <Categorias>[].obs;

  var items = 0.obs;

  var productName = ''.obs;

  ClienteProductosListController(){
    getCategorias();
  }

  void getCategorias()async{
    var result = await categoriasProvider.getAll();
    categorias.clear();
    categorias.addAll(result);
  }

  Future<List<Product>> getProducts(String idCategory) async {
      return await productsProvider.findByCategory(idCategory);
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