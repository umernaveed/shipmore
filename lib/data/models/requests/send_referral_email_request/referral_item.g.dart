// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'referral_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReferralItem _$ReferralItemFromJson(Map<String, dynamic> json) => ReferralItem(
      name: json['name'] as String,
      email: json['email'] as String,
      message: json['message'] as String,
    );

Map<String, dynamic> _$ReferralItemToJson(ReferralItem instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'message': instance.message,
    };
