import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:we_ship_faas/app/core/routes/app_pages.dart';
import 'package:we_ship_faas/app/util/flush_snackbar.dart';
import 'package:we_ship_faas/presentation/auth/controllers/login_controller.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  static const Color primaryBlue = Color(0xFF7A1EC2);
  static const Color deepBlue = Color(0xFF26052F);
  static const Color mutedText = Color(0xFF696D91);
  static const Color fieldBorder = Color(0xFFC79BEA);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;
            final scale = (width / 390).clamp(0.88, 1.08).toDouble();
            final horizontalMargin = 28.0 * scale;

            return Stack(
              children: [
                const Positioned.fill(
                  child: CustomPaint(
                    painter: _LoginBackgroundPainter(),
                  ),
                ),
                SafeArea(
                  bottom: false,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(
                      left: horizontalMargin,
                      right: horizontalMargin,
                      bottom: MediaQuery.of(context).viewInsets.bottom + 28,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: height - 36),
                      child: FormBuilder(
                        key: controller.formKey,
                        clearValueOnUnregister: true,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          children: [
                            SizedBox(height: 16 * scale),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: _BackButton(scale: scale),
                            ),
                            SizedBox(height: 10 * scale),
                            _BrandLogo(scale: scale),
                            SizedBox(height: 44 * scale),
                            _LoginCard(
                              scale: scale,
                              controller: controller,
                            ),
                            SizedBox(height: 230 * scale),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.scale});

  final double scale;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44 * scale,
      height: 44 * scale,
      child: IconButton(
        padding: EdgeInsets.zero,
        splashRadius: 22 * scale,
        onPressed: () {
          if (Get.key.currentState?.canPop() ?? false) {
            Get.back();
          }
        },
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: LoginScreen.deepBlue,
          size: 25 * scale,
        ),
      ),
    );
  }
}

class _BrandLogo extends StatelessWidget {
  const _BrandLogo({required this.scale});

  final double scale;

