import 'package:bitad_staff/screens/attendance.dart';
import 'package:bitad_staff/screens/login.dart';
import 'package:bitad_staff/screens/contacts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'common/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Bitad Staff',
        theme: appTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => Login(),
          '/attendance': (context) => Attendance(),
          '/contacts': (context) => Contacts()
        });
  }
}
