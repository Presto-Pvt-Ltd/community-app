// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_status_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionStatus _$TransactionStatusFromJson(Map<String, dynamic> json) {
  return TransactionStatus(
    approvedStatus: json['approvedStatus'] as bool,
    lenderSentMoney: json['lenderSentMoney'] as bool,
    borrowerSentMoney: json['borrowerSentMoney'] as bool,
    isBorrowerPenalised: json['isBorrowerPenalised'] as bool,
    isLenderPenalised: json['isLenderPenalised'] as bool,
    borrowerSentMoneyAt: json['borrowerSentMoneyAt'] == null
        ? null
        : DateTime.parse(json['borrowerSentMoneyAt'] as String),
    lenderSentMoneyAt: json['lenderSentMoneyAt'] == null
        ? null
        : DateTime.parse(json['lenderSentMoneyAt'] as String),
    emiPaid: json['emiPaid'] as int?,
    emiRazorpayIds:
        (json['emiRazorpayIds'] == null || json['emiRazorpayIds'].length == 0)
            ? null
            : (json['emiRazorpayIds'] as List<dynamic>)
                .map((e) => e.toString())
                .toList(),
  );
}

Map<String, dynamic> _$TransactionStatusToJson(TransactionStatus instance) =>
    <String, dynamic>{
      'approvedStatus': instance.approvedStatus,
      'lenderSentMoney': instance.lenderSentMoney,
      'borrowerSentMoney': instance.borrowerSentMoney,
      'isBorrowerPenalised': instance.isBorrowerPenalised,
      'isLenderPenalised': instance.isLenderPenalised,
      'borrowerSentMoneyAt': instance.borrowerSentMoneyAt?.toIso8601String(),
      'lenderSentMoneyAt': instance.lenderSentMoneyAt?.toIso8601String(),
      'emiPaid': instance.emiPaid,
      'emiRazorpayIds': instance.emiRazorpayIds,
    };
