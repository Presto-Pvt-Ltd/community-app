import 'package:json_annotation/json_annotation.dart';
import 'package:presto/models/enums.dart';
part 'generic_data_model.g.dart';

@JsonSerializable()
class GenericInformation {
  final String transactionId;
  final int amount;
  final DateTime initiationAt;
  final DateTime? completionAt;
  final List<PaymentMethods> transactionMethods;
  final double interestRate;

  GenericInformation({
    required this.transactionId,
    required this.amount,
    required this.transactionMethods,
    required this.interestRate,
    required this.initiationAt,
    this.completionAt,
  });
  factory GenericInformation.fromJson(Map<String, dynamic> json) =>
      _$GenericInformationFromJson(json);
  Map<String, dynamic> toJson() => _$GenericInformationToJson(this);
}
