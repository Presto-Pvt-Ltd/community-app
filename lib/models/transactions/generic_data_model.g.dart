// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generic_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenericInformation _$GenericInformationFromJson(Map<String, dynamic> json) {
  return GenericInformation(
    transactionId: json['transactionId'] as String,
    amount: json['amount'] as int,
    interestRate: (json['interestRate'] as num).toDouble(),
    initiationAt: DateTime.parse(json['initiationAt'] as String),
  );
}

Map<String, dynamic> _$GenericInformationToJson(GenericInformation instance) =>
    <String, dynamic>{
      'transactionId': instance.transactionId,
      'amount': instance.amount,
      'initiationAt': instance.initiationAt.toIso8601String(),
      'interestRate': instance.interestRate,
    };
