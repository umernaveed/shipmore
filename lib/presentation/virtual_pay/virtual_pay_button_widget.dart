import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

/// Renders the VirtualPay payment button (vpaywidget.js) in an [InAppWebView].
///
/// When [onPayNowPressed] is set, navigation from the HTML button is
/// intercepted; the callback receives the checkout URL so the full-screen page
/// can load the payment form directly.
class VirtualPayButtonWidget extends StatefulWidget {
  const VirtualPayButtonWidget({
    super.key,
    required this.accountName,
    required this.invoiceNumber,
    required this.invoiceAmount,
    this.currency = 'JMD',
    required this.firstName,
    required this.lastName,
    required this.contactNumber,
    required this.email,
    this.passed = 'mass',
    required this.returnUrl,
    this.height = 80,
    this.onPayNowPressed,
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
  final String returnUrl;
  final double height;

  /// When set, intercepts navigation from the HTML button and calls this with
  /// the checkout URL. Pass that URL to the full-screen page to show the form.
  final void Function(String? checkoutUrl)? onPayNowPressed;

  static String _escapeHtmlAttr(String value) {
    return value
        .replaceAll('&', '&amp;')
        .replaceAll('"', '&quot;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;');
  }

  static String buildHtml({
    required String accountName,
    required String invoiceNumber,
    required String invoiceAmount,
    String currency = 'JMD',
    required String firstName,
    required String lastName,
    required String contactNumber,
    required String email,
    String passed = 'mass',
    required String returnUrl,
  }) {
    const scriptUrl = 'https://pay.virtualpayinc.com/js/api/vpaywidget.js';
    final escapedReturnUrl = _escapeHtmlAttr(returnUrl);
    return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    #vpaywidget, #vpaywidget * { box-sizing: border-box; }
    #vpaywidget { width: 100% !important; }
    #vpaywidget a, #vpaywidget button, #vpaywidget [role="button"],
    #vpaywidget input[type="submit"] {
      width: 100% !important; min-width: 100%; display: flex !important;
      align-items: center !important; justify-content: center !important;
      text-align: center !important;
    }
    #vpaywidget a span, #vpaywidget button span, #vpaywidget [role="button"] span,
    #vpaywidget a div, #vpaywidget button div, #vpaywidget [role="button"] div {
      justify-content: center !important; text-align: center !important;
    }
  </style>
  <script src="$scriptUrl"></script>
</head>
<body style="margin:0; padding:12px;">
  <div style="width:100%;">
    <div id="vpaywidget"
        data-account-name="${_escapeHtmlAttr(accountName)}"
        data-invoice-number="${_escapeHtmlAttr(invoiceNumber)}"
        data-invoice-amount="${_escapeHtmlAttr(invoiceAmount)}"
        data-currency="${_escapeHtmlAttr(currency)}"
        data-first-name="${_escapeHtmlAttr(firstName)}"
        data-last-name="${_escapeHtmlAttr(lastName)}"
        data-contact-number="${_escapeHtmlAttr(contactNumber)}"
        data-email="${_escapeHtmlAttr(email)}"
        data-passed="${_escapeHtmlAttr(passed)}"
        data-return-url="$escapedReturnUrl">
    </div>
  </div>
</body>
</html>
''';
  }

  @override
  State<VirtualPayButtonWidget> createState() => _VirtualPayButtonWidgetState();
}

class _VirtualPayButtonWidgetState extends State<VirtualPayButtonWidget>
    with AutomaticKeepAliveClientMixin {
  static const String _scriptPath =
      'https://pay.virtualpayinc.com/js/api/vpaywidget.js';
  static const String _baseUrl = 'https://pay.virtualpayinc.com/';

  bool _isWebViewCreated = false;

  @override
  bool get wantKeepAlive => true;

  String _buildHtml() {
    return VirtualPayButtonWidget.buildHtml(
      accountName: widget.accountName,
      invoiceNumber: widget.invoiceNumber,
      invoiceAmount: widget.invoiceAmount,
      currency: widget.currency,
      firstName: widget.firstName,
      lastName: widget.lastName,
      contactNumber: widget.contactNumber,
      email: widget.email,
      passed: widget.passed,
      returnUrl: widget.returnUrl,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SizedBox(
      width: double.infinity,
      height: widget.height,
      child: InAppWebView(
        initialData: !_isWebViewCreated
            ? InAppWebViewInitialData(
                data: _buildHtml(),
                baseUrl: WebUri(_baseUrl),
              )
            : null,
        initialSettings: InAppWebViewSettings(
          transparentBackground: true,
          disableContextMenu: true,
          supportZoom: false,
          useWideViewPort: true,
          javaScriptEnabled: true,
          domStorageEnabled: true,
          useShouldOverrideUrlLoading: widget.onPayNowPressed != null,
        ),
        onWebViewCreated: (controller) {
          _isWebViewCreated = true;
        },
        shouldOverrideUrlLoading: widget.onPayNowPressed != null
            ? (controller, navigationAction) async {
                final url = navigationAction.request.url.toString();
                if (url.startsWith(_scriptPath) ||
                    url == _baseUrl ||
                    url == '$_baseUrl/') {
                  return NavigationActionPolicy.ALLOW;
                }
                widget.onPayNowPressed?.call(url);
                return NavigationActionPolicy.CANCEL;
              }
            : null,
      ),
    );
  }
}
