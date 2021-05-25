// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_status_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionStatus _$TransactionStatusFromJson(Map<String, dynamic> json) {
  return TransactionStatus(
    approvedStatus: json['approvedStatus'] as bool,
    lenderSentMoney: json['lenderSentMoney'] as bool,
    lenderRecievedMoney: json['lenderRecievedMoney'] as bool,
    borrowerSentMoney: json['borrowerSentMoney'] as bool,
    borrowerRecievedMoney: json['borrowerRecievedMoney'] as bool,
    isBorrowerPenalised: json['isBorrowerPenalised'] as bool,
    isLenderPenalised: json['isLenderPenalised'] as bool,
  );
}

Map<String, dynamic> _$TransactionStatusToJson(TransactionStatus instance) =>
    <String, dynamic>{
      'approvedStatus': instance.approvedStatus,
      'lenderSentMoney': instance.lenderSentMoney,
      'lenderRecievedMoney': instance.lenderRecievedMoney,
      'borrowerSentMoney': instance.borrowerSentMoney,
      'borrowerRecievedMoney': instance.borrowerRecievedMoney,
      'isBorrowerPenalised': instance.isBorrowerPenalised,
      'isLenderPenalised': instance.isLenderPenalised,
    };
