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

class OptionInformation{
  String optionName;
  IconData optionIcon;
  OptionInformation({required this.optionIcon, required this.optionName});
}

class SuperMenuView extends StatefulWidget {
  const SuperMenuView({Key? key}) : super(key: key);

  @override
  _SuperMenuView createState() => _SuperMenuView();
}

class _SuperMenuView extends State<SuperMenuView> {
  final textController = TextEditingController();

  @override
  void dispose(){
    textController.dispose();
    super.dispose();
  }

  @override
  void initState(){
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var optionList = List.generate(6, (index) {
      switch(index){
        case 0: return OptionInformation(optionIcon: Icons.emoji_events, optionName: "Losuj główną nagrodę");
        case 1: return OptionInformation(optionIcon: Icons.emoji_events, optionName: "Losuj zwycięzców");
        case 2: return OptionInformation(optionIcon: Icons.mail, optionName: "Wyślij maile z potwierdzeniem obecności");
        case 3: return OptionInformation(optionIcon: Icons.delete_forever, optionName: "Usuń nieaktywnych użytkowników z warsztatów");
        case 4: return OptionInformation(optionIcon: Icons.block, optionName: "Wyklucz użytkownika z udziału w losowaniu");
        case 5: return OptionInformation(optionIcon: Icons.check, optionName: "Przywróć użytkownika do udziału w losowaniu");
      }
    });
    
    return Scaffold(
      body: ListView.builder(
        itemCount: 6,
        itemBuilder: (_, i) {
          return ListTile(
            title: Text(optionList[i]!.optionName),
            leading: Icon(optionList[i]!.optionIcon, color: Colors.grey[900]),
            onTap: () {
              switch(i){
                case 0:
                  Navigator.pushNamed(context, '/mainwinner');
                  break;
                case 1:
                  Navigator.pushNamed(context, '/winners');
                  break;
                case 2:
                  showDialog(context: context, builder: (context){
                    textController.clear();
                    return AlertDialog(
                      content: Container(
                        height: 200,
                        child: Column(
                          children: [
                            Text('Czy na pewno chcesz wysłać maile? Aby potwierdzić, wpisz "tak" w polu tekstowym i naciśnij Ok'),
                            TextField(
                              controller: textController,
                            ),
                            SizedBox(
                              height: 24,
                            ),
                            ElevatedButton(
                                onPressed: (){
                                  if(textController.text != "tak"){
                                    Navigator.pop(context);
                                  } else {
                                    textController.clear();
                                    final api = RetrofitApi(context);


                                    api.getApiClient().then((dio) async {
                                      final client = RestClient(dio);

                                      var result = await client.sendConfirmationMails();
                                      final snackBar = SnackBar(content: Text('Wysłano maile'));
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      Navigator.pop(context);
                                    });
                                  }

                                },
                                style: ButtonStyle(
                                    minimumSize: MaterialStateProperty.all(const Size(110, 35)),
                                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)))),
                                child: Text("Ok", textScaleFactor: 1.2,))
                          ],
                        ),
                      )
                    );
                  });
                  break;
                case 3:
                  showDialog(context: context, builder: (context){
                    textController.clear();
                    return AlertDialog(
                        content: Container(
                          height: 220,
                          child: Column(
                            children: [
                              Text('Czy na pewno chcesz usunąć z warsztatów nieaktywnych użytkowników? Aby potwierdzić, wpisz "tak" w polu tekstowym i naciśnij Ok'),
                              TextField(
                                controller: textController,
                              ),
                              SizedBox(
                                height: 24,
                              ),
                              ElevatedButton(
                                  onPressed: (){
                                    if(textController.text != "tak"){
                                      Navigator.pop(context);
                                    } else {
                                      textController.clear();
                                      final api = RetrofitApi(context);


                                      api.getApiClient().then((dio) async {
                                        final client = RestClient(dio);

                                        var result = await client.excludeInactiveUsersFromWorkshops();
                                        final snackBar = SnackBar(content: Text('Usunięto z workshopów nieaktywnych użytkowników'));
                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                        Navigator.pop(context);
                                      });
                                    }


                                  },
                                  style: ButtonStyle(
                                      minimumSize: MaterialStateProperty.all(const Size(110, 35)),
                                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)))),
                                  child: Text("Ok", textScaleFactor: 1.2,))
                            ],
                          ),
                        )
                    );
                  });
                  break;
                case 4:
                  showDialog(context: context, builder: (context){
                    textController.clear();
                    return AlertDialog(
                        content: Container(
                          height: 220,
                          child: Column(
                            children: [
                              Text('Wpisz email użytkownika do zbanowania'),
                              SizedBox(
                                height: 41,
                              ),
                              TextField(
                                controller: textController,
                              ),
                              SizedBox(
                                height: 41,
                              ),
                              ElevatedButton(
                                  onPressed: (){
                                    if(textController.text != ""){
                                      final api = RetrofitApi(context);


                                      api.getApiClient().then((dio) async {
                                        final client = RestClient(dio);

                                        var result = await client.banUser(textController.text);
                                        textController.clear();
                                        showDialog(context: context, builder: (context) {
                                          return AlertDialog(
                                            content: Padding(
                                              padding: EdgeInsets.all(10.0),
                                              child: Text("Zbanowano " + result.firstName! + ' ' + result.lastName!),
                                            ),
                                          );
                                        });
                                      });
                                    }


                                  },
                                  style: ButtonStyle(
                                      minimumSize: MaterialStateProperty.all(const Size(110, 35)),
                                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)))),
                                  child: Text("Ok", textScaleFactor: 1.2,))
                            ],
                          ),
                        )
                    );
                  });
                  break;
                case 5:
                  showDialog(context: context, builder: (context){
                    textController.clear();
                    return AlertDialog(
                        content: Container(
                          height: 220,
                          child: Column(
                            children: [
                              Text('Wpisz email użytkownika do odbanowania'),
                              SizedBox(
                                height: 41,
                              ),
                              TextField(
                                controller: textController,
                              ),
                              SizedBox(
                                height: 41,
                              ),
                              ElevatedButton(
                                  onPressed: (){
                                    if(textController.text != ""){
                                      final api = RetrofitApi(context);


                                      api.getApiClient().then((dio) async {
                                        final client = RestClient(dio);

                                        var result = await client.unbanUser(textController.text);
                                        textController.clear();
                                        showDialog(context: context, builder: (context) {
                                          return AlertDialog(
                                            content: Padding(
                                              padding: EdgeInsets.all(10.0),
                                              child: Text("Odbanowano " + result.firstName! + ' ' + result.lastName!),
                                            ),
                                          );
                                        });
                                      });
                                    }


                                  },
                                  style: ButtonStyle(
                                      minimumSize: MaterialStateProperty.all(const Size(110, 35)),
                                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)))),
                                  child: Text("Ok", textScaleFactor: 1.2,))
                            ],
                          ),
                        )
                    );
                  });
                  break;
              }
            }, // Handle your onTap here.
          );
        },
      )
    );

  }


}

