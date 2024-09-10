import 'package:delivery/src/pages/cliente/profile/info/cliente_profile_info_controller.dart';
import 'package:flutter/material.dart';

import '../../../register/register_controller.dart';
import 'package:get/get.dart';

class ClienteProfileInfoPage extends StatelessWidget {


  RegisterController registerController = Get.put(RegisterController());
  ClienteProfileInfoController controller = Get.put(ClienteProfileInfoController());

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      body:Obx(()=>Stack(
        children: [
          _backGroundCover(context),
          _boxForm(context),
          _imageUser(context),
          Column(
            children: [
              _buttonBack(),
              _buttonRoles()
            ],
          ),
        ],
      ),
      ),
    );
  }

  Widget _backGroundCover(BuildContext context){
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.35,
      color: Colors.amber,
    );
  }

  Widget _boxForm(BuildContext context){
    return Container(
        margin: EdgeInsets.only(top:MediaQuery.of(context).size.height * 0.30,left:50,right: 50),
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color:Colors.black54,
                  blurRadius: 15,
                  offset: Offset(0,0.75)
              )
            ]
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _textName(),
              _textEmail(),
              _textPhone(),
              _buttonUpdate(context)
            ],
          ),
        )
    );
  }


  Widget _textName(){
    return Container(
        margin: EdgeInsets.only(top:20),
        child: ListTile(
          leading: Icon(Icons.person),
          title:Text('${controller.user.value.name??''} ${controller.user.value.lastname??''}',
          style: TextStyle(
              color: Colors.black
          ),
        ),
          subtitle:  Text('Email'),
        ),
    );
  }

  Widget _textEmail(){
    return ListTile(
          leading: Icon(Icons.email),
          title:Text(controller.user.value.email??'',
              style: TextStyle(
              color: Colors.black
          ),),
          subtitle:  Text('Email'),
    );
  }

  Widget _textPhone(){
    return ListTile(
          leading: Icon(Icons.phone),
          title:Text(controller.user.value.phone??'',
            style: TextStyle(
                color: Colors.black
            ),),
          subtitle:  Text('Teléfono'),
        );
  }

  Widget _buttonUpdate(BuildContext context){
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 40,vertical: 40),
      child: ElevatedButton(
          onPressed: ()=>controller.goToProfileUpdate(),
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 15),
              backgroundColor: Colors.amber
          ),
          child: Text(
            'Actualiza tus datos',
            style: TextStyle(
                color:Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 17
            ),
          )
      ),
    );
  }


  Widget _imageUser(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(top: 80),
        alignment: Alignment.topCenter,
        child: CircleAvatar(
          backgroundImage: controller.user.value.image!=null?
          NetworkImage(controller.user.value.image!):AssetImage('assets/img/user_profile.png') as ImageProvider,
          radius: 60,
          backgroundColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buttonRoles(){
    return Container(
      margin:EdgeInsets.only(right:20,top:20),
      alignment: Alignment.topRight,
      child:IconButton(
          onPressed:()=> controller.goToRoles(),
          icon: Icon(Icons.supervised_user_circle,
              color:Colors.white,
              size:30)
      ),
    );
  }

  Widget _buttonBack(){
    return SafeArea(
      child: Container(
        margin:EdgeInsets.only(right:20,top:20),
        alignment: Alignment.topRight,
        child:IconButton(
            onPressed:()=> controller.logOut(),
            icon: Icon(Icons.power_settings_new,
                color:Colors.white,
                size:30)
        ),
      ),
    );
  }

}
