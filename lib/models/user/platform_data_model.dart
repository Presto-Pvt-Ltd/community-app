import 'package:json_annotation/json_annotation.dart';
part 'platform_data_model.g.dart';

@JsonSerializable()
class PlatformData {
  final String referralCode;
  final String referredBy;
  final List<dynamic> referredTo;

  PlatformData({
    required this.referralCode,
    required this.referredBy,
    required this.referredTo,
  });
  factory PlatformData.fromJson(Map<String, dynamic> json) =>
      _$PlatformDataFromJson(json);
  Map<String, dynamic> toJson() => _$PlatformDataToJson(this);
}
