import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:we_ship_faas/app/core/get_di.dart';
import 'package:we_ship_faas/app/core/routes/app_pages.dart';
import 'package:we_ship_faas/app/util/flush_snackbar.dart';
import 'package:we_ship_faas/presentation/account/controllers/account_controller.dart';
import 'package:we_ship_faas/presentation/base_screen.dart';
import 'package:we_ship_faas/presentation/bottom_nav/controllers/bottom_nav_controller.dart';
import 'package:we_ship_faas/presentation/dashboard/views/dashboard.dart';
import 'package:we_ship_faas/presentation/widgets/dialogs/account_delete_dialog.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomNav = find<BottomNavController>();

    return BaseScreen(
      backgroundColor: Dashboard.pageBg,
      showGradients: false,
      value: SystemUiOverlayStyle.dark,
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 20),
              child: Column(
                children: [
                  const SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: EdgeInsets.only(top: 18, bottom: 24),
                      child: _AccountLogo(),
                    ),
                  ),
                  const _ProfileCard(),
                  const SizedBox(height: 18),
                  _MenuCard(
                    children: [
                      _AccountMenuTile(
                        title: 'Dashboard',
                        icon: Icons.home_outlined,
                        iconColor: Dashboard.blue,
                        iconBackground: const Color(0xFFF4E8FF),
                        onTap: () => bottomNav.onTabChange(0),
                      ),
                      _AccountMenuTile(
                        title: 'Authorize User',
                        icon: Icons.person_outline_rounded,
                        iconColor: const Color(0xFF139B8D),
                        iconBackground: const Color(0xFFE7FAF5),
                        expandable: true,
                        children: [
                          _AccountChildTile(
                            title: 'Create Authorize User',
                            onTap: () => Get.toNamed(
                              AppPages.addAuthorizeUser,
                              id: bottomNav.bottomNavNestedID,
                            ),
                          ),
                          _AccountChildTile(
                            title: 'Authorize Users',
                            onTap: () => Get.toNamed(
                              AppPages.authorizeUser,
                              id: bottomNav.bottomNavNestedID,
                            ),
                          ),
                        ],
                      ),
                      _AccountMenuTile(
                        title: 'My Account',
                        icon: Icons.credit_card_rounded,
                        iconColor: const Color(0xFF6925D7),
                        iconBackground: const Color(0xFFF2E9FF),
                        expandable: true,
                        children: [
                          _AccountChildTile(
                            title: 'Add Pre-Alert',
                            onTap: () => Get.toNamed(
                              AppPages.addPreAlertScreen,
                              id: bottomNav.bottomNavNestedID,
                            ),
                          ),
                          _AccountChildTile(
                            title: 'Track Packages',
                            onTap: () => Get.toNamed(
                              AppPages.trackPackages,
                              id: bottomNav.bottomNavNestedID,
                            ),
                          ),
                          _AccountChildTile(
                            title: 'Invoices',
                            onTap: () => Get.toNamed(
                              AppPages.invoices,
                              id: bottomNav.bottomNavNestedID,
                            ),
                          ),
                          _AccountChildTile(
                            title: 'Invite Friend',
                            onTap: () => Get.toNamed(
                              AppPages.inviteFriend,
                              id: bottomNav.bottomNavNestedID,
                            ),
                          ),
                        ],
                      ),
                      _AccountMenuTile(
                        title: 'Delivery System',
                        icon: Icons.location_on_outlined,
                        iconColor: const Color(0xFFF08B10),
                        iconBackground: const Color(0xFFFFF3E4),
                        expandable: true,
                        children: [
                          _AccountChildTile(
                            title: 'Request Delivery',
                            onTap: () => Get.toNamed(
                              AppPages.deliveryScreen,
                              id: bottomNav.bottomNavNestedID,
                            ),
                          ),
                        ],
                      ),
                      _AccountMenuTile(
                        title: 'Purchase Request',
                        icon: Icons.shopping_cart_outlined,
                        iconColor: const Color(0xFF0EAA66),
                        iconBackground: const Color(0xFFE9F9F1),
                        expandable: true,
                        children: [
                          _AccountChildTile(
                            title: 'Create Purchase Request',
                            onTap: () => Get.toNamed(
                              AppPages.addPurchase,
                              id: bottomNav.bottomNavNestedID,
                            ),
                          ),
                          _AccountChildTile(
                            title: 'Purchase Requests',
                            onTap: () => Get.toNamed(
                              AppPages.purchase,
                              id: bottomNav.bottomNavNestedID,
                            ),
                          ),
                        ],
                      ),
                      _AccountMenuTile(
                        title: 'View Referral Users',
                        icon: Icons.groups_2_outlined,
                        iconColor: const Color(0xFF7926E8),
                        iconBackground: const Color(0xFFF3E9FF),
                        onTap: () => Get.toNamed(
                          AppPages.refferalUsers,
                          id: bottomNav.bottomNavNestedID,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const _DangerActionsCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountLogo extends StatelessWidget {
  const _AccountLogo();

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
              size: Size(36, 22),
              painter: _SpeedMarkPainter(),
            ),
            const SizedBox(width: 5),
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
        const SizedBox(height: 7),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 24, height: 1, color: Dashboard.darkBlue),
            const SizedBox(width: 9),
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
            const SizedBox(width: 9),
            Container(width: 24, height: 1, color: Dashboard.darkBlue),
          ],
        ),
      ],
    );
  }
}

