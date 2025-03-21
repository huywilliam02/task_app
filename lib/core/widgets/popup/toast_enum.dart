import 'package:flutter/material.dart';
import 'package:test_interview/core/constants/app_color.dart';

enum ToastEnum {
  // Thành công
  success,
  // Cảnh báo
  warning,
  // Lỗi
  error;

//  loading;

  Color get backgroundColor {
    switch (this) {
      case ToastEnum.success:
        return AppColor.successToast;
      case ToastEnum.warning:
        return AppColor.warningToast;
      case ToastEnum.error:
        return AppColor.errorToast;
      // case ToastEnum.loading:
      //   return AppColor.foundation;
      default:
        return AppColor.white;
    }
  }

  Color get timeColor {
    switch (this) {
      case ToastEnum.success:
        return AppColor.successTimeToast;
      case ToastEnum.warning:
        return AppColor.warningTimeToast;
      case ToastEnum.error:
        return AppColor.errorTimeToast;
      default:
        return AppColor.white;
    }
  }

  Widget get leading {
    switch (this) {
      case ToastEnum.success:
        return Container(
          decoration: const BoxDecoration(
              shape: BoxShape.circle, color: AppColor.white),
          child: const Icon(
            Icons.check,
            color: AppColor.successToast,
          ),
        );
      case ToastEnum.warning:
        return Container(
          decoration: const BoxDecoration(
              shape: BoxShape.circle, color: AppColor.white),
          child: const Icon(
            Icons.error,
            color: AppColor.warningToast,
          ),
        );
      case ToastEnum.error:
        return Container(
          decoration: const BoxDecoration(
              shape: BoxShape.circle, color: AppColor.white),
          child: const Icon(
            Icons.close,
            color: AppColor.errorToast,
          ),
        );
      default:
        return Container();
    }
  }
}
