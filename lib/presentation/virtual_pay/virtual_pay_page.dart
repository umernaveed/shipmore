import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:we_ship_faas/presentation/virtual_pay/virtual_pay_button_widget.dart';

/// Full-screen Virtual Pay page. Loads [checkoutUrl] when provided (payment
/// form), otherwise the widget HTML (button). Listens for success/failure URLs.
class VirtualPayPage extends StatefulWidget {
  const VirtualPayPage({super.key});

  @override
  State<VirtualPayPage> createState() => _VirtualPayPageState();
}

class _VirtualPayPageState extends State<VirtualPayPage> {
  final ValueNotifier<double> _loadingProgress = ValueNotifier<double>(0);

  static const String _successUrl =
      'https://hermsjamaica.com/payment/success';
  static const String _failedUrl =
      'https://hermsjamaica.com/payment/failed';

  static final _webViewSettings = InAppWebViewSettings(
    transparentBackground: false,
    disableContextMenu: true,
    supportZoom: false,
    useWideViewPort: true,
    javaScriptEnabled: true,
    domStorageEnabled: true,
  );

  void _onUrlChanged(WebUri? url) {
    final urlStr = url?.toString().toLowerCase() ?? '';
    if (urlStr == _successUrl.toLowerCase()) {
      Get.back(result: 1);
    } else if (urlStr == _failedUrl.toLowerCase()) {
      Get.back(result: -1);
    }
  }

  @override
  void dispose() {
    _loadingProgress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    if (args == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Pay')),
        body: const Center(child: Text('Missing payment data')),
      );
    }

    final checkoutUrl = args['checkoutUrl'] as String?;
    final hasCheckoutUrl = checkoutUrl != null && checkoutUrl.isNotEmpty;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Pay with Virtual Pay',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Get.back(result: -1),
          ),
        ),
        body: Stack(
          children: [
            hasCheckoutUrl
                ? InAppWebView(
                    initialUrlRequest: URLRequest(url: WebUri(checkoutUrl)),
                    initialSettings: _webViewSettings,
                    onProgressChanged: (_, progress) =>
                        _loadingProgress.value = progress / 100,
                    onUpdateVisitedHistory: (_, url, __) => _onUrlChanged(url),
                  )
                : InAppWebView(
                    initialData: InAppWebViewInitialData(
                      data: VirtualPayButtonWidget.buildHtml(
                        accountName: args['accountName'] as String? ?? '',
                        invoiceNumber: args['invoiceNumber'] as String? ?? '',
                        invoiceAmount: args['invoiceAmount'] as String? ?? '',
                        currency: args['currency'] as String? ?? 'JMD',
                        firstName: args['firstName'] as String? ?? '',
                        lastName: args['lastName'] as String? ?? '',
                        contactNumber: args['contactNumber'] as String? ?? '',
                        email: args['email'] as String? ?? '',
                        passed: args['passed'] as String? ?? 'mass',
                        returnUrl: args['returnUrl'] as String? ?? '',
                      ),
                      baseUrl: WebUri('https://pay.virtualpayinc.com/'),
                    ),
                    initialSettings: _webViewSettings,
                    onProgressChanged: (_, progress) =>
                        _loadingProgress.value = progress / 100,
                    onUpdateVisitedHistory: (_, url, __) => _onUrlChanged(url),
                  ),
            ValueListenableBuilder<double>(
              valueListenable: _loadingProgress,
              builder: (context, value, child) {
                return value < 1.0
                    ? const Center(
                        child: CircularProgressIndicator.adaptive(),
                      )
                    : const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
