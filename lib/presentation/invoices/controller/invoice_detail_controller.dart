import 'package:get/get.dart';
import 'package:we_ship_faas/data/models/invoice_detail/invoice_detail.dart';
import 'package:we_ship_faas/data/models/requests/invoice_detail_request/invoice_detail_request.dart';
import 'package:we_ship_faas/domain/repositories/remote_repository.dart';

class InvoiceDetailController extends GetxController
    with StateMixin<InvoiceDetailResponse> {
  final RemoteRepository _remoteRepository;

  InvoiceDetailController({required RemoteRepository remoteRepository})
      : _remoteRepository = remoteRepository;

  Future<void> getInviceDetails(String invoiceNo) async {
    try {
      change(InvoiceDetailResponse.empty(), status: RxStatus.loading());
      final response = await _remoteRepository.getInvoiceDetails(
        InvoiceDetailRequest(invoiceNo: invoiceNo),
      );
      change(response.data, status: RxStatus.success());
    } catch (e) {
      change(InvoiceDetailResponse.empty(),
          status: RxStatus.error(e.toString()));
    }
  }
}
