import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:we_ship_faas/app/core/routes/app_pages.dart';
import 'package:we_ship_faas/app/util/flush_snackbar.dart';
import 'package:we_ship_faas/data/models/dashboard_data/dashboard_data.dart';
import 'package:we_ship_faas/presentation/bottom_nav/controllers/bottom_nav_controller.dart';
import 'package:we_ship_faas/presentation/dashboard/controllers/dashboard_controller.dart';
import 'package:we_ship_faas/presentation/widgets/shimmer_widget.dart';

class Dashboard extends GetView<DashboardController> {
  const Dashboard({super.key});

  static const Color blue = Color(0xFF7A1EC2);
  static const Color darkBlue = Color(0xFF26052F);
  static const Color purple = Color(0xFF9B35D6);
  static const Color green = Color(0xFF07A64B);
  static const Color orange = Color(0xFFD7B24A);
  static const Color pageBg = Color(0xFFFCF9FF);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: blue,
      onRefresh: controller.refreshData,
      child: controller.obx(
        onLoading: const _DashboardLoading(),
        onEmpty: const _EmptyDashboard(),
        onError: (error) => _EmptyDashboard(message: error),
        (state) {
          if (state == null) return const _EmptyDashboard();
          return CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _DashboardHeader(),
                      const SizedBox(height: 12),
                      _AccountSummary(data: state, controller: controller),
                      const SizedBox(height: 12),
                      _StatsStrip(data: state),
                      const SizedBox(height: 12),
                      _RewardsAndReferral(data: state),
                      const SizedBox(height: 12),
                      _RecentPackages(data: state),
                      const SizedBox(height: 12),
                      const _QuickActions(),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SizedBox(
        height: 64,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.menu_rounded),
                color: Dashboard.darkBlue,
                iconSize: 31,
                onPressed: _openDashboardMenu,
              ),
            ),
            const _LiteLogo(),
            Align(
              alignment: Alignment.centerRight,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_none_rounded),
                    color: Dashboard.darkBlue,
                    iconSize: 30,
                    onPressed: () => Get.toNamed(
                      AppPages.newsScreen,
                      id: Get.find<BottomNavController>().bottomNavNestedID,
                    ),
                  ),
                  Positioned(
                    right: 6,
                    top: 4,
                    child: Obx(() {
                      final badge = Get.find<BottomNavController>()
                          .notificationBadge;
                      if (badge == null) return const SizedBox.shrink();
                      return Container(
                        width: 19,
                        height: 19,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF1428),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          badge,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w800,
                            height: 1,
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openDashboardMenu() {
    Get.dialog(
      const _DashboardMenuPanel(),
      barrierColor: Colors.black26,
      transitionCurve: Curves.easeOutCubic,
    );
  }
}

class _DashboardMenuPanel extends StatelessWidget {
  const _DashboardMenuPanel();

  @override
  Widget build(BuildContext context) {
    final bottomNav = Get.find<BottomNavController>();

    return Align(
      alignment: Alignment.centerLeft,
      child: Material(
        color: Colors.transparent,
        child: SafeArea(
          child: Container(
            width: 286,
            margin: const EdgeInsets.only(left: 12, top: 8, bottom: 8),
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.14),
                  offset: const Offset(0, 14),
                  blurRadius: 30,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const _LiteLogo(),
                const SizedBox(height: 18),
                _DashboardMenuItem(
                  icon: Icons.home_rounded,
                  label: 'Dashboard',
                  onTap: () => _goToTab(bottomNav, 0),
                ),
                _DashboardMenuItem(
                  icon: Icons.inventory_2_outlined,
                  label: 'Packages',
                  onTap: () => _goToTab(bottomNav, 1),
                ),
                _DashboardMenuItem(
                  icon: Icons.add_box_outlined,
                  label: 'New Package',
                  onTap: () => _goToTab(bottomNav, 2),
                ),
                _DashboardMenuItem(
                  icon: Icons.notifications_none_rounded,
                  label: 'Notifications',
                  onTap: () => _goToTab(bottomNav, 3),
                ),
                _DashboardMenuItem(
                  icon: Icons.person_outline_rounded,
                  label: 'Account',
                  onTap: () => _goToTab(bottomNav, 4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _goToTab(BottomNavController controller, int index) {
    Get.back<void>();
    controller.onTabChange(index);
  }
}

class _DashboardMenuItem extends StatelessWidget {
  const _DashboardMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: Dashboard.blue, size: 23),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                color: Dashboard.darkBlue,
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LiteLogo extends StatelessWidget {
  const _LiteLogo();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const CustomPaint(
              size: Size(34, 21),
              painter: _SpeedMarkPainter(),
            ),
            const SizedBox(width: 3),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'Herms',
                    style: TextStyle(color: Dashboard.darkBlue),
                  ),
                  TextSpan(
                    text: '',
                    style: TextStyle(color: Dashboard.blue),
                  ),
                ],
              ),
              style: const TextStyle(
                fontSize: 25,
                fontFamily: 'Poppins',
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w800,
                height: 0.95,
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 18, height: 1, color: Dashboard.darkBlue),
            const SizedBox(width: 8),
            const Text(
              'C O U R I E R  L . T . D',
              style: TextStyle(
                color: Dashboard.darkBlue,
                fontSize: 8,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                letterSpacing: 3.4,
              ),
            ),
            const SizedBox(width: 8),
            Container(width: 18, height: 1, color: Dashboard.darkBlue),
          ],
        ),
      ],
    );
  }
}

