import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../models/order.dart';
import '../../../../utils/relative_time_util.dart';
import '../../../../widgets/no_data_widget.dart';
import 'client_orders_list_controller.dart';

class ClientOrdersListPage extends StatelessWidget {

  ClientOrdersListController controller = Get.put(ClientOrdersListController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => DefaultTabController(
      length: controller.status.length,
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
                  tabs: List<Widget>.generate(controller.status.length,(index){
                    return  Tab(
                      child: Text(controller.status[index]),
                    );
                  }),
                ),
              )),
          body: TabBarView(
            children:  controller.status.map((String status){
              return FutureBuilder(
                  future: controller.getOrders(status),
                  builder: (context,AsyncSnapshot<List<Order>> snapshot){
                    if(snapshot.hasData){

                      if(snapshot.data!.length>0){
                        return ListView.builder(
                            itemCount:snapshot.data?.length??0,
                            itemBuilder: (_,index) {
                              return _cardOrder(snapshot.data![index]);
                            }
                        );
                      }else{
                        return Center(child: NoDataWidget(text: 'No hay ordenes',));
                      }
                    }else{
                      return Center(child: NoDataWidget(text: 'No hay ordenes',));
                    }
                  }
              );
            }).toList(),
          )
      ),
    )
    );
  }

  Widget _cardOrder(Order order) {
    return GestureDetector(
      onTap: () => controller.goToDetail(order),
      child: Container(
        height: 150,
        margin: EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Card(
          elevation: 3.0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)
          ),
          child: Stack(
            children: [
              Container(
                height: 30,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    )
                ),
                child: Container(
                  margin: EdgeInsets.only(top: 5),
                  child: Text(
                    'Ordén #${order.id}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15, left: 20, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 5),
                        alignment: Alignment.centerLeft,
                        child: Text('Pedido: ${ RelativeTimeUtil.getRelativeTime(order.timestamp ?? 0)}',
                        style: TextStyle(color: Colors.black,fontSize: 15),)
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 5),
                      alignment: Alignment.centerLeft,
                      child: Text('Repartidor: ${order.delivery?.name ?? 'No asignado'} ${order.delivery?.lastname ?? ''}',
                      style: TextStyle(color: Colors.black,fontSize: 15),),
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 5),
                      alignment: Alignment.centerLeft,
                      child: Text('Teléfono: ${order.client?.phone ?? ''}',
                        style: TextStyle(color: Colors.black,fontSize: 15),),
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 5),
                      alignment: Alignment.centerLeft,
                      child: Text('Dirección de Entrega: ${order.address?.address ?? ''}',
                        style: TextStyle(color: Colors.black,fontSize: 15),),
                    ),


                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
