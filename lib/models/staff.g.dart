// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Staff _$StaffFromJson(Map<String, dynamic> json) => Staff(
      name: json['name'] as String,
      picture: json['picture'] as String,
      description: json['description'] as String,
      degree: json['degree'] as String?,
      contact: json['contact'] as String?,
    );

Map<String, dynamic> _$StaffToJson(Staff instance) => <String, dynamic>{
      'name': instance.name,
      'picture': instance.picture,
      'description': instance.description,
      'degree': instance.degree,
      'contact': instance.contact,
    };
