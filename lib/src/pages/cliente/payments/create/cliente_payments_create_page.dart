import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:get/get.dart';

import 'client_payments_create_controller.dart';

class ClientePaymentsCreatePage extends StatelessWidget {

  ClientPaymentsCreateController controller = Get.put(ClientPaymentsCreateController());

  @override
  Widget build(BuildContext context) {
    return Obx(()=>Scaffold(
      bottomNavigationBar: _buttonNext(context),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: CreditCardWidget(
              cardNumber: controller.cardNumber.value,
              expiryDate: controller.expireDate.value,
              cardHolderName: controller.cardHolderName.value,
              cvvCode: controller.cvvCode.value,
              showBackView: controller.isCvvFocused.value,
              cardBgColor: Colors.amber,
              obscureCardNumber: true,
              obscureCardCvv: true,
              height: 225,
              labelCardHolder: 'NOMBRE Y APELLIDO',
              textStyle: TextStyle(color: Colors.black),
              width: MediaQuery.of(context).size.width,
              animationDuration: Duration(milliseconds: 1000),
              onCreditCardWidgetChange: (CreditCardBrand ) {},
              glassmorphismConfig: Glassmorphism(
                blurX: 9.0,
                blurY:9.0,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Colors.grey.withAlpha(60),
                    Colors.black.withAlpha(55),
                  ],
                  stops: const <double>[
                    0.3,
                    0,
                  ],
                ),
              ),
            ),
          ),Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 60),
            child: CreditCardForm(
              formKey: controller.keyForm, // Required
              onCreditCardModelChange: controller.onCreditCardModelChanged, // Required
              //themeColor: Colors.red,
              obscureCvv: true,
              obscureNumber: true,
              inputConfiguration: const InputConfiguration(
              cardNumberDecoration: const InputDecoration(
                suffixIcon: Icon(Icons.credit_card),
                labelText: 'Numero de la tarjeta',
                hintText: 'XXXX XXXX XXXX XXXX',
              ),
              expiryDateDecoration: const InputDecoration(
                suffixIcon: Icon(Icons.date_range),
                labelText: 'Expira en',
                hintText: 'MM/YY',
              ),
              cvvCodeDecoration: const InputDecoration(
                suffixIcon: Icon(Icons.lock),
                labelText: 'CVV',
                hintText: 'XXX',
              ),
              cardHolderDecoration: const InputDecoration(
                suffixIcon: Icon(Icons.person),
                labelText: 'Titular de la tarjeta',
              ),
              ),
              cvvCode: '',
              expiryDate: '',
              cardHolderName: '',
              cardNumber: '',
            ),
          ),
        ],
      )
    )
    );
  }


  Widget _buttonNext(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 50),
      child: ElevatedButton(
          onPressed: () => controller.createCardToken(),
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 15),
              backgroundColor: Colors.amber
          ),
          child: Text(
            'CONTINUAR',
            style: TextStyle(
                color: Colors.black,
               fontWeight: FontWeight.bold,
            ),
          )
      ),
    );
  }
}
