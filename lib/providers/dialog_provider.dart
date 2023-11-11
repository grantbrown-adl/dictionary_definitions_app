import 'package:flutter/material.dart';

class DialogProvider {
  final GlobalKey<NavigatorState> navigatorKey;

  DialogProvider({required this.navigatorKey});

  Future<bool> showConfirmation({
    required String title,
    required String content,
    required String confirmLabel,
    String cancelLabel = 'Cancel',
  }) {
    return showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 250),
          child: Text(content),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text(cancelLabel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text(confirmLabel),
          ),
        ],
      ),
    ).then((result) => result ?? false);
  }

  Future<bool?> showAlert({
    required String title,
    required String content,
    String confirmLabel = 'OK',
  }) {
    return showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 250),
          child: Text(content),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
  }
}
