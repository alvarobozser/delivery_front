import 'package:delivery/src/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../models/product.dart';
import '../../../../models/user.dart';
import '../../../../utils/relative_time_util.dart';
import 'client_orders_detail_controller.dart';

class ClientOrdersDetailPage extends StatelessWidget {

  ClientOrdersDetailController controller= Get.put(ClientOrdersDetailController());

  @override
  Widget build(BuildContext context) {
    return Obx(()=>Scaffold(
        bottomNavigationBar: Container(
          color: Color.fromRGBO(245, 245, 245, 1),
          height:controller.order.status=='EN CAMINO'?
          MediaQuery.of(context).size.height*0.36:
          MediaQuery.of(context).size.height*0.33,
          child: Column(
            children: [
              _dataDate(),
              _dataDelivery(),
              _dataAddress(),
              _totalToPay(context),
            ],
          ),
        ),
      appBar: AppBar(
        backgroundColor: Colors.amber,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('Orden #${controller.order.id}',style:
          TextStyle(color: Colors.black),),
      ),
      body: controller.order.products!.isNotEmpty
        ?Container(
        margin: EdgeInsets.only(bottom: 20),
        child: ListView(
          children: controller.order.products!.map((Product product){
          return _cardProduct(product);
        }).toList(),
        ),
      ):Center(
        child: NoDataWidget(text: 'No hay ningún producto agregado aún'),
      )
    )
    );
  }

  Widget _cardProduct(Product product) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 7),
      child: Row(
        children: [
          _imageProduct(product),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name ?? '',
                style: TextStyle(
                  color: Colors.black,
                    fontWeight: FontWeight.bold,
                  fontSize: 16
                ),
              ),
              SizedBox(height: 7),
              Text(
                'Cantidad: ${product.quantity}',
                style: TextStyle(
                  // fontWeight: FontWeight.bold
                    fontSize: 14
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _dataDelivery() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text('Repartidor  -  Telefono'),
        subtitle: Text('${controller.order.delivery?.name ?? 'No asignado'} ${controller.order.delivery?.lastname ?? ''} - ${controller.order.delivery?.phone ?? '####'}'),
        trailing: Icon(Icons.person),
      ),
    );
  }

  Widget _dataAddress() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text('Direccion de entrega'),
        subtitle: Text(controller.order.address?.address ?? ''),
        trailing: Icon(Icons.location_on),
      ),
    );
  }

  Widget _dataDate() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text('Fecha del pedido'),
        subtitle: Text('${RelativeTimeUtil.getRelativeTime(
            controller.order.timestamp ?? 0)}'),
        trailing: Icon(Icons.timer),
      ),
    );
  }

    Widget _totalToPay(BuildContext context) {
    return Column(
      children: [
        Divider(height: 1, color: Colors.grey[300]),
        Container(
          margin: EdgeInsets.only(left: 20, top: 25),
          child: Row(
            mainAxisAlignment:controller.order.status=='EN CAMINO'?
            MainAxisAlignment.center:
            MainAxisAlignment.start,
            children: [
              Text(
                'Total: ${controller.total.value}€',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 17
                ),
              ),controller.order.status=='EN CAMINO'?
              _goToOrderMap():Container()
            ],
          ),
        )
      ],
    );
  }



  Widget _goToOrderMap(){
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 30),
        child: ElevatedButton(
            onPressed: ()=>controller.goToOrderMap(),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(15),
              backgroundColor: Colors.cyan[300],
            ),
            child: Text(
              'Ver ubicación del pedido',
              style: TextStyle(
                  color: Colors.white
              ),
            )
        )
    );
  }

  Widget _imageProduct(Product product) {
    return Container(
      height: 80,
      width: 80,
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
    );
  }

}
