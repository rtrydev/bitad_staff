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
import 'dart:developer' as developer;

class WinnersForm extends StatefulWidget {
  const WinnersForm({Key? key}) : super(key: key);

  @override
  _WinnersFormState createState() => _WinnersFormState();
}

class _WinnersFormState extends State<WinnersForm> {
  final numberOfWinnersTextController = TextEditingController();

  @override
  void dispose(){
    numberOfWinnersTextController.dispose();
    super.dispose();
  }

  @override
  void initState(){
    super.initState();
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
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'ilość osób do wylosowania',
                ),
                controller: numberOfWinnersTextController,
                textAlignVertical: TextAlignVertical.bottom,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 32,
              ),
              ElevatedButton(
                  onPressed: () async {
                    final numberOfWinners = numberOfWinnersTextController.text;
                    if(numberOfWinners == '') return;


                    final api = RetrofitApi(context);
                    

                    api.getApiClient().then((dio) async {
                      final client = RestClient(dio);

                      var result = await client.getWinners(int.parse(numberOfWinners));

                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Container(
                              height: 70.0*result.length,
                              width: 300,
                              child: ListView.builder(shrinkWrap: true, itemCount: result.length ,itemBuilder: (BuildContext context,int index){
                                return ListTile(
                                  title: Text(result[index].username +'  |  '+result[index].email),
                                  subtitle: Text(result[index].firstName + ' ' + result[index].lastName),
                                );
                              }),
                            ),
                          );
                        },
                      );

                    });
                  },
                  style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(const Size(110, 35)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0)))),
                  child: const Text('Losuj', textScaleFactor: 1.2,))
            ],
          ),
        ),
      ),
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

