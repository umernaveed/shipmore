import 'package:get/get.dart';
import 'package:we_ship_faas/app/core/get_di.dart';
import 'package:we_ship_faas/domain/repositories/remote_repository.dart';
import 'package:we_ship_faas/presentation/account/controllers/invite_friend_controller.dart';

class InviteFriendBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(
      InviteFriendController(remoteRepository: find<RemoteRepository>()),
    );
  }
}
