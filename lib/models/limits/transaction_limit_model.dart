import 'package:json_annotation/json_annotation.dart';
part 'transaction_limit_model.g.dart';

@JsonSerializable()
class TransactionLimits {
  final int borrowLowerLimit;
  final int borrowUpperLimit;
  final int transactionDefaultsAfterDays;
  final int keepTransactionActiveTillHours;
  final int levelCounter;
  final int downCounter;

  TransactionLimits({
    required this.borrowLowerLimit,
    required this.borrowUpperLimit,
    required this.transactionDefaultsAfterDays,
    required this.keepTransactionActiveTillHours,
    required this.levelCounter,
    required this.downCounter,
  });
  factory TransactionLimits.fromJson(Map<String, dynamic> json) =>
      _$TransactionLimitsFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionLimitsToJson(this);
}
