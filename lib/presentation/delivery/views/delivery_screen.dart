import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:we_ship_faas/app/core/get_di.dart';
import 'package:we_ship_faas/app/core/routes/app_pages.dart';
import 'package:we_ship_faas/app/extensions/string_ext.dart';
import 'package:we_ship_faas/data/models/get_all_package/get_all_package.dart';
import 'package:we_ship_faas/presentation/auth/views/login_screen.dart';
import 'package:we_ship_faas/presentation/base_screen.dart';
import 'package:we_ship_faas/presentation/bottom_nav/controllers/bottom_nav_controller.dart';
import 'package:we_ship_faas/presentation/dashboard/views/dashboard.dart';
import 'package:we_ship_faas/presentation/delivery/controllers/delivery_controller.dart';
import 'package:we_ship_faas/presentation/widgets/shimmer_widget.dart';

class DeliveryScreen extends GetView<DeliveryController> {
  const DeliveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      showGradients: false,
      value: SystemUiOverlayStyle.dark,
      backgroundColor: Dashboard.pageBg,
      body: Column(
        children: [
          const _PageHeader(title: 'Request Delivery'),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 14),
            child: _SearchBar(controller: controller),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => Future.sync(controller.onRefresh),
              child: GetBuilder<DeliveryController>(
                id: 'delivery',
                builder: (_) {
                  return PagedListView<int, GetAllPackage>.separated(
                    pagingController: controller.pagingController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 190),
                    builderDelegate: PagedChildBuilderDelegate<GetAllPackage>(
                      itemBuilder: (context, item, index) => _DeliveryCard(
                        item: item,
                        onChanged: (_) => controller.onItemChecked(item),
                      ),
                      firstPageProgressIndicatorBuilder: (_) =>
                          const _ListShimmer(),
                      noItemsFoundIndicatorBuilder: (_) =>
                          const _EmptyState('No delivery packages found'),
                    ),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 14),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
          child: _DeliverySummary(controller: controller),
        ),
      ),
    );
  }
}

class _DeliveryCard extends StatelessWidget {
  const _DeliveryCard({required this.item, required this.onChanged});

  final GetAllPackage item;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Row(
            children: [
              Checkbox(
                value: item.isToggleOn,
                activeColor: Dashboard.blue,
                onChanged: (value) {
                  item.isToggleOn = value ?? false;
                  onChanged(value);
                },
              ),
              const SizedBox(width: 4),
              const _TileIcon(
                icon: Icons.local_shipping_outlined,
                iconColor: Dashboard.blue,
                background: Color(0xFFF4E8FF),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'HAWB: ${item.manifestNo}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Dashboard.darkBlue,
                    fontSize: 18,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFEAF0F8)),
          const SizedBox(height: 14),
          _InfoRow('Date', item.createdAt.toDDMMYYYY, Icons.calendar_month_outlined),
          _InfoRow('Name', item.userName, Icons.person_outline_rounded),
          _InfoRow('Supplier', item.courier, Icons.storefront_outlined),
          _InfoRow('Tracking', item.supplierTrackingNo, Icons.confirmation_number_outlined),
          _InfoRow('Description', item.itemDescription, Icons.description_outlined,
              maxLines: 2),
          _InfoRow('Package Amount', _money(item.packageInvoice), Icons.payments_outlined),
        ],
      ),
    );
  }
}

class _DeliverySummary extends StatelessWidget {
  const _DeliverySummary({required this.controller});

  final DeliveryController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(
            () => Row(
              children: [
                Expanded(child: _SummaryValue('Packages', '${controller.selectedItems.length}')),
                Container(width: 1, height: 38, color: const Color(0xFFEAF0F8)),
                Expanded(child: _SummaryValue('Total Amount', _money(controller.totalAmount.value))),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  title: 'Clear',
                  onTap: controller.onClear,
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Color(0xFFD8E1EF)),
                  textColor: Dashboard.darkBlue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: Obx(() {
                  final count = controller.selectedItems.length;
                  return AppButton(
                    title: 'Create Request',
                    onTap: count <= 0
                        ? null
                        : () {
                            final id = find<BottomNavController>().bottomNavNestedID;
                            Get.toNamed(AppPages.managePickupRequest, id: id);
                          },
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryValue extends StatelessWidget {
  const _SummaryValue(this.label, this.value);
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: _mutedStyle),
        const SizedBox(height: 3),
        Text(value, style: _strongStyle, maxLines: 1, overflow: TextOverflow.ellipsis),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.label, this.value, this.icon, {this.maxLines = 1});
  final String label;
  final String? value;
  final IconData icon;
  final int maxLines;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          _TileIcon(icon: icon, iconColor: Dashboard.blue, background: const Color(0xFFF4E8FF)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: _mutedStyle),
                const SizedBox(height: 2),
                Text((value ?? '').isEmpty ? '--' : value!,
                    maxLines: maxLines, overflow: TextOverflow.ellipsis, style: _strongStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller});
  final DeliveryController controller;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: TextField(
        controller: controller.textEditingController,
        onTapOutside: (_) => FocusScope.of(context).unfocus(),
        decoration: _searchDecoration('Search delivery packages...'),
      ),
    );
  }
}

class _PageHeader extends StatelessWidget {
  const _PageHeader({required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SizedBox(
        height: 96,
        child: Stack(
          alignment: Alignment.center,
          children: [
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
    return Column(mainAxisSize: MainAxisSize.min, children: [
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
          ShimmerWidget(height: 310, width: double.infinity, radius: BorderRadius.circular(16), child: const SizedBox.shrink()),
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

String _money(dynamic value) {
  final text = value?.toString().trim() ?? '';
  if (text.isEmpty) return 'JMD 0.00';
  if (text.toUpperCase().contains('JMD')) return text;
  return 'JMD $text';
}

const _mutedStyle = TextStyle(color: Color(0xFF4D566B), fontSize: 12, fontFamily: 'Poppins', fontWeight: FontWeight.w500);
const _strongStyle = TextStyle(color: Dashboard.darkBlue, fontSize: 15, fontFamily: 'Poppins', fontWeight: FontWeight.w800);
