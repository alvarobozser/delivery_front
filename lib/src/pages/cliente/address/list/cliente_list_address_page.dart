import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    );
  }

  Widget _iconAddressCreate(){
    return IconButton(
        onPressed:()=>controller.goToAddressCreate() ,
        icon: Icon(Icons.add,color: Colors.black),
    );
  }
  
}