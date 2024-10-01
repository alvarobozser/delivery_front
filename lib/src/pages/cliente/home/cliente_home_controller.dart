import 'package:delivery/src/providers/push_notifications_provider.dart';
import 'package:delivery/src/utils/custom_animated_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../models/user.dart';

class ClienteHomeController extends GetxController{

  PushNotificationsProvider pushNotificationsProvider= PushNotificationsProvider();

  User user= User.fromJson(GetStorage().read('user')??{});

  var indexTab = 0.obs;

  ClienteHomeController(){
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