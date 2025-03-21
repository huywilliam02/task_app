import 'package:flutter/material.dart';
import 'package:test_interview/core/constants/app_color.dart';
import 'package:test_interview/core/utils/spaces.dart';
import 'package:test_interview/core/widgets/popup/toast_enum.dart';

enum ToastPosition {
  top,
  bottom,
  center,
}

class CustomToast extends StatefulWidget {
  final String message;
  final ToastEnum type;
  final Duration duration;

  const CustomToast({
    super.key,
    required this.message,
    required this.type,
    this.duration = const Duration(seconds: 3),
  });

  @override
  _CustomToastState createState() => _CustomToastState();
}

class _CustomToastState extends State<CustomToast>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Navigator.of(context).pop();
        }
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double maxWidth = MediaQuery.of(context).size.width * 0.85;

    return Material(
      color: AppColor.transparent,
      child: Container(
        margin: const EdgeInsets.only(
          left: 10.0,
          right: 10.0,
          bottom: 20.0,
          top: 20.0,
        ),
        decoration: BoxDecoration(
          color: widget.type.backgroundColor,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6.0,
              spreadRadius: 1.0,
            ),
          ],
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    widget.type.leading,
                    spaceW8,
                    Expanded(
                      child: Text(
                        widget.message,
                        style: const TextStyle(
                          color: AppColor.white,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _controller.stop();
                        Navigator.of(context).pop();
                      },
                      child: const Icon(
                        Icons.close,
                        size: 16.0,
                        color: AppColor.white,
                      ),
                    ),
                  ],
                ),
              ),
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(8.0)),
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return LinearProgressIndicator(
                      value: 1 - _controller.value,
                      minHeight: 2.0,
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation(widget.type.timeColor),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Hàm common để hiển thị toast
void showToastCommon({
  required BuildContext context,
  required String message,
  required ToastEnum type,
  ToastPosition position = ToastPosition.bottom, // Mặc định dưới
  Duration duration = const Duration(seconds: 3),
}) {
  Alignment alignment;
  switch (position) {
    case ToastPosition.top:
      alignment = Alignment.topCenter;
      break;
    case ToastPosition.bottom:
      alignment = Alignment.bottomCenter;
      break;
    case ToastPosition.center:
      alignment = Alignment.center;
      break;
  }

  showDialog(
    barrierDismissible: true,
    barrierColor: Colors.transparent,
    builder: (context) => Align(
      alignment: alignment,
      child: CustomToast(
        message: message,
        type: type,
        duration: duration,
      ),
    ),
    context: context,
  );
}

// Các hàm tiện ích để gọi nhanh cho từng vị trí
void showToastTop({
  required BuildContext context,
  required String message,
  required ToastEnum type,
  Duration duration = const Duration(seconds: 3),
}) {
  showToastCommon(
    context: context,
    message: message,
    type: type,
    position: ToastPosition.top,
    duration: duration,
  );
}

void showToastBottom({
  required BuildContext context,
  required String message,
  required ToastEnum type,
  Duration duration = const Duration(seconds: 3),
}) {
  showToastCommon(
    context: context,
    message: message,
    type: type,
    position: ToastPosition.bottom,
    duration: duration,
  );
}

void showToastCenter({
  required BuildContext context,
  required String message,
  required ToastEnum type,
  Duration duration = const Duration(seconds: 3),
}) {
  showToastCommon(
    context: context,
    message: message,
    type: type,
    position: ToastPosition.center,
    duration: duration,
  );
}

// Hàm gốc vẫn giữ để tương thích với code cũ (nếu cần)
void showCustomToast({
  required BuildContext context,
  required String message,
  required ToastEnum type,
  ToastPosition position = ToastPosition.bottom,
}) {
  showToastCommon(
    context: context,
    message: message,
    type: type,
    position: position,
  );
}
