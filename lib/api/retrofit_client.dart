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

@RestApi(baseUrl: "https://bitad.ath.bielsko.pl:8080/")
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @POST("/User/AuthenticateUser")
  Future<User> authenticateUser(@Body() UserLogin userLogin);

  @PUT("/Staff/CheckAttendance")
  Future<AttendanceResult> checkAttendance(@Query('attendanceCode') String code);

  @GET("/Staff/GetStaffAdmin")
  Future<List<Staff>> getStaff();

  @GET("/User/GetUser")
  Future<User> getUser();

  @GET("/Admin/GetWinners")
  Future<List<User>> getWinners(@Query ("numberOfWinners") int numberOfWinners);

  @GET("/Workshop/GetWorkshops")
  Future<List<Workshop>> getWorkshops();

  @GET("/Workshop/GetWorkshopParticipants")
  Future<List<Attendant>> getWorkshopParticipants(@Query("workshopCode") String workshopCode);

  @POST("/Admin/SendConfirmationMails")
  Future sendConfirmationMails();

  @POST("/Admin/ExcludeInactiveUsersFromWorkshops")
  Future excludeInactiveUsersFromWorkshops();

  @POST("/Admin/BanWorkshopInactiveAccounts")
  Future banWorkshopInactiveAccounts(@Query("workshopCode") String workshopCode);

  @PUT("/Staff/CheckWorkshopAttendance")
  Future<AttendanceResult> checkWorkshopAttendance(@Query("attendanceCode") String attendanceCode, @Query("workshopCode") String workshopCode);

  @PUT("/Admin/BanUser")
  Future<User> banUser(@Query("email") String email);

  @PUT("/Admin/UnbanUser")
  Future<User> unbanUser(@Query("email") String email);

  @GET("/Admin/GetMainWinner")
  Future<User> getXboxWinner();
}

