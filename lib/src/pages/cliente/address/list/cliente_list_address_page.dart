import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../models/address.dart';
import '../../../../widgets/no_data_widget.dart';
import 'cliente_list_address_controller.dart';

class ClienteListAddressPage extends StatelessWidget{

  ClientListAddressController  controller = Get.put(ClientListAddressController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.amber,
        title: Text('Mis Direcciones',
        style: TextStyle(
          color: Colors.black
        ),),
        actions: [
          _iconAddressCreate()
        ],
      ),
      body: GetBuilder<ClientListAddressController>(
        builder: (value)=> Stack(
          children: [
            _textSelectAddress(),
            _listAddress(context),
          ],
            ),
      ),
    );
  }


  Widget _radioSelectorAddress(Address address, int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              Radio(
                value: index,
                groupValue: controller.radioValue.value,
                onChanged: controller.handleRadioValueChange,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address.address ?? '',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                    ),
                  ),
                  Text(
                    address.neighborhood ?? '',
                    style: TextStyle(
                        fontSize: 15
                    ),
                  )
                ],
              )
            ],
          ),
          Divider(color: Colors.grey[400])
        ],
      ),
    );
  }

  Widget _listAddress(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 50),
      child: FutureBuilder(
          future: controller.getAddress(),
          builder: (context, AsyncSnapshot<List<Address>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isNotEmpty) {
                return ListView.builder(
                    itemCount: snapshot.data?.length ?? 0,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    itemBuilder: (_, index) {
                      return _radioSelectorAddress(snapshot.data![index], index);
                    }
                );
              }
              else {
                return Center(
                  child: NoDataWidget(text: 'No hay direcciones'),
                );
              }
            }
            else {
              return Center(
                child: NoDataWidget(text: 'No hay direcciones'),
              );
            }
          }
      ),
    );
  }

  Widget _iconAddressCreate(){
    return IconButton(
        onPressed:()=>controller.goToAddressCreate() ,
        icon: Icon(Icons.add,color: Colors.black),
    );
  }

  Widget _textSelectAddress() {
    return Container(
      margin: EdgeInsets.only(top: 30, left: 30),
      child: Text(
        'Elije donde recibirás tu pedido',
        style: TextStyle(
            color: Colors.black,
            fontSize: 19,
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }
  
}