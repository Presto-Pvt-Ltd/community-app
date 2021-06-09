// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lender_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LenderInformation _$LenderInformationFromJson(Map<String, dynamic> json) {
  return LenderInformation(
    lenderReferralCode: json['lenderReferralCode'] as String?,
    lenderName: json['lenderName'] as String?,
    upiId: json['upiId'] as String?,
  );
}

Map<String, dynamic> _$LenderInformationToJson(LenderInformation instance) =>
    <String, dynamic>{
      'lenderReferralCode': instance.lenderReferralCode,
      'lenderName': instance.lenderName,
      'upiId': instance.upiId,
    };
