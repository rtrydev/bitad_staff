import 'package:bitad_staff/api/retrofit_api.dart';
import 'package:bitad_staff/api/retrofit_client.dart';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_mobile_vision/qr_camera.dart';


class QRViewAttendance extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRViewAttendanceState();
}

class _QRViewAttendanceState extends State<QRViewAttendance> {
  bool camState = true;
  final codeTextController = TextEditingController();
  final emailTextController = TextEditingController();

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
                    final api = RetrofitApi();
                    api.getApiClient().then((value) {
                      final client = RestClient(value);
                      client.checkAttendance(codeTextController.text);
                    });

                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Text(codeTextController.text),
                        );
                      },
                    ).then((value) {
                      Navigator.pop(context);
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
                    final api = RetrofitApi();
                    api.getApiClient().then((value) {
                      final client = RestClient(value);
                      client.checkAttendance(codeTextController.text);
                    });

                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Text(codeTextController.text),
                        );
                      },
                    ).then((value) {
                      Navigator.pop(context);
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

          final api = RetrofitApi();
          api.getApiClient().then((value) {
            final client = RestClient(value);
            client.checkAttendance(code!);
          });

          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text(code!),
              );
            },
          ).then((exit) {
            setState(() {
              camState = true;
            });
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

    final buttonSection = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        textButton,
        emailButton
      ],
    );

    return Column(
      children: [
        Expanded(child: qrSection, flex: 16,),
        Expanded(child: buttonSection, flex: 2,)
      ],
    );

  }
}