  @override
  Widget build(BuildContext context) {
    final logoScale = math.min(scale, 1.0);

    return Column(
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomPaint(
                size: Size(44 * logoScale, 28 * logoScale),
                painter: const _SpeedMarkPainter(),
              ),
              SizedBox(width: 4 * logoScale),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Herms',
                      style: TextStyle(
                        color: LoginScreen.deepBlue,
                        fontSize: 36 * logoScale,
                        fontFamily: 'Poppins',
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w800,
                        height: 0.95,
                      ),
                    ),
                    TextSpan(
                      text: '',
                      style: TextStyle(
                        color: LoginScreen.primaryBlue,
                        fontSize: 36 * logoScale,
                        fontFamily: 'Poppins',
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w800,
                        height: 0.95,
                      ),
                    ),
                  ],
                ),
                maxLines: 1,
              ),
            ],
          ),
        ),
        SizedBox(height: 12 * scale),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 22 * scale,
                height: 1.4,
                color: LoginScreen.primaryBlue,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10 * scale),
                child: Text(
                  'C O U R I E R  L . T . D',
                  style: TextStyle(
                    color: LoginScreen.deepBlue,
                    fontSize: 12 * scale,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    letterSpacing: 5.0,
                  ),
                ),
              ),
              Container(
                width: 22 * scale,
                height: 1.4,
                color: LoginScreen.primaryBlue,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LoginCard extends StatelessWidget {
  const _LoginCard({
    required this.scale,
    required this.controller,
  });

  final double scale;
  final LoginController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        24 * scale,
        22 * scale,
        24 * scale,
        35 * scale,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.96),
        borderRadius: BorderRadius.circular(28 * scale),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0C56D9).withOpacity(0.18),
            offset: Offset(0, 22 * scale),
            blurRadius: 38 * scale,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.85),
            offset: Offset(-8 * scale, -8 * scale),
            blurRadius: 20 * scale,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 62 * scale,
                height: 62 * scale,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F0FF),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFC79BEA).withOpacity(0.28),
                      offset: Offset(0, 10 * scale),
                      blurRadius: 16 * scale,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.lock_outline_rounded,
                  color: LoginScreen.primaryBlue,
                  size: 32 * scale,
                ),
              ),
              SizedBox(width: 18 * scale),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Welcome Back',
                        style: TextStyle(
                          color: LoginScreen.deepBlue,
                          fontSize: 26 * scale,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w800,
                          height: 1.08,
                        ),
                      ),
                    ),
                    SizedBox(height: 10 * scale),
                    Text(
                      'Login to your Herms account',
                      style: TextStyle(
                        color: LoginScreen.mutedText,
                        fontSize: 16 * scale,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 34 * scale),
          _FieldLabel(text: 'Email', scale: scale),
          SizedBox(height: 8 * scale),
          _LoginTextField(
            name: 'email',
            hintText: 'Enter your email',
            icon: Icons.mail_outline_rounded,
            scale: scale,
            keyboardType: TextInputType.emailAddress,
            validator: FormBuilderValidators.compose(
              [
                FormBuilderValidators.required(),
                FormBuilderValidators.email(),
              ],
            ),
          ),
          SizedBox(height: 22 * scale),
          _FieldLabel(text: 'Password', scale: scale),
          SizedBox(height: 8 * scale),
          ValueListenableBuilder<bool>(
            valueListenable: controller.passwordVisibility,
            builder: (context, value, child) {
              return _LoginTextField(
                name: 'password',
                hintText: 'Enter your password',
                icon: Icons.lock_outline_rounded,
                scale: scale,
                obscureText: value,
                obscuringCharacter: '*',
                validator: FormBuilderValidators.compose(
                  [
                    FormBuilderValidators.required(),
                    FormBuilderValidators.minLength(6),
                  ],
                ),
                suffixIcon: IconButton(
                  onPressed: () => controller.onPasswordToggle(),
                  icon: Icon(
                    value
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: const Color(0xFF565A7D),
                    size: 27 * scale,
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 10 * scale),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Get.toNamed(AppPages.forgetPassword),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8 * scale),
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: LoginScreen.primaryBlue,
                    fontSize: 15 * scale,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 18 * scale),
          _LoginButton(scale: scale, controller: controller),
          SizedBox(height: 30 * scale),
          _OrDivider(scale: scale),
          SizedBox(height: 24 * scale),
          Center(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "Don't have an account? ",
                    style: TextStyle(
                      color: LoginScreen.deepBlue,
                      fontSize: 15 * scale,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.baseline,
                    baseline: TextBaseline.alphabetic,
                    child: GestureDetector(
                      onTap: () => Get.toNamed(AppPages.signUp),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: LoginScreen.primaryBlue,
                          fontSize: 15 * scale,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
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

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.text, required this.scale});

  final String text;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: LoginScreen.deepBlue,
        fontSize: 15 * scale,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _LoginTextField extends StatelessWidget {
  const _LoginTextField({
    required this.name,
    required this.hintText,
    required this.icon,
    required this.scale,
    this.validator,
    this.suffixIcon,
    this.keyboardType,
    this.obscureText = false,
    this.obscuringCharacter = '*',
  });

  final String name;
  final String hintText;
  final IconData icon;
  final double scale;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String obscuringCharacter;

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: name,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText,
      obscuringCharacter: obscuringCharacter,
      cursorColor: LoginScreen.primaryBlue,
      style: TextStyle(
        color: LoginScreen.deepBlue,
        fontSize: 16 * scale,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: LoginScreen.mutedText,
          fontSize: 16 * scale,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
          height: 1.2,
        ),
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 18 * scale, right: 12 * scale),
          child: Icon(
            icon,
            color: LoginScreen.primaryBlue,
            size: 27 * scale,
          ),
        ),
        prefixIconConstraints: BoxConstraints(
          minWidth: 58 * scale,
          minHeight: 58 * scale,
        ),
        suffixIcon: suffixIcon,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 18 * scale,
          vertical: 18 * scale,
        ),
        filled: true,
        fillColor: Colors.white,
        errorMaxLines: 2,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13 * scale),
          borderSide: const BorderSide(
            color: LoginScreen.fieldBorder,
            width: 1.2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13 * scale),
          borderSide: const BorderSide(
            color: LoginScreen.primaryBlue,
            width: 1.4,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13 * scale),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13 * scale),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.4),
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({required this.scale, required this.controller});

  final double scale;
  final LoginController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 58 * scale,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF8A2BE2), Color(0xFF2D0738)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(12 * scale),
          boxShadow: [
            BoxShadow(
              color: LoginScreen.primaryBlue.withOpacity(0.35),
              offset: Offset(0, 12 * scale),
              blurRadius: 18 * scale,
            ),
          ],
        ),
        child: TextButton(
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12 * scale),
            ),
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            controller.onLoginPress().then((value) {
              final isDone = value.isDone;
              final message = value.message;
              if (isDone) {
                Get.offAllNamed(AppPages.bottomNav);
              } else {
                if (message.isEmpty) return;
                FlushSnackbar.showSnackBar(message);
              }
            });
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                'Log In',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17 * scale,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
              Positioned(
                right: 14 * scale,
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 28 * scale,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider({required this.scale});

  final double scale;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(height: 1, color: const Color(0xFFD7DCE8)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16 * scale),
          child: Text(
            'OR',
            style: TextStyle(
              color: const Color(0xFF777B99),
              fontSize: 14 * scale,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Container(height: 1, color: const Color(0xFFD7DCE8)),
        ),
      ],
    );
  }
}

