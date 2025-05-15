import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_styles.dart';

class DialogUtils {
  static void showLoading({
    required BuildContext context,
    required String message,
  }) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(color: AppColors.greyColor),
              Padding(
                padding: EdgeInsets.all(8),
                child: Text(message, style: AppStyles.medium16black),
              ),
            ],
          ),
        );
      },
    );
  }

  static void hideLoading(BuildContext context) {
    Navigator.pop(context);
  }

  static void showMessage({
    required BuildContext context,
    required String message,
    String? title,
    String? posActionName,
    Function? posAction,
    String? negActionName,
    Function? negAction,
  }) {
    List<Widget> actions = [];
    if (posActionName != null) {
      actions.add(
        TextButton(
          child: Text(posActionName, style: AppStyles.medium16black),
          onPressed: () {
            Navigator.pop(context);
            posAction?.call();

            /// =
            /// if(posAction != null){
            /// posAction.call();
            /// }
          },
        ),
      );
    }

    if (negActionName != null) {
      actions.add(
        TextButton(
          child: Text(negActionName, style: AppStyles.medium16black),
          onPressed: () {
            Navigator.pop(context);
            posAction?.call();
          },
        ),
      );
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(message, style: AppStyles.medium16black),
          title: Text(title ?? '', style: AppStyles.medium16black),
          actions: actions,
        );
      },
    );
  }
}
