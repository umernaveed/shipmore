// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_referral_email_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendReferralEmailRequest _$SendReferralEmailRequestFromJson(
        Map<String, dynamic> json) =>
    SendReferralEmailRequest(
      referrals: (json['referrals'] as List<dynamic>)
          .map((e) => ReferralItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SendReferralEmailRequestToJson(
        SendReferralEmailRequest instance) =>
    <String, dynamic>{
      'referrals': instance.referrals.map((e) => e.toJson()).toList(),
    };
