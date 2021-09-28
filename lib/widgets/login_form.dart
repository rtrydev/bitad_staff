import 'package:bitad_staff/api/retrofit_api.dart';
import 'package:bitad_staff/api/retrofit_client.dart';
import 'package:bitad_staff/models/user.dart';
import 'package:bitad_staff/models/user_login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:dio/dio.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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

                    final api = RetrofitApi();
                    api.getApiClient().then((dio) {
                      final client = RestClient(dio);
                      client
                          .authenticateUser(UserLogin(username: username, password: password))
                          .then((response) {
                        if(response.role == Role.Admin){
                          Navigator.pushReplacementNamed(context, '/attendance');
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                // Retrieve the text the that user has entered by using the
                                // TextEditingController.
                                content: Text('Brak uprawnień do korzystania z tej aplikacji', textAlign: TextAlign.center,),
                              );
                            },
                          );
                        }
                      }).catchError((error) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              // Retrieve the text the that user has entered by using the
                              // TextEditingController.
                              content: Text('Nieprawidłowy login lub hasło', textAlign: TextAlign.center,),
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
                  child: const Text('Zaloguj', textScaleFactor: 1.2,))
            ],
          ),
        ),
      ),
    );
  }

}