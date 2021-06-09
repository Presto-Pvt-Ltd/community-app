import 'package:json_annotation/json_annotation.dart';
import 'package:presto/models/enums.dart';
part 'lender_data_model.g.dart';

/// [lenderSentMoneyAt] gives the Time stamp at which borrower paid back.
/// [lenderReferralCode] is borrowers referral code.
@JsonSerializable()
class LenderInformation {
  String? lenderReferralCode;
  String? lenderName;
  List<PaymentMethods>? requestedPaybackMethods;
  LenderInformation({
    required this.lenderReferralCode,
    required this.lenderName,
    required this.requestedPaybackMethods,
  });
  factory LenderInformation.fromJson(Map<String, dynamic> json) =>
      _$LenderInformationFromJson(json);
  Map<String, dynamic> toJson() => _$LenderInformationToJson(this);
}
