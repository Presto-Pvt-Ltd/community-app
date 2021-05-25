import 'package:json_annotation/json_annotation.dart';
part 'borrower_data_model.g.dart';

@JsonSerializable()
class BorrowerInformation {
  final int borrowerSentMoneyHour;
  final int borrowerSentMoneyDay;
  final int borrowerSentMoneyMonth;
  final int borrowerSentMoneyYear;
  final String borrowerReferralCode;
  BorrowerInformation({
    required this.borrowerSentMoneyDay,
    required this.borrowerSentMoneyHour,
    required this.borrowerSentMoneyMonth,
    required this.borrowerSentMoneyYear,
    required this.borrowerReferralCode,
  });
  factory BorrowerInformation.fromJson(Map<String, dynamic> json) =>
      _$BorrowerInformationFromJson(json);
  Map<String, dynamic> toJson() => _$BorrowerInformationToJson(this);
}
