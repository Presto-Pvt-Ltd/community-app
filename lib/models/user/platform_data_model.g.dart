// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platform_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlatformData _$PlatformDataFromJson(Map<String, dynamic> json) {
  return PlatformData(
    referralCode: json['referralCode'] as String,
    referredBy: json['referredBy'] as String,
    referredTo:
        (json['referredTo'] as List<dynamic>).map((e) => e as String).toList(),
  );
}

Map<String, dynamic> _$PlatformDataToJson(PlatformData instance) =>
    <String, dynamic>{
      'referralCode': instance.referralCode,
      'referredBy': instance.referredBy,
      'referredTo': instance.referredTo,
    };
