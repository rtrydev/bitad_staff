import 'package:bitad_staff/api/retrofit_api.dart';
import 'package:bitad_staff/api/retrofit_client.dart';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_mobile_vision/qr_camera.dart';
import 'package:shared_preferences/shared_preferences.dart';


class QRViewAttendance extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRViewAttendanceState();
}

class _QRViewAttendanceState extends State<QRViewAttendance> {
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

  void sendCode(){
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
                  const Text('Wpisz kod obecności'),
                  const SizedBox(height: 16,),
                  TextFormField(controller: codeTextController,),
                  ElevatedButton(onPressed: (){
                    final api = RetrofitApi(context);
                    api.getApiClient().then((value) {
                      final client = RestClient(value);
                      client.checkAttendance(codeTextController.text).then((value) => showMessage(value.code, false));
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
                      client.checkAttendance(codeTextController.text)
                      .then((value) => client.checkAttendance(codeTextController.text)
                          .then((value) => showMessage(value.code, false)));

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
            client.checkAttendance(code!)
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
            Icon(Icons.text_fields, color: color,),
            const Text('Wpisz kod')
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