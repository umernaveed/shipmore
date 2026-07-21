import 'package:json_annotation/json_annotation.dart';

part 'send_referral_email_response.g.dart';

@JsonSerializable()
class SendReferralEmailResponse {
  final bool? success;

  const SendReferralEmailResponse({this.success});

  factory SendReferralEmailResponse.fromJson(Map<String, dynamic> json) =>
      _$SendReferralEmailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SendReferralEmailResponseToJson(this);
}
