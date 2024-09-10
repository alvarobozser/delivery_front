import 'dart:io';

import 'package:delivery/src/models/categories.dart';
import 'package:delivery/src/pages/restaurante/products/create/products_create_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductsCreatePage extends StatelessWidget {


  ProductsCreateController controller = Get.put(ProductsCreateController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(()=>Stack(
        children: [
          _backGroundCover(context),
          _boxForm(context),
          _textNewCategory(context),
        ],
      ),
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
        margin: EdgeInsets.only( top: MediaQuery.of(context).size.height * 0.20,left: 50,right: 50),
        height: MediaQuery.of(context).size.height * 0.65,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
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
              _textPrice(),
              _dropDownCategories(controller.categorias),
              Container(
                margin: EdgeInsets.only(top:15,bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GetBuilder<ProductsCreateController>(
                        builder: (value)=> _cardImage(context, controller.imageFile1, 1),),
                    SizedBox(width: 5),
                    GetBuilder<ProductsCreateController>(
                      builder: (value)=> _cardImage(context, controller.imageFile2, 2)),
                    SizedBox(width: 5),
                    GetBuilder<ProductsCreateController>(
                      builder: (value)=> _cardImage(context, controller.imageFile3, 3),)
                  ],
                ),
              ),

              _buttonCreate(context)
            ],
          ),
        ));
  }

  List<DropdownMenuItem<String?>> _dropDownItems(List<Categorias> categorias){
    List<DropdownMenuItem<String>> list = [];
    categorias.forEach((item){
      list.add(DropdownMenuItem(
          child: Text(item.name??''),
          value: item.id,
      )
      );
    });
    return list;
  }

  Widget _dropDownCategories(List<Categorias> categorias) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal:35 ),
        margin: EdgeInsets.only(top: 20),
        child: DropdownButton(
          underline: Container(
          alignment: Alignment.centerRight,
          child: Icon(Icons.arrow_drop_down_circle,
            color: Colors.amber,
          ),
        ),
          elevation: 3,
          isExpanded: true,
            hint: Text(
              'Selecciona la categoria',
              style: TextStyle(
                fontSize: 18
              ),
            ),
          items: _dropDownItems(categorias),
          value: controller.idCategory.value==''?null:controller.idCategory.value,
          onChanged: (option){
            controller.idCategory.value=option.toString();
          },
      ),
    );
  }

  Widget _cardImage(BuildContext context,File? imageFile,int number){
    return GestureDetector(
      onTap: ()=>controller.showAlertDialog(context,number),
      child:Card(
        elevation: 5,
        child: Container(
            padding: EdgeInsets.all(5),
            height: 80,
            width: MediaQuery.of(context).size.width * 0.18,
            child: imageFile!=null?
            Image.file(
              imageFile,
              fit: BoxFit.cover,
            ):Image(
              image: AssetImage('assets/img/cover_image.png'),
            ),
      ),
      ),
    );

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
          onPressed: () => controller.createProduct(context),
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 15),
              backgroundColor: Colors.amber),
          child: Text(
            'Crear Producto',
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

  Widget _textPrice() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      child: TextField(
        controller: controller.priceController,
        keyboardType: TextInputType.number,
        decoration:
        InputDecoration(hintText: 'Precio', prefixIcon: Icon(Icons.euro)),
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
              Icon(Icons.article,size: 40,),
              Text('Nuevo Producto',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25),),
            ],
          )),
    );
  }
}
