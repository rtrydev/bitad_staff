

import 'package:bitad_staff/api/retrofit_api.dart';
import 'package:bitad_staff/api/retrofit_client.dart';
import 'package:bitad_staff/models/staff.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StaffView extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _StaffViewState();

}

class _StaffViewState extends State<StaffView> {
  List<Staff>? staffList;

  @override
  Widget build(BuildContext context) {

    final api = RetrofitApi();
    api.getApiClient().then((value) {
      final client = RestClient(value);
      client.getStaff().then((value) => {setState(() => staffList = value)});
    });

    return Scaffold(
      body: ListView.separated(
          itemBuilder: (BuildContext context, int index){
            return Container(
              height: 50,
              child: Center(child: Text('${staffList?[index].name}'),),
            );
          },
          separatorBuilder: (BuildContext context, int index) => const Divider(),
          itemCount: staffList?.length ?? 0),
    );
  }

}