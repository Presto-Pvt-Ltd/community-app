// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lender_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LenderInformation _$LenderInformationFromJson(Map<String, dynamic> json) {
  return LenderInformation(
    lenderReferralCode: json['lenderReferralCode'] as String?,
    lenderName: json['lenderName'] as String?,
    contact: json['contact'] as String?,
    paymentMethods:
        (json['paymentMethods'] == null || json['paymentMethods'].length == 0)
            ? null
            : (json['paymentMethods'] as List<dynamic>)
                .map((e) => paymentEnumDecode(e))
                .toList(),
  );
}

Map<String, dynamic> _$LenderInformationToJson(LenderInformation instance) =>
    <String, dynamic>{
      'lenderReferralCode': instance.lenderReferralCode,
      'lenderName': instance.lenderName,
      'contact': instance.contact,
      'paymentMethods':
          instance.paymentMethods?.map((e) => PaymentMethodsMap[e]).toList(),
    };
