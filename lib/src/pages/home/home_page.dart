import 'package:delivery/src/pages/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {

  HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        child: ElevatedButton(
            onPressed: ()=>controller.logOut(),
            child: Text('Cerrar Sesion',
            style: TextStyle(
              color: Colors.black
            ),
          ),
        ),
      )
    );
  }
}
