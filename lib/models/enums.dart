enum PaymentMethods {
  googlePay,
  payTm,
  upi,
  creditCard,
  debitCard,
  paypal,
  phonePay,
  amazonPay,
  unKnown,
}

const Map<PaymentMethods, String> PaymentMethodsMap = {
  PaymentMethods.googlePay: 'googlePay',
  PaymentMethods.payTm: 'payTm',
  PaymentMethods.upi: 'upi',
  PaymentMethods.creditCard: 'creditCard',
  PaymentMethods.debitCard: 'debitCard',
  PaymentMethods.paypal: 'paypal',
  PaymentMethods.phonePay: 'phonePay',
  PaymentMethods.amazonPay: 'amazonPay',
};

PaymentMethods paymentEnumDecode(
  String? object,
) {
  print("\n\n");
  print(object);
  print(PaymentMethodsMap.keys.firstWhere(
    (element) => PaymentMethodsMap[element] == object,
    orElse: () => PaymentMethods.unKnown,
  ));
  print("\n\n");
  if (object == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${PaymentMethodsMap.values.join(', ')}',
    );
  }
  return PaymentMethodsMap.keys.firstWhere(
    (element) => PaymentMethodsMap[element] == object,
    orElse: () => PaymentMethods.unKnown,
  );
}
