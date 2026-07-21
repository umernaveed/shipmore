import 'package:json_annotation/json_annotation.dart';
import 'package:we_ship_faas/data/models/requests/send_referral_email_request/referral_item.dart';

part 'send_referral_email_request.g.dart';

@JsonSerializable(explicitToJson: true)
class SendReferralEmailRequest {
  final List<ReferralItem> referrals;

  const SendReferralEmailRequest({
    required this.referrals,
  });

  factory SendReferralEmailRequest.fromJson(Map<String, dynamic> json) =>
      _$SendReferralEmailRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SendReferralEmailRequestToJson(this);
}
