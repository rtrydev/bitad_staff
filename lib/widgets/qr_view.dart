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

  @override
  initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
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
  }
}