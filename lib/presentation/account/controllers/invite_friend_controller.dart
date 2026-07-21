import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:we_ship_faas/app/extensions/controller_ext.dart';
import 'package:we_ship_faas/data/models/requests/send_referral_email_request/referral_item.dart';
import 'package:we_ship_faas/data/models/requests/send_referral_email_request/send_referral_email_request.dart';
import 'package:we_ship_faas/domain/repositories/remote_repository.dart';

class InviteFriendController extends GetxController {
  InviteFriendController({required RemoteRepository remoteRepository})
      : _remoteRepository = remoteRepository;

  final RemoteRepository _remoteRepository;

  final formKey = GlobalKey<FormBuilderState>();
  final formIds = <int>[0].obs;
  int _nextId = 1;

  void addInvitationForm() {
    formIds.add(_nextId++);
  }

  void removeForm(int id) {
    if (formIds.length <= 1) return;
    formIds.remove(id);
  }

  Future<({bool isDone, String message})> onSubmit() async {
    final isValid = formKey.currentState?.saveAndValidate() ?? false;
    if (!isValid) return (isDone: false, message: '');

    final formData = formKey.currentState?.value ?? <String, dynamic>{};
    final referrals = <ReferralItem>[];

    for (final id in formIds) {
      final name = formData['name_$id']?.toString().trim();
      final email = formData['email_$id']?.toString().trim();
      final message = formData['message_$id']?.toString().trim() ?? '';
      if (name == null || name.isEmpty || email == null || email.isEmpty) {
        continue;
      }
      final messageHtml = message.isEmpty ? '<p></p>' : '<p>$message</p>';
      referrals.add(ReferralItem(
        name: name,
        email: email,
        message: messageHtml,
      ));
    }

    if (referrals.isEmpty) {
      return (isDone: false, message: 'Please fill at least one invitation.');
    }

    return _sendReferralEmail(SendReferralEmailRequest(referrals: referrals));
  }

  Future<({bool isDone, String message})> _sendReferralEmail(
    SendReferralEmailRequest request,
  ) async {
    bool result = false;
    String message = '';
    await asyncTask(() async {
      final res = await _remoteRepository.sendReferralEmail(request);
      message = res.message;
      result = res.status;
      if (result) {
        formKey.currentState?.reset();
      }
    });
    return (isDone: result, message: message);
  }
}
