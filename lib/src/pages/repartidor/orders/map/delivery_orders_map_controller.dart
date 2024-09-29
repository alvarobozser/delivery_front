import 'dart:async';

import 'package:delivery/src/enviroment/enviroment.dart';
import 'package:delivery/src/models/response_api.dart';
import 'package:delivery/src/providers/orders_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:socket_io_client/socket_io_client.dart';
import '../../../../models/order.dart';


class DeliveryOrdersMapController extends GetxController{

  Socket socket=io('${Environment.API_URL}orders/delivery',<String,dynamic>{
    'transports':['websocket'],
    'autoConnect':false
  });

  Order order = Order.fromJson(Get.arguments['order'] ?? {});

  OrdersProvider ordersProvider= OrdersProvider();

  CameraPosition initialPosition = CameraPosition(
      target: LatLng(37.1814006,-5.7887763),
      zoom: 14);

  LatLng? addressLatlon;
  var addressName =''.obs;

  Completer<GoogleMapController> mapController = Completer();
  Position? position;

  Map<MarkerId,Marker> markers = <MarkerId,Marker>{}.obs;
  BitmapDescriptor? deliveryMarker;
  BitmapDescriptor? homeMarker;

  StreamSubscription? positionSuscribe;

  Set<Polyline> polylines = <Polyline>{}.obs;
  List<LatLng> points = [];

  double distanceBetween =0.0;
  bool isClose=false;

  DeliveryOrdersMapController(){
     print('Order: ${order.toJson()}');
     checkGPS();
     connectAndListen();
  }
  
  void updateToDelivered()async{
    if(distanceBetween<=200){
      ResponseApi responseApi=await ordersProvider.updateToDelivered(order);
      Fluttertoast.showToast(msg: responseApi.message??'',toastLength: Toast.LENGTH_LONG);
      if(responseApi.success==true){
        Get.offNamedUntil('/delivery/home', (route)=>false);
      }
    }else{
      Get.snackbar('Operación no permitada', 'Debes estar mas cerca de la posición de la posición de entrega');
    }
  }

  void isCloseToDeliveryPosition(){
    if(position!=null) {
      distanceBetween = Geolocator.distanceBetween(
          position!.latitude,
          position!.longitude,
          order.address!.lat!,
          order.address!.lng!);

      if(distanceBetween<=200 && isClose==false){
        isClose=true;
      }
    }
  }

  void connectAndListen(){
    socket.connect();
    socket.onConnect((data){
      print('Flutter conectado a SocketIO');
    });
  }

  void emitPosition(){
    if(position!=null){
      socket.emit('position', {
        'id_order': order.id,
        'lat': position!.latitude,
        'lng': position!.longitude
      });
    }
  }

  void onMapCreate(GoogleMapController controller){
    mapController.complete(controller);
  }

  Future setLocationDraggableInfo()async{
    double lat= initialPosition.target.latitude;
    double lng= initialPosition.target.longitude;

    List<Placemark> address = await placemarkFromCoordinates(lat, lng);
    if(address.isNotEmpty){
      String direccion = address[0].thoroughfare??'';
      String street = address[0].subThoroughfare??'';
      String ciudad = address[0].locality??'';
      String deparment = address[0].administrativeArea??'';
      addressName.value= '$direccion#$street,$ciudad,$deparment';
      addressLatlon = LatLng(lat, lng);
    }
  }

  Future<BitmapDescriptor> createMarkerFromAssets(String path) async {
    ImageConfiguration configuration = ImageConfiguration();
    BitmapDescriptor descriptor = await BitmapDescriptor.fromAssetImage(
        configuration, path
    );

    return descriptor;
  }

  void addMarker(
      String markerId,
      double lat,
      double lng,
      String title,
      String content,
      BitmapDescriptor iconMarker
      ){
    MarkerId id = MarkerId(markerId);
    Marker marker = Marker(markerId: id,icon: iconMarker,position: LatLng(lat, lng),
    infoWindow: InfoWindow(title: title,snippet: content));

    markers[id]=marker;
    update();
  }

