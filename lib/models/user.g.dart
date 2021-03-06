// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      email: json['email'] as String,
      role: _$enumDecode(_$RoleEnumMap, json['role']),
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      rewardCode: json['rewardCode'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'email': instance.email,
      'role': _$RoleEnumMap[instance.role],
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'rewardCode': instance.rewardCode,
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$RoleEnumMap = {
  Role.Guest: 'Guest',
  Role.Admin: 'Admin',
  Role.Super: 'Super',
};
