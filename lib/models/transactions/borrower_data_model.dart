import 'package:json_annotation/json_annotation.dart';
part 'borrower_data_model.g.dart';

/// [borrowerSentMoneyAt] gives the Time stamp at which borrower paid back.
/// [borrowerReferralCode] is borrowers referral code.
@JsonSerializable()
class BorrowerInformation {
  final String borrowerReferralCode;
  final String borrowerName;
  final double borrowerCreditScore;
  BorrowerInformation({
    required this.borrowerReferralCode,
    required this.borrowerName,
    required this.borrowerCreditScore,
  });
  factory BorrowerInformation.fromJson(Map<String, dynamic> json) =>
      _$BorrowerInformationFromJson(json);
  Map<String, dynamic> toJson() => _$BorrowerInformationToJson(this);
}
