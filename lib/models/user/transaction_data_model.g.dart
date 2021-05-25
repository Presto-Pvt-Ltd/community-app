// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionData _$TransactionDataFromJson(Map<String, dynamic> json) {
  return TransactionData(
    paymentMethodsUsed: (json['paymentMethodsUsed'] as List<dynamic>)
        .map((e) => _$enumDecode(_$PaymentMethodsEnumMap, e))
        .toList(),
    transactionIds: (json['transactionIds'] as List<dynamic>)
        .map((e) => e as String)
        .toList(),
    totalBorrowed: json['totalBorrowed'] as int,
    totalLent: json['totalLent'] as int,
    hasActiveTransaction: json['hasActiveTransaction'] as int,
  );
}

Map<String, dynamic> _$TransactionDataToJson(TransactionData instance) =>
    <String, dynamic>{
      'paymentMethodsUsed': instance.paymentMethodsUsed
          .map((e) => _$PaymentMethodsEnumMap[e])
          .toList(),
      'transactionIds': instance.transactionIds,
      'totalBorrowed': instance.totalBorrowed,
      'totalLent': instance.totalLent,
      'hasActiveTransaction': instance.hasActiveTransaction,
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
