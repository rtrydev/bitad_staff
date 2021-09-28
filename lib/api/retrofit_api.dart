import 'package:bitad_staff/api/retrofit_client.dart';
import 'package:dio/dio.dart';

class RetrofitApi {
  static String token = '';
  static Dio dio = Dio();
  static final RetrofitApi _retrofitApi = RetrofitApi._internal();

  factory RetrofitApi() {
    return _retrofitApi;
  }

  Future<Dio> getApiClient() async {
    dio.interceptors.clear();
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (request, handler) {
        if (token != null && token != '')
          request.headers['Authorization'] = 'Bearer $token';
        return handler.next(request);
      },
      onResponse: (response, handler) {
        token = response.headers.value('authtoken') ?? '';
        return handler.next(response);
      },

    ));
    return dio;
  }

  RetrofitApi._internal();

}