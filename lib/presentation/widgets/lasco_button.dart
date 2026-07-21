import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:we_ship_faas/app/util/web_launcher.dart';

class LascoButton extends StatelessWidget {
  const LascoButton({
    super.key,
    this.height,
    this.width,
    this.margin,
    this.onTap,
  });
  final double? height;
  final double? width;
  final EdgeInsets? margin;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: () {
          if (onTap != null) {
            onTap?.call();
          } else {
            try {
              launchURL('https://pay.lascobizja.com/btn/MTVLU1yGC3qs');
            } catch (_) {}
          }
        },
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.green),
          elevation: WidgetStateProperty.all(0),
          padding: WidgetStateProperty.all(
            EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
          ),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(90),
                  child: Container(
                    height: 5.5.h,
                    constraints: BoxConstraints(
                      minWidth: 20.w,
                      maxWidth: 35.w,
                    ),
                    color: Colors.pinkAccent,
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2.w),
                          child: Text(
                            'Virtual Pay',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 11.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 1.5.w),
              VerticalDivider(
                thickness: 2,
                width: 3.w,
                color: Colors.white,
              ),
              SizedBox(width: 1.5.w),
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pay Now',
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Powered by Virtual Pay',
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8.sp,
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
