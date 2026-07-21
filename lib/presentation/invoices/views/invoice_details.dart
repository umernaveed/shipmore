import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:we_ship_faas/app/extensions/string_ext.dart';
import 'package:we_ship_faas/app/util/flush_snackbar.dart';
import 'package:we_ship_faas/data/models/invoice_detail/invoice_detail.dart';
import 'package:we_ship_faas/presentation/base_screen.dart';
import 'package:we_ship_faas/presentation/dashboard/views/dashboard.dart';
import 'package:we_ship_faas/presentation/invoices/controller/invoice_detail_controller.dart';
import 'package:we_ship_faas/presentation/widgets/shimmer_widget.dart';

class InvoiceDetails extends GetView<InvoiceDetailController> {
  const InvoiceDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    if (args is String) {
      controller.getInviceDetails(args);
    }

    return BaseScreen(
      wrapWithAnnotatedRegion: true,
      backgroundColor: Dashboard.pageBg,
      value: SystemUiOverlayStyle.dark,
      showGradients: false,
      body: controller.obx(
        onLoading: const _InvoiceDetailShimmer(),
        onError: (error) => const _InvoiceErrorState(),
        (state) {
          if (state == null) return const SizedBox.shrink();
          return CustomScrollView(
            physics: const ClampingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 8, 18, 126),
                  child: Column(
                    children: [
                      const _InvoiceHeader(),
                      _InvoiceHero(data: state),
                      const SizedBox(height: 14),
                      _BillToCard(data: state),
                      const SizedBox(height: 14),
                      _InfoGrid(data: state),
                      const SizedBox(height: 14),
                      _ChargesCard(data: state),
                      const SizedBox(height: 14),
                      _TimelineCard(data: state),
                      const SizedBox(height: 14),
                      _InvoiceActions(data: state),
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

class _InvoiceHeader extends StatelessWidget {
  const _InvoiceHeader();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SizedBox(
        height: 82,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.chevron_left_rounded),
                color: Dashboard.darkBlue,
                iconSize: 38,
                onPressed: () => Get.back<void>(),
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
                    text: 'SHIPMORE COURIERS',
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

class _InvoiceHero extends StatelessWidget {
  const _InvoiceHero({required this.data});

  final InvoiceDetailResponse data;

  @override
  Widget build(BuildContext context) {
    final paid = data.isPaid && !data.isNotPaid;
    final statusText = paid ? 'PAID' : 'UNPAID';
    final statusColor = paid ? const Color(0xFF16B86B) : const Color(0xFFFFC52E);

    return Container(
      height: 246,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6F3A91), Color(0xFF321548)],
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
          const Positioned.fill(child: CustomPaint(painter: _CardWavePainter())),
          const Positioned(
            right: 2,
            bottom: 18,
            child: _InvoiceIllustration(),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.receipt_long_outlined, color: Colors.white, size: 22),
                  SizedBox(width: 10),
                  Text(
                    'Invoice Details',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Spacer(),
                  Icon(Icons.more_vert_rounded, color: Colors.white, size: 27),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                '#${data.invoiceNo}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
              const SizedBox(height: 13),
              Row(
                children: [
                  const Icon(Icons.calendar_month_outlined,
                      color: Colors.white, size: 19),
                  const SizedBox(width: 8),
                  Text(
                    _dateText(data.datePaid),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 13),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    color: paid ? Colors.white : Dashboard.darkBlue,
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const Spacer(),
              const Text(
                'Total Amount',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _money(data.grandTotal),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BillToCard extends StatelessWidget {
  const _BillToCard({required this.data});

  final InvoiceDetailResponse data;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Row(
        children: [
          const _SectionIcon(
            icon: Icons.person_outline_rounded,
            color: Dashboard.blue,
            background: Colors.transparent,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionTitle('Bill To'),
                const SizedBox(height: 12),
                Text(
                  data.userName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                _MutedText('Account No: ${data.mailboxNo}'),
                const SizedBox(height: 4),
                _MutedText(data.email),
              ],
            ),
          ),
          Container(
            width: 54,
            height: 54,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xFFF4E8FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.mail_outline_rounded,
              color: Dashboard.blue,
              size: 27,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoGrid extends StatelessWidget {
  const _InfoGrid({required this.data});

  final InvoiceDetailResponse data;

  @override
  Widget build(BuildContext context) {
    final primary = data.invoiceDetail.isEmpty ? null : data.invoiceDetail.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  _SectionIcon(
                    icon: Icons.business_rounded,
                    color: Dashboard.blue,
                    background: Colors.transparent,
                  ),
                  SizedBox(width: 10),
                  Expanded(child: _SectionTitle('Company Details')),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                data.companyName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Dashboard.blue,
                  fontSize: 15,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              _MutedText(data.localAddress),
              const SizedBox(height: 15),
              Row(
                children: [
                  const Icon(Icons.phone_rounded,
                      color: Dashboard.blue, size: 18),
                  const SizedBox(width: 8),
                  Expanded(child: _MutedText(data.phone)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  _SectionIcon(
                    icon: Icons.inventory_2_outlined,
                    color: Dashboard.blue,
                    background: Colors.transparent,
                  ),
                  SizedBox(width: 10),
                  Expanded(child: _SectionTitle('Shipment Details')),
                ],
              ),
              const SizedBox(height: 16),
              _KeyValueRow('HAWB', primary?.manifestNo ?? ''),
              _KeyValueRow('Weight', '${primary?.packageWeight ?? 0} lbs'),
              _KeyValueRow('Freight Type', _freightName(data.freightType)),
              _KeyValueRow('Description', primary?.packageDescription ?? ''),
            ],
          ),
        ),
      ],
    );
  }
}

class _ChargesCard extends StatelessWidget {
  const _ChargesCard({required this.data});

  final InvoiceDetailResponse data;

  @override
  Widget build(BuildContext context) {
    final details = data.invoiceDetail;
    final additionalFees = data.additionalFee ?? [];

    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              _RoundIcon(icon: Icons.attach_money_rounded),
              SizedBox(width: 12),
              _SectionTitle('Charges Breakdown'),
            ],
          ),
          const SizedBox(height: 16),
          _ChargeRow(
            label: _freightName(data.freightType),
            amount: _money(_sum(details.map((e) => e.packagePrice))),
          ),
          _ChargeRow(
            label: 'Service Fee',
            amount: _money(_sum(details.map((e) => e.serviceFee))),
          ),
          _ChargeRow(
            label: 'Custom Fee',
            amount: _money(_sum(details.map((e) => e.customFee))),
          ),
          _ChargeRow(label: 'GCT', amount: _money(data.gstTotal)),
          for (final fee in additionalFees)
            _ChargeRow(label: fee.name, amount: _money(fee.serviceFee)),
          if (_asDouble(data.discountPrice) > 0)
            _ChargeRow(label: 'Discount', amount: '- ${_money(data.discountPrice)}'),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF4E8FF),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Total Amount',
                    style: TextStyle(
                      color: Dashboard.blue,
                      fontSize: 15,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Text(
                  _money(data.grandTotal),
                  style: const TextStyle(
                    color: Dashboard.blue,
                    fontSize: 19,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineCard extends StatelessWidget {
  const _TimelineCard({required this.data});

  final InvoiceDetailResponse data;

  @override
  Widget build(BuildContext context) {
    final paid = data.isPaid && !data.isNotPaid;

    return _Card(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionIcon(
            icon: Icons.schedule_rounded,
            color: Dashboard.blue,
            background: Colors.transparent,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionTitle('Invoice Timeline'),
                const SizedBox(height: 16),
                _TimelineStep(
                  active: true,
                  title: 'Invoice Created',
                  subtitle: _dateText(data.datePaid),
                  showLine: true,
                ),
                _TimelineStep(
                  active: paid,
                  title: paid ? 'Payment Completed' : 'Payment Pending',
                  subtitle: paid ? _dateText(data.datePaid) : '',
                  showLine: true,
                ),
                _TimelineStep(
                  active: paid,
                  title: 'Package Released',
                  subtitle: '',
                  showLine: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InvoiceActions extends StatelessWidget {
  const _InvoiceActions({required this.data});

  final InvoiceDetailResponse data;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            icon: Icons.download_rounded,
            label: 'Download PDF',
            onTap: () => FlushSnackbar.showSnackBar(
              'PDF download is not available for this invoice',
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ActionButton(
            icon: Icons.share_outlined,
            label: 'Share Invoice',
            onTap: () async {
              await Clipboard.setData(
                ClipboardData(
                  text: 'Invoice #${data.invoiceNo} - ${_money(data.grandTotal)}',
                ),
              );
              FlushSnackbar.showSnackBar('Invoice details copied');
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ActionButton(
            icon: Icons.headset_mic_outlined,
            label: 'Contact Support',
            onTap: () => FlushSnackbar.showSnackBar(
              data.siteEmail.isEmpty ? data.phone : data.siteEmail,
            ),
          ),
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child, this.minHeight});

  final Widget child;
  final double? minHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: minHeight ?? 0),
      padding: const EdgeInsets.all(18),
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
      child: child,
    );
  }
}

class _SectionIcon extends StatelessWidget {
  const _SectionIcon({
    required this.icon,
    required this.color,
    required this.background,
  });

  final IconData icon;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: color, size: 25),
    );
  }
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Dashboard.blue,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: Dashboard.darkBlue,
        fontSize: 15,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _MutedText extends StatelessWidget {
  const _MutedText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: Color(0xFF4D566B),
        fontSize: 14,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
        height: 1.3,
      ),
    );
  }
}

class _KeyValueRow extends StatelessWidget {
  const _KeyValueRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 104,
            child: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 13,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                height: 1.25,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 13,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChargeRow extends StatelessWidget {
  const _ChargeRow({required this.label, required this.amount});

  final String label;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            amount,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineStep extends StatelessWidget {
  const _TimelineStep({
    required this.active,
    required this.title,
    required this.subtitle,
    required this.showLine,
  });

  final bool active;
  final String title;
  final String subtitle;
  final bool showLine;

  @override
  Widget build(BuildContext context) {
    final color = active ? Dashboard.blue : const Color(0xFF9BA6B9);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                color: active ? Dashboard.blue : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 2),
              ),
            ),
            if (showLine)
              Container(width: 2, height: 27, color: const Color(0xFFD6DDE8)),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Dashboard.darkBlue,
                    fontSize: 13,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (subtitle.isNotEmpty)
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFF4D566B),
                      fontSize: 12,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
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
      child: Container(
        height: 58,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFF0F4FA)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF8CA7CA).withOpacity(0.10),
              offset: const Offset(0, 6),
              blurRadius: 16,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Dashboard.blue, size: 22),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Dashboard.darkBlue,
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InvoiceIllustration extends StatelessWidget {
  const _InvoiceIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 124,
      height: 118,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            right: 16,
            top: 5,
            child: Container(
              width: 28,
              height: 48,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFB6D0FF), Color(0xFF5E94F2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(14),
                ),
              ),
            ),
          ),
          Positioned(
            top: 4,
            child: Container(
              width: 78,
              height: 94,
              decoration: BoxDecoration(
                color: const Color(0xFFF8F1FB),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.10),
                    blurRadius: 16,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _PaperLine(width: 50),
                  _PaperLine(width: 34),
                  _PaperLine(width: 50),
                  _PaperLine(width: 34),
                  _PaperLine(width: 22),
                ],
              ),
            ),
          ),
          Positioned(
            left: 8,
            bottom: 12,
            child: Container(
              width: 88,
              height: 29,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFB9D4FF), Color(0xFF7AA8FA)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 2,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF5A91F5),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: const Icon(Icons.check_rounded,
                  color: Colors.white, size: 31),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaperLine extends StatelessWidget {
  const _PaperLine({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 6,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF9DC0F8),
        borderRadius: BorderRadius.circular(4),
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

class _CardWavePainter extends CustomPainter {
  const _CardWavePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (var i = 0; i < 22; i++) {
      final path = Path()
        ..moveTo(size.width * 0.36, size.height * (0.34 + i * 0.018))
        ..cubicTo(
          size.width * 0.55,
          size.height * (0.12 + i * 0.018),
          size.width * 0.67,
          size.height * (0.74 - i * 0.010),
          size.width * 1.04,
          size.height * (0.46 + i * 0.014),
        );
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _InvoiceErrorState extends StatelessWidget {
  const _InvoiceErrorState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Text(
          'Something went wrong. Please try again later.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Dashboard.darkBlue,
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _InvoiceDetailShimmer extends StatelessWidget {
  const _InvoiceDetailShimmer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 98, 18, 18),
      child: Column(
        children: [
          ShimmerWidget(
            height: 206,
            radius: BorderRadius.circular(18),
            width: double.infinity,
            child: const SizedBox.shrink(),
          ),
          const SizedBox(height: 14),
          for (final height in [118.0, 172.0, 228.0, 150.0])
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: ShimmerWidget(
                height: height,
                radius: BorderRadius.circular(16),
                width: double.infinity,
                child: const SizedBox.shrink(),
              ),
            ),
        ],
      ),
    );
  }
}

String _dateText(String value) {
  if (value.trim().isEmpty) return '--';
  return value.toDDMMYYYY;
}

String _freightName(String freightType) {
  if (freightType.toLowerCase() == 'we_ship_faas') {
    return 'Regular Air Freight';
  }
  if (freightType.trim().isEmpty) return 'Regular Air Freight';
  return 'Express Air Freight';
}

String _money(String value) {
  final amount = value.trim().isEmpty ? '0.00' : value.trim();
  if (amount.toUpperCase().contains('JMD')) return amount;
  return 'JMD $amount';
}

String _sum(Iterable<String> values) {
  final total = values.fold<double>(0, (sum, value) => sum + _asDouble(value));
  return total.toStringAsFixed(2);
}

double _asDouble(String value) {
  final cleaned = value.replaceAll(',', '').replaceAll('JMD', '').trim();
  return double.tryParse(cleaned) ?? 0;
}
