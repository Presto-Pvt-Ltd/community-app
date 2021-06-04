enum PaymentMethods {
  googlePay,
  payTm,
  upi,
  creditCard,
  debitCard,
}

String paymentMethodsToString(PaymentMethods methods) {
  switch (methods) {
    case PaymentMethods.googlePay:
      return "GooglePay";
    case PaymentMethods.payTm:
      return "PayTm";
    case PaymentMethods.upi:
      return "upi";
    case PaymentMethods.creditCard:
      return "creditCard";
    case PaymentMethods.debitCard:
      return "debitCard";
  }
}
