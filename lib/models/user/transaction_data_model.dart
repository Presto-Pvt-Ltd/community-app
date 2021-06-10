import 'package:json_annotation/json_annotation.dart';

part 'transaction_data_model.g.dart';

// TODO: Cross check if this is done.
/// Remember when rebuilding this json
/// in the generated file for [paymentMethodsUsed]
/// rewrite : paymentMethodsUsed:  json['paymentMethodsUsed'] as Map<String,dynamic>
/// to : paymentMethodsUsed: Map<String, dynamic>.from(json['paymentMethodsUsed']),
@JsonSerializable()
class TransactionData {
  final Map<String, dynamic> paymentMethodsUsed;
  final List<String> transactionIds;
  int totalBorrowed;
  int totalLent;
  final List<String> activeTransactions;
  bool borrowingRequestInProcess;
  DateTime? lastBorrowingRequestPlacedAt;

  TransactionData({
    required this.paymentMethodsUsed,
    required this.transactionIds,
    required this.totalBorrowed,
    required this.totalLent,
    required this.activeTransactions,
    this.borrowingRequestInProcess = false,
    this.lastBorrowingRequestPlacedAt,
  });
  factory TransactionData.fromJson(Map<String, dynamic> json) =>
      _$TransactionDataFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionDataToJson(this);
}
