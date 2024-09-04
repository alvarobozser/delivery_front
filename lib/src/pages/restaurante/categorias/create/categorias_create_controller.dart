
import 'package:delivery/src/models/categories.dart';
import 'package:delivery/src/models/response_api.dart';
import 'package:delivery/src/providers/categorias_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class CategoriasCreateController extends GetxController{

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  CategoriasProvider categoriasProvider=CategoriasProvider();

  void createCategoria()async{
    String name = nameController.text;
    String description=descriptionController.text;

    if(name.isNotEmpty && description.isNotEmpty){
      Categorias categorias = Categorias(
        name: name,
        description: description
      );

      ResponseApi responseApi=await categoriasProvider.create(categorias);

      Get.snackbar('Categoria Creada', responseApi.message??'');
      if(responseApi.success==true){
        clearForm();
      }
    }else{
      Get.snackbar('Formulario no válido', 'Faltan campos por completar');
    }
  }

  void clearForm(){
    nameController.text='';
    descriptionController.text='';
  }
}