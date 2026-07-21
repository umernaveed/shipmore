import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:we_ship_faas/app/core/get_di.dart';
import 'package:we_ship_faas/app/services/device_service.dart';
import 'package:we_ship_faas/app/services/push_notifications_service.dart';
import 'package:we_ship_faas/data/models/app_meta/app_meta.dart';
import 'package:we_ship_faas/data/models/dashboard_data/dashboard_data.dart';
import 'package:we_ship_faas/data/models/user/user.dart';
import 'package:we_ship_faas/domain/repositories/local_repository.dart';
import 'package:we_ship_faas/domain/repositories/remote_repository.dart';
import 'package:we_ship_faas/presentation/onboarding/controllers/on_boarding_controller.dart';
import 'package:we_ship_faas/presentation/widgets/dialogs/app_update_dialog.dart';

class DashboardController extends GetxController
    with StateMixin<DashboardData> {
  final RemoteRepository _remoteRepository;
  final LocalRepository _localRepository;

  DashboardController({
    required RemoteRepository remoteRepository,
    required LocalRepository localRepository,
  })  : _remoteRepository = remoteRepository,
        _localRepository = localRepository;

  User get currentUser => _localRepository.getInstantUser();

  Future<void> fetchDashboard() async {
    try {
      change(DashboardData.defaultValues(), status: RxStatus.loading());
      final response = await _remoteRepository.fetchDashboard();
      change(response.data, status: RxStatus.success());
      Future.delayed(1.seconds, checkIfTheUpdateIsAvailable);
    } catch (e) {
      change(DashboardData.defaultValues(),
          status: RxStatus.error(e.toString()));
    }
  }

  Future<void> refreshData() => fetchDashboard();

  @override
  void onReady() {
    Future.delayed(500.milliseconds, () => fetchDashboard());
    final badger = find<FlutterAppNotificationBadger>();
    badger.clearBadge();
    super.onReady();
  }

  Future<void> checkIfTheUpdateIsAvailable() async {
    final onBoarding = find<OnBoardingController>();
    final isUpdateAvailable = isUpdateRequired(onBoarding.meta.value);
    if (!isUpdateAvailable) return;
    await Get.dialog(const AppUpdateDialog());
  }

  bool isUpdateRequired(AppMeta meta) {
    final remoteAppVersion = meta.setting?.appVersion ?? '0.0.0 + 0';
    final deviceInfo = find<DeviceInfoProvider>();
    final localAppVersion = deviceInfo.appVersionWithBuildNumber;
    Version remote = Version.parse(remoteAppVersion);
    Version local = Version.parse(localAppVersion);
    return remote.compareTo(local) > 0;
  }

  void launchStore() {
    try {
      final deviceInfo = find<DeviceInfoProvider>();
      final url = deviceInfo.getStoreLink();
      final uri = Uri.parse(url);
      launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } catch (_) {}
  }
}
