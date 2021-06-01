import 'package:json_annotation/json_annotation.dart';
part 'lender_data_model.g.dart';

@JsonSerializable()
class LenderInformation {
  final DateTime? lenderSentMoneyAt;
  final String? lenderReferralCode;
  LenderInformation({
    this.lenderSentMoneyAt,
    required this.lenderReferralCode,
  });
  factory LenderInformation.fromJson(Map<String, dynamic> json) =>
      _$LenderInformationFromJson(json);
  Map<String, dynamic> toJson() => _$LenderInformationToJson(this);
}
