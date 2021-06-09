// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lender_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LenderInformation _$LenderInformationFromJson(Map<String, dynamic> json) {
  return LenderInformation(
    lenderReferralCode: json['lenderReferralCode'] as String?,
    lenderName: json['lenderName'] as String?,
    requestedPaybackMethods: json['requestedPaybackMethods'] == null
        ? null
        : (json['requestedPaybackMethods'] as List<dynamic>)
            .map((e) => _$enumDecode(_$PaymentMethodsEnumMap, e))
            .toList(),
  );
}

Map<String, dynamic> _$LenderInformationToJson(LenderInformation instance) =>
    <String, dynamic>{
      'lenderReferralCode': instance.lenderReferralCode,
      'lenderName': instance.lenderName,
      'requestedPaybackMethods': instance.requestedPaybackMethods,
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$PaymentMethodsEnumMap = {
  PaymentMethods.googlePay: 'googlePay',
  PaymentMethods.payTm: 'payTm',
  PaymentMethods.upi: 'upi',
  PaymentMethods.creditCard: 'creditCard',
  PaymentMethods.debitCard: 'debitCard',
};
