// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lender_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LenderInformation _$LenderInformationFromJson(Map<String, dynamic> json) {
  return LenderInformation(
    lenderSentMoneyDay: json['lenderSentMoneyDay'] as int,
    lenderSentMoneyHour: json['lenderSentMoneyHour'] as int,
    lenderSentMoneyMonth: json['lenderSentMoneyMonth'] as int,
    lenderSentMoneyYear: json['lenderSentMoneyYear'] as int,
    lenderReferralCode: json['lenderReferralCode'] as String,
  );
}

Map<String, dynamic> _$LenderInformationToJson(LenderInformation instance) =>
    <String, dynamic>{
      'lenderSentMoneyHour': instance.lenderSentMoneyHour,
      'lenderSentMoneyDay': instance.lenderSentMoneyDay,
      'lenderSentMoneyMonth': instance.lenderSentMoneyMonth,
      'lenderSentMoneyYear': instance.lenderSentMoneyYear,
      'lenderReferralCode': instance.lenderReferralCode,
    };
