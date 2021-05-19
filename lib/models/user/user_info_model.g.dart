// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomUser _$CustomUserFromJson(Map<String, dynamic> json) {
  return CustomUser(
    firstName: json['firstName'] as String,
    lastName: json['lastName'] as String,
    contact: json['contact'] as String,
    deviceId: json['deviceId'] as String,
    contactVerified: json['contactVerified'] as bool,
    paymentMethodsFrequency:
        json['paymentMethodsFrequency'] as Map<String, dynamic>,
    referralCode: json['referralCode'] as String,
    referredBy: json['referredBy'] as String,
    emailVerified: json['emailVerified'] as bool,
    lent: json['lent'] as int,
    borrowed: json['borrowed'] as int,
    referredTo: json['referredTo'] as List<dynamic>,
  );
}

Map<String, dynamic> _$CustomUserToJson(CustomUser instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'contact': instance.contact,
      'deviceId': instance.deviceId,
      'emailVerified': instance.emailVerified,
      'contactVerified': instance.contactVerified,
      'paymentMethodsFrequency': instance.paymentMethodsFrequency,
      'referralCode': instance.referralCode,
      'referredBy': instance.referredBy,
      'referredTo': instance.referredTo,
      'borrowed': instance.borrowed,
      'lent': instance.lent,
    };
