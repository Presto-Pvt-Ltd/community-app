import 'package:json_annotation/json_annotation.dart';
part 'reward_limit_model.g.dart';

@JsonSerializable()
class RewardsLimit {
  final int penaliseCreditScore;
  final int rewardCreditScore;
  final int rewardPrestoCoins;

  RewardsLimit({
    required this.penaliseCreditScore,
    required this.rewardCreditScore,
    required this.rewardPrestoCoins,
  });
  factory RewardsLimit.fromJson(Map<String, dynamic> json) =>
      _$RewardsLimitFromJson(json);
  Map<String, dynamic> toJson() => _$RewardsLimitToJson(this);
}