class _AccountSummary extends StatelessWidget {
  const _AccountSummary({required this.data, required this.controller});

  final DashboardData data;
  final DashboardController controller;

  @override
  Widget build(BuildContext context) {
    final user = controller.currentUser;
    final name = user.firstName.trim().isEmpty ? 'Member' : user.firstName;
    final initials = _initials(user.firstName, user.lastName);
    final balance = _splitBalance(data.outstandingBalance);

    return Container(
      height: 204,
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7A1EC2), Color(0xFF2D0738)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Dashboard.blue.withOpacity(0.25),
            offset: const Offset(0, 10),
            blurRadius: 22,
          ),
        ],
      ),
      child: Stack(
        children: [
          const Positioned.fill(
            child: CustomPaint(painter: _CardWavePainter()),
          ),
          Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white30, width: 2),
                    ),
                    child: Text(
                      initials,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello, $name 👋',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                'Account ID: ${user.mailbox}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Color(0xFFE6EEFF),
                                  fontSize: 12,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            GestureDetector(
                              onTap: () async {
                                await Clipboard.setData(
                                  ClipboardData(text: user.mailbox),
                                );
                                FlushSnackbar.showSnackBar(
                                  'Account ID copied',
                                );
                              },
                              child: const Icon(
                                Icons.copy_rounded,
                                color: Color(0xFFE6EEFF),
                                size: 15,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Icon(Icons.more_vert_rounded,
                          color: Colors.white, size: 27),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(9),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star_rounded,
                              color: Color(0xFFFFD21D),
                              size: 16,
                            ),
                            SizedBox(width: 5),
                            Text(
                              'Gold Member',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(height: 1, color: Colors.white12),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _HeroMetric(
                      label: 'Outstanding Balance',
                      value: balance.amount,
                      suffix: balance.currency,
                      buttonText: 'View Invoices',
                      icon: Icons.description_outlined,
                      onTap: () => Get.toNamed(
                        AppPages.invoices,
                        id: Get.find<BottomNavController>().bottomNavNestedID,
                      ),
                    ),
                  ),
                  Container(width: 1, height: 58, color: Colors.white30),
                  const SizedBox(width: 18),
                  Expanded(
                    child: _HeroMetric(
                      label: 'Packages Ready',
                      value: data.outstandingPackage.toString(),
                      suffix: 'For Pickup',
                      buttonText: 'View Packages',
                      icon: Icons.inventory_2_outlined,
                      onTap: () => Get.toNamed(
                        AppPages.trackPackages,
                        id: Get.find<BottomNavController>().bottomNavNestedID,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _initials(String firstName, String lastName) {
    final first = firstName.trim().isNotEmpty ? firstName.trim()[0] : '';
    final last = lastName.trim().isNotEmpty ? lastName.trim()[0] : '';
    final result = '$first$last'.toUpperCase();
    return result.isEmpty ? 'LX' : result;
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({
    required this.label,
    required this.value,
    required this.suffix,
    required this.buttonText,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final String value;
  final String suffix;
  final String buttonText;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (label.contains('Balance')) ...[
              const SizedBox(width: 5),
              const Icon(Icons.visibility_outlined,
                  color: Colors.white70, size: 15),
            ],
          ],
        ),
        const SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
            ),
            const SizedBox(width: 5),
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(
                suffix,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    buttonText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (buttonText.contains('Packages')) ...[
                  const SizedBox(width: 8),
                  const Icon(Icons.chevron_right_rounded,
                      color: Colors.white, size: 22),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StatsStrip extends StatelessWidget {
  const _StatsStrip({required this.data});

  final DashboardData data;

  @override
  Widget build(BuildContext context) {
    final balance = _splitBalance(data.outstandingBalance);
    return _Card(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          _StatItem(
            icon: Icons.warehouse_outlined,
            iconColor: Dashboard.blue,
            background: const Color(0xFFF4E8FF),
            value: data.wherehouse.toString(),
            label: 'Miami Warehouse',
          ),
          const _VerticalRule(),
          _StatItem(
            icon: Icons.local_shipping_rounded,
            iconColor: Dashboard.purple,
            background: const Color(0xFFF2EAFE),
            value: data.inTransit.toString(),
            label: 'In Transit',
          ),
          const _VerticalRule(),
          _StatItem(
            icon: Icons.check_circle_rounded,
            iconColor: Dashboard.green,
            background: const Color(0xFFEAF9F0),
            value: data.outstandingPackage.toString(),
            label: 'Ready for Pickup',
          ),
          const _VerticalRule(),
          _StatItem(
            icon: Icons.account_balance_wallet_rounded,
            iconColor: Dashboard.orange,
            background: const Color(0xFFFFF3E5),
            value: balance.amount,
            label: 'Outstanding Balance',
            compactValue: true,
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.iconColor,
    required this.background,
    required this.value,
    required this.label,
    this.compactValue = false,
  });

  final IconData icon;
  final Color iconColor;
  final Color background;
  final String value;
  final String label;
  final bool compactValue;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 26),
          ),
          const SizedBox(height: 9),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                color: Dashboard.darkBlue,
                fontSize: compactValue ? 19 : 25,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w800,
                height: 1,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Dashboard.darkBlue,
                fontSize: 11,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                height: 1.14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RewardsAndReferral extends StatelessWidget {
  const _RewardsAndReferral({required this.data});

  final DashboardData data;

  @override
  Widget build(BuildContext context) {
    final rewardTarget = int.tryParse(data.setting.rewardPackages) ?? 75;
    final progress = rewardTarget <= 0
        ? 0.0
        : (data.packageCount / rewardTarget).clamp(0, 1).toDouble();
    final rate = num.tryParse(data.setting.usRate) ?? 0;
    final rewardJmd = data.memberPoints * rate;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _Card(
            background: const Color(0xFFFBFFFC),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionTitle(
                  icon: Icons.card_giftcard_rounded,
                  iconColor: Dashboard.green,
                  title: 'Rewards Wallet',
                ),
                const SizedBox(height: 18),
                _MoneyLine(
                  amount: _formatNum(data.memberPoints),
                  currency: 'USD',
                  label: 'Rewards Balance',
                ),
                const SizedBox(height: 10),
                _MoneyLine(
                  amount: _formatNum(rewardJmd),
                  currency: 'JMD',
                  label: 'Rewards Balance',
                ),
                const SizedBox(height: 15),
                Container(height: 1, color: const Color(0xFFE6EBF2)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      '${data.packageCount} / $rewardTarget packages',
                      style: const TextStyle(
                        color: Dashboard.darkBlue,
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${(progress * 100).round()}%',
                      style: const TextStyle(
                        color: Dashboard.darkBlue,
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    color: Dashboard.blue,
                    backgroundColor: const Color(0xFFE5E9EC),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Ship ${(rewardTarget - data.packageCount).clamp(0, rewardTarget)} more packages to earn ${data.setting.rewardAmount} USD',
                  style: const TextStyle(
                    color: Dashboard.darkBlue,
                    fontSize: 11,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _Card(
            background: const Color(0xFFFEFCFF),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionTitle(
                  icon: Icons.groups_rounded,
                  iconColor: Dashboard.purple,
                  title: 'Refer & Earn',
                ),
                const SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        'Earn ${data.setting.referralAmount} USD on ${data.setting.reffralPackages} packages shipped or reach ${data.setting.reffralWeight}lb weight.',
                        style: const TextStyle(
                          color: Dashboard.darkBlue,
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          height: 1.45,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const _GiftIllustration(),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: _ReferralButton(
                        icon: Icons.link_rounded,
                        label: 'Share Link',
                        onTap: () async {
                          await Clipboard.setData(
                            ClipboardData(text: data.referralCode),
                          );
                          FlushSnackbar.showSnackBar(
                            'Referral link copied',
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _ReferralButton(
                        icon: Icons.qr_code_2_rounded,
                        label: 'Show QR Code',
                        onTap: () => Get.dialog(_QrDialog(data.referralCode)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _RecentPackages extends StatelessWidget {
  const _RecentPackages({required this.data});

  final DashboardData data;

  @override
  Widget build(BuildContext context) {
    final packages = _recentPackages(data);
    return _Card(
      padding: const EdgeInsets.fromLTRB(14, 13, 14, 6),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.inventory_2_outlined,
                  color: Dashboard.darkBlue, size: 25),
              const SizedBox(width: 12),
              const Text(
                'Recent Packages',
                style: TextStyle(
                  color: Dashboard.darkBlue,
                  fontSize: 17,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => Get.toNamed(
                  AppPages.trackPackages,
                  id: Get.find<BottomNavController>().bottomNavNestedID,
                ),
                child: const Row(
                  children: [
                    Text(
                      'View All',
                      style: TextStyle(
                        color: Dashboard.blue,
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 7),
                    Icon(Icons.chevron_right_rounded,
                        color: Dashboard.blue, size: 23),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          for (var i = 0; i < packages.length; i++) ...[
            if (i > 0) Container(height: 1, color: const Color(0xFFE9EDF4)),
            _RecentPackageRow(package: packages[i], index: i),
          ],
        ],
      ),
    );
  }

  List<DashboardRecentPackage> _recentPackages(DashboardData data) {
    if (data.recentPackages.isNotEmpty) return data.recentPackages.take(2).toList();
    final ids = data.packageIds
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .take(2)
        .toList();
    if (ids.isEmpty) {
      return const [
        DashboardRecentPackage(
          trackingNo: '1006384',
          courier: 'AMAZON',
          merchant: 'AMAZON',
          status: 2,
          statusName: 'In Transit',
          createdAt: '',
        ),
        DashboardRecentPackage(
          trackingNo: '1005788',
          courier: 'AMAZON',
          merchant: 'AMAZON',
          status: 1,
          statusName: 'Ready for Pickup',
          createdAt: '',
        ),
      ];
    }
    return ids
        .map(
          (id) => DashboardRecentPackage(
            trackingNo: id,
            courier: 'PACKAGE',
            merchant: 'PACKAGE',
            status: 1,
            statusName: 'Ready for Pickup',
            createdAt: '',
          ),
        )
        .toList();
  }
}

class _RecentPackageRow extends StatelessWidget {
  const _RecentPackageRow({required this.package, required this.index});

  final DashboardRecentPackage package;
  final int index;

  @override
  Widget build(BuildContext context) {
    final ready = package.status == 1 ||
        package.statusName.toLowerCase().contains('ready') ||
        package.statusName.toLowerCase().contains('pickup');
    final color = ready ? Dashboard.green : Dashboard.purple;
    final bg = ready ? const Color(0xFFEAF9F0) : const Color(0xFFF1EBFF);
    final status = package.statusName.isEmpty
        ? (ready ? 'Ready for Pickup' : 'In Transit')
        : package.statusName;

    return SizedBox(
      height: 61,
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.inventory_2_outlined, color: color, size: 25),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'HAWB: ${package.trackingNo}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Dashboard.darkBlue,
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        (package.merchant.isEmpty
                                ? package.courier
                                : package.merchant)
                            .toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF70758D),
                          fontSize: 11,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (package.createdAt.isNotEmpty) ...[
                      const SizedBox(width: 12),
                      const Icon(Icons.calendar_today_outlined,
                          color: Color(0xFF70758D), size: 12),
                      const SizedBox(width: 5),
                      Text(
                        _formatDate(package.createdAt),
                        style: const TextStyle(
                          color: Color(0xFF70758D),
                          fontSize: 11,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right_rounded,
              color: Dashboard.darkBlue, size: 25),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              color: Dashboard.darkBlue,
              fontSize: 15,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 9),
          Row(
            children: [
              _ActionTile(
                icon: Icons.photo_camera_outlined,
                color: const Color(0xFF18A9EF),
                label: 'Add\nPackage',
                onTap: () => Get.toNamed(
                  AppPages.addPreAlertScreen,
                  id: Get.find<BottomNavController>().bottomNavNestedID,
                ),
              ),
              _ActionTile(
                icon: Icons.description_rounded,
                color: const Color(0xFF7B5BF7),
                label: 'My\nInvoices',
                onTap: () => Get.toNamed(
                  AppPages.invoices,
                  id: Get.find<BottomNavController>().bottomNavNestedID,
                ),
              ),
              _ActionTile(
                icon: Icons.headphones_rounded,
                color: Dashboard.orange,
                label: 'Support\nTicket',
                onTap: () => FlushSnackbar.showSnackBar(
                  'Support ticket feature is not available yet',
                ),
              ),
              _ActionTile(
                icon: Icons.location_on_rounded,
                color: Dashboard.green,
                label: 'Track\nShipment',
                onTap: () => Get.toNamed(
                  AppPages.trackPackages,
                  id: Get.find<BottomNavController>().bottomNavNestedID,
                ),
              ),
              _ActionTile(
                icon: Icons.calculate_rounded,
                color: const Color(0xFFFF2A7A),
                label: 'Rate\nCalculator',
                onTap: () => FlushSnackbar.showSnackBar(
                  'Rate calculator feature is not available yet',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 80,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE8ECF2)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Dashboard.darkBlue,
                  fontSize: 10,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  height: 1.15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.background = Colors.white,
  });

  final Widget child;
  final EdgeInsets padding;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9DB7DA).withOpacity(0.13),
            offset: const Offset(0, 6),
            blurRadius: 18,
          ),
        ],
        border: Border.all(color: const Color(0xFFF0F3F8)),
      ),
      child: child,
    );
  }
}

class _VerticalRule extends StatelessWidget {
  const _VerticalRule();

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 88, color: const Color(0xFFE6EBF2));
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.icon,
    required this.iconColor,
    required this.title,
  });

  final IconData icon;
  final Color iconColor;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 23),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: iconColor == Dashboard.green
                  ? const Color(0xFF087B3F)
                  : Dashboard.purple,
              fontSize: 15,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

class _MoneyLine extends StatelessWidget {
  const _MoneyLine({
    required this.amount,
    required this.currency,
    required this.label,
  });

  final String amount;
  final String currency;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(text: amount),
                TextSpan(
                  text: ' $currency',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            style: const TextStyle(
              color: Dashboard.darkBlue,
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF71758C),
            fontSize: 11,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _ReferralButton extends StatelessWidget {
  const _ReferralButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 63,
        decoration: BoxDecoration(
          color: const Color(0xFFFBF6FF),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Dashboard.blue, size: 23),
            const SizedBox(height: 7),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: const TextStyle(
                  color: Dashboard.purple,
                  fontSize: 11,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QrDialog extends StatelessWidget {
  const _QrDialog(this.data);

  final String data;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Referral QR Code',
              style: TextStyle(
                color: Dashboard.darkBlue,
                fontSize: 17,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 14),
            QrImageView(data: data, size: 210),
          ],
        ),
      ),
    );
  }
}

class _GiftIllustration extends StatelessWidget {
  const _GiftIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 58,
      height: 70,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            top: 0,
            left: 7,
            child: _Confetti(color: Dashboard.green),
          ),
          Positioned(
            top: 3,
            right: 8,
            child: _Confetti(color: Dashboard.orange),
          ),
          Positioned(
            top: 16,
            right: 0,
            child: _Confetti(color: Dashboard.purple),
          ),
          Container(
            width: 44,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF8788FF),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(width: 8, height: 36, color: Dashboard.purple),
          ),
          Positioned(
            bottom: 31,
            child: Container(
              width: 50,
              height: 9,
              decoration: BoxDecoration(
                color: const Color(0xFFA2A2FF),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 10,
            child: Transform.rotate(
              angle: -0.7,
              child: Container(
                width: 23,
                height: 13,
                decoration: BoxDecoration(
                  border: Border.all(color: Dashboard.purple, width: 4),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            right: 10,
            child: Transform.rotate(
              angle: 0.7,
              child: Container(
                width: 23,
                height: 13,
                decoration: BoxDecoration(
                  border: Border.all(color: Dashboard.purple, width: 4),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Confetti extends StatelessWidget {
  const _Confetti({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 0.8,
      child: Container(width: 6, height: 6, color: color),
    );
  }
}

class _DashboardLoading extends StatelessWidget {
  const _DashboardLoading();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(12, 80, 12, 18),
      itemCount: 5,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return ShimmerWidget(
          radius: BorderRadius.circular(16),
          child: SizedBox(
            height: index == 0 ? 164 : 120,
            width: double.infinity,
          ),
        );
      },
    );
  }
}

class _EmptyDashboard extends StatelessWidget {
  const _EmptyDashboard({this.message = 'No data found'});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.35),
        Center(
          child: Text(
            message?.isEmpty ?? true ? 'No data found' : message!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Dashboard.darkBlue,
              fontSize: 18,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _BalanceParts {
  const _BalanceParts(this.amount, this.currency);

  final String amount;
  final String currency;
}

_BalanceParts _splitBalance(String value) {
  final cleaned = value.trim().isEmpty ? '0.00 JMD' : value.trim();
  final parts = cleaned.split(RegExp(r'\s+'));
  if (parts.length == 1) return _BalanceParts(parts.first, 'JMD');
  return _BalanceParts(parts.first, parts.sublist(1).join(' '));
}

String _formatNum(num value) => value.toStringAsFixed(2);

String _formatDate(String value) {
  final date = DateTime.tryParse(value);
  if (date == null) return value;
  return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
}

class _SpeedMarkPainter extends CustomPainter {
  const _SpeedMarkPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Dashboard.blue
      ..strokeCap = StrokeCap.round
      ..strokeWidth = size.height * 0.14;
    for (var i = 0; i < 4; i++) {
      final y = size.height * (0.18 + i * 0.2);
      final start = size.width * (0.08 + i * 0.07);
      final end = size.width * (0.72 - (i == 0 ? 0.06 : 0));
      canvas.drawLine(Offset(start, y), Offset(end, y), paint);
    }
    final accent = Paint()
      ..color = const Color(0xFFE0C15B)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = size.height * 0.14;
    canvas.drawLine(
      Offset(size.width * 0.64, size.height * 0.18),
      Offset(size.width * 0.94, size.height * 0.18),
      accent,
    );
    canvas.drawLine(
      Offset(size.width * 0.55, size.height * 0.38),
      Offset(size.width * 0.88, size.height * 0.38),
      accent,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CardWavePainter extends CustomPainter {
  const _CardWavePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.07)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (var i = 0; i < 22; i++) {
      final path = Path()
        ..moveTo(size.width * 0.76, size.height * (0.42 + i * 0.012))
        ..cubicTo(
          size.width * 0.86,
          size.height * (0.30 + i * 0.012),
          size.width * 0.95,
          size.height * (0.38 + i * 0.012),
          size.width * 1.05,
          size.height * (0.20 + i * 0.012),
        );
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
