import 'dart:convert';

import 'package:delivery/src/models/response_api.dart';
import 'package:delivery/src/pages/cliente/profile/info/cliente_profile_info_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'dart:io';
import '../../../../providers/users_providers.dart';
import '../../../../models/user.dart';

class ClienteProfileUpdateController extends GetxController {

  User user = User.fromJson(GetStorage().read('user')??{});

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  ImagePicker picker = ImagePicker();
  File? imageFile;

  UsersProviders usersProviders= UsersProviders();
  ClienteProfileInfoController clienteProfileInfoController=Get.find();

  ClienteProfileUpdateController(){
    nameController.text=user.name??'';
    lastnameController.text=user.lastname??'';
    phoneController.text=user.phone??'';
    emailController.text=user.email??'';
  }

  Future selectImage(ImageSource imageSource) async {
    XFile? image = await picker.pickImage(source: imageSource);
    if (image != null) {
      imageFile = File(image.path);
      update();
    }
  }

  void showAlertDialog(BuildContext context) {
    Widget galleryButton = ElevatedButton(
      onPressed: () {
        Get.back();
        selectImage(ImageSource.gallery);
      },
      child: Text(
        'Galeria',
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 17
        ),
      ),
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber
      ),
    );
    Widget camaraButton = ElevatedButton(
      onPressed: () {
        Get.back();
        selectImage(ImageSource.camera);
      },
      child: Text(
        'Cámara',
        style: TextStyle(
            color: Colors.black,
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

    showDialog(context: context, builder: (BuildContext context) {
      return alertDialog;
    });
  }

  void updateInfo(BuildContext context) async{
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String name = nameController.text.trim();
    String lastname= lastnameController.text;
    String confirmPass= confirmPassController.text.trim();
    String phone=phoneController.text.trim();

    if(isValidForm(email, password,confirmPass,name,lastname,phone)){

      ProgressDialog progressDialog= ProgressDialog(context:context);
      progressDialog.show(max:100,msg:'Actualizando datos...');

      User myUser = User(
          id:user.id,
          email:email,
          name:name,
          lastname:lastname,
          phone:phone,
          password: password!=null ? password : user.password,
          sessionToken: user.sessionToken
      );
      if(imageFile==null){
        ResponseApi responseApi = await usersProviders.update(myUser);
        Get.snackbar('Proceso terminado', responseApi.message ?? '');
        progressDialog.close();
        if(responseApi.success==true){
          GetStorage().write('user', responseApi.data);
          clienteProfileInfoController.user.value = User.fromJson(GetStorage().read('user'));
        }
      }
      else{

        Stream stream = await usersProviders.updateWithImage(myUser, imageFile!);
        stream.listen((res){
          progressDialog.close();
          ResponseApi responseApi= ResponseApi.fromJson(json.decode(res));
          print('Response Api Update: ${responseApi.data}');
          Get.snackbar('Proceso terminado', responseApi.message ?? '');
          if(responseApi.success==true){
            GetStorage().write('user', responseApi.data);
            clienteProfileInfoController.user.value = User.fromJson(GetStorage().read('user'));
          }else{
            Get.snackbar('Registro Fallido', responseApi.message??'');
          }
        });
      }
    }
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

    if(password!=null){
      if(password!=confirmPass){
        Get.snackbar('Formulario no válido', 'Las contraseñas no coinciden');
        return false;
      }
    }

    return true;
  }
}