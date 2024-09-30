import 'package:delivery/src/pages/cliente/productos/list/cliente_productos_list_controller.dart';
import 'package:delivery/src/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../models/categories.dart';
import '../../../../models/product.dart';


class ClienteProductosListPage extends StatelessWidget {

  ClienteProductosListController controller= Get.put(ClienteProductosListController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => DefaultTabController(
        length: controller.categorias.length,
        child: Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(120),
              child: AppBar(
                flexibleSpace: Container(
                  margin: EdgeInsets.only(top:20),
                  alignment: Alignment.topCenter,
                  child: Wrap(
                    direction: Axis.horizontal,
                    children: [
                      _textFieldSearch(context),
                      _iconShoppingBag()
                    ],
                  ),
                ),
                backgroundColor: Colors.amber,
                bottom: TabBar(
                  isScrollable: true,
                  indicatorColor: Colors.black,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey[700],
                  tabs: List<Widget>.generate(controller.categorias.length,(index){
                    return  Tab(
                        child: Text(controller.categorias[index].name??''),
                      );
                  }),
                ),
              )),
          body: TabBarView(
              children:  controller.categorias.map((Categorias categorias){
                return FutureBuilder(
                    future: controller.getProducts(categorias.id??'1',controller.productName.value),
                    builder: (context,AsyncSnapshot<List<Product>> snapshot){
                        if(snapshot.hasData){

                          if(snapshot.data!.length>0){
                            return ListView.builder(
                                itemCount:snapshot.data?.length??0,
                                itemBuilder: (_,index) {
                                  return _cardProduct(context,snapshot.data![index]);
                                }
                            );
                          }else{
                            return NoDataWidget(text: 'No hay productos',);
                          }
                    }else{
                          return NoDataWidget(text: 'No hay productos',);
                     }
                  }
                );
          }).toList(),
          )
        ),
      )
    );
  }

  Widget _iconShoppingBag(){
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(left: 5),
        child: controller.items.value>0
            ?Stack(
          children: [
            IconButton(
                onPressed: ()=>controller.goToOrderCreate(),
                icon: Icon(
                  Icons.shopping_bag_outlined,
                  color: Colors.black,
                  size: 35,
                )
            ),
            Positioned(
                right: 5,
                top: 12,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                   '${controller.items.value}',
                  style: TextStyle(
                        fontSize: 12),
                  ),
                  width: 15,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(30))
                  ),
                ))
          ],
        ):IconButton(
            onPressed: ()=>controller.goToOrderCreate(),
            icon: Icon(
              Icons.shopping_bag_outlined,
              color: Colors.black,
              size: 30,
            )
        ),
      ),
    );
  }

  Widget _textFieldSearch(BuildContext context){
    return SafeArea(
      child:Container(
        width: MediaQuery.of(context).size.width * 0.75,
        child: TextField(
            onChanged: controller.onChangeText,
            decoration: InputDecoration(
              hintText: 'Buscar...',
              suffixIcon: Icon(Icons.search,color: Colors.grey),
              hintStyle: TextStyle(
                fontSize: 17,
                color: Colors.grey
              ),
              fillColor: Colors.white,
              filled: true,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                color: Colors.grey
                )
              ),
              focusedBorder:OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: Colors.grey
                )
              ),
              contentPadding: EdgeInsets.all(15)
            ),
          ),
      ),
    );
  }

  Widget _cardProduct(BuildContext context, Product product) {
    return GestureDetector(
      onTap: () => controller.openBottomSheet(context, product),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 15, left: 20, right: 20),
            child: ListTile(
              title: Text(product.name ?? ''),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text(
                    product.description ?? '',
                    maxLines: 2,
                    style: TextStyle(
                        fontSize: 13
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    '${product.price.toString()}€',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
              trailing: Container(
                height: 90,
                width: 70,
                // padding: EdgeInsets.all(2),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: FadeInImage(
                    image: product.image1 != null
                        ? NetworkImage(product.image1!)
                        : AssetImage('assets/img/no-image.png') as ImageProvider,
                    fit: BoxFit.cover,
                    fadeInDuration: Duration(milliseconds: 50),
                    placeholder:  AssetImage('assets/img/no-image.png'),
                  ),
                ),
              ),
            ),
          ),
          Divider(height: 1, color: Colors.grey[300], indent: 37, endIndent: 37,)
        ],
      ),
    );
  }

}
