import 'package:get/get.dart';
import 'package:we_ship_faas/data/models/news/news.dart';
import 'package:we_ship_faas/data/models/requests/offset_request/offset_request.dart';
import 'package:we_ship_faas/domain/repositories/remote_repository.dart';
import 'package:we_ship_faas/presentation/bottom_nav/controllers/bottom_nav_controller.dart';
import 'package:we_ship_faas/presentation/mixin/pagination_service.dart';

class NewsController extends GetxController with PaginationService<News> {
  final RemoteRepository _remoteRepository;
  NewsController({required RemoteRepository remoteRepository})
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

  @override
  Future<List<News>> listener(int pageKey, {String keyToSearch = ''}) async {
    final result = await _remoteRepository.getNews(
      OffsetRequest(offset: '$pageKey', keyword: keyToSearch),
    );
    if (pageKey == 0 && Get.isRegistered<BottomNavController>()) {
      Get.find<BottomNavController>().notificationCount.value =
          result.data.news.length;
    }
    return result.data.news;
  }
}
