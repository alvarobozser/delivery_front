import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../models/user.dart';
import '../../../providers/push_notifications_provider.dart';

class DeliveryHomeController extends GetxController{

  var indexTab = 0.obs;

  PushNotificationsProvider pushNotificationsProvider= PushNotificationsProvider();

  User user= User.fromJson(GetStorage().read('user')??{});

  DeliveryHomeController(){
    saveToken();
  }

  void changeTab(int index){
   indexTab.value=index;
  }

  void saveToken(){
    if(user.id!=null){
      pushNotificationsProvider.saveToken(user.id!);
    }
  }

  void logOut(){
    GetStorage().remove('user');

    Get.offNamedUntil('/', (route)=>false);
  }


}