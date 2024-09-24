import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'delivery_orders_map_controller.dart';

class DeliveryOrdersMapPage extends StatelessWidget{

  DeliveryOrdersMapController controller=Get.put(DeliveryOrdersMapController());

  @override
  Widget build(BuildContext context) {
    return Obx(()=>Scaffold(
      appBar: AppBar(
        title: Text('Ubica tu dirección',
        style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.amber,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Stack(
        children: [
          _googleMaps(),
          _iconMyLocation(),
          _cardAdress(),
          _buttonAccept(context)
          ],
        )
      ),
    );
  }


  @override
  Widget _googleMaps() {
    return GoogleMap(
        initialCameraPosition: controller.initialPosition,
        mapType: MapType.normal,
        onMapCreated: controller.onMapCreate,
        myLocationButtonEnabled: false,
        myLocationEnabled: false,
        onCameraMove:(position){
          controller.initialPosition=position;
        },
      onCameraIdle: ()async{
          await controller.setLocationDraggableInfo();
      }
    );
  }
  
  Widget _iconMyLocation(){
    return Center(
        child: Image.asset('assets/img/my_location_yellow.png',
          width: 65,
          height: 65,
        ),
    );
  }

  Widget _buttonAccept(BuildContext context){
    return Container(
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.only(bottom: 20),
      width: double.infinity,
      child: ElevatedButton(
          onPressed: ()=>controller.selectRefPoint(context),
          child: Text('Seleccionar este punto',
          style: TextStyle(color: Colors.black),),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber
        ),
      ),
    );
  }

  Widget _cardAdress(){
    return Container(
      alignment: Alignment.topCenter,
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 30),
      child: Card(
        color: Colors.grey[800],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: Text(controller.addressName.value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold
          ),),
          ),
      ),
    );
  }

}