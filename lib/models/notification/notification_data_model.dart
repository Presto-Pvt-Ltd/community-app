import 'package:json_annotation/json_annotation.dart';
import 'package:presto/models/enums.dart';
part 'notification_data_model.g.dart';

@JsonSerializable()
class CustomNotification {
  final String borrowerReferralCode;
  final List<String> lendersReferralCodes;
  final String transactionId;
  final int amount;
  final double borrowerRating;
  final List<PaymentMethods> paymentMethods;

  CustomNotification({
    required this.borrowerRating,
    required this.lendersReferralCodes,
    required this.amount,
    required this.transactionId,
    required this.paymentMethods,
    required this.borrowerReferralCode,
  });
  factory CustomNotification.fromJson(Map<String, dynamic> json) =>
      _$CustomNotificationFromJson(json);
  Map<String, dynamic> toJson() => _$CustomNotificationToJson(this);
}
