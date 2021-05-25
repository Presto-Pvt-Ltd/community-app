// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionData _$TransactionDataFromJson(Map<String, dynamic> json) {
  return TransactionData(
    paymentMethodsUsed: json['paymentMethodsUsed'] as List<dynamic>,
    transactionIds: json['transactionIds'] as List<dynamic>,
    totalBorrowed: json['totalBorrowed'] as int,
    totalLent: json['totalLent'] as int,
    hasActiveTransaction: json['hasActiveTransaction'] as int,
  );
}

Map<String, dynamic> _$TransactionDataToJson(TransactionData instance) =>
    <String, dynamic>{
      'paymentMethodsUsed': instance.paymentMethodsUsed,
      'transactionIds': instance.transactionIds,
      'totalBorrowed': instance.totalBorrowed,
      'totalLent': instance.totalLent,
      'hasActiveTransaction': instance.hasActiveTransaction,
    };
