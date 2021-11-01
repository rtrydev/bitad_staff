import 'package:bitad_staff/api/retrofit_api.dart';
import 'package:bitad_staff/api/retrofit_client.dart';
import 'package:bitad_staff/models/user.dart';
import 'package:bitad_staff/screens/contacts.dart';
import 'package:bitad_staff/screens/super.dart';
import 'package:bitad_staff/screens/winners.dart';
import 'package:bitad_staff/screens/workshops.dart';
import 'package:bitad_staff/widgets/qr_view.dart';
import 'package:bitad_staff/widgets/qr_view_workshop.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WorkshopAttendance extends StatelessWidget {

  String title;
  String workshopCode;

  WorkshopAttendance({Key? key, required this.title, required this.workshopCode}) : super(key: key);
  @override
  Widget build(BuildContext context){

    final color = Theme.of(context).primaryColor;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final qrCamera = QRViewWorkshop(title: title, code: workshopCode,);

    return Scaffold(
        appBar: AppBar(
            backgroundColor: backgroundColor,
            centerTitle: true,
            title: Text(
              title,
              textScaleFactor: 1.2,
              style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[900]),
            ),

            leading:
            IconButton(icon: Icon(Icons.arrow_back, color: Colors.grey[900],), onPressed: (){
              Navigator.pop(context);
            },)

        ),
        body: qrCamera
    );
  }



}



