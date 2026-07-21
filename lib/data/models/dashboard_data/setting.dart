import 'package:json_annotation/json_annotation.dart';

part 'setting.g.dart';

@JsonSerializable()
class Setting {
  final int id;
  @JsonKey(name: 'site_name', defaultValue: '')
  final String siteName;
  @JsonKey(name: 'pre_fix', defaultValue: '')
  final String preFix;
  @JsonKey(name: 'company_name', defaultValue: '')
  final String companyName;
  @JsonKey(name: 'site_email', defaultValue: '')
  final String siteEmail;
  @JsonKey(name: 'administrator_email', defaultValue: '')
  final String administratorEmail;
  @JsonKey(name: 'site_logo', defaultValue: '')
  final String siteLogo;
  @JsonKey(name: 'from_email', defaultValue: '')
  final String fromEmail;
  @JsonKey(name: 'site_title', defaultValue: '')
  final String siteTitle;
  @JsonKey(name: 'phone', defaultValue: '')
  final String phone;
  @JsonKey(name: 'site_footer_text', defaultValue: '')
  final String siteFooterText;
  @JsonKey(name: 'package_shipping_address_1', defaultValue: '')
  final String packageShippingAddress1;
  @JsonKey(name: 'package_shipping_address_2', defaultValue: '')
  final String packageShippingAddress2;
  @JsonKey(name: 'sea_shipping_address_1', defaultValue: '')
  final String seaShippingAddress1;
  @JsonKey(name: 'city', defaultValue: '')
  final String city;
  @JsonKey(name: 'state', defaultValue: '')
  final String state;
  @JsonKey(name: 'zip', defaultValue: '')
  final String zip;
  @JsonKey(name: 'country', defaultValue: '')
  final String country;
  @JsonKey(name: 'local_address', defaultValue: '')
  final String localAddress;
  @JsonKey(name: 'sea_shipping_address_2', defaultValue: '')
  final String seaShippingAddress2;
  @JsonKey(name: 'sea_city', defaultValue: '')
  final String seaCity;
  @JsonKey(name: 'sea_state', defaultValue: '')
  final String seaState;
  @JsonKey(name: 'sea_zip', defaultValue: '')
  final String seaZip;
  @JsonKey(name: 'sea_country', defaultValue: '')
  final String seaCountry;
  @JsonKey(name: 'sea_local_address', defaultValue: '')
  final String seaLocalAddress;
  @JsonKey(name: 'us_rate', defaultValue: '0')
  final String usRate;
  @JsonKey(name: 'discount', defaultValue: '')
  final String discount;
  @JsonKey(name: 'reward_points', defaultValue: -1)
  final int rewardPoints;
  @JsonKey(name: 'api_token', defaultValue: '')
  final String apiToken;

  /// new
  @JsonKey(name: 'base_url', defaultValue: '')
  final String baseUrl;
  @JsonKey(name: 'app_logo', defaultValue: '')
  final String appLogo;
  @JsonKey(name: 'text_color', defaultValue: '')
  final String textColor;
  @JsonKey(name: 'btn_color', defaultValue: '')
  final String btnColor;
  @JsonKey(name: 'reffral_weight', defaultValue: '')
  final dynamic reffralWeight;
  @JsonKey(name: 'reffral_packages', defaultValue: '')
  final String reffralPackages;
  @JsonKey(name: 'reffral_use_duration', defaultValue: '')
  final String reffralUseDuration;
  @JsonKey(name: 'referral_amount', defaultValue: 0)
  final num referralAmount;
  @JsonKey(name: 'reward_weight', defaultValue: 0)
  final num rewardWeight;
  @JsonKey(name: 'reward_packages', defaultValue: "0")
  final String rewardPackages;
  @JsonKey(name: 'reward_use_duration', defaultValue: "0")
  final String rewardUseDuration;
  @JsonKey(name: 'reward_amount', defaultValue: "0")
  final String rewardAmount;

