// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_limit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionLimits _$TransactionLimitsFromJson(Map<String, dynamic> json) {
  return TransactionLimits(
    levelCounter: json['levelCounter'] ?? 0 as int,
    borrowLowerLimit: json['borrowLowerLimit'] ?? 0 as int,
    borrowUpperLimit: json['borrowUpperLimit'] ?? 2000 as int,
    transactionDefaultsAfterDays:
        json['transactionDefaultsAfterDays'] ?? 30 as int,
    keepTransactionActiveTillHours:
        json['keepTransactionActiveTillHours'] ?? 6 as int,
  );
}

Map<String, dynamic> _$TransactionLimitsToJson(TransactionLimits instance) =>
    <String, dynamic>{
      'borrowLowerLimit': instance.borrowLowerLimit,
      'borrowUpperLimit': instance.borrowUpperLimit,
      'transactionDefaultsAfterDays': instance.transactionDefaultsAfterDays,
      'keepTransactionActiveTillHours': instance.keepTransactionActiveTillHours,
      'levelCounter': instance.levelCounter,
    };
