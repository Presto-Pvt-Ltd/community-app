import 'package:json_annotation/json_annotation.dart';
part 'borrower_data_model.g.dart';

@JsonSerializable()
class BorrowerInformation {
  final int borrowerSentMoneyHour;
  final DateTime? borrowerSentMoneyAt;
  final String borrowerReferralCode;
  BorrowerInformation({
    required this.borrowerSentMoneyHour,
    this.borrowerSentMoneyAt,
    required this.borrowerReferralCode,
  });
  factory BorrowerInformation.fromJson(Map<String, dynamic> json) =>
      _$BorrowerInformationFromJson(json);
  Map<String, dynamic> toJson() => _$BorrowerInformationToJson(this);
}
