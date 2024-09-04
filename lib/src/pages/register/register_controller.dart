import 'dart:io';

import 'package:delivery/src/models/response_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'dart:convert';
import '../../models/user.dart';
import '../../providers/users_providers.dart';

class RegisterController extends GetxController{

 TextEditingController emailController = TextEditingController();
 TextEditingController passwordController = TextEditingController();
 TextEditingController nameController = TextEditingController();
 TextEditingController lastnameController = TextEditingController();
 TextEditingController confirmPassController = TextEditingController();
 TextEditingController phoneController = TextEditingController();

 UsersProviders usersProviders= UsersProviders();

 ImagePicker picker = ImagePicker();
 File? imageFile;

  void register(BuildContext context) async{
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String name = nameController.text.trim();
    String lastname= lastnameController.text;
    String confirmPass= confirmPassController.text.trim();
    String phone=phoneController.text.trim();

    if(isValidForm(email, password,confirmPass,name,lastname,phone)){

      ProgressDialog progressDialog= ProgressDialog(context:context);
      progressDialog.show(max:100,msg:'Registrando datos...');

      User user = User(
       email:email,
       name:name,
       lastname:lastname,
       phone:phone,
       password:password
      );

      Stream stream = await usersProviders.createWithImage(user, imageFile!);
      stream.listen((res){

      progressDialog.close();
      ResponseApi responseApi= ResponseApi.fromJson(json.decode(res));

      if(responseApi.success==true){
        GetStorage().write('user', responseApi.data);
        goToHomePage();
      }else{
        Get.snackbar('Error', responseApi.message??'');
      }
      });
    }
  }

 void goToHomePage(){
   Get.offNamedUntil('/client/products/list',(route)=>false);
 }

  bool isValidForm(String email, String password,confirmPass,name,lastname,phone){

    if(!GetUtils.isEmail(email)){
      Get.snackbar('Formulario no válido', 'El email no es válido');
      return false;
    }

    if(email.isEmpty){
      Get.snackbar('Formulario no válido', 'El campo email no puede estar vacio');
      return false;
    }

    if(name.isEmpty){
      Get.snackbar('Formulario no válido', 'El campo nombre no puede estar vacio');
      return false;
    }

    if(lastname.isEmpty){
      Get.snackbar('Formulario no válido', 'El campo apellidos no puede estar vacio');
      return false;
    }

    if(phone.isEmpty){
      Get.snackbar('Formulario no válido', 'El campo teléfono no puede estar vacio');
      return false;
    }

    if(password.isEmpty){
      Get.snackbar('Formulario no válido', 'El campo password no puede estar vacio');
      return false;
    }

    if(confirmPass.isEmpty){
      Get.snackbar('Formulario no válido', 'El password es incorrecto');
      return false;
    }

    if(password!=confirmPass){
      Get.snackbar('Formulario no válido', 'Las contraseñas no coinciden');
      return false;
    }

    if(imageFile==null){
      Get.snackbar('Formulario no válido', 'Debes seleccionar una imagen de perfil');
      return false;
    }


    return true;
  }

 Future selectImage (ImageSource imageSource) async{
   XFile? image = await picker.pickImage(source: imageSource);
   if(image!=null){
     imageFile = File(image.path);
     update();
   }
 }

 void showAlertDialog(BuildContext context){
   Widget galleryButton= ElevatedButton(
     onPressed: (){
       Get.back();
       selectImage(ImageSource.gallery);
     },
     child: Text(
       'Galeria',
       style: TextStyle(
           color:Colors.black,
           fontWeight: FontWeight.bold,
           fontSize: 17
       ),
     ),
     style: ElevatedButton.styleFrom(
         backgroundColor: Colors.amber
     ),
   );
   Widget camaraButton= ElevatedButton(
     onPressed: (){
       Get.back();
       selectImage(ImageSource.camera);

     },
     child: Text(
       'Cámara',
       style: TextStyle(
           color:Colors.black,
           fontWeight: FontWeight.bold,
           fontSize: 17
       ),
     ),
     style: ElevatedButton.styleFrom(
         backgroundColor: Colors.amber
     ),
   );

   AlertDialog alertDialog = AlertDialog(
     title: Text('Selecciona una ópcion'),
     actions: [
       galleryButton,
       camaraButton
     ],
   );

   showDialog(context: context, builder: (BuildContext context){
     return alertDialog;
   });
 }

}