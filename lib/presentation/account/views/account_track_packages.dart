import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:we_ship_faas/app/extensions/string_ext.dart';
import 'package:we_ship_faas/data/models/get_all_package/get_all_package.dart';
import 'package:we_ship_faas/presentation/account/controllers/get_delivery_packages_controller.dart';
import 'package:we_ship_faas/presentation/base_screen.dart';
import 'package:we_ship_faas/presentation/dashboard/views/dashboard.dart';
import 'package:we_ship_faas/presentation/widgets/shimmer_widget.dart';

class AccountTrackePackages extends GetView<AllDeliveryPackagesController> {
  const AccountTrackePackages({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      wrapWithAnnotatedRegion: true,
      value: SystemUiOverlayStyle.dark,
      backgroundColor: Dashboard.pageBg,
      showGradients: false,
      body: Column(
        children: [
          const _PackagesHeader(),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 14),
            child: _PackageSearchBar(controller: controller),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => Future.sync(
                () => controller.pagingController.refresh(),
              ),
              child: PagedListView<int, GetAllPackage>.separated(
                pagingController: controller.pagingController,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 126),
                builderDelegate: PagedChildBuilderDelegate<GetAllPackage>(
                  animateTransitions: true,
                  transitionDuration: 300.milliseconds,
                  itemBuilder: (context, item, index) =>
                      _PackageCard(item: item),
                  firstPageProgressIndicatorBuilder: (_) =>
                      const _PackageListShimmer(),
                  newPageProgressIndicatorBuilder: (_) => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 18),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  noItemsFoundIndicatorBuilder: (_) => const _EmptyPackages(),
                ),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PackagesHeader extends StatelessWidget {
  const _PackagesHeader();

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
            const SizedBox(width: 4),
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
                fontSize: 24,
                fontFamily: 'Poppins',
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w800,
                height: 0.95,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 22, height: 1, color: Dashboard.darkBlue),
            const SizedBox(width: 8),
            const Text(
              'C O U R I E R  L . T . D',
              style: TextStyle(
                color: Dashboard.darkBlue,
                fontSize: 8,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                letterSpacing: 3.2,
              ),
            ),
            const SizedBox(width: 8),
            Container(width: 22, height: 1, color: Dashboard.darkBlue),
          ],
        ),
      ],
    );
  }
}

class _PackageSearchBar extends StatelessWidget {
  const _PackageSearchBar({required this.controller});

  final AllDeliveryPackagesController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.textEditingController,
              onTapOutside: (event) => FocusScope.of(context).unfocus(),
              decoration: InputDecoration(
                hintText: 'Search by HAWB, carrier, package...',
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: Dashboard.blue,
                  size: 29,
                ),
                filled: true,
                fillColor: const Color(0xFFF8FAFE),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Dashboard.blue),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                hintStyle: const TextStyle(
                  color: Color(0xFF777E98),
                  fontSize: 15,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: const TextStyle(
                color: Dashboard.darkBlue,
                fontSize: 15,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFF4E8FF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE7D2FA)),
            ),
            child: const Icon(
              Icons.filter_alt_outlined,
              color: Dashboard.blue,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}

class _PackageCard extends StatelessWidget {
  const _PackageCard({required this.item});

  final GetAllPackage item;

  @override
  Widget build(BuildContext context) {
    final title = item.manifestNo.isNotEmpty
        ? 'HAWB: ${item.manifestNo}'
        : 'Package: ${item.pkNo}';

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const _TileIcon(
                icon: Icons.inventory_2_outlined,
                iconColor: Dashboard.blue,
                background: Color(0xFFF4E8FF),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
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
              const SizedBox(width: 10),
              _StatusBadge(status: item.statusName),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, thickness: 1, color: Color(0xFFEAF0F8)),
          const SizedBox(height: 16),
          _InfoRow(
            icon: Icons.calendar_month_outlined,
            iconColor: Dashboard.blue,
            background: const Color(0xFFF4E8FF),
            label: 'Date',
            value: _dateText(item.createdAt),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _InfoRow(
                  icon: Icons.scale_outlined,
                  iconColor: const Color(0xFF6925D7),
                  background: const Color(0xFFF2E9FF),
                  label: 'Weight',
                  value: _value(item.weight),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _InfoRow(
                  icon: Icons.format_list_numbered_rounded,
                  iconColor: const Color(0xFF0EAA66),
                  background: const Color(0xFFE9F9F1),
                  label: 'Quantity',
                  value: _value(item.quantity),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _InfoRow(
            icon: Icons.local_shipping_outlined,
            iconColor: const Color(0xFFF08B10),
            background: const Color(0xFFFFF3E4),
            label: 'Carrier',
            value: item.courier,
          ),
          const SizedBox(height: 12),
          _InfoRow(
            icon: Icons.confirmation_number_outlined,
            iconColor: Dashboard.blue,
            background: const Color(0xFFF4E8FF),
            label: 'Carrier Tracking No',
            value: item.trackingNo.isNotEmpty
                ? item.trackingNo
                : item.supplierTrackingNo,
          ),
          const SizedBox(height: 12),
          _InfoRow(
            icon: Icons.description_outlined,
            iconColor: const Color(0xFF6925D7),
            background: const Color(0xFFF2E9FF),
            label: 'Description',
            value: item.itemDescription,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.iconColor,
    required this.background,
    required this.label,
    required this.value,
    this.maxLines = 1,
  });

  final IconData icon;
  final Color iconColor;
  final Color background;
  final String label;
  final String value;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _TileIcon(icon: icon, iconColor: iconColor, background: background),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF4D566B),
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value.isEmpty ? '--' : value,
                maxLines: maxLines,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Dashboard.darkBlue,
                  fontSize: 15,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ],
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
      width: 42,
      height: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: iconColor, size: 27),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final text = status.trim().isEmpty ? 'Package' : status.trim();
    final ready = text.toLowerCase().contains('ready') ||
        text.toLowerCase().contains('pickup');
    final color = ready ? const Color(0xFF16B86B) : Dashboard.blue;
    final background = ready ? const Color(0xFFE8F8EF) : const Color(0xFFF4E8FF);

    return Container(
      constraints: const BoxConstraints(maxWidth: 116),
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: color,
          fontSize: 13,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w800,
        ),
      ),
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

class _PackageListShimmer extends StatelessWidget {
  const _PackageListShimmer();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < 3; i++) ...[
          ShimmerWidget(
            height: 292,
            width: double.infinity,
            radius: BorderRadius.circular(16),
            child: const SizedBox.shrink(),
          ),
          if (i != 2) const SizedBox(height: 14),
        ],
      ],
    );
  }
}

class _EmptyPackages extends StatelessWidget {
  const _EmptyPackages();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Text(
          'No packages found',
          style: TextStyle(
            color: Dashboard.darkBlue,
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

BoxDecoration _cardDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: const Color(0xFFF0F4FA)),
    boxShadow: [
      BoxShadow(
        color: const Color(0xFF8CA7CA).withOpacity(0.12),
        offset: const Offset(0, 8),
        blurRadius: 20,
      ),
    ],
  );
}

String _dateText(String value) {
  if (value.trim().isEmpty) return '--';
  return value.toDDMMYYYY;
}

String _value(dynamic value) {
  final text = value?.toString().trim() ?? '';
  return text.isEmpty ? '--' : text;
}
