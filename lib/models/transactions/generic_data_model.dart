import 'package:json_annotation/json_annotation.dart';
import 'package:presto/models/enums.dart';
part 'generic_data_model.g.dart';

/// [transactionId] denotes the unique transaction ID.
/// [amount] denotes the amount of transaction in rupees.
/// [initiationAt] gives the time stamp of transaction initiation.
/// [completionAt] gives the time stamp of transaction completion.
/// [transactionMethodsRequestedByBorrower] gives us list of enum [PaymentMethods] requested by borrower.
/// [interestRate] denotes interest rate.
@JsonSerializable()
class GenericInformation {
  final String transactionId;
  final int amount;
  final DateTime initiationAt;
  final double interestRate;

  GenericInformation({
    required this.transactionId,
    required this.amount,
    required this.interestRate,
    required this.initiationAt,
  });
  factory GenericInformation.fromJson(Map<String, dynamic> json) =>
      _$GenericInformationFromJson(json);
  Map<String, dynamic> toJson() => _$GenericInformationToJson(this);
}
