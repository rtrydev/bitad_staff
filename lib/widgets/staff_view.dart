
import 'package:url_launcher/url_launcher.dart';
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
        padding: EdgeInsets.only(top: 8),
          itemBuilder: (BuildContext context, int index){
            return Container(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage('${staffList?[index].picture}')
                              )
                          ),
                        ),
                        Padding(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${staffList?[index].name}', style: TextStyle(fontWeight: FontWeight.w700)),
                              Text('${staffList?[index].description}', style: TextStyle(color: Colors.grey.shade600),),
                            ],
                          ),
                          padding: EdgeInsets.only(left: 16),
                        )

                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 40,
                            child: TextButton(
                              child: Icon(Icons.phone, color:Colors.blue),
                              onPressed: (){
                                _launchCaller(staffList?[index].contact);
                              },
                            ) ,
                          ),
                          SizedBox(
                            width: 40,
                            child: TextButton(
                              child: Icon(Icons.message, color:Colors.blue),
                              onPressed: (){
                                _launchMessenger(staffList?[index].contact);
                              },
                            ) ,
                          )

                        ]

                    )

                  ],
                )
            );

          },
          separatorBuilder: (BuildContext context, int index) => const Divider(),
          itemCount: staffList?.length ?? 0),
    );
  }

  void _launchCaller(String? number) async {
    final url = "tel:$number";
    if (await canLaunch(url)){
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _launchMessenger(String? number) async {
    final url = "sms:$number";
    if (await canLaunch(url)){
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

}