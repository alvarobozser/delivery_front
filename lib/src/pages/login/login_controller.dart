import 'package:delivery/src/models/response_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../models/user.dart';
import '../../providers/users_providers.dart';


class LoginController extends GetxController{

 User user = User.fromJson(GetStorage().read('user') ?? {});

 TextEditingController emailController = TextEditingController();
 TextEditingController passwordController = TextEditingController();

 UsersProviders usersProviders=UsersProviders();

  void goToRegisterPage(){
    Get.toNamed('/register');
  }

  void login() async{
    String email = emailController.text.trim();

    String password = passwordController.text.trim();

    if(isValidForm(email, password)){
      ResponseApi responseApi = await usersProviders.login(email,password);

      print('Res : ${responseApi.toJson()}');

      if(responseApi.success==true){
        GetStorage().write('user', responseApi.data);

        User myUser = User.fromJson(GetStorage().read('user') ?? {});

        if(myUser.roles!.length > 1){
          goToRolPage();
        }else{
          goToClientHomePage();
        }
      }else{
        Get.snackbar('Login', responseApi.message??'');
      }
    }
  }

  void goToClientHomePage(){
    Get.offNamedUntil('/client/home',(route)=>false);
  }

 void goToRolPage(){
   Get.offNamedUntil('/roles',(route)=>false);
 }


 bool isValidForm(String email, String password){

    if(!GetUtils.isEmail(email)){
      Get.snackbar('Formulario no válido', 'El email no es válido');
      return false;
    }

    if(email.isEmpty){
      Get.snackbar('Formulario no válido', 'El campo email no puede estar vacioo');
      return false;
    }

    if(password.isEmpty){
      Get.snackbar('Formulario no válido', 'El campo password no puede estar vacio');
      return false;
    }

    return true;
  }

}