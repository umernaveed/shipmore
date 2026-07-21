import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:we_ship_faas/app/core/routes/app_routes.dart';
import 'package:we_ship_faas/presentation/base_screen.dart';
import 'package:we_ship_faas/presentation/bottom_nav/controllers/bottom_nav_controller.dart';
import 'package:we_ship_faas/presentation/dashboard/views/dashboard.dart';

class BottomNavScreen extends GetView<BottomNavController> {
  const BottomNavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      value: SystemUiOverlayStyle.dark,
      showGradients: false,
      extendBody: true,
      wrapWithAnnotatedRegion: true,
      backgroundColor: Dashboard.pageBg,
      body: Container(
        margin: const EdgeInsets.only(bottom: 102),
        child: Navigator(
          key: Get.nestedKey(controller.bottomNavNestedID),
          onGenerateRoute: (settings) {
            Get.routing.args = settings.arguments;
            final page = AppRoutes.routes.firstWhere(
              (r) => r.name == settings.name,
            );
            return GetPageRoute<dynamic>(
              page: page.page,
              settings: settings,
              binding: page.binding,
              transition: page.transition,
              parameter: page.parameters,
              opaque: page.opaque,
              popGesture: page.popGesture,
              fullscreenDialog: page.fullscreenDialog,
              maintainState: page.maintainState,
              curve: page.curve,
              middlewares: page.middlewares,
            );
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
          child: Container(
            height: 94,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF8CA7CA).withOpacity(0.22),
                  offset: const Offset(0, 4),
                  blurRadius: 18,
                ),
              ],
              border: Border.all(color: const Color(0xFFF0F3F8)),
            ),
            child: Obx(
              () => Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _NavItem(
                    index: 0,
                    current: controller.currentIndex.value,
                    icon: Icons.home_rounded,
                    label: 'Dashboard',
                    onTap: controller.onTabChange,
                  ),
                  _NavItem(
                    index: 1,
                    current: controller.currentIndex.value,
                    icon: Icons.inventory_2_outlined,
                    label: 'Packages',
                    onTap: controller.onTabChange,
                  ),
                  _CenterNavItem(
                    selected: controller.currentIndex.value == 2,
                    onTap: () => controller.onTabChange(2),
                  ),
                  _NavItem(
                    index: 3,
                    current: controller.currentIndex.value,
                    icon: Icons.notifications_none_rounded,
                    label: 'Notifications',
                    badge: controller.notificationBadge,
                    onTap: controller.onTabChange,
                  ),
                  _NavItem(
                    index: 4,
                    current: controller.currentIndex.value,
                    icon: Icons.person_outline_rounded,
                    label: 'Account',
                    onTap: controller.onTabChange,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.index,
    required this.current,
    required this.icon,
    required this.label,
    required this.onTap,
    this.badge,
  });

  final int index;
  final int current;
  final IconData icon;
  final String label;
  final void Function(int) onTap;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    final selected = index == current;
    final color = selected ? Dashboard.blue : Dashboard.darkBlue;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTap(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(icon, color: color, size: 27),
                if (badge != null)
                  Positioned(
                    right: -8,
                    top: -7,
                    child: Container(
                      width: 18,
                      height: 18,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF1428),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        badge!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w800,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            SizedBox(
              width: 58,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  maxLines: 1,
                  softWrap: false,
                  style: TextStyle(
                    color: color,
                    fontSize: 10.5,
                    fontFamily: 'Poppins',
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                    height: 1.1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CenterNavItem extends StatelessWidget {
  const _CenterNavItem({required this.selected, required this.onTap});

  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.translate(
              offset: const Offset(0, -15),
              child: Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0877FF), Color(0xFF0042D6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Dashboard.blue.withOpacity(0.35),
                      offset: const Offset(0, 8),
                      blurRadius: 18,
                    ),
                  ],
                ),
                child: const Icon(Icons.add_rounded,
                    color: Colors.white, size: 37),
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -12),
              child: SizedBox(
                width: 68,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'New Package',
                    maxLines: 1,
                    softWrap: false,
                    style: TextStyle(
                      color: selected ? Dashboard.blue : Dashboard.darkBlue,
                      fontSize: 10.5,
                      fontFamily: 'Poppins',
                      fontWeight:
                          selected ? FontWeight.w800 : FontWeight.w600,
                      height: 1.1,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
