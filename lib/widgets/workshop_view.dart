
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
                      onTap: () async {
                        final result = await _getAttendants(snapshot.data![index].code);
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
                                        final email = result[index].eMail ?? '';
                                        return ListTile(
                                          title: Text((index + 1).toString() + '.  ' + firstName + ' ' + lastName +'  |  '+email),
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
                                            final email = result[i].eMail ?? '';
                                            return (i + 1).toString() + '.  ' + firstName + ' ' + lastName +'  |  '+email;
                                          });
                                          final path = directory+ '/' + snapshot.data![index].title.replaceAll(' ', '-')+'-'+DateTime.now().toString().split('.')[0].replaceFirst(' ', '-').replaceAll(':', '.')+'.txt';
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