import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:we_ship_faas/app/core/get_di.dart';
import 'package:we_ship_faas/app/core/routes/app_pages.dart';
import 'package:we_ship_faas/app/extensions/string_ext.dart';
import 'package:we_ship_faas/data/models/invoice/invoice.dart';
import 'package:we_ship_faas/presentation/base_screen.dart';
import 'package:we_ship_faas/presentation/bottom_nav/controllers/bottom_nav_controller.dart';
import 'package:we_ship_faas/presentation/dashboard/views/dashboard.dart';
import 'package:we_ship_faas/presentation/invoices/controller/invoices_controller.dart';
import 'package:we_ship_faas/presentation/widgets/shimmer_widget.dart';

class InvoicesScreen extends GetView<InvoicesController> {
  const InvoicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      wrapWithAnnotatedRegion: true,
      backgroundColor: Dashboard.pageBg,
      value: SystemUiOverlayStyle.dark,
      showGradients: false,
      body: Column(
        children: [
          const _InvoicesHeader(),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 14),
            child: _InvoiceSearchBar(controller: controller),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => Future.sync(
                () => controller.pagingController.refresh(),
              ),
              child: PagedListView<int, Invoice>.separated(
                pagingController: controller.pagingController,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 22),
                builderDelegate: PagedChildBuilderDelegate<Invoice>(
                  animateTransitions: true,
                  transitionDuration: 300.milliseconds,
                  itemBuilder: (context, item, index) {
                    return _InvoiceCard(invoice: item);
                  },
                  firstPageProgressIndicatorBuilder: (_) =>
                      const _InvoiceListShimmer(),
                  newPageProgressIndicatorBuilder: (_) => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 18),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  noItemsFoundIndicatorBuilder: (_) => const _EmptyInvoices(),
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

class _InvoicesHeader extends StatelessWidget {
  const _InvoicesHeader();

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
                  onPressed: () {
                    final bottomNavNestedID =
                        find<BottomNavController>().bottomNavNestedID;
                    Get.back<void>(id: bottomNavNestedID);
                  },
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

class _InvoiceSearchBar extends StatelessWidget {
  const _InvoiceSearchBar({required this.controller});

  final InvoicesController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
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
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.textEditingController,
              onTapOutside: (event) => FocusScope.of(context).unfocus(),
              decoration: InputDecoration(
                hintText: 'Search by invoice no, user name...',
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
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 13,
                ),
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

class _InvoiceCard extends StatelessWidget {
  const _InvoiceCard({required this.invoice});

  final Invoice invoice;

  @override
  Widget build(BuildContext context) {
    final status = invoice.status.trim().isEmpty ? 'Unpaid' : invoice.status;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
      decoration: BoxDecoration(
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
      ),
      child: Column(
        children: [
          Row(
            children: [
              const _TileIcon(
                icon: Icons.receipt_long_outlined,
                iconColor: Dashboard.blue,
                background: Color(0xFFF4E8FF),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  'Invoice #${invoice.invoiceNo}',
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
              _StatusBadge(status: status),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, thickness: 1, color: Color(0xFFEAF0F8)),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    _InvoiceInfoRow(
                      icon: Icons.calendar_month_outlined,
                      iconColor: Dashboard.blue,
                      background: const Color(0xFFF4E8FF),
                      label: 'Date Created',
                      value: _dateText(invoice.createdAt),
                    ),
                    const SizedBox(height: 14),
                    _InvoiceInfoRow(
                      icon: Icons.request_quote_outlined,
                      iconColor: const Color(0xFF6925D7),
                      background: const Color(0xFFF2E9FF),
                      label: 'Invoice Paid',
                      value: _money(invoice.totalPaid),
                    ),
                    const SizedBox(height: 14),
                    _InvoiceInfoRow(
                      icon: Icons.account_balance_wallet_outlined,
                      iconColor: const Color(0xFF0EAA66),
                      background: const Color(0xFFE9F9F1),
                      label: 'Invoice Unpaid',
                      value: _money(invoice.totalInvoice),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 150,
                margin: const EdgeInsets.symmetric(horizontal: 14),
                color: const Color(0xFFE1E7F0),
              ),
              Expanded(
                child: Column(
                  children: [
                    _InvoiceInfoRow(
                      icon: Icons.event_available_outlined,
                      iconColor: const Color(0xFF13AF66),
                      background: const Color(0xFFE9F9F1),
                      label: 'Date Paid',
                      value: _dateText(invoice.datePaid),
                    ),
                    const SizedBox(height: 14),
                    _InvoiceInfoRow(
                      icon: Icons.person_outline_rounded,
                      iconColor: const Color(0xFF6925D7),
                      background: const Color(0xFFF2E9FF),
                      label: 'User Name',
                      value: invoice.userName,
                    ),
                    const SizedBox(height: 14),
                    _InvoiceInfoRow(
                      icon: Icons.check_circle_outline_rounded,
                      iconColor: Dashboard.blue,
                      background: const Color(0xFFF4E8FF),
                      label: 'Paid Status',
                      customValue: _StatusBadge(status: status, compact: true),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _InvoiceDetailButton(invoice: invoice),
        ],
      ),
    );
  }
}

class _InvoiceInfoRow extends StatelessWidget {
  const _InvoiceInfoRow({
    required this.icon,
    required this.iconColor,
    required this.background,
    required this.label,
    this.value,
    this.customValue,
  });

  final IconData icon;
  final Color iconColor;
  final Color background;
  final String label;
  final String? value;
  final Widget? customValue;

  @override
  Widget build(BuildContext context) {
    return Row(
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
              customValue ??
                  Text(
                    value ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Dashboard.darkBlue,
                      fontSize: 15,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w800,
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
  const _StatusBadge({required this.status, this.compact = false});

  final String status;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final paid = status.toLowerCase().contains('paid') &&
        !status.toLowerCase().contains('unpaid');
    final color = paid ? const Color(0xFF16B86B) : Dashboard.blue;
    final background = paid ? const Color(0xFFE8F8EF) : const Color(0xFFF4E8FF);

    return Container(
      height: compact ? 27 : 34,
      padding: EdgeInsets.symmetric(horizontal: compact ? 9 : 12),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: compact ? color : background,
        borderRadius: BorderRadius.circular(compact ? 5 : 8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (compact) ...[
            const Icon(Icons.check_rounded, color: Colors.white, size: 16),
            const SizedBox(width: 4),
          ],
          Text(
            status,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: compact ? Colors.white : color,
              fontSize: compact ? 13 : 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _InvoiceDetailButton extends StatelessWidget {
  const _InvoiceDetailButton({required this.invoice});

  final Invoice invoice;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final bottomNavNestedID = find<BottomNavController>().bottomNavNestedID;
        Get.toNamed(
          AppPages.invoiceDetails,
          id: bottomNavNestedID,
          arguments: invoice.invoiceNo.toString(),
        );
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0877FF), Color(0xFF0042D6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Dashboard.blue.withOpacity(0.25),
              offset: const Offset(0, 7),
              blurRadius: 18,
            ),
          ],
        ),
        child: const Row(
          children: [
            Spacer(),
            Text(
              'Invoice Detail',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w800,
              ),
            ),
            Spacer(),
            Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 30),
          ],
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

class _InvoiceListShimmer extends StatelessWidget {
  const _InvoiceListShimmer();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < 3; i++) ...[
          _ShimmerCard(height: 318),
          if (i != 2) const SizedBox(height: 14),
        ],
      ],
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  const _ShimmerCard({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return ShimmerWidget(
      height: height,
      width: double.infinity,
      radius: BorderRadius.circular(16),
      child: const SizedBox.shrink(),
    );
  }
}

class _EmptyInvoices extends StatelessWidget {
  const _EmptyInvoices();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Text(
          'No invoices found',
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

String _dateText(String value) {
  if (value.trim().isEmpty) return '--';
  return value.toDDMMYYYY;
}

String _money(dynamic value) {
  final text = value?.toString().trim() ?? '';
  if (text.isEmpty) return '0.00 JMD';
  if (text.toUpperCase().contains('JMD')) return text;
  return '$text JMD';
}
