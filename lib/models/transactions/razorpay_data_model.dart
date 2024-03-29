import 'package:json_annotation/json_annotation.dart';
part 'razorpay_data_model.g.dart';

/// [lenderSentMoneyAt] gives the Time stamp at which borrower paid back.
/// [lenderReferralCode] is borrowers referral code.
@JsonSerializable()
class RazorpayInformation {
  bool sentMoneyToLender;
  bool sentMoneyToBorrower;
  String? borrowerRazorpayPaymentId;
  String? lenderRazorpayPaymentId;
  RazorpayInformation({
    required this.borrowerRazorpayPaymentId,
    required this.lenderRazorpayPaymentId,
    required this.sentMoneyToBorrower,
    required this.sentMoneyToLender,
  });
  factory RazorpayInformation.fromJson(Map<String, dynamic> json) =>
      _$RazorpayInformationFromJson(json);
  Map<String, dynamic> toJson() => _$RazorpayInformationToJson(this);
}
