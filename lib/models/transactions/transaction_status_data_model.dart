import 'package:json_annotation/json_annotation.dart';
part 'transaction_status_data_model.g.dart';

@JsonSerializable()
class TransactionStatus {
  final bool approvedStatus;
  final bool lenderSentMoney;
  final bool lenderReceivedMoney;
  final bool borrowerSentMoney;
  final bool borrowerReceivedMoney;
  final bool isBorrowerPenalised;
  final bool isLenderPenalised;

  TransactionStatus({
    required this.approvedStatus,
    required this.lenderSentMoney,
    required this.lenderReceivedMoney,
    required this.borrowerSentMoney,
    required this.borrowerReceivedMoney,
    required this.isBorrowerPenalised,
    required this.isLenderPenalised,
  });
  factory TransactionStatus.fromJson(Map<String, dynamic> json) =>
      _$TransactionStatusFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionStatusToJson(this);
}
