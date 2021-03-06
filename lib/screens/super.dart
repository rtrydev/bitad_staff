import 'package:bitad_staff/widgets/supermenu_view.dart';
import 'package:bitad_staff/widgets/winners_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'attendance.dart';

class SuperMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme
        .of(context)
        .scaffoldBackgroundColor;
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: backgroundColor,
              centerTitle: true,
              title: Text('Narzędzia administracyjne', textScaleFactor: 1.2,
                style: TextStyle(
                    fontWeight: FontWeight.w500, color: Colors.grey[900]),),
              leading:
              IconButton(icon: Icon(Icons.arrow_back, color: Colors.grey[900],),
                onPressed: () {
                  Navigator.pushReplacement(context, _createRoute());
                },)

          ),
          body: SuperMenuView(),
        ), onWillPop: () async {
          Navigator.pushReplacement(context, _createRoute());
          return false;
    });
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => Attendance(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}