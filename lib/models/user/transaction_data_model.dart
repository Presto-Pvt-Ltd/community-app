import 'package:json_annotation/json_annotation.dart';
import 'package:presto/models/enums.dart';
part 'transaction_data_model.g.dart';

@JsonSerializable()
class TransactionData {
  final List<PaymentMethods> paymentMethodsUsed;
  final List<String> transactionIds;
  final int totalBorrowed;
  final int totalLent;
  final int hasActiveTransaction;

  TransactionData({
    required this.paymentMethodsUsed,
    required this.transactionIds,
    required this.totalBorrowed,
    required this.totalLent,
    required this.hasActiveTransaction,
  });
  factory TransactionData.fromJson(Map<String, dynamic> json) =>
      _$TransactionDataFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionDataToJson(this);
}
