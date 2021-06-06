import 'package:json_annotation/json_annotation.dart';
part 'reward_limit_model.g.dart';

/// [RewardsLimit] denotes the rewards and penalties one might face.
/// [penaliseCreditScore] denotes the penalty in Credit Score for a default by borrower.
/// [rewardCreditScore] denotes the reward in Credit Score for completion of a transaction by borrower.
/// [rewardPrestoCoinsPercent] denotes the reward in Presto Coins to lender for lending money.
@JsonSerializable()
class RewardsLimit {
  final double penaliseCreditScore;
  final double rewardCreditScore;
  final double rewardPrestoCoinsPercent;

  RewardsLimit({
    required this.penaliseCreditScore,
    required this.rewardCreditScore,
    required this.rewardPrestoCoinsPercent,
  });
  factory RewardsLimit.fromJson(Map<String, dynamic> json) =>
      _$RewardsLimitFromJson(json);
  Map<String, dynamic> toJson() => _$RewardsLimitToJson(this);
}
