import 'package:json_annotation/json_annotation.dart';
part 'transaction_limit_model.g.dart';

/// [TransactionLimits] contains all the limits on transaction.
/// [borrowLowerLimit] minimum amount which can be borrowed in rupees.
/// [borrowUpperLimit] maximum amount which can be borrowed in rupees.
/// [transactionDefaultsAfterDays] maximum time period in days offered to a borrower in order to payback.
/// [keepTransactionActiveForHours] maximum amount of time in hours for a transaction to wait for handshake.
/// [keepTransactionActiveForMinutes] maximum amount of time in hours for a transaction to wait for handshake.
/// [levelCounter] total number of levels to send notification request above the parent.
/// [downCounter] total number of levels to send notification request below the parent.
@JsonSerializable()
class TransactionLimits {
  final int borrowLowerLimit;
  final int borrowUpperLimit;
  final int transactionDefaultsAfterDays;
  final int keepTransactionActiveForHours;
  final int levelCounter;
  final int downCounter;
  final int keepTransactionActiveForMinutes;

  TransactionLimits({
    required this.borrowLowerLimit,
    required this.borrowUpperLimit,
    required this.keepTransactionActiveForMinutes,
    required this.transactionDefaultsAfterDays,
    required this.keepTransactionActiveForHours,
    required this.levelCounter,
    required this.downCounter,
  });
  factory TransactionLimits.fromJson(Map<String, dynamic> json) =>
      _$TransactionLimitsFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionLimitsToJson(this);
}
