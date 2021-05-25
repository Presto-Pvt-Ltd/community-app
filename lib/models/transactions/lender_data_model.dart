import 'package:json_annotation/json_annotation.dart';
part 'lender_data_model.g.dart';

@JsonSerializable()
class LenderInformation {
  final int lenderSentMoneyHour;
  final int lenderSentMoneyDay;
  final int lenderSentMoneyMonth;
  final int lenderSentMoneyYear;
  final String lenderReferralCode;
  LenderInformation({
    required this.lenderSentMoneyDay,
    required this.lenderSentMoneyHour,
    required this.lenderSentMoneyMonth,
    required this.lenderSentMoneyYear,
    required this.lenderReferralCode,
  });
  factory LenderInformation.fromJson(Map<String, dynamic> json) =>
      _$LenderInformationFromJson(json);
  Map<String, dynamic> toJson() => _$LenderInformationToJson(this);
}
