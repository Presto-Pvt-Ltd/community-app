// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generic_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenericInformation _$GenericInformationFromJson(Map<String, dynamic> json) {
  return GenericInformation(
    transactionId: json['transactionId'] as String,
    initiationHour: json['initiationHour'] as int,
    initiationDay: json['initiationDay'] as int,
    initiationMonth: json['initiationMonth'] as int,
    initiationYear: json['initiationYear'] as int,
    completionDay: json['completionDay'] as int,
    completionHour: json['completionHour'] as int,
    completionMonth: json['completionMonth'] as int,
    completionYear: json['completionYear'] as int,
    amount: json['amount'] as int,
    transactionMethods: (json['transactionMethods'] as List<dynamic>)
        .map((e) => _$enumDecode(_$PaymentMethodsEnumMap, e))
        .toList(),
    interestRate: (json['interestRate'] as num).toDouble(),
  );
}

Map<String, dynamic> _$GenericInformationToJson(GenericInformation instance) =>
    <String, dynamic>{
      'transactionId': instance.transactionId,
      'initiationHour': instance.initiationHour,
      'initiationDay': instance.initiationDay,
      'initiationMonth': instance.initiationMonth,
      'initiationYear': instance.initiationYear,
      'completionHour': instance.completionHour,
      'completionDay': instance.completionDay,
      'completionMonth': instance.completionMonth,
      'completionYear': instance.completionYear,
      'amount': instance.amount,
      'transactionMethods': instance.transactionMethods
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
