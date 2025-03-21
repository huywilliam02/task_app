import 'package:flutter/material.dart';
import 'package:test_interview/core/utils/spaces.dart';

class AppCheckBox extends StatelessWidget {
  const AppCheckBox({
    super.key,
    this.prefixTitle,
    this.value,
    this.isEnabled,
    this.suffixTitle,
    this.onTap,
    this.styleTitle,
  });

  final String? prefixTitle;
  final bool? value;
  final bool? isEnabled;
  final String? suffixTitle;
  final VoidCallback? onTap;
  final TextStyle? styleTitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (prefixTitle != null) ...[
          Text(prefixTitle!,
              style: styleTitle ??
                  TextStyle(
                    color: Colors.grey,
                  )),
          spaceW4,
        ],
        InkWell(
          onTap: (isEnabled ?? true) ? onTap : null,
          child: (value ?? false)
              ? const Icon(
                  Icons.check_box,
                  color: Colors.grey,
                )
              : Stack(
                  alignment: Alignment.center,
                  children: [
                    if (!(isEnabled ?? true))
                      Container(
                        width: 16,
                        height: 16,
                        color: Colors.grey,
                      ),
                    const Icon(
                      Icons.check_box_outline_blank,
                      color: Colors.grey,
                    ),
                  ],
                ),
        ),
        if (suffixTitle != null) ...[
          spaceW4,
          Text(
            suffixTitle!,
            style: styleTitle ??
                TextStyle(
                  color: Colors.grey,
                ),
          ),
        ],
      ],
    );
  }
}
