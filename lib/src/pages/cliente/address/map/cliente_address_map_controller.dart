import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;

class ClienteAddressMapController extends GetxController{

  CameraPosition initialPosition = CameraPosition(
      target: LatLng(37.1814006,-5.7887763),
      zoom: 14);

  LatLng? addressLatlon;
  var addressName =''.obs;

  Completer<GoogleMapController> mapController = Completer();
  Position? position;

  ClienteAddressMapController(){
    //checkGPS();
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

  void checkGPS()async{
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
      animateCamaraPosition(position?.latitude ?? 37.1814006, position?.longitude ?? -5.7887763);
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
}