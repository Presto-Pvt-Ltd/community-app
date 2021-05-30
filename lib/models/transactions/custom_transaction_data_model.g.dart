// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_transaction_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomTransaction _$CustomTransactionFromJson(Map<String, dynamic> json) {
  return CustomTransaction(
    genericInformation: GenericInformation.fromJson(
        json['genericInformation'] as Map<String, dynamic>),
    borrowerInformation: BorrowerInformation.fromJson(
        json['borrowerInformation'] as Map<String, dynamic>),
    transactionStatus: TransactionStatus.fromJson(
        json['transactionStatus'] as Map<String, dynamic>),
    lenderInformation: json['lenderInformation'] == null
        ? null
        : LenderInformation.fromJson(
            json['lenderInformation'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$CustomTransactionToJson(CustomTransaction instance) =>
    <String, dynamic>{
      'genericInformation': instance.genericInformation,
      'borrowerInformation': instance.borrowerInformation,
      'lenderInformation': instance.lenderInformation,
      'transactionStatus': instance.transactionStatus,
    };
