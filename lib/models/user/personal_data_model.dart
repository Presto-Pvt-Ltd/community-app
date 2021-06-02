import 'package:json_annotation/json_annotation.dart';
part 'personal_data_model.g.dart';

@JsonSerializable()
class PersonalData {
  /// Personal information about user
  final String name;
  final String email;
  final String contact;
  final String password;
  final String deviceId;
  final String referralId;

  PersonalData({
    required this.name,
    required this.email,
    required this.contact,
    required this.password,
    required this.deviceId,
    required this.referralId,
  });

  factory PersonalData.fromJson(Map<String, dynamic> json) =>
      _$PersonalDataFromJson(json);
  Map<String, dynamic> toJson() => _$PersonalDataToJson(this);
}
