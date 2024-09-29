import 'package:delivery/src/pages/roles/roles_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:delivery/src/models/rol.dart';

class RolesPage extends StatelessWidget {

  RolesController rolesController= Get.put(RolesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('Selecciona un rol',
        style: TextStyle
          (color: Colors.black,
        ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*0.17),
        child: ListView(
          children:  rolesController.user.roles!=null ?rolesController.user.roles!.map((Rol rol){
            return _cardRol(rol);
          }).toList():[],
        ),
      ),
    );
  }

  @override
  Widget _cardRol(Rol rol) {
    return GestureDetector(
      onTap: ()=>rolesController.goToPageRol(rol),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10),
            height: 90,
            width: 90,
            /*decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.amber, width: 2),
            ),*/
            //child: ClipOval(
              child: FadeInImage(
                image: NetworkImage(rol.image!),
                fit: BoxFit.cover,
                fadeInDuration: Duration(milliseconds: 50),
                placeholder: AssetImage('assets/img/no-image.png'),
             // ),
            ),
          ),
          Text(
            rol.name ?? '',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 35), // Aquí agregamos un margen inferior al objeto
        ],
      ),
    );
  }

}
