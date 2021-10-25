// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workshop.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Workshop _$WorkshopFromJson(Map<String, dynamic> json) => Workshop(
      title: json['title'] as String,
      code: json['code'] as String,
      speaker: Speaker.fromJson(json['speaker'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WorkshopToJson(Workshop instance) => <String, dynamic>{
      'title': instance.title,
      'code': instance.code,
      'speaker': instance.speaker,
    };