class _SpeedMarkPainter extends CustomPainter {
  const _SpeedMarkPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 3.2
      ..strokeCap = StrokeCap.round
      ..color = Dashboard.blue;
    final rows = [
      [0.00, 0.82],
      [0.14, 0.92],
      [0.28, 1.00],
      [0.42, 0.86],
    ];

    for (var i = 0; i < rows.length; i++) {
      final y = size.height * (0.16 + (i * 0.22));
      canvas.drawLine(
        Offset(size.width * rows[i][0], y),
        Offset(size.width * rows[i][1], y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard();

  @override
  Widget build(BuildContext context) {
    final controller = find<AccountController>();

    return Obx(() {
      final user = controller.user.value;
      final name = user.completeName.trim().isEmpty
          ? 'Herms User'
          : user.completeName.trim();
      final initials = _initials(user.firstName, user.lastName);

      return InkWell(
        onTap: () => Get.toNamed(AppPages.updateProfile),
        borderRadius: BorderRadius.circular(18),
        child: Container(
          height: 136,
          padding: const EdgeInsets.fromLTRB(18, 16, 16, 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF7A1EC2), Color(0xFF2D0738)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Dashboard.blue.withOpacity(0.22),
                offset: const Offset(0, 10),
                blurRadius: 24,
              ),
            ],
          ),
          child: Stack(
            children: [
              const Positioned.fill(
                child: CustomPaint(painter: _ProfileWavePainter()),
              ),
              Row(
                children: [
                  Container(
                    width: 66,
                    height: 66,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white70, width: 1.5),
                    ),
                    child: Text(
                      initials,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Icon(
                              Icons.edit_outlined,
                              color: Colors.white,
                              size: 26,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          user.email,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.white,
                    size: 38,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  static String _initials(String firstName, String lastName) {
    final first = firstName.trim().isNotEmpty ? firstName.trim()[0] : '';
    final last = lastName.trim().isNotEmpty ? lastName.trim()[0] : '';
    final result = '$first$last'.toUpperCase();
    return result.isEmpty ? 'LX' : result;
  }
}

class _ProfileWavePainter extends CustomPainter {
  const _ProfileWavePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.10)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (var i = 0; i < 18; i++) {
      final path = Path()
        ..moveTo(size.width * 0.58, size.height * (0.08 + i * 0.035))
        ..quadraticBezierTo(
          size.width * 0.80,
          size.height * (0.02 + i * 0.012),
          size.width * 1.04,
          size.height * (0.52 + i * 0.018),
        );
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _cardDecoration(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Column(
          children: [
            for (var i = 0; i < children.length; i++) ...[
              children[i],
              if (i != children.length - 1) const _AccountDivider(),
            ],
          ],
        ),
      ),
    );
  }
}

class _AccountMenuTile extends StatelessWidget {
  const _AccountMenuTile({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    this.onTap,
    this.expandable = false,
    this.children = const [],
  });

  final String title;
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final VoidCallback? onTap;
  final bool expandable;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    if (expandable) {
      return Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.fromLTRB(22, 13, 24, 13),
          childrenPadding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
          leading: _TileIcon(
            icon: icon,
            iconColor: iconColor,
            background: iconBackground,
          ),
          title: _TileTitle(title),
          trailing: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Dashboard.darkBlue,
            size: 28,
          ),
          children: children,
        ),
      );
    }

    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 78,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 0, 24, 0),
          child: Row(
            children: [
              _TileIcon(
                icon: icon,
                iconColor: iconColor,
                background: iconBackground,
              ),
              const SizedBox(width: 22),
              Expanded(child: _TileTitle(title)),
              const Icon(
                Icons.chevron_right_rounded,
                color: Dashboard.darkBlue,
                size: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AccountChildTile extends StatelessWidget {
  const _AccountChildTile({required this.title, required this.onTap});

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(94, 8, 24, 8),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: const TextStyle(
              color: Color(0xFF4D566B),
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _TileIcon extends StatelessWidget {
  const _TileIcon({
    required this.icon,
    required this.iconColor,
    required this.background,
  });

  final IconData icon;
  final Color iconColor;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Icon(icon, color: iconColor, size: 31),
    );
  }
}

class _TileTitle extends StatelessWidget {
  const _TileTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: Dashboard.darkBlue,
        fontSize: 17,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _DangerActionsCard extends StatelessWidget {
  const _DangerActionsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: _cardDecoration(),
      child: const Column(
        children: [
          _LogoutActionTile(),
          SizedBox(height: 10),
          _DeleteActionTile(),
        ],
      ),
    );
  }
}

class _LogoutActionTile extends StatelessWidget {
  const _LogoutActionTile();

  @override
  Widget build(BuildContext context) {
    return _ActionTile(
      title: 'Log Out',
      subtitle: 'Securely log out from your account',
      icon: Icons.logout_rounded,
      iconColor: Dashboard.blue,
      background: const Color(0xFFF7EEFF),
      textColor: Dashboard.blue,
      onTap: () {
        final c = find<AccountController>();
        c.onLogOut().then((value) {
          if (value.isDone) {
            Get.offAllNamed(AppPages.login);
            return;
          }
          if (value.message.isNotEmpty) {
            FlushSnackbar.showSnackBar(value.message);
          }
        });
      },
    );
  }
}

class _DeleteActionTile extends StatelessWidget {
  const _DeleteActionTile();

  @override
  Widget build(BuildContext context) {
    return _ActionTile(
      title: 'Delete Account',
      subtitle: 'Permanently delete your account',
      icon: Icons.delete_outline_rounded,
      iconColor: const Color(0xFFE30012),
      background: const Color(0xFFFFEEEE),
      textColor: const Color(0xFFE30012),
      onTap: () async {
        final result =
            await Get.dialog<bool>(const AccountDeleteConfirmationDialog());
        if (!(result ?? false)) return;
        final c = find<AccountController>();
        await c.deleteAccount();
      },
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.background,
    required this.textColor,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color background;
  final Color textColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        constraints: const BoxConstraints(minHeight: 82),
        padding: const EdgeInsets.fromLTRB(18, 12, 20, 12),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            _TileIcon(
              icon: icon,
              iconColor: iconColor,
              background: Colors.white.withOpacity(0.48),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF4D566B),
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Dashboard.darkBlue,
              size: 30,
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountDivider extends StatelessWidget {
  const _AccountDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      thickness: 1,
      color: Color(0xFFEAF0F8),
    );
  }
}

class AppDivider extends StatelessWidget {
  const AppDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 0,
      thickness: 1,
      color: Color(0xFFE2E2E2),
    );
  }
}

BoxDecoration _cardDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(18),
    border: Border.all(color: const Color(0xFFF0F4FA)),
    boxShadow: [
      BoxShadow(
        color: const Color(0xFF8CA7CA).withOpacity(0.13),
        offset: const Offset(0, 8),
        blurRadius: 22,
      ),
    ],
  );
}
