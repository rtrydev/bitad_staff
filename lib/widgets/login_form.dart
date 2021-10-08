import 'package:bitad_staff/api/retrofit_api.dart';
import 'package:bitad_staff/api/retrofit_client.dart';
import 'package:bitad_staff/models/user.dart';
import 'package:bitad_staff/models/user_login.dart';
import 'package:bitad_staff/screens/attendance.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final loginTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  @override
  void dispose(){
    loginTextController.dispose();
    passwordTextController.dispose();
    super.dispose();
  }

  @override
  void initState(){
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    Widget loginBody = Center(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 80.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/images/bitad-logo.svg'),
            const SizedBox(
              height: 8,
            ),
            Text('STAFF APP', style: TextStyle(fontSize: 16)),
            const SizedBox(
              height: 48,
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'login',
              ),
              controller: loginTextController,
            ),
            const SizedBox(
              height: 8,
            ),
            TextFormField(
              decoration: const InputDecoration(hintText: 'hasło'),
              obscureText: true,
              controller: passwordTextController,
            ),
            const SizedBox(
              height: 32,
            ),
            ElevatedButton(
                onPressed: () {
                  final username = loginTextController.text;
                  final password = passwordTextController.text;
                  if(username == '' || password == '') return;

                  final api = RetrofitApi(context);
                  api.getApiClient().then((dio) {
                    final client = RestClient(dio);
                    client
                        .authenticateUser(UserLogin(username: username, password: password))
                        .then((response) {
                      RetrofitApi.userRole = response.role;
                      if(response.role == Role.Admin || response.role == Role.Super){
                        Navigator.pushReplacement(context, _createRoute());

                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return const AlertDialog(
                              content: Text('Brak uprawnień do korzystania z tej aplikacji', textAlign: TextAlign.center,),
                            );
                          },
                        );
                      }
                    }).catchError((error) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return const AlertDialog(
                            content: Text('Błąd', textAlign: TextAlign.center,),
                          );
                        },
                      );

                    });
                  });
                },
                style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(const Size(110, 35)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0)))),
                child: const Text('Zaloguj się', textScaleFactor: 1.2,))
          ],
        ),
      ),
    );


    return Scaffold(
      body: loginBody
    );

  }

  Route _createRoute(){
    return PageRouteBuilder(

      pageBuilder: (context, animation, secondaryAnimation) => Attendance(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
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

