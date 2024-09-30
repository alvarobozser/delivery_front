
import 'package:flutter/cupertino.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:get/get.dart';

class ClientPaymentsCreateController extends GetxController{

  var cardNumber = ''.obs;
  var expireDate = ''.obs;
  var cardHolderName = ''.obs;
  var cvvCode = ''.obs;
  var isCvvFocused=false.obs;
  GlobalKey<FormState> keyForm = GlobalKey();

  void onCreditCardModelChanged(CreditCardModel creditCardModel){
    cardNumber.value=creditCardModel.cardNumber;
    expireDate.value=creditCardModel.expiryDate;
    cardHolderName.value=creditCardModel.cardHolderName;
    cvvCode.value=creditCardModel.cvvCode;
    isCvvFocused.value=creditCardModel.isCvvFocused;

  }

  void createCardToken() async {
    if (isValidForm()) {
      Get.snackbar('Falta', 'Falta');
    }else{
      Get.snackbar('Otros', 'Otros');
    }
  }

  bool isValidForm () {
    if (cardNumber.value.isEmpty) {
      Get.snackbar('Formulario no valido', 'Ingresa el numero de la tarjeta');
      return false;
    }
    if (expireDate.value.isEmpty) {
      Get.snackbar('Formulario no valido', 'Ingresa la fecha de vencimiento de la tarjeta');
      return false;
    }
    if (cardHolderName.value.isEmpty) {
      Get.snackbar('Formulario no valido', 'Ingresa el nombre del titular');
      return false;
    }
    if (cvvCode.value.isEmpty) {
      Get.snackbar('Formulario no valido', 'Ingresa el codigo de seguridad');
      return false;
    }

    return true;
  }
}