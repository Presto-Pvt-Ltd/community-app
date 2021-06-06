// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reward_limit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RewardsLimit _$RewardsLimitFromJson(Map<String, dynamic> json) {
  return RewardsLimit(
    penaliseCreditScore: (json['penaliseCreditScore'] as num).toDouble(),
    rewardCreditScore: (json['rewardCreditScore'] as num).toDouble(),
    rewardPrestoCoinsPercent:
        (json['rewardPrestoCoinsPercent'] as num).toDouble(),
  );
}

Map<String, dynamic> _$RewardsLimitToJson(RewardsLimit instance) =>
    <String, dynamic>{
      'penaliseCreditScore': instance.penaliseCreditScore,
      'rewardCreditScore': instance.rewardCreditScore,
      'rewardPrestoCoinsPercent': instance.rewardPrestoCoinsPercent,
    };
