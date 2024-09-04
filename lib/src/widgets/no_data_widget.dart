import 'package:flutter/material.dart';

class NoDataWidget extends StatelessWidget {

  String text = '';

  NoDataWidget({this.text = ''});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/img/cero-items.png',
            height: 120,
            width: 120,
          ),
          SizedBox(height: 15),
          Text(
            text,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
            ),
          )
        ],
      ),
    );
  }
}
