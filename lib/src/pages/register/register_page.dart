
import 'package:delivery/src/pages/register/register_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterPage extends StatelessWidget {

  RegisterController controller = Get.put(RegisterController());

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      body:Stack(
        children: [
          _backGroundCover(context),
          _boxForm(context),
          _imageUser(context),
          _buttonBack(),
        ],
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
        height: MediaQuery.of(context).size.height * 0.65,
        decoration: BoxDecoration(
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
              _textInfo(),
              _textEmail(),
              _textName(),
              _textSurname(),
              _textPhone(),
              _textPassword(),
              _textConfirmPassword(),
              _buttonRegister(context)
            ],
          ),
        )
    );
  }

  Widget _textInfo(){
    return Container(
        margin: EdgeInsets.only(top:40,bottom: 20),
        child: Text('Introduce tus datos',
          style: TextStyle(
              color:Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 17
          ),
        )
    );
  }

  Widget _buttonRegister(BuildContext context){
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 40,vertical: 45),
      child: ElevatedButton(
          onPressed: ()=>controller.register(context),
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 15),
              backgroundColor: Colors.amber
          ),
          child: Text(
            'Registrarse',
            style: TextStyle(
                color:Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 17
            ),
          )
      ),
    );
  }

  Widget _textEmail(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      child: TextField(
        controller: controller.emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            hintText: 'Email',
            prefixIcon: Icon(Icons.email)
        ),
      ),
    );
  }

  Widget _textName(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      child: TextField(
        controller: controller.nameController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            hintText: 'Nombre',
            prefixIcon: Icon(Icons.person)
        ),
      ),
    );
  }

  Widget _textSurname(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      child: TextField(
        controller: controller.lastnameController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            hintText: 'Apellidos',
            prefixIcon: Icon(Icons.person_outline)
        ),
      ),
    );
  }

  Widget _textPhone(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      child: TextField(
        controller: controller.phoneController,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
            hintText: 'Teléfono',
            prefixIcon: Icon(Icons.phone)
        ),
      ),
    );
  }


  Widget _textPassword(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      child: TextField(
        controller: controller.passwordController,
        keyboardType: TextInputType.text,
        obscureText: true,
        decoration: InputDecoration(
            hintText: 'Password',
            prefixIcon: Icon(Icons.lock)
        ),
      ),
    );
  }

Widget _textConfirmPassword(){
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 40),
    child: TextField(
      controller: controller.confirmPassController,
      keyboardType: TextInputType.text,
      obscureText: true,
      decoration: InputDecoration(
          hintText: 'Confirmar Password',
          prefixIcon: Icon(Icons.lock_outline)
      ),
    ),
  );
  }

  Widget _imageUser(BuildContext context) {

    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(top: 50),
        alignment: Alignment.topCenter,
        child: GestureDetector(
            onTap: () => controller.showAlertDialog(context),
            child: GetBuilder<RegisterController> (
              builder: (value) => CircleAvatar(
                backgroundImage: controller.imageFile != null
                    ? FileImage(controller.imageFile!)
                    : AssetImage('assets/img/user_profile.png') as ImageProvider,
                radius: 60,
                backgroundColor: Colors.white,
              ),
            )
        ),
      ),
    );
  }

  Widget _buttonBack(){
    return SafeArea(
      child: Container(
        margin:EdgeInsets.only(left:20,top:20),
        child:IconButton(
          onPressed:()=> Get.back(),
          icon: Icon(Icons.arrow_back_ios,
          color:Colors.white,
          size:30)
        ),
      ),
    );
  }
}