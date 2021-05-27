import 'package:json_annotation/json_annotation.dart';
part 'reward_limit_model.g.dart';

@JsonSerializable()
class RewardsLimit {
  final double penaliseCreditScore;
  final double rewardCreditScore;
  final double rewardPrestoCoins;

  RewardsLimit({
    required this.penaliseCreditScore,
    required this.rewardCreditScore,
    required this.rewardPrestoCoins,
  });
  factory RewardsLimit.fromJson(Map<String, dynamic> json) =>
      _$RewardsLimitFromJson(json);
  Map<String, dynamic> toJson() => _$RewardsLimitToJson(this);
}
