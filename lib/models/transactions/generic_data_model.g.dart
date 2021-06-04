// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generic_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenericInformation _$GenericInformationFromJson(Map<String, dynamic> json) {
  return GenericInformation(
    transactionId: json['transactionId'] as String,
    amount: json['amount'] as int,
    transactionMethodsRequestedByBorrower:
        (json['transactionMethodsRequestedByBorrower'] as List<dynamic>)
            .map((e) => _$enumDecode(_$PaymentMethodsEnumMap, e))
            .toList(),
    interestRate: (json['interestRate'] as num).toDouble(),
    initiationAt: DateTime.parse(json['initiationAt'] as String),
    completionAt: json['completionAt'] == null
        ? null
        : DateTime.parse(json['completionAt'] as String),
  );
}

Map<String, dynamic> _$GenericInformationToJson(GenericInformation instance) =>
    <String, dynamic>{
      'transactionId': instance.transactionId,
      'amount': instance.amount,
      'initiationAt': instance.initiationAt.toIso8601String(),
      'completionAt': instance.completionAt?.toIso8601String(),
      'transactionMethodsRequestedByBorrower': instance
          .transactionMethodsRequestedByBorrower
          .map((e) => _$PaymentMethodsEnumMap[e])
          .toList(),
      'interestRate': instance.interestRate,
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
