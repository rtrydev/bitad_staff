import 'dart:io';

import 'package:bitad_staff/api/retrofit_api.dart';
import 'package:bitad_staff/api/retrofit_client.dart';
import 'package:bitad_staff/models/user.dart';
import 'package:bitad_staff/models/user_login.dart';
import 'package:bitad_staff/screens/attendance.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;

class MainWinnerView extends StatefulWidget {
  const MainWinnerView({Key? key}) : super(key: key);

  @override
  _MainWinnerState createState() => _MainWinnerState();
}

class _MainWinnerState extends State<MainWinnerView> {

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

              const SizedBox(
                height: 32,
              ),
              ElevatedButton(
                  onPressed: () async {

                    final api = RetrofitApi(context);


                    api.getApiClient().then((dio) async {
                      final client = RestClient(dio);

                      var result = await client.getMainWinner();
                      var dialogHeight = 70.0*result.length + 55;
                      if(dialogHeight > 555) dialogHeight = 555;
                      if(dialogHeight == 55) dialogHeight += 15;

                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Container(
                              height: dialogHeight,
                              width: 300,
                              child: Column(
                                children: [
                                  Container(
                                    height: dialogHeight - 70,
                                    child: ListView.builder(shrinkWrap: true, itemCount: result.length ,itemBuilder: (BuildContext context,int index){
                                      final firstName = result[index].firstName ?? '';
                                      final lastName = result[index].lastName ?? '';
                                      final rewardCode = result[index].rewardCode ?? '';
                                      final email = result[index].email;
                                      return ListTile(
                                        title: Text(firstName + ' ' + lastName +'  |  '+ rewardCode + '  |  ' + email),
                                      );
                                    }),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  ElevatedButton(
                                      onPressed: () async {
                                        var status = await Permission.storage.status;
                                        if (!status.isGranted) {
                                          // You can request multiple permissions at once.
                                          Map<Permission, PermissionStatus> statuses = await [
                                            Permission.storage
                                          ].request();
                                        }
                                        final directory = '/storage/emulated/0/Download/Bitad';
                                        await Directory(directory).create();
                                        var lines = List.generate(result.length, (i) {
                                          final firstName = result[i].firstName ?? '';
                                          final lastName = result[i].lastName ?? '';
                                          final rewardCode = result[i].rewardCode ?? '';
                                          final email = result[i].email;
                                          return (i + 1).toString() + '.  ' + firstName + ' ' + lastName +'  |  '+ rewardCode + '  |  ' + email;
                                        });
                                        final path = '${directory}/bitad-winners-'+DateTime.now().toString().split('.')[0].replaceFirst(' ', '-').replaceAll(':', '.')+'.txt';
                                        var outputFile = await File(path).create();
                                        for(int j = 0; j<result.length; j++) {
                                          outputFile.writeAsStringSync('${lines[j]}\n\n', mode: FileMode.append);
                                        }
                                        final snackBar = SnackBar(content: Text('Zapisano w ${path}'));
                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);

                                      },
                                      style: ButtonStyle(
                                          minimumSize: MaterialStateProperty.all(const Size(110, 35)),
                                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(16.0)))),
                                      child: const Text('Zapisz do pliku', textScaleFactor: 1.2,))
                                ],
                              ),
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

