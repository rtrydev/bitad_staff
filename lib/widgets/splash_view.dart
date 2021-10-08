
import 'package:bitad_staff/api/retrofit_api.dart';
import 'package:bitad_staff/api/retrofit_client.dart';
import 'package:bitad_staff/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>{

  late Future<User> user;
  bool loggedIn = false;

  @override
  void initState() {
    super.initState();
    user = _getUser();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
          future: user,
          builder: (context, snapshot){
            if(snapshot.hasData){
              final userData = snapshot.data as User;
              if(userData.role == Role.Guest){
                Future.microtask(() => Navigator.pushReplacementNamed(context, '/login'));
              } else {
                Future.microtask(() => Navigator.pushReplacementNamed(context, '/attendance'));
              }

              return Container();
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/images/bitad-logo.svg'),
                    const SizedBox(
                      height: 8,
                    ),
                    Text('STAFF APP', style: TextStyle(fontSize: 16)),
                    const SizedBox(
                      height: 90,
                    ),
                    const CircularProgressIndicator()
                  ],
                ),
              );
            }
          },
        )
    );
  }

  Future<User> _getUser() async{

    final api = RetrofitApi(context);
    final dio = await api.getApiClient();
    final client = RestClient(dio);
    return client.getUser().then((user) {
      setState(() {
        loggedIn = true;
      });
      RetrofitApi.userRole = user.role;

      return user;
    });

  }

}