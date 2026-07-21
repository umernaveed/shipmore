import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:we_ship_faas/app/core/get_di.dart';
import 'package:we_ship_faas/app/core/routes/app_pages.dart';
import 'package:we_ship_faas/app/extensions/string_ext.dart';
import 'package:we_ship_faas/data/models/all_authorize_users_response/all_authorize_users_response.dart';
import 'package:we_ship_faas/presentation/authorize/controllers/authorize_controller.dart';
import 'package:we_ship_faas/presentation/base_screen.dart';
import 'package:we_ship_faas/presentation/bottom_nav/controllers/bottom_nav_controller.dart';
import 'package:we_ship_faas/presentation/dashboard/views/dashboard.dart';
import 'package:we_ship_faas/presentation/widgets/shimmer_widget.dart';

class AuthorizeScreen extends GetView<AuthorizeController> {
  const AuthorizeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      showGradients: false,
      value: SystemUiOverlayStyle.dark,
      backgroundColor: Dashboard.pageBg,
      body: Column(
        children: [
          const _PageHeader(),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 14),
            child: _TopBar(controller: controller),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => Future.sync(
                () => controller.pagingController.refresh(),
              ),
              child: PagedListView<int, AuthorizeUsersResponse>.separated(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 126),
                pagingController: controller.pagingController,
                physics: const AlwaysScrollableScrollPhysics(),
                builderDelegate: PagedChildBuilderDelegate<AuthorizeUsersResponse>(
                  animateTransitions: true,
                  transitionDuration: 300.milliseconds,
                  itemBuilder: (context, item, index) => _AuthorizeCard(item),
                  firstPageProgressIndicatorBuilder: (_) => const _ListShimmer(),
                  noItemsFoundIndicatorBuilder: (_) =>
                      const _EmptyState('No authorize users found'),
                ),
                separatorBuilder: (context, index) => const SizedBox(height: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.controller});
  final AuthorizeController controller;
  @override
  Widget build(BuildContext context) {
    final id = find<BottomNavController>().bottomNavNestedID;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.textEditingController,
              onTapOutside: (_) => FocusScope.of(context).unfocus(),
              decoration: _searchDecoration('Search authorize users...'),
            ),
          ),
          const SizedBox(width: 12),
          InkWell(
            onTap: () => Get.toNamed(AppPages.addAuthorizeUser, id: id),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Dashboard.blue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.add_rounded, color: Colors.white, size: 31),
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthorizeCard extends StatelessWidget {
  const _AuthorizeCard(this.item);
  final AuthorizeUsersResponse item;
  @override
  Widget build(BuildContext context) {
    final id = find<BottomNavController>().bottomNavNestedID;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Row(
            children: [
              const _TileIcon(icon: Icons.person_outline_rounded, iconColor: Dashboard.blue, background: Color(0xFFF4E8FF)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Dashboard.darkBlue, fontSize: 18, fontFamily: 'Poppins', fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFEAF0F8)),
          const SizedBox(height: 14),
          _InfoRow('Created', item.createdAt.toDDMMYYYY, Icons.calendar_month_outlined),
          _InfoRow('Phone #', item.phone, Icons.phone_outlined),
          _InfoRow('ID/Proof', item.proof, Icons.badge_outlined),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _SmallButton(
                  label: 'Edit',
                  icon: Icons.edit_outlined,
                  color: Dashboard.blue,
                  onTap: () => Get.toNamed(
                    AppPages.addAuthorizeUser,
                    id: id,
                    arguments: item,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SmallButton(
                  label: 'Delete',
                  icon: Icons.delete_outline_rounded,
                  color: const Color(0xFFE94B4E),
                  onTap: () => find<AuthorizeController>()
                      .deleteAuthorizeUser(id: item.id.toString()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SmallButton extends StatelessWidget {
  const _SmallButton({required this.label, required this.icon, required this.color, required this.onTap});
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 46,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 7),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'Poppins', fontWeight: FontWeight.w800)),
          ]),
        ),
      );
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.label, this.value, this.icon);
  final String label;
  final String value;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(children: [
          _TileIcon(icon: icon, iconColor: Dashboard.blue, background: const Color(0xFFF4E8FF)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: _mutedStyle),
            const SizedBox(height: 2),
            Text(value.isEmpty ? '--' : value, maxLines: 1, overflow: TextOverflow.ellipsis, style: _strongStyle),
          ])),
        ]),
      );
}

