import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:we_ship_faas/presentation/base_screen.dart';
import 'package:we_ship_faas/presentation/dashboard/views/dashboard.dart';

class DashboardMainScreen extends StatelessWidget {
  const DashboardMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseScreen(
      value: SystemUiOverlayStyle.dark,
      showGradients: false,
      backgroundColor: Dashboard.pageBg,
      body: Dashboard(),
    );
  }
}
