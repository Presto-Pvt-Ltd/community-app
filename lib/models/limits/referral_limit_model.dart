import 'package:json_annotation/json_annotation.dart';
part 'referral_limit_model.g.dart';

@JsonSerializable()
class ReferralLimit {
  final int refereeLimit;

  ReferralLimit({
    required this.refereeLimit,
  });
  factory ReferralLimit.fromJson(Map<String, dynamic> json) =>
      _$ReferralLimitFromJson(json);
  Map<String, dynamic> toJson() => _$ReferralLimitToJson(this);
}
