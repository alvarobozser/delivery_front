import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../../models/order.dart';
import '../../../../models/product.dart';
import '../../../../models/response_api.dart';
import '../../../../models/user.dart';
import '../../../../models/address.dart' as address;
import '../../../../providers/orders_provider.dart';

class ClientStripePaymentController extends GetConnect{

  Map<String,dynamic>? paymentIntentData;

  OrdersProvider ordersProvider=OrdersProvider();

  User user = User.fromJson(GetStorage().read('user')??{});

  Future <void> makePayment (BuildContext context)async{
    try{

      paymentIntentData= await createPaymentIntent('20','EUR');
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntentData!['client_secret'],
            /*applePay: PaymentSheetApplePay(
              merchantCountryCode: 'ES', // El código del país donde está registrado el comercio
            ),*/
            googlePay: PaymentSheetGooglePay(
              merchantCountryCode: 'ES',
              testEnv: true, // Puedes configurarlo a 'false' en producción
            ),
            style: ThemeMode.dark,
            merchantDisplayName: 'Mi Comercio',
          )
      ).then((value){

      });

      showPaymentSheet(context);

    }catch(err){
        print('Err${err}');
    }
  }

  showPaymentSheet(BuildContext context)async{
    try{
      await Stripe.instance.presentPaymentSheet().then((value) async{
        Get.snackbar('Pago Finalizado','Tu pago fue procesado correctamente');
        address.Address a = address.Address.fromJson(GetStorage().read('address')??{});
        List<Product> products=[];
        if(GetStorage().read('shopping_bag')is List<Product>){
          products =GetStorage().read('shopping_bag');
        }else{
          products =Product.fromJsonList(GetStorage().read('shopping_bag'));
        }

        Order order= Order(
            idClient:user.id,
            idAddress: a.id,
            products: products
        );
        ResponseApi responseApi= await ordersProvider.create(order);

        Fluttertoast.showToast(msg: responseApi.message??'',toastLength: Toast.LENGTH_LONG);
        paymentIntentData=null;
        if(responseApi.success==true) {
          GetStorage().remove('shopping_bag');
          Get.offNamedUntil('/client/home',(route)=>false);
        }

      }).onError((error,stackTrace){
        print('Error: $error - $stackTrace');
      });

    }on StripeException catch(err){
      print('Error ${err}');
      showDialog(context: context, builder: (value)=>AlertDialog(
              content: Text('Operación Cancelada'),
            ),
          );
    }
  }

  createPaymentIntent(String amount, String currency) async{

    try{
      Map<String,dynamic>? body={
        'amount':calculateAmount(amount),
        'currency':currency,
        'payment_method_types[]':'card'

      };

      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body:body,
          headers:{
            'Authorization':'Bearer sk_test_51Q586tJM7CBfXVFie4rueMjMAgde8xFkg0inCkCKmsWZOkhk8zPGMBCwniiAw9LwLbqTvKCTnB3EwzWNKKnSqWJK00ouIQXAoz',
            'Content-Type':'application/x-www-form-urlencoded'
      }
      );

      return jsonDecode(response.body);

    }catch(err){
      print('Error${err}');
    }
  }

  calculateAmount (String amount){
    final a = int.parse(amount)*100;
    return a.toString();
  }


}