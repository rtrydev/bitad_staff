import 'package:bitad_staff/models/attendance_result.dart';
import 'package:bitad_staff/models/staff.dart';
import 'package:bitad_staff/models/user.dart';
import 'package:bitad_staff/models/user_login.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'retrofit_client.g.dart';

@RestApi(baseUrl: "http://192.168.0.206:8080/")
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @POST("/User/AuthenticateUser")
  Future<User> authenticateUser(@Body() UserLogin userLogin);

  @PUT("/User/CheckAttendance")
  Future<AttendanceResult> checkAttendance(@Query('attendanceCode') String code);

  @GET("/Staff/GetStaffAdmin")
  Future<List<Staff>> getStaff();
}

