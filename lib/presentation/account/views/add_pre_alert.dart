import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:we_ship_faas/app/util/flush_snackbar.dart';
import 'package:we_ship_faas/presentation/account/controllers/add_alert_controller.dart';
import 'package:we_ship_faas/presentation/auth/views/login_screen.dart';
import 'package:we_ship_faas/presentation/auth/widgets/text_field.dart';
import 'package:we_ship_faas/presentation/base_screen.dart';
import 'package:we_ship_faas/presentation/dashboard/views/dashboard.dart';

class AddPreAlertScreen extends GetView<AddPreAlertController> {
  const AddPreAlertScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      wrapWithAnnotatedRegion: true,
      backgroundColor: Dashboard.pageBg,
      value: SystemUiOverlayStyle.dark,
      showGradients: false,
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 126),
          child: Column(
            children: [
              const _AddPackageHeader(),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
                decoration: _cardDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        _TileIcon(
                          icon: Icons.add_box_outlined,
                          iconColor: Dashboard.blue,
                          background: Color(0xFFF4E8FF),
                        ),
                        SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            'Add Pre-Alert',
                            style: TextStyle(
                              color: Dashboard.darkBlue,
                              fontSize: 20,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Create a package alert before your shipment arrives.',
                      style: TextStyle(
                        color: Color(0xFF4D566B),
                        fontSize: 13,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20),
                    FormBuilder(
                      key: controller.formKey,
                      clearValueOnUnregister: true,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppTextField(
                            title: 'Name',
                            hint: 'Name',
                            name: 'nick_name',
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                          ),
                          SizedBox(height: 2.2.h),
                          AppTextField(
                            title: 'Merchant',
                            hint: 'Merchant',
                            name: 'merchant',
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                          ),
                          SizedBox(height: 2.2.h),
                          AppTextField(
                            title: 'Carrier',
                            hint: 'Carrier',
                            name: 'courier',
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                          ),
                          SizedBox(height: 2.2.h),
                          AppTextField(
                            title: 'Carrier tracking number',
                            hint: 'Carrier tracking number',
                            maxLines: 3,
                            minLines: 2,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.multiline,
                            type: FieldType.normal,
                            name: 'supplier_tracking_no',
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                          ),
                          SizedBox(height: 2.2.h),
                          AppTextField(
                            title: 'Weight',
                            hint: 'Weight',
                            maxLines: 1,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.number,
                            type: FieldType.normal,
                            name: 'weight',
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                          ),
                          SizedBox(height: 2.2.h),
                          AppTextField(
                            title: 'Value (US \$)',
                            hint: 'Value (US \$)',
                            maxLines: 1,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.number,
                            type: FieldType.normal,
                            name: 'price',
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                          ),
                          SizedBox(height: 2.2.h),
                          AppTextField(
                            title: 'Description',
                            hint: 'Description',
                            maxLines: 4,
                            minLines: 3,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.multiline,
                            type: FieldType.normal,
                            name: 'item_description',
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                          ),
                          const SizedBox(height: 22),
                          const Text(
                            'Attach an invoice',
                            style: TextStyle(
                              color: Dashboard.darkBlue,
                              fontSize: 15,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const FilePickerWidget(),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: AppButton(
                                  title: 'Submit',
                                  onTap: () {
                                    controller.onSubmit().then((value) {
                                      final isDone = value.isDone;
                                      final message = value.message;
                                      if (isDone) {
                                        Get.back();
                                        if (message.isEmpty) return;
                                        FlushSnackbar.showSnackBar(message);
                                      }
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: AppButton(
                                  title: 'Clear',
                                  onTap: controller.clearFile,
                                  backgroundColor: Colors.white,
                                  side: const BorderSide(
                                    width: 1,
                                    color: Color(0xFFD8E1EF),
                                  ),
                                  textColor: Dashboard.darkBlue,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddPackageHeader extends StatelessWidget {
  const _AddPackageHeader();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SizedBox(
        height: 96,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.chevron_left_rounded),
                color: Dashboard.darkBlue,
                iconSize: 38,
                onPressed: () => Get.back<void>(),
              ),
            ),
            const _LiteLogo(),
          ],
        ),
      ),
    );
  }
}

class _LiteLogo extends StatelessWidget {
  const _LiteLogo();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const CustomPaint(
              size: Size(34, 21),
              painter: _SpeedMarkPainter(),
            ),
            const SizedBox(width: 4),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'SHIPMORE COURIERS',
                    style: TextStyle(color: Dashboard.darkBlue),
                  ),
                  TextSpan(
                    text: '',
                    style: TextStyle(color: Dashboard.blue),
                  ),
                ],
              ),
              style: const TextStyle(
                fontSize: 24,
                fontFamily: 'Poppins',
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w800,
                height: 0.95,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 22, height: 1, color: Dashboard.darkBlue),
            const SizedBox(width: 8),
            const Text(
              'C O U R I E R  L . T . D',
              style: TextStyle(
                color: Dashboard.darkBlue,
                fontSize: 8,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                letterSpacing: 3.2,
              ),
            ),
            const SizedBox(width: 8),
            Container(width: 22, height: 1, color: Dashboard.darkBlue),
          ],
        ),
      ],
    );
  }
}

class _TileIcon extends StatelessWidget {
  const _TileIcon({
    required this.icon,
    required this.iconColor,
    required this.background,
  });

  final IconData icon;
  final Color iconColor;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: iconColor, size: 27),
    );
  }
}

class _SpeedMarkPainter extends CustomPainter {
  const _SpeedMarkPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 3.2
      ..strokeCap = StrokeCap.round
      ..color = Dashboard.blue;
    final rows = [
      [0.00, 0.82],
      [0.14, 0.92],
      [0.28, 1.00],
      [0.42, 0.86],
    ];

    for (var i = 0; i < rows.length; i++) {
      final y = size.height * (0.16 + (i * 0.22));
      canvas.drawLine(
        Offset(size.width * rows[i][0], y),
        Offset(size.width * rows[i][1], y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

BoxDecoration _cardDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: const Color(0xFFF0F4FA)),
    boxShadow: [
      BoxShadow(
        color: const Color(0xFF8CA7CA).withOpacity(0.12),
        offset: const Offset(0, 8),
        blurRadius: 20,
      ),
    ],
  );
}

class FilePickerWidget extends StatelessWidget {
  const FilePickerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddPreAlertController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFE),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE7D2FA)),
            ),
            child: Row(
              children: [
                const _TileIcon(
                  icon: Icons.upload_file_outlined,
                  iconColor: Dashboard.blue,
                  background: Color(0xFFF4E8FF),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    controller.pickedFile.value.path.isEmpty
                        ? 'No file chosen'
                        : controller.pickedFileName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Dashboard.darkBlue,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Obx(
          () => Visibility(
            visible: !controller.isFilePicked &&
                controller.filePickError.value.isNotEmpty,
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                controller.filePickError.value,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Obx(
          () => Visibility(
            visible: !controller.isFilePicked,
            child: GestureDetector(
              onTap: controller.pickFile,
              child: Container(
                width: double.infinity,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFF4E8FF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE7D2FA)),
                ),
                child: const Text(
                  'Choose File',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Dashboard.blue,
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
