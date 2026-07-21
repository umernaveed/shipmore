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
  @JsonKey(name: 'express_shipping_address_1', defaultValue: '')
  final String expressShippingAddress1;
  @JsonKey(name: 'express_shipping_address_2', defaultValue: '')
  final String expressShippingAddress2;
  @JsonKey(name: 'express_city', defaultValue: '')
  final String expressCity;
  @JsonKey(name: 'express_state', defaultValue: '')
  final String expressState;
  @JsonKey(name: 'express_zip', defaultValue: '')
  final String expressZip;
  @JsonKey(name: 'express_country', defaultValue: '')
  final String expressCountry;
  @JsonKey(name: 'express_local_address', defaultValue: '')
  final String expressLocalAddress;
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
  @JsonKey(name: 'us_rate', defaultValue: '')
  final String usRate;
  @JsonKey(name: 'discount', defaultValue: '')
  final String discount;
  @JsonKey(name: 'reward_points', defaultValue: -1)
  final int rewardPoints;
  @JsonKey(name: 'api_token', defaultValue: '')
  final String apiToken;

  const Setting({
    this.id = 0,
    this.siteName = "",
    this.preFix = "",
    this.companyName = "",
    this.siteEmail = "",
    this.administratorEmail = "",
    this.siteLogo = "",
    this.fromEmail = "",
    this.siteTitle = "",
    this.phone = "",
    this.siteFooterText = "",
    this.packageShippingAddress1 = "",
    this.packageShippingAddress2 = "",
    this.seaShippingAddress1 = "",
    this.city = "",
    this.state = "",
    this.zip = "",
    this.country = "",
    this.localAddress = "",
    this.seaShippingAddress2 = "",
    this.seaCity = "",
    this.seaState = "",
    this.seaZip = "",
    this.seaCountry = "",
    this.seaLocalAddress = "",
    this.usRate = "",
    this.discount = "",
    this.rewardPoints = 0,
    this.apiToken = "",
    this.expressShippingAddress1 = "",
    this.expressShippingAddress2 = "",
    this.expressCity = "",
    this.expressState = "",
    this.expressZip = "",
    this.expressCountry = "",
    this.expressLocalAddress = "",
  });

  factory Setting.dashboardAddressSetting() {
    return const Setting();
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

    return Setting(
      id: intValue('id'),
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
      expressShippingAddress1: stringValue('express_shipping_address_1'),
      expressShippingAddress2: stringValue('express_shipping_address_2'),
      expressCity: stringValue('express_city'),
      expressState: stringValue('express_state'),
      expressZip: stringValue('express_zip'),
      expressCountry: stringValue('express_country'),
      expressLocalAddress: stringValue('express_local_address'),
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
      usRate: stringValue('us_rate'),
      discount: stringValue('discount'),
      rewardPoints: intValue('reward_points'),
      apiToken: stringValue('api_token'),
    );
  }

  Map<String, dynamic> toJson() => _$SettingToJson(this);
}
