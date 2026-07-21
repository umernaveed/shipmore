import 'dart:math';

import 'package:get/get.dart';
import 'package:we_ship_faas/app/core/routes/app_pages.dart';
import 'package:we_ship_faas/data/models/requests/offset_request/offset_request.dart';
import 'package:we_ship_faas/domain/repositories/remote_repository.dart';

class BottomNavController extends GetxController {
  BottomNavController({required RemoteRepository remoteRepository})
      : _remoteRepository = remoteRepository;

  final RemoteRepository _remoteRepository;
  final bottomNavNestedID = Random().nextInt(999);

  var currentIndex = 0.obs;
  final notificationCount = 0.obs;

  String? get notificationBadge {
    final count = notificationCount.value;
    if (count <= 0) return null;
    return count > 99 ? '99+' : count.toString();
  }

  Future<void> refreshNotificationCount() async {
    try {
      final result = await _remoteRepository.getNews(
        const OffsetRequest(offset: '0', keyword: ''),
      );
      notificationCount.value = result.data.news.length;
    } catch (_) {
      notificationCount.value = 0;
    }
  }

  void onTabChange(int e) {
    if (currentIndex.value == e) return;
    currentIndex.value = e;
    switch (e) {
      case 0:
        Get.toNamed(AppPages.dashboard, id: bottomNavNestedID);
        break;
      case 1:
        Get.toNamed(AppPages.trackPackages, id: bottomNavNestedID);
        break;
      case 2:
        Get.toNamed(AppPages.addPreAlertScreen, id: bottomNavNestedID);
        break;
      case 3:
        Get.toNamed(AppPages.newsScreen, id: bottomNavNestedID);
        break;
      case 4:
        Get.toNamed(AppPages.account, id: bottomNavNestedID);
        break;
    }
  }

  void onPageChanged(e) => currentIndex.value = e;

  @override
  void onInit() {
    refreshNotificationCount();
    super.onInit();
  }
}
