// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionData _$TransactionDataFromJson(Map<String, dynamic> json) {
  return TransactionData(
    paymentMethodsUsed: json['paymentMethodsUsed'] as Map<String, dynamic>,
    transactionIds: (json['transactionIds'] as List<dynamic>)
        .map((e) => e as String)
        .toList(),
    totalBorrowed: json['totalBorrowed'] as int,
    totalLent: json['totalLent'] as int,
    activeTransactions: (json['activeTransactions'] as List<dynamic>)
        .map((e) => e as String)
        .toList(),
  );
}

Map<String, dynamic> _$TransactionDataToJson(TransactionData instance) =>
    <String, dynamic>{
      'paymentMethodsUsed': instance.paymentMethodsUsed,
      'transactionIds': instance.transactionIds,
      'totalBorrowed': instance.totalBorrowed,
      'totalLent': instance.totalLent,
      'activeTransactions': instance.activeTransactions,
    };
