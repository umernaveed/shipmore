import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:we_ship_faas/app/core/get_di.dart';
import 'package:we_ship_faas/app/util/flush_snackbar.dart';
import 'package:we_ship_faas/presentation/account/controllers/invite_friend_controller.dart';
import 'package:we_ship_faas/presentation/account/views/account_screen.dart';
import 'package:we_ship_faas/presentation/auth/views/login_screen.dart';
import 'package:we_ship_faas/presentation/auth/widgets/auth_app_bar.dart';
import 'package:we_ship_faas/presentation/auth/widgets/text_field.dart';
import 'package:we_ship_faas/presentation/base_screen.dart';
import 'package:we_ship_faas/presentation/bottom_nav/controllers/bottom_nav_controller.dart';

class InviteFriendScreen extends GetView<InviteFriendController> {
  const InviteFriendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      wrapWithAnnotatedRegion: true,
      value: SystemUiOverlayStyle.dark,
      backgroundColor: const Color(0xFFFAF4F2).withOpacity(0.4),
      appBar: const AuthCustomAppBar.withSmallAppLogo(
        backButtonVisible: true,
        usingNavigator: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.addInvitationForm,
        backgroundColor: const Color(0xFF7A1EC2),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Container(
          width: context.width,
          margin: EdgeInsets.only(
            left: 6.w,
            right: 6.w,
            top: 2.h,
            bottom: 10.h,
          ),
          child: FormBuilder(
            key: controller.formKey,
            child: Obx(
              () {
                final formIds = controller.formIds;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0; i < formIds.length; i++) ...[
                      _InvitationFormCard(
                        formId: formIds[i],
                        displayIndex: i + 1,
                        formCount: formIds.length,
                        onRemove: formIds.length > 1
                            ? () => controller.removeForm(formIds[i])
                            : null,
                      ),
                      if (i < formIds.length - 1) SizedBox(height: 3.h),
                    ],
                    SizedBox(height: 3.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: AppButton(
                        title: 'Send Invitations',
                        onTap: () async {
                          final result = await controller.onSubmit();
                          if (result.isDone) {
                            if (result.message.isNotEmpty) {
                              FlushSnackbar.showSnackBar(result.message);
                            }
                            Get.back(
                              id: find<BottomNavController>().bottomNavNestedID,
                            );
                          } else if (result.message.isNotEmpty) {
                            FlushSnackbar.showSnackBar(result.message);
                          }
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _InvitationFormCard extends StatelessWidget {
  const _InvitationFormCard({
    required this.formId,
    required this.displayIndex,
    required this.formCount,
    this.onRemove,
  });

  final int formId;
  final int displayIndex;
  final int formCount;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 4,
            offset: Offset(0, 3),
            spreadRadius: 2,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 3.w,
              right: 3.w,
              top: 3.h,
              bottom: 2.h,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formCount > 1 ? 'Invitation $displayIndex' : 'Invite Friend',
                  style: TextStyle(
                    color: const Color(0xFF7A1EC2),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (onRemove != null)
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    color: Colors.red.shade400,
                    onPressed: onRemove,
                    tooltip: 'Remove invitation',
                  ),
              ],
            ),
          ),
          const AppDivider(),
          Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFD9D9D9)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFD9D9D9)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      const BorderSide(color: Color(0xFF7A1EC2), width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.red),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
              child: Column(
                children: [
                  AppTextField(
                    title: 'Name',
                    hint: 'Name',
                    name: 'name_$formId',
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  SizedBox(height: 3.h),
                  AppTextField(
                    title: 'Email',
                    hint: 'Email',
                    name: 'email_$formId',
                    keyboardType: TextInputType.emailAddress,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.email(),
                    ]),
                  ),
                  SizedBox(height: 3.h),
                  AppTextField(
                    title: 'Message',
                    hint: 'Message',
                    name: 'message_$formId',
                    maxLines: 8,
                    initialValue:
                        "I wanted to personally recommend BluePeak Couriers to you for your online shopping and shipping needs.\n\n"
                        "I've been using them and the service has been really reliable—fast deliveries, good customer service, and their app makes it super easy to track everything.\n\n"
                        "They also have pickup locations in Kingston and Mandeville, plus other convenient pickup points. If you ever need a dependable courier service, definitely check them out. I think you'll like the experience.\n\n"
                        "See the website and app links below to sign up.",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
