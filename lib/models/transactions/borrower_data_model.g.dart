// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'borrower_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BorrowerInformation _$BorrowerInformationFromJson(Map<String, dynamic> json) {
  return BorrowerInformation(
    borrowerReferralCode: json['borrowerReferralCode'] as String,
    borrowerName: json['borrowerName'] as String,
    borrowerCreditScore: (json['borrowerCreditScore'] as num).toDouble(),
    requestedPaybackMethods:
        (json['transactionMethodsRequestedByBorrower'] as List<dynamic>)
            .map((e) => _$enumDecode(_$PaymentMethodsEnumMap, e))
            .toList(),
  );
}

Map<String, dynamic> _$BorrowerInformationToJson(
        BorrowerInformation instance) =>
    <String, dynamic>{
      'borrowerReferralCode': instance.borrowerReferralCode,
      'borrowerName': instance.borrowerName,
      'borrowerCreditScore': instance.borrowerCreditScore,
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
