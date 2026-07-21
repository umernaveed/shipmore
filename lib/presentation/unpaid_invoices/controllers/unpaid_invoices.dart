import 'package:get/get.dart';
import 'package:we_ship_faas/data/models/unpaid_invoice/unpaid_invoice.dart';
import 'package:we_ship_faas/domain/repositories/remote_repository.dart';
import 'package:we_ship_faas/presentation/mixin/pagination_service.dart';

class UnpaidInvoicesController extends GetxController
    with PaginationService<UnpaidInvoice> {
  final RemoteRepository _remoteRepository;

  UnpaidInvoicesController({required RemoteRepository remoteRepository})
      : _remoteRepository = remoteRepository;

  @override
  void onInit() {
    initlizieController();
    super.onInit();
  }

  @override
  void onClose() {
    disposeController();
    super.onClose();
  }

  void onRefresh() {
    return pagingController.refresh();
  }

  @override
  Future<List<UnpaidInvoice>> listener(int pageKey,
      {String keyToSearch = ''}) async {
    final result = await _remoteRepository.getAllUnpaidInvoices();
    return result.data.unPaidInvoices;
  }
}