  void checkGPS()async{
    deliveryMarker=await createMarkerFromAssets('assets/img/delivery_little.png');
    homeMarker=await createMarkerFromAssets('assets/img/home.png');


    bool isLocationEnabled= await Geolocator.isLocationServiceEnabled();
    if(isLocationEnabled==true){
      updateLocation();
    }else{
      bool isLocationGPS= await location.Location().requestService();
      if(isLocationGPS==true){
        updateLocation();
      }
    }
  }

  void selectRefPoint(BuildContext context){
    if(addressLatlon!=null){
      Map<String,dynamic> data = {
        'address': addressName.value,
        'lat': addressLatlon!.latitude,
        'lng': addressLatlon!.longitude,
      };
      Navigator.pop(context,data);
    }
  }

  void updateLocation()async{
    try {
      await _determinePosition();
      position = await Geolocator.getLastKnownPosition();
      saveLocation();
      animateCamaraPosition(position?.latitude ?? 37.1814006, position?.longitude ?? -5.7887763);

      addMarker('delivery',
          position?.latitude ?? 37.1814006,
          position?.longitude ?? -5.7887763,
          'Tu posición',
          '',
          deliveryMarker!);
      addMarker('home',
          order.address?.lat ?? 37.1814006,
          order.address?.lng ?? -5.7887763,
          'Lugar de entrega',
          '',
          homeMarker!);

      LatLng from=LatLng(position!.latitude,position!.longitude);
      LatLng to=LatLng(order.address?.lat ?? 37.1814006,order.address?.lng ?? -5.7887763);

      setPolylines(from, to);

      LocationSettings locationSettings=LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 1
      );

      positionSuscribe=Geolocator.getPositionStream(
          locationSettings: locationSettings
      ).listen((Position pos){
        position=pos;
        addMarker('delivery',
            position?.latitude ?? 37.1814006,
            position?.longitude ?? -5.7887763,
            'Tu posición',
            '',
            deliveryMarker!);

      animateCamaraPosition(position?.latitude ?? 37.1814006, position?.longitude ?? -5.7887763);
      emitPosition();
      isCloseToDeliveryPosition();
      });
    }catch(e){
      print('error: ${e}');
    }
  }

  Future animateCamaraPosition(double lat, double long)async{
    GoogleMapController controller = await mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
          target: LatLng(lat,long),
          zoom: 13,
          bearing: 0
      )
    ));
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  void saveLocation()async{
    if(position!=null){
      order.lat=position!.latitude;
      order.lng=position!.longitude;
    await ordersProvider.updateLatLng(order);
    }

  }
  //Ojo esta funcionalidad octiva el importe de Google
  Future<void> setPolylines(LatLng from, LatLng to) async {
    PointLatLng pointFrom = PointLatLng(from.latitude, from.longitude);
    PointLatLng pointTo = PointLatLng(to.latitude, to.longitude);
    PolylineResult result = await PolylinePoints().getRouteBetweenCoordinates(
      googleApiKey: Environment.API_KEY_MAPS,
      request: PolylineRequest(
        origin: pointFrom,
        destination: pointTo,
        mode: TravelMode.driving,
      ),
    );

    for (PointLatLng point in result.points) {
      points.add(LatLng(point.latitude, point.longitude));
    }

    Polyline polyline = Polyline(
        polylineId: PolylineId('poly'),
        color: Colors.amber,
        points: points,
        width: 5
    );

    polylines.add(polyline);
    update();
  }

  void centerPosition() {
    if (position != null) {
      animateCamaraPosition(position!.latitude, position!.longitude);
    }
  }

  void callNumber() async{
    String number = order.client?.phone ?? ''; //set the number here
    await FlutterPhoneDirectCaller.callNumber(number);
  }

  @override
  void onClose() {
    super.onClose();
    socket.disconnect();
    positionSuscribe?.cancel();

  }
}