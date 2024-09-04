import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../models/user.dart';

class ClienteProfileInfoController extends GetxController{

  var user = User.fromJson(GetStorage().read('user')??{}).obs;


  void logOut(){
    GetStorage().remove('user');

    Get.offNamedUntil('/', (route)=>false);
  }

  void goToProfileUpdate(){
    Get.toNamed('client/profile/update');
  }

  void goToRoles(){
    Get.offNamedUntil('/roles',(route)=>false);
  }
}