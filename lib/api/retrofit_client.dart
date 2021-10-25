import 'package:bitad_staff/models/attendance_result.dart';
import 'package:bitad_staff/models/attendant.dart';
import 'package:bitad_staff/models/staff.dart';
import 'package:bitad_staff/models/user.dart';
import 'package:bitad_staff/models/user_login.dart';
import 'package:bitad_staff/models/workshop.dart';
import 'package:bitad_staff/screens/workshops.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'retrofit_client.g.dart';

@RestApi(baseUrl: "http://212.106.184.93:8080/")
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

  @GET("/Workshop/GetWorkshops")
  Future<List<Workshop>> getWorkshops();

  @GET("/Workshop/GetWorkshopParticipants")
  Future<List<Attendant>> getWorkshopParticipants(@Query("workshopCode") String workshopCode);

  @POST("/Staff/SendConfirmationMails")
  Future sendConfirmationMails();

  @POST("/Staff/ExcludeInactiveUsersFromWorkshops")
  Future excludeInactiveUsersFromWorkshops();

  @POST("/Staff/BanWorkshopInactiveAccounts")
  Future banWorkshopInactiveAccounts(@Query("workshopCode") String workshopCode);

  @PUT("/User/CheckWorkshopAttendance")
  Future<AttendanceResult> checkWorkshopAttendance(@Query("attendanceCode") String attendanceCode, @Query("workshopCode") String workshopCode);
}

