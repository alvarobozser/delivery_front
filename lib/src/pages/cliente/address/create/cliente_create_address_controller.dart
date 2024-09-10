import 'package:delivery/src/pages/cliente/address/map/cliente_address_map_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ClienteCreateAddressController extends GetxController{

  TextEditingController addressController = TextEditingController();
  TextEditingController neighborhoodController = TextEditingController();
  TextEditingController refPointController = TextEditingController();

  void openGoogleMap(BuildContext context){
    showMaterialModalBottomSheet(
        context: context,
        builder: (context)=>ClienteAddressMapPage(),
        isDismissible: false,
        enableDrag: false,
    );

  }
}