import 'package:flutter/material.dart';
import 'package:test_interview/core/constants/app_color.dart';
import 'package:test_interview/core/utils/spaces.dart';

class ConfirmDialog extends StatelessWidget {
  ConfirmDialog({
    required this.title,
    required this.body,
    this.leftButtonText = 'Cancel', // Giá trị mặc định
    this.rightButtonText = 'Confirm', // Giá trị mặc định
    this.onLeftButtonTap,
    this.onRightButtonTap,
    this.onTapCancel,
    this.width,
    this.showLeftButton = true, // Thêm điều khiển hiển thị nút trái
    this.showRightButton = true, // Thêm điều khiển hiển thị nút phải
    this.showCancelIcon = true, // Thêm điều khiển hiển thị icon đóng
  });

  final String title;
  final Widget body;
  final String leftButtonText;
  final String rightButtonText;
  final VoidCallback? onLeftButtonTap;
  final VoidCallback? onTapCancel;
  final VoidCallback? onRightButtonTap;
  final double? width;
  final bool showLeftButton; // Hiển thị nút trái hay không
  final bool showRightButton; // Hiển thị nút phải hay không
  final bool showCancelIcon; // Hiển thị icon đóng hay không

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) async => false,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Container(
          width: width ?? MediaQuery.of(context).size.width * 0.85,
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(12.0),
          ),
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                decoration: const BoxDecoration(
                  color: AppColor.lightBlue,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: AppColor.textBlack,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (showCancelIcon) // Chỉ hiển thị nếu showCancelIcon = true
                      InkWell(
                        onTap: onTapCancel ?? () => Navigator.of(context).pop(),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Icon(Icons.close, color: AppColor.redBoder),
                        ),
                      ),
                  ],
                ),
              ),
              spaceH8,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: body,
              ),
              spaceH16,
              if (showLeftButton ||
                  showRightButton) // Chỉ hiển thị Row nếu có nút
                Row(
                  children: [
                    if (showLeftButton) // Hiển thị nút trái nếu showLeftButton = true
                      Expanded(
                        child: InkWell(
                          onTap: onLeftButtonTap ??
                              () => Navigator.of(context).pop(),
                          child: Container(
                            height: 45,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: const Border(
                                top: BorderSide(color: AppColor.primaryDark),
                                right: BorderSide(color: AppColor.primaryDark),
                              ),
                              borderRadius: BorderRadius.only(
                                bottomLeft:
                                    Radius.circular(showRightButton ? 0 : 12.0),
                              ),
                            ),
                            child: Text(
                              leftButtonText,
                              style: const TextStyle(
                                color: AppColor.primaryDark,
                                fontFamily: 'Nunito',
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (showRightButton)
                      Expanded(
                        child: InkWell(
                          onTap: onRightButtonTap ??
                              () => Navigator.of(context).pop(),
                          child: Container(
                            height: 45,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColor.primaryMain,
                              borderRadius: BorderRadius.only(
                                topLeft:
                                    Radius.circular(showLeftButton ? 0 : 12.0),
                                topRight:
                                    Radius.circular(showLeftButton ? 0 : 12.0),
                                bottomRight:
                                    Radius.circular(showLeftButton ? 0 : 12.0),
                                bottomLeft:
                                    Radius.circular(showLeftButton ? 0 : 12.0),
                              ),
                            ),
                            child: Text(
                              rightButtonText,
                              style: const TextStyle(
                                color: AppColor.white,
                                fontFamily: 'Nunito',
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

void showConfirmDialog({
  BuildContext? context,
  required String title,
  required Widget body,
  String leftButtonText = 'Cancel',
  String rightButtonText = 'Confirm',
  VoidCallback? onLeftButtonTap,
  VoidCallback? onRightButtonTap,
  VoidCallback? onCancel,
  double? width,
  bool showLeftButton = true, // Thêm tham số điều khiển nút trái
  bool showRightButton = true, // Thêm tham số điều khiển nút phải
  bool showCancelIcon = true, // Thêm tham số điều khiển icon đóng
}) {
  showDialog(
    context: context!,
    barrierDismissible: false,
    barrierColor: Colors.grey.withOpacity(0.7),
    builder: (BuildContext context) {
      return ConfirmDialog(
        title: title,
        body: body,
        onTapCancel: onCancel,
        leftButtonText: leftButtonText,
        onLeftButtonTap: onLeftButtonTap,
        rightButtonText: rightButtonText,
        onRightButtonTap: onRightButtonTap,
        width: width,
        showLeftButton: showLeftButton,
        showRightButton: showRightButton,
        showCancelIcon: showCancelIcon,
      );
    },
  );
}
