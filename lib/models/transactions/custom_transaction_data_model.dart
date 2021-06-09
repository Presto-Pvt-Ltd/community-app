import 'package:json_annotation/json_annotation.dart';
import 'package:presto/models/transactions/borrower_data_model.dart';
import 'package:presto/models/transactions/generic_data_model.dart';
import 'package:presto/models/transactions/lender_data_model.dart';
import 'package:presto/models/transactions/razorpay_data_model.dart';
import 'package:presto/models/transactions/transaction_status_data_model.dart';
part 'custom_transaction_data_model.g.dart';

/// Contains all the information about a particular transaction.
@JsonSerializable()
class CustomTransaction {
  final GenericInformation genericInformation;
  final BorrowerInformation borrowerInformation;
  LenderInformation? lenderInformation;
  TransactionStatus transactionStatus;
  RazorpayInformation razorpayInformation;
  CustomTransaction({
    required this.genericInformation,
    required this.borrowerInformation,
    required this.transactionStatus,
    required this.razorpayInformation,
    this.lenderInformation,
  });

  factory CustomTransaction.fromJson(Map<String, dynamic> json) =>
      _$CustomTransactionFromJson(json);
  Map<String, dynamic> toJson() => _$CustomTransactionToJson(this);
}
