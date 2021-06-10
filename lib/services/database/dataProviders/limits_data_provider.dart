import 'package:presto/app/app.logger.dart';
import 'package:presto/models/limits/referral_limit_model.dart';
import 'package:presto/models/limits/reward_limit_model.dart';
import 'package:presto/models/limits/share_text.dart';
import 'package:presto/models/limits/transaction_limit_model.dart';

class LimitsDataProvider {
  final log = getLogger("LimitsDataProvider");
  ReferralLimit? referralLimit;
  RewardsLimit? rewardsLimit;
  ShareText? shareText;
  TransactionLimits? transactionLimits;
}
