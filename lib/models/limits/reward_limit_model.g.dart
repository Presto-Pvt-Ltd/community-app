// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reward_limit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RewardsLimit _$RewardsLimitFromJson(Map<String, dynamic> json) {
  return RewardsLimit(
    penaliseCreditScore: json['penaliseCreditScore'] as int,
    rewardCreditScore: json['rewardCreditScore'] as int,
    rewardPrestoCoins: json['rewardPrestoCoins'] as int,
  );
}

Map<String, dynamic> _$RewardsLimitToJson(RewardsLimit instance) =>
    <String, dynamic>{
      'penaliseCreditScore': instance.penaliseCreditScore,
      'rewardCreditScore': instance.rewardCreditScore,
      'rewardPrestoCoins': instance.rewardPrestoCoins,
    };
