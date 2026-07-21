import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:we_ship_faas/app/core/assets/drawables.dart';
import 'package:we_ship_faas/data/models/news/news.dart';
import 'package:we_ship_faas/presentation/base_screen.dart';
import 'package:we_ship_faas/presentation/bottom_nav/controllers/bottom_nav_controller.dart';
import 'package:we_ship_faas/presentation/dashboard/views/dashboard.dart';
import 'package:we_ship_faas/presentation/news/news_controller.dart';
import 'package:we_ship_faas/presentation/widgets/shimmer_widget.dart';

class NewsScreen extends GetView<NewsController> {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      showGradients: false,
      value: SystemUiOverlayStyle.dark,
      backgroundColor: Dashboard.pageBg,
      body: Column(
        children: [
          const _NotificationsHeader(),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 14),
            child: _NotificationSummary(controller: controller),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => Future.sync(
                () => controller.pagingController.refresh(),
              ),
              child: PagedListView<int, News>.separated(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 126),
                physics: const AlwaysScrollableScrollPhysics(),
                pagingController: controller.pagingController,
                builderDelegate: PagedChildBuilderDelegate<News>(
                  animateTransitions: true,
                  transitionDuration: 300.milliseconds,
                  firstPageProgressIndicatorBuilder: (_) =>
                      const _NotificationShimmerList(),
                  newPageProgressIndicatorBuilder: (_) => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 18),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  noItemsFoundIndicatorBuilder: (_) =>
                      const _EmptyNotifications(),
                  itemBuilder: (context, item, index) {
                    return _NotificationCard(news: item);
                  },
                ),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationsHeader extends StatelessWidget {
  const _NotificationsHeader();

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
              child: Padding(
                padding: const EdgeInsets.only(left: 18),
                child: IconButton(
                  icon: const Icon(Icons.chevron_left_rounded),
                  color: Dashboard.darkBlue,
                  iconSize: 38,
                  onPressed: () {
                    if (Get.isRegistered<BottomNavController>()) {
                      Get.back<void>(
                        id: Get.find<BottomNavController>().bottomNavNestedID,
                      );
                      return;
                    }
                    Get.back<void>();
                  },
                ),
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
                    text: 'Herms',
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

class _NotificationSummary extends StatelessWidget {
  const _NotificationSummary({required this.controller});

  final NewsController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final count = Get.isRegistered<BottomNavController>()
          ? Get.find<BottomNavController>().notificationCount.value
          : (controller.pagingController.itemList?.length ?? 0);
      return Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        decoration: _cardDecoration(),
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                const _TileIcon(
                  icon: Icons.notifications_none_rounded,
                  iconColor: Dashboard.blue,
                  background: Color(0xFFF4E8FF),
                ),
                if (count > 0)
                  Positioned(
                    right: -3,
                    top: -5,
                    child: Container(
                      width: 20,
                      height: 20,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF1428),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        count > 99 ? '99+' : count.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w800,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Notifications',
                    style: TextStyle(
                      color: Dashboard.darkBlue,
                      fontSize: 20,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    count == 1 ? '1 update available' : '$count updates available',
                    style: const TextStyle(
                      color: Color(0xFF4D566B),
                      fontSize: 13,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.mark_email_read_outlined,
              color: Dashboard.blue,
              size: 28,
            ),
          ],
        ),
      );
    });
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.news});

  final News news;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: news.image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 168,
              placeholder: (context, url) => Image.asset(
                Drawables.emptyImage,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 168,
              ),
              errorWidget: (context, url, error) => Image.asset(
                Drawables.emptyImage,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 168,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _TileIcon(
                icon: Icons.campaign_outlined,
                iconColor: Dashboard.blue,
                background: Color(0xFFF4E8FF),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      news.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Dashboard.darkBlue,
                        fontSize: 17,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w800,
                        height: 1.15,
                      ),
                    ),
                    if (news.createdAt.trim().isNotEmpty) ...[
                      const SizedBox(height: 5),
                      Text(
                        news.createdAt,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF6C7487),
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Html(
            data: news.newsDescription,
            shrinkWrap: true,
          ),
        ],
      ),
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

class _NotificationShimmerList extends StatelessWidget {
  const _NotificationShimmerList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < 3; i++) ...[
          ShimmerWidget(
            height: 300,
            width: double.infinity,
            radius: BorderRadius.circular(16),
            child: const SizedBox.shrink(),
          ),
          if (i != 2) const SizedBox(height: 14),
        ],
      ],
    );
  }
}

class _EmptyNotifications extends StatelessWidget {
  const _EmptyNotifications();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Text(
          'No notifications found',
          style: TextStyle(
            color: Dashboard.darkBlue,
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
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
