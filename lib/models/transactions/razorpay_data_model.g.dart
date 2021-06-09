// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'razorpay_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RazorpayInformation _$RazorpayInformationFromJson(Map<String, dynamic> json) {
  return RazorpayInformation(
    sentMoneyToBorrower: json['sentMoneyToBorrower'] as bool,
    sentMoneyToLender: json['sentMoneyToLender'] as bool,
    borrowerTransactionIdFromRazorpay:
        json['borrowerTransactionIdFromRazorpay'] as String?,
    lenderTransactionIdFromRazorpay:
        json['lenderTransactionIdFromRazorpay'] as String?,
  );
}

Map<String, dynamic> _$RazorpayInformationToJson(
        RazorpayInformation instance) =>
    <String, dynamic>{
      'sentMoneyToBorrower': instance.sentMoneyToBorrower,
      'sentMoneyToLender': instance.sentMoneyToLender,
      'borrowerTransactionIdFromRazorpay':
          instance.borrowerTransactionIdFromRazorpay,
      'lenderTransactionIdFromRazorpay':
          instance.lenderTransactionIdFromRazorpay,
    };
