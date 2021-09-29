
import 'package:bitad_staff/screens/contacts.dart';
import 'package:bitad_staff/widgets/qr_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_mobile_vision/qr_camera.dart';

class Attendance extends StatelessWidget {


  @override
  Widget build(BuildContext context){

    final color = Theme.of(context).primaryColor;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final qrCamera = QRViewAttendance();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        centerTitle: true,
        title: const Text(
            'Sprawdź Obecność',
          textScaleFactor: 1.2,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.contacts, color: Colors.black,), onPressed: (){
            Navigator.pushReplacement(context, _createRoute());
          },)
        ],
      ),
      body: Column(
        children: [
          Expanded(child: qrCamera, flex: 7,),
        ],
      )
    );
  }

  Route _createRoute(){
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => Contacts(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }


}



