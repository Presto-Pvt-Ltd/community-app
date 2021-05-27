// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomNotification _$CustomNotificationFromJson(Map<String, dynamic> json) {
  return CustomNotification(
    borrowerRating: (json['borrowerRating'] as num).toDouble(),
    lenderReferralCode: json['lenderReferralCode'] as String,
    amount: json['amount'] as int,
    transactionId: json['transactionId'] as String,
    paymentMethods: (json['paymentMethods'] as List<dynamic>)
        .map((e) => _$enumDecode(_$PaymentMethodsEnumMap, e))
        .toList(),
    borrowerReferralCode: json['borrowerReferralCode'] as String,
  );
}

Map<String, dynamic> _$CustomNotificationToJson(CustomNotification instance) =>
    <String, dynamic>{
      'borrowerReferralCode': instance.borrowerReferralCode,
      'lenderReferralCode': instance.lenderReferralCode,
      'transactionId': instance.transactionId,
      'amount': instance.amount,
      'borrowerRating': instance.borrowerRating,
      'paymentMethods': instance.paymentMethods
          .map((e) => _$PaymentMethodsEnumMap[e])
          .toList(),
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
