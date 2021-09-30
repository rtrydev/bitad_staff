import 'package:bitad_staff/api/retrofit_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RetrofitApi {
  static Dio dio = Dio();
  static BuildContext? _context;
  static final RetrofitApi _retrofitApi = RetrofitApi._internal();

  factory RetrofitApi(BuildContext context) {
    _context = context;
    return _retrofitApi;
  }

  Future<Dio> getApiClient() async {
    dio.interceptors.clear();
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (request, handler) {
        SharedPreferences.getInstance().then((prefs) {
          String? token = prefs.getString('token');
          if (token != null && token != '')
            request.headers['Authorization'] = 'Bearer $token';
        });
        return handler.next(request);
      },
      onResponse: (response, handler) {


        SharedPreferences.getInstance()
            .then((prefs) => prefs.setString('token', response.headers.value('authtoken') ?? ''));

        return handler.next(response);
      },
      onError: (error, handler) {
        if(error.response?.statusCode == 401){
          SharedPreferences.getInstance()
              .then((prefs) => prefs.setString('token', ''));
          if(ModalRoute.of(_context!)?.settings.name != '/'){
            Navigator.pushReplacementNamed(_context!, '/');
          }
          return;
        }

      }

    ));
    return dio;
  }

  RetrofitApi._internal();

}