import 'package:bitad_staff/widgets/winners_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'attendance.dart';

class Winners extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme
        .of(context)
        .scaffoldBackgroundColor;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: backgroundColor,
          centerTitle: true,
          title: Text('Losowanie', textScaleFactor: 1.2,
            style: TextStyle(
                fontWeight: FontWeight.w500, color: Colors.grey[900]),),
          leading:
          IconButton(icon: Icon(Icons.arrow_back, color: Colors.grey[900],),
            onPressed: () {
              Navigator.pop(context);
            },)

      ),
      body: WinnersForm(),
    );
  }


}