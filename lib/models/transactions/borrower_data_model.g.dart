// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'borrower_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BorrowerInformation _$BorrowerInformationFromJson(Map<String, dynamic> json) {
  return BorrowerInformation(
    borrowerSentMoneyDay: json['borrowerSentMoneyDay'] as int,
    borrowerSentMoneyHour: json['borrowerSentMoneyHour'] as int,
    borrowerSentMoneyMonth: json['borrowerSentMoneyMonth'] as int,
    borrowerSentMoneyYear: json['borrowerSentMoneyYear'] as int,
    borrowerReferralCode: json['borrowerReferralCode'] as String,
  );
}

Map<String, dynamic> _$BorrowerInformationToJson(
        BorrowerInformation instance) =>
    <String, dynamic>{
      'borrowerSentMoneyHour': instance.borrowerSentMoneyHour,
      'borrowerSentMoneyDay': instance.borrowerSentMoneyDay,
      'borrowerSentMoneyMonth': instance.borrowerSentMoneyMonth,
      'borrowerSentMoneyYear': instance.borrowerSentMoneyYear,
      'borrowerReferralCode': instance.borrowerReferralCode,
    };
