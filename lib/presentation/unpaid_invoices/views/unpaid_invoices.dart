import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sizer/sizer.dart';
import 'package:we_ship_faas/app/core/get_di.dart';
import 'package:we_ship_faas/app/core/routes/app_pages.dart';
import 'package:we_ship_faas/app/extensions/string_ext.dart';
import 'package:we_ship_faas/data/models/unpaid_invoice/unpaid_invoice.dart';
import 'package:we_ship_faas/presentation/account/views/account_screen.dart';
import 'package:we_ship_faas/presentation/auth/views/login_screen.dart';
import 'package:we_ship_faas/presentation/auth/widgets/auth_app_bar.dart';
import 'package:we_ship_faas/presentation/auth/widgets/text_field.dart';
import 'package:we_ship_faas/presentation/authorize/views/authorize_screen.dart';
import 'package:we_ship_faas/presentation/base_screen.dart';
import 'package:we_ship_faas/presentation/bottom_nav/controllers/bottom_nav_controller.dart';
import 'package:we_ship_faas/presentation/unpaid_invoices/controllers/unpaid_invoices.dart';

class UnpaidInvoicesScreen extends GetView<UnpaidInvoicesController> {
  const UnpaidInvoicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      showGradients: false,
      value: SystemUiOverlayStyle.dark,
      backgroundColor: const Color(0xFFFAF4F2).withOpacity(0.4),
      appBar: const AuthCustomAppBar.withSmallAppLogo(
        backButtonVisible: true,
        usingNavigator: true,
      ),
      body: Container(
        width: context.width,
        margin:
            EdgeInsets.only(left: 4.5.w, right: 4.5.w, top: 1.h, bottom: 2.h),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(3),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 4,
              offset: Offset(0, 3),
              spreadRadius: 1.8,
            )
          ],
        ),
        child: Padding(
          padding:
              EdgeInsets.only(left: 5.w, right: 5.w, top: 3.h, bottom: 1.4.h),
          child: Column(
            children: [
              const SearchField(),
              SizedBox(height: 2.h),
              const AppDivider(),
              SizedBox(height: 2.h),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => Future.sync(
                    () => controller.onRefresh(),
                  ),
                  child: GetBuilder<UnpaidInvoicesController>(
                    id: 'unpaidInvoices',
                    builder: (_) {
                      return PagedListView<int, UnpaidInvoice>.separated(
                        pagingController: controller.pagingController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        restorationId: '1',
                        addAutomaticKeepAlives: true,
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        shrinkWrap: true,
                        builderDelegate: PagedChildBuilderDelegate(
                          itemBuilder: (context, item, index) {
                            return _UnpaidItem(item: item);
                          },
                        ),
                        separatorBuilder: (context, index) => Padding(
                          padding: EdgeInsets.only(top: 2.h, bottom: 2.h),
                          child: Column(
                            children: [
                              const AppDivider(),
                              SizedBox(height: 2.h),
                              const AppDivider(),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _UnpaidItem extends StatelessWidget {
  const _UnpaidItem({required this.item});
  final UnpaidInvoice item;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 1.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: _TrackPackagesItemKeyValueBuilder(
                subTitle: item.createdAt?.toDDMMYYYY,
                title: 'Date created:',
                mainAxisAlignment: MainAxisAlignment.start,
                spaceBTW: 1.w,
              ),
            ),
            Expanded(
              child: _TrackPackagesItemKeyValueBuilder(
                subTitle: item.totalInvoice.toString(),
                title: 'Invoice Unpaid:',
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                spaceBTW: 1.w,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.5.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _TrackPackagesItemKeyValueBuilder(
                subTitle: item.invoiceNo.toString(),
                title: 'Invoice#:',
                mainAxisAlignment: MainAxisAlignment.start,
                spaceBTW: 1.w,
              ),
            ),
            Expanded(
              child: _TrackPackagesItemKeyValueBuilder(
                subTitle: item.userName,
                title: 'User Name:',
                mainAxisAlignment: MainAxisAlignment.end,
                spaceBTW: 1.w,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.5.h),
        SizedBox(height: 1.3.h),
        AppButton(
          title: 'Invoice Detail',
          width: context.width,
          height: 5,
          buttonBorderRadius: 8,
          backgroundColor: const Color(0xFF7A1EC2),
          onTap: () {
            final bottomNavNestedID =
                find<BottomNavController>().bottomNavNestedID;
            Get.toNamed(
              AppPages.invoiceDetails,
              id: bottomNavNestedID,
              arguments: item.invoiceNo.toString(),
            );
          },
        ),
        SizedBox(height: 1.3.h),
      ],
    );
  }
}

class _TrackPackagesItemKeyValueBuilder extends StatelessWidget {
  final String title;
  final String? subTitle;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final double spaceBTW;
  final MainAxisSize mainAxisSize;
  final Widget? customSubTitle;
  const _TrackPackagesItemKeyValueBuilder({
    required this.title,
    this.subTitle,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.spaceBTW = 0,
    this.mainAxisSize = MainAxisSize.max,
    this.customSubTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: [
        Text(
          title,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.black,
            fontSize: 9.sp,
            fontWeight: FontWeight.w600,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: spaceBTW),
        customSubTitle ??
            Text(
              subTitle ?? '',
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 9.sp,
                fontWeight: FontWeight.w400,
                overflow: TextOverflow.ellipsis,
              ),
            )
      ],
    );
  }
}
