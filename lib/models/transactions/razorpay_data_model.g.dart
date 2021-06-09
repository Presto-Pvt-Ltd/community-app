// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'razorpay_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RazorpayInformation _$RazorpayInformationFromJson(Map<String, dynamic> json) {
  return RazorpayInformation(
    sentMoneyToBorrower: json['sentMoneyToBorrower'] as bool,
    sentMoneyToLender: json['sentMoneyToLender'] as bool,
    borrowerRazorpayPaymentId: json['borrowerRazorpayPaymentId'] as String?,
    lenderRazorpayPaymentId: json['lenderRazorpayPaymentId'] as String?,
  );
}

Map<String, dynamic> _$RazorpayInformationToJson(
        RazorpayInformation instance) =>
    <String, dynamic>{
      'sentMoneyToBorrower': instance.sentMoneyToBorrower,
      'sentMoneyToLender': instance.sentMoneyToLender,
      'borrowerRazorpayPaymentId': instance.borrowerRazorpayPaymentId,
      'lenderRazorpayPaymentId': instance.lenderRazorpayPaymentId,
    };
