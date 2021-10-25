import 'package:bitad_staff/api/retrofit_api.dart';
import 'package:bitad_staff/api/retrofit_client.dart';
import 'package:bitad_staff/models/attendant.dart';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_mobile_vision/qr_camera.dart';
import 'package:shared_preferences/shared_preferences.dart';


class QRViewWorkshop extends StatefulWidget {
  String code;
  String title;
  QRViewWorkshop({Key? key, required this.title, required this.code}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewWorkshop();
}

class _QRViewWorkshop extends State<QRViewWorkshop> {

  bool camState = true;
  final codeTextController = TextEditingController();
  final emailTextController = TextEditingController();

  void showMessage(int code, bool fromCamera){
    String message = '';
    switch(code){
      case 0:
        {
          message = 'Ok';
          break;
        }
      case 1:
        {
          message = 'Już aktywowany';
          break;
        }
      case 2: {
        message = 'Konto nieaktywne';
        break;
      }
      case 404: {
        message = 'Nie znaleziono odpowiadającego użytkownika';
        break;
      }
      default: {
        message = 'Błąd';
        break;
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(message, textAlign: TextAlign.center, textScaleFactor: 1.2,),
        );
      },
    ).then((value) {
      setState(() {
        camState = true;
      });
      if(!fromCamera) {
        Navigator.pop(context);
      }
    });
  }

  void sendCode() async{
    setState(() {
      camState = false;
    });
    final result = await _getAttendants(widget.code);
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
                ListView.builder(shrinkWrap: true, itemCount: result.length ,itemBuilder: (BuildContext context,int index){
                  final firstName = result[index].firstName ?? '';
                  final lastName = result[index].lastName ?? '';
                  final code = result[index].workshopAttendanceCode ?? '';
                  return ListTile(
                    title: Text((index + 1).toString() + '.  ' + firstName + ' ' + lastName +'  |  '+code),
                  );
                }),
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
                        final code = result[i].workshopAttendanceCode ?? '';
                        return (i + 1).toString() + '.  ' + firstName + ' ' + lastName +'  |  '+code;
                      });
                      final path = directory+ '/' + widget.title.replaceAll(' ', '-')+'-'+DateTime.now().toString().split('.')[0].replaceFirst(' ', '-').replaceAll(':', '.')+'.txt';
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
    ).then((value) {
      setState((){
        camState = true;
      });
    });
  }

  Future<List<Attendant>> _getAttendants(String code) async {
    final api = RetrofitApi(context);
    final client = await api.getApiClient();
    final restClient = RestClient(client);
    final participants = await restClient.getWorkshopParticipants(code);

    return participants;
  }

  void sendEmail(){
    setState(() {
      camState = false;
    });
    showDialog(
      context: context,
      builder: (context) {

        codeTextController.text = '';
        return AlertDialog(
            content: Container(
              height: 250,
              width: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text('Wpisz adres E-Mail'),
                  const SizedBox(height: 16,),
                  TextFormField(controller: codeTextController,),
                  ElevatedButton(onPressed: (){
                    final api = RetrofitApi(context);
                    api.getApiClient().then((value) {
                      final client = RestClient(value);
                      client.checkWorkshopAttendance(codeTextController.text, widget.code)
                          .then((value) => showMessage(value.code, false));

                    });

                  }, child: Text('Zatwierdź'))
                ],
              ),
            )
        );
      },
    ).then((value) {
      setState((){
        camState = true;
      });
    });
  }

  @override
  initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final color = Theme.of(context).primaryColor;

    final qrSection = Center(
      child: camState ? QrCamera(
        qrCodeCallback: (code){
          setState(() {
            camState = false;
          });

          final api = RetrofitApi(context);
          api.getApiClient().then((value) {
            final client = RestClient(value);
            client.checkWorkshopAttendance(code!, widget.code)
                .then((value) => showMessage(value.code, true));

          });

        },
      ) : const Text(''),
    );

    final textButton = TextButton(
        onPressed: sendCode,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(Icons.list, color: color,),
            const Text('Lista osób')
          ],
        )
    );

    final emailButton = TextButton(
        onPressed: sendEmail,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(Icons.alternate_email, color: color),
            const Text('E-Mail')
          ],
        )
    );

    final buttonSection = Padding(
      padding: EdgeInsets.only(left: 32, right: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(child: textButton),
          Expanded(child: emailButton)
        ],
      ),
    );

    return Column(
      children: [
        Expanded(child: qrSection, flex: 16,),
        Expanded(child: buttonSection, flex: 2,)
      ],
    );

  }
}