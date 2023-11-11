import 'package:flash/flash.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';

abstract class NotificationProvider {
  success({required String message, int secondsToDisplay = 3});

  info({required String message, int secondsToDisplay = 3});

  error({required String message, int secondsToDisplay = 3});
}

class AppNotifications extends StatefulWidget {
  final Widget child;

  /// GlobalKey Reference to the root navigator.
  ///
  /// Because we want the notification provider as high as possible in the
  /// widget tree, it ends up above the root [Navigator], meaning we can't
  /// actually show a [Flashbar] using the current [BuildContext] (it does not
  /// contain a [Navigator] yet)
  ///
  /// Relies on this solution:
  /// https://github.com/flutter/flutter/issues/34105#issuecomment-841755280 to
  /// access the navigator at the time of showing the [Flashbar].
  final GlobalKey<NavigatorState> navigatorKey;

  /// Instance of [NotificationProvider] Sends notifications with [Flash] (via
  /// the `flash` package).
  const AppNotifications({
    Key? key,
    required this.child,
    required this.navigatorKey,
  }) : super(key: key);

  static NotificationProvider of(BuildContext context) =>
      context.findAncestorStateOfType<FlashNotificationProvider>()!;

  @override
  FlashNotificationProvider createState() => FlashNotificationProvider();
}

class FlashNotificationProvider extends State<AppNotifications>
    implements NotificationProvider {
  @override
  void initState() {
    super.initState();
  }

  @override
  info({required String message, int secondsToDisplay = 3}) {
    _show(
      MessageNotification(
        type: MessageType.info,
        message: message,
      ),
      secondsToDisplay,
    );
  }

  @override
  success({required String message, int secondsToDisplay = 3}) {
    _show(
      MessageNotification(
        type: MessageType.success,
        message: message,
      ),
      secondsToDisplay,
    );
  }

  @override
  error({required String message, int secondsToDisplay = 3}) {
    _show(
      MessageNotification(
        type: MessageType.error,
        message: message,
      ),
      secondsToDisplay,
    );
  }

  @override
  Widget build(BuildContext context) => widget.child;

  void _show(MessageNotification notification, int duration) {
    context.showFlash(
      duration: Duration(seconds: duration),
      builder: (context, controller) => FlashBar(
        controller: controller,
        behavior: FlashBehavior.floating,
        position: FlashPosition.top,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(24)),
          side: BorderSide(
            color: _getColor(notification.type),
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        margin: const EdgeInsets.all(32.0),
        clipBehavior: Clip.antiAlias,
        indicatorColor: _getColor(notification.type),
        content: Text(notification.message),
      ),
    );
  }

  Color _getColor(MessageType type) {
    switch (type) {
      case MessageType.success:
        return Colors.greenAccent.shade100;
      case MessageType.error:
        return Colors.red.shade800;
      case MessageType.info:
        return Colors.teal.shade200;
      default:
        return Colors.transparent;
    }
  }
}

class MessageNotification extends Notification {
  final String message;
  final MessageType type;

  MessageNotification({required this.type, required this.message});
}

enum MessageType {
  success,
  error,
  info,
}
