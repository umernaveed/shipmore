import 'package:json_annotation/json_annotation.dart';

import 'setting.dart';
import 'user_info.dart';

part 'dashboard_address_data.g.dart';

@JsonSerializable()
class DashboardAddressData {
  @JsonKey(name: 'setting', defaultValue: Setting.dashboardAddressSetting)
  final Setting setting;
  @JsonKey(name: 'user_info', defaultValue: UserInfo.empty)
  final UserInfo userInfo;

  const DashboardAddressData({required this.setting, required this.userInfo});

  factory DashboardAddressData.fromJson(Map<String, dynamic> json) {
    final settingJson = json['setting'];
    final userInfoJson = json['user_info'];

    return DashboardAddressData(
      setting: settingJson is Map
          ? Setting.fromJson(Map<String, dynamic>.from(settingJson))
          : Setting.dashboardAddressSetting(),
      userInfo: userInfoJson is Map
          ? UserInfo.fromJson(Map<String, dynamic>.from(userInfoJson))
          : UserInfo.empty(),
    );
  }

  factory DashboardAddressData.defaultValues() {
    return DashboardAddressData(
      setting: Setting.dashboardAddressSetting(),
      userInfo: UserInfo.empty(),
    );
  }

  Map<String, dynamic> toJson() => _$DashboardAddressDataToJson(this);
}
