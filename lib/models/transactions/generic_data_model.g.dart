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
    amount: json['amount'] as String,
    transactionMethods: json['transactionMethods'] as List<dynamic>,
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
      'transactionMethods': instance.transactionMethods,
      'interestRate': instance.interestRate,
    };
