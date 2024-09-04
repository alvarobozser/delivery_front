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
              preferredSize: Size.fromHeight(100),
              child: AppBar(
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
                    future: controller.getProducts(categorias.id??'1'),
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

  Widget _cardProduct(BuildContext context,Product product) {
    return  GestureDetector(
      onTap: ()=>controller.openBottomSheet(context,product),
      child: Column(
        children: [
          Container(
            //margin: EdgeInsets.only(top: 20,left: 20,right: 20),
            color:const Color.fromRGBO(245, 245, 245, 1.0),
            child: ListTile(
                      title: Text(product.name ?? '',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 15,),
                          Text(product.description ?? '',
                          maxLines: 2,
                            style: TextStyle(
                              fontSize: 13
                            ),
                          ),
                          SizedBox(height: 15,),
                          Text(
                            '${product.price.toString()}€',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          ),
                          SizedBox(height: 10,)
                        ],
                      ),
              trailing: Container(
                //height: 130,
                //width: 130,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: FadeInImage(
                    image: product.image1!=null ? NetworkImage(product.image1!) as ImageProvider
                      :AssetImage('assets/img/no-image.png'),
                    fit: BoxFit.contain,
                    fadeInDuration: Duration(milliseconds: 50),
                    placeholder: AssetImage('assets/img/no-image.png'),
                  ),
                ),
              ),
            ),
          ),
          Divider(height: 1,color: Colors.grey[500],indent: 37,endIndent: 37,)
        ],
      ),
    );
  }


}
