import 'package:delivery/src/pages/restaurante/orders/detail/restaurant_orders_detail_controller.dart';
import 'package:delivery/src/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../models/product.dart';
import '../../../../models/user.dart';
import '../../../../utils/relative_time_util.dart';

class RestaurantOrdersDetailPage extends StatelessWidget {

  RestaurantOrdersDetailController controller= Get.put(RestaurantOrdersDetailController());

  @override
  Widget build(BuildContext context) {
    return Obx(()=>Scaffold(
        bottomNavigationBar: Container(
          color: Color.fromRGBO(245, 245, 245, 1),
          height: controller.order.status=='PAGADO'?
          MediaQuery.of(context).size.height*0.45
          :MediaQuery.of(context).size.height*0.40,
          child: Column(
            children: [
              _dataDate(),
              _dataClient(),
              _dataAddress(),
              _dataDelivery(),
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


  Widget _dataClient() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text('Cliente  -  Telefono'),
        subtitle: Text('${controller.order.client?.name ?? ''} ${controller.order.client?.lastname ?? ''} - ${controller.order.client?.phone ?? ''}'),
        trailing: Icon(Icons.person),
      ),
    );
  }

  Widget _dataDelivery() {
    return controller.order.status != 'PAGADO'
        ? Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text('Repartidor asignado'),
        subtitle: Text('${controller.order.delivery?.name ?? ''} ${controller.order.delivery?.lastname ?? ''} - ${controller.order.delivery?.phone ?? ''}'),
        trailing: Icon(Icons.delivery_dining),
      ),
    )
        : Container();
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
        controller.order.status=='PAGADO'? Container(
          width: double.infinity,
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(left: 30,top: 10),
          child: Text('Asignar repartidor',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.black
          ),),
        ):Container(),
        controller.order.status=='PAGADO'?_dropDownDeliveryMen(controller.users):Container(),
        Container(
          margin: EdgeInsets.only(left: 20, top: 25),
          child: Row(
            mainAxisAlignment: controller.order.status=='PAGADO'? MainAxisAlignment.center:MainAxisAlignment.start,
            children: [
              Text(
                'Total: ${controller.total.value}€',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 17
                ),
              ),
              controller.order.status=='PAGADO'?Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: ElevatedButton(
                    onPressed: ()=>controller.updateOrden(),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(15),
                      backgroundColor: Colors.amber,
                    ),
                    child: Text(
                      'Pasar a Despachado',
                      style: TextStyle(
                          color: Colors.black
                      ),
                    )
                ),
              ):Container()
            ],
          ),
        )
      ],
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

  List<DropdownMenuItem<String?>> _dropDownItems(List<User> users){
    List<DropdownMenuItem<String>> list = [];
    users.forEach((user){
      list.add(DropdownMenuItem(
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
              child: FadeInImage(
                  image: user.image!=null?
              NetworkImage(user.image!)
              :AssetImage('assets/image/no-image.png') as ImageProvider,
                fit: BoxFit.cover,
                fadeInDuration: Duration(milliseconds: 50),
                placeholder: AssetImage('assets/image/no-image.png'),
              ),
            ),
            ),
            SizedBox(width: 15,),
            Text(user.name??''),
          ],
        ),
        value: user.id,
      )
      );
    });
    return list;
  }

  Widget _dropDownDeliveryMen(List<User> users) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal:40),
      margin: EdgeInsets.only(top: 20),
      child: DropdownButton(
        underline: Container(
          alignment: Alignment.centerRight,
          child: Icon(Icons.arrow_drop_down_circle,
            color: Colors.amber,
          ),
        ),
        elevation: 3,
        isExpanded: true,
        hint: Text(
          'Selecciona repartidor',
          style: TextStyle(
              fontSize: 18
          ),
        ),
        items: _dropDownItems(users),
        value: controller.idDelivery.value==''?null:controller.idDelivery.value,
        onChanged: (option){
          controller.idDelivery.value=option.toString();
        },
      ),
    );
  }
}
