// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'borrower_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BorrowerInformation _$BorrowerInformationFromJson(Map<String, dynamic> json) {
  print("\n\n\n");
  print(json);
  print("\n\n\n");
  return BorrowerInformation(
    borrowerReferralCode: json['borrowerReferralCode'] as String,
    borrowerName: json['borrowerName'] as String,
    borrowerCreditScore: (json['borrowerCreditScore'] as num).toDouble(),
    contact: json['contact'] as String,
    paymentMethods:
        (json['paymentMethods'] == null || json['paymentMethods'].length == 0)
            ? null
            : (json['paymentMethods'] as List<dynamic>)
                .map((e) => paymentEnumDecode(e))
                .toList(),
  );
}

Map<String, dynamic> _$BorrowerInformationToJson(
        BorrowerInformation instance) =>
    <String, dynamic>{
      'borrowerReferralCode': instance.borrowerReferralCode,
      'borrowerName': instance.borrowerName,
      'borrowerCreditScore': instance.borrowerCreditScore,
      'contact': instance.contact,
      'paymentMethods':
          instance.paymentMethods?.map((e) => PaymentMethodsMap[e]).toList(),
    };
