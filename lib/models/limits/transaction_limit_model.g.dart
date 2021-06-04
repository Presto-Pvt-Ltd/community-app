// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_limit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionLimits _$TransactionLimitsFromJson(Map<String, dynamic> json) {
  return TransactionLimits(
    borrowLowerLimit: json['borrowLowerLimit'] as int,
    borrowUpperLimit: json['borrowUpperLimit'] as int,
    keepTransactionActiveForMinutes:
        json['keepTransactionActiveForMinutes'] as int,
    transactionDefaultsAfterDays: json['transactionDefaultsAfterDays'] as int,
    keepTransactionActiveForHours: json['keepTransactionActiveForHours'] as int,
    levelCounter: json['levelCounter'] as int,
    downCounter: json['downCounter'] as int,
  );
}

Map<String, dynamic> _$TransactionLimitsToJson(TransactionLimits instance) =>
    <String, dynamic>{
      'borrowLowerLimit': instance.borrowLowerLimit,
      'borrowUpperLimit': instance.borrowUpperLimit,
      'transactionDefaultsAfterDays': instance.transactionDefaultsAfterDays,
      'keepTransactionActiveForHours': instance.keepTransactionActiveForHours,
      'levelCounter': instance.levelCounter,
      'downCounter': instance.downCounter,
      'keepTransactionActiveForMinutes':
          instance.keepTransactionActiveForMinutes,
    };
