// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lender_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LenderInformation _$LenderInformationFromJson(Map<String, dynamic> json) {
  return LenderInformation(
    lenderSentMoneyAt: json['lenderSentMoneyAt'] == null
        ? null
        : DateTime.parse(json['lenderSentMoneyAt'] as String),
    lenderReferralCode: json['lenderReferralCode'] as String,
  );
}

Map<String, dynamic> _$LenderInformationToJson(LenderInformation instance) =>
    <String, dynamic>{
      'lenderSentMoneyAt': instance.lenderSentMoneyAt?.toIso8601String(),
      'lenderReferralCode': instance.lenderReferralCode,
    };
