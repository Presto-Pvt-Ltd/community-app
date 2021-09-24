import 'package:json_annotation/json_annotation.dart';
part 'transaction_status_data_model.g.dart';

/// [TransactionStatus] represents state of transaction.
/// [approvedStatus] is [true] if handshake is done.
/// [lenderSentMoney] is [true] if lender has sent money.
/// [borrowerSentMoney] is [true] if borrower has sent money.
/// [isBorrowerPenalised] is [true] if borrower has defaulted and penalised.
/// [isLenderPenalised] is [true] if lender has defaulted and penalised.
@JsonSerializable()
class TransactionStatus {
  bool approvedStatus;
  bool lenderSentMoney;
  bool borrowerSentMoney;
  bool isBorrowerPenalised;
  bool isLenderPenalised;
  int? emiPaid;
  DateTime? borrowerSentMoneyAt;
  DateTime? lenderSentMoneyAt;
  List<String>? emiRazorpayIds;
  TransactionStatus({
    required this.approvedStatus,
    required this.lenderSentMoney,
    required this.borrowerSentMoney,
    required this.isBorrowerPenalised,
    required this.isLenderPenalised,
    required this.borrowerSentMoneyAt,
    required this.lenderSentMoneyAt,
    this.emiPaid,
    this.emiRazorpayIds,
  });
  factory TransactionStatus.fromJson(Map<String, dynamic> json) =>
      _$TransactionStatusFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionStatusToJson(this);
}
