import 'package:bitad_staff/models/attendance_result.dart';
import 'package:bitad_staff/models/staff.dart';
import 'package:bitad_staff/models/user.dart';
import 'package:bitad_staff/models/user_login.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'retrofit_client.g.dart';

@RestApi(baseUrl: "http://10.0.2.2:8080/")
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @POST("/User/AuthenticateUser")
  Future<User> authenticateUser(@Body() UserLogin userLogin);

  @PUT("/User/CheckAttendance")
  Future<AttendanceResult> checkAttendance(@Query('attendanceCode') String code);

  @GET("/Staff/GetStaffAdmin")
  Future<List<Staff>> getStaff();

  @GET("/User/GetUser")
  Future<User> getUser();

  @GET("/User/Winners")
  Future<List<User>> getWinners(@Query ("numberOfWinners") int numberOfWinners);
}

