import 'package:delivery/src/pages/restaurante/categorias/create/categorias_create_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoriasCreatePage extends StatelessWidget {


  CategoriasCreateController controller = Get.put(CategoriasCreateController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _backGroundCover(context),
          _boxForm(context),
          _textNewCategory(context),
        ],
      ),
    );
  }

  Widget _backGroundCover(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.35,
      color: Colors.amber,
    );
  }

  Widget _boxForm(BuildContext context) {
    return Container(
        margin: EdgeInsets.only( top: MediaQuery.of(context).size.height * 0.30,left: 50,right: 50),
        height: MediaQuery.of(context).size.height * 0.40,
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black54,
                  blurRadius: 15,
                  offset: Offset(0, 0.75))
            ]),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _textInfo(),
              _textName(),
              _textDescription(),
              _buttonCreate(context)
            ],
          ),
        ));
  }

  Widget _textInfo() {
    return Container(
        margin: EdgeInsets.only(top: 40, bottom: 20),
        child: Text(
          'Introduce los datos',
          style: TextStyle(
              color:
              Colors.black,
              fontWeight:
              FontWeight.bold,
              fontSize: 17),
        ));
  }

  Widget _buttonCreate(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: ElevatedButton(
          onPressed: () => controller.createCategoria(),
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 15),
              backgroundColor: Colors.amber),
          child: Text(
            'Crear Categoría',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
          )),
    );
  }


  Widget _textName() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      child: TextField(
        controller: controller.nameController,
        keyboardType: TextInputType.text,
        decoration:
            InputDecoration(hintText: 'Nombre', prefixIcon: Icon(Icons.category)),
      ),
    );
  }

  Widget _textDescription() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40,vertical: 20),
      child: TextField(
        controller: controller.descriptionController,
        keyboardType: TextInputType.text,
        maxLines: 3,
        decoration: InputDecoration(
            hintText: 'Descripción',
            prefixIcon: Container(
              margin:  EdgeInsets.only(bottom: 50),
              child: Icon(Icons.description),
            )),
      ),
    );
  }

  Widget _textNewCategory(BuildContext context) {
    return SafeArea(
      child: Container(
          margin: EdgeInsets.only(top: 60),
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              Icon(Icons.category,size: 120,),
              Text('Nueva Categoria',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25),),
            ],
          )),
    );
  }
}
