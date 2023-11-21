import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

class SnackbarStyle {
  const SnackbarStyle({
    this.bgColor,
    this.fgColor,
  });
  final Color? bgColor;
  final Color? fgColor;
}

enum SnackbarState {
  normal,
  error,
  warning,
  success;

  SnackbarStyle get style => switch (this) {
        normal => const SnackbarStyle(
            bgColor: Colors.blueAccent,
            fgColor: Colors.white,
          ),
        error => SnackbarStyle(
            bgColor: Colors.red[400],
            fgColor: Colors.white,
          ),
        warning => SnackbarStyle(
            bgColor: Colors.orange[400],
            fgColor: Colors.black,
          ),
        success => SnackbarStyle(
            bgColor: Colors.green[600],
            fgColor: Colors.white,
          ),
      };
}

@LazySingleton()
class MessengerService {
  final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
      GlobalKey();

  void showSnackBar({
    required String message,
    Widget? content,
    Widget? leading,
    Widget? trailing,
    String? actionText,
    double bottomPadding = 0,
    SnackbarState state = SnackbarState.normal,
    void Function()? actionCallback,
  }) {
    if (rootScaffoldMessengerKey.currentState != null) {
      rootScaffoldMessengerKey.currentState
        ?..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            content: Text(message),
          ),
        );
    }
  }

  void showPersistentSnackbar({
    required String message,
    required BuildContext context,
    Duration? duration,
    Widget? snackbar,
    Widget? leading,
    Widget? trailing,
    String? actionText,
    double bottomPadding = 20,
    SnackbarState state = SnackbarState.normal,
    void Function()? actionCallback,
  }) =>
      showFlash<dynamic>(
        context: context,
        duration: duration ?? const Duration(seconds: 4),
        builder: (_, controller) => FlashBar<dynamic>(
          controller: controller,
          backgroundColor: state.style.bgColor,
          behavior: FlashBehavior.floating,
          shadowColor: state.style.fgColor,
          margin: const EdgeInsets.all(20).copyWith(bottom: bottomPadding),
          dismissDirections: const [
            FlashDismissDirection.startToEnd,
          ],
          padding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          shouldIconPulse: false,
          primaryAction: actionCallback == null
              ? null
              : Padding(
                  padding: const EdgeInsets.only(
                    right: 12,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      controller.dismiss();
                      actionCallback();
                    },
                    child: Text(
                      actionText ?? 'Try Again',
                      style: TextStyle(
                        fontSize: 12,
                        color: state.style.fgColor,
                        fontWeight: FontWeight.w500,
                      ).copyWith(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
          content: Text(
            message,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: state.style.fgColor,
            ),
          ),
        ),
      );
}
