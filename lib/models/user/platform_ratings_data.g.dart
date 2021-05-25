// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platform_ratings_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlatformRatings _$PlatformRatingsFromJson(Map<String, dynamic> json) {
  return PlatformRatings(
    communityScore: (json['communityScore'] as num).toDouble(),
    personalScore: (json['personalScore'] as num).toDouble(),
    prestoCoins: (json['prestoCoins'] as num).toDouble(),
  );
}

Map<String, dynamic> _$PlatformRatingsToJson(PlatformRatings instance) =>
    <String, dynamic>{
      'communityScore': instance.communityScore,
      'personalScore': instance.personalScore,
      'prestoCoins': instance.prestoCoins,
    };
