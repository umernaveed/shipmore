import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:we_ship_faas/presentation/virtual_pay/virtual_pay_button_widget.dart';
import 'package:we_ship_faas/presentation/virtual_pay/virtual_pay_service.dart';

/// Virtual Pay section: keeps the WebView alive across rebuilds.
///
/// Pass [payload] with the 9 data-attribute fields (accountName, invoiceNumber,
/// invoiceAmount, currency, firstName, lastName, contactNumber, email, passed).
/// [onPayNowPressed] receives the checkout URL so the parent can open the full-screen page.
class VirtualPaySection extends StatefulWidget {
  const VirtualPaySection({
    super.key,
    required this.payload,
    this.returnUrl =
        'https://shipmoretrackingja.com/payment/success',
    this.buttonKey,
    this.onPayNowPressed,
  });

  /// Payload matching data-account-name, data-invoice-number, data-invoice-amount,
  /// data-currency, data-first-name, data-last-name, data-contact-number,
  /// data-email, data-passed.
  final VirtualPayPayload payload;

  final String returnUrl;
  final Key? buttonKey;
  final void Function(String? checkoutUrl)? onPayNowPressed;

  @override
  State<VirtualPaySection> createState() => _VirtualPaySectionState();
}

class _VirtualPaySectionState extends State<VirtualPaySection>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final amountJmdStr = widget.payload.invoiceAmount
        .replaceAll('JMD', '')
        .replaceAll(',', '')
        .trim();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.2.w),
      child: VirtualPayButtonWidget(
        key: widget.buttonKey ?? const ValueKey('virtual_pay_section'),
        accountName: widget.payload.accountName,
        invoiceNumber: widget.payload.invoiceNumber,
        invoiceAmount: amountJmdStr.isEmpty ? '0' : amountJmdStr,
        currency: widget.payload.currency,
        firstName: widget.payload.firstName,
        lastName: widget.payload.lastName,
        contactNumber: widget.payload.contactNumber,
        email: widget.payload.email,
        passed: widget.payload.passed,
        returnUrl: widget.returnUrl,
        height: 120,
        onPayNowPressed: widget.onPayNowPressed,
      ),
    );
  }
}
