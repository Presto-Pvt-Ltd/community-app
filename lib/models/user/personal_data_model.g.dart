// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonalData _$PersonalDataFromJson(Map<String, dynamic> json) {
  return PersonalData(
    name: json['name'] as String,
    email: json['email'] as String,
    contact: json['contact'] as String,
    password: json['password'] as String,
    deviceId: json['deviceId'] as String,
    referralId: json['referralId'] as String,
  );
}

Map<String, dynamic> _$PersonalDataToJson(PersonalData instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'contact': instance.contact,
      'password': instance.password,
      'deviceId': instance.deviceId,
      'referralId': instance.referralId,
    };
