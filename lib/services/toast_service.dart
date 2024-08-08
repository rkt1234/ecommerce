import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';

void getToast(BuildContext context, String message, Icon icon) {
  return DelightToastBar(
    autoDismiss: true,
    snackbarDuration: const Duration(milliseconds: 1000),
    position: DelightSnackbarPosition.top,
    builder: (context) => ToastCard(
      leading: icon,
      title: Text(
        message,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
      ),
    ),
  ).show(context);
}
