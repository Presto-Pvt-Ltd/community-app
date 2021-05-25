import 'package:json_annotation/json_annotation.dart';

part 'notification_data_model.g.dart';

@JsonSerializable()
class NotificationToken {
  final String notificationToken;

  NotificationToken({required this.notificationToken});
  factory NotificationToken.fromJson(Map<String, dynamic> json) =>
      _$NotificationTokenDataFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationTokenDataToJson(this);
}
