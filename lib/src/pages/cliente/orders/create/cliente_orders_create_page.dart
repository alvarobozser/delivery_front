import 'package:delivery/src/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../models/product.dart';
import 'cliente_orders_create_controller.dart';

class ClienteOrdersCreatePage extends StatelessWidget {

  ClienteOrdersCreateController controller = Get.put(ClienteOrdersCreateController());


  @override
  Widget build(BuildContext context) {
    return Obx(()=>Scaffold(
      bottomNavigationBar: Container(
        color: Color.fromRGBO(245, 245, 245, 1),
        height: 100,
        child: _totalToPay(context),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.amber,
        title: Text(
            'Mi Cesta',
          style: TextStyle(
              color: Colors.black),),
      ),
      body: controller.selectedProducts.length>0
        ? ListView(
        children: controller.selectedProducts.map((Product product){
          return _cardProduct(product);
        }).toList(),
        )
          : Center(
          child:
          NoDataWidget(text: 'No hay ningun producto agregado aun')
      ),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Total: ${controller.total.value}€',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 17
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: ElevatedButton(
                    onPressed: () =>controller.goToAddressList(),
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(15),
                      backgroundColor: Colors.amber,
                    ),
                    child: Text(
                      'Confirmar Pedido',
                      style: TextStyle(
                          color: Colors.black
                      ),
                    )
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _cardProduct(Product product){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      child: Row(
        children: [
          _imageProduct(product),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(product.name??'',
              style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),

              SizedBox(height: 10,),
              _buttonsAddOrRemove(product),
            ],
          ),
          Spacer(),
          Column(
            children: [
             _textPrice(product),
            _iconDelete(product)
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconDelete(Product product) {
    return IconButton(
        onPressed: ()=>controller.deleteItem(product),
        icon: Icon(
          Icons.delete,
          color: Colors.red,
        )
    );
  }

  Widget _textPrice(Product product) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Text(
        '${(product.price! * product.quantity!).toStringAsFixed(1)}€', // Limita a un decimal
        style: TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }


  Widget _imageProduct(Product product) {
    return Container(
      height: 70,
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
    );
  }

  Widget _buttonsAddOrRemove(Product product) {
    return Container(
      margin: EdgeInsets.only(left: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => controller.removeItem(product),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  )
              ),

              child: Text('-'),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            color: Colors.grey[200],
            child: Text('${product.quantity ?? 0}'),
          ),
          GestureDetector(
            onTap: () =>controller.addItem(product),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  )
              ),
              child: Text('+'),
            ),
          ),
        ],
      ),
    );
  }
}
