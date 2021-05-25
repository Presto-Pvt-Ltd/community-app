import 'package:json_annotation/json_annotation.dart';
import 'package:presto/models/enums.dart';
part 'generic_data_model.g.dart';

@JsonSerializable()
class GenericInformation {
  final String transactionId;
  final int initiationHour;
  final int initiationDay;
  final int initiationMonth;
  final int initiationYear;
  final int completionHour;
  final int completionDay;
  final int completionMonth;
  final int completionYear;
  final int amount;
  final List<PaymentMethods> transactionMethods;
  final double interestRate;

  GenericInformation({
    required this.transactionId,
    required this.initiationHour,
    required this.initiationDay,
    required this.initiationMonth,
    required this.initiationYear,
    required this.completionDay,
    required this.completionHour,
    required this.completionMonth,
    required this.completionYear,
    required this.amount,
    required this.transactionMethods,
    required this.interestRate,
  });
  factory GenericInformation.fromJson(Map<String, dynamic> json) =>
      _$GenericInformationFromJson(json);
  Map<String, dynamic> toJson() => _$GenericInformationToJson(this);
}