class _PageHeader extends StatelessWidget {
  const _PageHeader();
  @override
  Widget build(BuildContext context) => SafeArea(
        bottom: false,
        child: SizedBox(
          height: 96,
          child: Stack(alignment: Alignment.center, children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 18),
                child: IconButton(
                  icon: const Icon(Icons.chevron_left_rounded),
                  color: Dashboard.darkBlue,
                  iconSize: 38,
                  onPressed: () => Get.back<void>(),
                ),
              ),
            ),
            const _LiteLogo(),
          ]),
        ),
      );
}

class _LiteLogo extends StatelessWidget {
  const _LiteLogo();
  @override
  Widget build(BuildContext context) => Column(mainAxisSize: MainAxisSize.min, children: [
        Row(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.end, children: [
          const CustomPaint(size: Size(34, 21), painter: _SpeedMarkPainter()),
          const SizedBox(width: 4),
          Text.rich(TextSpan(children: [
            const TextSpan(text: 'Herms', style: TextStyle(color: Dashboard.darkBlue)),
            TextSpan(text: '', style: TextStyle(color: Dashboard.blue)),
          ]), style: const TextStyle(fontSize: 24, fontFamily: 'Poppins', fontStyle: FontStyle.italic, fontWeight: FontWeight.w800, height: 0.95)),
        ]),
        const SizedBox(height: 6),
        Row(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 22, height: 1, color: Dashboard.darkBlue),
          const SizedBox(width: 8),
          const Text('C O U R I E R  L . T . D', style: TextStyle(color: Dashboard.darkBlue, fontSize: 8, fontFamily: 'Poppins', fontWeight: FontWeight.w600, letterSpacing: 3.2)),
          const SizedBox(width: 8),
          Container(width: 22, height: 1, color: Dashboard.darkBlue),
        ]),
      ]);
}

class _TileIcon extends StatelessWidget {
  const _TileIcon({required this.icon, required this.iconColor, required this.background});
  final IconData icon;
  final Color iconColor;
  final Color background;
  @override
  Widget build(BuildContext context) => Container(
        width: 42,
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: iconColor, size: 27),
      );
}

class _SpeedMarkPainter extends CustomPainter {
  const _SpeedMarkPainter();
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..strokeWidth = 3.2..strokeCap = StrokeCap.round..color = Dashboard.blue;
    final rows = [[0.00, 0.82], [0.14, 0.92], [0.28, 1.00], [0.42, 0.86]];
    for (var i = 0; i < rows.length; i++) {
      final y = size.height * (0.16 + (i * 0.22));
      canvas.drawLine(Offset(size.width * rows[i][0], y), Offset(size.width * rows[i][1], y), paint);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ListShimmer extends StatelessWidget {
  const _ListShimmer();
  @override
  Widget build(BuildContext context) => Column(children: [
        for (var i = 0; i < 3; i++) ...[
          ShimmerWidget(height: 210, width: double.infinity, radius: BorderRadius.circular(16), child: const SizedBox.shrink()),
          if (i != 2) const SizedBox(height: 14),
        ]
      ]);
}

class _EmptyState extends StatelessWidget {
  const _EmptyState(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Center(child: Padding(padding: const EdgeInsets.all(32), child: Text(text, style: _strongStyle)));
}

InputDecoration _searchDecoration(String hint) => InputDecoration(
      hintText: hint,
      prefixIcon: const Icon(Icons.search_rounded, color: Dashboard.blue, size: 29),
      filled: true,
      fillColor: const Color(0xFFF8FAFE),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
    );

BoxDecoration _cardDecoration() => BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: const Color(0xFFF0F4FA)),
      boxShadow: [BoxShadow(color: const Color(0xFF8CA7CA).withOpacity(0.12), offset: const Offset(0, 8), blurRadius: 20)],
    );

const _mutedStyle = TextStyle(color: Color(0xFF4D566B), fontSize: 12, fontFamily: 'Poppins', fontWeight: FontWeight.w500);
const _strongStyle = TextStyle(color: Dashboard.darkBlue, fontSize: 15, fontFamily: 'Poppins', fontWeight: FontWeight.w800);
