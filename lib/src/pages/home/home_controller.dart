import 'package:delivery/src/models/user.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeController extends GetxController{

  User user = User.fromJson(GetStorage().read('user')??{});

  HomeController(){
    print('user ${user.toJson()}');
  }

  void logOut(){
    GetStorage().remove('user');

    Get.offNamedUntil('/', (route)=>false);
  }
}