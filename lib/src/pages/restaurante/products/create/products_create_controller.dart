
import 'dart:convert';
import 'dart:io';
import 'package:delivery/src/models/product.dart';
import 'package:delivery/src/providers/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:delivery/src/models/categories.dart';
import 'package:delivery/src/models/response_api.dart';
import 'package:delivery/src/providers/categorias_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class ProductsCreateController extends GetxController{

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  ImagePicker picker = ImagePicker();
  File? imageFile1;
  File? imageFile2;
  File? imageFile3;

  var idCategory = ''.obs;

  List<Categorias> categorias = <Categorias>[].obs;

  ProductsProvider productsProvider= ProductsProvider();

  ProductsCreateController(){
    getCategorias();
  }

  void getCategorias()async{
    var result= await categoriasProvider.getAll();
    categorias.clear();
    categorias.addAll(result);
  }

  CategoriasProvider categoriasProvider=CategoriasProvider();

  void createProduct(BuildContext context)async{
    String name = nameController.text;
    String description=descriptionController.text;
    String price = priceController.text;

    ProgressDialog progressDialog= ProgressDialog(context:context);


    if(isValidForm(name, description, price)) {
      Product product = Product(
          name: name,
          description: description,
          price: double.parse(price),
          idCategory: idCategory.value
      );

      progressDialog.show(max: 100, msg: 'Espera un momento...');

      List<File> images = [];
      images.add(imageFile1!);
      images.add(imageFile2!);
      images.add(imageFile3!);

      Stream stream = await productsProvider.create(product, images);
      stream.listen((res){
        progressDialog.close();

        ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));
        Get.snackbar('Proceso terminado', responseApi.message??'');
        if(responseApi.success==true){
          clearForm();
        }
      });
    }
  }

  bool isValidForm(String name,String description, String price){
    if(name.isEmpty){
      Get.snackbar('Formulario no válido', 'Falta el nombre por completar');
      return false;
    }
    if(description.isEmpty){
      Get.snackbar('Formulario no válido', 'Falta la descripcion por completar');
      return false;
    }
    if(price.isEmpty){
      Get.snackbar('Formulario no válido', 'Falta el precio por completar');
      return false;
    }
    if(idCategory.value==''){
      Get.snackbar('Formulario no válido', 'Selecciona la categoria del producto');
      return false;
    }

    if(imageFile1==null){
      Get.snackbar('Formulario no válido', 'Selecciona la imagen numero 1');
      return false;
    }

    if(imageFile2==null){
      Get.snackbar('Formulario no válido', 'Selecciona la imagen numero 2');
      return false;
    }
    
    if(imageFile3==null){
      Get.snackbar('Formulario no válido', 'Selecciona la imagen numero 3');
      return false;
    }


    return true;
  }

  void clearForm(){
    nameController.text='';
    descriptionController.text='';
    priceController.text='';
    imageFile1=null;
    imageFile2=null;
    imageFile3=null;
    idCategory.value='';
    update();
  }

  Future selectImage (ImageSource imageSource,int numberFile) async{
    XFile? image = await picker.pickImage(source: imageSource);
    if(image!=null){

      if(numberFile ==1){
        imageFile1 = File(image.path);
      }
      else if(numberFile ==2){
        imageFile2 = File(image.path);
      }
      else if(numberFile ==3){
        imageFile3 = File(image.path);
      }

      update();
    }
  }

  void showAlertDialog(BuildContext context,int numberFile){
    Widget galleryButton= ElevatedButton(
      onPressed: (){
        Get.back();
        selectImage(ImageSource.gallery,numberFile);
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
        selectImage(ImageSource.camera,numberFile);

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