import 'package:presto/app/app.locator.dart';
import 'package:presto/app/app.logger.dart';
import 'package:presto/models/limits/referral_limit_model.dart';
import 'package:presto/models/limits/reward_limit_model.dart';
import 'package:presto/models/limits/share_text.dart';
import 'package:presto/models/limits/transaction_limit_model.dart';
import 'package:presto/services/database/dataHandlers/limitsDataHandler.dart';

class LimitsDataProvider {
  final log = getLogger("LimitsDataProvider");
  final LimitsDataHandler _limitsDataHandler = locator<LimitsDataHandler>();
  ReferralLimit? referralLimit;
  RewardsLimit? rewardsLimit;
  ShareText? shareText;
  TransactionLimits? transactionLimits;
}
