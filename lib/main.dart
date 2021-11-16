import 'package:bitad_staff/screens/attendance.dart';
import 'package:bitad_staff/screens/login.dart';
import 'package:bitad_staff/screens/contacts.dart';
import 'package:bitad_staff/screens/splash.dart';
import 'package:bitad_staff/screens/super.dart';
import 'package:bitad_staff/screens/winners.dart';
import 'package:bitad_staff/screens/workshops.dart';
import 'package:bitad_staff/widgets/mainwinner_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'common/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
    .then((value) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Bitad Staff',
        theme: appTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => Splash(),
          '/attendance': (context) => Attendance(),
          '/contacts': (context) => Contacts(),
          '/winners' : (context) => Winners(),
          '/login' : (context) => Login(),
          '/workshops' : (context) => Workshops(),
          '/super' : (context) => SuperMenu(),
          '/mainwinner' : (context) => MainWinnerView(),
        });
  }
}
