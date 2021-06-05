// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'borrower_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BorrowerInformation _$BorrowerInformationFromJson(Map<String, dynamic> json) {
  return BorrowerInformation(
    borrowerReferralCode: json['borrowerReferralCode'] as String,
    borrowerName: json['borrowerName'] as String,
    borrowerCreditScore: json['borrowerCreditScore'] as double,
  );
}

Map<String, dynamic> _$BorrowerInformationToJson(
        BorrowerInformation instance) =>
    <String, dynamic>{
      'borrowerReferralCode': instance.borrowerReferralCode,
      'borrowerName': instance.borrowerName,
      'borrowerCreditScore': instance.borrowerCreditScore,
    };
