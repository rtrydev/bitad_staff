
import 'package:shared_preferences/shared_preferences.dart';
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
  late Future<List<Staff>> staffList;

  @override
  void initState(){
    super.initState();
    staffList = _getStaff();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Staff>>(
        future: staffList,
        builder: (context, snapshot){
          if(snapshot.hasData){
            return ListView.separated(
                padding: EdgeInsets.only(top: 8),
                itemBuilder: (BuildContext context, int index){
                  return Container(
                      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 7,
                            child:
                            Row(
                              children: [
                                Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: NetworkImage('${snapshot.data?[index].picture}')
                                      )
                                  ),
                                ),
                                SizedBox(
                                  width: 210,
                                  child: Padding(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('${snapshot.data?[index].name}',
                                            style: TextStyle(fontWeight: FontWeight.w700, color: Colors.grey[900])),
                                        Text('${snapshot.data?[index].description}',
                                          style: TextStyle(color: Colors.grey.shade600),
                                        ),
                                      ],
                                    ),
                                    padding: EdgeInsets.only(left: 16),
                                  ),
                                ),


                              ],
                            ),

                          ),
                          Expanded(
                            flex: 2,
                            child:
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    width: 40,
                                    child: snapshot.data?[index].contact != null ? TextButton(
                                      child: Icon(Icons.phone, color:Colors.blue),
                                      onPressed: (){
                                        _launchCaller(snapshot.data?[index].contact);
                                      },
                                    ) : Container() ,
                                  ),
                                  SizedBox(
                                    width: 40,
                                    child: snapshot.data?[index].contact != null ? TextButton(
                                      child: Icon(Icons.message, color:Colors.blue),
                                      onPressed: (){
                                        _launchMessenger(snapshot.data?[index].contact);
                                      },
                                    ) : Container(),
                                  )

                                ]

                            ),
                          )


                        ],
                      )
                  );

                },
                separatorBuilder: (BuildContext context, int index) => const Divider(),
                itemCount: snapshot.data?.length ?? 0);
          } else {
            return const Center( child: CircularProgressIndicator(),) ;
          }
        },
      )
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

  Future<List<Staff>> _getStaff() async {
  final api = RetrofitApi(context);
  final client = await api.getApiClient();
  final restClient = RestClient(client);
  final staff = await restClient.getStaff();

  return staff;

}
}