class _LoginBackgroundPainter extends CustomPainter {
  const _LoginBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final blue = LoginScreen.primaryBlue;
    const deepBlue = Color(0xFF2D0738);

    final topGlow = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFEAF3FF).withOpacity(0.7),
          Colors.white.withOpacity(0),
        ],
      ).createShader(Rect.fromCircle(
        center: Offset(size.width * 0.5, size.height * 0.31),
        radius: size.width * 0.8,
      ));
    canvas.drawRect(Offset.zero & size, topGlow);

    _drawDots(canvas, Offset(size.width * 0.03, size.height * 0.13), blue);
    _drawDots(canvas, Offset(size.width * 0.96, size.height * 0.74), blue);
    _drawWaveLines(canvas, size, blue);
    _drawBottomScene(canvas, size, blue, deepBlue);
  }

  void _drawDots(Canvas canvas, Offset origin, Color color) {
    final paint = Paint()..color = color.withOpacity(0.9);
    for (var row = 0; row < 5; row++) {
      for (var col = 0; col < 4; col++) {
        canvas.drawCircle(
          origin + Offset(col * 14.0, row * 14.0),
          1.8,
          paint,
        );
      }
    }
  }

  void _drawWaveLines(Canvas canvas, Size size, Color color) {
    final paint = Paint()
      ..color = color.withOpacity(0.82)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;

    for (var i = 0; i < 8; i++) {
      final path = Path()
        ..moveTo(size.width + 8, size.height * 0.22 + i * 5)
        ..cubicTo(
          size.width * 0.92,
          size.height * 0.27 + i * 5,
          size.width * 0.96,
          size.height * 0.31 + i * 4,
          size.width * 0.88,
          size.height * 0.35 + i * 3,
        );
      canvas.drawPath(path, paint);
    }

    for (var i = 0; i < 8; i++) {
      final path = Path()
        ..moveTo(-18, size.height * 0.31 + i * 5)
        ..cubicTo(
          size.width * 0.08,
          size.height * 0.34 + i * 3,
          size.width * 0.03,
          size.height * 0.38 + i * 4,
          size.width * 0.16,
          size.height * 0.41 + i * 3,
        );
      canvas.drawPath(path, paint);
    }
  }

  void _drawBottomScene(Canvas canvas, Size size, Color blue, Color deepBlue) {
    final top = size.height * 0.74;
    final rect = Rect.fromLTWH(0, top, size.width, size.height - top);
    final gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFFB86BE8).withOpacity(0.20),
          const Color(0xFF8A2BE2).withOpacity(0.88),
          const Color(0xFF5B168F),
        ],
        stops: const [0, 0.48, 1],
      ).createShader(rect);
    canvas.drawRect(rect, gradientPaint);

    final shipPaint = Paint()..color = const Color(0xFF45106F).withOpacity(0.78);
    final ship = Path()
      ..moveTo(size.width * 0.60, size.height * 0.91)
      ..lineTo(size.width * 0.96, size.height * 0.91)
      ..lineTo(size.width * 0.89, size.height * 0.96)
      ..lineTo(size.width * 0.64, size.height * 0.96)
      ..close();
    canvas.drawPath(ship, shipPaint);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.70,
          size.height * 0.82,
          size.width * 0.22,
          size.height * 0.08,
        ),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFF7A1EC2).withOpacity(0.55),
    );
    for (var i = 0; i < 4; i++) {
      final yOffset = i.isEven ? 0.0 : size.height * 0.015;
      canvas.drawRect(
        Rect.fromLTWH(
          size.width * (0.69 + i * 0.055),
          size.height * 0.83 - yOffset,
          size.width * 0.045,
          size.height * 0.035,
        ),
        Paint()..color = const Color(0xFFB86BE8).withOpacity(0.42),
      );
    }

    final vanPaint = Paint()..color = const Color(0xFFEAF3FF).withOpacity(0.78);
    final vanTop = size.height * 0.90;
    final vanLeft = size.width * 0.05;
    final van = RRect.fromRectAndRadius(
      Rect.fromLTWH(vanLeft, vanTop, size.width * 0.27, size.height * 0.045),
      const Radius.circular(6),
    );
    canvas.drawRRect(van, vanPaint);
    final cabin = Path()
      ..moveTo(vanLeft + size.width * 0.18, vanTop)
      ..lineTo(vanLeft + size.width * 0.24, vanTop + size.height * 0.006)
      ..lineTo(vanLeft + size.width * 0.27, vanTop + size.height * 0.026)
      ..lineTo(vanLeft + size.width * 0.18, vanTop + size.height * 0.026)
      ..close();
    canvas.drawPath(cabin, vanPaint);
    final wheelPaint = Paint()..color = deepBlue.withOpacity(0.65);
    canvas.drawCircle(
      Offset(vanLeft + size.width * 0.07, vanTop + size.height * 0.047),
      7,
      wheelPaint,
    );
    canvas.drawCircle(
      Offset(vanLeft + size.width * 0.23, vanTop + size.height * 0.047),
      7,
      wheelPaint,
    );

    final routePaint = Paint()
      ..color = const Color(0xFFE0C15B).withOpacity(0.75)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final route = Path()
      ..moveTo(size.width * 0.30, size.height * 0.91)
      ..cubicTo(
        size.width * 0.42,
        size.height * 0.98,
        size.width * 0.48,
        size.height * 0.82,
        size.width * 0.58,
        size.height * 0.89,
      )
      ..cubicTo(
        size.width * 0.64,
        size.height * 0.93,
        size.width * 0.70,
        size.height * 0.90,
        size.width * 0.75,
        size.height * 0.88,
      );
    _drawDashedPath(canvas, route, routePaint);
    final pinCenter = Offset(size.width * 0.50, size.height * 0.89);
    canvas.drawCircle(pinCenter, 10, Paint()..color = const Color(0xFFE0C15B));
    canvas.drawCircle(pinCenter, 4, Paint()..color = blue);
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = math.min(distance + 6, metric.length);
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance += 12;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SpeedMarkPainter extends CustomPainter {
  const _SpeedMarkPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = LoginScreen.primaryBlue
      ..strokeCap = StrokeCap.round
      ..strokeWidth = size.height * 0.14;
    for (var i = 0; i < 4; i++) {
      final y = size.height * (0.18 + i * 0.2);
      final start = size.width * (0.08 + i * 0.07);
      final end = size.width * (0.72 - (i == 0 ? 0.06 : 0));
      canvas.drawLine(Offset(start, y), Offset(end, y), paint);
    }
    final accent = Paint()
      ..color = const Color(0xFFE0C15B)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = size.height * 0.14;
    canvas.drawLine(
      Offset(size.width * 0.64, size.height * 0.18),
      Offset(size.width * 0.94, size.height * 0.18),
      accent,
    );
    canvas.drawLine(
      Offset(size.width * 0.55, size.height * 0.38),
      Offset(size.width * 0.88, size.height * 0.38),
      accent,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class AuthWidgetSpanBuilder extends StatelessWidget {
  const AuthWidgetSpanBuilder({
    super.key,
    required this.firstTitle,
    required this.secondTitle,
    this.onTap,
  });

  final String firstTitle;
  final String secondTitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: firstTitle,
              style: context.textTheme.bodySmall?.copyWith(
                color: const Color(0xFF181725),
                fontSize: 9.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            WidgetSpan(
              child: InkWell(
                splashColor: Color(0xFF7A1EC2),
                borderRadius: BorderRadius.circular(3),
                onTap: onTap,
                child: Text(
                  secondTitle,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF7A1EC2),
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AppButton extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? textColor;
  final BorderSide side;
  final double buttonBorderRadius;

  /// .h is internaly used
  final double height;
  final double? width;
  final double? fontSize;
  const AppButton({
    super.key,
    required this.title,
    this.onTap,
    this.backgroundColor,
    this.textColor,
    this.side = BorderSide.none,
    this.buttonBorderRadius = 19,
    this.height = 6.9,
    this.fontSize,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? context.width,
      height: height.h,
      child: TextButton(
        style: TextButton.styleFrom(
          disabledBackgroundColor: Colors.black12.withOpacity(0.1),
          backgroundColor: backgroundColor ?? const Color(0xFF7A1EC2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonBorderRadius),
            side: side,
          ),
        ),
        onPressed: onTap,
        child: Text(
          title,
          style: TextStyle(
            color: textColor ?? const Color(0xFFFFF9FF),
            fontSize: fontSize ?? 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
