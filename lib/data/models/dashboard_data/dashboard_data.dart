import 'package:json_annotation/json_annotation.dart';

import 'setting.dart';

part 'dashboard_data.g.dart';

@JsonSerializable()
class DashboardData {
  @JsonKey(name: 'setting', defaultValue: Setting.defaultValues)
  final Setting setting;
  @JsonKey(name: 'outlet_id', defaultValue: '-1')
  final String outletId;
  @JsonKey(name: 'outstanding_package', defaultValue: -1)
  final int outstandingPackage;
  @JsonKey(name: 'in_transit', defaultValue: -1)
  final int inTransit;
  @JsonKey(name: 'outstanding_invoice', defaultValue: -1)
  final int outstandingInvoice;
  @JsonKey(name: 'outstanding_balance', defaultValue: '-1')
  final String outstandingBalance;
  @JsonKey(name: 'wherehouse', defaultValue: -1)
  final int wherehouse;
  @JsonKey(name: 'member_points', defaultValue: -1)
  final num memberPoints;
  @JsonKey(name: 'referral_code', defaultValue: "")
  final String referralCode;
  @JsonKey(name: 'pending_balance', defaultValue: '0')
  final dynamic pendingBalance;
  @JsonKey(name: 'available_balance', defaultValue: 0)
  final num availableBalance;
  @JsonKey(name: 'package_count', defaultValue: 0)
  final int packageCount;
  @JsonKey(name: 'package_weight', defaultValue: 0)
  final dynamic packageWeight;
  @JsonKey(name: 'account_manager', defaultValue: '')
  final String accountManager;
  @JsonKey(name: 'manager_phone', defaultValue: '')
  final String managerPhone;
  @JsonKey(name: 'package_ids', defaultValue: '')
  final String packageIds;
  @JsonKey(name: 'invoice_ids', defaultValue: '')
  final String invoiceIds;
  @JsonKey(name: 'recent_packages', defaultValue: <DashboardRecentPackage>[])
  final List<DashboardRecentPackage> recentPackages;

  const DashboardData({
    required this.setting,
    required this.outletId,
    required this.outstandingPackage,
    required this.inTransit,
    required this.outstandingInvoice,
    required this.outstandingBalance,
    required this.wherehouse,
    required this.memberPoints,
    required this.referralCode,
    required this.pendingBalance,
    required this.availableBalance,
    required this.packageCount,
    required this.packageWeight,
    required this.accountManager,
    required this.packageIds,
    required this.invoiceIds,
    required this.managerPhone,
    required this.recentPackages,
  });

  factory DashboardData.defaultValues() {
    return DashboardData(
      inTransit: 0,
      memberPoints: 0,
      outletId: '-1',
      outstandingBalance: '',
      outstandingInvoice: 0,
      outstandingPackage: 0,
      setting: Setting.defaultValues(),
      wherehouse: 0,
      pendingBalance: 0,
      availableBalance: 0,
      packageCount: 0,
      packageWeight: 0,
      referralCode: '',
      accountManager: '',
      packageIds: '',
      invoiceIds: '',
      managerPhone: '',
      recentPackages: const [],
    );
  }
  factory DashboardData.fromJson(Map<String, dynamic> json) {
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

    final settingJson = json['setting'];

    return DashboardData(
      setting: settingJson is Map
          ? Setting.fromJson(Map<String, dynamic>.from(settingJson))
          : Setting.defaultValues(),
      outletId: stringValue('outlet_id', '-1'),
      outstandingPackage: intValue('outstanding_package'),
      inTransit: intValue('in_transit'),
      outstandingInvoice: intValue('outstanding_invoice'),
      outstandingBalance: stringValue('outstanding_balance'),
      wherehouse: intValue('wherehouse'),
      memberPoints: numValue('member_points'),
      referralCode: stringValue('referral_code'),
      pendingBalance: json['pending_balance'] ?? 0,
      availableBalance: numValue('available_balance'),
      packageCount: intValue('package_count'),
      packageWeight: json['package_weight'] ?? 0,
      accountManager: stringValue('account_manager'),
      managerPhone: stringValue('manager_phone'),
      packageIds: stringValue('package_ids'),
      invoiceIds: stringValue('invoice_ids'),
      recentPackages: (json['recent_packages'] is List)
          ? (json['recent_packages'] as List)
              .whereType<Map>()
              .map((item) =>
                  DashboardRecentPackage.fromJson(Map<String, dynamic>.from(item)))
              .toList()
          : const [],
    );
  }

  Map<String, dynamic> toJson() => _$DashboardDataToJson(this);
}

@JsonSerializable()
class DashboardRecentPackage {
  @JsonKey(name: 'tracking_no', defaultValue: '')
  final String trackingNo;
  @JsonKey(name: 'courier', defaultValue: '')
  final String courier;
  @JsonKey(name: 'merchant', defaultValue: '')
  final String merchant;
  @JsonKey(name: 'status', defaultValue: 0)
  final int status;
  @JsonKey(name: 'status_name', defaultValue: '')
  final String statusName;
  @JsonKey(name: 'created_at', defaultValue: '')
  final String createdAt;

  const DashboardRecentPackage({
    required this.trackingNo,
    required this.courier,
    required this.merchant,
    required this.status,
    required this.statusName,
    required this.createdAt,
  });

  factory DashboardRecentPackage.fromJson(Map<String, dynamic> json) {
    String stringValue(String key, [String fallback = '']) {
      final value = json[key];
      return value == null ? fallback : value.toString();
    }

    int intValue(String key, [int fallback = 0]) {
      final value = json[key];
      if (value is num) return value.toInt();
      return int.tryParse(value?.toString() ?? '') ?? fallback;
    }

    return DashboardRecentPackage(
      trackingNo: stringValue('tracking_no'),
      courier: stringValue('courier'),
      merchant: stringValue('merchant'),
      status: intValue('status'),
      statusName: stringValue('status_name'),
      createdAt: stringValue('created_at'),
    );
  }

  Map<String, dynamic> toJson() => _$DashboardRecentPackageToJson(this);
}
