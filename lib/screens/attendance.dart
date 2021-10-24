import 'package:bitad_staff/api/retrofit_api.dart';
import 'package:bitad_staff/api/retrofit_client.dart';
import 'package:bitad_staff/models/user.dart';
import 'package:bitad_staff/screens/contacts.dart';
import 'package:bitad_staff/screens/winners.dart';
import 'package:bitad_staff/screens/workshops.dart';
import 'package:bitad_staff/widgets/qr_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        title: Text(
            'Sprawdź obecność',
          textScaleFactor: 1.2,
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[900]),
        ),
        actions: [
          IconButton(icon: Icon(Icons.contacts, color: Colors.grey[900],), onPressed: (){
            Navigator.pushReplacement(context, _createRouteContacts());
          },),
          IconButton(onPressed: (){
            Navigator.pushReplacement(context, _createRouteWorkshops());
          }, icon: Icon(Icons.text_snippet_outlined, color: Colors.grey[900],) )
        ],
        leading: RetrofitApi.userRole == Role.Super ?
        IconButton(icon: Icon(Icons.emoji_events, color: Colors.grey[900],), onPressed: (){
          Navigator.pushReplacement(context, _createRouteWinners());
        },) : Container()

      ),
      body: qrCamera
    );
  }

  Route _createRouteContacts(){
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

  Route _createRouteWorkshops(){
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => Workshops(),
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

  Route _createRouteWinners(){
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => Winners(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1.0, 0.0);
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



