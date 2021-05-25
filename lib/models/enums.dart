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
      return "googlePay";
    case PaymentMethods.payTm:
      return "payTm";
    case PaymentMethods.upi:
      return "upi";
    case PaymentMethods.creditCard:
      return "creditCard";
    case PaymentMethods.debitCard:
      return "debitCard";
  }
}
