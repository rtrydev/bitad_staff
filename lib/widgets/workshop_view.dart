
import 'dart:io';

import 'package:bitad_staff/models/attendant.dart';
import 'package:bitad_staff/models/workshop.dart';
import 'package:bitad_staff/screens/workshop_attendance.dart';
import 'package:bitad_staff/widgets/network_image_ssl.dart';
import 'package:bitad_staff/widgets/qr_view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bitad_staff/api/retrofit_api.dart';
import 'package:bitad_staff/api/retrofit_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WorkshopView extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => _WorkshopViewState();

}

class _WorkshopViewState extends State<WorkshopView> {
  late Future<List<Workshop>> workshopList;

  @override
  void initState(){
    super.initState();
    workshopList = _getWorkshops();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<List<Workshop>>(
          future: workshopList,
          builder: (context, snapshot){
            if(snapshot.hasData){
              return ListView.separated(
                  padding: EdgeInsets.only(top: 8),
                  itemBuilder: (BuildContext context, int index){
                    return GestureDetector(
                      child: Container(
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
                                              image: NetworkImageSSL('${snapshot.data?[index].speaker.picture}')
                                          )
                                      ),
                                    ),
                                    SizedBox(
                                      width: 210,
                                      child: Padding(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('${snapshot.data?[index].title}',
                                                style: TextStyle(fontWeight: FontWeight.w700, color: Colors.grey[900])),
                                            Text('${snapshot.data?[index].speaker.name}',
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
                                  child: Container()
                              )


                            ],
                          )
                      ),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(
                                builder: (context) => WorkshopAttendance(title: snapshot.data![index].title, workshopCode: snapshot.data![index].code)));

                      },
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

  Future<List<Workshop>> _getWorkshops() async {
    final api = RetrofitApi(context);
    final client = await api.getApiClient();
    final restClient = RestClient(client);
    final workshops = await restClient.getWorkshops();

    return workshops;

  }

  Future<List<Attendant>> _getAttendants(String code) async {
    final api = RetrofitApi(context);
    final client = await api.getApiClient();
    final restClient = RestClient(client);
    final participants = await restClient.getWorkshopParticipants(code);

    return participants;
  }
}