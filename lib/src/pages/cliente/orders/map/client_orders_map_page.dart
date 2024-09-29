import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'client_orders_map_controller.dart';

class ClientOrdersMapPage extends StatelessWidget{

  ClientOrdersMapController controller=Get.put(ClientOrdersMapController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ClientOrdersMapController>(
      builder: (builder)=>Scaffold(
      body: Stack(
        children: [
          Container(
              height: MediaQuery.of(context).size.height*0.68,
              child: _googleMaps()),
          SafeArea(
            child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buttonBack(),
                  _iconCenterMyLocation(),
                ],
              ),
              Spacer(),
              _cardOrderInfo(context),
            ],
          ),
        ),
          ],
        )
    ),
    );
  }

  Widget _buttonBack() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(left: 20,top: 20),
      child: IconButton(
        onPressed: () => Get.back(),
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
          size: 30,
        ),
      ),
    );
  }

  Widget _cardOrderInfo(BuildContext context){
    return Container(
      height: MediaQuery.of(context).size.height* 0.32,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20)
        ),
        boxShadow: [BoxShadow(
          color: Colors.grey.withOpacity(1.0),
          spreadRadius: 5,
          blurRadius: 7,
          offset: Offset(0,3)
        )
        ]
      ),
      child: Column(
        children: [
          _listTitleAddress(controller.order.address?.neighborhood ?? '',
          'Ciudad',
          Icons.my_location),
          _listTitleAddress(controller.order.address?.address ?? '',
              'Direccion',
              Icons.location_on
          ),
          Divider(color: Colors.grey,endIndent: 30,indent: 30,),
          _DeliveryInfo(),
        ],
      ),
    );
  }

  Widget _DeliveryInfo() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 35, vertical: 20),
      child: Row(
        children: [
          _imageClient(),
          SizedBox(width: 15),
          Text(
            '${controller.order.delivery?.name ?? ''} ${controller.order.delivery?.lastname ?? ''}',
            style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold
            ),
            maxLines: 1,
          ),
          Spacer(),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: Colors.grey[400]
            ),
            child: IconButton(
              onPressed: ()=>controller.callNumber(),
              icon: Icon(Icons.phone, color: Colors.black),
            ),
          )
        ],
      ),
    );
  }

  Widget _imageClient() {
    return Container(
      height: 50,
      width: 50,
      // padding: EdgeInsets.all(2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: FadeInImage(
          image: controller.order.delivery!.image != null
              ? NetworkImage(controller.order.delivery!.image!)
              : AssetImage('assets/img/no-image.png') as ImageProvider,
          fit: BoxFit.cover,
          fadeInDuration: Duration(milliseconds: 50),
          placeholder:  AssetImage('assets/img/no-image.png'),
        ),
      ),
    );
  }

  Widget _listTitleAddress(String title,String subtitle,IconData iconData){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title:Text(title,
          style: TextStyle(
            fontSize: 15,
            color: Colors.black
          ),
        ),
          subtitle: Text(
            subtitle,
              style: TextStyle(
              fontSize: 15,
              color: Colors.black
          ),
          ),
        trailing:Icon(iconData) ,
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
        markers: Set<Marker>.of(controller.markers.values),
        polylines: controller.polylines,
    );
  }



  Widget _iconCenterMyLocation() {
    return GestureDetector(
      onTap: () =>controller.centerPosition(),//=> controller.centerPosition(),
      child: Container(
        alignment: Alignment.centerRight,
        margin: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
        child: Card(
          shape: CircleBorder(),
          color: Colors.white,
          elevation: 4,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Icon(
              Icons.location_searching,
              color: Colors.grey[600],
              size: 20,
            ),
          ),
        ),
      ),
    );
  }


}