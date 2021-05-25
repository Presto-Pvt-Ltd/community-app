// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'borrower_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BorrowerInformation _$BorrowerInformationFromJson(Map<String, dynamic> json) {
  return BorrowerInformation(
    borrowerSentMoneyHour: json['borrowerSentMoneyHour'] as int,
    borrowerSentMoneyAt: json['borrowerSentMoneyAt'] == null
        ? null
        : DateTime.parse(json['borrowerSentMoneyAt'] as String),
    borrowerReferralCode: json['borrowerReferralCode'] as String,
  );
}

Map<String, dynamic> _$BorrowerInformationToJson(
        BorrowerInformation instance) =>
    <String, dynamic>{
      'borrowerSentMoneyHour': instance.borrowerSentMoneyHour,
      'borrowerSentMoneyAt': instance.borrowerSentMoneyAt?.toIso8601String(),
      'borrowerReferralCode': instance.borrowerReferralCode,
    };
