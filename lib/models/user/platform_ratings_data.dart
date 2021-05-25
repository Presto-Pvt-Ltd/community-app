import 'package:json_annotation/json_annotation.dart';
part 'platform_ratings_data.g.dart';

@JsonSerializable()
class PlatformRatings {
  final double communityScore;
  final double personalScore;
  final double prestoCoins;
  PlatformRatings({
    required this.communityScore,
    required this.personalScore,
    required this.prestoCoins,
  });
  factory PlatformRatings.fromJson(Map<String, dynamic> json) =>
      _$PlatformRatingsFromJson(json);
  Map<String, dynamic> toJson() => _$PlatformRatingsToJson(this);
}
