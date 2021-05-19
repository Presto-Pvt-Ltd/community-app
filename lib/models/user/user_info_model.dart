import 'package:json_annotation/json_annotation.dart';

part 'user_info_model.g.dart';

@JsonSerializable()
class CustomUser {
  /// Personal information about user
  final String firstName;
  final String lastName;
  final String contact;
  final String deviceId;

  /// Identity Verification bools
  final bool emailVerified;
  final bool contactVerified;

  /// User preference
  final Map<String, dynamic> paymentMethodsFrequency;

  /// Platform specific information
  /// User's unique ID
  final String referralCode;

  /// Parent's unique ID
  final String referredBy;

  /// Children's unique ID
  List<dynamic> referredTo;

  /// Net amount [borrowed] and [lent] by user through app
  int borrowed;
  int lent;

  CustomUser({
    required this.firstName,
    required this.lastName,
    required this.contact,
    required this.deviceId,
    required this.contactVerified,
    required this.paymentMethodsFrequency,
    required this.referralCode,
    required this.referredBy,
    this.emailVerified = false,
    this.lent = 0,
    this.borrowed = 0,
    this.referredTo = const [],
  });
  factory CustomUser.fromJson(Map<String, dynamic> json) =>
      _$CustomUserFromJson(json);
  Map<String, dynamic> toJson() => _$CustomUserToJson(this);
}