  const Setting(
      {required this.id,
      required this.siteName,
      required this.preFix,
      required this.companyName,
      required this.siteEmail,
      required this.administratorEmail,
      required this.siteLogo,
      required this.fromEmail,
      required this.siteTitle,
      required this.phone,
      required this.siteFooterText,
      required this.packageShippingAddress1,
      required this.packageShippingAddress2,
      required this.seaShippingAddress1,
      required this.city,
      required this.state,
      required this.zip,
      required this.country,
      required this.localAddress,
      required this.seaShippingAddress2,
      required this.seaCity,
      required this.seaState,
      required this.seaZip,
      required this.seaCountry,
      required this.seaLocalAddress,
      required this.usRate,
      required this.discount,
      required this.rewardPoints,
      required this.apiToken,
      required this.baseUrl,
      required this.appLogo,
      required this.textColor,
      required this.btnColor,
      required this.reffralWeight,
      required this.reffralPackages,
      required this.reffralUseDuration,
      required this.referralAmount,
      required this.rewardWeight,
      required this.rewardPackages,
      required this.rewardUseDuration,
      required this.rewardAmount});

  factory Setting.defaultValues() {
    return const Setting(
      id: -1,
      administratorEmail: '',
      apiToken: '',
      city: '',
      companyName: '',
      country: '',
      discount: '',
      fromEmail: '',
      localAddress: '',
      packageShippingAddress1: '',
      packageShippingAddress2: '',
      phone: '',
      preFix: '',
      seaCity: '',
      seaCountry: '',
      seaLocalAddress: '',
      seaState: '',
      seaShippingAddress1: '',
      seaShippingAddress2: '',
      seaZip: '',
      siteEmail: '',
      siteFooterText: '',
      siteLogo: '',
      siteName: '',
      siteTitle: '',
      state: '',
      usRate: '',
      zip: '',
      rewardPoints: 0,
      baseUrl: '',
      appLogo: '',
      textColor: '',
      btnColor: '',
      reffralWeight: '',
      reffralPackages: '',
      reffralUseDuration: '',
      referralAmount: 0,
      rewardWeight: 0,
      rewardPackages: '',
      rewardUseDuration: '',
      rewardAmount: '',
    );
  }

  factory Setting.fromJson(Map<String, dynamic> json) {
    String stringValue(String key, [String fallback = '']) {
      final value = json[key];
      return value == null ? fallback : value.toString();
    }

    int intValue(String key, [int fallback = 0]) {
      final value = json[key];
      if (value is num) return value.toInt();
      return num.tryParse(value?.toString() ?? '')?.toInt() ?? fallback;
    }

    num numValue(String key, [num fallback = 0]) {
      final value = json[key];
      if (value is num) return value;
      return num.tryParse(value?.toString() ?? '') ?? fallback;
    }

    return Setting(
      id: intValue('id', -1),
      siteName: stringValue('site_name'),
      preFix: stringValue('pre_fix'),
      companyName: stringValue('company_name'),
      siteEmail: stringValue('site_email'),
      administratorEmail: stringValue('administrator_email'),
      siteLogo: stringValue('site_logo'),
      fromEmail: stringValue('from_email'),
      siteTitle: stringValue('site_title'),
      phone: stringValue('phone'),
      siteFooterText: stringValue('site_footer_text'),
      packageShippingAddress1: stringValue('package_shipping_address_1'),
      packageShippingAddress2: stringValue('package_shipping_address_2'),
      seaShippingAddress1: stringValue('sea_shipping_address_1'),
      city: stringValue('city'),
      state: stringValue('state'),
      zip: stringValue('zip'),
      country: stringValue('country'),
      localAddress: stringValue('local_address'),
      seaShippingAddress2: stringValue('sea_shipping_address_2'),
      seaCity: stringValue('sea_city'),
      seaState: stringValue('sea_state'),
      seaZip: stringValue('sea_zip'),
      seaCountry: stringValue('sea_country'),
      seaLocalAddress: stringValue('sea_local_address'),
      usRate: stringValue('us_rate', '0'),
      discount: stringValue('discount'),
      rewardPoints: intValue('reward_points'),
      apiToken: stringValue('api_token'),
      baseUrl: stringValue('base_url'),
      appLogo: stringValue('app_logo'),
      textColor: stringValue('text_color'),
      btnColor: stringValue('btn_color'),
      reffralWeight: json['reffral_weight'] ?? '',
      reffralPackages: stringValue('reffral_packages'),
      reffralUseDuration: stringValue('reffral_use_duration'),
      referralAmount: numValue('referral_amount'),
      rewardWeight: numValue('reward_weight'),
      rewardPackages: stringValue('reward_packages', '0'),
      rewardUseDuration: stringValue('reward_use_duration', '0'),
      rewardAmount: stringValue('reward_amount', '0'),
    );
  }

  Map<String, dynamic> toJson() => _$SettingToJson(this);
}
