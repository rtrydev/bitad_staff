// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Attendant _$AttendantFromJson(Map<String, dynamic> json) => Attendant(
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      workshopAttendanceCode: json['workshopAttendanceCode'] as String?,
    );

Map<String, dynamic> _$AttendantToJson(Attendant instance) => <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'workshopAttendanceCode': instance.workshopAttendanceCode,
    };
