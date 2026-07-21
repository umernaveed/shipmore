import 'package:json_annotation/json_annotation.dart';

part 'referral_item.g.dart';

@JsonSerializable()
class ReferralItem {
  final String name;
  final String email;
  final String message;

  const ReferralItem({
    required this.name,
    required this.email,
    required this.message,
  });

  factory ReferralItem.fromJson(Map<String, dynamic> json) =>
      _$ReferralItemFromJson(json);

  Map<String, dynamic> toJson() => _$ReferralItemToJson(this);
}
