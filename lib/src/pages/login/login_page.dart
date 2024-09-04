import 'package:delivery/src/pages/login/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class LoginPage extends StatelessWidget {

  LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 80,
        child: _textDontHaveAccount(),
      ),
      body:Stack(
        children: [
          _backGroundCover(context),
          _boxForm(context),
          Column(
            children: [
              _imageCover(),
              _textAppName()
            ],
          ),
        ],
      ),
    );
  }


  Widget _backGroundCover(BuildContext context){
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.42,
      color: Colors.amber,
    );
  }

  Widget _textAppName(){
    return Text(
      'Delivery',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black
      ),
    );
  }


  Widget _imageCover(){
    return SafeArea(
      child:Container(
      margin: EdgeInsets.only(top:30,bottom: 15),
      alignment: Alignment.topCenter,
      child: Image.asset(
        'assets/img/repartidor.png',
        width: 150,
        height: 150,
    ),
    ),
    );
  }

  Widget _textDontHaveAccount(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '¿No tienes cuenta?',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 17
          ),
        ),
        SizedBox(width: 7,),
        GestureDetector(
          onTap:()=>controller.goToRegisterPage(),
          child: Text(
            'Registrate aquí',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.amber,
                fontSize: 17
            ),
          
          ),
        )
      ],
    );
  }

  Widget _boxForm(BuildContext context){
    return Container(
      margin: EdgeInsets.only(top:MediaQuery.of(context).size.height * 0.33,left:50,right: 50),
      height: MediaQuery.of(context).size.height * 0.40,
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
          _textPassword(),
          _buttonLogin()
        ],
      ),
    )
    );
  }

  Widget _textInfo(){
    return Container(
        margin: EdgeInsets.only(top:40,bottom: 50),
        child: Text('Introduce tus datos',
          style: TextStyle(
              color:Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 17
          ),
        )
    );
  }

  Widget _buttonLogin(){
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 40,vertical: 45),
      child: ElevatedButton(
          onPressed: ()=>controller.login(),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 15),
            backgroundColor: Colors.amber
          ),
          child: Text(
            'Login',
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

}
