import 'package:json_annotation/json_annotation.dart';
import 'package:presto/models/enums.dart';
part 'transaction_data_model.g.dart';

/// TODO: Cross check if this is done.
/// Remember when rebuilding this json
/// in the generated file for [paymentMethodsUsed]
/// rewrite : paymentMethodsUsed:  json['paymentMethodsUsed'] as Map<String,dynamic>
/// to : paymentMethodsUsed: Map<String, dynamic>.from(json['paymentMethodsUsed']),
class TransactionData {
  final Map<String, dynamic> paymentMethodsUsed;
  final List<String> transactionIds;
  final int totalBorrowed;
  final int totalLent;
  final List<String> activeTransactions;

  TransactionData({
    required this.paymentMethodsUsed,
    required this.transactionIds,
    required this.totalBorrowed,
    required this.totalLent,
    required this.activeTransactions,
  });
  factory TransactionData.fromJson(Map<String, dynamic> json) =>
      _$TransactionDataFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionDataToJson(this);
}
