import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:we_ship_faas/app/core/routes/app_pages.dart';

/// Payload for Virtual Pay, matching the widget data attributes:
/// data-account-name, data-invoice-number, data-invoice-amount, data-currency,
/// data-first-name, data-last-name, data-contact-number, data-email, data-passed.
class VirtualPayPayload {
  const VirtualPayPayload({
    this.accountName = 'blue_peak_digital',
    required this.invoiceNumber,
    required this.invoiceAmount,
    this.currency = 'JMD',
    required this.firstName,
    required this.lastName,
    required this.contactNumber,
    required this.email,
    this.passed = 'mass',
  });

  final String accountName;
  final String invoiceNumber;
  final String invoiceAmount;
  final String currency;
  final String firstName;
  final String lastName;
  final String contactNumber;
  final String email;
  final String passed;
}

/// Service for opening the Virtual Pay full-screen page and handling navigation.
class VirtualPayService {
  VirtualPayService._();

  static const String returnUrl =
      'https://hermsjamaica.com/payment/success';

  static final VirtualPayService _instance = VirtualPayService._();

  static VirtualPayService get instance => _instance;

  /// Opens the Virtual Pay page. [payload] holds invoice and user data.
  /// Pass [checkoutUrl] when the user tapped Pay Now so the page loads the payment form.
  /// [onResult] is called with the page result: 1 = success, -1 = canceled, null = other.
  Future<void> openVirtualPayPage(
    BuildContext context, {
    required VirtualPayPayload payload,
    String? checkoutUrl,
    void Function(int? result)? onResult,
  }) async {
    final result = await Get.toNamed(
      AppPages.virtualPayPage,
      arguments: {
        'accountName': payload.accountName,
        'invoiceNumber': payload.invoiceNumber,
        'invoiceAmount':
            payload.invoiceAmount.isEmpty ? '0' : payload.invoiceAmount,
        'currency': payload.currency,
        'firstName': payload.firstName,
        'lastName': payload.lastName,
        'contactNumber': payload.contactNumber,
        'email': payload.email,
        'passed': payload.passed,
        'returnUrl': returnUrl,
        if (checkoutUrl != null && checkoutUrl.isNotEmpty)
          'checkoutUrl': checkoutUrl,
      },
    );
    final int? resultValue = result is int ? result : null;
    onResult?.call(resultValue);
  }
}
